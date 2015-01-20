module Noaa
	module Tides
		require 'nokogiri'

  	class NoaaStationList
  		def url
	      "#{base_url}/stations.html"
	    end

	    def base_url
	      Noaa::BASE_URL
	    end

  		def get(options = {})
	      default_options = {
	        limit: 0,
	        id: nil,
	        verbose: true,
	        current: true
	      }
	      options = default_options.merge options

	      stats = {
	        stations: [],
	        station_count: 0,
	        errors: [],
	        error_count: 0
	      }
	      @doc = doc
	      @station_ids = station_ids doc
	      

	      # Probably only relevant for testing
	      @station_ids = @station_ids[0..options[:limit]-1] if options[:limit] > 0
	      @station_ids = [ url_by_id(options[:id]) ] if options[:id]

	      @station_ids.each do |station_id|
	        puts "scraping --> #{station_id}" if options[:verbose]
	        h = scrape_station(url_by_id(station_id))
	        puts h.inspect
	        #h = url_by_id(station_id)
	        stats[:stations].push h
	        stats[:station_count] += 1
	      end

	      stats
	    end

	    def url_by_id(id)
	      "#{base_url}/stationhome.html?id=#{id}"
	    end

	    def doc
	      doc = Nokogiri::HTML(HTTParty.get(url))  
	    end

	private
	    def station_ids(doc)
	      doc.css('.station').map{|element| element['id'][1..-1]}
	    end

	    def scrape_station(url)
	      NoaaStation.new.scrape(url)
	    end
		end
	end
end