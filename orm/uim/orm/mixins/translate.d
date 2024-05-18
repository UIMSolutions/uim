module uim.orm.mixins.translate;

import uim.orm;

@safe:

// Contains a translation method aimed to help managing multiple translations for an entity.
mixin template TTranslate() {
    /**
     * Returns the entity containing the translated fields for this object and for
     * the specified language. If the translation for the passed language is not
     * present, a new empty entity will be created so that values can be added to
     * it.
     *
     * @param string language Language to return entity for.
     */
    IORMEntity translation(string language) {
        if (language == get("_locale")) {
            return this;
        }

        i18n = get("_translations");
        created = false;

        if (i18n.isEmpty) {
            i18n = null;
            created = true;
        }

        if (created || i18n.isEmpty(language) || !(i18n[language] instanceof IORMEntity)) {
            className = class;

            i18n[language] = new className();
            created = true;
        }

        if (created) {
            set("_translations", i18n);
        }

        // Assume the user will modify any of the internal translations, helps with saving
        setDirty("_translations", true);

        return i18n[language];
    } 
}
