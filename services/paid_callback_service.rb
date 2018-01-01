require_relative 'service'

class PaidCallbackService < Service
  def initialize(form)
    @form = form
    @query = form.callback_query
  end

  def process
    assign_params
    return unless validate_params

    if paid!
      m = "Status #{MessageFormater.inline_format(@d, @query['from']['username'])} telah di-update menjadi *dibayar*"
      MessageHandler.edit_message(@query['message']['message_id'], @query['message']['chat']['id'], m)
    end
  rescue => e
    Log.warn e
    raise InternalError.new("Terjadi kesalahan pada sistem, tetap tenang tetap semangat.")
  end

  private

  def assign_params
    _, @debt_id = @query['data'].split(':')
    @d = Debt.find_by(id: @debt_id)
  end

  def validate_params
    @d && (@d.from == @form.from_username || @d.to == @form.from_username)
  end

  def paid!
    @d.state = 'paid'
    @d.paid_at = Time.now
    @d.paid_by = @form.from_username
    @d.save!
  end
end
