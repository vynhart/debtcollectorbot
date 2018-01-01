require 'json'
require_relative 'start_service'
require_relative 'owe_service'
require_relative 'lend_service'

class TelegramService < Service
  def initialize(payload)
    @payload = JSON.parse(payload)
    @form = MessageForm.new(@payload)
  end

  def process
    Thread.new do
      begin
        service = get_service
        service.process if service
      rescue Service::MessageError, Service::InternalError => e
        Log.warn(e)
        MessageHandler.send_message(@form.chat['id'], e.message)
      rescue => e
        Log.warn(e)
      end
    end
    MessageHandler.send_chat_action(@form.chat['id']) if @form.command? || @form.callback?
    'ok'
  end

  private

  def get_service
    if @form.command?
      get_command_service
    elsif @form.callback?
      get_callback_service
    end
  end

  def get_command_service
    case @form.command
    when '/start', '/help'
      StartService.new(@form)
    when '/owe'
      OweService.new(@form)
    when '/lend'
      LendService.new(@form)
    when '/list'
      ListService.new(@form)
    when '/paid'
      PaidService.new(@form)
    when '/paidlist'
      PaidListService.new(@form)
    end
  end

  def get_callback_service
    case @form.callback_command
    when 'paid'
      PaidCallbackService.new(@form)
    end
  end

  class MessageForm
    def initialize(payload)
      @payload = payload
      @m = payload['message']
      @c = payload['callback_query']
    end

    def message; @m; end
    def callback_query; @c; end

    def message?
      !!(@m)
    end

    def callback?
      !!(@c)
    end

    def command?
      !!command
    end

    def command
      return nil unless entities
      e = entities.find{ |x| x['type'] == 'bot_command' }
      e && text[e['offset']..(e['length'] - 1)].split('@').first
    end

    def chat
      (@m && @m['chat']) || (@c && @c['message']['chat'])
    end

    def text
      @m && @m['text']
    end

    def from
      (@m && @m['from']) || (@c && @c['from'])
    end

    def entities
      @m && @m['entities']
    end

    def callback_command
      @c['data'].split(':').first
    end

    def from_id
      from['id']
    end

    def from_username
      from['username'].tr('@', '')
    end

    def nonprivate?
      chat && chat['type'] != 'private'
    end
  end
end
