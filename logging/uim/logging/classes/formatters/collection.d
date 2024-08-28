module uim.logging.classes.formatters.collection;

import uim.logging;
@safe:

class DLogFormatterCollection : DCollection!DLogFormatter {   
}
auto LogFormatterCollection() { return new DLogFormatterCollection; }