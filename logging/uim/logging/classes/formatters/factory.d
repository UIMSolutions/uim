module uim.logging.classes.formatters.factory;

import uim.logging;

@safe:

class DLogFormatterFactory : DFactory!DLogFormatter {
}
auto LogFormatterFactory() { return DLogFormatterFactory.factory; }

