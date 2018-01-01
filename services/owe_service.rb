require_relative 'service'
require_relative 'inline_owe_service'

class OweService < Service
  def initialize(form)
    @form = form
  end

  def process
    if command_only?
      'ok' # TODO
    else
      InlineOweService.new(@form).process
    end
  end

  private

  def command_only?
    @form.text.size == @form.command.size
  end
end
