var ArticlesOverview = createReactClass({
  getInitialState: function() {
    return {
      sections: this.props.sections,
      deletedSections: [],
      newSectionName: ""
    };
  },

  componentDidMount: function() {
    $(this.refs.list).sortable({
      handle: "> .handle",
      stop: this.updateSectionPositions
    });

    $(this.refs.input).on("keypress", this.maybeCreateNewSection);
  },

  createNewSection: function() {
    this.state.sections.push({
      id: null,
      name: this.state.newSectionName,
      articles: []
    });

    this.setState({
      sections: this.state.sections,
      newSectionName: ""
    });
  },

  maybeCreateNewSection: function(e) {
    if (e.keyCode == 13) {
      e.preventDefault();
      this.createNewSection();
    }
  },

  updateNewSectionName: function(e) {
    this.setState({ newSectionName: e.target.value });
  },

  updateSectionPositions: function() {
    var self = this;
    var newOrder = [];
    $("> li.section", this.refs.list).each(function(i) {
      newOrder.push(self.state.sections[this.dataset.position]);
    });

    this.setState({ sections: newOrder });
  },

  removeSection: function(i) {
    var section = this.state.sections[i];
    if (confirm('Remove the section "' + section.name + '"?')) {
      this.state.sections.splice(i, 1)

      if (section.id)
        this.state.deletedSections.push(section.id);

      this.setState({
        sections: this.state.sections,
        deletedSections: this.state.deletedSections
      });
    }
  },

  render: function() {
    var self = this;
    var props = this.props;
    var state = this.state;

    var sectionNode = function(section, i) {
      return <ArticleSection key={ "section/" + section.name }
                             overview={ self }
                             id={ section.id }
                             name={ section.name }
                             position={ i }
                             articles={ section.articles }
                             articleOptions={ props.articles } />;
    };

    var deletedSectionNode = function(id) {
      return <input key={ "deleted/" + id }
                    type="hidden"
                    name="deleted_section_ids[]"
                    value={ id } />
    };

    return <ol ref="list">
             { state.sections.map(sectionNode) }

             <li>
               <span className="fa fa-plus btn"
                     onClick={ this.createNewSection } />
               <input ref="input" type="text"
                      value={ this.state.newSectionName }
                      onChange={ this.updateNewSectionName } />

               { state.deletedSections.map(deletedSectionNode) }
             </li>
           </ol>;
  }
});

var ArticleSection = createReactClass({
  getInitialState: function() {
    return {
      articles: this.props.articles,
      articleOptions: this.props.articleOptions
    }
  },

  componentDidMount: function() {
    $(this.refs.options).select2();
    // onchange addArticle

    $(this.refs.list).sortable({
      handle: "> .handle",
      stop: this.updateArticlePositions
    });
  },

  updateArticlePositions: function() {
    var self = this;
    var newOrder = [];
    $("> li.article", this.refs.list).each(function(i) {
      newOrder.push(self.state.articles[this.dataset.position]);
    });

    this.setState({ articles: newOrder });
  },

  addArticle: function() {
    if (this.refs.options.value) {
      this.state.articles.push({
        id: this.refs.options.value,
        name: $("option:selected", this.refs.options).text()
      });

      $(this.refs.options).val(null).trigger("change");

      this.setState({ articles: this.state.articles });
    }
  },

  removeArticle: function(i) {
    var name = this.state.articles[i].name;
    if (confirm('Remove "' + name + '" from this section?')) {
      this.state.articles.splice(i, 1)
      this.setState({ articles: this.state.articles });
    }
  },

  render: function() {
    var self = this;
    var state = this.state;
    var props = this.props;
    var id = this.props.id;

    var articleNode = function(article, j) {
      var i = props.position;
      return <li key={ "article/" + article.id }
                 className="input article"
                 data-position={ j }>
               <input type="hidden"
                      name={ "article_sections[" + i + "][articles_attributes][" + j + "][id]" }
                      value={ article.id } />
               <input type="hidden"
                      name={ "article_sections[" + i + "][articles_attributes][" + j + "][article_section_position]" }
                      value={ j } />

               <span className="handle fa fa-arrows" />

               <span className="handle">{ article.name }</span>

               <span className="fa fa-trash-o"
                     onClick={ self.removeArticle.bind(self, j) } />
             </li>;
    };

    var articleOption = function(article) {
      return <option key={ "option/" + article.id }
                     value={ article.id }>{ article.name }</option>;
    };

    var idInput =
      <input type="hidden"
             name={ "article_sections[" + props.position + "][id]" }
             value={ id } />;

    return <li className="input section" data-position={ props.position }>
             { id ? idInput : "" }

             <input type="hidden"
                    name={ "article_sections[" + props.position + "][position]" }
                    value={ props.position } />

             <input type="hidden"
               name={ "article_sections[" + props.position + "][name]" }
               value={ props.name } />;

             <span className="handle fa fa-arrows" />
             <span className="handle">
               <strong>{ props.name }</strong>
             </span>

             <span className="fa fa-trash-o"
                   onClick={ props.overview.removeSection.bind(props.overview, props.position) } />

             <ol ref="list">
               { state.articles.map(articleNode) }
               <li className="input">
                 <span className="fa fa-plus btn"
                       onClick={ this.addArticle } />
                 <select ref="options">
                   <option value="" />
                   { props.articleOptions.map(articleOption) }
                 </select>
               </li>
             </ol>
           </li>;
  }
});
