module uim.oop.logging.formatters.collection;

import uim.oop;
@safe:

class DLogFormatterCollection : DCollection!DLogFormatter {   
}
auto LogFormatterCollection() { return new DLogFormatterCollection; }