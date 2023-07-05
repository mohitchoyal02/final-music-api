class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :type
      t.string :username
      t.string :password_digest
      t.string :full_name
      t.string :email
      t.string :genre_type

      t.timestamps
    end
  end
end
