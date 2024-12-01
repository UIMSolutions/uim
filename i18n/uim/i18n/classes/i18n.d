module uim.i18n.classes.i18n;

import uim.i18n;

@safe:

class DI18N : UIMObject {
    this() {
        super();
    }
    // Default locale
    const string DEFAULT_LOCALE = "en_US";

    // The translators collection
    protected static DTranslatorRegistry _collection = null;

    // The environment default locale
    protected static string _defaultLocale = null;

}
