module uim.i18n.registries.formatter;

import uim.i18n;

@safe:

class DFormatterRegistry : DObjectRegistry!DI18NFormatter {
}

auto FormatterRegistration() {
    return DFormatterRegistry.registration;
}