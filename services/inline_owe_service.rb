require_relative 'base_inline_owe_service'

class InlineOweService < BaseInlineOweService
  def initialize(form)
    @form = form
  end

  def process
    assign_params
    validate

    if save_record
      m = "Hutang kepada #{@username} sebanyak Rp#{@amount} telah dicatat."
      m << "\nDeskripsi: #{@desc}" if @desc
      MessageHandler.send_message(@form.chat['id'], m)
    end
  rescue => e
    Log.warn e
    raise
  end

  private

  def save_record
    d = Debt.new(
      from: @form.from['username'],
      to: @username,
      amount: @amount,
      desc: @desc,
      state: 'unpaid',
      created_by: @form.from['username'],
      chat_id: @form.chat['id']
    )
    d.save!
  end
end
