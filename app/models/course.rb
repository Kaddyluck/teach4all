class Course < ApplicationRecord
  searchkick word_middle: [:name]

  enum status: [ :editing, :validated, :published ]
  enum visibility: [ :for_all_users, :for_organization_users, :for_selected_users ]

  belongs_to :user
  belongs_to :organization, optional: true
  has_many :pages, dependent: :destroy, index_errors: true
  belongs_to :certificate_template, optional: true
  has_many :certificates, dependent: :destroy
  has_many :passing_courses
  has_many :ratings, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :selected_course_users, dependent: :destroy

  has_attached_file :avatar, styles: { medium: "150x150>", thumb: "70x70>" }, default_url: "/images/:style/course.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  accepts_nested_attributes_for :pages

  validates :name, :pages, presence: true, if: :validate?
  validates_associated :pages, if: :validate?
  validate :visibility_options, if: :validate?

  scope :from_users, -> { where(organization: nil) }
  scope :from_organizations, -> { where.not(organization: nil) }
  scope :passing, -> { joins(:passing_courses).where(passing_courses: { status: :passing }).or(passing_courses: { status: :need_restart })}
  scope :reviewing, -> { joins(:passing_courses).where(passing_courses: { status: :reviewing })}
  scope :passed, -> { joins(:passing_courses).where(passing_courses: { status: [:finished_successfully, :finished_unsuccessfully] })}
  scope :finished_successfully, -> { joins(:passing_courses).where(passing_courses: { status: :finished_successfully })}
  scope :finished_unsuccessfully, -> { joins(:passing_courses).where(passing_courses: { status: :finished_unsuccessfully })}

  after_update :restart_passing_courses

  def self.not_touched_by_user(user)
    where.not(id: user.touched_course_ids)
  end

  def self.search_for(term, options={})
    return self.all.order(:created_at) if term.blank?
    results = search term, fields: options[:fields],
                           match: :word_middle
    results.records
  rescue Faraday::ConnectionFailed
    db_search(term, fields: options[:fields])
  end

  def self.db_search(term, options={})
    return self.all if term.blank?
    fields = options[:fields] ? options[:fields] : %i[name]
    condition = fields.map { |field| "courses.#{field} ILIKE :term" }.join(' OR ')
    words = term.split
    words.reduce(self) do |relation, word|
      relation.where(condition, { term: db_searching_term(word) })
    end
  end

  def first_error_text
    messages = errors.full_messages.map do |message|
      message.gsub(/Pages\[\d\] base/, '')
             .gsub(/Pages\[\d\]/, 'Each page ')
    end
    messages.first
  end

  def validate?
    validated? || published?
  end

  def visibility_options
    if for_organization_users? && organization_id.nil?
      errors.add(:base, "Cannot set visibility only for organization users when organization not present.")
    elsif for_selected_users? && selected_course_users.empty?
      errors.add(:base, "You should select at least one user.")
    end
  end

  def recalculate_rating
    all_ratings = ratings.all
    average_rating = (all_ratings.reduce(0) {|sum, r| sum + r.value}).to_f / all_ratings.length
    self.update_columns(average_rating: average_rating)
  end

  def recalculate_statistics
    passing_courses_count = passing_courses.count
    finished_successfully_count = passing_courses.where(status: :finished_successfully).count
    finished_unsuccessfully_count = passing_courses.where(status: :finished_unsuccessfully).count
    if organization
      passing_by_organization_users_percent = (passing_courses.where(["user_id IN (?)", organization.users.pluck(:id)]).count.to_f / organization.users.count * 100).round
      update_columns(passing_by_organization_users_percent: passing_by_organization_users_percent)
    end
    update_columns(passing_courses_count: passing_courses_count,
                   finished_successfully_count: finished_successfully_count,
                   finished_unsuccessfully_count: finished_unsuccessfully_count)
  end

  def progress_for(user)
    passing_courses.find_by(user: user).progress
  end

  def restart_passing_courses
    passing_courses.where(status: :passing).update(status: :need_restart)
  end

  private

  def self.db_searching_term(term, word_part=:middle)
    case word_part
    when :start
      "#{term}%"
    when :end
      "%#{term}"
    else
      "%#{term}%"
    end
  end
end
