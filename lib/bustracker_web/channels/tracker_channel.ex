defmodule BustrackerWeb.TrackerChannel do
  use BustrackerWeb, :channel
  alias Bustracker.Track

  def join("tracker:"<>name, payload, socket) do
    if authorized?(payload) do
      track = Track.new()
      socket = socket
      |> assign(:track, track)
      |> assign(:name, name)
      {:ok, %{"join" => name, "track" => Track.client_view(track)}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end


  def handle_in("nearestStops", %{"longitude" => lo, "latitude" => la}, socket) do
    track = Track.nearestStops(socket.assigns[:track], lo, la)
    socket = assign(socket, :track, track)
    {:reply, {:ok, %{"track" => Track.client_view(track)}}, socket}
  end

  def handle_in("predictions", %{"stopId" => stopId}, socket) do
    track = Track.predictions(socket.assigns[:track], stopId)
    socket = assign(socket, :track, track)
    {:reply, {:ok, %{"track" => Track.client_view(track)}}, socket}
  end

  def handle_in("setStopId", %{"stopId" => stopId}, socket) do
    track = Track.setStopId(socket.assigns[:track], stopId)
    socket = assign(socket, :track, track)
    {:reply, {:ok, %{"track" => Track.client_view(track)}}, socket}
  end

  def handle_in("allStopsForRoute", %{"routeid" => routeid, "tripid" => tripid}, socket) do
    track = Track.allStopsForRoute(socket.assigns[:track], routeid, tripid)
    socket = assign(socket, :track, track)
    {:reply, {:ok, %{"track" => Track.client_view(track)}}, socket}
  end
  def handle_in("updateSelRoute", %{"newSelRoute" => newSelRoute}, socket) do
    track = Track.updateSelRoute(socket.assigns[:track], newSelRoute)
    socket = assign(socket, :track, track)
    {:reply, {:ok, %{"track" => Track.client_view(track)}}, socket}
  end

  def handle_in("busUpdate", %{"tripid" => tripid}, socket) do
    track = Track.busUpdate(socket.assigns[:track], tripid)
    socket = assign(socket, :track, track)
    {:reply, {:ok, %{"track" => Track.client_view(track)}}, socket}
  end
  def handle_in("busUpdate1", %{"tripid" => tripid}, socket) do
    track = Track.busUpdate1(socket.assigns[:track], tripid)
    socket = assign(socket, :track, track)
    {:reply, {:ok, %{"track" => Track.client_view(track)}}, socket}
  end

  def handle_in("hideBusModal", %{"busUpdateBool" => busUpdateBool}, socket) do
    track = Track.hideBusModal(socket.assigns[:track], busUpdateBool)
    socket = assign(socket, :track, track)
    {:reply, {:ok, %{"track" => Track.client_view(track)}}, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (tracker:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
