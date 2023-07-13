class RecentSerializer < ActiveModel::Serializer
  attributes :id, :song

  has_one :song
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
