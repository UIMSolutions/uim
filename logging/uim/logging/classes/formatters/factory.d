module uim.logging.formatters.factory;

import uim.logging;

@safe:

class DLogFormatterFactory : DFactory!DLogFormatter {
}
auto LogFormatterFactory() { return DLogFormatterFactory.factory; }

