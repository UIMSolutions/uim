module uim.orm.behaviors\Translate;

import uim.orm;

@safe:

/**
 * This class provides a way to translate dynamic data by keeping translations
 * in a separate shadow table where each row corresponds to a row of primary table.
 */
class ShadowTableStrategy : ITranslateStrategy {
    mixin InstanceConfigTemplate();
    mixin LocatorAwareTemplate();
    mixin TranslateStrategyTemplate {
        buildMarshalMap as private _buildMarshalMap;
    }
    
    /**
     * Default config
     *
     * These are merged with user-provided configuration.
     */
    protected IData[string] _defaultConfigData = [
        "fields": [],
        "defaultLocale": null,
        "referenceName": null,
        "allowEmptyTranslations": true,
        "onlyTranslated": false,
        "strategy": "subquery",
        "tableLocator": null,
        "validator": false,
    ];

    /**
     * Constructor
     * Params:
     * \UIM\ORM\Table mytable Table instance.
     * @param Iconfiguration.getData(string] configData Configuration.
     */
    this(Table mytable, Iconfiguration.getData(string] configData = null) {
        auto mytableAlias = mytable.getAlias();
        [myplugin] = pluginSplit(mytable.getRegistryAlias(), true);
        auto mytableReferenceName = configData("referenceName"];

        configData += [
            "mainTableAlias": mytableAlias,
            "translationTable": myplugin ~ mytableReferenceName ~ "Translations",
            "hasOneAlias": mytableAlias ~ "Translation",
        ];

        if (configuration.hasKey("tableLocator")) {
           _tableLocator = configData("tableLocator");
        }
        configuration.update(configData);
        this.table = mytable;
        this.translationTable = this.getTableLocator().get(
           configuration.data("translationTable"],
            ["allowFallbackClass": true]
        );

        this.setupAssociations();
    }
    
    /**
     * Create a hasMany association for all records.
     *
     * Don"t create a hasOne association here as the join conditions are modified
     * in before find - so create/modify it there.
     */
    protected void setupAssociations() {
        configData = this.getConfig();

        mytargetAlias = this.translationTable.getAlias();
        this.table.hasMany(mytargetAlias, [
            "className": configData("translationTable"],
            "foreignKey": "id",
            "strategy": configData("strategy"],
            "propertyName": "_i18n",
            "dependent": true,
        ]);
    }
    
    /**
     * Callback method that listens to the `beforeFind` event in the bound
     * table. It modifies the passed query by eager loading the translated fields
     * and adding a formatter to copy the values into the main table records.
     * Params:
     * \UIM\Event\IEvent<\UIM\ORM\Table> myevent The beforeFind event that was fired.
     * @param \UIM\ORM\Query\SelectQuery myquery Query.
     * @param \ArrayObject<string, mixed> options The options for the query.
     */
    void beforeFind(IEvent myevent, SelectQuery myquery, ArrayObject options) {
        mylocale = Hash.get(options, "locale", this.getLocale());
        configData = this.getConfig();

        if (mylocale == configData("defaultLocale"]) {
            return;
        }
        this.setupHasOneAssociation(mylocale, options);

        myfieldsAdded = this.addFieldsToQuery(myquery, configData);
        myorderByTranslatedField = this.iterateClause(myquery, "order", configData);
        myfilteredByTranslatedField =
            this.traverseClause(myquery, "where", configData) ||
            configData("onlyTranslated"] ||
            (options["filterByCurrentLocale"] ?? null);

        if (!myfieldsAdded && !myorderByTranslatedField && !myfilteredByTranslatedField) {
            return;
        }
        myquery.contain([configData("hasOneAlias"]]);

        myquery.formatResults(
            fn (ICollection results): this.rowMapper(results, mylocale),
            myquery.PREPEND
        );
    }
    
