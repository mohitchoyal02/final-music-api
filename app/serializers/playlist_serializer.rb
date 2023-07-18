class PlaylistSerializer < ActiveModel::Serializer
  attributes :id, :title, :songs

  has_many :songs

  # def songs
  #   object.songs
  # end


  # attribute :songs do |params|
  #   SongSerializer.new(params.songs)
  # end  
  # def songs
  #   ActiveModel::SerializableResource.new(object.songs,  each_serializer: SongSerializer)
  # end

end
