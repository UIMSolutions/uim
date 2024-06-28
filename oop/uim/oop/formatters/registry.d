module uim.oop.formatters.registry;

import uim.oop;
@safe:

class DFormatterRegistry : DObjectRegistry!DFormatter {
}
auto FormatterRegistry() { return DFormatterRegistry.registry; }