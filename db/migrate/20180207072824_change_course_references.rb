class ChangeCourseReferences < ActiveRecord::Migration[5.1]
  def change
    add_reference :courses, :organization, null:true, index:true
  end
end