    /**
     * Create a hasOne association for record with required locale.
     * Params:
     * string mylocale Locale
     * @param \ArrayObject<string, mixed> options Find options
     */
    protected void setupHasOneAssociation(string mylocale, ArrayObject options) {
        configData = this.getConfig();

        [myplugin] = pluginSplit(configData("translationTable"]);
        myhasOneTargetAlias = myplugin ? (myplugin ~ "." ~ configData("hasOneAlias"]): configData("hasOneAlias"];
        if (!this.getTableLocator().exists(myhasOneTargetAlias)) {
            // Load table before hand with fallback class usage enabled
            this.getTableLocator().get(
                myhasOneTargetAlias,
                [
                    "className": configData("translationTable"],
                    "allowFallbackClass": true,
                ]
            );
        }
        if (isSet(options["filterByCurrentLocale"])) {
            myjoinType = options["filterByCurrentLocale"] ? "INNER" : "LEFT";
        } else {
            myjoinType = configData("onlyTranslated"] ? "INNER" : "LEFT";
        }
        this.table.hasOne(configData("hasOneAlias"], [
            "foreignKey": ["id"],
            "joinType": myjoinType,
            "propertyName": "translation",
            "className": configData("translationTable"],
            "conditions": [
                configData("hasOneAlias"] ~ ".locale": mylocale,
            ],
        ]);
    }
    
    /**
     * Add translation fields to query.
     *
     * If the query is using autofields (directly or implicitly) add the
     * main table"s fields to the query first.
     *
     * Only add translations for fields that are in the main table, always
     * add the locale field though.
     * Params:
     * \UIM\ORM\Query\SelectQuery myquery The query to check.
     * @param Iconfiguration.getData(string] configData The config to use for adding fields.
     */
    protected bool addFieldsToQuery(SelectQuery myquery, Iconfiguration.getData(string] configData) {
        if (myquery.isAutoFieldsEnabled()) {
            return true;
        }
        myselect = array_filter(myquery.clause("select"), auto (myfield) {
            return isString(myfield);
        });

        if (!myselect) {
            return true;
        }
        myalias = configData("mainTableAlias"];
        myjoinRequired = false;
        foreach (this.translatedFields() as myfield) {
            if (array_intersect(myselect, [myfield, "myalias.myfield"])) {
                myjoinRequired = true;
                myquery.select(myquery.aliasField(myfield, configData("hasOneAlias"]));
            }
        }
        if (myjoinRequired) {
            myquery.select(myquery.aliasField("locale", configData("hasOneAlias"]));
        }
        return myjoinRequired;
    }
    
    /**
     * Iterate over a clause to alias fields.
     *
     * The objective here is to transparently prevent ambiguous field errors by
     * prefixing fields with the appropriate table alias. This method currently
     * expects to receive an order clause only.
     * Params:
     * \UIM\ORM\Query\SelectQuery myquery the query to check.
     * @param string myname The clause name.
     * @param Iconfiguration.getData(string] configData The config to use for adding fields.
     */
    protected bool iterateClause(SelectQuery myquery, string myname = "", Iconfiguration.getData(string] configData = null) {
        myclause = myquery.clause(myname);
        assert(myclause.isNull || cast(QueryExpression)myclause);
        if (!myclause || !myclause.count()) {
            return false;
        }
        myalias = configData("hasOneAlias"];
        myfields = this.translatedFields();
        mymainTableAlias = configData("mainTableAlias"];
        mymainTableFields = this.mainFields();
        myjoinRequired = false;

        myclause.iterateParts(
            auto (myc, &myfield) use (myfields, myalias, mymainTableAlias, mymainTableFields, &myjoinRequired) {
                if (!isString(myfield) || myfield.has(".")) {
                    return myc;
                }
                if (in_array(myfield, myfields, true)) {
                    myjoinRequired = true;
                    myfield = "myalias.myfield";
                } else if (in_array(myfield, mymainTableFields, true)) {
                    myfield = "mymainTableAlias.myfield";
                }
                return myc;
            }
        );

        return myjoinRequired;
    }
    
    /**
     * Traverse over a clause to alias fields.
     *
     * The objective here is to transparently prevent ambiguous field errors by
     * prefixing fields with the appropriate table alias. This method currently
     * expects to receive a where clause only.
     * Params:
     * \UIM\ORM\Query\SelectQuery myquery the query to check.
     * @param string myname The clause name.
     * @param Iconfiguration.getData(string] configData The config to use for adding fields.
     */
    protected bool traverseClause(SelectQuery myquery, string myname = "", Iconfiguration.getData(string] configData = null) {
        /** @var \UIM\Database\Expression\QueryExpression|null myclause */
        myclause = myquery.clause(myname);
        if (!myclause || !myclause.count()) {
            return false;
        }
        auto myalias = configData("hasOneAlias"];
        auto myfields = this.translatedFields();
        auto mymainTableAlias = configData("mainTableAlias"];
        auto mymainTableFields = this.mainFields();
        auto myjoinRequired = false;

        myclause.traverse(
            void (myexpression) use (myfields, myalias, mymainTableAlias, mymainTableFields, &myjoinRequired) {
                if (!(cast(IField)myexpression)) {
                    return;
                }
                myfield = myexpression.getFieldNames();
                if (!isString(myfield) || myfield.has(".")) {
                    return;
                }
                if (in_array(myfield, myfields, true)) {
                    myjoinRequired = true;
                    myexpression.setFieldNames("myalias.myfield");

                    return;
                }
                if (in_array(myfield, mymainTableFields, true)) {
                    myexpression.setFieldNames("mymainTableAlias.myfield");
                }
            }
        );

        return myjoinRequired;
    }
    
