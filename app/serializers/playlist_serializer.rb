class PlaylistSerializer < ActiveModel::Serializer
  attributes :id, :title, :songs

  has_many :songs
  class SongSerializer < ActiveModel::Serializer
  attributes :id, :title, :genre, :artist_name, :url

  def url
    url = object.file.url
  end

  def artist_name
    artist_name = object.artist.full_name
  end
end

end
