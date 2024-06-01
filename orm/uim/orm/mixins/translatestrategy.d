module uim.orm.mixins.translatestrategy;

import uim.orm;

@safe:

// Contains common code needed by TranslateBehavior strategy classes.
mixin template TTranslateStrategy() {
    // Table instance
    protected DORMTable table;

    /**
     * The locale name that will be used to override fields in the bound table
     * from the translations table
     */
    protected string locale;

    // Instance of Table responsible for translating
    protected DORMTable translationTable;

    // Return translation table instance.
    DORMTable getTranslationTable() {
        return _translationTable;
    }

    /**
     * Sets the locale to be used.
     *
     * When fetching records, the content for the locale set via this method,
     * and likewise when saving data, it will save the data in that locale.
     *
     * Note that in case an entity has a `_locale` property set, that locale
     * will win over the locale set via this method (and over the globally
     * configured one for that matter)!
     *
     * @param string locale The locale to use for fetching and saving
     *  records. Pass `null` in order to unset the current locale, and to make
     *  the behavior fall back to using the globally configured locale.
     */
    void setLocale(string locale) {
        this.locale = locale;
    }

    /**
     * Returns the current locale.
     *
     * If no locale has been explicitly set via `setLocale()`, this method will return
     * the currently configured global locale.
     */
    string locale() {
        return _locale ?: I18n.locale();
    }

    /**
     * Unset empty translations to avoid persistence.
     *
     * Should only be called if configuration.get("allowEmptyTranslations"] is false.
     *
     * @param DORMDatasource\IORMEntity anEntity The entity to check for empty translations fields inside.
     */
    protected void unsetEmptyFields(entity) {
        /** @var array<DORMEntity> translations */
        translations = (array)entity.get("_translations");
        foreach (translations as locale: translation) {
            fields = translation.extract(configuration.get("fields"], false);
            foreach (fields as field: value) {
                if (value == null || value == "") {
                    translation.unset(field);
                }
            }

            translation = translation.extract(configuration.get("fields"]);

            // If now, the current locale property is empty,
            // unset it completely.
            if (array_filter(translation).isEmpty) {
                unset(entity.get("_translations")[locale]);
            }
        }

        // If now, the whole _translations property is empty,
        // unset it completely and return
        if (entity..isEmpty("_translations"))) {
            entity.unset("_translations");
        }
    }

    /**
     * Build a set of properties that should be included in the marshalling process.

     * Add in `_translations` marshalling handlers. You can disable marshalling
     * of translations by setting `"translations": false.toJson` in the options
     * provided to `Table.newEntity()` or `Table.patchEntity()`.
     *
     * @param DORMMarshaller marshaller The marhshaller of the table the behavior is attached to.
     * @param Json[string] map The property map being built.
     * @param Json[string] options The options array used in the marshalling call.
     */
    Json[string] buildMarshalMap(DMarshaller marshaller, Json[string] map, Json[string] optionData) {
        if (isset(options["translations"]) && !options["translations"]) {
            return [];
        }

        return [
            "_translations": function (value, entity) use (marshaller, options) {
                if (!(value.isArray) {
                    return null;
                }

                /** @var array<string, DORMDatasource\IORMEntity>|null translations */
                translations = entity.get("_translations");
                if (translations == null) {
                    translations = null;
                }

                options["validate"] = configuration.get("validator"];
                errors = null;
                foreach (value as language: fields) {
                    if (!translations.hasKey(language)) {
                        translations[language] = this.table.newEmptyEntity();
                    }
                    marshaller.merge(translations[language], fields, options);

                    translationErrors = translations[language].getErrors();
                    if (translationErrors) {
                        errors[language] = translationErrors;
                    }
                }

                // Set errors into the root entity, so validation errors match the original form data position.
                if (errors) {
                    entity.setErrors(["_translations": errors]);
                }

                return translations;
            },
        ];
    }

    /**
     * Unsets the temporary `_i18n` property after the entity has been saved
     *
     * @param DORMevents.IEvent event The beforeSave event that was fired
     * @param DORMDatasource\IORMEntity anEntity The entity that is going to be saved
     */
    void afterSave(IEvent event, IORMEntity anEntity) {
        entity.unset("_i18n");
    }
}
