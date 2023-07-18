class AlbumSerializer < ActiveModel::Serializer
  attributes :id, :title, :songs

  has_many :songs  

  # has_many :songs
  # def songs
  #   ActiveModel::SerializableResource.new(object.songs,  each_serializer: SongSerializer)
  # end
end
