class Listner < User
	validates :username, uniqueness: {scope: :type}
end
