class AddTemplateToCourse < ActiveRecord::Migration[5.1]
  def change
    add_reference :courses, :certificate_template, foreign_key: true, index:true
  end
end
