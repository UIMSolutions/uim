module uim.logging.classes.formatters.text;

import uim.logging;

@safe:
class DTextLogFormatter : DLogFormatter {
mixin(LogFormatterThis!("Text"));
}
mixin(LogFormatterCalls!("Text"));
