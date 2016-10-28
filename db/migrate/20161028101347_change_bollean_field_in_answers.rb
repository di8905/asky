class ChangeBolleanFieldInAnswers < ActiveRecord::Migration[5.0]
  def change
    change_column :answers, :best, :boolean, default: false, null: false
  end
end
