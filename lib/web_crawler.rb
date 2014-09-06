
#
# Things to do:
#
# Speed up with threads
# Option for ignoring hash addresses
# Option for ignoring query syntax
# Option for ignoring http vs https
# Option to slow down requests as a courtesy
# Fix it for google - it seems to have some problems
#
#
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'pry'

# A class for parsing a url
class WebCrawler

  attr_accessor :pages, :url, :queue

  def to_s
    p "URL structure for: #{url}"
    @pages.each do |page|
      p "#{page}"
    end
    nil
  end

  def self.crawl(url)
    crawler = self.new(url)
    crawler.queue << URI(url)
    crawler.crawl
    crawler
  end

  def initialize(url)
    @url = url
    @queue = []
    @pages = {}
  end

  def crawl
    while url = @queue.shift
      next if @pages[url.to_s]
      page = Page.parse(url.to_s)
      p page
      @pages[url.to_s] = page
      @queue += page.internal_links.select do |link|
        @pages[link.to_s].nil?
      end
    end
  end
end

class Page

  attr_accessor :url, :raw_links, :html, :js, :css, :images

  def to_s
    puts "Page: #{url}"
    if internal_links.length > 0
      puts "\t links:"
      internal_links.each { |l| puts "\t\t#{l.to_s}"}
    end
    if images.length > 0
      puts "\t images:"
      images.each { |l| puts "\t\t#{l.to_s}"}
    end
    if css.length > 0
      puts "\t css:"
      css.each { |l| puts "\t\t#{l.to_s}"}
    end
    if js.length > 0
      puts "\t js:"
      js.each { |l| puts "\t\t#{l.to_s}"}
    end
  end

  def self.parse(url)
    self.new(url).tap { |page| page.parse }
  end

  def initialize(url)
    @url = url
    @js = []
    @css = []
    @images = []
    @links = []
  end

  def parse
    @html = Nokogiri::HTML(open_url)
    parse_links
    parse_css
    parse_js
    parse_images
  end

  def formatted_links
    page_uri = URI(url)
    @raw_links.map do |l|
      URI.join(page_uri, URI(l || ""))
    end
  end

  def internal_links
    formatted_links.select { |link| link.host == URI(url).host }
  end

  def parse_links
    @raw_links = @html.css('a')
      .map { |a| a['href'] }
      .reject{ |l| l.nil? || l.empty? }
  end

  def parse_css
    @css = @html.css('link')
      .map { |link| link['href'] }
      .reject { |url| url.nil? || url.empty? }
  end

  def parse_js
    @js = @html.css("script[type='text/javascript']")
      .map { |script| script['src'] }
      .reject { |url| url.nil? || url.empty? }
  end

  def parse_images
    @images = @html.css('img')
      .map { |img| img['src'] }
      .reject { |url| url.nil? || url.empty? }
  end

  def open_url
    begin
      open url
    rescue OpenURI::HTTPError => error
      ""
    end
  end
end
