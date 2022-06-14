---
title: "Web Scraper - Valorant Data Analysis"
date: 2022-06-13
draft: true
ShowToC: true

cover:
  image: img/val/val_logo.jpg
  alt: 'Valorant logo'

tags: ['scrapy','json','webscraping','programming']
categories: ['data']

---

# Summary

I was originally looking for a Valorant API to analyse some of my own match data, however Riot games do not hand out personal API keys for this game.

I figured I could scrape some of my own match data which is publically available on the web client side.

Though the data is fairly limited due to built in limitations of the Riot Valorant API. The website only pulls 30 matches worth of data.

Still it was worth learning about the web-scraping process and adding to the toolkit.

# Web Scraper

I decided to use a module called "scrapy" as my web-scrapping tool and the website being interrogated was [https://dak.gg/valorant/en/profile/FilPill-EUW](https://dak.gg/valorant/en/profile/FilPill-EUW)

Figured I didn't need to emulate any "human-like" browser activity. Initally when I started, I tried to parse out the HTML classes within the div's however it did not work. Despite the data being kept inside the HTML tags,I could not access them with my scraper.

When I simulated the webscraper opening the website, it did not return any data at all. Just an empty HTML template of a website. Soonafter, I realised that javascript is being employed to load the data into the front-end dynamically.

I changed my approach eventually. After inspecting the web elements in the network tab (more specifically XHR/Fetch) of my browser, I found an https request which returns JSON data.

This is the final iteration of the spider I developed to scrape my match data:

```[zsh]
import scrapy
import json

class PlayerState(scrapy.Spider):
    name = 'playerState'
    start_urls =  ['https://dak.gg/valorant/en/profile/FilPill-EUW']
    headers = {
   "accept":" application/json, text/plain, */*"
    }

    def parse(self, response):
        url = 'https://val.dakgg.io/api/v1/accounts/JPnyLxsiavseiYbL8xtmWSuFRHdupX43u_hVynD5YScr2_Y32Wt2v5K-NvxvfDRWTL67AHdVSmoLTg/matches'

        request = scrapy.Request(url,
                                 callback = self.parse_api,
                                 headers=self.headers)
        yield request

    def parse_api(self,response):
        raw_data = response.body
        data = json.loads(raw_data)
        yield {
               'matches':data['matches']
        }
```
The spider script is suprisingly short, however it returns all my match data from the page.

# Data Analysis

Since we are only pulling out 30 matches, we are fairly limited in visualising our data. In the future I may attempt to scrape out bigger pools of data of the player base to perform some big data analysis. Will have to figure out an elegant way to do it.

For now I made some basic analysis with my jupyter notebook, some of which is derivative of the scraped data:

{{< img720 src = "/img/val/kill_death.png" >}}
{{< img720 src = "/img/val/map_wins.png" >}}
