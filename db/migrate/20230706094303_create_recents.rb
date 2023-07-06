class CreateRecents < ActiveRecord::Migration[7.0]
  def change
    create_table :recents do |t|

      t.timestamps
    end
  end
end
