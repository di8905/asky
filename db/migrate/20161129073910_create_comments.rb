class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.string :body
      t.references :commentable, polymorphic: true, index: true
    end
  end
end
