class ReportWindow extends React.Component {
  propTypes: {
    content: React.PropTypes.string
  }
  defaultProps: {
    content: ''
  }
  constructor(props) {
    super(props);

    this.sendReport = this.sendReport.bind(this);
  }
  componentDidMount() {
    var self = this;

    $(this.refs.reportDialog).modal({
      onApprove() {
        self.sendReport();
      },
      onDeny() {
        self.setState({content: ''});
      }
    })
  }
  componentDidUpdate() {
    var self = this;

    if(this.props.content && this.props.content.length > 2 && this.props.content.length < 1000) {
      $(this.refs.reportDialog).modal('show');
    }
  }
  sendReport() {
    var self = this;

    functions.async('/reports', 'POST', JSON.stringify({
      report: {
        url: window.location.href,
        context: self.props.content
      }
    }), (object) => {
      if(object.meta && object.meta.status == 'Success') {
        functions.pushFlash(I18n.t('js.report.success'));
      }
      else {
        functions.pushFlash(I18n.t('js.report.fail'));
      }
    });

    self.setState({content: ''});
  }
  render() {
    return <div ref="reportDialog" className="ui report basic modal">
      <div className="ui icon header">
        <i className="icon warning circle"></i>
        {I18n.t('js.report.confirm')}
      </div>
      <div className="content">
        <div className="selected">{this.props.content}</div>
      </div>
      <div className="actions">
        <div className="ui red basic cancel inverted button">
          <i className="remove icon"></i>
          {I18n.t('js.report.cancel')}
        </div>
        <div className="ui green ok inverted button">
          <i className="checkmark icon"></i>
          {I18n.t('js.report.ok')}
        </div>
      </div>
    </div>
  }
}
