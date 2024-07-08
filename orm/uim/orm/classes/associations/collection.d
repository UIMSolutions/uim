/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
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
     * This makes using plugins simpler as the Plugin.classname syntax is frequently used.
     */
    DORMAssociation add(string aliasName, DORMAssociation associationToAdd) {
        string pluginName = pluginSplit(aliasName)[1];
        return _items[pluginName] = associationToAdd;
    }

    // Creates and adds the Association object to this collection.
    DORMAssociation load(string associationClassname, string associated, Json[string] options = null) {
        options["tableLocator"] = getTableLocator();

        auto association = new classname(associationClassname, someOptions);
        return _add(association.getName(), association);
    }

    // Fetch an attached association by name.
    DORMAssociation get(string associationAlias) {
        return _items.get(associationAlias, null);
    }

    /**
     * Fetch an association by property name.
     * aProperty - The property to find an association by.
     */
    DORMAssociation getByProperty(string aProperty) {
        foreach (myAssociation; _items) {
            if (myAssociation.getProperty() == aProperty) {
                return myAssociation;
            }
        }

        return null;
    }

    // Check for an attached association by name.
    bool has(string associationName) {
        return _items.hasKey(associationName);
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
    DORMAssociation[] getByType(string[] someclassnames...) {
        auto myclassnames = someclassnames.map!(classname => classname.lower).array;

        // TODO
        /* 
        out  = array_filter(_items, function(assoc) use(class) {
            [, name] = namespaceSplit(get_class(assoc)); return isIn(name.lower, classname, true);
        });

        return array_values(out);
        */
        return null; 
    }

    /**
     * Drop/remove an association.
     * Once removed the association will no longer be reachable
     */
    bool remove(string aliasName) {
        return _items.remove(aliasName);
    }

    /**
     * Remove all registered associations.
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
     */
    bool saveParents(DORMTable ormTable, IORMEntity ormEntity, Json[string] associations, Json[string] options = null) {
        return associations.isEmpty
            ? true : _saveAssociations(ormTable, ormEntity, associations, options, false);
    }

    /**
     * Save all the associations that are children of the given entity.
     * Child associations include any association where the given table is not the owning side.
     */
    bool saveChildren(DORMTable ormTable, IORMEntity ormEntity, Json[string] associations, Json[string] options = null) {
        return associations.isEmpty
            ? true : _saveAssociations(ormTable, ormEntity, associations, options, true);
    }

    /**
     * Helper method for saving an association"s data.
     *
     * @param DORMDORMTable aTable The table the save is currently operating on
     * @param DORMDatasource\IORMEntity anEntity The entity to save
     * @param Json[string] associations Array of associations to save.
     */
    protected bool _saveAssociations(
        DORMTable ormTable,
        IORMEntity anEntity,
        array associations,
        Json[string] options,
        bool isOwningSide
   ) {
        options.remove("associated");
        // TODO 
        /* foreach (aliasName, nested; associations ) {
            if (is_int(aliasName)) {
                aliasName = nested;
                nested = null;
            }
            relation = get(aliasName);
            if (!relation) {
                msg =
                    "Cannot save %s, it is not associated to %s"
                    .format(aliasName, ormTable.aliasName())
               );
                throw new DInvalidArgumentException(msg);
            }
            if (relation.isOwningSide(ormTable) != isOwningSide) {
                continue;
            }
            if (!_save(relation, entity, nested, options)) {
                return false;
            }
        } */

        return true;
    }

    // Helper method for saving an association"s data.
    protected bool _save(
        DORMAssociation ormAssociation,
        IORMEntity ormEntity,
        Json[string] nested,
        Json[string] options
   ) {
        if (!ormEntity.isChanged(ormAssociation.getProperty())) {
            return true;
        }
        if (!nested.isEmpty) {
            options = nested.update(options);
        }

        return !ormAssociation.saveAssociated(ormEntity, options).isNull;
    }

    /**
     * Cascade a delete across the various associations.
     * Cascade first across associations for which cascadeCallbacks is true.
     */
    bool cascadeRemove(IORMEntity ormEntity, Json[string] deleteOptions) {
        auto noCascade = null;
        foreach (assoc; _items) {
            if (!assoc.getCascadeCallbacks()) {
                noCascade ~= assoc;
                continue;
            }
            
            if (!assoc.cascadeRemove(ormEntity, deleteOptions)) {
                return false;
            }
        }

        return noCascade.all!(assoc => assoc.cascadeRemove(ormEntity, deleteOptions));
    }

    /**
     * Returns an associative array of association names out a mixed array. 
     * If true is passed, then it returns all association names in this collection.
     */
    Json[string] normalizeKeys(string[] keys) {
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
