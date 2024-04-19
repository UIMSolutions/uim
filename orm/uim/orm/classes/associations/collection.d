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
    /* mixin TAssociationsNormalizer;
    mixin TLocatorAware;

    // Stored associations
    protected DORMAssociation[] _items;

    /**
     * Constructor.
     *
     * Sets the default table locator for associations.
     * If no locator is provided, the global one will be used.
     *
     * @param DORMLocator\ILocator|null tableLocator Table locator instance.
     * /
    this(?ILocator tableLocator = null) {
        if (tableLocator != null) {
            _tableLocator = tableLocator;
        }
    }

    /**
     * Add an association to the collection
     *
     * If the alias added contains a `.` the part preceding the `.` will be dropped.
     * This makes using plugins simpler as the Plugin.Class syntax is frequently used.
     *
     * anAliasName -  The association alias
     * @param DORMDORMAssociation anAssociation The association to add.
     * @return  The association object being added.
     * /
     DORMAssociation add(string anAliasName, DORMAssociation anAssociation) {
        [, anAliasName] = pluginSplit(alias);

        return _items[anAliasName] = anAssociation;
    }

    /**
     * Creates and adds the Association object to this collection.
     *
     * @param string anClassName The name of association class.
     * @param string associated The alias for the target table.
     * @param array<string, mixed> options List of options to configure the association definition.
     * @return DORMAssociation
     * @throws \InvalidArgumentException
     * @psalm-param class-string<DORMAssociation> className
     * /
    DORMAssociation load(string anClassName, string associated, IData[string] optionData = null) {
        someOptions["tableLocator"] = this.getTableLocator();
        association = new className(associated, someOptions);

        return _add(association.getName(), association);
    }

    /**
     * Fetch an attached association by name.
     *
     * @param string anAliasName The association alias to get.
     * @return DORMAssociation|null Either the association or null.
     * /
    DORMAssociation get(string anAliasName) {
        return _items[alias] ?? null;
    }

    /**
     * Fetch an association by property name.
     *
     * aProperty - The property to find an association by.
     * returns the association or null.
     * /
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
     * /
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
     * @param array<string>|string class DThe type of associations you want.
     *   For example "BelongsTo" or array like ["BelongsTo", "HasOne"]
     * returns an array of Association objects.
     * /
    DORMAssociation[] getByType(string[] someClassNames...) {
      auto myClassNames = someClassNames.map!(className => className.toLower).array;

      out = array_filter(_items, function (assoc) use (class) {
          [, name] = namespaceSplit(get_class(assoc));

          return in_array(name.toLower, class, true);
      });

      return array_values(out);
    }

    /**
     * Drop/remove an association.
     *
     * Once removed the association will no longer be reachable
     * /
    void remove(string aliasName) {
        unset(_items[aliasName]);
    }

    /**
     * Remove all registered associations.
     *
     * Once removed associations will no longer be reachable
     * /
    void removeAll() {
      foreach (myAliasName, object; _items) {
        this.remove(myAliasName);
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
     * @param array associations The list of associations to save parents from.
     *   associations not in this list will not be saved.
     * @param array<string, mixed> options The options for the save operation.
     * @return bool Success
     * /
    bool saveParents(DORMTable aTable, IEntity anEntity, array associations, IData[string] optionData = null) {
      if (empty(associations)) {
          return true;
      }

      return _saveAssociations(aTable, entity, associations, options, false);
    }

    /**
     * Save all the associations that are children of the given entity.
     *
     * Child associations include any association where the given table is not the owning side.
     *
     * @param DORMDORMTable aTable The table entity is for.
     * @param DORMDatasource\IEntity anEntity The entity to save associated data for.
     * @param array associations The list of associations to save children from.
     *   associations not in this list will not be saved.
     * @param array<string, mixed> options The options for the save operation.
     * @return bool Success
     * /
    bool saveChildren(DORMTable aTable, IEntity anEntity, array associations, IData[string] optionData) {
        if (empty(associations)) {
            return true;
        }

        return _saveAssociations(table, entity, associations, options, true);
    }

    /**
     * Helper method for saving an association"s data.
     *
     * @param DORMDORMTable aTable The table the save is currently operating on
     * @param DORMDatasource\IEntity anEntity The entity to save
     * @param array associations Array of associations to save.
     * @param array<string, mixed> options Original options
     * @param bool owningSide Compared with association classes" isOwningSide method.
     * returns True if Success
     * @throws \InvalidArgumentException When an unknown alias is used.
     * /
    protected bool _saveAssociations(
        DORMTable aTable,
        IEntity anEntity,
        array associations,
        IData[string] optionData,
        bool owningSide
    ) {
        unset(options["associated"]);
        foreach (associations as alias: nested) {
            if (is_int(alias)) {
                alias = nested;
                nested = null;
            }
            relation = get(alias);
            if (!relation) {
                msg = sprintf(
                    "Cannot save %s, it is not associated to %s",
                    alias,
                    table.aliasName()
                );
                throw new DInvalidArgumentException(msg);
            }
            if (relation.isOwningSide(table) != owningSide) {
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
     * @param DORMDatasource\IEntity anEntity The entity to save
     * @param array<string, mixed> nested Options for deeper associations
     * @param array<string, mixed> options Original options
     * @return bool Success
     * /
    protected bool _save(
        DORMAssociation anAssociation,
        IEntity anEntity,
        array nested,
        IData[string] optionData
    ) {
        if (!anEntity.isDirty(association.getProperty())) {
            return true;
        }
        if (!empty(nested)) {
            options = nested + options;
        }

        return (bool)association.saveAssociated(entity, options);
    }

    /**
     * Cascade a delete across the various associations.
     * Cascade first across associations for which cascadeCallbacks is true.
     *
     * @param DORMDatasource\IEntity anEntity The entity to delete associations for.
     * @param array<string, mixed> options The options used in the delete operation.
     * /
    bool cascadeDelete_(IEntity anEntity, IData[string] optionData) {
        noCascade = null;
        foreach (_items as assoc) {
            if (!assoc.getCascadeCallbacks()) {
                noCascade[] = assoc;
                continue;
            }
            success = assoc.cascadeDelete_(anEntity, options);
            if (!success) {
                return false;
            }
        }

        foreach (noCascade as assoc) {
            success = assoc.cascadeDelete_(anEntity, options);
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
     * @param array|bool keys the list of association names to normalize
     * /
    array normalizeKeys(keys) {
        if (keys == true) {
            keys = this.keys();
        }

        if (empty(keys)) {
            return [];
        }

        return _normalizeAssociations(keys);
    }

    // Allow looping through the associations
    DORMAssociation[string] getIterator() {
      return new DArrayIterator(_items);
    } */
} 
