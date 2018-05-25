import React, { Component } from 'react';
import { Dropdown, DropdownToggle, DropdownMenu, DropdownItem } from 'reactstrap';
import CheckboxQuestionForm from './checkbox_question_form';
import RadioQuestionForm from './radio_question_form';
import SelectQuestionForm from './select_question_form';
import TextfieldQuestionForm from './textfield_question_form';
import TextareaQuestionForm from './textarea_question_form';

function QuestionForm(props) {
  switch(props.questionType) {
    case 0:
      return null;
    case 1:
      return <CheckboxQuestionForm saveQuestion={props.saveQuestion} />;
    case 2:
      return <RadioQuestionForm saveQuestion={props.saveQuestion} />;
    case 3:
      return <SelectQuestionForm saveQuestion={props.saveQuestion} />;
    case 4:
      return <TextfieldQuestionForm saveQuestion={props.saveQuestion} />;
    case 5:
      return <TextareaQuestionForm saveQuestion={props.saveQuestion} />;
    default:
      return null;
  }
}

export default class QuestionsForm extends Component {
  constructor(props) {
    super(props);

    this.state = {
      dropdownOpen: false,
      questionFormType: 0 // 0 - nothing, 1 - checkboxes, 2 - radios, 3 - select, 4 - textfield, 5 - text area 
    };
  }

  toggle = () => {
    this.setState({
      dropdownOpen: !this.state.dropdownOpen
    });
  };

  toggleQuestionType = (type) => {
    this.setState({
      questionFormType: type
    });
  };

  saveQuestion = (question) => {
    this.props.saveQuestion(question);
    this.setState({questionFormType: 0});
  };

  render() {
    return (
      <div>
        <Dropdown isOpen={this.state.dropdownOpen} toggle={this.toggle} className="mt-2">
          <DropdownToggle caret>
            Add question to page
          </DropdownToggle>
          <DropdownMenu>
            <DropdownItem onClick={() => this.toggleQuestionType(1)}>With check box answers</DropdownItem>
            <DropdownItem onClick={() => this.toggleQuestionType(2)}>With radio button answer</DropdownItem>
            <DropdownItem onClick={() => this.toggleQuestionType(3)}>With select list answer</DropdownItem>
            <DropdownItem onClick={() => this.toggleQuestionType(4)}>With textfield answer</DropdownItem>
            <DropdownItem onClick={() => this.toggleQuestionType(5)}>With textarea answer</DropdownItem>
          </DropdownMenu>
        </Dropdown>
        <br/>
        <QuestionForm questionType={this.state.questionFormType} saveQuestion={(question) => this.saveQuestion(question)}/>
      </div>
    );
  }
}