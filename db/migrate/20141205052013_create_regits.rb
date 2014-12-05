class CreateRegits < ActiveRecord::Migration
  def change
    create_table :regists do |t|
      t.string :email
    end
  end
end
