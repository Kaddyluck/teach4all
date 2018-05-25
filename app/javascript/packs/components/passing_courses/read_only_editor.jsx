import React, { Component } from 'react';
import { Editor } from 'react-draft-wysiwyg';
import { EditorState, convertToRaw, ContentState, convertFromRaw } from 'draft-js';
import 'react-draft-wysiwyg/dist/react-draft-wysiwyg.css';

export default class ReadOnlyEditor extends Component {
  constructor(props) {
    super(props);
    let editorState = EditorState.createWithContent(convertFromRaw(this.props.content));
    this.state = {
        editorState: editorState
    };
  };

  componentWillReceiveProps(newProps) {
    let editorState = EditorState.createWithContent(convertFromRaw(newProps.content));
    this.state = {
        editorState: editorState
    };
  };

  render() {
    return (
      <div>
        {this.state.editorState.getCurrentContent().hasText() ? (
          <Editor
          readOnly
          toolbarHidden={true}
          editorState={this.state.editorState}
          toolbarClassName="readOnlyEditorToolbar"
          wrapperClassName="readOnlyEditorWrapper"
          editorClassName="readOnlyEditor"/> 
        ) : (
          null
        )}
      </div>
    );
  }
}