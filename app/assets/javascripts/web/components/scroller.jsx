class Scroller extends React.Component {
  propTypes: {
    containerClass: React.PropTypes.string,
    onScrollEnd: React.PropTypes.func,
    scrollOnUpdate: React.PropTypes.bool,
    alwaysVisible: React.PropTypes.bool
  }
  defaultProps: {
    scrollOnUpdate: false,
    alwaysVisible: false
  }
  componentDidMount() {
    $(this.refs.scrollerContainer).nanoScroller({alwaysVisible: this.props.alwaysVisible});

    if(this.props.onScrollEnd) {
      $(this.refs.scrollerContainer).on('scrollend', this.props.onScrollEnd);

      if($(this.refs.scrollerContainer).find('.nano-pane').is(':hidden')) {
        this.props.onScrollEnd();
      }
    }

    // very strange fix
    setTimeout(() => {
      $(this.refs.scrollerContainer).nanoScroller();
    }, 100);
  }
  componentWillUnmount() {
    $(this.refs.scrollerContainer).nanoScroller({destroy: true});
  }
  componentDidUpdate() {
    $(this.refs.scrollerContainer).nanoScroller();

    if(this.props.scrollOnUpdate) {
      $(this.refs.scrollerContainer).nanoScroller({scroll: 'top'});
    }
  }
  render() {
    return <div ref="scrollerContainer" className={`nano ${this.props.containerClass || ''}`}>
      <div className="overthrow nano-content">
        {this.props.children}
      </div>
    </div>
  }
}
