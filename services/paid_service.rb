class PaidService < Service
  def initialize(form)
    @form = form
  end

  def process
    m = "Pilih hutang yang sudah dibayar"

    inline_queries = get_inline_keyboards
    MessageHandler.send_inline_keyboard(@form.chat['id'], m, inline_queries)
  end

  private

  def get_inline_keyboards
    username = @form.from['username']
    debts = Debt.where(from: username)
    debts = debts.where(chat_id: @form.chat['id']) if @form.nonprivate?

    loans = Debt.where(to: username)
    loans = loans.where(chat_id: @form.chat['id']) if @form.nonprivate?

    debts = debts.map do |d|
      [{text: MessageFormater.send("debt_inline_format", d), callback_data: "paid:#{d.id}"}]
    end

    loans = loans.map do |l|
      [{text: MessageFormater.send("loan_inline_format", l), callback_data: "paid:#{l.id}"}]
    end

    debts.concat(loans)
  end
end
