module uim.i18n.classes.translators.registry;

import uim.i18n;

@safe:

class DTranslatorRegistry : DObjectRegistry!DTranslator {
}
auto TranslatorRegistry() { 
    return DTranslatorRegistry.registration;
}