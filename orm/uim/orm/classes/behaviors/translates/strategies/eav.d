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

        configuration.updateDefaults([
            "fields": Json.emptyArray,
            "translationTable": Json("I18n"),
            "defaultLocale": Json(null),
            "referencename": "".toJson,
            "allowEmptyTranslations": true.toJson,
            "onlyTranslated": false.toJson,
            "strategy": Json("subquery"),
            "tableLocator": Json(null),
            "validator": false.toJson,
        ]);

        return true;
    }

    mixin(TProperty!("string", "name"));

    /*
    mixin TLocatorAware;
    mixin TTranslateStrategy;

  

    /**
     * Constructor
     *
     * @param DORMDORMTable aTable The table this strategy is attached to.
     * @param Json[string] myConfiguration The config for this strategy.
     * /
    this(DORMTable aTable, Json[string] configData) {
        if (configuration.has("tableLocator"])) {
            _tableLocator = configuration.get("tableLocator"];
        }

        configuration.update(myConfiguration);
        this.table = table;
        this.translationTable = this.getTableLocator().get(
            configuration.get("translationTable"],
            ["allowFallbackClass": true.toJson]
        );

        this.setupAssociations();
    }

    /**
     * Creates the associations between the bound table and every field passed to
     * this method.
     *
     * Additionally it creates a `i18n` HasMany association that will be
     * used for fetching all translations for each record in the bound table.
     * /
    protected void setupAssociations() {
        fields = configuration.get("fields"];
        table = configuration.get("translationTable"];
        model = configuration.get("referenceName"];
        strategy = configuration.get("strategy"];
        filter = configuration.get("onlyTranslated"];

        targetAlias = this.translationTable.aliasName();
        alias = this.table.aliasName();
        tableLocator = this.getTableLocator();

        foreach (fields as field) {
            name = alias ~ "_" ~ field ~ "_translation";

            if (!tableLocator.exists(name)) {
                fieldTable = tableLocator.get(name, [
                    "className": table,
                    "alias": name,
                    "table": this.translationTable.getTable(),
                    "allowFallbackClass": true.toJson,
                ]);
            } else {
                fieldTable = tableLocator.get(name);
            }

            conditions = [
                name ~ ".model": model,
                name ~ ".field": field,
            ];
            if (!configuration.get("allowEmptyTranslations"]) {
                conditions[name ~ ".content !="] = "";
            }

            this.table.hasOne(name, [
                "targetTable": fieldTable,
                "foreignKey": "foreign_key",
                "joinType": filter ? Query.JOIN_TYPE_INNER : Query.JOIN_TYPE_LEFT,
                "conditions": conditions,
                "propertyName": field ~ "_translation",
            ]);
        }

        conditions = ["targetAlias.model": model];
        if (!configuration.get("allowEmptyTranslations"]) {
            conditions["targetAlias.content !="] = "";
        }

        this.table.hasMany(targetAlias, [
            "className": table,
            "foreignKey": "foreign_key",
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
     *
     * @param DORMevents.IEvent event The beforeFind event that was fired.
     * @param DORMQuery query Query
     * @param \ArrayObject options The options for the query
     * /
    void beforeFind(IEvent event, Query query, ArrayObject options) {
        locale = Hash.get(options, "locale", this.getLocale());

        if (locale == this.getConfig("defaultLocale")) {
            return;
        }

        conditions = function (field, locale, query, select) {
            return function (q) use (field, locale, query, select) {
                q.where([q.getRepository().aliasField("locale"): locale]);

                if (
                    query.isAutoFieldsEnabled() ||
                    in_array(field, select, true) ||
                    in_array(this.table.aliasField(field), select, true)
                ) {
                    q.select(["id", "content"]);
                }

                return q;
            };
        };

        contain = null;
        fields = configuration.get("fields"];
        alias = this.table.aliasName();
        select = query.clause("select");

        changeFilter = isset(options["filterByCurrentLocale"]) &&
            options["filterByCurrentLocale"] != configuration.get("onlyTranslated"];

        foreach (fields as field) {
            name = alias ~ "_" ~ field ~ "_translation";

            contain[name]["queryBuilder"] = conditions(
                field,
                locale,
                query,
                select
            );

            if (changeFilter) {
                filter = options["filterByCurrentLocale"]
                    ? Query.JOIN_TYPE_INNER
                    : Query.JOIN_TYPE_LEFT;
                contain[name]["joinType"] = filter;
            }
        }

        query.contain(contain);
        query.formatResults(function (results) use (locale) {
            return _rowMapper(results, locale);
        }, query.PREPEND);
    }

    /**
     * Modifies the entity before it is saved so that translated fields are persisted
     * in the database too.
     *
     * @param DORMevents.IEvent event The beforeSave event that was fired
     * @param DORMDatasource\IEntity anEntity The entity that is going to be saved
     * @param \ArrayObject options the options passed to the save method
     * /
    void beforeSave(IEvent event, IEntity anEntity, ArrayObject options) {
        locale = entity.get("_locale") ?: this.getLocale();
        newOptions = [this.translationTable.aliasName(): ["validate": false.toJson]];
        options["associated"] = newOptions + options["associated"];

        // Check early if empty translations are present in the entity.
        // If this is the case, unset them to prevent persistence.
        // This only applies if configuration.get("allowEmptyTranslations"] is false
        if (configuration.get("allowEmptyTranslations"] == false) {
            this.unsetEmptyFields(entity);
        }

        this.bundleTranslatedFields(entity);
        bundled = entity.get("_i18n") ?: [];
        noBundled = count(bundled) == 0;

        // No additional translation records need to be saved,
        // as the entity is in the default locale.
        if (noBundled && locale == this.getConfig("defaultLocale")) {
            return;
        }

        values = entity.extract(configuration.get("fields"], true);
        fields = values.keys;
        noFields = fields.isEmpty;

        // If there are no fields and no bundled translations, or both fields
        // in the default locale and bundled translations we can
        // skip the remaining logic as its not necessary.
        if (noFields && noBundled || (fields && bundled)) {
            return;
        }

        primaryKeys = (array)this.table.primaryKeys();
        key = entity.get(current(primaryKeys));

        // When we have no key and bundled translations, we
        // need to mark the entity dirty so the root
        // entity persists.
        if (noFields && bundled && !key) {
            foreach (configuration.get("fields"] as field) {
                entity.setDirty(field, true);
            }

            return;
        }

        if (noFields) {
            return;
        }

        model = configuration.get("referenceName"];

        preexistent = null;
        if (key) {
            preexistent = this.translationTable.find()
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

        modified = null;
        foreach (preexistent as field: translation) {
            translation.set("content", values[field]);
            modified[field] = translation;
        }

        new = array_diff_key(values, modified);
        foreach (new as field: content) {
            new[field] = new DORMEntity(compact("locale", "field", "content", "model"), [
                "useSetters": false.toJson,
                "markNew": true.toJson,
            ]);
        }

        entity.set("_i18n", array_merge(bundled, array_values(modified + new)));
        entity.set("_locale", locale, ["setter": false.toJson]);
        entity.setDirty("_locale", false);

        foreach (fields as field) {
            entity.setDirty(field, false);
        }
    }

    /**
     * Returns a fully aliased field name for translated fields.
     *
     * If the requested field is configured as a translation field, the `content`
     * field with an alias of a corresponding association is returned. Table-aliased
     * field name is returned for all other fields.
     *
     * @param string field Field name to be aliased.
     * /
    string translationField(string field) {
        table = this.table;
        if (this.getLocale() == this.getConfig("defaultLocale")) {
            return table.aliasField(field);
        }
        associationName = table.aliasName() ~ "_" ~ field ~ "_translation";

        if (table.associations().has(associationName)) {
            return associationName ~ ".content";
        }

        return table.aliasField(field);
    }

    /**
     * Modifies the results from a table find in order to merge the translated fields
     * into each entity for a given locale.
     *
     * @param DORMDatasource\IResultset results Results to map.
     * @param string locale Locale string
     * @return DORMcollections.ICollection
     * /
    protected function rowMapper(results, locale) {
        return results.map(function (row) use (locale) {
            /** @var DORMdatasources.IEntity|array|null row * /
            if (row == null) {
                return row;
            }
            hydrated = !(row.isArray;

            foreach (configuration.get("fields"] as field) {
                name = field ~ "_translation";
                translation = row[name] ?? null;

                if (translation == null || translation == false) {
                    unset(row[name]);
                    continue;
                }

                content = translation["content"] ?? null;
                if (content != null) {
                    row[field] = content;
                }

                unset(row[name]);
            }

            row["_locale"] = locale;
            if (hydrated) {
                /** @psalm-suppress PossiblyInvalidMethodCall * /
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
     * @return DORMcollections.ICollection
     * /
    function groupTranslations(results): ICollection
    {
        return results.map(function (row) {
            if (!row instanceof IEntity) {
                return row;
            }
            translations = (array)row.get("_i18n");
            if (empty(translations) && row.get("_translations")) {
                return row;
            }
            grouped = new DCollection(translations);

            result = null;
            foreach (grouped.combine("field", "content", "locale") as locale: keys) {
                entityClass = this.table.getEntityClass();
                translation = new DORMEntityClass(keys + ["locale": locale], [
                    "markNew": false.toJson,
                    "useSetters": false.toJson,
                    "markClean": true.toJson,
                ]);
                result[locale] = translation;
            }

            options = ["setter": false.toJson, "guard": false.toJson];
            row.set("_translations", result, options);
            unset(row["_i18n"]);
            row.clean();

            return row;
        });
    }

    /**
     * Helper method used to generated multiple translated field entities
     * out of the data found in the `_translations` property in the passed
     * entity. The result will be put into its `_i18n` property.
     *
     * @param DORMDatasource\IEntity anEntity Entity
     * /
    protected void bundleTranslatedFields(entity) {
        translations = (array)entity.get("_translations");

        if (empty(translations) && !entity.isDirty("_translations")) {
            return;
        }

        fields = configuration.get("fields"];
        primaryKeys = (array)this.table.primaryKeys();
        key = entity.get(current(primaryKeys));
        find = null;
        contents = null;

        foreach (translations as lang: translation) {
            foreach (fields as field) {
                if (!translation.isDirty(field)) {
                    continue;
                }
                find[] = ["locale": lang, "field": field, "foreign_key IS": key];
                contents[] = new DORMEntity(["content": translation.get(field)], [
                    "useSetters": false.toJson,
                ]);
            }
        }

        if (empty(find)) {
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
     *
     * @param Json[string] ruleSet An array of array of conditions to be used for finding each
     * /
    // TODO protected Json[string] findExistingTranslations(ruleSet) {
        association = this.table.getAssociation(this.translationTable.aliasName());

        query = association.find()
            .select(["id", "num": 0])
            .where(current(ruleSet))
            .disableHydration()
            .disableBufferedResults();

        unset(ruleSet[0]);
        foreach (ruleSet as i: conditions) {
            q = association.find()
                .select(["id", "num": i])
                .where(conditions);
            query.unionAll(q);
        }

        return query.all().combine("num", "id").toArray();
    } */
}
