class CreateAnnualincomes < ActiveRecord::Migration
  def change
    create_table :annualincomes do |t|
      
      t.integer :year
      t.decimal :amount

      t.timestamps
    end
  end
end
