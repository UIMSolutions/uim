module uim.orm.classes.behaviors.translates.strategies.eav;

import uim.orm;

@safe:

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
class DEavStrategy { // TODO }: ITranslateStrategy {
    mixin TConfigurable;

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
            .setDefault("translationTable", "I18n".toJson)
            .setDefault("defaultLocale", Json(null))
            .setDefault("referencename", "".toJson)
            .setDefault("allowEmptyTranslations", true.toJson)
            .setDefault("onlyTranslated", false.toJson)
            .setDefault("strategy", "subquery".toJson)
            .setDefault("tableLocator", Json(null))
            .setDefault("validator", false.toJson);

        return true;
    }

    mixin(TProperty!("string", "name"));

    /*
    mixin TLocatorAware;
    mixin TTranslateStrategy; */

    this(DORMTable aTable, Json[string] configData) {
        if (configuration.contains("tableLocator")) {
            _tableLocator = configuration.get("tableLocator");
        }

        configuration.set(myConfiguration);
        _table = table;
        _translationTable = getTableLocator().get(
            configuration.get("translationTable"],
            ["allowFallbackClass": true.toJson]
       );

        setupAssociations();
    }

    /**
     * Creates the associations between the bound table and every field passed to
     * this method.
     *
     * Additionally it creates a `i18n` HasMany association that will be
     * used for fetching all translations for each record in the bound table.
     */
    protected void setupAssociations() {
        auto fields = configuration.get("fields");
        auto table = configuration.get("translationTable");
        auto model = configuration.get("referenceName");
        auto strategy = configuration.get("strategy");
        auto filter = configuration.get("onlyTranslated");

        auto targetAlias = _translationTable.aliasName();
        auto aliasName = _table.aliasName();
        auto tableLocator = getTableLocator();

        foreach (field; fields) {
            string name = alias ~ "_" ~ field ~ "_translation";

            if (!tableLocator.hasKey(name)) {
                fieldTable = tableLocator.get(name, [
                    "classname": table,
                    "alias": name,
                    "table": _translationTable.getTable(),
                    "allowFallbackClass": true.toJson,
                ]);
            } else {
                fieldTable = tableLocator.get(name);
            }

            conditions = [
                name ~ ".model": model,
                name ~ ".field": field,
            ];
            if (configuration.hasKey("allowEmptyTranslations")) {
                conditions.setPath([name, "content !="], "");
            }

            _table.hasOne(name, [
                "targetTable": fieldTable,
                "foreignKeys": "foreign_key",
                "joinType": filter ? Query.JOIN_TYPE_INNER : Query.JOIN_TYPE_LEFT,
                "conditions": conditions,
                "propertyName": field ~ "_translation",
            ]);
        }

        conditions = ["targetAlias.model": model];
        if (configuration.hasKey("allowEmptyTranslations")) {
            conditions["targetAlias.content !="] = "";
        }

        _table.hasMany(targetAlias, [
            "classname": table,
            "foreignKeys": "foreign_key",
            "strategy": strategy,
            "conditions": conditions,
            "propertyName": "_i18n",
            "dependent": true.toJson,
        ]);
    }

    /**
     * Callback method that listens to the `beforeFind` event in the bound
     * table. It modifies the passed query by eager loading the translated fields
     * and adding a formatter to copy the values into the main table records.
     */
    void beforeFind(IEvent event, DQuery query, SJson[string] options) {
        auto locale = Hash.get(options, "locale", locale());
        if (locale == configuration.get("defaultLocale")) {
            return;
        }

        auto conditions = function (field, locale, query, select) {
            return function (q) use (field, locale, query, select) {
                q.where([q.getRepository().aliasField("locale"): locale]);

                if (
                    query.isAutoFieldsEnabled() ||
                    isIn(field, select, true) ||
                    isIn(_table.aliasField(field), select, true)
               ) {
                    q.select(["id", "content"]);
                }

                return q;
            };
        };

        auto contain = null;
        auto fields = configuration.get("fields");
        auto aliasName = _table.aliasName();
        auto select = query.clause("select");

        auto changeFilter = options.hasKey("filterByCurrentLocale") &&
            options.get("filterByCurrentLocale"] != configuration.get("onlyTranslated");

        foreach (field; fields) {
            auto name = aliasName ~ "_" ~ field ~ "_translation";
            contain.setPath([name, "queryBuilder"], conditions(
                field,
                locale,
                query,
                select
           ));

            if (changeFilter) {
                filter = options.get("filterByCurrentLocale"]
                    ? Query.JOIN_TYPE_INNER
                    : Query.JOIN_TYPE_LEFT;
                contain[name]["joinType"] = filter;
            }
        }

        query.contain(contain);
        // TODO
/*        query.formatResults(function (results) use (locale) {
            return _rowMapper(results, locale);
        }, query.PREPEND);
 */    }

    /**
     * Modifies the entity before it is saved so that translated fields are persisted
     * in the database too.
     */
    void beforeSave(IEvent event, IORMEntity ormEntity, Json[string] options) {
        auto locale = ormEntity.get("_locale") ?: locale();
        auto newOptions = [_translationTable.aliasName(): ["validate": false.toJson]];
        options.set("associated", newOptions + options.get("associated"));

        // Check early if empty translations are present in the entity.
        // If this is the case, unset them to prevent persistence.
        // This only applies if configuration.get("allowEmptyTranslations"] is false
        if (!configuration.getBoolean("allowEmptyTranslations")) {
            unsetEmptyFields(ormEntity);
        }

        bundleTranslatedFields(entity);
        auto bundled = entity.get("_i18n");
        auto noBundled = count(bundled) == 0;

        // No additional translation records need to be saved,
        // as the entity is in the default locale.
        if (noBundled && locale == getConfig("defaultLocale")) {
            return;
        }

        auto values = entity.extract(configuration.get("fields"), true);
        auto fields = values.keys;
        auto noFields = fields.isEmpty;

        // If there are no fields and no bundled translations, or both fields
        // in the default locale and bundled translations we can
        // skip the remaining logic as its not necessary.
        if (noFields && noBundled || (fields && bundled)) {
            return;
        }

        primaryKeys = /* (array) */_table.primaryKeys();
        key = entity.get(currentValue(primaryKeys));

        // When we have no key and bundled translations, we
        // need to mark the entity dirty so the root
        // entity persists.
        if (noFields && bundled && !key) {
            foreach (field; configuration.get("fields")) {
                entity.setDirty(field, true);
            }

            return;
        }

        if (noFields) {
            return;
        }

        auto model = configuration.get("referenceName");
        auto preexistent = null;
        if (key) {
            preexistent = _translationTable.find()
                .select(["id", "field"])
                .where([
                    "field IN": fields,
                    "locale": locale,
                    "foreign_key": key,
                    "model": model,
                ])
                .disableBufferedResults()
                .all()
                .indexBy("field");
        }

        auto modified = null;
        foreach (field, translation; preexistent) {
            translation.set("content", values[field]);
            modified[field] = translation;
        }

        // TODO
/*        new = array_diffinternalKey(values, modified);
        foreach (field, content; new) {
            new[field] = new DORMEntity([
                "locale": locale, 
                "field": field, 
                "content": content, 
                "model": model
            ], 
            [
                "useSetters": false.toJson,
                "markNew": true.toJson,
            ]);
        }

        entity.set("_i18n", array_merge(bundled, (modified + new).values));
        entity.set("_locale", locale, ["setter": false.toJson]);
        entity.setDirty("_locale", false);

        foreach (field; fields) {
            entity.setDirty(field, false);
        }
 */    }

    /**
     * Returns a fully aliased field name for translated fields.
     *
     * If the requested field is configured as a translation field, the `content`
     * field with an alias of a corresponding association is returned. Table-aliased
     * field name is returned for all other fields.
     */
    string translationField(string fieldName) {
        auto table = _table;
        if (locale() == configuration.get("defaultLocale")) {
            return table.aliasField(fieldName);
        }
        
        string associationName = table.aliasName() ~ "_" ~ fieldName ~ "_translation";
        if (table.associations().has(associationName)) {
            return associationName ~ ".content";
        }

        return table.aliasField(fieldName);
    }

    /**
     * Modifies the results from a table find in order to merge the translated fields
     * into each entity for a given locale.
     */
    protected DORMcollections rowMapper(IResultset results, string localeName) {
        return results.map(function (row) use (localeName) {
            /** @var DORMdatasources.IORMEntity|array|null row */
            if (row == null) {
                return row;
            }
            hydrated = !row.isArray;

            foreach (field; configuration.getStringArray("fields")) {
                auto name = field ~ "_translation";
                auto translation = row.get(name);

                if (translation.isEmpty) {
                    row.remove(name);
                    continue;
                }

                auto content = translation.get("content");
                if (!content.isNull) {
                    row[field] = content;
                }

                row.remove(name);
            }

            row["_locale"] = locale;
            if (hydrated) {
                /** @psalm-suppress PossiblyInvalidMethodCall */
                row.clean();
            }

            return row;
        });
    }

    /**
     * Modifies the results from a table find in order to merge full translation
     * records into each entity under the `_translations` key.
     */
    ICollection groupTranslations(IResultset resultsToModify) {
        return null;
        // TODO
        /* 
        return resultsToModify.map(function (row) {
            if (!cast(IORMEntity)row) {
                return row;
            }
            
            auto translations = /* (array) */row.get("_i18n");
            if (translations.isEmpty && row.get("_translations")) {
                return row;
            }
            grouped = new DCollection(translations);

            result = null;
            foreach (grouped.combine("field", "content", "locale") as locale: keys) {
                entityClass = _table.getEntityClass();
                translation = new DORMEntityClass(keys + ["locale": locale], [
                    "markNew": false.toJson,
                    "useSetters": false.toJson,
                    "markClean": true.toJson,
                ]);
                result[locale] = translation;
            }

            options = ["setter": false.toJson, "guard": false.toJson];
            row.set("_translations", result, options);
            row.remove("_i18n");
            row.clean();

            return row;
        }); */
    }

    /**
     * Helper method used to generated multiple translated field entities
     * out of the data found in the `_translations` property in the passed
     * entity. The result will be put into its `_i18n` property.
     */
    protected void bundleTranslatedFields(IORMEntity entity) {
        auto translations = entity.getStringArray("_translations");

        if (translations.isEmpty && !entity.isChanged("_translations")) {
            return;
        }

        fields = configuration.get("fields");
        primaryKeys = /* (array) */_table.primaryKeys();
        key = entity.get(currentValue(primaryKeys));
        find = null;
        contents = null;

        foreach (translations as lang: translation) {
            foreach (fields as field) {
                if (!translation.isChanged(field)) {
                    continue;
                }
                find ~= ["locale": lang, "field": field, "foreign_key IS": key];
                contents ~= new DORMEntity(["content": translation.get(field)], [
                    "useSetters": false.toJson,
                ]);
            }
        }

        if (find.isEmpty) {
            return;
        }

        results = this.findExistingTranslations(find);

        foreach (find as i: translation) {
            if (!empty(results[i])) {
                contents[i].set("id", results[i], ["setter": false.toJson]);
                contents[i].setNew(false);
            } else {
                translation["model"] = configuration.get("referenceName"];
                contents[i].set(translation, ["setter": false.toJson, "guard": false.toJson]);
                contents[i].setNew(true);
            }
        }

        entity.set("_i18n", contents);
    }

    /**
     * Returns the ids found for each of the condition arrays passed for the
     * translations table. Each records is indexed by the corresponding position
     * to the conditions array.
     */
    protected Json[string] findExistingTranslations( Json[string] ruleSet) {
        auto association = _table.getAssociation(_translationTable.aliasName());

        auto query = association.find()
            .select(["id": "", "num": "0"])
            .where(currentValue(ruleSet))
            .disableHydration()
            .disableBufferedResults();

        remove(ruleSet[0]);
        foreach (index, condition; ruleSet) {
            auto q = association.find()
                .select(["id": "", "num": index])
                .where(conditions);
            query.unionAll(q);
        }

        return query.all().combine("num", "id").toJString();
    }
}
