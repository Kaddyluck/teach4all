import React, { Component } from 'react';
import {ListGroupItemHeading, FormGroup, Label, Input, Badge} from 'reactstrap';

class TextfieldQuestionPreview extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    return(
      <div>
        <ListGroupItemHeading>{this.props.question.text}</ListGroupItemHeading>
        {"(answer of this question should be entered into textarea and manualy checked)"}
      </div>
    );
  }
}

export default TextfieldQuestionPreview;