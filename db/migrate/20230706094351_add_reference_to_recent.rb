class AddReferenceToRecent < ActiveRecord::Migration[7.0]
  def change
    add_reference :recents, :listner
    add_reference :recents, :song
  end
end
