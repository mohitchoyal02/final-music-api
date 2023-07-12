class Artist < User
  has_many :songs, dependent: :destroy
  has_many :albums
  validates :username, uniqueness: {scope: :type}
end
