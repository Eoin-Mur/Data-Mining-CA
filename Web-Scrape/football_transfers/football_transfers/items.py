# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# http://doc.scrapy.org/en/latest/topics/items.html

import scrapy


class FootballTransfersItem(scrapy.Item):
    # define the fields for your item here like:
    # name = scrapy.Field()
    pass

class TransferItem(scrapy.Item):
		season = scrapy.Field()
		year = scrapy.Field()
		rowId = scrapy.Field()
		transferTypeId = scrapy.Field()
		transferType = scrapy.Field()
		owner = scrapy.Field()
		player = scrapy.Field()
		team = scrapy.Field()
		text = scrapy.Field()


