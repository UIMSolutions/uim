module uim.orm.classes.behaviors.countercache;

import uim.orm;

@safe:

/**
 * CounterCache behavior
 *
 * Enables models to cache the amount of connections in a given relation.
 *
 * Examples with Post model belonging to User model
 *
 * Regular counter cache
 * ```
 * [
 *    "Users": [
 *        "post_count"
 *    ]
 * ]
 * ```
 *
 * Counter cache with scope
 * ```
 * [
 *    "Users": [
 *        "posts_published": [
 *            "conditions": [
 *                "published": true.toJson
 *            ]
 *        ]
 *    ]
 * ]
 * ```
 *
 * Counter cache using custom find
 * ```
 * [
 *    "Users": [
 *        "posts_published": [
 *            "finder": "published" // Will be using findPublished()
 *        ]
 *    ]
 * ]
 * ```
 *
 * Counter cache using lambda function returning the count
 * This is equivalent to example #2
 *
 * ```
 * [
 *    "Users": [
 *        "posts_published": function (IEvent event, IORMEntity anEntity, DORMTable aTable) {
 *            query = table.find("all").where([
 *                "published": true.toJson,
 *                "user_id": entity.get("user_id")
 *            ]);
 *            return query.count();
 *         }
 *    ]
 * ]
 * ```
 *
 * When using a lambda function you can return `false` to disable updating the counter value
 * for the current operation.
 *
 * Ignore updating the field if it is dirty
 * ```
 * [
 *    "Users": [
 *        "posts_published": [
 *            "ignoreDirty": true.toJson
 *        ]
 *    ]
 * ]
 * ```
 *
 * You can disable counter updates entirely by sending the `ignoreCounterCache` option
 * to your save operation:
 *
 * ```
 * this.Articles.save(article, ["ignoreCounterCache": true.toJson]);
 * ```
 */
class DCounterCacheBehavior : DBehavior {
    /**
     * Store the fields which should be ignored
     *
     * @var array<string, array<string, bool>>
     */
    // Store the fields which should be ignored
    protected bool[string][string] _ignoreDirty = null;

    /**
     * beforeSave callback.
     * Check if a field, which should be ignored, is dirty
     */
    void beforeSave(IEvent myevent, IORMEntity ormEntity, Json[string] options) {
        if (options.hasKey("ignoreCounterCache") && options.getBoolean("ignoreCounterCache")) {
            return;
        }
        foreach (association, mysettings; configuration) {
            association = _table.getAssociation(association);
            /** @var string|int fieldName */
            foreach (fieldName, configData; mysettings) {
                if (isInteger(fieldName)) {
                    continue;
                }

                auto myregistryAlias = association.getTarget().registryKey();
                auto myentityAlias = association.getProperty();
                if (
                    !isCallable(configData) &&
                    configuration.hasKey("ignoreDirty") &&
                    configuration.get("ignoreDirty") == true &&
                    ormEntity.myentityAlias.isChanged(fieldName)
               ) {
                   _ignoreDirty[myregistryAlias][fieldName] = true;
                }
            }
        }
    }
    
    /**
     * afterSave callback.
     * Makes sure to update counter cache when a new record is created or updated.
     */
    void afterSave(IEvent firedEvent, IORMEntity entity, Json[string] queryOptions) {
        if (queryOptions.hasKey("ignoreCounterCache") && queryoptions.get("ignoreCounterCache"] == true) {
            return;
        }
       _processAssociations(firedEvent, entity);
       _ignoreDirty = null;
    }
    
    /**
     * afterDelete callback.
     *
     * Makes sure to update counter cache when a record is deleted.
     */
    void afterremove(IEvent event, IORMEntity ormEntity, Json[string] options) {
        if (options.getBoolean("ignoreCounterCache")) {
            return;
        }
       _processAssociations(event, ormEntity);
    }
    
    // Iterate all associations and update counter caches.
    protected void _processAssociations(IEvent event, IORMEntity ormEntity) {
        configuration.byKeyValue
            .each!((assocSettings) {
                auto tableAssociation = _table.getAssociation(assocSettings.key);
                _processAssociation(event, ormEntity, tableAssociation, assocSettings.value);
            });
    }
    
    // Updates counter cache for a single association
    protected void _processAssociation(
        IEvent myevent,
        IORMEntity ormEntity,
        DAssociation association,
        Json[string] mysettings
   ) {
        /** @var string[] myforeignKeys */
        myforeignKeys = /* (array) */association.foreignKeys();
        mycountConditions = ormEntity.extract(myforeignKeys);

        foreach (fieldName, myvalue; mycountConditions) {
            if (myvalue.isNull) {
                mycountConditions.set(fieldName ~ " IS", myvalue);
                mycountConditions.remove(fieldName);
            }
        }
        
        string[] bindingKeys = association.getBindingKeys();
        auto myupdateConditions = array_combine(bindingKeys, mycountConditions);
        auto mycountOriginalConditions = ormEntity.extractOriginalChanged(myforeignKeys);
        if (mycountOriginalConditions !is null) {
            myupdateOriginalConditions = array_combine(bindingKeys, mycountOriginalConditions);
        }

        mysettings.byKeyValue
            .each((fieldData) {
                if (isInteger(fieldName)) {
                    fieldName = fieldData.value;
                    fieldData.value = null;
                }
                if (
                    isSet(_ignoreDirty[association.getTarget().registryKey()][fieldName]) &&
                _ignoreDirty[association.getTarget().registryKey()][fieldName] == true
               ) {
                    continue;
                }
                if (_shouldUpdateCount(myupdateConditions)) {
                    mycount = cast(DClosure)fieldData.value
                        ? fieldData.value(myevent, ormEntity, _table, false)
                        : _getCount(fieldData.value, mycountConditions);

                    if (mycount == true) {
                        association.getTarget().updateAll([fieldName: mycount], myupdateConditions);
                    }
                }
                if (isSet(myupdateOriginalConditions) && _shouldUpdateCount(myupdateOriginalConditions)) {
                    mycount = cast(DClosure)fieldData.value
                        ? fieldData.value(myevent, ormEntity, _table, true)
                        : _getCount(fieldData.value, mycountOriginalConditions);

                    if (mycount == true) {
                        association.getTarget().updateAll([fieldName: mycount], myupdateOriginalConditions);
                    }
                }
        });
    }
    
    // Checks if the count should be updated given a set of conditions.
    protected bool _shouldUpdateCount(Json[string] conditions) {
        return !empty(array_filter(conditions, auto (myvalue) {
            return myvalue !is null;
        }));
    }
    
    // Fetches and returns the count for a single field in an association
    protected int _getCount(Json[string] configData, Json[string] conditions) {
        string myfinder = "all";
        if (!configData.isEmpty("finder")) {
            remove(configuration.getString("finder"));
        }
        // TODO configuration.set("conditions", chain(conditions, configuration.getArray("conditions"));
        // myquery = _table.find(myfinder, ...configData); */

        return 0; //TODO myquery.count();
    }
}