    /**
     * Modifies the entity before it is saved so that translated fields are persisted
     * in the database too.
     * Params:
     * \UIM\Event\IEvent<\UIM\ORM\Table> myevent The beforeSave event that was fired.
     * @param \UIM\Datasource\IEntity myentity The entity that is going to be saved.
     * @param \ArrayObject<string, mixed> options the options passed to the save method.
     */
    void beforeSave(IEvent myevent, IEntity myentity, ArrayObject options) {
        mylocale = myentity.get("_locale") ?: this.getLocale();
        mynewOptions = [this.translationTable.getAlias(): ["validate": false]];
        options["associated"] = mynewOptions + options["associated"];

        // Check early if empty translations are present in the entity.
        // If this is the case, unset them to prevent persistence.
        // This only applies if configuration.data("allowEmptyTranslations"] is false
        if (configuration.data("allowEmptyTranslations"] == false) {
            this.unsetEmptyFields(myentity);
        }
        this.bundleTranslatedFields(myentity);
        mybundled = myentity.get("_i18n") ?: [];
        mynoBundled = count(mybundled) == 0;

        // No additional translation records need to be saved,
        // as the entity is in the default locale.
        if (mynoBundled && mylocale == configurationData.isSet("defaultLocale")) {
            return;
        }
        myvalues = myentity.extract(this.translatedFields(), true);
        myfields = myvalues.keys;
        mynoFields = empty(myfields);

        // If there are no fields and no bundled translations, or both fields
        // in the default locale and bundled translations we can
        // skip the remaining logic as its not necessary.
        if (mynoFields && mynoBundled || (myfields && mybundled)) {
            return;
        }
        myprimaryKey = (array)this.table.getPrimaryKey();
        myid = myentity.get(to!string(current(myprimaryKey)));

        // When we have no key and bundled translations, we
        // need to mark the entity dirty so the root
        // entity persists.
        if (mynoFields && mybundled && !myid) {
            foreach (this.translatedFields() as myfield) {
                myentity.setDirty(myfield, true);
            }
            return;
        }
        if (mynoFields) {
            return;
        }
        mywhere = ["locale": mylocale];
        mytranslation = null;
        if (myid) {
            mywhere["id"] = myid;

            mytranslation = this.translationTable.find()
                .select(array_merge(["id", "locale"], myfields))
                .where(mywhere)
                .first();
        }
        if (mytranslation) {
            mytranslation.set(myvalues);
        } else {
            mytranslation = this.translationTable.newEntity(
                mywhere + myvalues,
                [
                    "useSetters": false,
                    "markNew": true,
                ]
            );
        }
        myentity.set("_i18n", array_merge(mybundled, [mytranslation]));
        myentity.set("_locale", mylocale, ["setter": false]);
        myentity.setDirty("_locale", false);

        myfields.each!(field => myentity.setDirty(field, false));
    }
 
    array buildMarshalMap(Marshaller mymarshaller, array mymap, IData[string] options) {
        this.translatedFields();

        return _buildMarshalMap(mymarshaller, mymap, options);
    }
    
    /**
     * Returns a fully aliased field name for translated fields.
     *
     * If the requested field is configured as a translation field, field with
     * an alias of a corresponding association is returned. Table-aliased
     * field name is returned for all other fields.
     * Params:
     * string myfield Field name to be aliased.
     */
    string translationField(string myfield) {
        if (this.getLocale() == configurationData.isSet("defaultLocale")) {
            return this.table.aliasField(myfield);
        }
        mytranslatedFields = this.translatedFields();
        if (in_array(myfield, mytranslatedFields, true)) {
            return configurationData.isSet("hasOneAlias") ~ "." ~ myfield;
        }
        return this.table.aliasField(myfield);
    }
    
