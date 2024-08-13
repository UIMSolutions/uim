 module uim.oop.logging.formatters.html;

import uim.oop;

@safe:

class DHtmlLogFormatter : DLogFormatter {
  mixin(LogFormatterThis!("Html"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    return true;
  }
}
mixin(LogFormatterCalls!("Html"));
