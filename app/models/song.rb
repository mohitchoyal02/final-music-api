class Song < ApplicationRecord

  has_one_attached :file

  has_many :recents

  belongs_to :artist
  belongs_to :album, optional: true
  
  has_and_belongs_to_many :playlists

  before_create :is_attached

  validates :title, presence:true, uniqueness: true
  # validates :genre_type, presence: true,
  validates :genre, presence:true, inclusion: {in: %w(hip-hop rock pop)}

  private
  def is_attached
    file.attached?
  end
end
