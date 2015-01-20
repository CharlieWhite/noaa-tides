module Noaa
	module Tides
		require 'nokogiri'

  	class NoaaStation

  		def scrape(url)
	      h = {}
	      xpath = "//h3"

	      doc = Nokogiri::HTML(HTTParty.get(url))  

	      h[:url] = url
	      # Title, Station Id and Description
	      header = doc.xpath(xpath).first.text
	      title, station_id = header.split(/ - /)
	      title = title.rstrip
	      h[:title] = title.strip
	      station_id = station_id.sub(/Station ID: ?/i, '')
	      station_id = /[A-Z0-9]+/.match(station_id).to_s rescue nil
	      h[:station_id] = station_id
	      
	      # # Lat and Lng
	      table = doc.css("#info ~ table")
	      lat = convert_degrees_to_decimal(table.xpath("//tr[td/text()[contains(., 'Latitude')]]/td").last.text)
	      h[:lat] = lat
	      lng = convert_degrees_to_decimal(table.xpath("//tr[td/text()[contains(., 'Longitude')]]/td").last.text)
	      h[:lng] = lng
	     	
				h
	    end

	    def convert_degrees_to_decimal(degree_string)
	    	degree_string.gsub(/(\d+)° (\d+\.\d{1,2})' (\w)/) do
	    		 decimal = $1.to_f + $2.to_f/60
	    		 decimal = decimal * -1 if ($3 == 'S' or $3 == 'W')
	    		 decimal
				end
	    end


  		def normalize_url(url)
	      base_url = Noaa::BASE_URL
	      /^#{base_url}/.match(url) ? url : [Noaa::BASE_URL, url].join('/')
	    end

	    def logger
	      Rails.logger if defined? Rails.logger
	    end
  	end
	end
end