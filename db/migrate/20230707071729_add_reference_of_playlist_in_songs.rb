class AddReferenceOfPlaylistInSongs < ActiveRecord::Migration[7.0]
  def up
        add_reference :songs, :playlist
  end
  def down
         remove_reference :songs, :playlist
  end
end
