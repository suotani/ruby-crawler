require 'open-uri'
require 'robotex' # gem install robotex
require 'nokogiri' # gem install nokogiri
require 'erb'

rubyinstaller_archives_url = "https://rubyinstaller.org/downloads/archives/"

if Robotex.new.allowed?(rubyinstaller_archives_url)
  charset = nil
  html = open(rubyinstaller_archives_url) do |file|
    charset = file.charset
    page = file.read
  end

  page = Nokogiri::HTML.parse(html, nil, charset)
  result = page.search('.rubyinstallerexe').search(".downloadlink").to_a

  #puts result.map{|r| [r["href"], r.text]}
  list = result.map{|r| [r["href"], r.text]}
  File.open("./index.html", "w") do |f|
    content = ERB.new(File.read("./index.html.erb")).result(binding)
    f.puts(content)
  end
else
  puts "No Allow Scraping"
end

