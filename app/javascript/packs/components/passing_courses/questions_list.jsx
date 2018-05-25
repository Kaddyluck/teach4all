import React, { Component } from 'react';
import CheckboxQuestion from './checkbox_question';
import RadioQuestion from './radio_question';
import SelectQuestion from './select_question';
import TextfieldQuestion from './textfield_question';
import TextareaQuestion from './textarea_question';

function Question(props) {
  switch(props.question.type) {
    case 'checkbox':
      return <CheckboxQuestion question={props.question}
                               userAnswers={props.userAnswers}
                               changeUserAnswers={props.changeUserAnswers}/>;
    case 'radio':
      return <RadioQuestion question={props.question}
                            userAnswers={props.userAnswers}
                            changeUserAnswers={props.changeUserAnswers}/>;
    case 'select':
      return <SelectQuestion question={props.question}
                             userAnswers={props.userAnswers}
                             changeUserAnswers={props.changeUserAnswers}/>;
    case 'textfield':
      return <TextfieldQuestion question={props.question}
                                userAnswers={props.userAnswers}
                                changeUserAnswers={props.changeUserAnswers}/>;
    case 'textarea':
      return <TextareaQuestion question={props.question}
                               userAnswers={props.userAnswers}
                               changeUserAnswers={props.changeUserAnswers}/>;
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
      <div>
        <p>Questions:</p>
        {this.props.questions.map((q) => {
          return(
            <div>
              <Question question={q}
                        userAnswers={this.props.userAnswers}
                        changeUserAnswers={this.props.changeUserAnswers}/>
              <br/>
            </div>
          );
        })}
      </div>
    );
  }
}

export default QuestionsList;