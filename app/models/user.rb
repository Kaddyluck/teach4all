class User < ApplicationRecord
  searchkick word_middle: [:email, :nickname, :first_name, :last_name]

  devise :database_authenticatable, :registerable, :confirmable, :recoverable,
         :rememberable, :trackable, :validatable, :lockable, :timeoutable

  has_many :roles, dependent: :destroy
  has_many :organizations, through: :roles
  has_many :requests, dependent: :destroy
  has_many :sent_messages, class_name: Message.name, foreign_key: :sender_id
  has_many :received_messages, class_name: Message.name, foreign_key: :receiver_id
  has_many :receipts, foreign_key: :owner_id
  has_many :impersonations_as_target, class_name: Impersonation.name,
                                      foreign_key: :target_user_id
  has_many :impersonations_as_impersonator, class_name: Impersonation.name,
                                            foreign_key: :impersonator_id
  has_many :courses, dependent: :destroy
  has_many :certificate_templates, as: :owner, dependent: :destroy
  has_many :certificates, dependent: :destroy
  has_many :passing_courses
  has_many :passing_courses, dependent: :destroy
  has_many :touched_courses, through: :passing_courses, source: :course
  has_many :review_requests
  has_many :ratings
  has_many :favorites, dependent: :destroy
  has_many :favorite_courses, through: :favorites, source: :course
  has_many :selected_course_users, dependent: :destroy

  has_attached_file :avatar, styles: { medium: "150x150>", thumb: "70x70>" }, default_url: "/images/:style/user.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  after_create :accept_invitations

  validates :nickname, presence: true,
                       uniqueness: { case_sensitive: true, allow_blank: true }
  validates :first_name, presence: true
  validates :last_name, presence: true

  def self.search_for(term, limit: nil, exclude: User.new)
    search term, fields: [:email, :nickname, :first_name, :last_name],
                 match: :word_middle,
                 misspellings: false,
                 where: { id: { not: exclude.id.to_i } },
                 limit: limit
  rescue Faraday::ConnectionFailed
    db_search(term).where.not(id: exclude.id).limit(limit)
  end

  def self.db_search(term, fields: nil, word_part: :middle)
    return self.all if term.blank?
    fields = fields ? fields : %i[email nickname first_name last_name]
    condition = fields.map { |field| "#{field} ILIKE :term" }.join(' OR ')
    words = term.split
    words.reduce(self) do |relation, word|
      relation.where(condition, { term: db_searching_term(word, :start) })
    end
  end

  def admin?
    roles.pluck(:role).include?('admin')
  end

  def org_admin?
    roles.pluck(:role).include?('org_admin')
  end
  
  def current_courses
    self.touched_courses.where(passing_courses: { status: [:passing, :reviewing, :need_restart] })
  end

  def passed_courses
    self.touched_courses.where(passing_courses: { status: [:finished_successfully, :finished_unsuccessfully] })
  end

  def interlocutors
    User.joins(receipts: :message)
        .where('(messages.sender_id = :id OR messages.receiver_id = :id) AND users.id != :id', {id: self.id})
        .order('receipts.created_at DESC')
        .uniq
  end

  private

  def self.db_searching_term(term, word_part)
    case word_part
    when :start
      "#{term}%"
    when :end
      "%#{term}"
    else
      "%#{term}%"
    end
  end

  def accept_invitations
    invitations = Invitation.where(user_email: self.email)
    invitations.each do |i|
      Organization.find(i.organization_id).roles.create(user_id: self.id)
      i.destroy
    end
  end

end
