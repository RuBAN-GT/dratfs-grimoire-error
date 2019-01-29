class LiveSearch extends React.Component {
  constructor(props) {
    super(props);

    this.state = { expanded: false };

    this.handleOpen  = this.handleOpen.bind(this);
    this.handleClose = this.handleClose.bind(this);
  }
  handleOpen() {
    this.setState({expanded: true});

    $(this.refs.container).parents('.menu.right').addClass('expended');

    document.body.style.overflow = 'hidden';
  }
  handleClose() {
    this.setState({expanded: false});

    $(this.refs.container).parents('.menu.right').removeClass('expended');

    document.body.style.overflow = 'auto';
  }
  render() {
    return <div ref="container" className="livesearch container" data-expanded={this.state.expanded}>
      {this.state.expanded &&
        <LiveSearchForm />
      }

      {this.state.expanded ? (
        <span className="toggler" onClick={this.handleClose}><i className="close icon"></i></span>
      ) : (
        <span className="toggler" onClick={this.handleOpen}><i className="search icon"></i></span>
      )}

    </div>;
  }
}
