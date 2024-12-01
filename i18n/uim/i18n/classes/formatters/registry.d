module uim.i18n.classes.formatters.registry;

import uim.i18n;

@safe:

class DFormatterRegistry : DObjectRegistry!DI18NFormatter {
    static DFormatterRegistry registry;
}

auto FormatterRegistry() {
    return DFormatterRegistry.registry is null
        ? DFormatterRegistry.registry = new DFormatterRegistry
        : DFormatterRegistry.registry;
}