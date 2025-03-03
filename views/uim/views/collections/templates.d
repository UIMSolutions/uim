module uim.views.collections.templates;

import uim.views;
@safe:

version (test_uim_views) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
} 


// An object Collection for Template.
class DTemplateCollection {
    override bool initialize(Json[string] initData = null) {
    writeln("initialize in DHtmlHelper");
    if (!super.initialize(initData)) {
      return false;
    }

    _templates
      .set("meta", "<meta{{attrs}}>")
      .set("metalink", "<link href=\"{{url}}\"{{attrs}}>")
      .set("link", "<a href=\"{{url}}\"{{attrs}}>{{content}}</a>")
      .set("mailto", "<a href=\"mailto:{{url}}\"{{attrs}}>{{content}}</a>")
      .set("image", "<img src=\"{{url}}\"{{attrs}}>")
      .set("tableheader", "<th{{attrs}}>{{content}}</th>")
      .set("tableheaderrow", "<tr{{attrs}}>{{content}}</tr>")
      .set("tablecell", "<td{{attrs}}>{{content}}</td>")
      .set("tablerow", "<tr{{attrs}}>{{content}}</tr>")
      .set("block", "<div{{attrs}}>{{content}}</div>")
      .set("blockstart", "<div{{attrs}}>")
      .set("blockend", "</div>")
      .set("tag", "<{{tag}}{{attrs}}>{{content}}</{{tag}}>")
      .set("tagstart", "<{{tag}}{{attrs}}>")
      .set("tagend", "</{{tag}}>")
      .set("tagselfclosing", "<{{tag}}{{attrs}}/>")
      .set("para", "<p{{attrs}}>{{content}}</p>")
      .set("parastart", "<p{{attrs}}>")
      .set("css", "<link rel=\"{{rel}}\" href=\"{{url}}\"{{attrs}}>")
      .set("style", "<style{{attrs}}>{{content}}</style>")
      .set("charset", "<meta charset=\"{{charset}}\">")
      .set("ul", "<ul{{attrs}}>{{content}}</ul>")
      .set("ol", "<ol{{attrs}}>{{content}}</ol>")
      .set("li", "<li{{attrs}}>{{content}}</li>")
      .set("javascriptblock", "<script{{attrs}}>{{content}}</script>")
      .set("javascriptstart", "<script>")
      .set("javascriptlink", "<script src=\"{{url}}\"{{attrs}}></script>")
      .set("javascriptend", "</script>")
      .set("confirmJs", "{{confirm}}");

    writeln(_templates);
    return true;
  }
}

auto TemplateCollection() {
  return new DTemplateCollection;
}

unittest {
  assert(TemplateCollection);

  auto templates = TemplateCollection;
}