class AddReferenceToAlbums < ActiveRecord::Migration[7.0]
  def up
    #add_reference :songs, :artist
    add_reference :albums, :song
  end
  def down
    remove_reference :songs, :artist
    remove_reference :albums, :song
  end
end
