require 'sinatra'   # gem 'sinatra'
require 'line/bot'  # gem 'line-bot-api'

def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_secret = ENV["7b3c329f7d657490e9e059f5b319d978"]
    config.channel_token = ENV["qXH57zpR/MSsj5vzAdmYoIC9onhS1RkbQly4eQ63Rm/gmi6EAyHJOg/E4pBYE2s8iYNIta7OCb6Qm62mcA7XxPizm7nQrQ70rwQpC/+meaZLiw2rUBKseaVOktkEKNXaB3gSlhOMLkxbb/0vxeXClgdB04t89/1O/w1cDnyilFU="]
  }
end

post '/callback' do
  body = request.body.read

  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request' end
  end

  events = client.parse_events_from(body)

  events.each { |event|
    case event
    when Line::Bot::Event::Message
      case event.type
      when Line::Bot::Event::MessageType::Text
        message = {
          type: 'text',
          text: event.message['text']
        }
        client.reply_message(event['replyToken'], message)
      end
    end
  }

  "OK"
end
