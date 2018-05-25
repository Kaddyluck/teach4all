import React, { Component } from 'react';
import { Label, Input } from 'reactstrap';

class RadioQuestion extends Component {
  constructor(props) {
    super(props);
  }

  handleAnswersChange = (event, answer) => {
    let newAnswer = {
      questionId: this.props.question.id,
      answerId: answer.id
    };
    let answers = this.props.userAnswers;
    this.props.question.answers.forEach(a => {
      answers = answers.filter(userAnswer => userAnswer.answerId != a.id);
    });
    answers.push(newAnswer);
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
                  <Input type="radio" name={`radio${this.props.question.id}`} 
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

export default RadioQuestion;