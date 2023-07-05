class CreateSongs < ActiveRecord::Migration[7.0]
  def change
    create_table :songs do |t|
      t.binary :file
      t.string :title
      t.string :genre

      t.timestamps
    end
  end
end
