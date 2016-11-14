class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.integer :vote
      t.integer :user_id
      t.references :voteable, polymorphic: true, index: true
    end
  end
end
