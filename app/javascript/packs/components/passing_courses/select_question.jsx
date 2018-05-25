import React, { Component } from 'react';
import { Label, Input } from 'reactstrap';

class SelectQuestion extends Component {
  constructor(props) {
    super(props);
  }

  handleAnswersChange = (event) => {
    let answers = this.props.userAnswers;
    this.props.question.answers.forEach(a => {
      answers = answers.filter(userAnswer => userAnswer.answerId != a.id);
    });
    let options = event.target.options;
    for (var i = 0, l = options.length; i < l; i++) {
      if (options[i].selected) {
        answers.push({
          questionId: this.props.question.id,
          answerId: options[i].value
        });
      }
    }
    this.props.changeUserAnswers(answers);
  };

  render() {
    let selected_values =[];
    this.props.question.answers.forEach((answer) => {
      if (this.props.userAnswers.find(a => a.answerId == answer.id)) {
        selected_values.push(answer.id);
      }
    });
    return(
      <div>
        {this.props.question.text}
        <Input type="select" name="selectMulti" id="exampleSelectMulti" multiple
               onChange={this.handleAnswersChange}
               value={selected_values}>
          {this.props.question.answers.map((answer) => {
            return(
              <option key={answer.id}
                      value={answer.id}>
                {answer.text}
              </option>
            );
          })}
        </Input>
      </div>
    );
  }
}

export default SelectQuestion;