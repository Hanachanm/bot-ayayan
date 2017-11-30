require 'dotenv/load'
require 'slack-ruby-client'

Slack.configure do |conf|
  conf.token = ENV['API_TOKEN']
end

client = Slack::RealTime::Client.new

client.on :hello do
  puts "Successfully connected, welcome '#{client.self.name}' to the '#{client.team.name}' team at https://#{client.team.domain}.slack.com."
end

client.on :message do |data|
  case data.text
  when 'こんにちは' then
    client.message channel: data['channel'], text: "<@#{data.user}>さん、こんにちは"
  when '何時？' then
    client.message channel: data['channel'], text: "ただ今の時刻は#{Time.now}です"
  end

  if /(.+)代、(\d+)円/ =~  data.text then
    client.message channel: data['channel'], text: "#{Time.now}\s#{$1}代として、#{$2}円を登録しました！"
  end

end

client.start!



