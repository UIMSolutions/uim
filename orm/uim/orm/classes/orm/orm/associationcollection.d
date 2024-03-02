module uim.orm;

import uim.orm;

@safe:

/**
 * A container/collection for association classes.
 *
 * Contains methods for managing associations, and
 * ordering operations around saving and deleting.
 *
 * @template-implements \IteratorAggregate<string, \UIM\ORM\Association>
 */
class AssociationCollection : IteratorAggregate {
    mixin AssociationsNormalizerTemplate();
    mixin LocatorAwareTemplate();

    /**
     * Stored associations
     *
     * @var array<string, \UIM\ORM\Association>
     */
    protected array my_items = [];

    /**
     * Sets the default table locator for associations.
     * If no locator is provided, the global one will be used.
     * Params:
     * \UIM\ORM\Locator\ILocator|null mytableLocator Table locator instance.
     */
    this(ILocator mytableLocator = null) {
        if (mytableLocator !isNull) {
           _tableLocator = mytableLocator;
        }
    }
    
    /**
     * Add an association to the collection
     *
     * If the alias added contains a `.` the part preceding the `.` will be dropped.
     * This makes using plugins simpler as the Plugin.Class syntax is frequently used.
     * Params:
     * string myalias The association alias
     * @param \UIM\ORM\Association myassociation The association to add.
     */
    Association add(string myalias, Association myassociation) {
        [, myalias] = pluginSplit(myalias);

        return _items[myalias] = myassociation;
    }
    
    /**
     * Creates and adds the Association object to this collection.
     * Params:
     * string myclassName The name of association class.
     * @param string myassociated The alias for the target table.
     * @param IData[string] options List of options to configure the association definition.
     */
    Association load(string myclassName, string myassociated, IData[string] optionData = null) {
        options += [
            "tableLocator": this.getTableLocator(),
        ];

        myassociation = new myclassName(myassociated, options);

        return this.add(myassociation.name, myassociation);
    }
    
    /**
     * Fetch an attached association by name.
     * Params:
     * string myalias The association alias to get.
     */
    Association get(string myalias) {
        return _items[myalias] ?? null;
    }
    
    /**
     * Fetch an association by property name.
     * Params:
     * string myprop The property to find an association by.
     */
    Association getByProperty(string myprop) {
        foreach (association, _items) {
            if (association.getProperty() == myprop) {
                return association;
            }
        }
        return null;
    }
    
    /**
     * Check for an attached association by name.
     * Params:
     * string myalias The association alias to get.
     */
    bool has(string myalias) {
        return isSet(_items[myalias]);
    }
    
    // Get the names of all the associations in the collection.
    string[] keys() {
        return _items.keys;
    }
    
    /**
     * Get an array of associations matching a specific type.
     * Params:
     * string[]|string myclass The type of associations you want.
     *  For example "BelongsTo" or array like ["BelongsTo", "HasOne"]
     */
    Association[] getByType(string[] myclass) {
        myclass = array_map("strtolower", (array)myclass);

        result = array_filter(_items, auto (myassoc) use (myclass) {
            [, myname] = namespaceSplit(myassoc.classname);

            return in_array(myname.toLower, myclass, true);
        });

        return result.values;
    }
    
    /**
     * Drop/remove an association.
     *
     * Once removed the association will no longer be reachable
     * Params:
     * string myalias The alias name.
     */
    void remove(string myalias) {
        unset(_items[myalias]);
    }
    
    /**
     * Remove all registered associations.
     * Once removed associations will no longer be reachable
     */
    void removeAll() {
        _items.keys.each!(key => this.remove(key));
    }
    
    /**
     * Save all the associations that are parents of the given entity.
     *
     * Parent associations include any association where the given table
     * is the owning side.
     * Params:
     * \UIM\ORM\Table mytable The table entity is for.
     * @param \UIM\Datasource\IEntity myentity The entity to save associated data for.
     * @param array myassociations The list of associations to save parents from.
     *  associations not in this list will not be saved.
     * @param IData[string] options The options for the save operation.
         */
    bool saveParents(Table mytable, IEntity myentity, array myassociations, IData[string] optionData = null) {
        if (isEmpty(myassociations)) {
            return true;
        }
        return _saveAssociations(mytable, myentity, myassociations, options, false);
    }
    
