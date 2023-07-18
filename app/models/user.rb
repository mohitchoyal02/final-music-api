class User < ApplicationRecord
  include BCrypt

  validates :type, presence: true, inclusion: {in: %w(Listner Artist)}
  validates :username, presence:true, format: {with: /\A\w{4,16}\z/, message: "username is not valid, only alphabetic characters accepted"} 
  validates :password, presence:true
  validates :email, presence: true, format: {with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i, message: "Email address not valid"}
  validates :full_name, presence: true
  validates :genre_type, presence: true, inclusion: {in: %w(hip-hop rock pop)}

  has_many :songs

  def password= (new_password)
    password = Password.create(new_password)
    self.password_digest = password
  end

  def password
    @password = Password.new(self.password_digest)
  end

end
  