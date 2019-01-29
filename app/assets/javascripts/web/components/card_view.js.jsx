class CardView extends React.Component {
  propTypes: {
    current: React.PropTypes.string,
    user: React.PropTypes.string,
    theme: React.PropTypes.array,
    collection: React.PropTypes.array,
    cards: React.PropTypes.array,
    meta: React.PropTypes.array
  }
  defaultProps: {
    user: "",
    theme: [],
    collection: [],
    cards: [],
    current: null,
    meta: []
  }
  constructor(props) {
    super(props);

    let card = null;

    if(this.props.current) {
      card = this.props.cards.find((item) => {
        return item.real_id == this.props.current
      });
    }

    if(!card) { card = this.props.cards[0]; }

    this.state = {
      cards: this.props.cards,
      card: card,
      next_page: this.props.meta.next_page,
      opened: card.opened,
      original: false,
      report: ''
    };

    this.changeCard = this.changeCard.bind(this);

    this.toggleReadStatus = this.toggleReadStatus.bind(this);
    this.toggleOpenStatus = this.toggleOpenStatus.bind(this);
    this.toggleOrigStatus = this.toggleOrigStatus.bind(this);
  }
  changeCard(card) {
    this.setState({
      card: card,
      opened: false,
      original: false,
      report: ''
    }, this.enableTooltip);

    window.history.pushState(null, card.name, card.link);

    document.title = card.name;
  }
  enableTooltip() {
    $('.tooltiped').popup({ variation: 'inverted' });
  }
  componentDidMount() {
    let self    = this;
    let started = $(this.refs.cardsSection).
      find(`[data-real-id="${this.state.card.real_id}"]`).
      index();

    // Cards slider
    this.slider = new Swiper(this.refs.cardsContainer, {
      initialSlide: started,
      slidesPerView: 7,
      slidesPerGroup: 1,
      spaceBetween: 10,
      mousewheelControl: true,
      threshold: 25,
      nextButton: '.arrow.next',
      prevButton: '.arrow.prev',
      preloadImages: false,
      lazyLoading: true,
      lazyLoadingInPrevNext: true,
      lazyLoadingInPrevNextAmount: 7,
      lazyPreloaderClass: 'lazy-preloader',
      onReachEnd(swiper) {
        if(!self.state.next_page) { return null; }

        functions.async(`${self.props.collection.link}.json?page=${self.state.next_page}`, 'GET', '', (object) => {
          self.setState({ next_page: object.meta.next_page });

          if(object.cards) {
            self.setState((prevState) => ({
              cards: prevState.cards.concat(object.cards),
            }), () => {
              self.slider.update(true);
            });
          }
        });
      },
      breakpoints: {
        776: {
          slidesPerView: 'auto'
        },
        991: {
          slidesPerView: 'auto'
        },
        1199: {
          slidesPerView: 4
        }
      }
    });
    this.slider.lazy.load();

    // Enable tooltips
    this.enableTooltip();

    // Error report
    $(this.refs.info).keydown((event) => {
      if(event.ctrlKey && event.keyCode == 13) {
        let text = this.getSelectionText();

        if(!text || text.length < 3) { return }

        self.setState({report: text});
      }
    });
  }
  toggleReadStatus() {
    if(!this.props.user) { return }

    functions.async(`${this.state.card.link}/read`, 'PUT', '', (object) => {
      if(object.meta && object.meta.status == 'Success') {
        this.setState((prevState) => {
          let card = prevState.card;

          card.readed = object.card.readed;

          return {card: card};
        }, this.enableTooltip);
      }
    });
  }
  toggleOpenStatus() {
    if(!this.props.user || this.state.card.opened) { return }

    this.setState((prevState) => ({
      opened: !prevState.opened
    }), this.enableTooltip);
  }
  toggleOrigStatus() {
    this.setState((prevState) => ({
      original: !prevState.original
    }), this.enableTooltip);
  }
  getSelectionText() {
    let text = '';

    if (window.getSelection) {
      text = window.getSelection().toString();
    }
    else if(document.selection && document.selection.type != 'Control') {
      text = document.selection.createRange().text;
    }

    return text;
  }
  render() {
    return <div className="card view">
      <div className="basic wrapper">
        <div className="breadcrumbs">
          <a href={this.props.theme.link} dangerouslySetInnerHTML={{__html: this.props.theme.name}} />
          <span className="divider"></span>
          <span dangerouslySetInnerHTML={{__html: this.props.collection.name}} />
          <span className="divider"></span>
          <span className="current" dangerouslySetInnerHTML={{__html: this.state.original ? this.state.card.untranslated_name : this.state.card.name}} />
        </div>

        <div className="grid">
          <div className="poster">
            <div className="picture">
              <img src={this.state.card.full_picture_url} alt={this.state.card.name} />
              {(this.props.user && !this.state.card.opened && !this.state.opened) &&
                <div className="closed overlay"><i className="lock massive icon"></i></div>
              }
            </div>

            {(this.props.user || I18n.locale != 'en') &&
              <div className="user menu">
                {this.props.user &&
                  <div className="personal menu">
                    {this.state.card.readed ? (
                      <i className="icon tooltiped remove bookmark" title={I18n.t('js.cards.unread')} onClick={this.toggleReadStatus}></i>
                    ) : (
                      <i className="icon tooltiped bookmark" title={I18n.t('js.cards.read')} onClick={this.toggleReadStatus}></i>
                    )}

                    {(!this.state.card.opened) && (
                      this.state.opened ? (
                        <i onClick={this.toggleOpenStatus} className="icon tooltiped hide" title={I18n.t('js.cards.hide')}></i>
                      ) : (
                        <i onClick={this.toggleOpenStatus} className="icon tooltiped unhide" title={I18n.t('js.cards.show')}></i>
                      )
                    )}
                  </div>
                }

                {I18n.locale != 'en' &&
                  <div className="lang menu">
                    {this.state.original ? (
                      <i onClick={this.toggleOrigStatus} className="icon tooltiped selected radio" title={I18n.t('js.cards.translated')}></i>
                    ) : (
                      <i onClick={this.toggleOrigStatus} className="icon tooltiped radio" title={I18n.t('js.cards.original')}></i>
                    )}
                  </div>
                }
              </div>
            }
          </div>
          <div ref="info" className="info">
            {(this.props.user && !this.state.card.opened && !this.state.opened) ? (
              <div className="content unopened">{I18n.t('js.cards.hidden_content')}</div>
            ) : (
              <div className="content opened">
                <Scroller containerClass="mobile hidden" scrollOnUpdate={true}>
                  {this.state.card.intro &&
                    <div className="intro" dangerouslySetInnerHTML={{__html: this.state.original ? this.state.card.untranslated_intro : this.state.card.intro}} />
                  }
                  {this.state.card.description &&
                    <div className="description" dangerouslySetInnerHTML={{__html: this.state.original ? this.state.card.untranslated_description : this.state.card.description}} />
                  }
                </Scroller>
                <div className="mobile only">
                  {this.state.card.intro &&
                    <div className="intro" dangerouslySetInnerHTML={{__html: this.state.original ? this.state.card.untranslated_intro : this.state.card.intro}} />
                  }
                  {this.state.card.description &&
                    <div className="description" dangerouslySetInnerHTML={{__html: this.state.original ? this.state.card.untranslated_description : this.state.card.description}} />
                  }
                </div>
              </div>
            )}
          </div>
        </div>
      </div>

      <div className="cards section" ref="cardsSection">
        <div className="full cards swiper">
          <div ref="cardsContainer" className="container swiper-container">
            <div className="wrapper swiper-wrapper">
              {this.state.cards.map((item, i) => {
                return <div
                  key={item.id}
                  data-real-id={item.real_id}
                  onClick={() => this.changeCard(item)}
                  className={`card swiper-slide ${item == this.state.card ? 'active' : ''}`}>
                  <div className="image">
                    <img className="swiper-lazy" data-src={item.full_picture_url} alt={item.name} />
                    <div className="lazy-preloader">
                      <div className="ui loader inverted large active"></div>
                    </div>
                    {(this.props.user && !item.opened) &&
                      <div className="closed overlay"><i className="lock huge icon"></i></div>
                    }
                  </div>

                  {(item == this.state.card) ? (
                    <div className="name" dangerouslySetInnerHTML={{__html: this.state.original ? this.state.card.untranslated_name : this.state.card.name}} />
                  ) : (
                    <div className="name" dangerouslySetInnerHTML={{__html: item.name}} />
                  )}
                </div>
              })}
            </div>
          </div>

          <div className="arrow prev swiper-button-prev"></div>
          <div className="arrow next swiper-button-next"></div>
        </div>
      </div>

      {I18n.locale != 'en' &&
        <ReportWindow content={this.state.report} />
      }
    </div>
  }
}
