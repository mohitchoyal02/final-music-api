class Song < ApplicationRecord
  has_one_attached :file
  belongs_to :artist
  has_many :recents
  belongs_to :playlist, optional: true
  belongs_to :album, optional: true
  has_and_belongs_to_many :playlists

  before_create :is_attached

  validates :title, presence:true, uniqueness: true
  validates :genre, presence:true

  private
  def is_attached
    file.attached?
  end
end
