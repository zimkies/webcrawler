require 'minitest/autorun'
require 'minitest/spec'
require_relative "../lib/web_crawler"

describe WebCrawler do

  describe '#parse' do
    let(:url) { 'http://google.com' }

    it "returns a crawler" do
      WebCrawler.crawl(url).must_be_instance_of WebCrawler
    end
  end
end

describe Page do

  describe '#parse' do
    let(:url) { 'http://google.com' }

    it "returns a Page" do
      Page.parse(url).must_be_instance_of Page
    end
  end
end
