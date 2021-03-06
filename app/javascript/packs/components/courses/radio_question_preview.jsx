import React, { Component } from 'react';
import {ListGroupItemHeading, FormGroup, Label, Input, Badge} from 'reactstrap';

class RadioQuestionPreview extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    return(
      <div>
        <ListGroupItemHeading>{this.props.question.text}</ListGroupItemHeading>
        {"Answers:"}
          {this.props.question.answers.map((answer) => {
            return(
              <div>
                <Label check>
                  <Input type="radio" name="radio1" />{' '}
                  {answer.correct ? <span className="text-success">{answer.text}</span> : answer.text}{'\n'}
                </Label>
              </div>
            );
          })}
      </div>
    );
  }
}

export default RadioQuestionPreview;