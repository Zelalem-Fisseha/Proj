class CreateVisits < ActiveRecord::Migration[8.0]
  def change
    create_table :visits do |t|
      t.string :ip_address
      t.string :path
      t.datetime :visited_at

      t.timestamps
    end
  end
end
