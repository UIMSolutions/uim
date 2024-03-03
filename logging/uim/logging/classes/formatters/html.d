 module logging.uim.logging.classes.formatters.html;

import uim.logging;

@safe:
class DHTMLLogFormatter : DLogFormatter {
  mixin(FormatterThis!("HTML"));

  override bool initialize(IData[string] configSettings = null) {
    super.initialize(configSettings);
  }
}
mixin(FormatterCalls!("HTML"));
