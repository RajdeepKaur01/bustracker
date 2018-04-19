import React from 'react';
import PropTypes from 'prop-types';

class Modal extends React.Component {
  render() {
    // Render nothing if the "show" prop is false
    if(!this.props.show) {
      return null;
    }

    return (
      <div className="backdrop1">
        <div className="space1"></div>
        <div className="modal1">
          <div className="mheader bg-dark"><span className="modalheadfont">Stops</span>
          <button className="btn btn-primary btn-sm floatr" onClick={this.props.onClose}>
            Close
          </button>
          </div><br/><br/>
          <table className="table table-striped">
          {this.props.selRouteStops.data==undefined?<tr><td>Not Available</td></tr>:
            <tbody>
            {this.props.selRouteStops.data.map((uu,i=0)=>
                <tr key={"mm"+uu.id}><td>{(i+1)}</td><td>{this.props.selRouteStops.included.find(item => item.id == uu.relationships.stop.data.id).attributes.name}</td></tr>
              )}
            </tbody>}
          </table>
        </div>
      </div>
    );
  }
}

Modal.propTypes = {
  onClose: PropTypes.func.isRequired,
  show: PropTypes.bool,
  children: PropTypes.node
};

export default Modal;
