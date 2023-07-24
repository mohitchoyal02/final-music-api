class UserSerializer < ActiveModel::Serializer
  attributes :username, :full_name, :email, :genre_type
end
