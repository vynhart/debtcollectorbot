require_relative 'service'
require_relative 'inline_lend_service'

class LendService < Service
  def initialize(form)
    @form = form
  end

  def process
    if command_only?
      'ok' # TODO
    else
      InlineLendService.new(@form).process
    end
  end

  private

  def command_only?
    @form.text.size == @form.command.size
  end
end
