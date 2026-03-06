class AddFollowLookupIndex < ActiveRecord::Migration[7.1]
  def change
    add_index :follows, [:follower_id, :followee_id, :status]
  end
end
