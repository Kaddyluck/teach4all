import React from 'react';
import {Row, Col, Button} from 'reactstrap';

function SavePublishButtons(props) {
  if (props.edit) {
    return(
      <Row>
        <Col md="6">
          <Button block outline color="info" onClick={props.saveCourse}>Save course</Button>
        </Col>
        <Col md="6">
          <Button block outline color="success" onClick={props.publishCourse}>Publish course</Button>
        </Col>
      </Row>
    );
  } else {
    return(<Button block outline color="info" onClick={props.saveCourse}>Save course</Button>);
  }
}

export default SavePublishButtons;