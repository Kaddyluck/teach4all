import React, { Component } from 'react';
import {ListGroupItemHeading, FormGroup, Label, Input, Badge} from 'reactstrap';

class SelectQuestionPreview extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    return(
      <div>
        <ListGroupItemHeading>{this.props.question.text}</ListGroupItemHeading>
        {"Answers:"}
        <Input type="select" name="selectMulti" id="exampleSelectMulti" multiple>
          {this.props.question.answers.map((answer) => {
            return(
              <option>{answer.text}{answer.correct ? ' (correct answer)': null }</option>
            );
          })}
        </Input>
      </div>
    );
  }
}

export default SelectQuestionPreview;