class CardViewEditor extends CardView {
  constructor(props) {
    super(props);

    this.state.collection = this.props.collection;

    this.updateCards = this.updateCards.bind(this);

    this.enableGlossary  = this.enableGlossary.bind(this);
    this.disableGlossary = this.disableGlossary.bind(this);

    this.disableEditor = this.disableEditor.bind(this);
    this.enableEditor  = this.enableEditor.bind(this);
    this.saveData      = this.saveData.bind(this);
  }
  updateCards(callback = null) {
    var self = this;

    functions.async(this.props.collection.link, 'GET', '', (object) => {
      self.setState((prevState) => {
        let current = object.cards.find((item) => {
          return item.id == prevState.card.id
        });

        return {
          cards: object.cards,
          card: current
        }
      }, this.enableTooltip);
    });
  }
  enableGlossary() {
    this.setState({
      glossary: true
    });
  }
  disableGlossary() {
    this.setState({
      glossary: false
    }, this.updateCards);
  }
  enableEditor() {
    this.setState((prevState) => ({
      editable: true
    }), () => {
      document.querySelectorAll('.ckeditor').forEach((item, i) => {
        this[`${item.id}Input`] = CKEDITOR.inline(item.id, {
          toolbar: 'mini'
        });

        this[`${item.id}Input`].on('change', () => {
          $('.nano').nanoScroller();
        });
      });

      this.nameInput = new Medium({
        element: document.getElementById('name'),
        mode: Medium.inlineMode
      });

      this.collectionInput = new Medium({
        element: document.getElementById('collection'),
        mode: Medium.inlineMode
      });

      this.replacementInput = document.querySelector('#replacement input');
      this.glossaryInput    = document.querySelector('#glossary input');

      $('.ui.checkbox').checkbox();
    });
  }
  disableEditor() {
    this.setState((prevState) => ({
      editable: false
    }), () => {
      document.querySelectorAll('.ckeditor').forEach((item, i) => {
        this[`${item.id}Input`].setData(this.state.card[item.id]);
        this[`${item.id}Input`].destroy();

        this[`${item.id}Input`] = null;
      });

      this.nameInput.value(this.state.card.name);
      this.collectionInput.value(this.props.collection.name);

      this.enableTooltip();
    });
  }
  saveData() {
    if(!this.state.editable) {
      return;
    }

    let collection  = this.collectionInput.value();
    let name        = this.nameInput.value();
    let intro       = this.introInput.getData();
    let description = this.descriptionInput.getData();
    let replacement = this.replacementInput.checked;
    let glossary    = this.glossaryInput.checked;

    let token = document.querySelector('meta[name="csrf-token"]').content;

    functions.async(this.props.collection.link, 'PUT', JSON.stringify({
      collection: {
        name: collection,
        cards_attributes: {
          id: this.state.card.id,
          name: name,
          intro: intro,
          description: description,
          replacement: replacement,
          glossary: glossary
        }
      }}),
      (object) => {
        if(object.meta && object.meta.status == 'Success') {
          this.setState((prevState) => {
            let card       = prevState.card;
            let collection = prevState.collection;

            collection.name = object.collection.name;

            let current = object.collection.cards.find((item) => {
              return item.id == card.id
            });

            if(current) {
              return {
                collection: collection,
                card: Object.assign(card, current)
              };
            }
          }, this.disableEditor);
        }
        else {
          alert('error');

          console.log(object);
        }
      }
    );
  }
  render() {
    return <div className="card view editor">
      <div className="basic wrapper">
        <div className="toolbox">
          <div className="breadcrumbs">
            <a href={this.props.theme.link} dangerouslySetInnerHTML={{__html: this.props.theme.name}} />
            <span className="divider"></span>
            <span id="collection" contentEditable={this.state.editable} dangerouslySetInnerHTML={{__html: this.props.collection.name}} />
            <span className="divider"></span>
            <span id="name" className="current" contentEditable={this.state.editable} dangerouslySetInnerHTML={{__html: this.state.editable ? this.state.card.original_name : this.state.card.name}} />
          </div>

          <div className="ui actions basic right aligned nopadded segment mobile hidden">
            {this.state.editable &&
              <div className="ui positive button" onClick={this.saveData}>{I18n.t('js.editor.save')}</div>
            }
            {this.state.editable &&
              <div className="ui negative positive button" onClick={this.disableEditor}>{I18n.t('js.editor.cancel')}</div>
            }
            {!this.state.editable &&
              <div className="ui blue button" onClick={this.enableEditor}>{I18n.t('js.editor.edit')}</div>
            }
            <div onClick={this.enableGlossary} className="ui teal icon button">
              <i className="list icon"></i>
            </div>
          </div>
        </div>

        <div className="grid">
          <div ref="posterColumn" className="poster">
            <div className="picture">
              <img src={this.state.card.full_picture_url} alt={this.state.card.name} />
            </div>
          </div>
          <div className="info">
            <Scroller containerClass="content" scrollOnUpdate={true}>
              {(this.state.card.intro || this.state.editable) &&
                <div id="intro" contentEditable={this.state.editable} className="intro ckeditor" dangerouslySetInnerHTML={{__html: this.state.editable ? this.state.card.original_intro : this.state.card.intro}} />
              }
              {(this.state.card.description || this.state.editable) &&
                <div id="description" contentEditable={this.state.editable} className="description ckeditor" dangerouslySetInnerHTML={{__html: this.state.editable ? this.state.card.original_description : this.state.card.description}} />
              }
              {this.state.editable &&
                <div className="checkboxes">
                  <div id="replacement" className="replacement field">
                    <div className="ui checkbox">
                      <input type="checkbox" name="replacement" checked={this.state.card.replacement} onChange={() => {}} />
                      <label>{I18n.t('js.editor.replacement')}</label>
                    </div>
                  </div>
                  <div id="glossary" className="glossary field">
                    <div className="ui checkbox">
                      <input type="checkbox" name="glossary"  checked={this.state.card.glossary} onChange={() => {}} />
                      <label>{I18n.t('js.editor.glossary')}</label>
                    </div>
                  </div>
                </div>
              }
            </Scroller>
            <div className="content mobile only">
              {this.state.card.intro &&
                <div className="intro" dangerouslySetInnerHTML={{__html: this.state.card.intro}} />
              }
              {this.state.card.description &&
                <div className="description" dangerouslySetInnerHTML={{__html: this.state.card.description}} />
              }
            </div>
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
                  </div>
                  <div className="name" dangerouslySetInnerHTML={{__html: item.name}} />
                </div>
              })}
            </div>
          </div>

          <div className="arrow prev swiper-button-prev"></div>
          <div className="arrow next swiper-button-next"></div>
        </div>
      </div>

      {this.state.glossary &&
        <div className="glossary panel">
          <div className="header">
            <span className="ui header">{I18n.t('js.glossary.glossary')}</span>
            <i onClick={this.disableGlossary} className="icon close"></i>
          </div>

          <div className="container">
            <GlossaryEditor />
          </div>
        </div>
      }
    </div>
  }
}
