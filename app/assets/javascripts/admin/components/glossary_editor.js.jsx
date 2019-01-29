class GlossaryEditor extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      glossary: [],
      editable: null
     };

    this.getGlossary    = this.getGlossary.bind(this);
    this.enableEditing  = this.enableEditing.bind(this);
    this.disableEditing = this.disableEditing.bind(this);
    this.createElement  = this.createElement.bind(this);
    this.updateElement  = this.updateElement.bind(this);
    this.removeElement  = this.removeElement.bind(this);
  }
  componentWillMount() {
    this.getGlossary()
  }
  getGlossary() {
    var self = this;

    functions.async('/tooltips', 'GET', '', (object) => {
      self.setState({
        glossary: object.tooltips
      });
    });
  }
  componentDidMount() {
    this.inputSlug = document.getElementById('input-slug');
    this.inputBody = document.getElementById('input-body');

    this.inputReplacement = document.getElementById('input-replacement');

    $('.ui.checkbox').checkbox();
  }
  createElement() {
    this.disableEditing();

    var self = this;

    let slug = this.inputSlug.value;
    let body = this.inputBody.value;
    let repl = this.inputReplacement.checked;

    functions.async('/tooltips', 'POST', JSON.stringify({
        tooltip: {
          slug: slug,
          body: body,
          replacement: repl
        }
      }),
      (object) => {
        $(self.inputSlug).parents('.field').removeClass('error');
        $(self.inputBody).parents('.field').removeClass('error');

        if(object.meta.status == 'Success') {
          this.inputSlug.value = '';
          this.inputBody.value = '';

          self.setState((prevState) => {
            let glossary = prevState.glossary;

            glossary.unshift(object.tooltip);

            return { glossary: glossary }
          });
        }
        else {
          if(object.meta.errors.slug) {
            $(self.inputSlug).parents('.field').addClass('error');
          }
          if(object.meta.errors.body) {
            $(self.inputBody).parents('.field').addClass('error');
          }
        }
      }
    );
  }
  updateElement() {
    var self = this;

    let slug = this.slugCell.value();
    let body = this.bodyCell.value();
    let repl = this.replacementCell.checked;

    functions.async(`/tooltips/${this.state.editable.id}`, 'PUT', JSON.stringify({
        tooltip: {
          slug: slug,
          body: body,
          replacement: repl
        }
      }),
      (object) => {
        if(object.meta.status == 'Success') {
          self.currentRow.removeClass('error');

          self.setState((prevState) => {
            let glossary = prevState.glossary;

            let index = glossary.findIndex((item) => {
              return item.id == prevState.editable.id
            });

            glossary.splice(index, 1);
            glossary.splice(index, 0, object.tooltip);

            return {
              glossary: glossary,
              editable: object.tooltip
            }
          }, self.disableEditing);
        }
        else {
          self.currentRow.addClass('error');
        }
      }
    );
  }
  removeElement(id) {
    this.disableEditing();

    var self = this;

    functions.async(`/tooltips/${id}`, 'DELETE', '', (object) => {
      self.setState((prevState) => {
        let glossary = prevState.glossary;

        let index = glossary.findIndex((item) => {
          return item.id == id
        });

        glossary.splice(index, 1);

        return { glossary: glossary }
      });
    });
  }
  disableEditing() {
    if(!this.state.editable) {
      return;
    }

    let item = this.state.editable;

    let element = document.querySelector(`.tooltips .item[data-id="${item.id}"] .slug`);
    element.setAttribute('contenteditable', false);
    this.slugCell.value(item.slug);
    this.slugCell = null;

    element = document.querySelector(`.tooltips .item[data-id="${item.id}"] .body`);
    element.setAttribute('contenteditable', false);
    this.bodyCell.value(item.body);
    this.bodyCell = null;

    this.currentRow = null;
    this.setState({
      editable: null
    });
  }
  enableEditing(item) {
    this.disableEditing();

    this.setState({
      editable: item
    });

    let element = document.querySelector(`.tooltips .item[data-id="${item.id}"] .slug`);
    element.setAttribute('contenteditable', true);
    this.slugCell = new Medium({
      element: element,
      mode: Medium.inlineMode,
      autofocus: true
    });

    this.currentRow = $(element).parents('tr');

    element = document.querySelector(`.tooltips .item[data-id="${item.id}"] .body`);
    element.setAttribute('contenteditable', true);
    this.bodyCell = new Medium({
      element: element,
      mode: Medium.inlineMode,
      autofocus: false
    });

    this.replacementCell = document.querySelector(`.tooltips .item[data-id="${item.id}"] .replacement input`);
  }
  render() {
    function changeCheckbox(event) {
      $('.ui.checkbox').checkbox();
    }

    return <div className="glossary editor">
      <div className="content">
        <div className="ui new form">
          <div className="two fields">
            <div className="field">
              <label htmlFor="input-slug">{I18n.t('js.glossary.slug')}</label>
              <input id="input-slug" name="slug" type="text" />
            </div>
            <div className="field">
              <label htmlFor="input-body">{I18n.t('js.glossary.body')}</label>
              <input id="input-body" name="body" type="text" />
            </div>
          </div>
          <div className="field">
            <div className="ui checkbox">
              <input id="input-replacement" type="checkbox" name="replacement" value={true} />
              <label>{I18n.t('js.glossary.replacement')}</label>
            </div>
          </div>

          <button className="ui positive fluid button" onClick={this.createElement}>{I18n.t('js.editor.add')}</button>
        </div>

        <div className="body">
          {(this.state.glossary.length > 0) ? (
            <Scroller alwaysVisible={true} scrollOnUpdate={true}>
              <table className="ui inverted compact very basic selectable celled table tooltips">
                <tbody>
                  {this.state.glossary.map((item, i) => {
                    return <tr className={`item ${this.state.editable == item ? 'editable' : ''}`} data-id={item.id} key={item.id}>
                      <td className="slug" contentEditable={false}>{item.slug}</td>
                      <td className="body" contentEditable={false}>{item.body}</td>
                      <td className="replacement">
                        <div className={`ui fitted ${this.state.editable != item ? 'disabled' : ''} checkbox`} title={I18n.t('js.glossary.replacement')}>
                          <input type="checkbox" checked={item.replacement} onChange={changeCheckbox} />
                          <label></label>
                        </div>
                      </td>
                      <td className="tools">
                        {(this.state.editable == item) ? (
                          <button className="ui positive edit button icon" onClick={() => {this.updateElement()}}><i className="check icon"></i></button>
                        ) : (
                          <button className="ui blue edit button icon" onClick={() => {this.enableEditing(item)}}><i className="edit icon"></i></button>
                        )}
                        <button className="ui red remove button icon" onClick={() => {this.removeElement(item.id)}}><i className="trash icon"></i></button>
                      </td>
                    </tr>
                  })}
                </tbody>
              </table>
            </Scroller>
          ) : (
            <div className="ui message">{I18n.t('js.glossary.empty')}</div>
          )}
        </div>
      </div>
    </div>
  }
}
