class Listner < User
	has_many :recents
	validates :username, uniqueness: {scope: :type}
end
