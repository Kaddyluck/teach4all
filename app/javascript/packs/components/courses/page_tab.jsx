import React from 'react'
import {NavItem, NavLink, Badge} from 'reactstrap';
import classnames from 'classnames';

export class PageTab extends React.Component {
  formatStr = (s) => {
    if(s.length > 10) {
      return s.slice(0, 11).trim() + '...';
    }
    return s;
  };
  deletePage = () => {
    if(confirm('Are you shure?')) {
      this.props.deletePage(this.props.pageNumber);
    }
  };
  render() {
    return(
      <div>
        <NavItem>
          <NavLink
            className={classnames({ active: this.props.activePage === this.props.pageNumber })}
            onClick={() => { this.props.togglePage(this.props.pageNumber); }}>
            {this.formatStr(this.props.text) || 'New page'}
            {
              this.props.activePage === this.props.pageNumber && 
              <Badge className="ml-1">
                <span className="close-tab" onClick={this.deletePage}>×</span>
              </Badge>
            }
          </NavLink>
        </NavItem>
      </div>
    )
  }
};