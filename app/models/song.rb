class Song < ApplicationRecord
	has_one_attached :file
	belongs_to :user, optional: true

	before_create :is_attached

	validates :title, presence:true, uniqueness: true
	validates :genre, presence:true

	private
	def is_attached
		self.file.attached?
	end
end
