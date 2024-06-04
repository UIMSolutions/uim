module uim.orm.classes.behaviors.translates.translate;

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
class DTranslateBehavior : DBehavior { // IPropertyMarshal {
    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false; 
        }

        configuration.updateDefaults([
            "implementedFinders": ["translations": "findTranslations"],
            "implementedMethods": [
                "setLocale": "setLocale",
                "getLocale": "getLocale",
                "translationField": "translationField",
            
        ],
        "fields" : [],
        "defaultLocale" : null,
        "referenceName" : "",
        "allowEmptyTranslations": true.toJson,
        "onlyTranslated": false.toJson,
        "strategy" : "subquery",
        "tableLocator" : null,
        "validator": false.toJson,]);

        return true; 
    }

   // Default strategy class name.
    protected static string mydefaultStrategyClass = ShadowTableStrategy.classname;

    // Translation strategy instance.
    protected ITranslateStrategy mystrategy = null;

    /**
     
     *
     * ### Options
     *
     * - `fields`: List of fields which need to be translated. Providing this fields
     * list is mandatory when using `EavStrategy`. If the fields list is empty when
     * using `ShadowTableStrategy` then the list will be auto generated based on
     * shadow table schema.
     * - `defaultLocale`: The locale which is treated as default by the behavior.
     * Fields values for defaut locale will be stored in the primary table itself
     * and the rest in translation table. If not explicitly set the value of
     * `I18n.getDefaultLocale()` will be used to get default locale.
     * If you do not want any default locale and want translated fields
     * for all locales to be stored in translation table then set this config
     * to empty string `""`.
     * - `allowEmptyTranslations`: By default if a record has been translated and
     * stored as an empty string the translate behavior will take and use this
     * value to overwrite the original field value. If you don"t want this behavior
     * then set this option to `false`.
     * - `validator`: The validator that should be used when translation records
     * are created/modified. Default `null`.
     * Params:
     * \ORM\Table mytable The table this behavior is attached to.
     * @param Json[string] configData The config for this behavior.
     */
    this(DTable mytable, Json[string] initData = null) {
        configuration += [
            "defaultLocale": I18n.getDefaultLocale(),
            "referenceName": this.referenceName(mytable),
            "tableLocator": mytable.associations().getTableLocator(),
        ];

        super(mytable, configData);
    }

    bool initialize(Json[string] initData = null) {
        getStrategy();
        return super.initialize(initData);
    }

    /**
     * Set default strategy class name.
     * Params:
     * string myclass DClass name.
     */
    static void setDefaultStrategyClass(string myclass) {
        mydefaultStrategyClass = myclass;
    }

    /**
     * Get default strategy class name.
     */
    static string getDefaultStrategyClass() {
        return mydefaultStrategyClass;
    }

    /**
     * Get strategy class instance.
     */
    ITranslateStrategy getStrategy() {
        if (this.strategy!is null) {
            return _strategy;
        }
        return _strategy = this.createStrategy();
    }

    /**
     * Create strategy instance.
     */
    protected ITranslateStrategy createStrategy() {
        configData = array_diff_key(
            configuration,
            ["implementedFinders", "implementedMethods", "strategyClass"]
        );
        /** @var class-string<\ORM\Behavior\Translate\ITranslateStrategy> myclassName */
        myclassName = configurationData.hasKey("strategyClass", mydefaultStrategyClass);

        return new myclassName(_table, configData);
    }

    /**
     * Set strategy class instance.
     * Params:
     * \ORM\Behavior\Translate\ITranslateStrategy mystrategy Strategy class instance.
     */
    void setStrategy(ITranslateStrategy mystrategy) {
        this.strategy = mystrategy;
    }

    /**
     * Gets the Model callbacks this behavior is interested in.
     */
    IEvent[] implementedEvents() {
        return [
            "Model.beforeFind": "beforeFind",
            "Model.beforeMarshal": "beforeMarshal",
            "Model.beforeSave": "beforeSave",
            "Model.afterSave": "afterSave",
        ];
    }

    /**
     * Hoist fields for the default locale under `_translations` key to the root
     * in the data.
     *
     * This allows `_translations.{locale}.field_name` type naming even for the
     * default locale in forms.
     * Params:
     * \UIM\Event\IEvent myevent
     * @param \ArrayObject mydata
     * @param \ArrayObject options
     */
    void beforeMarshal(IEvent myevent, ArrayObject mydata, ArrayObject options) {
        if (isSet(options["translations"]) && !options["translations"]) {
            return;
        }
        mydefaultLocale = configurationData.hasKey("defaultLocale");
        if (!mydata["_translations"].hasKey(mydefaultLocale)) {
            return;
        }
        foreach (mydata["_translations"][mydefaultLocale] as fieldName : myvalue) {
            mydata[fieldName] = myvalue;
        }
        unset(mydata["_translations"][mydefaultLocale]);
    }

    /**
     * Add in `_translations` marshalling handlers. You can disable marshalling
     * of translations by setting `"translations": false.toJson` in the options
     * provided to `Table.newEntity()` or `Table.patchEntity()`.
     */
    Json[string] buildMarshalMap(DMarshaller tableMarshaller, Json[string] propertyMap, Json[string] marshallingOptions) {
        return _getStrategy().buildMarshalMap(tableMarshaller, propertyMap, marshallingOptions);
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
     * Params:
     * string mylocale The locale to use for fetching and saving records. Pass `null`
     * in order to unset the current locale, and to make the behavior fall back to using the
     * globally configured locale.
     */
    void setLocale(string mylocale) {
        getStrategy().setLocale(mylocale);
    }

    /**
     * Returns the current locale.
     *
     * If no locale has been explicitly set via `setLocale()`, this method will return
     * the currently configured global locale.
     */
    string locale() {
        return _getStrategy().locale();
    }

    /**
     * Returns a fully aliased field name for translated fields.
     *
     * If the requested field is configured as a translation field, the `content`
     * field with an alias of a corresponding association is returned. Table-aliased
     * field name is returned for all other fields.
     * Params:
     * string fieldName Field name to be aliased.
     */
    string translationField(string fieldName) {
        return _getStrategy().translationField(fieldName);
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
     * myarticle = myarticles.find("translations", locales: ["eng", "deu"]).first();
     * myenglishTranslatedFields = myarticle.get("_translations")["eng"];
     * ```
     *
     * If the `locales` array is not passed, it will bring all translations found
     * for each record.
     * Params:
     * \ORM\Query\SelectQuery myquery The original query to modify
     * @param string[] mylocales A list of locales or options with the `locales` key defined
     */
    SelectQuery findTranslations(SelectQuery myquery, Json[string] mylocales = []) {
        mytargetAlias = getStrategy().getTranslationTable().aliasName();

        return myquery
            .contain([mytargetAlias: auto(IQuery myquery) use(mylocales, mytargetAlias) {
                        if (mylocales) {
                            myquery.where(["mytargetAlias.locale IN": mylocales]);
                        }
                        return myquery;}

                        ])
                            .formatResults(getStrategy()
                                .groupTranslations(...), myquery.PREPEND);
                    }

                    /**
     * Proxy method calls to strategy class instance.
     * Params:
     * string mymethod Method name.
     * @param Json[string] myargs Method arguments.
    */
                    Json __call(string mymethod, Json[string] myargs) {
                        return _strategy. {
                            mymethod
                        }
                        (...myargs);
                    }

                    /**
     * Determine the reference name to use for a given table
     *
     * The reference name is usually derived from the class name of the table object
     * (PostsTable ~ Posts), however for autotable instances it is derived from
     * the database table the object points at - or as a last resort, the alias
     * of the autotable instance.
     * Params:
     * \ORM\Table mytable The table class to get a reference name for.
     */
                    protected string referenceName(Table mytable) {
                        myname = namespaceSplit(mytable.classname);
                        myname = substr(to!string(end(myname)), 0,  - 5);
                        if (myname.isEmpty) {
                            myname = mytable.getTable() ?  : mytable.aliasName();
                            myname = Inflector.camelize(myname);
                        }
                        return myname;
                    }
}
