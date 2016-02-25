# coding: utf-8

require 'open-uri'
require 'bundler'
Bundler.require

def get_directs(url, direct_destinies)
  hash = {}
  open(url) do |f|
    html = f.read.encode('utf-8', 'shift_jis')
    doc = Nokogiri::HTML(html)
    times = doc.css('td.lowBg06>span.l')
    times.each do |e|
      hour = e.text
      minutes = e.parent.css('~.lowBgFFF td')
      minutes += e.parent.css('~.lowBg12 td')
      destinations = minutes.css('.s').map {|d| d.text }
      min_vals = minutes.css('.ll').map {|d| d.text }
      set = [destinations, min_vals].transpose
      hash[hour] = set
    end
  end

  directs = hash.map do |k, v| 
    dests = v.select do |e| 
      direct_destinies.include? e[0]
    end
    [k, dests]
  end

  Hash[directs]
end


kaeri_url = 'http://ekikara.jp/newdata/ekijikoku/1310061/up1_13105091.htm'
kaeri_d = %w{指 清 石 所 保 飯}
iki_url = 'http://ekikara.jp/newdata/ekijikoku/1304011/up1_13120041.htm'
iki_d = %w{木 豊}

time = ARGV[0]
puts "#{time}時台の直通電車は"
puts "行き"
puts get_directs(iki_url, iki_d)[time].join(' ')
puts "帰り"
puts get_directs(kaeri_url, kaeri_d)[time].join(' ')
