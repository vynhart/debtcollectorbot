class AddChatId < ActiveRecord::Migration[5.1]
  def change
    add_column(:debts, :chat_id, :text)
    add_index(:debts, [:chat_id, :state])
  end
end
