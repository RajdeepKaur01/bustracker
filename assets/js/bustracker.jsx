import "phoenix_html"
import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';
import Modal from './modal';
import BusModal from './busModal';

export default function run_demo(root,channel,lat,lon) {
  ReactDOM.render(<Board channel={channel} lat={lat} lon={lon} />, root);
}

class Board extends React.Component {
  constructor(props) {
    super(props);
    this.channel=props.channel;
    this.latitude=props.lat;
    this.longitude=props.lon;
    this.state = {
      nearestStops: [],
      predictions: [],
      stopId: "",
      selRoute: false,
      selRouteStops: [],
      busUpdate: [],
      busUpdateBool: false,
      selTrip: "",
    };
    this.channel.join()
    .receive("ok", this.gotView.bind(this))
    .receive("error", resp => { console.log("Unable to join", resp) });
  }
  gotView(view){
    // console.log(view);
    this.setState(view.track);
    if(this.state.busUpdateBool){
      setTimeout(()=> {this.channel.push("busUpdate1",{ tripid: this.state.selTrip })
        .receive("ok", this.gotView.bind(this))},10000);
      //  console.log("hello inside");
    }
    else{
      setTimeout(()=> {this.channel.push("predictions",{ stopId: this.state.stopId })
        .receive("ok", this.gotView.bind(this))},30000);
      //  console.log("hello outside");
    }
  }
  getNearestStop(){
    this.channel.push("nearestStops",{ latitude: this.latitude, longitude: this.longitude})
      .receive("ok", this.gotView.bind(this));
  }
  getPredictions(ev){
    this.channel.push("setStopId",{ stopId: ev.target.value })
      .receive("ok", this.gotView.bind(this));
    this.channel.push("predictions",{ stopId: ev.target.value })
        .receive("ok", this.gotView.bind(this));
  }
  toggleModal() {
    this.channel.push("updateSelRoute",{ newSelRoute: false })
      .receive("ok", this.gotView.bind(this));
  }
  getSelStops(ev){
  //  console.log(ev.target.id,"Trip ID");
    this.channel.push("allStopsForRoute",{ routeid: ev.target.text , tripid: ev.target.id })
      .receive("ok", this.gotView.bind(this));
  }
  getBusUpdate(ev){
    console.log("fetching update");
    this.channel.push("busUpdate",{ tripid: ev.target.id })
      .receive("ok", this.gotView.bind(this));
  }
  toggleBusModal() {
    this.channel.push("hideBusModal",{ busUpdateBool: false })
      .receive("ok", this.gotView.bind(this));
  }

  render() {
    let source = _.map(this.state.nearestStops, (uu) => <option key={uu.id} value={uu.id}>{uu.attributes.name}</option>);
    let sourcehead="";
    if(source!="") source = <select id="mySelect" className="form-control" onChange={(ev)=>this.getPredictions(ev)}><option>Select</option>{source}</select>
    if(source!="") sourcehead= <h6><br/><b>Select Source</b>(Stops are within half mile from your current location)</h6>
    return(
      <div>
        <Modal show={this.state.selRoute}
          onClose={this.toggleModal.bind(this)} selRouteStops={this.state.selRouteStops} />
        <BusModal show={this.state.busUpdateBool}
          onClose={this.toggleBusModal.bind(this)} busUpdate={this.state.busUpdate} />

        <h5> Current Location  </h5>
        <h5>{"Longitude:" + this.longitude }</h5>
        <h5>{"Latitude:"+this.latitude}</h5>
        <button className="btn btn-primary" onClick={()=>this.getNearestStop()}>Get Nearest Bus Stop</button>
        {sourcehead}
        {source}
        <div className="over1">
        <table className="table table-striped">
          <thead>
            <tr>
              <th className="width1">Route</th>
              <th className="width1">DirectionId</th>
              <th className="width4">Scheduled Arrival</th>
              <th className="width4">Predicted Arrival</th>
              <th className="width4">Predicted Departure</th>
              <th className="width4">Status</th>
            </tr>
          </thead>
          <tbody>
          {this.state.predictions.length==0?<tr></tr>:this.state.predictions.data.map((uu)=>
              <Predict key={"pr"+uu.id} uu={uu} getBusUpdate={this.getBusUpdate.bind(this)} getSelStops= {this.getSelStops.bind(this)} root={this} />
            )}
          </tbody>
        </table>
        </div>
      </div>
    );
  }
}

function Predict(props){

  let uu=props.uu;
  let root=props.root;
  let schedule_arrival = root.state.predictions.included==undefined?null: root.state.predictions.included.find(item => item.id == uu.relationships.schedule.data.id).attributes.arrival_time;

  // to save history
  function add_log() {
    let text = JSON.stringify({
      log: {
          directionId: uu.attributes.direction_id==0?"Outbound":"Inbound",
          predicted: uu.attributes.arrival_time,
          route: uu.relationships.route.data.id,
          schedule: schedule_arrival==null?null:schedule_arrival,
          stop: $('#mySelect :selected').text(),
          user_id: current_user_id,
        },
    });

    $.ajax(log_path, {
      method: "post",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: text,
      success: (resp) => { $("#"+uu.id).html('Saved'); $("#"+uu.id).prop("disabled",true); },
      error: (resp) => { console.log(resp); },
    });
  }

  return(
    <tr key={"pr"+uu.id}>
      <td><a href="#" onClick={props.getSelStops} id={uu.relationships.trip.data.id}>{uu.relationships.route.data.id}</a></td>
      <td>{uu.attributes.direction_id==0?"Outbound":"Inbound"}</td>
      <td>{schedule_arrival==null? "Not Available" : schedule_arrival.substring(0,(schedule_arrival).length-6)}</td>
      <td>{uu.attributes.arrival_time==null?"Not Available":uu.attributes.arrival_time.substring(0,(uu.attributes.arrival_time).length-6)}</td>
      <td>{uu.attributes.departure_time==null?"Not Available":uu.attributes.departure_time.substring(0,(uu.attributes.departure_time).length-6)}</td>
      <td><a href="#" onClick={props.getBusUpdate} id={uu.relationships.trip.data.id}>Live-Update </a>
      <button className="btn btn-primary btn-sm" id={uu.id} onClick={add_log} >Save</button></td>
    </tr>
  );
}


//42.3377967 -71.0705763
