module uim.html.components.component;

@safe:
import uim.html;

class DH5Component {
  this() {
    this.css(CSSMediaQueries);
  }

  mixin(OProperty!("DCSSMediaQueries", "css"));
  mixin(XString!("html"));
  mixin(XString!("js"));

  override string toString() {
    string result;
    result ~= "<style>"~_css.toString~"</style>";
    if (html.length > 0) result ~= html;
    if (js.length > 0) result ~= "<script>"~_js~"</script>";
    return "";
  }
}
auto H5Component() { return new DH5Component(); }

version(test_uim_html) { unittest {
  assert(H5Component);
}}