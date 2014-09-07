webcrawler
==========

A ruby library for webcrawling

Install dependencies with:
```
bundle install
```

To run from the command line:
```
ruby ./lib/web_crawler.rb https://google.com
```

To run as a library:
```
require './lib/web_crawler'

crawler = WebCrawler.crawl("https://google.com")
puts crawler.to_s
```
