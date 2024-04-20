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
     *
     * @param string|null locale The locale to use for fetching and saving
     *   records. Pass `null` in order to unset the current locale, and to make
     *   the behavior fall back to using the globally configured locale.
     * @return this
     */
    ITranslateStrategy setLocale(string locale);

    /**
     * Returns the current locale.
     *
     * If no locale has been explicitly set via `setLocale()`, this method will
     * return the currently configured global locale.
     */
    string getLocale();

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
     *
     * @param DORMDatasource\IResultSet results Results to modify.
     */
    IORMCollection groupTranslations(results);

    /**
     * Callback method that listens to the `beforeFind` event in the bound
     * table. It modifies the passed query by eager loading the translated fields
     * and adding a formatter to copy the values into the main table records.
     *
     * @param DORMevents.IEvent event The beforeFind event that was fired.
     * @param DORMQuery query Query
     * @param \ArrayObject options The options for the query
     */
    void beforeFind(IEvent event, Query query, ArrayObject options);

    /**
     * Modifies the entity before it is saved so that translated fields are persisted
     * in the database too.
     *
     * @param DORMevents.IEvent event The beforeSave event that was fired
     * @param DORMDatasource\IEntity anEntity The entity that is going to be saved
     * @param \ArrayObject options the options passed to the save method
     */
    void beforeSave(IEvent event, IEntity anEntity, ArrayObject options);

    /**
     * Unsets the temporary `_i18n` property after the entity has been saved
     *
     * @param DORMevents.IEvent event The beforeSave event that was fired
     * @param DORMDatasource\IEntity anEntity The entity that is going to be saved
     */
    void afterSave(IEvent event, IEntity anEntity);
}
