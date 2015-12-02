import scrapy

from football_transfers.items import TransferItem


class TransferSpider(scrapy.Spider):
	name = "transfers"
	allowed_domains = ["footballdatabase.eu"]
	start_urls = [
		#premierShip

		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=1lieu=Angleterresaison=2005.html",
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=1lieu=Angleterresaison=2006.html",
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=1lieu=Angleterresaison=2007.html",
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=1lieu=Angleterresaison=2008.html",
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=1lieu=Angleterresaison=2009.html",
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=1lieu=Angleterresaison=2010.html",
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=1lieu=Angleterresaison=2011.html",
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=1lieu=Angleterresaison=2012.html",
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=1lieu=Angleterresaison=2013.html",
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=llieu=Angleterresaison=2014.html",
		#championship
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=2lieu=Angleterresaison=2005.html",
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=2lieu=Angleterresaison=2006.html",
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=2lieu=Angleterresaison=2007.html",
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=2lieu=Angleterresaison=2008.html",
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=2lieu=Angleterresaison=2009.html",
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=2lieu=Angleterresaison=2010.html",
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=2lieu=Angleterresaison=2011.html",
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=2lieu=Angleterresaison=2012.html",
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=2lieu=Angleterresaison=2013.html",
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=2lieu=Angleterresaison=2014.html",
		#league 1
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=3lieu=Angleterresaison=2005.html",
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=3lieu=Angleterresaison=2006.html",
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=3lieu=Angleterresaison=2007.html",
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=3lieu=Angleterresaison=2008.html",
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=3lieu=Angleterresaison=2009.html",
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=3lieu=Angleterresaison=2010.html",
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=3lieu=Angleterresaison=2011.html",
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=3lieu=Angleterresaison=2012.html",
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=3lieu=Angleterresaison=2013.html",
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=3lieu=Angleterresaison=2014.html",
		#league 2
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=4lieu=Angleterresaison=2005.html",
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=4lieu=Angleterresaison=2006.html",
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=4lieu=Angleterresaison=2007.html",
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=4lieu=Angleterresaison=2008.html",
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=4lieu=Angleterresaison=2009.html",
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=4lieu=Angleterresaison=2010.html",
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=4lieu=Angleterresaison=2011.html",
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=4lieu=Angleterresaison=2012.html",
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=4lieu=Angleterresaison=2013.html",
		"file:///C:/Users/eoinm_000/Documents/Programing/Python/football_transfers/scraped_files/transfertstab.phpcompetition=4lieu=Angleterresaison=2014.html"


	]

	def parse(self, response):	
		row = 1
		rowType = 1	
		for sel in response.xpath('//table[@width="486" and @align="center" and @cellpadding="0" and @cellspacing="0" and @border="0"]/tr[not(@*)]'):

			##print sel
			if rowType == 3:
				rowType = 1

			url = response.url.split("/")[-1]
			season = url[29:-31]
			year = url[52:-5]
			for innersel in sel.xpath('td[@class="transarrfd"]/table/tr/td'):
				#print "here"
				item = TransferItem()
				item['rowId'] = row
				item['transferTypeId'] = rowType
				item['season'] = season
				item['year'] = year
				item['transferType'] = "arrival"
				item['owner'] = sel.xpath('td[@rowspan="4"]/a/b/text()').extract()
				item['player'] = innersel.xpath('a/b/text()').extract()
				item['team'] = innersel.xpath('a[contains(@href,"football.club")]/*/text()').extract()
				if not item['team']:
					item['team'] = innersel.xpath('a[contains(@href,"football.club")]/text()').extract()
				item['text'] = innersel.xpath('text()').extract()
				yield item
				
			#print sel.xpath('td[@class="transdepfd"]/table/tr/td/a')

			for innersel in sel.xpath('td[@class="transdepfd"]/table/tr/td'):
				#print "here"
				item = TransferItem()
				item['rowId'] = row
				item['transferTypeId'] = rowType
				item['season'] = season
				item['year'] = year
				item['transferType'] = "departure"
				item['owner'] = sel.xpath('td[@rowspan="4"]/a/b/text()').extract()
				item['player'] = innersel.xpath('a/b/text()').extract()
				item['team'] = innersel.xpath('a[contains(@href,"football.club")]/*/text()').extract()
				if not item['team']:
					item['team'] = innersel.xpath('a[contains(@href,"football.club")]/text()').extract()
				item['text'] = innersel.xpath('text()').extract()
				yield item

			rowType += 1
			if rowType == 3:
				row += 1
