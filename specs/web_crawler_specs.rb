require 'minitest/autorun'
require 'minitest/spec'
require_relative "../lib/web_crawler"

describe WebCrawler do

  describe '#parse' do
    let(:url) { 'https://joingrouper.com' }
    let(:parsed_crawler) { WebCrawler.crawl(url) }

    it "caches pages" do
      parsed_crawler.must_be_instance_of WebCrawler
      parsed_crawler.pages.length.must_be :>,  1
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

    it "internal links have no external links" do
      Page.parse(url).internal_links.each do |l|
        l.must_be_instance_of URI::HTTP
        l.host.must_match URI(url).host
      end
    end
  end
end

