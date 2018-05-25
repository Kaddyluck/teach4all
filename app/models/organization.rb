class Organization < ApplicationRecord
  searchkick word_start: [:name]

  validates :name, presence: true, uniqueness: { case_sensitive: true }
  has_many :roles, dependent: :destroy
  has_many :users, through: :roles
  has_many :invitations, dependent: :destroy
  has_many :requests, dependent: :destroy
  has_many :impersonations_as_target, through: :users
  has_many :certificate_templates, as: :owner, dependent: :destroy
  has_many :courses
  has_attached_file :avatar, styles: { medium: "150x150>", thumb: "70x70>" }, default_url: "/images/:style/organization.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  def self.search_for(term, options={})
    return self.all if term.blank?
    results = search term, fields: options[:fields],
                           match: :word_start
    results.records
  rescue Faraday::ConnectionFailed
    db_search(term, fields: options[:fields], word_part: options[:word_part])
  end

  def self.db_search(term, options={})
    return self.all if term.blank?
    fields = options[:fields] ? options[:fields] : %i[name]
    condition = fields.map { |field| "courses.#{field} ILIKE :term" }.join(' OR ')
    words = term.split
    words.reduce(self) do |relation, word|
      relation.where(condition, { term: db_searching_term(word, word_part: options[:word_part]) })
    end
  end

  def admins
    users.where(roles: { role: 'org_admin' })
  end

  def admin_list
    admins.pluck(:nickname).join(', ')
  end

  def user_list
    users.pluck(:nickname).join(', ')
  end

  def org_admin?(user_id)
    admins.pluck(:id).include?(user_id)
  end

  def user?(user_id)
    users.pluck(:id).include?(user_id)
  end

  def impersonations
    impersonations_as_target.where(impersonator: self.admins)
  end

  def self.chart(organization)
    chart = { passing: 0, finished_successfully: 0, finished_unsuccessfully: 0 }
    Organization.find(organization.id).courses.find_each do |course|
      course.passing_courses.where(["user_id IN (?)", organization.users.pluck(:id)]).find_each do |passing_course|
        if %i[passing finished_successfully finished_unsuccessfully].include? passing_course.status.to_sym
          chart[passing_course.status.to_sym] += 1
        end
      end
    end
    chart
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
