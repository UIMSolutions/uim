/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.orm.classes.eagerloadable;

/**
 * Represents a single level in the associations tree to be eagerly loaded
 * for a specific query. This contains all the information required to
 * fetch the results from the database from an associations and all its children
 * levels.
 *
 * @internal
 */
class DEagerLoadable : UIMObject {
    this() {
        super();
    }

    /*
    // A list of other associations to load from this level.
    protected DORMEagerLoadable[] _associations = null;

    // The Association class instance to use for loading the records.
    protected DORMAssociation _instance;

    // A list of options to pass to the association object for loading the records.
    protected Json[string] configuration = null;

    /* A dotted separated string representing the path of associations
     * that should be followed to fetch this level.
     */
    protected string _aliasPath;

    /**
     * A dotted separated string representing the path of entity properties
     * in which results for this level should be placed.
     *
     * For example, in the following nested property:
     *
     * ```
     * article.author.company.country
     * ```
     *
     * The property path of `country` will be `author.company`
     *
     */
    protected string _propertyPath;

    // Whether this level can be fetched using a join.
    protected bool _canBeJoined = false;

    /* Whether this level was meant for a "matching" fetch
     * operation
     */
    protected bool _forMatching;

    /**
     * The property name where the association result should be nested
     * in the result.
     *
     * For example, in the following nested property:
     *
     * ```
     * article.author.company.country
     * ```
     * The target property of `country` will be just `country`
     */
    protected string _targetProperty;

    /**
     . The myConfiguration parameter accepts the following array
     * keys:
     *
     * - associations
     * - instance
     * - config
     * - canBeJoined
     * - aliasPath
     * - propertyPath
     * - forMatching
     * - targetProperty
     *
     * The keys maps to the settable properties in this class.
     */
    this(string associationName, Json[string] configData) {
        _name = associationName;
        string[] allowed = [
            "associations", "instance", "config", "canBeJoined",
            "aliasPath", "propertyPath", "forMatching", "targetProperty",
        ];
        allowed.each!((property) {
            if (configData.hasKey(property)) {
                /* this.{"_" ~ property} = configuration.get(property); */
            }
        });
    }

    // Adds a new association to be loaded from this level.
    void addAssociation(string associationName, EagerLoadable association) {
        _associations[associationName] = association;
    }

    // Returns the Association class instance to use for loading the records.
    DORMEagerLoadable[] associations() {
      return _associations;
    }

    // Gets the Association class instance to use for loading the records.
    DORMAssociation instance() {
        /* if (_instance == null) {
            throw new \RuntimeException("No instance set.");
        } */

        return _instance;
    }

    // Gets a dot separated string representing the path of associations that should be followed to fetch this level.
    string aliasPath() {
      return _aliasPath;
    }

    /**
     * Gets a dot separated string representing the path of entity properties
     * in which results for this level should be placed.
     *
     * For example, in the following nested property:
     *
     * ```
     * article.author.company.country
     * ```
     * The property path of `country` will be `author.company`
     */
    string propertyPath() {
        return _propertyPath;
    }

    // Sets whether this level can be fetched using a join.
    void setCanBeJoined(bool joinable) {
      _canBeJoined = joinable;
    }

    // Gets whether this level can be fetched using a join.
    bool canBeJoined() {
        return _canBeJoined;
    }

    /**
     * Gets whether this level was meant for a
     * "matching" fetch operation.
     */
    bool forMatching() {
        return _forMatching;
    }

    /**
     * The property name where the result of this association
     * should be nested at the end.
     *
     * For example, in the following nested property:
     *
     * ```
     * article.author.company.country
     * ```
     *
     * The target property of `country` will be just `country`
     *
     */
    string targetProperty() {
        return _targetProperty;
    }

    /**
     * Returns a representation of this object that can be passed to
     * uim\orm.EagerLoader.contain()
     */
    Json[string] asContainArray() {
        auto associations = _associations.map!(association => assoc.asContainArray()).join;
        
        if (_forMatching != null) {
            configData = ["matching": _forMatching] + myConfiguration;
        }

        return [
            _name: [
                "associations": DAssociations,
                "config": configData,
            ],
        ];
    }

    // Handles cloning eager loadables.
    void clone() {
        foreach (index, association; _associations) {
            _associations[index] = association.clone;
        }
    }
}
