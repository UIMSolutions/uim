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
     *
     * Check if a field, which should be ignored, is dirty
     * Params:
     * \UIM\Event\IEvent<\ORM\Table> myevent The beforeSave event that was fired
     * @param \UIM\Datasource\IORMEntity myentity The entity that is going to be saved
     * @param \ArrayObject<string, mixed> options The options for the query
     */
    void beforeSave(IEvent myevent, IORMEntity myentity, ArrayObject options) {
        if (isSet(options["ignoreCounterCache"]) && options["ignoreCounterCache"] == true) {
            return;
        }
        foreach (configuration as myassoc: mysettings) {
            myassoc = _table.getAssociation(myassoc);
            /** @var string|int fieldName */
            foreach (mysettings as fieldName: configData) {
                if (isInt(fieldName)) {
                    continue;
                }
                myregistryAlias = myassoc.getTarget().registryKey();
                myentityAlias = myassoc.getProperty();

                if (
                    !isCallable(configData) &&
                    configuration.hasKey("ignoreDirty") &&
                    configuration.get("ignoreDirty"] == true &&
                    myentity.myentityAlias.isDirty(fieldName)
                ) {
                   _ignoreDirty[myregistryAlias][fieldName] = true;
                }
            }
        }
    }
    
    /**
     * afterSave callback.
     *
     * Makes sure to update counter cache when a new record is created or updated.
     */
    void afterSave(IEvent firedEvent, IORMEntity entity, ArrayObject queryOptions) {
        if (isSet(queryOptions["ignoreCounterCache"]) && queryOptions["ignoreCounterCache"] == true) {
            return;
        }
       _processAssociations(firedEvent, entity);
       _ignoreDirty = null;
    }
    
    /**
     * afterDelete callback.
     *
     * Makes sure to update counter cache when a record is deleted.
     * Params:
     * \UIM\Event\IEvent<\ORM\Table> myevent The afterDelete event that was fired.
     * @param \UIM\Datasource\IORMEntity myentity The entity that was deleted.
     * @param \ArrayObject<string, mixed> options The options for the query
     */
    void afterremove(IEvent myevent, IORMEntity myentity, ArrayObject options) {
        if (isSet(options["ignoreCounterCache"]) && options["ignoreCounterCache"] == true) {
            return;
        }
       _processAssociations(myevent, myentity);
    }
    
    /**
     * Iterate all associations and update counter caches.
     * Params:
     * \UIM\Event\IEvent<\ORM\Table> myevent Event instance.
     * @param \UIM\Datasource\IORMEntity myentity Entity.
     */
    protected void _processAssociations(IEvent anEvent, IORMEntity anEntity) {
        configuration.byKeyValue
            .each!((assocSettings) {
                auto newAssoc = _table.getAssociation(assocSettings.key);
                _processAssociation(anEvent, anEntity, newAssoc, assocSettings.value);
            }
    }
    
    /**
     * Updates counter cache for a single association
     * Params:
     * \UIM\Event\IEvent<\ORM\Table> myevent Event instance.
     * @param \UIM\Datasource\IORMEntity myentity Entity
     * @param \ORM\Association myassoc The association object
     * @param Json[string] mysettings The settings for counter cache for this association
     */
    protected void _processAssociation(
        IEvent myevent,
        IORMEntity myentity,
        DAssociation myassoc,
        Json[string] mysettings
    ) {
        /** @var string[] myforeignKeys */
        myforeignKeys = (array)myassoc.foreignKeys();
        mycountConditions = myentity.extract(myforeignKeys);

        foreach (mycountConditions as fieldName: myvalue) {
            if (myvalue.isNull) {
                mycountConditions[fieldName ~ " IS"] = myvalue;
                unset(mycountConditions[fieldName]);
            }
        }
        myprimaryKeys = (array)myassoc.getBindingKey();
        myupdateConditions = array_combine(myprimaryKeys, mycountConditions);

        mycountOriginalConditions = myentity.extractOriginalChanged(myforeignKeys);
        if (mycountOriginalConditions != []) {
            myupdateOriginalConditions = array_combine(myprimaryKeys, mycountOriginalConditions);
        }

        mysettings.byKeyValue
            .each((fieldData) {
                if (isInt(fieldName)) {
                    fieldName = fieldData.value;
                    fieldData.value = null;
                }
                if (
                    isSet(_ignoreDirty[myassoc.getTarget().registryKey()][fieldName]) &&
                _ignoreDirty[myassoc.getTarget().registryKey()][fieldName] == true
                ) {
                    continue;
                }
                if (_shouldUpdateCount(myupdateConditions)) {
                    mycount = cast(DClosure)fieldData.value
                        ? fieldData.value(myevent, myentity, _table, false)
                        : _getCount(fieldData.value, mycountConditions);

                    if (mycount != false) {
                        myassoc.getTarget().updateAll([fieldName: mycount], myupdateConditions);
                    }
                }
                if (isSet(myupdateOriginalConditions) && _shouldUpdateCount(myupdateOriginalConditions)) {
                    mycount = cast(DClosure)fieldData.value
                        ? fieldData.value(myevent, myentity, _table, true)
                        : _getCount(fieldData.value, mycountOriginalConditions);

                    if (mycount != false) {
                        myassoc.getTarget().updateAll([fieldName: mycount], myupdateOriginalConditions);
                    }
                }
        }
    }
    
    /**
     * Checks if the count should be updated given a set of conditions.
     * Params:
     * Json[string] myconditions Conditions to update count.
     */
    protected bool _shouldUpdateCount(Json[string] myconditions) {
        return !empty(array_filter(myconditions, auto (myvalue) {
            return myvalue !isNull;
        }));
    }
    
    /**
     * Fetches and returns the count for a single field in an association
     * Params:
     * Json[string] configData The counter cache configuration for a single field
     * @param Json[string] myconditions Additional conditions given to the query
     */
    protected int _getCount(Json[string] configData, Json[string] myconditions) {
        myfinder = "all";
        if (!igData.isEmpty("finder")) {
            myfinder = configuration.get("finder"];
            unset(configuration.get("finder"]);
        }
        configuration.get("conditions"] = chain(myconditions, configuration.get("conditions"] ?? []);
        myquery = _table.find(myfinder, ...configData);

        return myquery.count();
    }
}
