module uim.orm.classes.behaviors.translates.strategies.shadowtable;

import uim.orm;

@safe:

/**
 * This class provides a way to translate dynamic data by keeping translations
 * in a separate shadow table where each row corresponds to a row of primary table.
 */
class DShadowTableStrategy { // TODO }: ITranslateStrategy {
    mixin TConfigurable;

    this() {
        initialize;
    }

    this(IData[string] initData) {
        initialize(initData);
    }

    this(string name) {
        this().name(name);
    }

    // Hook method
    bool initialize(IData[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        configuration.updateDefaults([
            "fields": ArrayData,
            "defaultLocale": NullData,
            "referencename": StringData,
            "allowEmptyTranslations": BooleanData(true),
            "onlyTranslated": BooleanData(false),
            "strategy": StringData("subquery"),
            "tableLocator": NullData,
            "validator": BooleanData(false),
        ]);

        return true;
    }

    mixin(TProperty!("string", "name"));
    /* 
    mixin TLocatorAware;
    mixin TTranslateStrategy() {
        buildMarshalMap as private _buildMarshalMap;
    }

    /**
     * Constructor
     *
     * @param DORMDORMTable aTable Table instance.
     * @param array<string, mixed> myConfiguration Configuration.
     * /
    this(DORMTable aTable, IData[string] configData) {
        tableAlias = table.aliasName();
        [plugin] = pluginSplit(table.registryKey(), true);
        tableReferenceName = configuration.get("referenceName"];

        myConfiguration += [
            "mainTableAlias": tableAlias,
            "translationTable": plugin.tableReferenceName ~ "Translations",
            "hasOneAlias": tableAlias ~ "Translation",
        ];

        if (configuration.has("tableLocator"])) {
            _tableLocator = configuration.get("tableLocator"];
        }

        configuration.update(myConfiguration);
        this.table = table;
        this.translationTable = this.getTableLocator().get(
            configuration.get("translationTable"],
            ["allowFallbackClass": BooleanData(true)]
        );

        this.setupAssociations();
    }

    /**
     * Create a hasMany association for all records.
     *
     * Don"t create a hasOne association here as the join conditions are modified
     * in before find - so create/modify it there.
     * /
    protected void setupAssociations() {
        myConfiguration = configuration;

        targetAlias = this.translationTable.aliasName();
        this.table.hasMany(targetAlias, [
                "className": configuration.get("translationTable"],
                "foreignKey": "id",
                "strategy": configuration.get("strategy"],
                "propertyName": "_i18n",
                "dependent": BooleanData(true),
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
     * /
    void beforeFind(IEvent event, Query query, ArrayObject options) {
        locale = Hash :  : get(options, "locale", this.getLocale());
        myConfiguration = configuration;

        if (locale == configuration.get("defaultLocale"]) {
            return;
        }

        this.setupHasOneAssociation(locale, options);

        fieldsAdded = this.addFieldsToQuery(query, myConfiguration);
        orderByTranslatedField = this.iterateClause(query, "order", myConfiguration);
        filteredByTranslatedField =
            this.traverseClause(query, "where", myConfiguration) ||
            configuration.get("onlyTranslated"] ||
            (options["filterByCurrentLocale"] ?  ? null);

        if (!fieldsAdded && !orderByTranslatedField && !filteredByTranslatedField) {
            return;
        }

        query.contain([configuration.get("hasOneAlias"]]);

        query.formatResults(function(results) use(locale) {
            return _rowMapper(results, locale);}, query:
             : PREPEND);
        }

        /**
     * Create a hasOne association for record with required locale.
     *
     * @param string locale Locale
     * @param \ArrayObject options Find options
     * /
        protected void setupHasOneAssociation(string locale, ArrayObject options) {
            myConfiguration = configuration;

            [plugin] = pluginSplit(configuration.get("translationTable"]);
            hasOneTargetAlias = plugin ? (plugin ~ "." ~ configuration.get("hasOneAlias"])
                : configuration.get("hasOneAlias"];
            if (!this.getTableLocator().exists(hasOneTargetAlias)) {
                // Load table before hand with fallback class usage enabled
                this.getTableLocator().get(
                    hasOneTargetAlias,
                    [
                        "className": configuration.get("translationTable"],
                        "allowFallbackClass": BooleanData(true),
                    ]
                );
            }

            if (isset(options["filterByCurrentLocale"])) {
                joinType = options["filterByCurrentLocale"] ? "INNER" : "LEFT";
            } else {
                joinType = configuration.get("onlyTranslated"] ? "INNER" : "LEFT";
            }

            this.table.hasOne(configuration.get("hasOneAlias"], [
                    "foreignKey": ["id"],
                    "joinType": joinType,
                    "propertyName": "translation",
                    "className": configuration.get("translationTable"],
                    "conditions": [
                        configuration.get("hasOneAlias"] ~ ".locale": locale,
                    
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
     * @param array<string, mixed> myConfiguration The config to use for adding fields.
     * @return bool Whether a join to the translation table is required.
     * /
        protected function addFieldsToQuery(query, IData myConfiguration) {
            if (query.isAutoFieldsEnabled()) {
                return true;
            }

            select = array_filter(query.clause("select"), function(field) {
                return field.isString;});

                if (!select) {
                    return true;
                }

                alias = configuration.get("mainTableAlias"];
                joinRequired = false;
                foreach (this.translatedFields() as field) {
                    if (array_intersect(select, [field, "alias.field"])) {
                        joinRequired = true;
                        query.select(query.aliasField(field, configuration.get("hasOneAlias"]));
                    }
                }

                if (joinRequired) {
                    query.select(query.aliasField("locale", configuration.get("hasOneAlias"]));
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
     * @param array<string, mixed> myConfiguration The config to use for adding fields.
     * @return bool Whether a join to the translation table is required.
     * /
            protected bool iterateClause(query, name = "", myConfiguration = null) {
                clause = query.clause(name);
                if (!clause || !clause.count()) {
                    return false;
                }

                alias = configuration.get("hasOneAlias"];
                fields = this.translatedFields();
                mainTableAlias = configuration.get("mainTableAlias"];
                mainTableFields = this.mainFields();
                joinRequired = false;

                clause.iterateParts(
                    function(c,  & field) use(fields, alias, mainTableAlias, mainTableFields,  & joinRequired) {
                    if (!field.isString || indexOf(field, ".")) {
                        return c;}

                        /** @psalm-suppress ParadoxicalCondition * /
                        if (in_array(field, fields, true)) {
                            joinRequired = true; field = "alias.field";}
                            elseif(in_array(field, mainTableFields, true)) {
                                field = "mainTableAlias.field";}

                                return c;}

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
     * @param array<string, mixed> myConfiguration The config to use for adding fields.
     * @return bool Whether a join to the translation table is required.
     * /
                            protected bool traverseClause(query, name = "", myConfiguration = null) {
                                clause = query.clause(name);
                                if (!clause || !clause.count()) {
                                    return false;
                                }

                                IData alias = configuration.get("hasOneAlias"];
                                fields = this.translatedFields();
                                mainTableAlias = configuration.get("mainTableAlias"];
                                mainTableFields = this.mainFields();
                                joinRequired = false;

                                clause.traverse(
                                    function(expression) use(fields, alias, mainTableAlias, mainTableFields,  & joinRequired) {
                                    if (!(expression instanceof IField)) {
                                        return;}
                                        field = expression.getField(); if (!(field.isString || indexOf(field, ".")) {
                                                return; }

                                                if (in_array(field, fields, true)) {
                                                    joinRequired = true; expression.setField(
                                                    "alias.field"); return; }

                                                    /** @psalm-suppress ParadoxicalCondition * /
                                                    if (in_array(field, mainTableFields, true)) {
                                                        expression.setField("mainTableAlias.field");
                                                    }
                                                }
                                                ); return joinRequired;}

                                                /**
     * Modifies the entity before it is saved so that translated fields are persisted
     * in the database too.
     *
     * @param DORMevents.IEvent event The beforeSave event that was fired.
     * @param DORMDatasource\IEntity anEntity The entity that is going to be saved.
     * @param \ArrayObject options the options passed to the save method.
     * /
                                                void beforeSave(IEvent event, IEntity anEntity, ArrayObject options) {
                                                    locale = entity.get("_locale") ? 
                                                    : this.getLocale(); newOptions = [
                                                        this.translationTable.aliasName(): [
                                                            "validate": BooleanData(false)
                                                        ]
                                                    ]; options["associated"] = newOptions + options["associated"];

                                                    // Check early if empty translations are present in the entity.
                                                    // If this is the case, unset them to prevent persistence.
                                                    // This only applies if configuration.get("allowEmptyTranslations"] is false
                                                    if (
                                                        configuration.get("allowEmptyTranslations"] == false) {
                                                        this.unsetEmptyFields(entity);
                                                    }

                                                    this.bundleTranslatedFields(entity);
                                                    bundled = entity.get("_i18n") ?  : [];
                                                    noBundled = count(bundled) == 0;

                                                    // No additional translation records need to be saved,
                                                    // as the entity is in the default locale.
                                                    if (noBundled && locale == this.getConfig(
                                                        "defaultLocale")) {
                                                        return;}

                                                        values = entity.extract(
                                                        this.translatedFields(), true);
                                                        fields = values.keys; noFields = empty(
                                                        fields); // If there are no fields and no bundled translations, or both fields
                                                        // in the default locale and bundled translations we can
                                                        // skip the remaining logic as its not necessary.
                                                        if (noFields && noBundled || (fields && bundled)) {
                                                            return;}

                                                            primaryKeys = (array) this.table
                                                            .primaryKeys(); id = entity.get(
                                                            current(primaryKeys));

                                                            // When we have no key and bundled translations, we
                                                            // need to mark the entity dirty so the root
                                                            // entity persists.
                                                            if (noFields && bundled && !id) {
                                                                foreach (
                                                                    this.translatedFields() as field) {
                                                                    entity.setDirty(field, true);
                                                                }

                                                                return;}

                                                                if (noFields) {
                                                                    return;}

                                                                    where = [
                                                                        "locale": locale
                                                                    ]; translation = null;
                                                                    if (id) {
                                                                        where["id"] = id;

                                                                        /** @var DORMdatasources.IEntity|null translation * /
                                                                        translation = this.translationTable.find()
                                                                        .select(array_merge([
                                                                            "id",
                                                                            "locale"
                                                                        ], fields))
                                                                        .where(where)
                                                                        .disableBufferedResults()
                                                                        .first();}

                                                                        if (translation) {
                                                                            translation.set(values);
                                                                        } else {
                                                                            translation = this.translationTable
                                                                            .newEntity(
                                                                            where + values,
                                                                            [
                                                                                "useSetters": BooleanData(false),
                                                                                "markNew": BooleanData(true),
                                                                            ]
                                                                            );}

                                                                            entity.set("_i18n", array_merge(bundled, [
                                                                                translation
                                                                            ])); entity.set("_locale", locale, [
                                                                                "setter": BooleanData(
                                                                                false)
                                                                            ]); entity.setDirty("_locale", false);

                                                                            foreach (fields as field) {
                                                                                entity.setDirty(field, false);
                                                                            }
                                                                        }

                                                                        array buildMarshalMap(DMarshaller marshaller, array map, IData[string] optionData) {
                                                                            this.translatedFields();

                                                                            return _buildMarshalMap(marshaller, map, options);
                                                                        }

                                                                        /**
     * Returns a fully aliased field name for translated fields.
     *
     * If the requested field is configured as a translation field, field with
     * an alias of a corresponding association is returned. Table-aliased
     * field name is returned for all other fields.
     *
     * @param string field Field name to be aliased.
     * /
                                                                        string translationField(
                                                                        string field) {
                                                                            if (this.getLocale() == this.getConfig(
                                                                                "defaultLocale")) {
                                                                                return _table.aliasField(
                                                                                field);
                                                                            }

                                                                            translatedFields = this.translatedFields();
                                                                            if (in_array(field, translatedFields, true)) {
                                                                                return _getConfig(
                                                                                "hasOneAlias") ~ "." ~ field;
                                                                            }

                                                                            return _table.aliasField(
                                                                            field);
                                                                        }

                                                                        /**
     * Modifies the results from a table find in order to merge the translated
     * fields into each entity for a given locale.
     *
     * @param DORMDatasource\IResultset results Results to map.
     * @param string locale Locale string
     * @return DORMcollections.ICollection
     * /
                                                                        protected function rowMapper(results, locale) {
                                                                            allowEmpty = configuration.get("allowEmptyTranslations"];

                                                                            return results.map(
                                                                            function(row) use(allowEmpty, locale) {
                                                                                /** @var DORMdatasources.IEntity|array|null row * /
                                                                                if (row == null) {
                                                                                    return row;
                                                                                }

                                                                                hydrated = !(
                                                                                row.isArray;

                                                                                if (
                                                                                    empty(
                                                                                    row["translation"])) {
                                                                                    row["_locale"] = locale;
                                                                                    unset(
                                                                                    row["translation"]);

                                                                                    if (hydrated) {
                                                                                        /** @psalm-suppress PossiblyInvalidMethodCall * /
                                                                                        row.clean();
                                                                                    }

                                                                                    return row;
                                                                                }

                                                                                /** @var DORMEntity|array translation * /
                                                                                translation = row["translation"];

                                                                                /**
             * @psalm-suppress PossiblyInvalidMethodCall
             * @psalm-suppress PossiblyInvalidArgument
             * /
                                                                                keys = hydrated ? translation
                                                                                .getVisible() : translation
                                                                                .keys;

                                                                                foreach (
                                                                                    keys as field) {
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

                                                                                unset(
                                                                                row["translation"]);

                                                                                if (hydrated) {
                                                                                    /** @psalm-suppress PossiblyInvalidMethodCall * /
                                                                                    row.clean();
                                                                                }

                                                                                return row;
                                                                            });}

                                                                            /**
     * Modifies the results from a table find in order to merge full translation
     * records into each entity under the `_translations` key.
     *
     * @param DORMDatasource\IResultset results Results to modify.
     * @return DORMcollections.ICollection
     * /
                                                                            function groupTranslations(
                                                                            results) : ICollection {
                                                                                return results.map(
                                                                                function(row) {
                                                                                    translations = (
                                                                                    array) row["_i18n"];
                                                                                    if (empty(translations) && row.get(
                                                                                        "_translations")) {
                                                                                        return row;
                                                                                    }

                                                                                    result = null;
                                                                                    foreach (
                                                                                        translations as translation) {
                                                                                        unset(
                                                                                        translation["id"]);
                                                                                        result[translation["locale"]] = translation;
                                                                                    }

                                                                                    row["_translations"] = result;
                                                                                    unset(
                                                                                    row["_i18n"]);
                                                                                    if (
                                                                                        row instanceof IEntity) {
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
     * @param DORMDatasource\IEntity anEntity Entity.
     * /
                                                                            protected void bundleTranslatedFields(
                                                                            entity) {
                                                                                translations = (
                                                                                array) entity.get(
                                                                                "_translations");

                                                                                if (empty(translations) && !entity
                                                                                .isDirty(
                                                                                "_translations")) {
                                                                                    return;
                                                                                }

                                                                                primaryKeys = (
                                                                                array) this.table.primaryKeys();
                                                                                key = entity.get(
                                                                                current(primaryKeys));

                                                                                foreach (translations as lang
                                                                                : translation) {
                                                                                    if (
                                                                                        !translation
                                                                                    .id) {
                                                                                        update = [
                                                                                            "id": key,
                                                                                            "locale": lang,
                                                                                        ];
                                                                                        translation.set(update, [
                                                                                            "guard": BooleanData(
                                                                                            false)
                                                                                        ]);
                                                                                    }
                                                                                }

                                                                                entity.set("_i18n", translations);
                                                                            }

                                                                            /**
     * Lazy define and return the main table fields.
     *
     * @return array<string>
     * /
                                                                            protected string[] mainFields() {
                                                                                fields = this.getConfig(
                                                                                "mainTableFields");

                                                                                if (fields) {
                                                                                    return fields;
                                                                                }

                                                                                fields = this.table.getSchema()
                                                                                .columns();

                                                                                configuration.update("mainTableFields", fields);

                                                                                return fields;
                                                                            }

                                                                            /**
     * Lazy define and return the translation table fields.
     *
     * /
                                                                            protected string[] translatedFields() {
                                                                                fields = this.getConfig(
                                                                                "fields");

                                                                                if (fields) {
                                                                                    return fields;
                                                                                }

                                                                                table = this
                                                                                .translationTable;
                                                                                fields = table.getSchema()
                                                                                .columns();
                                                                                fields = array_values(
                                                                                array_diff(fields, [
                                                                                    "id",
                                                                                    "locale"
                                                                                ]));

                                                                                configuration.update("fields", fields);

                                                                                return fields;
                                                                            } */
                                                                        }