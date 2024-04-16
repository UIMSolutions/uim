 module uim.logging.classes.formatters.html;

import uim.logging;

@safe:

class DHtmlLogFormatter : DLogFormatter {
  mixin(LogFormatterThis!("Html"));

  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    return true;
  }
}
mixin(LogFormatterCalls!("Html"));
