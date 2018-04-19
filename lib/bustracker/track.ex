defmodule Bustracker.Track do
  alias Bustracker.Api_Key
  def new do
    %{
      nearestStops: [],
      predictions: [],
      stopId: "",
      selRoute: false,
      selRouteStops: [],
      busUpdate: [],
      busUpdateBool: false,
      selTrip: "",
    }
  end

  def client_view(track) do
    track
  end

  def nearestStops(track, lo, la) do
    xs = nearestStops_list(lo, la)
    Map.merge(track, %{nearestStops: xs})
  end

  def nearestStops_list(lo, la) do
    resp = HTTPoison.get!("https://api-v3.mbta.com/stops?filter[latitude]="<>la<>"&filter[longitude]="<>lo<>"&filter[radius]=0.005&filter[route_type]=3&api_key="<>Api_Key.apikey)
    data = Poison.decode!(resp.body)
    data["data"]
  end

  def setStopId(track, id) do
    Map.merge(track, %{stopId: id})
  end

  def predictions(track, id) do
    xs = predictions_list(id)
    Map.merge(track, %{predictions: xs})
  end

  def predictions_list(id) do
    resp = HTTPoison.get!("https://api-v3.mbta.com/predictions?include=schedule&sort=arrival_time&filter[stop]="<>id<>"&api_key="<>Api_Key.apikey)
    data = Poison.decode!(resp.body)
    data
  end

#get all stops of routes
  def allStopsForRoute(track, routeid, tripid) do
    xs = allStopsForRoute_list(routeid, tripid)
    Map.merge(track, %{selRouteStops: xs, selRoute: true})
  end

  def allStopsForRoute_list(routeid, tripid) do
    IO.puts(tripid)
    # resp = HTTPoison.get!("https://api-v3.mbta.com/stops?filter[route_type]=3&filter[route]="<>id<>"&api_key="<>Api_Key.apikey)
    resp = HTTPoison.get!("https://api-v3.mbta.com/schedules?sort=stop_sequence&include=stop&"<>"&filter[trip]="<>tripid<>"&api_key="<>Api_Key.apikey)
    data = Poison.decode!(resp.body)
    data
  end

  def updateSelRoute(track, newSelRoute) do
    Map.merge(track, %{selRoute: newSelRoute})
  end

  def hideBusModal(track, busUpdateBool) do
    Map.merge(track, %{busUpdateBool: busUpdateBool})
  end

  # get vehicle update
  #get all stops of routes
    def busUpdate(track, tripid) do
      xs = busUpdate_list(tripid)
      Map.merge(track, %{busUpdate: xs, busUpdateBool: true, selTrip: tripid})
    end

    def busUpdate1(track, tripid) do
      xs = busUpdate_list(tripid)
      Map.merge(track, %{busUpdate: xs})
    end

    def busUpdate_list(tripid) do
      IO.puts(tripid)
      resp = HTTPoison.get!("https://api-v3.mbta.com/vehicles?include=stop&filter[trip]="<>tripid<>"&api_key="<>Api_Key.apikey)
      data = Poison.decode!(resp.body)
      data
    end
end



# Stop -> Predictions -> Route ->Routes details(All Stops of Route with Route Id)
