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

        configuration
            .setDefault("fields", Json.emptyArray)
            .setDefault("defaultLocale", Json(null))
            .setDefault("referencename", "")
            .setDefault("allowEmptyTranslations", true)
            .setDefault("onlyTranslated", false)
            .setDefault("strategy", "subquery")
            .setDefault("tableLocator", Json(null))
            .setDefault("validator", false);

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

        configuration.set(myConfiguration);
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
     */
    void beforeFind(IEvent event, Query query, Json[string] options) {
        auto locale = Hash.get(options, "locale", locale());
        auto configData = configuration.data;
        if (
            locale == configuration.get("defaultLocale")) {
            return;
        }

        setupHasOneAssociation(locale, options);
        auto fieldsAdded = this.addFieldsToQuery(query, myConfiguration);
        auto orderByTranslatedField = this.iterateClause(query, "order", myConfiguration);
        auto filteredByTranslatedField =
            traverseClause(query, "where", myConfiguration) ||
            configuration.hasKeys("onlyTranslated", "filterByCurrentLocale");
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

    // Create a hasOne association for record with required locale.
    protected void setupHasOneAssociation(string localeName, Json[string] options) {
        auto configData = configuration.data;
        [plugin] = pluginSplit(
            configuration.get("translationTable"));
        hasOneTargetAlias = plugin
            ? (plugin ~ "." ~ configuration.getString("hasOneAlias")) : configuration.get(
                "hasOneAlias");
        if (!getTableLocator()
            .hasKey(hasOneTargetAlias)) {
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
            ? (options.hasKey("filterByCurrentLocale") ? "INNER" : "LEFT") : (
                configuration.getString("onlyTranslated") ? "INNER" : "LEFT");

        _table.hasOne(configuration.get("hasOneAlias"), [
                "foreignKeys": ["id"],
                "joinType": joinType,
                "propertyName": "translation",
                "classname": configuration.getString("translationTable"),
                "conditions": [
                    configuration.getString("hasOneAlias") ~ ".locale": localeName,

                

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
     */
    protected bool addFieldsToQuery(DORMQuery query, Json[string] options) {
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

        auto aliasName = "mainTableAlias";
        joinRequired = false;
        foreach (field; translatedFields()) {
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
     */
    protected bool iterateClause(DORMQuery query, string clauseName = "", Json[string] myConfiguration = null) {
        auto clause = query.clause(clauseName);
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
            else if (mainTableFields.has(field)) {
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
     */
    protected bool traverseClause(DORMQuery queryToCheck, string clauseName = "", Json[string] myConfiguration = null) {
        auto clause = queryToCheck.clause(clauseName);
        if (!clause || !clause.count()) {
            return false;
        }

        string aliasName = configuration.getString("hasOneAlias");
        string[] fields = translatedFields();
        auto mainTableAlias = configuration.get("mainTableAlias");
        auto mainTableFields = this.mainFields();
        auto joinRequired = false;
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
     */
    void beforeSave(IEvent event, IORMEntity anEntity, Json[string] options) {
        auto locale = entity.get("_locale") ? entity.get("_locale") : locale();
        auto newOptions = [
            this.translationTable.aliasName(): [
                "validate": false.toJson
            ]
        ];
        options.set("associated", newOptions + options.get("associated"]);

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
            where.set("id", id);

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
     */
    protected ICollection rowMapper(IResultset results, string locale) {
        auto allowEmpty = configuration
            .get(
                "allowEmptyTranslations");

        /* return results.map(
            function(
                row) use(
                allowEmpty, locale) {
            /** @var DORMdatasources.IORMEntity|array|null row * /
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
                    row.set("_locale", locale); remove(
                    row["translation"]); 
                    if (
                        hydrated) {
                        /** @psalm-suppress PossiblyInvalidMethodCall * /
                        row.clean();}

                        return row;}

                        /** @var DORMEntity|array translation * /
                        translation = row["translation"];  /**
             * @psalm-suppress PossiblyInvalidMethodCall
             * @psalm-suppress PossiblyInvalidArgument
              * /
                        keys = hydrated ? translation
                        .visibleFields() : translation
                        .keys; foreach (field; keys) {
                            if (
                                field == "locale") {
                                row.set("_locale", translation[field]); 
                                continue;
                                }

                                if (
                                    translation[field] != null) {
                                    if (allowEmpty || translation[field] != "") {
                                        row[field] = translation[field];}
                                    }
                                }

                                remove(
                                row["translation"]); if (
                                    hydrated) {
                                    /** @psalm-suppress PossiblyInvalidMethodCall * /
                                    row.clean();}

                                    return row;}); */
    }

    /**
     * Modifies the results from a table find in order to merge full translation
     * records into each entity under the `_translations` key.
     */
    ICollection groupTranslations(IResultset results) {
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
            foreach (translation; translations) {
                translation.remove("id");
                result.set(translation.getString("locale"), translation);
            }

            row.set("_translations", result);
            row.remove("_i18n");
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
     */
    protected void bundleTranslatedFields(IORMEntity entity) {
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
        configuration.set(
            "mainTableFields", fields);

        return fields;
    }

    // Lazy define and return the translation table fields.
    protected string[] translatedFields() {
        auto fields = getConfig("fields");
        if (fields) {
            return fields;
        }

        auto table = _translationTable;
        fields = table.getSchema()
            .columns();
        fields = array_values(
            array_diff(
                fields, [
                    "id", "locale"
                ]));
        configuration.set("fields", fields);
        return fields;
    }
}
