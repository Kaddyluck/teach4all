import React from 'react';
import {Row, Col, Card, CardBody, Button, ButtonGroup} from 'reactstrap';
import ReadOnlyEditor from './read_only_editor';
import QuestionsList from './questions_list';
import ReactLoading from 'react-loading';

class PassingCoursePage extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      activePage: this.props.activePage,
      pages: this.props.pages.map((page) => {
        page.content = JSON.parse(page.content);
        return page;
      }),
      userAnswers: this.props.userAnswers,
      loading: false   
    };
  }

  nextPage = () => {
    this.setState({
      activePage: this.state.activePage + 1
    }, () => {this.saveProgress();});
  };

  previousPage = () => {
    this.setState({
      activePage: this.state.activePage - 1
    }, () => {this.saveProgress();});
  };

  changeUserAnswers = (newUserAnswers) => {
    this.setState({
      userAnswers: newUserAnswers
    });
  };

  saveProgress = (callback) => {
    $.ajax({ 
      url: this.props.saveProgressCoursePath,
      type: 'PUT',
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      dataType: 'json',
      data: {userAnswers: this.state.userAnswers, activePage: this.state.activePage},
      success: function(result) {
        if (callback) {
          callback(result);
        }
      }
    });
  };
  
  checkAnswers = () => {
    this.saveProgress((result) => {
      if(confirm('Are you sure?')) {
        $.ajax({
          url: this.props.checkAnswersCoursePath,
          type: 'PUT',
          beforeSend: function(xhr) {
            xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
            this.setState({loading: true});
          }.bind(this),
          dataType: 'json',
          success: function(response) {
            window.location.href = response.redirect;
          }
        });
      }
    });
  };

  render() {
    return(
      <div>
        <Row>
          <Col lg="12">
            <Card>
              <CardBody>
                {this.state.loading ? (
                  <div className="mx-auto">
                    <ReactLoading type="cylon" 
                                  color="#158CBA" 
                                  height={300} 
                                  width={300} 
                                  className={"mx-auto"}
                                  delay={100} />
                    <h1 className="text-center">Checking your answers :-)</h1>
                  </div>
                ) : (
                  <div>
                    <h3>{this.props.name} : {this.props.pages[this.state.activePage].title}</h3>
                    <ReadOnlyEditor content={this.state.pages[this.state.activePage].content} />
                    {this.state.pages[this.state.activePage].questions.length != 0 ?
                      <QuestionsList questions={this.state.pages[this.state.activePage].questions} 
                                    userAnswers={this.state.userAnswers}
                                    changeUserAnswers={this.changeUserAnswers}/> : null}
                    {this.state.activePage == 0 ? null :
                      <Button outline className="float-left" 
                              color="info" outline
                              onClick={this.previousPage} >
                        ← previous
                      </Button>}
                    {this.state.activePage == this.state.pages.length - 1 ? (
                      <Button outline color="success" className="float-right"
                              onClick={this.checkAnswers}>
                        Check my answers!
                      </Button> 
                    ) : (
                      <Button outline className="float-right" 
                              color="info" outline
                              onClick={this.nextPage}>
                        next →
                      </Button>
                    )}
                  </div>
                )}
              </CardBody>
            </Card>
          </Col>
        </Row>
      </div>
    )
  }
};

export default PassingCoursePage;