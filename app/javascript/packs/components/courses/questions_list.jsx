import React, { Component } from 'react';
import CheckboxQuestionPreview from './checkbox_question_preview';
import RadioQuestionPreview from './radio_question_preview';
import {ListGroup, ListGroupItem} from 'reactstrap';
import FlipMove from 'react-flip-move';
import SelectQuestionPreview from './select_question_preview';
import TextfieldQuestionPreview from './textfield_question_preview';
import TextareaQuestionPreview from './textarea_question_preview';

function Question(props) {
  switch(props.question.type) {
    case 'checkbox':
      return <CheckboxQuestionPreview question={props.question}/>;
    case 'radio':
      return <RadioQuestionPreview question={props.question}/>;
    case 'select':
      return <SelectQuestionPreview question={props.question}/>;
    case 'textfield':
      return <TextfieldQuestionPreview question={props.question}/>;
    case 'textarea':
      return <TextareaQuestionPreview question={props.question}/>;
    default:
      return null;
  }
}

class QuestionsList extends Component {
  constructor(props) {
   super(props)   
  }

  render() {
    return(
      <div style={{ position: 'relative' }}>
        <FlipMove staggerDurationBy="30" 
                  duration={500} enterAnimation="fade" 
                  leaveAnimation="fade"
                  maintainContainerHeight={true}>
          {this.props.questions.map((question, i) => {
            return(
              <div key={question.key}>
                <ListGroupItem action>
                  <button type="button" className="close" aria-label="Close" onClick={() => {this.props.deleteQuestion(i)}}>
                    <span aria-hidden="true">&times;</span>
                  </button>
                  <Question question={question}/> 
                </ListGroupItem>
              </div>
            );
          })}
        </FlipMove>
      </div>
    );
  }
}

export default QuestionsList;