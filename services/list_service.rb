require_relative 'service'

class ListService < Service
  def initialize(form)
    @form = form
  end

  def process
    m = generate_message

    MessageHandler.send_message(@form.chat['id'], m)
  end

  private

  def generate_message
    @form.nonprivate? ? in_group_message(@form.chat['id']) : private_message(@form.from['username'])
  end

  def private_message(username)
    debts, loans = [Debt.where(from: username), Debt.where(to: username)]

    m = "Daftar hutang anda:"
    m << "-" if debts.empty?
    debts.each{ |d| m << "\n#{MessageFormater.debt_message_format(d)}" }
    m << "\n\nDaftar piutang anda:"
    m << "-" if loans.empty?
    loans.each{ |l| m << "\n#{MessageFormater.loan_message_format(l)}" }
    m
  end

  def in_group_message(chat_id)
    debts = Debt.where(chat_id: chat_id)

    return "Daftar hutang kosong! yay!" if debts.empty?
    m = "Daftar hutang yang belum dibayar:"
    debts.each{ |d| m << "\n#{MessageFormater.in_group_format(d)}" }
    m << "\n\njangan lupa dibayar ya :wink:" unless debts.empty?
    m
  end
end
