module uim.logging.formatters.registry;

import uim.logging;

@safe:

class DLogFormatterRegistry : DObjectRegistry!DLogFormatter {
}

auto LogFormatterRegistry() {
    return DLogFormatterRegistry.registry;
}
