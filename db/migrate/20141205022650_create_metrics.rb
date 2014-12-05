class CreateMetrics < ActiveRecord::Migration
  def change
    create_table :metrics do |t|
      t.string :case
      t.string :block
      t.string :pattern
      t.integer :count
    end
  end
end
