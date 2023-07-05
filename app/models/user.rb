class User < ApplicationRecord
	include BCrypt

	validates :username, presence:true, uniqueness: true
	validates :password, presence:true
	validates :email, presence: true
	validates :full_name, presence: true

	def password= (new_password)
		password = Password.create(new_password)
		self.password_digest =password
	end

	def password
		@password = Password.new(self.password_digest)
	end
end
	