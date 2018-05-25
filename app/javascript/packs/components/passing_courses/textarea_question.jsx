import React, { Component } from 'react';
import { Label, Input } from 'reactstrap';

class TextareaQuestion extends Component {
  constructor(props) {
    super(props);
  }

  handleAnswersChange = (event) => {
    let answers = this.props.userAnswers;
    answers = answers.filter(a => a.questionId != this.props.question.id);
    let newAnswer = {
      questionId: this.props.question.id,
      text: event.target.value
    };
    answers.push(newAnswer);
    this.props.changeUserAnswers(answers);
  };

  render() {
    let answer = this.props.userAnswers.find(a => a.questionId == this.props.question.id);
    return(
      <div>
        {this.props.question.text}
        <Input type="textarea" name="text"
               onChange={this.handleAnswersChange}
               value={answer ? answer.text : ""}/>
      </div>
    );
  }
}

export default TextareaQuestion;