module uim.orm.classes.behaviors.translates.strategies.shadowtable;

import uim.orm;

@safe:

/**
 * This class provides a way to translate dynamic data by keeping translations
 * in a separate shadow table where each row corresponds to a row of primary table.
 */
class DShadowTableStrategy { // TODO }: ITranslateStrategy {
    mixin TConfigurable;

    mixin TLocatorAware;
    // TODO mixin TTranslateStrategy() {
    //     buildMarshalMap as private _buildMarshalMap;
    // }

    this() {
        initialize;
    }

    this(Json[string] initData) {
        initialize(initData);
    }

    this(string name) {
        this().name(name);
    }

    // Hook method
    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        configuration.updateDefaults([
            "fields": Json.emptyArray,
            "defaultLocale": Json(null),
            "referencename": "".toJson,
            "allowEmptyTranslations": true.toJson,
            "onlyTranslated": false.toJson,
            "strategy": "subquery".toJson,
            "tableLocator": Json(null),
            "validator": false.toJson,
        ]);

        return true;
    }

    mixin(TProperty!("string", "name"));

    this(DORMTable table, Json[string] configData) {
        auto tableAlias = table.aliasName();
        [plugin] = pluginSplit(table.registryKey(), true);
        auto tableReferenceName = configuration.get("referenceName");
        auto myConfiguration += [
            "mainTableAlias": tableAlias,
            "translationTable": plugin.tableReferenceName ~ "Translations",
            "hasOneAlias": tableAlias ~ "Translation",
        ];
        if (configuration.contains("tableLocator")) {
            _tableLocator = configuration.get("tableLocator");
        }

        configuration.update(myConfiguration);
        _table = table;
        this.translationTable = getTableLocator()
            .get(
                configuration.get("translationTable"),
                ["allowFallbackClass": true.toJson]
           );
        setupAssociations();
    }

    /**
     * Create a hasMany association for all records.
     *
     * Don"t create a hasOne association here as the join conditions are modified
     * in before find - so create/modify it there.
     */
    protected void setupAssociations() {
        auto configData = configuration.data;
        targetAlias = this.translationTable.aliasName();
        _table.hasMany(targetAlias, [
                "classname": configuration.get("translationTable"),
                "foreignKeys": Json("id"),
                "strategy": configuration.get("strategy"),
                "propertyName": Json("_i18n"),
                "dependent": true.toJson,
            ]);
    }

    /**
     * Callback method that listens to the `beforeFind` event in the bound
     * table. It modifies the passed query by eager loading the translated fields
     * and adding a formatter to copy the values into the main table records.
     *
     * @param DORMevents.IEvent event The beforeFind event that was fired.
     * @param DORMQuery query Query.
     * @param \ArrayObject options The options for the query.
     */
    void beforeFind(IEvent event, Query query, ArrayObject options) {
        auto locale = Hash.get(options, "locale", locale());
        auto configData = configuration.data;
        if (
            locale == configuration.get("defaultLocale")) {
            return;
        }

        setupHasOneAssociation(locale, options);
        fieldsAdded = this.addFieldsToQuery(
            query, myConfiguration);
        orderByTranslatedField = this.iterateClause(query, "order", myConfiguration);
        filteredByTranslatedField =
            traverseClause(query, "where", myConfiguration) ||
            configuration.hasKey(
                "onlyTranslated") ||
            (options["filterByCurrentLocale"] ?  ? null);
        if (!fieldsAdded && !orderByTranslatedField && !filteredByTranslatedField) {
            return;
        }

        query.contain([configuration.get("hasOneAlias")]);
        // TODO
        /*
        query.formatResults(
            function(results) use(locale) {
            return _rowMapper(results, locale);}, query:
             : PREPEND);
             */
    }

    /**
     * Create a hasOne association for record with required locale.
     *
     * @param string locale Locale
     * @param \ArrayObject options Find options
     */
    protected void setupHasOneAssociation(string locale, ArrayObject options) {
        auto configData = configuration.data;
        [plugin] = pluginSplit(
            configuration.get(
                "translationTable"));
        hasOneTargetAlias = plugin 
            ? (plugin ~ "." ~ configuration.getString("hasOneAlias")) 
            : configuration.get("hasOneAlias");
        if (!getTableLocator()
            .exists(hasOneTargetAlias)) {
            // Load table before hand with fallback class usage enabled
            getTableLocator().get(
                hasOneTargetAlias,
                [
                    "classname": configuration.get("translationTable"),
                    "allowFallbackClass": true.toJson,
                ]
           );
        }

        string joinType = options.hasKey("filterByCurrentLocale")
            ? (options["filterByCurrentLocale"] ? "INNER" : "LEFT") : (
                configuration.getString("onlyTranslated") ? "INNER" : "LEFT");

        _table.hasOne(configuration.get("hasOneAlias"), [
                "foreignKeys": ["id"],
                "joinType": joinType,
                "propertyName": "translation",
                "classname": configuration.getString("translationTable"),
                "conditions": [
                    configuration.getString("hasOneAlias") ~ ".locale": locale,

                

            ],]);
    }

    /**
     * Add translation fields to query.
     *
     * If the query is using autofields (directly or implicitly) add the
     * main table"s fields to the query first.
     *
     * Only add translations for fields that are in the main table, always
     * add the locale field though.
     *
     * @param DORMQuery query The query to check.
     * @param Json[string] myConfiguration The config to use for adding fields.
     */
    protected bool addFieldsToQuery(DORMQuery query, Json myConfiguration) {
        if (query.isAutoFieldsEnabled()) {
            return true;
        }

        auto select = array_filter(query.clause(
                "select"), function(
                field) { return field
                .isString; });
        if (!select) {
            return true;
        }

        auto aliasName"mainTableAlias");
        joinRequired = false;
        foreach (
            translatedFields() as field) {
            if (array_intersect(select, [
                        field, "alias.field"
                    ])) {
                joinRequired = true;
                query.select(query.aliasField(field, configuration.get("hasOneAlias")));
            }
        }

        if (joinRequired) {
            query.select(query.aliasField("locale", configuration.get("hasOneAlias")));
        }

        return joinRequired;
    }

    /**
     * Iterate over a clause to alias fields.
     *
     * The objective here is to transparently prevent ambiguous field errors by
     * prefixing fields with the appropriate table alias. This method currently
     * expects to receive an order clause only.
     *
     * @param DORMQuery query the query to check.
     * @param string aName The clause name.
     * @param Json[string] myConfiguration The config to use for adding fields.
     */
    protected bool iterateClause(query, name = "", myConfiguration = null) {
        clause = query.clause(
            name);
        if (!clause || !clause.count()) {
            return false;
        }

        string aliasName = configuration.get("hasOneAlias");
        string[] fields = translatedFields();
        auto mainTableAlias = configuration.get("mainTableAlias");
        mainTableFields = this.mainFields();
        auto joinRequired = false;
        /* clause.iterateParts(
            function(c,  & field) use(fields, aliasName, mainTableAlias, mainTableFields,  & joinRequired) {
            if (!field.isString || field.contains(".")) {
                return c;
            }

            if (fields.has(field))) {
                joinRequired = true;
                field = "alias.field";
            }
            elseif (mainTableFields.has(field)) {
                field = "mainTableAlias.field";
            }

            return c;
        } */

        

       );
        return joinRequired;
    }

    /**
     * Traverse over a clause to alias fields.
     *
     * The objective here is to transparently prevent ambiguous field errors by
     * prefixing fields with the appropriate table alias. This method currently
     * expects to receive a where clause only.
     *
     * @param DORMQuery query the query to check.
     * @param string aName The clause name.
     * @param Json[string] myConfiguration The config to use for adding fields.
     */
    protected bool traverseClause(DORMQuery query, name = "", myConfiguration = null) {
        auto clause = queryToCheck.clause(name);
        if (!clause || !clause.count()) {
            return false;
        }

        string aliasName = configuration.getString("hasOneAlias");
        string[] fields = translatedFields();
        mainTableAlias = configuration.get("mainTableAlias");
        mainTableFields = this.mainFields();
        joinRequired = false;
        clause.traverse(
            function(
                expression) use(
                fields, alias, mainTableAlias, mainTableFields,  & joinRequired) {
            if (!(
                cast(IField) expression)) {
                return;
            }

            auto field = expression.getField();
            if (!(field.isString || field.indexOf("."))) {
                return;
            }

            if (isIn(field, fields, true)) {
                joinRequired = true;
                expression.setField(
                    "alias.field");
                return;
            }

            /** @psalm-suppress ParadoxicalCondition */
            if (isIn(field, mainTableFields, true)) {
                expression.setField(
                    "mainTableAlias.field");
            }
        }
       );
        return joinRequired;
    }

    /**
     * Modifies the entity before it is saved so that translated fields are persisted
     * in the database too.
     *
     * @param DORMevents.IEvent event The beforeSave event that was fired.
     * @param DORMDatasource\IORMEntity anEntity The entity that is going to be saved.
     * @param \ArrayObject options the options passed to the save method.
     */
    void beforeSave(IEvent event, IORMEntity anEntity, ArrayObject options) {
        locale = entity.get("_locale") ? entity.get("_locale") : locale();
        newOptions = [
            this.translationTable.aliasName(): [
                "validate": false.toJson
            ]
        ];
        options["associated"] = newOptions + options["associated"];

        // Check early if empty translations are present in the entity.
        // If this is the case, unset them to prevent persistence.
        // This only applies if configuration.get("allowEmptyTranslations"] is false
        if (
            configuration.get(
                "allowEmptyTranslations") == false) {
            this.unsetEmptyFields(
                entity);
        }

        this.bundleTranslatedFields(
            entity);
        bundled = entity.get("_i18n") ?
             : [];
        noBundled = count(
            bundled) == 0; // No additional translation records need to be saved,
        // as the entity is in the default locale.
        if (noBundled && locale == getConfig(
                "defaultLocale")) {
            return;
        }

        values = entity.extract(
            translatedFields(), true);
        fields = values
            .keys;
        noFields = empty(
            fields); // If there are no fields and no bundled translations, or both fields
        // in the default locale and bundled translations we can
        // skip the remaining logic as its not necessary.
        if (noFields && noBundled || (
                fields && bundled)) {
            return;
        }

        primaryKeys = (
            array) _table
            .primaryKeys();
        id = entity.get(
            currentValue(
                primaryKeys)); // When we have no key and bundled translations, we
        // need to mark the entity dirty so the root
        // entity persists.
        if (noFields && bundled && !id) {
            foreach (
                field; translatedFields()) {
                entity.setDirty(field, true);
            }

            return;
        }

        if (
            noFields) {
            return;
        }

        where = [
            "locale": locale
        ];
        translation = null;
        if (id) {
            where["id"] = id;

            /** @var DORMdatasources.IORMEntity|null translation */
            translation = this
                .translationTable.find()
                .select(array_merge([
                            "id",
                            "locale"
                        ], fields))
                .where(where)
                .disableBufferedResults()
                .first();
        }

        if (
            translation) {
            translation.set(
                values);
        } else {
            translation = this
                .translationTable
                .newEntity(
                    where + values,
                    [
                        "useSetters": false
                        .toJson,
                        "markNew": true
                        .toJson,
                    ]
               );
        }

        entity.set("_i18n", array_merge(
                bundled, [
                    translation
                ]));
        entity.set("_locale", locale, [
                "setter": BooleanData(
                    false)
            ]);
        entity.setDirty("_locale", false);
        fields.each!(field => entity.setDirty(field, false));
    }

    Json[string] buildMarshalMap(
        DMarshaller marshaller, Json[string] map, Json[string] options = null) {
        translatedFields();

        return _buildMarshalMap(
            marshaller, map, options);
    }

    /**
     * Returns a fully aliased field name for translated fields.
     *
     * If the requested field is configured as a translation field, field with
     * an alias of a corresponding association is returned. Table-aliased
     * field name is returned for all other fields.
     *
     * @param string field Field name to be aliased.
     */
    string translationField(string fieldName) {
        if (
            locale() == getConfig("defaultLocale")) {
            return _table.aliasField(fieldName);
        }

        auto translatedFields = this.translatedFields();
        if (isIn(fieldName, translatedFields, true)) {
            return _configuration.getString("hasOneAlias") ~ "." ~ fieldName;
        }

        return _table.aliasField(fieldName);
    }

    /**
     * Modifies the results from a table find in order to merge the translated
     * fields into each entity for a given locale.
     *
     * @param DORMDatasource\IResultset results Results to map.
     * @param string locale Locale string
     */
    protected ICollection rowMapper(
        results, locale) {
        allowEmpty = configuration
            .get(
                "allowEmptyTranslations");

        return results.map(
            function(
                row) use(
                allowEmpty, locale) {
            /** @var DORMdatasources.IORMEntity|array|null row */
            if (
                row == null) {
                return row;
            }

            hydrated = !(
                row
                .isArray;
            if (
                empty(
                row["translation"])) {
                row["_locale"] = locale;
                remove(
                    row["translation"]);
                if (
                    hydrated) {
                    /** @psalm-suppress PossiblyInvalidMethodCall */
                    row.clean();
                }

                return row;
            }

            /** @var DORMEntity|array translation */
            translation = row["translation"]; /**
             * @psalm-suppress PossiblyInvalidMethodCall
             * @psalm-suppress PossiblyInvalidArgument
             */
            keys = hydrated ? translation
                .visibleFields() : translation
                .keys;
            foreach (field; keys) {
                if (
                    field == "locale") {
                    row["_locale"] = translation[field];
                    continue;
                }

                if (
                    translation[field] != null) {
                    if (allowEmpty || translation[field] != "") {
                        row[field] = translation[field];
                    }
                }
            }

            remove(
                row["translation"]);
            if (
                hydrated) {
                /** @psalm-suppress PossiblyInvalidMethodCall */
                row.clean();
            }

            return row;
        });
    }

    /**
     * Modifies the results from a table find in order to merge full translation
     * records into each entity under the `_translations` key.
     *
     * @param DORMDatasource\IResultset results Results to modify.
     */
    ICollection groupTranslations(
        results) {
        return results.map(
            function(
                row) {
            translations = (
                array) row["_i18n"];
            if (translations.isEmpty && row
            .get(
            "_translations")) {
                return row;
            }

            result = null;
            foreach (
                translations as translation) {
                remove(
                    translation["id"]);
                result[translation["locale"]] = translation;
            }

            row["_translations"] = result;
            remove(
                row["_i18n"]);
            if (
                cast(
                IORMEntity) row) {
                row.clean();
            }

            return row;
        });
    }

    /**
     * Helper method used to generated multiple translated field entities
     * out of the data found in the `_translations` property in the passed
     * entity. The result will be put into its `_i18n` property.
     *
     * @param DORMDatasource\IORMEntity anEntity Entity.
     */
    protected void bundleTranslatedFields(
        entity) {
        translations = (
            array) entity.get(
            "_translations");
        if (translations.isEmpty && !entity
            .isChanged(
                "_translations")) {
            return;
        }

        primaryKeys = (
            array) _table
            .primaryKeys();
        key = entity.get(
            currentValue(
                primaryKeys));
        foreach (
            translations as lang : translation) {
            if (
                !translation
                .id) {
                update = [
                    "id": key,
                    "locale": lang,
                ];
                translation.set(
                    update, [
                        "guard": BooleanData(
                            false)
                    ]);
            }
        }

        entity.set("_i18n", translations);
    }

    /**
     * Lazy define and return the main table fields.
     */
    protected string[] mainFields() {
        fields = configuration.get(
            "mainTableFields");

        if (
            fields) {
            return fields;
        }

        fields = _table
            .getSchema()
            .columns();
        configuration.update(
            "mainTableFields", fields);

        return fields;
    }

    /**
     * Lazy define and return the translation table fields.
     *
     */
    protected string[] translatedFields() {
        fields = getConfig(
            "fields");
        if (
            fields) {
            return fields;
        }

        table = this
            .translationTable;
        fields = table.getSchema()
            .columns();
        fields = array_values(
            array_diff(
                fields, [
                    "id",
                    "locale"
                ]));
        configuration.update(
            "fields", fields);

        return fields;
    }

    

    *  /
}
