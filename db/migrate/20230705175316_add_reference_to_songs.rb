class AddReferenceToSongs < ActiveRecord::Migration[7.0]
  def change
    add_reference :songs, :artist
  end
end
