import scrapy

from football_transfers.items import TransferItem

class TransferSpider(scrapy.Spider):
	name = "transfers"
	allowed_domains = ["footballdatabase.eu"]
	start_urls = [
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/transfer.html"
	]

	def parse(self, response):
	#	filename = 'transfer.html'
	#	with open(filename, 'wb') as f:
	#		f.write(response.body)

		
		#/table/tbody/tr/td/table/tbody/tr/td/table/tbody/tr/td/table width="486"
		#print response.xpath('//table[@width="486" and @align="center" and @cellpadding="0" and @cellspacing="0" and @border="0"]/tr/td[@class="transarrfd"]/table/tr/td/*')
		for arrSel in response.xpath('//table[@width="486" and @align="center" and @cellpadding="0" and @cellspacing="0" and @border="0"]/tr/td[@class="transarrfd"]/table/tr/td'):
			#print "here"
			#print sel
			#print sel.xpath('td/text()')
			#print sel.xpath('a/@href')
			##print sel
			#print sel.xpath('a/b/text()').extract()
			#print sel.xpath('a/text()').extract()
			#print sel.xpath('text()').extract()
			item = TransferItem()
			item['transferType'] = "arrival"
			item['owner'] = arrSel.xpath('td/a[@class="link_1"]/text()')
			item['player'] = arrSel.xpath('a/b/text()').extract()
			item['team'] = arrSel.xpath('a/text()').extract()
			item['text'] = arrSel.xpath('text()').extract()
			yield item

		for depSel in response.xpath('//table[@width="486" and @align="center" and @cellpadding="0" and @cellspacing="0" and @border="0"]/tr/td[@class="transdepfd"]/table/tr/td'):
			item = TransferItem()
			item['transferType'] = "departure"
			item['owner'] = depSel.xpath('td/a[@class="link_1"]/text()')
			item['player'] = depSel.xpath('a/b/text()').extract()
			item['team'] = depSel.xpath('a/text()').extract()
			item['text'] = depSel.xpath('text()').extract()
			yield item