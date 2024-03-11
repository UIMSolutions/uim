 module logging.uim.logging.classes.formatters.html;

import uim.logging;

@safe:
class DHTMLLogFormatter : DLogFormatter {
  mixin(FormatterThis!("HTML"));

  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    return true;
  }
}
// mixin(FormatterCalls!("HTML"));
