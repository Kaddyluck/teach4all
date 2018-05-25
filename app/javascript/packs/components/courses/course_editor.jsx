import React from 'react'
import { Card, CardHeader, CardText, CardBody,
   Button, UncontrolledAlert, Nav, NavItem, NavLink, Badge, InputGroup, Input, InputGroupAddon } from 'reactstrap';
import { PageTab } from './page_tab';
import MyEditor from './my_editor';
import QuestionsForm from './questions_form';
import QuestionsList from './questions_list';
import MyAlert from '../my_alert';
import SavePublishButtons from './save_publish_buttons';

class CourseEditor extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      saveCourseMethod: this.props.saveCourseMethod,
      saveCoursePath: this.props.saveCoursePath,
      validateAndSaveCoursePath: this.props.validateAndSaveCoursePath,
      alertColor: "success",
      alertMessage: "",
      alerts: false,
      courseName: this.props.name,
      activePage: 0,
      pages: this.props.pages.map((page) => {
        page.content = JSON.parse(page.content);
        return page;
      })
    };
  };

  togglePage = (page) => {
    if (this.state.activePage !== page) {
      this.setState({
        activePage: page
      });
    }
  };
  
  newPage = () => {
    this.setState({
      pages: [...this.state.pages, {
        title: "",
        content: {"entityMap":{},"blocks":[{"key":"637gr","text":"","type":"unstyled","depth":0,"inlineStyleRanges":[],"entityRanges":[],"data":{}}]},
        questions: []
      }], 
      activePage: this.state.pages.length
    });
  };

  deletePage = (n) =>{
    var pages = this.state.pages;
    pages.splice(n, 1);
    this.setState({
      pages: pages,
      activePage: 0
    });
    if (this.state.pages.length == 0) {
      this.newPage();
    }
  };

  handleCourseNameChange = (e) => {
    this.setState({
      courseName: e.target.value
    });
  };

  handlePageTitleChange = (e) => {
    this.editor.saveContent();
    var pages = this.state.pages;
    pages[this.state.activePage].title = e.target.value;
    this.setState({
      pages: pages
    });
  };

  saveContent = (pageNumber, content) => {
    if (pageNumber < this.state.pages.length) {
      var pages = this.state.pages;
      pages[pageNumber].content = content;
      this.setState({
        pages: pages
      });
    }
  };

  saveQuestion = (question) => {
    this.editor.saveContent();
    question.key = Math.random().toString(36).substring(2, 15);
    var pages = this.state.pages;
    pages[this.state.activePage].questions.push(question);
    this.setState({
      pages: pages
    });
  };

  deleteQuestion = (i) => {
    this.editor.saveContent();
    var pages = this.state.pages;
    pages[this.state.activePage].questions.splice(i, 1);
    this.setState({
      pages: pages
    });
  };

  saveCourse = (method, path) => {
    this.editor.saveContent();
    // this is for strigifying content of each page and not mutating a state, pages = [...this.state.pages] not work
    let pages = [];
    this.state.pages.forEach((page) => {
      let pageCopy = {...page};
      pageCopy.content = JSON.stringify(pageCopy.content);
      pages.push(pageCopy);
    });
    //
    let course = {'course': {
        name: this.state.courseName,
        published: this.state.published,
        pages: pages
      }
    };
    $.ajax({ url: path,
      type: method,
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      dataType: 'json',
      data: course,
      success: function(response) {
        if(response.redirect){
          window.location.href = response.redirect;
        } else if (response.alertMessage) {
          this.setState({
            alerts: true,
            alertColor: response.alertColor,
            alertMessage: response.alertMessage
          });
          $('html, body').animate({ scrollTop: 0 }, 'fast');
        }
      }.bind(this)
    });
  };

  render() {
    return(
      <div>
        <div className='row'>
          <div className='col-lg-12'>
          {this.state.alerts && <MyAlert message={this.state.alertMessage} color={this.state.alertColor} onDismiss={()=>{this.setState({alerts: false});}}/>}
          <InputGroup>
            <InputGroupAddon addonType="prepend">Enter Name Of The Course:</InputGroupAddon>
            <Input onChange={this.handleCourseNameChange} value={this.state.courseName}/>
          </InputGroup>
          <hr/>   
          <Card>
            <CardBody>
              <h4>{this.state.courseName}</h4>
              <Nav tabs>
                {this.state.pages.map( (s, i) => {
                  return(
                    <PageTab key={s + i}
                             pageNumber={i} 
                             text={s.title} 
                             togglePage={this.togglePage} 
                             activePage={this.state.activePage}
                             deletePage={this.deletePage} />
                  );})}
                  <NavItem>
                    <NavLink onClick={this.newPage}>
                    <Badge color="secondary" className="plus" pill>+</Badge>
                    </NavLink>
                  </NavItem>
              </Nav>
              <br/>
              <InputGroup>
                <InputGroupAddon addonType="prepend">Enter Title Of The Page:</InputGroupAddon>
                <Input value={this.state.pages[this.state.activePage].title}
                       onChange={this.handlePageTitleChange}/>
              </InputGroup>
              <br/>
              <p>Content:</p>
              <MyEditor content={this.state.pages[this.state.activePage].content} 
                        saveContent={this.saveContent}
                        activePage={this.state.activePage}
                        ref={instance => { this.editor = instance; }}/>
              <br/>
              <p>Questions:</p>
              <QuestionsList questions={this.state.pages[this.state.activePage].questions} deleteQuestion={this.deleteQuestion}/>
              <QuestionsForm saveQuestion={this.saveQuestion}/>
              <hr/>
              <SavePublishButtons edit={this.props.edit} 
                                  saveCourse={() =>{this.saveCourse(this.state.saveCourseMethod, this.state.saveCoursePath);}} 
                                  publishCourse={() => {this.saveCourse('PUT', this.state.validateAndSaveCoursePath);}} />
            </CardBody>
          </Card>
          </div>
        </div>
      </div>
    )
  };
};

export default CourseEditor;