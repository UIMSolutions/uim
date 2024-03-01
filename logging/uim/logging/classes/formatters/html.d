 module logging.uim.logging.classes.formatters.html;

import uim.logging;

@safe:
class DHTMLLogFormatter : DLogFormatter {
  mixin(FormatterThis!("HTML"));

  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);
  }
}
mixin(FormatterCalls!("HTML"));
