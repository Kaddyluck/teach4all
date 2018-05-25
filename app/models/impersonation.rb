class Impersonation < ApplicationRecord
  belongs_to :impersonator, class_name: User.name
  belongs_to :target_user, class_name: User.name

  scope :not_ended, -> { where(ended_at: nil) }

  def self.db_search(term, fields: nil, word_part: :middle)
    return self.all if term.blank?
    fields =
      if fields
        fields.map { |field| searching_fields_map[field] }
      else
        searching_fields_map.values
      end
    condition = fields.map { |field| "#{field} ILIKE :term"}.join(' OR ')
    words = term.split
    words.reduce(self.joins(:impersonator, :target_user)) do |relation, word|
      relation.where(condition, { term: db_searching_term(word, :start) })
    end
  end

  private

  def self.searching_fields_map
    {
      'target_user_nickname' => 'target_users_impersonations.nickname',
      'impersonator_nickname' => 'impersonators_impersonations.nickname'
    }
  end

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
end
