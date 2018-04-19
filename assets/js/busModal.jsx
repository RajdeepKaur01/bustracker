import React from 'react';
import PropTypes from 'prop-types';
import { Card, CardBody } from 'reactstrap';

class BusModal extends React.Component {
  render() {
    // Render nothing if the "show" prop is false
    if(!this.props.show) {
      return null;
    }

    return (
      <div className="backdrop1">
        <div className="space1"></div>
        <div className="modal1">
          <div className="mheader bg-dark"><span className="modalheadfont">Status</span>
          <button className="btn btn-primary btn-sm floatr" onClick={this.props.onClose}>
            Close
          </button>
          </div>
          <br/><br/>
          <table className="table table-striped">
            <tbody>
              <tr>
              <td>Current Status:</td><td>{ this.props.busUpdate.data[0]==undefined?"Not available":this.props.busUpdate.data[0].attributes.current_status }</td>
              </tr>
              <tr>
              <td>Bus Stop:</td><td>{ this.props.busUpdate.data[0]==undefined?"Not available":this.props.busUpdate.included[0].attributes.name  }</td>
              </tr>
              <tr>
              <td>Last Updated On:</td><td>{ this.props.busUpdate.data[0]==undefined?"Not available":this.props.busUpdate.data[0].attributes.last_updated.substring(0,(this.props.busUpdate.data[0].attributes.last_updated).length-6) }</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    );
  }
}

BusModal.propTypes = {
  onClose: PropTypes.func.isRequired,
  show: PropTypes.bool,
  children: PropTypes.node
};

export default BusModal;
