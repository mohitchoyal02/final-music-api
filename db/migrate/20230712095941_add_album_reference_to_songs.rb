class AddAlbumReferenceToSongs < ActiveRecord::Migration[7.0]
  def change
    add_reference :songs, :album
  end
end
