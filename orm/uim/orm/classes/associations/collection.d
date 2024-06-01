/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.orm.classes.associations.collection;

import uim.orm;

@safe:

/**
 * A container/collection for association classes.
 *
 * Contains methods for managing associations, and
 * ordering operations around saving and deleting.
 */
class DAssociationCollection { // }: IteratorAggregate {
    mixin TAssociationsNormalizer;
    mixin TLocatorAware;

    // Stored associations
    protected DORMAssociation[] _items;

    /**
     .
     *
     * Sets the default table locator for associations.
     * If no locator is provided, the global one will be used.
     *
     * @param DORMLocator\ILocator|null tableLocator Table locator instance.
     */
    this(ILocator tableLocator = null) {
        if (tableLocator != null) {
            _tableLocator = tableLocator;
        }
    }

    /**
     * Add an association to the collection
     *
     * If the alias added contains a `.` the part preceding the `.` will be dropped.
     * This makes using plugins simpler as the Plugin.Class syntax is frequently used.
     * @param DORMDORMAssociation anAssociation The association to add.
     */
     DORMAssociation add(string anAliasName, DORMAssociation anAssociation) {
        [, anAliasName] = pluginSplit(alias);

        return _items[anAliasName] = anAssociation;
    }

    /**
     * Creates and adds the Association object to this collection.
     *
     * @param string anClassName The name of associationClassname
     * @param string associated The alias for the target table.
     * @param Json[string] options List of options to configure the association definition.
     */
    DORMAssociation load(string associationClassname, string associated, Json[string] optionData = null) {
        someOptions["tableLocator"] = getTableLocator();
        association = new className(associated, someOptions);

        return _add(association.getName(), association);
    }

    // Fetch an attached association by name.
    DORMAssociation get(string associationAlias) {
        return _items[alias] ?? null;
    }

    /**
     * Fetch an association by property name.
     *
     * aProperty - The property to find an association by.
     * returns the association or null.
     */
    DORMAssociation getByProperty(string aProperty) {
        foreach (myAssociation; _items ) {
            if (myAssociation.getProperty() == aProperty) {
                return myAssociation;
            }
        }

        return null;
    }

    /**
     * Check for an attached association by name.
     *
     * @param string anAliasName The association alias to get.
     * return true if the association exists.
     */
    bool has(string anAliasName) {
      return isset(_items[alias]);
    }

    // Get the names of all the associations in the collection.
    string[] keys() {
      return _items.keys;
    }

    /**
     * Get an array of associations matching a specific type.
     *
     * @param string[]|string class DThe type of associations you want.
     *  For example "BelongsTo" or array like ["BelongsTo", "HasOne"]
     * returns an array of Association objects.
     */
    DORMAssociation[] getByType(string[] someClassNames...) {
      auto myClassNames = someClassNames.map!(className => className.lower).array;

      out = array_filter(_items, function (assoc) use (class) {
          [, name] = namespaceSplit(get_class(assoc));

          return in_array(name.lower, class, true);
      });

      return array_values(out);
    }

    /**
     * Drop/remove an association.
     *
     * Once removed the association will no longer be reachable
     */
    bool remove(string aliasName) {
        unset(_items[aliasName]);
    }

    /**
     * Remove all registered associations.
     *
     * Once removed associations will no longer be reachable
     */
    void removeAll() {
      foreach (myAliasName, object; _items) {
        remove(myAliasName);
      }
    }

    /**
     * Save all the associations that are parents of the given entity.
     *
     * Parent associations include any association where the given table
     * is the owning side.
     *
     * aTable - The table entity is for.
     * anEntity - The entity to save associated data for.
     * @param Json[string] associations The list of associations to save parents from.
     *  associations not in this list will not be saved.
     * @param Json[string] options The options for the save operation.
     */
    bool saveParents(DORMTable aTable, IORMEntity anEntity, Json[string] associations, Json[string] optionData = null) {
      return associations.isEmpty
        ? true
        : _saveAssociations(aTable, entity, associations, options, false);
    }

    /**
     * Save all the associations that are children of the given entity.
     *
     * Child associations include any association where the given table is not the owning side.
     *
     * @param DORMDORMTable aTable The table entity is for.
     * @param DORMDatasource\IORMEntity anEntity The entity to save associated data for.
     * @param Json[string] associations The list of associations to save children from.
     *  associations not in this list will not be saved.
     * @param Json[string] options The options for the save operation.
     */
    bool saveChildren(DORMTable aTable, IORMEntity anEntity, Json[string] associations, Json[string] optionData) {
        return associations.isEmpty
            ? true
            : _saveAssociations(table, entity, associations, options, true);
    }

    /**
     * Helper method for saving an association"s data.
     *
     * @param DORMDORMTable aTable The table the save is currently operating on
     * @param DORMDatasource\IORMEntity anEntity The entity to save
     * @param Json[string] associations Array of associations to save.
     * @param Json[string] options Original options
     * returns True if Success
     */
    protected bool _saveAssociations(
        DORMTable aTable,
        IORMEntity anEntity,
        array associations,
        Json[string] optionData,
        bool isOwningSide
    ) {
        options.remove("associated"]);
        foreach (associations as alias: nested) {
            if (is_int(alias)) {
                alias = nested;
                nested = null;
            }
            relation = get(alias);
            if (!relation) {
                msg =  
                    "Cannot save %s, it is not associated to %s"
                    .format(alias, table.aliasName())
                );
                throw new DInvalidArgumentException(msg);
            }
            if (relation.isOwningSide(table) != isOwningSide) {
                continue;
            }
            if (!_save(relation, entity, nested, options)) {
                return false;
            }
        }

        return true;
    }

    /**
     * Helper method for saving an association"s data.
     *
     * @param DORMDORMAssociation anAssociation The association object to save with.
     * @param DORMDatasource\IORMEntity anEntity The entity to save
     * @param Json[string] nested Options for deeper associations
     * @param Json[string] options Original options
     */
    protected bool _save(
        DORMAssociation anAssociation,
        IORMEntity anEntity,
        array nested,
        Json[string] optionData
    ) {
        if (!anEntity.isDirty(association.getProperty())) {
            return true;
        }
        if (!nested.isEmpty) {
            options = nested + options;
        }

        return (bool)association.saveAssociated(entity, options);
    }

    /**
     * Cascade a delete across the various associations.
     * Cascade first across associations for which cascadeCallbacks is true.
     *
     * @param DORMDatasource\IORMEntity anEntity The entity to delete associations for.
     * @param Json[string] options The options used in the delete operation.
     */
    bool cascaderemove(IORMEntity anEntity, Json[string] optionData) {
        noCascade = null;
        foreach (_items as assoc) {
            if (!assoc.getCascadeCallbacks()) {
                noCascade ~= assoc;
                continue;
            }
            success = assoc.cascaderemove(anEntity, options);
            if (!success) {
                return false;
            }
        }

        foreach (noCascade as assoc) {
            success = assoc.cascaderemove(anEntity, options);
            if (!success) {
                return false;
            }
        }

        return true;
    }

    /**
     * Returns an associative array of association names out a mixed
     * array. If true is passed, then it returns all association names
     * in this collection.
     *
     * @param Json keys the list of association names to normalize
     */
    Json[string] normalizeKeys(keys) {
        if (keys == true) {
            keys = keys();
        }

        if (keys.isEmpty) {
            return [];
        }

        return _normalizeAssociations(keys);
    }

    // Allow looping through the associations
    DORMAssociation[string] getIterator() {
      return new DArrayIterator(_items);
    }
} 
