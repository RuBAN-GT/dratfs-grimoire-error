class EntriesView extends React.Component {
  propTypes: {
    entries: React.PropTypes.array,
  }
  defaultProps: {
    entries: []
  }
  render() {
    return <div className="entries view">
      <div className="ui equal width grid">
        {this.props.entries.map((item, i) => {
          return <div key={item.id} className="column">
            <div className="entry">
              <p>{item.text}</p>
              <div className="date">
                <a href={item.url} target="_blank">{item.created_at}</a>
              </div>
            </div>
          </div>
        })}
      </div>
    </div>
  }
}
