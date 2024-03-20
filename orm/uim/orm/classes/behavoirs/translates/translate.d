module orm.uim.orm.classes.behavoirs.translates.translate;

import uim.orm;

@safe:

/**
 * This behavior provides a way to translate dynamic data by keeping translations
 * in a separate table linked to the original record from another one. Translated
 * fields can be configured to override those in the main table when fetched or
 * put aside into another property for the same entity.
 *
 * If you wish to override fields, you need to call the `locale` method in this
 * behavior for setting the language you want to fetch from the translations table.
 *
 * If you want to bring all or certain languages for each of the fetched records,
 * you can use the custom `translations` finders that is exposed to the table.
 */
class TranslateBehavior : Behavior,
IPropertyMarshal {
    override bool initialize(IData[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        Configuration.updateDefaults([
            "implementedFinders": ["translations": "findTranslations"],
            "implementedMethods": [
                "setLocale": "setLocale",
                "getLocale": "getLocale",
                "translationField": "translationField",
            
        ],
        "fields" : [],
        "defaultLocale" : null,
        "referenceName" : "",
        "allowEmptyTranslations" : true,
        "onlyTranslated" : false,
        "strategy" : "subquery",
        "tableLocator" : null,
        "validator" : false,]);
        return true;
    }

    /**
     * Default strategy class name.
     *
     * @var string
     * @psalm-var class-string<DORMBehavior\Translate\ITranslateStrategy>
     * /
    protected static defaultStrategyClass = EavStrategy.class;

    /**
     * Translation strategy instance.
     *
     * @var DORMBehavior\Translate\ITranslateStrategy|null
     */
    protected strategy;

    /**
     * Constructor
     *
     * ### Options
     *
     * - `fields`: List of fields which need to be translated. Providing this fields
     *   list is mandatory when using `EavStrategy`. If the fields list is empty when
     *   using `ShadowTableStrategy` then the list will be auto generated based on
     *   shadow table schema.
     * - `defaultLocale`: The locale which is treated as default by the behavior.
     *   Fields values for defaut locale will be stored in the primary table itself
     *   and the rest in translation table. If not explicitly set the value of
     *   `I18n::getDefaultLocale()` will be used to get default locale.
     *   If you do not want any default locale and want translated fields
     *   for all locales to be stored in translation table then set this config
     *   to empty string `""`.
     * - `allowEmptyTranslations`: By default if a record has been translated and
     *   stored as an empty string the translate behavior will take and use this
     *   value to overwrite the original field value. If you don"t want this behavior
     *   then set this option to `false`.
     * - `validator`: The validator that should be used when translation records
     *   are created/modified. Default `null`.
     *
     * @param DORMDORMTable aTable The table this behavior is attached to.
     * @param array<string, mixed> myConfiguration The config for this behavior.
     */
    this(DORMTable aTable, IData[string] configData) {
        myConfiguration += [
            "defaultLocale": I18n: : getDefaultLocale(),
            "referenceName": this.referenceName(table),
            "tableLocator": table.associations().getTableLocator(),
        ];

        super((table, myConfiguration);}

        /**
     * Initialize hook
     *
     * @param array<string, mixed> myConfiguration The config for this behavior.
     */
        bool initialize(IData[string] myConfiguration) {
            this.getStrategy();}

            /**
     * Set default strategy class name.
     *
     * @param string aClassName  Class name.
     * @return void
     * @since 4.0.0
     * @psalm-param class-string<DORMBehavior\Translate\ITranslateStrategy> class
     */
            static function setDefaultStrategyClass(string aClassName) {
                defaultStrategyClass = class;}

                /**
     * Get default strategy class name.
     *
     * @return string
     * @since 4.0.0
     * @psalm-return class-string<DORMBehavior\Translate\ITranslateStrategy>
     */
                static string getDefaultStrategyClass() {
                    return defaultStrategyClass;}

                    /**
     * Get strategy class instance.
     *
     * @return DORMBehavior\Translate\ITranslateStrategy
     * @since 4.0.0
     */
                    function getStrategy() : ITranslateStrategy {
                        if (this.strategy != null) {
                            return this.strategy;}

                            return this.strategy = this.createStrategy();}

                            /**
     * Create strategy instance.
     *
     * @return DORMBehavior\Translate\ITranslateStrategy
     * @since 4.0.0
     */
                            protected function createStrategy() {
                                myConfiguration = array_diff_key(
                                    configuration,
                                    ["implementedFinders", "implementedMethods", "strategyClass"]
                                );  /** @var class-string<DORMBehavior\Translate\ITranslateStrategy> className */
                                className = this.getConfig("strategyClass", defaultStrategyClass);

                                    return new className(_table, myConfiguration);
                            }

                            /**
     * Set strategy class instance.
     *
     * @param DORMBehavior\Translate\ITranslateStrategy strategy Strategy class instance.
     * @return this
     * @since 4.0.0
     */
                            function setStrategy(ITranslateStrategy strategy) {
                                this.strategy = strategy; return this;}

                                /**
     * Gets the Model callbacks this behavior is interested in.
     *
     * @return array<string, mixed>
     */
                                array implementedEvents() {
                                    return [
                                        "Model.beforeFind": "beforeFind",
                                        "Model.beforeSave": "beforeSave",
                                        "Model.afterSave": "afterSave",
                                    ];}

                                    /**
     * {@inheritDoc}
     *
     * Add in `_translations` marshalling handlers. You can disable marshalling
     * of translations by setting `"translations": false` in the options
     * provided to `Table::newEntity()` or `Table::patchEntity()`.
     *
     * @param DORMMarshaller marshaller The marhshaller of the table the behavior is attached to.
     * @param array map The property map being built.
     * @param array<string, mixed> options The options array used in the marshalling call.
     * @return array A map of `[property: callable]` of additional properties to marshal.
     */
                                    array buildMarshalMap(Marshaller marshaller, array map, STRINGAA someOptions) {
                                        return this.getStrategy()
                                            .buildMarshalMap(marshaller, map, options);
                                    }

                                    /**
     * Sets the locale that should be used for all future find and save operations on
     * the table where this behavior is attached to.
     *
     * When fetching records, the behavior will include the content for the locale set
     * via this method, and likewise when saving data, it will save the data in that
     * locale.
     *
     * Note that in case an entity has a `_locale` property set, that locale will win
     * over the locale set via this method (and over the globally configured one for
     * that matter)!
     *
     * @param string|null locale The locale to use for fetching and saving records. Pass `null`
     * in order to unset the current locale, and to make the behavior fall back to using the
     * globally configured locale.
     * @return this
     * @see DORMBehavior\TranslateBehavior::getLocale()
     * @link https://book.cakephp.org/4/en/orm/behaviors/translate.html#retrieving-one-language-without-using-i18n-locale
     * @link https://book.cakephp.org/4/en/orm/behaviors/translate.html#saving-in-another-language
     */
                                    function setLocale(Nullable!string locale) {
                                        this.getStrategy().setLocale(locale); return this;
                                    }

                                    /**
     * Returns the current locale.
     *
     * If no locale has been explicitly set via `setLocale()`, this method will return
     * the currently configured global locale.
     *
     * @return string
     * @see DORMI18n\I18n::getLocale()
     * @see DORMBehavior\TranslateBehavior::setLocale()
     */
                                    string getLocale() {
                                        return this.getStrategy().getLocale();}

                                        /**
     * Returns a fully aliased field name for translated fields.
     *
     * If the requested field is configured as a translation field, the `content`
     * field with an alias of a corresponding association is returned. Table-aliased
     * field name is returned for all other fields.
     *
     * @param string field Field name to be aliased.
     */
                                        string translationField(string field) {
                                            return this.getStrategy().translationField(field);
                                        }

                                        /**
     * Custom finder method used to retrieve all translations for the found records.
     * Fetched translations can be filtered by locale by passing the `locales` key
     * in the options array.
     *
     * Translated values will be found for each entity under the property `_translations`,
     * containing an array indexed by locale name.
     *
     * ### Example:
     *
     * ```
     * article = articles.find("translations", ["locales": ["eng", "deu"]).first();
     * englishTranslatedFields = article.get("_translations")["eng"];
     * ```
     *
     * If the `locales` array is not passed, it will bring all translations found
     * for each record.
     *
     * @param DORMQuery query The original query to modify
     * @param array<string, mixed> options Options
     * @return DORMQuery
     */
                                        function findTranslations(Query query, STRINGAA someOptions)
                                            : Query {
                                                locales = options["locales"] ?  ? [];
                                                    targetAlias = this.getStrategy()
                                                    .getTranslationTable().aliasName();

                                                    return query
                                                    .contain([targetAlias: function(query) use(locales, targetAlias) {
                                                                /** @var DORMdatasources.IQuery query */
                                                                if (locales) {
                                                                    query.where(
                                                                        ["targetAlias.locale IN": locales]);
                                                                }

                                                                return query;}
                                                                ])
                                                                    .formatResults([this.getStrategy(), "groupTranslations"], query:
                                                                         : PREPEND);
                                                            }

                                                            /**
     * Proxy method calls to strategy class instance.
     *
     * @param string aMethodName Method name.
     * @param array args Method arguments.
     * @return mixed
     */
                                                            function __call(method, args) {
                                                                return this.strategy. {
                                                                    method
                                                                }
                                                                (...args);}

                                                                /**
     * Determine the reference name to use for a given table
     *
     * The reference name is usually derived from the class name of the table object
     * (PostsTable . Posts), however for autotable instances it is derived from
     * the database table the object points at - or as a last resort, the alias
     * of the autotable instance.
     *
     * @param DORMDORMTable aTable The table class to get a reference name for.
     */
                                                                protected string referenceName(
                                                                    DORMTable aTable) {
                                                                    name = namespaceSplit(
                                                                        get_class(table));
                                                                        name = substr(end(name), 0, -5);
                                                                        if (empty(name)) {
                                                                            name = table.getTable() ?  : table.aliasName();
                                                                                name = Inflector :  : camelize(
                                                                                    name);
                                                                        }

                                                                    return name;}
                                                                }
