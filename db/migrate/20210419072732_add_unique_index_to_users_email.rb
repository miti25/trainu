class AddUniqueIndexToUsersEmail < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :email, unique: true, name: 'email'
  end
end
