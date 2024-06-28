module uim.oop.logformatters.collection;

import uim.oop;
@safe:

class DLogFormatterCollection : DCollection!DLogFormatter {   
}
auto LogFormatterCollection() { return new DLogFormatterCollection; }