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
     */
    IORMEntity translation(string language) {
        if (language == get("_locale")) {
            return this;
        }

        auto i18n = get("_translations");
        auto isCreated = false;

        if (i18n.isEmpty) {
            i18n = null;
            isCreated = true;
        }

        if (isCreated || i18n.isEmpty(language) || !(cast(IORMEntity)i18n[language])) {
            /* classname = class;

            i18n[language] = new classname();
            isCreated = true; */
        }

        /* if (isCreated) {
            set("_translations", i18n);
        } */

        // Assume the user will modify any of the internal translations, helps with saving
        setDirty("_translations", true);

        // return i18n[language];
        return null;
    } 
}
