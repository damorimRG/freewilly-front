class CreateVisits < ActiveRecord::Migration[5.2]
  def change
    create_table :visits do |t|
      t.string :url
      t.string :session
      t.timestamps
    end
  end
end
