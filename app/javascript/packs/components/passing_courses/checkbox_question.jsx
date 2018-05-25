import React, { Component } from 'react';
import { Label, Input } from 'reactstrap';

class CheckboxQuestion extends Component {
  constructor(props) {
    super(props);
  }

  handleAnswersChange = (event, answer) => {
    if (event.target.checked) {
      this.addToUserAnswers(answer);
    } else {
      this.deleteFromUserAnswers(answer);
    }
  };

  addToUserAnswers = (answer) => {
    let userAnswer = {
      questionId: this.props.question.id,
      answerId: answer.id
    };
    let answers = this.props.userAnswers;
    answers.push(userAnswer);
    this.props.changeUserAnswers(answers);
  };

  deleteFromUserAnswers = (answer) => {
    let answers = this.props.userAnswers;
    answers = answers.filter(a => a.answerId != answer.id);
    this.props.changeUserAnswers(answers);
  };

  render() {
    return(
      <div>
        {this.props.question.text}
          {this.props.question.answers.map((answer) => {
            return(
              <div key={answer.id}>
                <Label check>
                  <Input type="checkbox"
                         onChange={(e) => {this.handleAnswersChange(e, answer)}}
                         checked={this.props.userAnswers.find(a => a.answerId == answer.id)}/>{' '}
                  {answer.text}{'\n'}
                </Label>
              </div>
            );
          })}
      </div>
    );
  }
}

export default CheckboxQuestion;