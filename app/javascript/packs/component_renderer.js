import React from 'react';
import { render } from 'react-dom';

export default function ComponentRenderer(Component) {
  document.addEventListener('DOMContentLoaded', () => {
    const container = $('#container');
    const myProps = container.data();
    render(<Component {...myProps} />, container.get(0));
  });
}