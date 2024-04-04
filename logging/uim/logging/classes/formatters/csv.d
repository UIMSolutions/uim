module uim.logging.classes.formatters.csv;

import uim.logging;

@safe:
class DCsvLogFormatter : DLogFormatter {
  mixin(LogFormatterThis!("Csv"));

  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    return true;
  }
}
mixin(LogFormatterCalls!("Csv"));

