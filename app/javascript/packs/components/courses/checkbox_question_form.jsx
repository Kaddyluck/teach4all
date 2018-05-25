import React, { Component } from 'react';
import {Card, CardBody, InputGroup, FormGroup, InputGroupAddon, Label, ListGroup, ListGroupItem, Input, Button} from 'reactstrap';
import MyAlert from '../my_alert';
import FlipMove from 'react-flip-move';

export default class CheckboxQuestionForm extends Component {
  constructor(props) {
    super(props);

    this.state = {
      errors: false,
      errorMessage: "Question content can't be blank :-)",
      type: "checkbox",
      questionText: "",
      answers: []
    }
  }

  handleQuestionTextChange = (e) => {
    this.setState({
      questionText: e.target.value
    });
  };

  handleAnswerTextChange = (i, text) => {
    let answers = this.state.answers;
    answers[i].text = text;
    this.setState({
      answers: answers
    });
  };

  handleQuestionCorrectChange = (i) => {
    let answers = this.state.answers;
    answers[i].correct = !answers[i].correct;
    this.setState({
      answers: answers
    });
  };

  addAnswer = () => {
    let answers = this.state.answers;
    answers.push({
      text: "",
      correct: false,
      key: Math.random().toString(36).substring(2, 15)
    });
    this.setState({
      answers: answers
    });
  };

  deleteAnswer = (i) => {
    let answers = this.state.answers;
    answers.splice(i, 1);
    this.setState({
      answers: answers
    });
  };

  onAlertDismiss = () => {
    this.setState({errors: false});
  };

  saveQuestion = () => {
    let errors = false;
    if (this.state.answers.length < 2) {
      this.setState({
        errors: true,
        errorMessage: "Question should have at least 2 answers :-)"
      });
      errors = true;
    }
    this.state.answers.forEach( function (answer) {
      if(!answer.text) {
        this.setState({
          errors: true,
          errorMessage: "Answer text can't be blank :-)"
        });
        errors = true;
      }
    }.bind(this));
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
          <Label>Type question:</Label>  
          <Input type="textarea" name="text" id="questionText" onChange={this.handleQuestionTextChange}/>
          <br/>
          <Label>
            Answers: {this.state.answers.length > 0 ? null : " You should add answers to question :-)"}
          </Label>
          <div style={{ position: 'relative' }}>
            <FlipMove staggerDurationBy="30" 
                      duration={500} 
                      enterAnimation="fade" 
                      leaveAnimation="fade"
                      maintainContainerHeight={true}>
              {this.state.answers.map((answer, i) => {
                return(
                  <div key={answer.key}>
                    <ListGroupItem action >
                      <button type="button" className="close" aria-label="Close" onClick={() => this.deleteAnswer(i)}>
                        <span aria-hidden="true" className="close-tab">&times;</span>
                      </button>
                      <div className="questionForm">
                        <InputGroup size="sm">
                          <InputGroupAddon addonType="prepend">Type answer:</InputGroupAddon>
                          <Input value={this.state.answers[i].text} onChange={(e) => this.handleAnswerTextChange(i, e.target.value)}/>
                        </InputGroup>
                        <Label check>
                          <Input type="checkbox" onChange={()=>this.handleQuestionCorrectChange(i)}/>{' '}
                          Correct
                        </Label>
                      </div>
                    </ListGroupItem>
                  </div>
                );
              })}
            </FlipMove>
          </div>
          <Button color="secondary" size="sm" onClick={this.addAnswer} className="mt-1">+ add answer</Button>
          <hr/>
          <Button color="primary" onClick={this.saveQuestion}>Add question</Button>
        </CardBody>
      </Card>
    );
  }
}