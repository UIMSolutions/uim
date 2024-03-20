module uim.orm.behaviors\Translate;

import uim.orm;

@safe:

/*
/**
 * Contains common code needed by TranslateBehavior strategy classes.
 */
template TranslateStrategyTemplate {
    /**
     * Table instance
     *
     * @var \UIM\ORM\Table
     */
    protected Table mytable;

    /**
     * The locale name that will be used to override fields in the bound table
     * from the translations table
     */
    protected string mylocale = null;

    /**
     * Instance of Table responsible for translating
     */
    protected Table mytranslationTable;

    /**
     * Return translation table instance.
     */
    Table getTranslationTable() {
        return this.translationTable;
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
     * Params:
     * string mylocale The locale to use for fetching and saving
     *  records. Pass `null` in order to unset the current locale, and to make
     *  the behavior fall back to using the globally configured locale.
     */
    void setLocale(string mylocale) {
        this.locale = mylocale;
    }
    
    /**
     * Returns the current locale.
     *
     * If no locale has been explicitly set via `setLocale()`, this method will return
     * the currently configured global locale.
     */
    string getLocale() {
        return this.locale ?: I18n.getLocale();
    }
    
    /**
     * Unset empty translations to avoid persistence.
     *
     * Should only be called if configuration.data("allowEmptyTranslations"] is false.
     * Params:
     * \UIM\Datasource\IEntity myentity The entity to check for empty translations fields inside.
     */
    protected void unsetEmptyFields(IEntity myentity) {
        Entity[] mytranslations = (array)myentity.get("_translations");
        foreach (mytranslations as mylocale: mytranslation) {
            myfields = mytranslation.extract(configuration.data("fields"], false);
            foreach (field: myvalue; myfields) {
                if (myvalue.isNull || myvalue.isEmpty) {
                    mytranslation.unset(field);
                }
            }
            mytranslation = mytranslation.extract(configuration.data("fields"]);

            // If now, the current locale property is empty,
            // unset it completely.
            if (isEmpty(array_filter(mytranslation))) {
                unset(myentity.get("_translations")[mylocale]);
            }
        }
        // If now, the whole _translations property is empty,
        // unset it completely and return
        if (isEmpty(myentity.get("_translations"))) {
            myentity.remove("_translations");
        }
    }
    
    /**
     * Build a set of properties that should be included in the marshalling process.

     * Add in `_translations` marshalling handlers. You can disable marshalling
     * of translations by setting `"translations": false` in the options
     * provided to `Table.newEntity()` or `Table.patchEntity()`.
     * Params:
     * \UIM\ORM\Marshaller mymarshaller The marhshaller of the table the behavior is attached to.
     * @param array mymap The property map being built.
     * @param IData[string] options The options array used in the marshalling call.
     */
    array buildMarshalMap(Marshaller mymarshaller, array mymap, IData[string] options) {
        if (isSet(options["translations"]) && !options["translations"]) {
            return null;
        }
        return [
            "_translations": auto (myvalue, IEntity myentity) use (mymarshaller, options) {
                if (!isArray(myvalue)) {
                    return null;
                }
                /** @var array<string, \UIM\Datasource\IEntity> mytranslations */
                mytranslations = myentity.get("_translations") ?? [];

                options["validate"] = configuration.data("validator"];
                myerrors = [];
                foreach (mylanguage: myfields; myvalue) {
                    if (!isSet(mytranslations[mylanguage])) {
                        mytranslations[mylanguage] = this.table.newEmptyEntity();
                    }
                    mymarshaller.merge(mytranslations[mylanguage], myfields, options);

                    mytranslationErrors = mytranslations[mylanguage].getErrors();
                    if (mytranslationErrors) {
                        myerrors[mylanguage] = mytranslationErrors;
                    }
                }
                // Set errors into the root entity, so validation errors match the original form data position.
                if (myerrors) {
                    myentity.setErrors(["_translations": myerrors]);
                }
                return mytranslations;
            },
        ];
    }
    
    /**
     * Unsets the temporary `_i18n` property after the entity has been saved
     * Params:
     * \UIM\Event\IEvent<\UIM\ORM\Table> myevent The beforeSave event that was fired
     * @param \UIM\Datasource\IEntity myentity The entity that is going to be saved
     */
    void afterSave(IEvent myevent, IEntity myentity) {
        myentity.unset("_i18n");
    }
}
