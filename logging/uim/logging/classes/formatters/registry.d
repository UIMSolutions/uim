module uim.oop.logging.formatters.registry;

import uim.oop;

@safe:

class DLogFormatterRegistry : DObjectRegistry!DLogFormatter {
}

auto LogFormatterRegistry() {
    return DLogFormatterRegistry.registry;
}
