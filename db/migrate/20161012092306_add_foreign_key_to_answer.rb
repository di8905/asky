class AddForeignKeyToAnswer < ActiveRecord::Migration
  def change
    add_foreign_key :answers, :questions
  end
end
