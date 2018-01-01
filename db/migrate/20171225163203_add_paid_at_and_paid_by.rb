class AddPaidAtAndPaidBy < ActiveRecord::Migration[5.1]
  def change
    add_column :debts, :paid_at, :datetime
    add_column :debts, :paid_by, :text
  end
end
