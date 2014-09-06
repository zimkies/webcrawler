
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'pry'

# A class for parsing a url
class WebCrawler

  attr_accessor :pages, :url, :queue

  def self.crawl(url)
    crawler = self.new(url)
    crawler.queue << url
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
      p "url #{url}"
      page = Page.parse(url)
      @queue += page.internal_links.select do |link|
        @pages[link].nil?
      end
    end
  end
end

class Page

  attr_accessor :url, :raw_links, :html, :js, :css, :images

  def self.parse(url)
    page = self.new url
    page.parse
    page
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
      URI.join(page_uri, URI(l))
    end
  end

  def internal_links
    formatted_links.select { |link| link.host == URI(url).host }
  end

  def parse_links
    @raw_links = @html.css('a').map { |a| a['href'] }
  end

  def parse_css
    @css = @html.css('link').map { |link| link['href'] }
  end

  def parse_js
    @js = @html.css("script[type='text/javascript']").map { |script| script['src'] }
  end

  def parse_images
    @images = @html.css('img').map { |img| img['src'] }
  end

  def open_url
    begin
      open url
    rescue OpenURI::HTTPError => error
      ""
    end
  end
end
