class CreateDebt < ActiveRecord::Migration[5.1]
  def change
    create_table :debts do |t|
      t.text :from
      t.text :to
      t.integer :amount
      t.string :desc
      t.text :state
      t.text :created_by
      t.timestamps
    end
    add_index(:debts, [:from, :state])
    add_index(:debts, [:to, :state])
  end
end
