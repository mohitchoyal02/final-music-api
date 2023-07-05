class Artist < User
	validates :username, uniqueness: {scope: :type}
end
