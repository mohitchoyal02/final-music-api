class Playlist < ApplicationRecord
  belongs_to :listner
  has_and_belongs_to_many :songs

  validates :title, presence: true, uniqueness: true
end
