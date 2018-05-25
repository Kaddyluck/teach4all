import React, { Component } from 'react';
import { Editor } from 'react-draft-wysiwyg';
import { EditorState, convertToRaw, ContentState, convertFromRaw } from 'draft-js';
import draftToHtml from 'draftjs-to-html';
import htmlToDraft from 'html-to-draftjs';
import DraftPasteProcessor from 'draft-js/lib/DraftPasteProcessor';
import 'react-draft-wysiwyg/dist/react-draft-wysiwyg.css';

function uploadImageCallBack(file) {
  return new Promise(
    (resolve, reject) => {
      const xhr = new XMLHttpRequest(); // eslint-disable-line no-undef
      xhr.open('POST', 'https://api.imgur.com/3/image');
      xhr.setRequestHeader('Authorization', 'Client-ID 56963dc6e54ee1b');
      const data = new FormData(); // eslint-disable-line no-undef
      data.append('image', file);
      xhr.send(data);
      xhr.addEventListener('load', () => {
        const response = JSON.parse(xhr.responseText);
        resolve(response);
      });
      xhr.addEventListener('error', () => {
        const error = JSON.parse(xhr.responseText);
        reject(error);
      });
    },
  );
}

export default class MyEditor extends Component {
  constructor(props) {
    super(props);
    let editorState = EditorState.createWithContent(convertFromRaw(this.props.content));
    this.state = {
        editorState: editorState
    };
  };

  componentWillReceiveProps(newProps) {
    if (this.props.activePage != newProps.activePage) {
      this.saveContent();
    }
    let editorState = EditorState.createWithContent(convertFromRaw(newProps.content));
    this.state = {
        editorState: editorState
    };
  };
  
  onEditorStateChange = (editorState) => {
    this.setState({
      editorState,
    });
  };

  saveContent = () => {
    this.props.saveContent(this.props.activePage, convertToRaw(this.state.editorState.getCurrentContent()));
  };

  render() {
    return (
      <Editor
        editorState={this.state.editorState}
        wrapperClassName="myWrapper"
        editorClassName="myEditor"
        onEditorStateChange={this.onEditorStateChange}
        toolbar={{
          image: {
            uploadCallback: uploadImageCallBack,
            alt: { present: true, mandatory: false },
          },
          embedded: {
            defaultSize: {
              height: '450',
              width: '900',
            },
          },
        }}
      />
    );
  }
}