class Song < ApplicationRecord
	has_one_attached :file
	belongs_to :artist
	has_many :recents
	belongs_to :album , optional: true

	before_create :is_attached

	validates :title, presence:true, uniqueness: true
	validates :genre, presence:true

	private
	def is_attached
		self.file.attached?
	end
end
