class AddAnserBelongsToQuestion < ActiveRecord::Migration
  def change
    add_belongs_to :answers, :question
    add_index :answers, :question_id
  end
end
