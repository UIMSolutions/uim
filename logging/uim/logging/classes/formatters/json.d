module logging.uim.logging.classes.formatters.json;

import uim.logging;

@safe:
class DJsonLogFormatter : DLogFormatter {
  mixin(LogFormatterThis!("Json"));

  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    return true;
  }
}
mixin(LogFormatterCalls!("Json"));