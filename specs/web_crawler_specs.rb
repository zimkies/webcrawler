require 'minitest/autorun'
require 'minitest/spec'
require_relative "../lib/web_crawler"

describe WebCrawler do

  describe '#parse' do
    let(:url) { 'https://joingrouper.com' }

    it "returns a crawler" do
      WebCrawler.crawl(url).must_be_instance_of WebCrawler
    end

    it "caches some pages" do
      WebCrawler.crawl(url).pages.must_equal []
    end
  end
end

describe Page do

  describe '#parse' do
    let(:url) { 'http://nokogiri.org' }

    it "returns a Page" do
      Page.parse(url).must_be_instance_of Page
    end

    it "stores css" do
      Page.parse(url).css.first.must_match /\.css/
    end

    it "stores js" do
      Page.parse(url).js.first.must_match /\.js/
    end

    it "stores images" do
      Page.parse(url).images.first.must_match /\.png/
    end

    it "internal links has no external links" do
      Page.parse(url).internal_links.first.must_match /^\/$/
    end
  end
end
