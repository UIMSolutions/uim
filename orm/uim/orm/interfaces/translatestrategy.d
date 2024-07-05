module uim.orm.interfaces.translatestrategy;

import uim.orm;

@safe:

// This interface describes the methods for translate behavior strategies.
interface ITranslateStrategy : IPropertyMarshal {
    // Return translation table instance.
    DORMTable getTranslationTable();

    /**
     * Sets the locale to be used.
     *
     * When fetching records, the content for the locale set via this method,
     * and likewise when saving data, it will save the data in that locale.
     *
     * Note that in case an entity has a `_locale` property set, that locale
     * will win over the locale set via this method (and over the globally
     * configured one for that matter)!
     */
    ITranslateStrategy setLocale(string localeName);

    /**
     * Returns the current locale.
     *
     * If no locale has been explicitly set via `setLocale()`, this method will
     * return the currently configured global locale.
     */
    string locale();

    /**
     * Returns a fully aliased field name for translated fields.
     *
     * If the requested field is configured as a translation field, field with
     * an alias of a corresponding association is returned. Table-aliased
     * field name is returned for all other fields.
     *
     * aAliasedField - Field name to be aliased.
     */
    string translationField(string aAliasedField);

    /**
     * Modifies the results from a table find in order to merge full translation records
     * into each entity under the `_translations` key
     */
    IORMCollection groupTranslations(IResultset results);

    /**
     * Callback method that listens to the `beforeFind` event in the bound
     * table. It modifies the passed query by eager loading the translated fields
     * and adding a formatter to copy the values into the main table records.
     */
    void beforeFind(IEvent event, DORMQuery query, Json[string] options);

    /**
     * Modifies the entity before it is saved so that translated fields are persisted
     * in the database too.
     */
    void beforeSave(IEvent event, IORMEntity anEntity, Json[string] options);

    // Unsets the temporary `_i18n` property after the entity has been saved
    void afterSave(IEvent event, IORMEntity anEntity);
}
