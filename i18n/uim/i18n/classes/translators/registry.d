module uim.i18n.classes.translators.registry;

import uim.i18n;

@safe:

class DTranslatorRegistry : DObjectRegistry!DTranslator {
    static DTranslatorRegistry registry;
}
auto TranslatorRegistry() { 
    return DTranslatorRegistry.registry is null
        ? DTranslatorRegistry.registry = new DTranslatorRegistry
        : DTranslatorRegistry.registry;
}