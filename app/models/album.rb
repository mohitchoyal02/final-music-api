class Album < ApplicationRecord
  belongs_to :artist
  has_many :songs
  validates :title,presence: true,uniqueness: true
end
