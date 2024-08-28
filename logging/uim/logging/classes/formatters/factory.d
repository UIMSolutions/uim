module uim.logging.formatters.factory;

import uim.oop;

@safe:

class DLogFormatterFactory : DFactory!DLogFormatter {
}
auto LogFormatterFactory() { return DLogFormatterFactory.factory; }

