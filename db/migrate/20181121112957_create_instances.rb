class CreateInstances < ActiveRecord::Migration[5.2]
  def change
    create_table :instances do |t|
      t.string :uuid
      t.belongs_to :session

      t.timestamps
    end
  end
end