#because footballdatabase.eu are a bunch of pricks and only allow you to veiw 5 pages before logging in
#get all the pages and work on them of line.... pain in the arse!!!!
class TransferHTMLSpider(scrapy.Spider):
	name = "transfer_html"
	allowed_domains = ["footballdatabase.eu"]
	start_urls = [
		# most i could get before the redirect kicked in was 11. scrape 11 pages a day?
		# could connect through a vpn every 11 pages, new ip no redirect?

		#ones commented out already scraped...
		#Preimer league. 
		#"http://www.footballdatabase.eu/transfertstab.php?competition=1&lieu=Angleterre&saison=2014/2015",
		#"http://www.footballdatabase.eu/transfertstab.php?competition=1&lieu=Angleterre&saison=2013/2014",
		#"http://www.footballdatabase.eu/transfertstab.php?competition=1&lieu=Angleterre&saison=2012/2013",
		#"http://www.footballdatabase.eu/transfertstab.php?competition=1&lieu=Angleterre&saison=2011/2012",
		#"http://www.footballdatabase.eu/transfertstab.php?competition=1&lieu=Angleterre&saison=2010/2011",
		#"http://www.footballdatabase.eu/transfertstab.php?competition=1&lieu=Angleterre&saison=2009/2010",
		#"http://www.footballdatabase.eu/transfertstab.php?competition=1&lieu=Angleterre&saison=2008/2009",
		#"http://www.footballdatabase.eu/transfertstab.php?competition=1&lieu=Angleterre&saison=2007/2008",
		#"http://www.footballdatabase.eu/transfertstab.php?competition=1&lieu=Angleterre&saison=2006/2007",
		#"http://www.footballdatabase.eu/transfertstab.php?competition=1&lieu=Angleterre&saison=2005/2006",
		
		#championship..
		
		#"http://www.footballdatabase.eu/transfertstab.php?competition=2&lieu=Angleterre&saison=2014/2015",
		#"http://www.footballdatabase.eu/transfertstab.php?competition=2&lieu=Angleterre&saison=2013/2014",
		#"http://www.footballdatabase.eu/transfertstab.php?competition=2&lieu=Angleterre&saison=2012/2013",
		#"http://www.footballdatabase.eu/transfertstab.php?competition=2&lieu=Angleterre&saison=2011/2012",
		#"http://www.footballdatabase.eu/transfertstab.php?competition=2&lieu=Angleterre&saison=2010/2011",
		#"http://www.footballdatabase.eu/transfertstab.php?competition=2&lieu=Angleterre&saison=2009/2010",
		#"http://www.footballdatabase.eu/transfertstab.php?competition=2&lieu=Angleterre&saison=2008/2009",
		#"http://www.footballdatabase.eu/transfertstab.php?competition=2&lieu=Angleterre&saison=2007/2008",
		#"http://www.footballdatabase.eu/transfertstab.php?competition=2&lieu=Angleterre&saison=2006/2007",
		#"http://www.footballdatabase.eu/transfertstab.php?competition=2&lieu=Angleterre&saison=2005/2006",
		
		#league 1..
		
		#"http://www.footballdatabase.eu/transfertstab.php?competition=3&lieu=Angleterre&saison=2014/2015",
		#"http://www.footballdatabase.eu/transfertstab.php?competition=3&lieu=Angleterre&saison=2013/2014",
		#"http://www.footballdatabase.eu/transfertstab.php?competition=3&lieu=Angleterre&saison=2012/2013",
		#"http://www.footballdatabase.eu/transfertstab.php?competition=3&lieu=Angleterre&saison=2011/2012",
		#"http://www.footballdatabase.eu/transfertstab.php?competition=3&lieu=Angleterre&saison=2010/2011",
		#"http://www.footballdatabase.eu/transfertstab.php?competition=3&lieu=Angleterre&saison=2009/2010",
		#"http://www.footballdatabase.eu/transfertstab.php?competition=3&lieu=Angleterre&saison=2008/2009",
		#"http://www.footballdatabase.eu/transfertstab.php?competition=3&lieu=Angleterre&saison=2007/2008",
		#"http://www.footballdatabase.eu/transfertstab.php?competition=3&lieu=Angleterre&saison=2006/2007",
		#"http://www.footballdatabase.eu/transfertstab.php?competition=3&lieu=Angleterre&saison=2005/2006"
		
		#league 2..
		
		#"http://www.footballdatabase.eu/transfertstab.php?competition=4&lieu=Angleterre&saison=2014/2015",
		#"http://www.footballdatabase.eu/transfertstab.php?competition=4&lieu=Angleterre&saison=2013/2014",
		#"http://www.footballdatabase.eu/transfertstab.php?competition=4&lieu=Angleterre&saison=2012/2013",
		#"http://www.footballdatabase.eu/transfertstab.php?competition=4&lieu=Angleterre&saison=2011/2012",
		#"http://www.footballdatabase.eu/transfertstab.php?competition=4&lieu=Angleterre&saison=2010/2011"
		"http://www.footballdatabase.eu/transfertstab.php?competition=4&lieu=Angleterre&saison=2009/2010",
		"http://www.footballdatabase.eu/transfertstab.php?competition=4&lieu=Angleterre&saison=2008/2009",
		"http://www.footballdatabase.eu/transfertstab.php?competition=4&lieu=Angleterre&saison=2007/2008",
		"http://www.footballdatabase.eu/transfertstab.php?competition=4&lieu=Angleterre&saison=2006/2007",
		"http://www.footballdatabase.eu/transfertstab.php?competition=4&lieu=Angleterre&saison=2005/2006"
	]

	def parse(self, response):
		filename = response.url.split("/")[-2] + ".html"
		#print filename
		clean_filename = filename.replace('?','')
		#print clean_filename
		clean_filename2 = clean_filename.replace('&','')
		#print clean_filename2
		with open(clean_filename2, 'wb') as f:
			f.write(response.body)