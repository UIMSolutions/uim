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
class DEagerLoadable {
    // The name of the association to load.
    protected string _name;

    /*
    // A list of other associations to load from this level.
    protected DORMEagerLoadable[] _associations = null;

    // The Association class instance to use for loading the records.
    /*
     * @var DORMAssociation|null
     */
    protected _instance;

    // A list of options to pass to the association object for loading
     * the records.
     *
     * @var Json[string]
     */
    protected configuration = null;

    // A dotted separated string representing the path of associations
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
     */
    protected bool _canBeJoined = false;

    // Whether this level was meant for a "matching" fetch
     * operation
     *
     * @var bool|null
     */
    protected _forMatching;

    /**
     * The property name where the association result should be nested
     * in the result.
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
     *
     * @param string aName The Association name.
     * @param Json[string] myConfiguration The list of properties to set.
     */
    this(string aName, Json[string] configData) {
        _name = name;
        allowed = [
            "associations", "instance", "config", "canBeJoined",
            "aliasPath", "propertyPath", "forMatching", "targetProperty",
        ];
        allowed.each!((property) {
            if (configData.hasKey(property)) {
                this.{"_" ~ property} = configuration.get(property);
            }
        });
    }

    /**
     * Adds a new association to be loaded from this level.
     *
     * @param string aName The association name.
     * @param DORMEagerLoadable association The association to load.
     */
    void addAssociation(string aName, EagerLoadable association) {
        _associations[name] = association;
    }

    // Returns the Association class instance to use for loading the records.
    DORMEagerLoadable[] associations() {
      return _associations;
    }

    // Gets the Association class instance to use for loading the records.
    DORMAssociation instance() {
        if (_instance == null) {
            throw new \RuntimeException("No instance set.");
        }

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
     *
     * The property path of `country` will be `author.company`
     *
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
     * Sets the list of options to pass to the association object for loading
     * the records.
     *
     * @param Json[string] myConfiguration The value to set.
     */
    void configuration.update(Json myConfiguration) {
        configuration = myConfiguration;
    }

    // Gets the list of options to pass to the association object for loading the records.
    Json configuration.data {
      return configuration;
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
        auto configData = configuration.data;
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
