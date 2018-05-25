import React from 'react';
import { Alert } from 'reactstrap';

class MyAlert extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      visible: true
    };

    this.onDismiss = this.onDismiss.bind(this);
  }

  onDismiss() {
    this.props.onDismiss();
    this.setState({ visible: false });
  }

  componentWillReceiveProps() {
    this.state = {
        visible: true
    }
  }

  render() {
    return (
      <Alert color={this.props.color} isOpen={this.state.visible} toggle={this.onDismiss}>
        {this.props.message}
      </Alert>
    );
  }
}

export default MyAlert;
