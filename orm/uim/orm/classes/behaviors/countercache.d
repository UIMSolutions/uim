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
 *     "Users": [
 *         "post_count"
 *     ]
 * ]
 * ```
 *
 * Counter cache with scope
 * ```
 * [
 *     "Users": [
 *         "posts_published": [
 *             "conditions": [
 *                 "published": BooleanData(true)
 *             ]
 *         ]
 *     ]
 * ]
 * ```
 *
 * Counter cache using custom find
 * ```
 * [
 *     "Users": [
 *         "posts_published": [
 *             "finder": "published" // Will be using findPublished()
 *         ]
 *     ]
 * ]
 * ```
 *
 * Counter cache using lambda function returning the count
 * This is equivalent to example #2
 *
 * ```
 * [
 *     "Users": [
 *         "posts_published": function (IEvent event, IEntity anEntity, DORMTable aTable) {
 *             query = table.find("all").where([
 *                 "published": BooleanData(true),
 *                 "user_id": entity.get("user_id")
 *             ]);
 *             return query.count();
 *          }
 *     ]
 * ]
 * ```
 *
 * When using a lambda function you can return `false` to disable updating the counter value
 * for the current operation.
 *
 * Ignore updating the field if it is dirty
 * ```
 * [
 *     "Users": [
 *         "posts_published": [
 *             "ignoreDirty": BooleanData(true)
 *         ]
 *     ]
 * ]
 * ```
 *
 * You can disable counter updates entirely by sending the `ignoreCounterCache` option
 * to your save operation:
 *
 * ```
 * this.Articles.save(article, ["ignoreCounterCache": BooleanData(true)]);
 * ```
 */
class DCounterCacheBehavior : DBehavior {
    /**
     * Store the fields which should be ignored
     *
     * @var array<string, array<string, bool>>
     * /
    // Store the fields which should be ignored
    protected bool[string][string] my_ignoreDirty = [];

    /**
     * beforeSave callback.
     *
     * Check if a field, which should be ignored, is dirty
     * Params:
     * \UIM\Event\IEvent<\UIM\ORM\Table> myevent The beforeSave event that was fired
     * @param \UIM\Datasource\IEntity myentity The entity that is going to be saved
     * @param \ArrayObject<string, mixed> options The options for the query
     * /
    void beforeSave(IEvent myevent, IEntity myentity, ArrayObject options) {
        if (isSet(options["ignoreCounterCache"]) && options["ignoreCounterCache"] == true) {
            return;
        }
        foreach (configuration as myassoc: mysettings) {
            myassoc = _table.getAssociation(myassoc);
            /** @var string|int myfield * /
            foreach (mysettings as myfield: configData) {
                if (isInt(myfield)) {
                    continue;
                }
                myregistryAlias = myassoc.getTarget().registryKey();
                myentityAlias = myassoc.getProperty();

                if (
                    !isCallable(configData) &&
                    configuration.hasKey("ignoreDirty") &&
                    configData("ignoreDirty"] == true &&
                    myentity.myentityAlias.isDirty(myfield)
                ) {
                   _ignoreDirty[myregistryAlias][myfield] = true;
                }
            }
        }
    }
    
    /**
     * afterSave callback.
     *
     * Makes sure to update counter cache when a new record is created or updated.
     * Params:
     * \UIM\Event\IEvent<\UIM\ORM\Table> myevent The afterSave event that was fired.
     * @param \UIM\Datasource\IEntity myentity The entity that was saved.
     * @param \ArrayObject<string, mixed> options The options for the query
     * /
    void afterSave(IEvent myevent, IEntity myentity, ArrayObject options) {
        if (isSet(options["ignoreCounterCache"]) && options["ignoreCounterCache"] == true) {
            return;
        }
       _processAssociations(myevent, myentity);
       _ignoreDirty = [];
    }
    
    /**
     * afterDelete callback.
     *
     * Makes sure to update counter cache when a record is deleted.
     * Params:
     * \UIM\Event\IEvent<\UIM\ORM\Table> myevent The afterDelete event that was fired.
     * @param \UIM\Datasource\IEntity myentity The entity that was deleted.
     * @param \ArrayObject<string, mixed> options The options for the query
     * /
    void afterDelete_(IEvent myevent, IEntity myentity, ArrayObject options) {
        if (isSet(options["ignoreCounterCache"]) && options["ignoreCounterCache"] == true) {
            return;
        }
       _processAssociations(myevent, myentity);
    }
    
    /**
     * Iterate all associations and update counter caches.
     * Params:
     * \UIM\Event\IEvent<\UIM\ORM\Table> myevent Event instance.
     * @param \UIM\Datasource\IEntity myentity Entity.
     * /
    protected void _processAssociations(IEvent myevent, IEntity myentity) {
        foreach (configuration as myassoc: mysettings) {
            myassoc = _table.getAssociation(myassoc);
           _processAssociation(myevent, myentity, myassoc, mysettings);
        }
    }
    
    /**
     * Updates counter cache for a single association
     * Params:
     * \UIM\Event\IEvent<\UIM\ORM\Table> myevent Event instance.
     * @param \UIM\Datasource\IEntity myentity Entity
     * @param \UIM\ORM\Association myassoc The association object
     * @param array mysettings The settings for counter cache for this association
     * /
    protected void _processAssociation(
        IEvent myevent,
        IEntity myentity,
        Association myassoc,
        array mysettings
    ) {
        /** @var string[] myforeignKeys * /
        myforeignKeys = (array)myassoc.getForeignKeys();
        mycountConditions = myentity.extract(myforeignKeys);

        foreach (mycountConditions as myfield: myvalue) {
            if (myvalue is null) {
                mycountConditions[myfield ~ " IS"] = myvalue;
                unset(mycountConditions[myfield]);
            }
        }
        myprimaryKeys = (array)myassoc.getBindingKey();
        myupdateConditions = array_combine(myprimaryKeys, mycountConditions);

        mycountOriginalConditions = myentity.extractOriginalChanged(myforeignKeys);
        if (mycountOriginalConditions != []) {
            myupdateOriginalConditions = array_combine(myprimaryKeys, mycountOriginalConditions);
        }
        foreach (mysettings as myfield: configData) {
            if (isInt(myfield)) {
                myfield = configData;
                configData = [];
            }
            if (
                isSet(_ignoreDirty[myassoc.getTarget().registryKey()][myfield]) &&
               _ignoreDirty[myassoc.getTarget().registryKey()][myfield] == true
            ) {
                continue;
            }
            if (_shouldUpdateCount(myupdateConditions)) {
                mycount = cast(DClosure)configData
                    ? configData(myevent, myentity, _table, false)
                    : _getCount(configData, mycountConditions);

                if (mycount != false) {
                    myassoc.getTarget().updateAll([myfield: mycount], myupdateConditions);
                }
            }
            if (isSet(myupdateOriginalConditions) && _shouldUpdateCount(myupdateOriginalConditions)) {
                if (cast(DClosure)configData) {
                    mycount = configData(myevent, myentity, _table, true);
                } else {
                    mycount = _getCount(configData, mycountOriginalConditions);
                }
                if (mycount != false) {
                    myassoc.getTarget().updateAll([myfield: mycount], myupdateOriginalConditions);
                }
            }
        }
    }
    
    /**
     * Checks if the count should be updated given a set of conditions.
     * Params:
     * array myconditions Conditions to update count.
     * /
    protected bool _shouldUpdateCount(array myconditions) {
        return !empty(array_filter(myconditions, auto (myvalue) {
            return myvalue !isNull;
        }));
    }
    
    /**
     * Fetches and returns the count for a single field in an association
     * Params:
     * IData[string] configData The counter cache configuration for a single field
     * @param array myconditions Additional conditions given to the query
     * /
    protected int _getCount(IData[string] configData, array myconditions) {
        myfinder = "all";
        if (!empty(configData("finder"])) {
            myfinder = configData("finder"];
            unset(configData("finder"]);
        }
        configData("conditions"] = chain(myconditions, configData("conditions"] ?? []);
        myquery = _table.find(myfinder, ...configData);

        return myquery.count();
    } */
}
