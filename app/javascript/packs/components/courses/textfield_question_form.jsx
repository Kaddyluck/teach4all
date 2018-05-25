import React, { Component } from 'react';
import {Card, CardBody, InputGroup, FormGroup, InputGroupAddon, Label, ListGroup, ListGroupItem, Input, Button} from 'reactstrap';
import MyAlert from '../my_alert';
import FlipMove from 'react-flip-move';

export default class TextfieldQuestionForm extends Component {
  constructor(props) {
    super(props);

    this.state = {
      errors: false,
      errorMessage: "Question content can't be blank :-)",
      type: "textfield",
      questionText: "",
      answers: []
    }
  }

  handleQuestionTextChange = (e) => {
    this.setState({
      questionText: e.target.value
    });
  };

  onAlertDismiss = () => {
    this.setState({errors: false});
  };

  saveQuestion = () => {
    let errors = false;

    if (!this.state.questionText) {
      this.setState({
        errors: true,
        errorMessage: "Question text can't be blank :-)"
      });
      errors = true;
    }

    if (!errors) {
      console.log(!this.state.errors);
      this.props.saveQuestion({
        type: this.state.type,
        text: this.state.questionText,
        answers: this.state.answers
      });
    } 
  };

  render() {
    return(
      <Card>
        <CardBody>
          {this.state.errors && <MyAlert message={this.state.errorMessage} color="danger" onDismiss={this.onAlertDismiss}/>}
          <Label>Type question (note that for this type of question you'll need manualy check answers of each user):</Label>  
          <Input type="textarea" name="text" id="questionText" onChange={this.handleQuestionTextChange}/>
          <hr/>
          <Button color="primary" onClick={this.saveQuestion}>Add question</Button>
        </CardBody>
      </Card>
    );
  }
}