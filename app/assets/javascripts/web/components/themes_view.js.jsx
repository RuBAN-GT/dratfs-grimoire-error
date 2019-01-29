class ThemesView extends React.Component {
  propTypes: {
    themes: React.PropTypes.array,
    current: React.PropTypes.string,
    entries: React.PropTypes.array
  }
  defaultProps: {
    current: null,
    themes: [],
    entries: []
  }
  constructor(props) {
    super(props);

    let theme = null;
    if(this.props.current) {
      theme = this.props.themes.find((item) => {
        return item.real_id == this.props.current
      });
    }
    this.state = {
      theme: theme,
      collections: null
    };

    this.loadCollection = this.loadCollection.bind(this);
    this.changeTheme    = this.changeTheme.bind(this);
  }
  componentDidMount() {
    var self = this;
    let started = 3;

    if(this.state.theme) {
      this.loadCollection(this.state.theme);

      started = $(this.refs.themesCards).find(`[data-real-id="${this.props.current}"]`).index();
    }

    $(this.refs.themesCards).coverflow({
      index: started,
      innerAngle: 0,
      outerAngle: 0,
      enableWheel: false,
      enableKeyboard: 'focus',
      width: 300,
      height: 385,
      select(event, current) {
        if(!self.refs.themesCards) { return }

        if($(self.refs.themesCards).attr('data-init') == 2) {
          self.changeTheme(current.getAttribute('data-key'));
        }
        else {
          $(self.refs.themesCards).attr('data-init', Number($(self.refs.themesCards).attr('data-init')) + 1);
        }
      },
      confirm(event, current) {
        self.changeTheme(current.getAttribute('data-key'));
      }
    });
  }
  changeTheme(index) {
    let theme = this.props.themes[index];

    if(this.state.theme == theme) { return }

    this.setState({theme: theme});

    window.history.pushState(null, theme.name, theme.link);

    document.title = theme.name;

    this.loadCollection(theme);
  }
  loadCollection(theme) {
    let collections = sessionStorage.getItem(`${I18n.locale}.collections.${theme.real_id}`);

    if(collections) {
      this.setState({collections: JSON.parse(collections)});
    }
    else {
      var self = this;

      functions.async(`${theme.link}.json`, 'GET', '', (object) => {
        if(object.theme && object.theme.collections) {
          sessionStorage.setItem(`${I18n.locale}.collections.${theme.real_id}`, JSON.stringify(object.theme.collections));

          self.setState({collections: object.theme.collections});
        }
      })
    }
  }
  render() {
    return <div className="themes view">
      <div className="basic wrapper">
        <div ref="themesCards" className="full cards coverflow" data-init="0">
          {this.props.themes.map((item, i) => {
            return <div
              className="card coverflow"
              key={item.id}
              data-key={i}
              data-real-id={item.real_id}>
              <div className="image">
                <img src={item.full_picture_url} alt={item.name} />
              </div>
              <div className="name">{item.name}</div>
            </div>;
          })}
        </div>
      </div>

      {this.state.theme && this.state.collections ? (
        <CollectionsView collections={this.state.collections} />
      ) : (
        <EntriesView entries={this.props.entries} />
      )}
    </div>;
  }
}
