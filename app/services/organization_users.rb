class OrganizationUsers
  include Enumerable

  SEARCHABLE_FIELDS = %i[email nickname first_name last_name]
  ORDERABLE_FIELDS = %i[email nickname first_name last_name]

  attr_accessor :organization, :users

  def initialize(organization=Organization.new)
    @organization = organization
    @users = @organization.users.includes(:organizations, :roles) + invited_users
  end

  def each
    @users.map { |user| yield(user) }
  end

  def sort
    result = self.class.new(@organization)
    result.users = super
    result
  end

  def select
    result = self.class.new(@organization)
    result.users = super
    result
  end

  def order(field, direction)
    if direction.to_sym == :desc
      self.sort do |first, second|
        if first.public_send(field).present? && second.public_send(field).present?
          second.public_send(field).upcase <=> first.public_send(field).upcase
        else
          second.public_send(field).present? ? -1 : 1
        end
      end
    else
      self.sort do |first, second|
        if first.public_send(field).present? && second.public_send(field).present?
          first.public_send(field).upcase <=> second.public_send(field).upcase
        else
          first.public_send(field).present? ? -1 : 1
        end
      end
    end
  end

  def search(term, options={})
    return self if term.blank?
    fields = options[:fields] ? options[:fields].map(&:to_sym) : []
    searching_fields = fields.any? ? (fields & SEARCHABLE_FIELDS) : SEARCHABLE_FIELDS
    self.select do |user|
      searching_fields.reduce(false) do |sum, field|
        attribute = user.public_send(field).to_s
        if attribute
          sum || attribute.match?(/\A#{term}/i)
        else
          false
        end
      end
    end
  end

  def where(options={})
    case options[:registered].to_s
    when 'true'
      self.select { |user| user.persisted? }
    when 'false'
      self.select { |user| user.new_record? }
    else
      self
    end
  end

  private

  def invited_users
    @organization.invitations.map { |invitation| User.new(email: invitation.user_email) }
  end
end
