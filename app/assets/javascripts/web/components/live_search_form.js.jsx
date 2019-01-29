class LiveSearchForm extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      query: '',
      current: 1,
      next: null,
      wait: false,
      results: []
    }

    this.timer        = null;
    this.handleChange = this.handleChange.bind(this);
    this.searchCards  = this.searchCards.bind(this);
    this.loadMore     = this.loadMore.bind(this);
  }
  searchCards(query, page = 1) {
    if(query.length < 2 || page == null || page < this.state.current) {
      return;
    }

    var self   = this;
    let result = sessionStorage.getItem(`${I18n.locale}.search.${query}.${page}`);

    if(result) {
      result = JSON.parse(result);
      this.setState((prevState) => ({
        results: prevState.results.concat(result.cards),
        current: page,
        next: result.meta.next_page,
        wait: false
      }));
    }
    else {
      functions.async(`/${I18n.locale}/search.json?q=${query}&page=${page}`, 'GET', '', (object) => {
        let results = (object && object.cards) ? object.cards : [];
        let next    = (object && object.meta.next_page) ? object.meta.next_page : null;

        if(results) {
          sessionStorage.setItem(`${I18n.locale}.search.${query}.${page}`, JSON.stringify(object));

          self.setState((prevState) => ({
            results: prevState.results.concat(results),
            current: page,
            next: next,
            wait: false
          }));
        }
      })
    }
  }
  loadMore() {
    this.searchCards(this.state.query, this.state.next);
  }
  handleChange(event) {
    var self  = this;
    var value = event.target.value;

    clearTimeout(this.timer);

    this.timer = setTimeout(function() {
      self.setState({
        query: value,
        current: 1,
        next: null,
        wait: true,
        results: []
      }, function() {
        self.searchCards(value, 1);
      });
    }, 400);
  }
  render() {
    return <div className="livesearch form">
      <div className="input">
        <input type="text" name="q" placeholder={I18n.t('js.search.placeholder')} onChange={this.handleChange} autoFocus />
      </div>

      <div className="results">
        <div className="ui container basic wrapper">
          {!this.state.query &&
            <div className="none message">{I18n.t('js.search.none')}</div>
          }
          {this.state.query && this.state.query.length < 2 &&
            <div className="limit message">{I18n.t('js.search.limit', {min: 2})}</div>
          }
          {this.state.query.length >= 2 && this.state.wait &&
            <div className="ui active centered large inverted loader"></div>
          }
          {this.state.query.length >= 2 && !this.state.wait && !this.state.results.length &&
            <div className="empty message">{I18n.t('js.search.empty')}</div>
          }
          {this.state.results.length > 0 &&
            <Scroller onScrollEnd={this.loadMore}>
              {this.state.results.map((item, i) => {
                return <a className="result" href={item.link} key={item.id} data-real-id={item.real_id}>
                  <div className="image">
                    <img src={item.mini_picture_url} alt={item.name} />
                    {(!item.opened) &&
                      <div className="closed overlay"><i className="lock big icon"></i></div>
                    }
                  </div>
                  <div className="content">
                    <div className="name" dangerouslySetInnerHTML={{__html: item.name}} />
                    <div className="breadcrumbs">
                      <span dangerouslySetInnerHTML={{__html: item.theme.name}} />
                      <span className="divider"></span>
                      <span dangerouslySetInnerHTML={{__html: item.collection.name}} />
                    </div>
                  </div>
                </a>;
              })}
            </Scroller>
          }
        </div>
      </div>
    </div>;
  }
}
