class Listner < User
  has_many :recents
  has_many :playlists
  validates :username, uniqueness: {scope: :type}
end
