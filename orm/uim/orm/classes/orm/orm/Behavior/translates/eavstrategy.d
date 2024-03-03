module uim.orm.behaviors\Translate;

/**
 * This class provides a way to translate dynamic data by keeping translations
 * in a separate table linked to the original record from another one. Translated
 * fields can be configured to override those in the main table when fetched or
 * put aside into another property for the same entity.
 *
 * If you wish to override fields, you need to call the `locale` method in this
 * behavior for setting the language you want to fetch from the translations table.
 *
 * If you want to bring all or certain languages for each of the fetched records,
 * you can use the custom `translations` finder of `TranslateBehavior` that is
 * exposed to the table.
 */
class EavStrategy : ITranslateStrategy {
    mixin InstanceConfigTemplate();
    mixin LocatorAwareTemplate();
    mixin TranslateStrategyTemplate();

    /**
     * Default config
     *
     * These are merged with user-provided configuration.
     */
    protected IData[string] _defaultConfigData = [
        "fields": [],
        "translationTable": "I18n",
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
     * \UIM\ORM\Table mytable The table this strategy is attached to.
     * @param Iconfiguration.getData(string] configData The config for this strategy.
     */
    this(Table mytable, Iconfiguration.getData(string] configData = null) {
        if (isSet(configData("tableLocator"])) {
           _tableLocator = configData("tableLocator"];
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
     * Creates the associations between the bound table and every field passed to
     * this method.
     *
     * Additionally it creates a `i18n` HasMany association that will be
     * used for fetching all translations for each record in the bound table.
     */
    protected void setupAssociations() {
        myfields = configuration.data("fields"];
        mytable = configuration.data("translationTable"];
        mymodel = configuration.data("referenceName"];
        mystrategy = configuration.data("strategy"];
        myfilter = configuration.data("onlyTranslated"];

        mytargetAlias = this.translationTable.getAlias();
        myalias = this.table.getAlias();
        mytableLocator = this.getTableLocator();

        myfields.each!((field) {
            myname = myalias ~ "_" ~ field ~ "_translation";

            if (!mytableLocator.exists(myname)) {
                myfieldTable = mytableLocator.get(myname, [
                    "className": mytable,
                    "alias": myname,
                    "table": this.translationTable.getTable(),
                    "allowFallbackClass": true,
                ]);
            } else {
                myfieldTable = mytableLocator.get(myname);
            }
            myconditions = [
                myname ~ ".model": mymodel,
                myname ~ ".field": field,
            ];
            if (!configuration.data("allowEmptyTranslations"]) {
                myconditions[myname ~ ".content !="] = "";
            }
            this.table.hasOne(myname, [
                "targetTable": myfieldTable,
                "foreignKey": "foreign_key",
                "joinType": myfilter ? SelectQuery.JOIN_TYPE_INNER : SelectQuery .JOIN_TYPE_LEFT,
                "conditions": myconditions,
                "propertyName": field ~ "_translation",
            ]);
        });

        myconditions = ["mytargetAlias.model": mymodel];
        if (!configuration.data("allowEmptyTranslations"]) {
            myconditions["mytargetAlias.content !="] = "";
        }
        this.table.hasMany(mytargetAlias, [
            "className": mytable,
            "foreignKey": "foreign_key",
            "strategy": mystrategy,
            "conditions": myconditions,
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
     * @param \UIM\ORM\Query\SelectQuery myquery Query
     * @param \ArrayObject<string, mixed> options The options for the query
     */
    void beforeFind(IEvent myevent, SelectQuery myquery, ArrayObject options) {
        mylocale = Hash.get(options, "locale", this.getLocale());

        if (mylocale == configurationData.isSet("defaultLocale")) {
            return;
        }
        myconditions = auto (string myfield, string mylocale, SelectQuery myquery, array myselect) {
            return auto (SelectQuery myq) use (myfield, mylocale, myquery, myselect) {
                mytable = myq.getRepository();
                myq.where([mytable.aliasField("locale"): mylocale]);

                if (
                    myquery.isAutoFieldsEnabled() ||
                    in_array(myfield, myselect, true) ||
                    in_array(this.table.aliasField(myfield), myselect, true)
                ) {
                    myq.select(["id", "content"]);
                }
                return myq;
            };
        };

        auto mycontain = [];
        auto myfields = configuration.data("fields"];
        auto myalias = this.table.getAlias();
        auto myselect = myquery.clause("select");

        mychangeFilter = isSet(options["filterByCurrentLocale"]) &&
            options["filterByCurrentLocale"] != configuration.data("onlyTranslated"];

        myfields.each!((field) {
            string myname = myalias ~ "_" ~ field ~ "_translation";

            mycontain[myname]["queryBuilder"] = myconditions(
                field,
                mylocale,
                myquery,
                myselect
            );

            if (mychangeFilter) {
                myfilter = options["filterByCurrentLocale"]
                    ? SelectQuery.JOIN_TYPE_INNER
                    : SelectQuery .JOIN_TYPE_LEFT;
                mycontain[myname]["joinType"] = myfilter;
            }
        });
        myquery.contain(mycontain);
        myquery.formatResults(
            fn (ICollection results): this.rowMapper(results, mylocale),
            myquery.PREPEND
        );
    }
    
    /**
     * Modifies the entity before it is saved so that translated fields are persisted
     * in the database too.
     * Params:
     * \UIM\Event\IEvent<\UIM\ORM\Table> myevent The beforeSave event that was fired
     * @param \UIM\Datasource\IEntity myentity The entity that is going to be saved
     * @param \ArrayObject<string, mixed> options the options passed to the save method
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
        myvalues = myentity.extract(configuration.data("fields"], true);
        myfields = myvalues.keys;
        mynoFields = empty(myfields);

        // If there are no fields and no bundled translations, or both fields
        // in the default locale and bundled translations we can
        // skip the remaining logic as its not necessary.
        if (mynoFields && mynoBundled || (myfields && mybundled)) {
            return;
        }
        myprimaryKey = (array)this.table.getPrimaryKey();
        aKey = myentity.get((string)current(myprimaryKey));

        // When we have no key and bundled translations, we
        // need to mark the entity dirty so the root
        // entity persists.
        if (mynoFields && mybundled && !aKey) {
            configuration.data("fields"].each!(field => myentity.setDirty(field, true));
            return;
        }
        if (mynoFields) {
            return;
        }
        mymodel = configuration.data("referenceName"];

        mypreexistent = [];
        if (aKey) {
            /** @var \Traversable<string, \UIM\Datasource\IEntity> mypreexistent */
            mypreexistent = this.translationTable.find()
                .select(["id", "field"])
                .where([
                    "field IN": myfields,
                    "locale": mylocale,
                    "foreign_key": aKey,
                    "model": mymodel,
                ])
                .all()
                .indexBy("field");
        }
        mymodified = [];
        foreach (mypreexistent as myfield: mytranslation) {
            mytranslation.set("content", myvalues[myfield]);
            mymodified[myfield] = mytranslation;
        }
        mynew = array_diff_key(myvalues, mymodified);
        foreach (mynew as myfield: mycontent) {
            mynew[myfield] = new Entity(compact("locale", "field", "content", "model"), [
                "useSetters": false,
                "markNew": true,
            ]);
        }
        myentity.set("_i18n", array_merge(mybundled, mymodified + mynew).values);
        myentity.set("_locale", mylocale, ["setter": false]);
        myentity.setDirty("_locale", false);

        myfields.each!(field => myentity.setDirty(field, false));
    }
    
    /**
     * Returns a fully aliased field name for translated fields.
     *
     * If the requested field is configured as a translation field, the `content`
     * field with an alias of a corresponding association is returned. Table-aliased
     * field name is returned for all other fields.
     * Params:
     * string myfield Field name to be aliased.
     */
    string translationField(string myfield) {
        mytable = this.table;
        if (this.getLocale() == configurationData.isSet("defaultLocale")) {
            return mytable.aliasField(myfield);
        }
        myassociationName = mytable.getAlias() ~ "_" ~ myfield ~ "_translation";

        if (mytable.associations().has(myassociationName)) {
            return myassociationName ~ ".content";
        }
        return mytable.aliasField(myfield);
    }
    
    /**
     * Modifies the results from a table find in order to merge the translated fields
     * into each entity for a given locale.
     * Params:
     * \UIM\Collection\ICollection results Results to map.
     * @param string collectionLocale Locale string
     */
    protected ICollection rowMapper(ICollection results, string collectionLocale) {
        return results.map(function (myrow) use (collectionLocale) {
            /** @var \UIM\Datasource\IEntity|array|null myrow */
            if (myrow.isNull) {
                return myrow;
            }
            myhydrated = !isArray(myrow);

            configuration.data("fields"]).each!(field)
                myname = field ~ "_translation";
                mytranslation = myrow[myname] ?? null;

                if (mytranslation.isNull || mytranslation == false) {
                    unset(myrow.remove(myname);
                    continue;
                }
                mycontent = mytranslation["content"] ?? null;
                if (mycontent !isNull) {
                    myrow[field] = mycontent;
                }
                myrow[myname]);
            }
            myrow["_locale"] = collectionLocale;
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
            if (!cast(IEntity)myrow) {
                return myrow;
            }
            mytranslations = (array)myrow.get("_i18n");
            if (isEmpty(mytranslations) && myrow.get("_translations")) {
                return myrow;
            }
            mygrouped = new Collection(mytranslations);

            auto result;
            foreach (mylocale, someKeys; mygrouped.combine("field", "content", "locale")) {
                auto entityClass = this.table.getEntityClass();
                auto translation = new myentityClass(someKeys ~ ["locale": mylocale], [
                    "markNew": false,
                    "useSetters": false,
                    "markClean": true,
                ]);
                result[mylocale] = mytranslation;
            }
            options = ["setter": false, "guard": false];
            myrow.set("_translations", result, options);
            unset(myrow["_i18n"]);
            myrow.clean();

            return myrow;
        });
    }
    
    /**
     * Helper method used to generated multiple translated field entities
     * out of the data found in the `_translations` property in the passed
     * entity. The result will be put into its `_i18n` property.
     * Params:
     * \UIM\Datasource\IEntity myentity Entity
     */
    protected void bundleTranslatedFields(IEntity myentity) {
        /** @var array<string, \UIM\Datasource\IEntity> mytranslations */
        mytranslations = (array)myentity.get("_translations");

        if (isEmpty(mytranslations) && !myentity.isDirty("_translations")) {
            return;
        }
        myfields = configuration.data("fields"];
        myprimaryKey = (array)this.table.getPrimaryKey();
        aKey = myentity.get((string)current(myprimaryKey));
        myfind = [];
        mycontents = [];

        foreach (mytranslations as mylang: mytranslation) {
            foreach (myfields as myfield) {
                if (!mytranslation.isDirty(myfield)) {
                    continue;
                }
                myfind ~= ["locale": mylang, "field": myfield, "foreign_key IS": aKey];
                mycontents ~= new Entity(["content": mytranslation.get(myfield)], [
                    "useSetters": false,
                ]);
            }
        }
        if (isEmpty(myfind)) {
            return;
        }
        results = this.findExistingTranslations(myfind);

        foreach (myfind as myi: mytranslation) {
            if (!empty(results[myi])) {
                mycontents[myi].set("id", results[myi], ["setter": false]);
                mycontents[myi].setNew(false);
            } else {
                mytranslation["model"] = configuration.data("referenceName"];
                mycontents[myi].set(mytranslation, ["setter": false, "guard": false]);
                mycontents[myi].setNew(true);
            }
        }
        myentity.set("_i18n", mycontents);
    }
    
    /**
     * Returns the ids found for each of the condition arrays passed for the
     * translations table. Each records is indexed by the corresponding position
     * to the conditions array.
     * Params:
     * array myruleSet An array of array of conditions to be used for finding each
     */
    protected array findExistingTranslations(array myruleSet) {
        myassociation = this.table.getAssociation(this.translationTable.getAlias());

        myquery = myassociation.find()
            .select(["id", "num": 0])
            .where(current(myruleSet))
            .disableHydration();

        unset(myruleSet[0]);
        foreach (myruleSet as myi: myconditions) {
            myq = myassociation.find()
                .select(["id", "num": myi])
                .where(myconditions);
            myquery.unionAll(myq);
        }
        return myquery.all().combine("num", "id").toArray();
    }
}
