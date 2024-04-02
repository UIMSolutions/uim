module uim.logging.classes.formatters.xml;

import uim.logging;

@safe:
class DXmlLogFormatter : DLogFormatter {
mixin(LogFormatterThis!("Xml"));
}
mixin(LogFormatterCalls!("Xml"));
