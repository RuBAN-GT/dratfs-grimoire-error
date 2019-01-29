class CollectionsView extends React.Component {
  propTypes: {
    collections: React.PropTypes.array,
  }
  defaultProps: {
    collections: []
  }
  componentDidMount() {
    this.slider = new Swiper(this.refs.collectionContainer, {
      slidesPerView: 6,
      slidesPerGroup: 1,
      spaceBetween: 10,
      mousewheelControl: true,
      threshold: 25,
      nextButton: '.arrow.next',
      prevButton: '.arrow.prev',
      lazyLoading: true,
      lazyLoadingInPrevNext: true,
      lazyLoadingInPrevNextAmount: 8,
      lazyPreloaderClass: 'lazy-preloader',
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
  }
  shouldComponentUpdate(nextProps) {
    return (this.props.collections != nextProps.collections);
  }
  componentDidUpdate() {
    this.slider.update(true);
    this.slider.lazy.load();
  }
  render() {
    return <div ref="sth" className="collections view">
      <div className="full cards swiper">
        <div ref="collectionContainer" className="container swiper-container">
          <div className="wrapper swiper-wrapper">
            {this.props.collections.map((item, i) => {
              return <a
                href={item.link}
                key={item.id}
                data-real-id={item.real_id}
                className="card swiper-slide">
                <div className="image">
                  <img className="swiper-lazy" data-src={item.full_picture_url} alt={item.name} />
                  <div className="lazy-preloader">
                    <div className="ui loader inverted large active"></div>
                  </div>
                </div>
                <div className="name">{item.name}</div>
              </a>
            })}
          </div>
        </div>

        <div className="arrow prev swiper-button-prev"></div>
        <div className="arrow next swiper-button-next"></div>
      </div>
    </div>;
  }
}
