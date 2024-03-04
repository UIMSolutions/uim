module uim.orm.behaviors;

@safe:
import uim.orm;

use ArrayObject;
import DORMdatasources.IEntity;
import DORMevents.IEvent;
import DORMAssociation;
import DORMBehavior;
use Closure;

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
 *                 "published": true
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
 *                 "published": true,
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
 *             "ignoreDirty": true
 *         ]
 *     ]
 * ]
 * ```
 *
 * You can disable counter updates entirely by sending the `ignoreCounterCache` option
 * to your save operation:
 *
 * ```
 * this.Articles.save(article, ["ignoreCounterCache": true]);
 * ```
 */
class CounterCacheBehavior : Behavior {
    /**
     * Store the fields which should be ignored
     *
     * @var array<string, array<string, bool>>
     */
    protected _ignoreDirty = null;

    /**
     * beforeSave callback.
     *
     * Check if a field, which should be ignored, is dirty
     *
     * @param DORMevents.IEvent event The beforeSave event that was fired
     * @param DORMDatasource\IEntity anEntity The entity that is going to be saved
     * @param \ArrayObject options The options for the query
     */
    void beforeSave(IEvent event, IEntity anEntity, ArrayObject options) {
        if (isset(options["ignoreCounterCache"]) && options["ignoreCounterCache"] == true) {
            return;
        }

        foreach (configuration as assoc: settings) {
            assoc = _table.getAssociation(assoc);
            foreach (settings as field: myConfiguration) {
                if (is_int(field)) {
                    continue;
                }

                registryAlias = assoc.getTarget().registryKey();
                entityAlias = assoc.getProperty();

                if (
                    !is_callable(myConfiguration) &&
                    isset(myconfiguration["ignoreDirty"]) &&
                    myconfiguration["ignoreDirty"] == true &&
                    entity.entityAlias.isDirty(field)
                ) {
                    _ignoreDirty[registryAlias][field] = true;
                }
            }
        }
    }

    /**
     * afterSave callback.
     *
     * Makes sure to update counter cache when a new record is created or updated.
     *
     * @param DORMevents.IEvent event The afterSave event that was fired.
     * @param DORMDatasource\IEntity anEntity The entity that was saved.
     * @param \ArrayObject options The options for the query
     */
    void afterSave(IEvent event, IEntity anEntity, ArrayObject options) {
        if (isset(options["ignoreCounterCache"]) && options["ignoreCounterCache"] == true) {
            return;
        }

        _processAssociations(event, entity);
        _ignoreDirty = null;
    }

    /**
     * afterDelete callback.
     *
     * Makes sure to update counter cache when a record is deleted.
     *
     * @param DORMevents.IEvent event The afterDelete event that was fired.
     * @param DORMDatasource\IEntity anEntity The entity that was deleted.
     * @param \ArrayObject options The options for the query
     */
    void afterDelete(IEvent event, IEntity anEntity, ArrayObject options) {
        if (isset(options["ignoreCounterCache"]) && options["ignoreCounterCache"] == true) {
            return;
        }

        _processAssociations(event, entity);
    }

    /**
     * Iterate all associations and update counter caches.
     *
     * @param DORMevents.IEvent event Event instance.
     * @param DORMDatasource\IEntity anEntity Entity.
     */
    protected void _processAssociations(IEvent event, IEntity anEntity) {
        foreach (configuration as assoc: settings) {
            assoc = _table.getAssociation(assoc);
            _processAssociation(event, entity, assoc, settings);
        }
    }

    /**
     * Updates counter cache for a single association
     *
     * @param DORMevents.IEvent event Event instance.
     * @param DORMDatasource\IEntity anEntity Entity
     * @param DORMAssociation assoc The association object
     * @param array settings The settings for counter cache for this association
     * @return void
     * @throws \RuntimeException If invalid callable is passed.
     */
    protected void _processAssociation(
        IEvent event,
        IEntity anEntity,
        Association assoc,
        array settings
    ) {
        foreignKeys = (array)assoc.getForeignKey();
        countConditions = entity.extract(foreignKeys);

        foreach (countConditions as field: value) {
            if (value == null) {
                countConditions[field ~ " IS"] = value;
                unset(countConditions[field]);
            }
        }

        primaryKeys = (array)assoc.getBindingKey();
        updateConditions = array_combine(primaryKeys, countConditions);

        countOriginalConditions = entity.extractOriginalChanged(foreignKeys);
        if (countOriginalConditions != []) {
            updateOriginalConditions = array_combine(primaryKeys, countOriginalConditions);
        }

        foreach (settings as field: myConfiguration) {
            if (is_int(field)) {
                field = myConfiguration;
                myConfiguration = null;
            }

            if (
                isset(_ignoreDirty[assoc.getTarget().registryKey()][field]) &&
                _ignoreDirty[assoc.getTarget().registryKey()][field] == true
            ) {
                continue;
            }

            if (_shouldUpdateCount(updateConditions)) {
                if (myConfiguration instanceof Closure) {
                    count = myConfiguration(event, entity, _table, false);
                } else {
                    count = _getCount(myConfiguration, countConditions);
                }
                if (count != false) {
                    assoc.getTarget().updateAll([field: count], updateConditions);
                }
            }

            if (isset(updateOriginalConditions) && _shouldUpdateCount(updateOriginalConditions)) {
                if (myConfiguration instanceof Closure) {
                    count = myConfiguration(event, entity, _table, true);
                } else {
                    count = _getCount(myConfiguration, countOriginalConditions);
                }
                if (count != false) {
                    assoc.getTarget().updateAll([field: count], updateOriginalConditions);
                }
            }
        }
    }

    /**
     * Checks if the count should be updated given a set of conditions.
     *
     * @param array conditions Conditions to update count.
     * @return bool True if the count update should happen, false otherwise.
     */
    protected function _shouldUpdateCount(array conditions) {
        return !empty(array_filter(conditions, function (value) {
            return value != null;
        }));
    }

    /**
     * Fetches and returns the count for a single field in an association
     *
     * @param array<string, mixed> myConfiguration The counter cache configuration for a single field
     * @param array conditions Additional conditions given to the query
     * @return int The number of relations matching the given config and conditions
     */
    protected int _getCount(Json myConfiguration, array conditions) {
        finder = "all";
        if (!empty(myconfiguration["finder"])) {
            finder = myconfiguration["finder"];
            unset(myconfiguration["finder"]);
        }

        myconfiguration["conditions"] = array_merge(conditions, myconfiguration["conditions"] ?? []);
        query = _table.find(finder, myConfiguration);

        return query.count();
    }
}