    /**
     * Modifies the results from a table find in order to merge the translated
     * fields into each entity for a given locale.
     * Params:
     * \UIM\Collection\ICollection results Results to map.
     * @param string mylocale Locale string
     */
    protected ICollection rowMapper(ICollection results, string mylocale) {
        myallowEmpty = configuration.data("allowEmptyTranslations"];

        return results.map(function (myrow) use (myallowEmpty, mylocale) {
            /** @var \UIM\Datasource\IEntity|array|null myrow */
            if (myrow.isNull) {
                return myrow;
            }
            myhydrated = !isArray(myrow);

            if (isEmpty(myrow["translation"])) {
                myrow["_locale"] = mylocale;
                unset(myrow["translation"]);

                if (myhydrated) {
                    /** @var \UIM\Datasource\IEntity myrow */
                    myrow.clean();
                }
                return myrow;
            }
            /** @var \UIM\Datasource\IEntity|array mytranslation */
            mytranslation = myrow["translation"];

            someKeys = myhydrated
                ? mytranslation.getVisible()
                : mytranslation.keys;

            foreach (myfield; someKeys) {
                if (myfield == "locale") {
                    myrow["_locale"] = mytranslation[myfield];
                    continue;
                }
                if (!mytranslation[myfield].isNull) {
                    if (myallowEmpty || !mytranslation[myfield].isEmpty) {
                        myrow[myfield] = mytranslation[myfield];
                    }
                }
            }
            // array myrow */
            unset(myrow["translation"]);

            if (myhydrated) {
                /** @var \UIM\Datasource\IEntity myrow */
                myrow.clean();
            }
            return myrow;
        });
    }
    
    /**
     * Modifies the results from a table find in order to merge full translation
     * records into each entity under the `_translations` key.
     * Params:
     * \UIM\Collection\ICollection results Results to modify.
     */
    ICollection groupTranslations(ICollection results) {
        return results.map(function (myrow) {
            if (!(cast(IEntity)myrow)) {
                return myrow;
            }
            mytranslations = (array)myrow.get("_i18n");
            if (isEmpty(mytranslations) && myrow.get("_translations")) {
                return myrow;
            }
            auto result;
            foreach (mytranslation; mytranslations) {
                unset(mytranslation["id"]);
                result[mytranslation["locale"]] = mytranslation;
            }
            myrow["_translations"] = result;
            unset(myrow["_i18n"]);
            if (cast(IEntity)myrow) {
                myrow.clean();
            }
            return myrow;
        });
    }
    
    /**
     * Helper method used to generated multiple translated field entities
     * out of the data found in the `_translations` property in the passed
     * entity. The result will be put into its `_i18n` property.
     * Params:
     * \UIM\Datasource\IEntity myentity Entity.
     */
    protected void bundleTranslatedFields(IEntity myentity) {
        /** @var array<string, \UIM\ORM\Entity> mytranslations */
        mytranslations = (array)myentity.get("_translations");

        if (isEmpty(mytranslations) && !myentity.isDirty("_translations")) {
            return;
        }
        myprimaryKey = (array)this.table.getPrimaryKey();
        aKey = myentity.get((string)current(myprimaryKey));

        foreach (mytranslations as mylang: mytranslation) {
            if (!mytranslation.id) {
                myupdate = [
                    "id": aKey,
                    "locale": mylang,
                ];
                mytranslation.set(myupdate, ["guard": false]);
            }
        }
        myentity.set("_i18n", mytranslations);
    }
    
    /**
     * Lazy define and return the main table fields.
     */
    protected string[] mainFields() {
        myfields = configurationData.isSet("mainTableFields");

        if (myfields) {
            return myfields;
        }
        myfields = this.table.getSchema().columns();

        configuration.update("mainTableFields", myfields);

        return myfields;
    }
    
    // Lazy define and return the translation table fields.
    protected string[] translatedFields() {
        string[] myfields = configurationData.isSet("fields");

        if (myfields) {
            return myfields;
        }
        mytable = this.translationTable;
        myfields = mytable.getSchema().columns();
        myfields = array_diff(myfields, ["id", "locale"]).values;

        configuration.update("fields", myfields);

        return myfields;
    }
}
