module uim.i18n.classes.formatters.registry;

import uim.i18n;

@safe:

class DFormatterRegistry : DObjectRegistry!DI18NFormatter {
}

auto FormatterRegistry() {
    return DFormatterRegistry.registry;
}