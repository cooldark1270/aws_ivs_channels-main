class CreateStreamKeys < ActiveRecord::Migration[7.1]
  def change
    create_table :stream_keys do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :arn
      t.string :channel_arn
      t.string :value

      t.timestamps
    end
  end
end
