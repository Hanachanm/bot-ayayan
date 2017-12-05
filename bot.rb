require 'dotenv/load'
require 'slack-ruby-client'

Slack.configure do |conf|
  conf.token = ENV['API_TOKEN']
end

client = Slack::RealTime::Client.new

client.on :hello do
  puts "Successfully connected, welcome '#{client.self.name}' to the '#{client.team.name}' team at https://#{client.team.domain}.slack.com."
end

used_money = 0        #使ったお金の合計
all_money = 50000     #予算
balance = 50000      #残っている予算
now_money = 0         #登録した金額
deficit = 0
coments = ["なんとか耐えたネ。。来月も一緒に頑張ろうね！","すごくいい感じ＾＾","いっぱい余ったね〜！すごいロト"]

client.on :message do |data|
  case data.text
  when 'こんにちは' then
    client.message channel: data['channel'], text: "<@#{data.user}>さん、こんにちは"
  when '何時？' then
    client.message channel: data['channel'], text: "ただ今の時刻は#{Time.now}です"
  when /(.+)代、(\d+)円/ then
    client.message channel: data['channel'], text: "#{Time.now}\s#{$1}代として、#{$2}円を登録しました！"
    now_money = $2.to_i
    used_money = used_money + now_money
    balance = all_money - used_money
  when 'あと何円使える？' then
    client.message channel: data['channel'], text: "#{balance}円ダヨ"
  when /(\d)月もありがとう/ then
    client.message channel: data['channel'], text: "今月使ったのは、#{used_money}円だよ！"
    if balance < 0 
      deficit = balance * -1
      client.message channel: data['channel'], text: "#{deficit}円の赤字だよ！！><\n来月は節約しようね。。。"
    elsif balance >= 0 && balance <= 999
      client.message channel: data['channel'], text: "残ったのは、#{balance}円です！#{coments[0]}"
    elsif balance >= 1000 && balance <= 9999
      client.message channel: data['channel'], text: "残ったのは、#{balance}円です！#{coments[1]}"
    elsif balance >= 10000
      client.message channel: data['channel'], text: "残ったのは、#{balance}円です！#{coments[2]}"
    end
  end

end

client.start!



