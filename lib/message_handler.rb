require 'faraday'
require 'json'
require 'logger'

class MessageHandler
  API = Faraday.new('https://api.telegram.org/')
  TOKEN = ENV['TOKEN']
  LOG = Logger.new('log/api_telegram.log', 10, 1_048_576)

  def self.send_message(chat_id, text, opts = {})
    body = {
      chat_id: chat_id,
      parse_mode: 'Markdown',
      text: text
    }
    body[:reply_markup] = opts[:reply_markup].to_json if opts[:reply_markup]
    r = API.post do |req|
      req.url "/bot#{TOKEN}/sendMessage"
      req.body = body
    end
    r = JSON.parse(r.body)

    unless r['ok']
      LOG.warn("Request Fail \n#{r}")
    end
  rescue Faraday::ConnectionFailed => e
    LOG.warn e
    retry
  rescue => e
    LOG.error(e)
  end

  def self.edit_message(message_id, chat_id, text, opts = {})
    body = {
      message_id: message_id,
      chat_id: chat_id,
      parse_mode: 'Markdown',
      text: text
    }
    body[:reply_markup] = opts[:reply_markup].to_json if opts[:reply_markup]
    r = API.post do |req|
      req.url "/bot#{TOKEN}/editMessageText"
      req.body = body
    end
    r = JSON.parse(r.body)

    unless r['ok']
      LOG.warn("Request Fail \n#{r}")
    end
  rescue Faraday::ConnectionFailed => e
    LOG.warn e
    retry
  rescue => e
    LOG.error(e)
  end

  def self.send_chat_action(chat_id)
    API.post do |req|
      req.url "/bot#{TOKEN}/sendChatAction"
      req.body = { chat_id: chat_id, action: 'typing' }
    end
  rescue Faraday::ConnectionFailed => e
    LOG.warn e
    retry
  rescue => e
    LOG.warn e
  end

  def self.send_inline_keyboard(chat_id, text, inline_keyboard = nil)
    unless inline_keyboard.first.is_a?(Array)
      inline_keyboard = [ inline_keyboard ]
    end

    reply_markup = {
      inline_keyboard: inline_keyboard
    }
    send_message(chat_id, text, reply_markup: reply_markup)
  end

  def self.send_reply_keyboard(chat_id, text, reply_keyboard = nil)
    # only for development testing purpose
    # START
    reply_keyboard ||= [
      ['one', 'two', 'three', 'four']
    ]
    # END

    reply_markup = {
      keyboard: reply_keyboard,
      resize_keyboard: true,
      one_time_keyboard: true
    }
    send_message(chat_id, text, reply_markup: reply_markup)
  end

  def self.remove_reply_keyboard
  end
end
