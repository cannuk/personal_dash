require 'bart/station'


#station abbreviations you want departure estimates for.
#You can also specify direction and platform according to the BART api
#(http://api.bart.gov/docs/etd/etd.aspx)
#ex: {abbr: "mlbr", platform: 1}
#    {abbr: "embr", direction: "south"}
depart_station = {abbr: "embr", direction: "south"}
#Filter the list of destination estimates from the depart stations to the following stations
destination_stations = ["mlbr", "sfia"]

UPDATE = '5m' #This is how often we query the BART API. Don't be a jerk and do it too often...
UPDATE_DISPLAY = '1m' #This is how often we update the display on the dashboard.

dest_estimates = Hash.new
last_updated = Time.now

#This queries the BART API
SCHEDULER.every UPDATE, :first_in => 0 do |job|


  #create the station object
  station = Bart::Station.new(abbr: depart_station[:abbr])
  #load the departures passing any extra parameters
  departures = station.load_departures(depart_station.select {|k,v| ["platform", "direction"].include?(k) })
  #filter the departures to our destinations
  dest_estimates = departures.select { |d| destination_stations.include?(d.destination.abbr) }

  last_updated = Time.now
  p dest_estimates
  true
end

#This sends the data to the front end. It accounts for time since update
SCHEDULER.every UPDATE_DISPLAY, :first_in => 0 do |job|
  final = Array.new
  dest_estimates.each do |dest|
    destination = Hash.new
    destination[:abbr] = dest.destination.abbr
    destination[:station_name] = dest.destination.name
    destination[:estimates] = Array.new
    dest.estimates.each do |e|
      #get the difference since the last update in seconds
      minutes_since = ((Time.now - last_updated)/60).round
      #only add to the estimates if the train hasn't departed yet
      if minutes_since <= e.minutes
        destination[:estimates] << {:minutes => (e.minutes - minutes_since), :train_length => e.length}
      end
    end
    final << destination
  end
  p final
  send_event('bart', destinations: final)
end