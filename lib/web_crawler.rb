
require 'rubygems'
require 'nokogiri'
require 'open-uri'

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
    return unless url = @queue.pop
    page = Page.parse(url)
    @queue += page.links.reject { |link| @pages[link].nil? }
  end
end

class Page

  attr_accessor :url, :links, :html, :js, :css, :images

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
  end

  def parse_links
    @links = @html.css('a').map { link['href'] }
  end

  def parse_css
    @css = @html.css('link').map { link['href'] }
  end

  def parse_js
    @js = @html.css('script').map { link['src'] }
  end

  def parse_images
    @images = @html.css('img').map { link['src'] }
  end

  def open_url
    open url
  end
end