    /**
     * Save all the associations that are children of the given entity.
     *
     * Child associations include any association where the given table
     * is not the owning side.
     * Params:
     * \UIM\ORM\Table mytable The table entity is for.
     * @param \UIM\Datasource\IEntity myentity The entity to save associated data for.
     * @param array myassociations The list of associations to save children from.
     *  associations not in this list will not be saved.
     * @param IData[string] options The options for the save operation.
         */
    bool saveChildren(Table mytable, IEntity myentity, array myassociations, IData[string] options) {
        if (isEmpty(myassociations)) {
            return true;
        }
        return _saveAssociations(mytable, myentity, myassociations, options, true);
    }
    
    /**
     * Helper method for saving an association"s data.
     * Params:
     * \UIM\ORM\Table mytable The table the save is currently operating on
     * @param \UIM\Datasource\IEntity myentity The entity to save
     * @param array myassociations Array of associations to save.
     * @param IData[string] options Original options
     * @param bool myowningSide Compared with association classes"
     *  isOwningSide method.
     */
    protected bool _saveAssociations(
        Table mytable,
        IEntity myentity,
        array myassociations,
        IData[string] options,
        bool myowningSide
    ) {
        unset(options["associated"]);
        foreach (myassociations as myalias: mynested) {
            if (isInt(myalias)) {
                myalias = mynested;
                mynested = [];
            }
            myrelation = this.get(myalias);
            if (!myrelation) {
                mymsg = 
                    "Cannot save `%s`, it is not associated to `%s`.".format(
                    myalias,
                    mytable.getAlias()
                );
                throw new InvalidArgumentException(mymsg);
            }
            if (myrelation.isOwningSide(mytable) != myowningSide) {
                continue;
            }
            if (!_save(myrelation, myentity, mynested, options)) {
                return false;
            }
        }
        return true;
    }
    
    /**
     * Helper method for saving an association"s data.
     * Params:
     * \UIM\ORM\Association myassociation The association object to save with.
     * @param \UIM\Datasource\IEntity myentity The entity to save
     * @param IData[string] mynested Options for deeper associations
     * @param IData[string] options Original options
     */
    protected bool _save(
        Association myassociation,
        IEntity myentity,
        array mynested,
        IData[string] options
    ) {
        if (!myentity.isDirty(myassociation.getProperty())) {
            return true;
        }
        if (!empty(mynested)) {
            options = mynested + options;
        }
        return (bool)myassociation.saveAssociated(myentity, options);
    }
    
    /**
     * Cascade a delete across the various associations.
     * Cascade first across associations for which cascadeCallbacks is true.
     * Params:
     * \UIM\Datasource\IEntity myentity The entity to delete associations for.
     * @param IData[string] options The options used in the delete operation.
     */
   bool cascadeDelete(IEntity myentity, IData[string] options) {
        mynoCascade = [];
        foreach (_items as myassoc) {
            if (!myassoc.getCascadeCallbacks()) {
                mynoCascade ~= myassoc;
                continue;
            }
            mysuccess = myassoc.cascadeDelete(myentity, options);
            if (!mysuccess) {
                return false;
            }
        }
        foreach (mynoCascade as myassoc) {
            mysuccess = myassoc.cascadeDelete(myentity, options);
            if (!mysuccess) {
                return false;
            }
        }
        return true;
    }
    
    /**
     * Returns an associative array of association names out a mixed
     * array. If true is passed, then it returns all association names
     * in this collection.
     * Params:
     * string[]|bool someKeys the list of association names to normalize
     */
    array normalizeKeys(string[]|bool someKeys) {
        if (someKeys == true) {
            someKeys = this.keys();
        }
        if (isEmpty(someKeys)) {
            return null;
        }
        return _normalizeAssociations(someKeys);
    }
    
    /**
     * Allow looping through the associations
     */
    Traversable<string, \UIM\ORM\Association> getIterator() {
        return new ArrayIterator(_items);
    }
}
