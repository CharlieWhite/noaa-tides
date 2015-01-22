module Noaa
	module Tides
		class NoaaStationObservation
			include HTTParty
  		base_uri Noaa::BASE_URL
  		#debug_output
			
			def initialize station_id, timestamp, options = {}
				@station_id = station_id
				@timestamp = timestamp

				@params = {
					station: @station_id,
					units: (options[:units] || "metric"),
					time_zone: (options[:time_zone] || "gmt"),
					application: (options[:application] || "Waves"),
					format: (options[:format] || "json")
				}
			end

			def get_air_temperature
				params = default_params.merge(product: "air_temperature")
				get(params)
			end 

			def get_water_temperature
				params = default_params.merge(product: "water_temperature")
				get(params)
			end 

			def get_wind
				params = default_params.merge(product: "wind")
				get(params)
			end 

			def get_water_level
				params = default_params.merge(product: "water_level", datum: "MTL")
				get(params)
			end

			def get params
				result = self.class.get("/api/datagetter", {query: params}).parsed_response
				parsed_result = JSON.parse(result)
				puts parsed_result
				if parsed_result && !parsed_result["error"]
					closest_to_time(@timestamp, parsed_result["data"])
				else
					nil
				end
			end

			def default_params
				@params.merge(date_params(@timestamp))
			end

			def self.base_url
	      Noaa::BASE_URL
	    end

	    def date_params datetime
	    	if (datetime.to_date == Date.today)
	    			{date: "today"}
	    	else
	    		{begin_date: datetime.beginning_of_day.strftime("%m/%d/%Y %H:%M"), end_date: datetime.end_of_day.strftime("%m/%d/%Y %H:%M")}
	    	end
	    end


	    def closest_to_time(timestamp, t_array)
			  t_array.min{ |a,b|  (timestamp-DateTime.parse(a["t"])).abs <=> (timestamp-DateTime.parse(b["t"])).abs  }
			end
		end
	end
end


#http://tidesandcurrents.noaa.gov/api/datagetter?begin_date=20130101 10:00&end_date=20130101 10:24&station=8454000&product=water_level&datum=mllw&units=metric&time_zone=gmt&application=web_services&format=xml 
