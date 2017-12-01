require 'dotenv/load'
require 'slack-ruby-client'

Slack.configure do |conf|
  conf.token = ENV['API_TOKEN']
end

client = Slack::RealTime::Client.new

client.on :hello do
  puts "Successfully connected, welcome '#{client.self.name}' to the '#{client.team.name}' team at https://#{client.team.domain}.slack.com."
end

$usedMoney = 0        #使ったお金の合計
$allMoney = 50000     #予算
$balance = 50000      #残っている予算
$nowMoney = 0         #登録した金額

client.on :message do |data|
  case data.text
  when 'こんにちは' then
    client.message channel: data['channel'], text: "<@#{data.user}>さん、こんにちは"
  when '何時？' then
    client.message channel: data['channel'], text: "ただ今の時刻は#{Time.now}です"
  when /(.+)代、(\d+)円/ then
    client.message channel: data['channel'], text: "#{Time.now}\s#{$1}代として、#{$2}円を登録しました！"
    $nowMoney = $2.to_i
    $usedMoney = $usedMoney + $nowMoney
    $balance = $allMoney - $usedMoney
  when 'あと何円使える？' then
    client.message channel: data['channel'], text: "#{$balance}円ダヨ"
  end

end

client.start!



