import React, { Component } from 'react';
import Slider from 'react-rangeslider';
import { Alert, Button } from 'reactstrap';
import MyAlert from './components/my_alert';
import ComponentRenderer from './component_renderer';

class RatingSlider extends Component {
  constructor (props, context) {
    super(props, context)
    this.state = {
      value: this.props.userRating,
      alerts: false,
      alertMessage: ""
    }
  }

  handleChange = value => {
    this.setState({
      value: value
    })
  };

  saveRating = () => {
    $.ajax({ url: this.props.rateCoursePath,
      type: 'PUT',
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      dataType: 'json',
      data: {value: this.state.value},
      success: function(response) {
        this.setState({
          alertMessage: "Your rate saved.",
          alerts: true
        });
      }.bind(this)
    });
  };

  render () {
    const { value } = this.state;
    return (
      <div>
        {this.state.alerts ? (
          <MyAlert color="success" 
                   onDismiss={() => {this.setState({alerts: false})}}
                   message={this.state.alertMessage}/>) : null}
        <Alert color="info">
          <h5 className="alert-heading">Rate course: your mark is {this.state.value}</h5>
          <div className="row">
            <div className="col-lg-8">
              <Slider
                min={-10}
                max={10}
                value={value}
                onChangeStart={this.handleChangeStart}
                onChange={this.handleChange}
                onChangeComplete={this.handleChangeComplete}
              />
            </div>
            <div className="col-lg-4">
              <Button block size="sm" color="primary"
                      onClick={this.saveRating}>
                Rate!
              </Button>
            </div>
          </div>
        </Alert>
      </div>
    );
  }
}

ComponentRenderer(RatingSlider);