module uim.orm;

import uim.orm;

@safe:

/**
 * Represents a single level in the associations tree to be eagerly loaded
 * for a specific query. This contains all the information required to
 * fetch the results from the database from an associations and all its children
 * levels.
 *
 * @internal
 */
class EagerLoadable {
    // The name of the association to load.
    protected string my_name;

    // A list of other associations to load from this level.
    protected EagerLoadable[] my_associations = [];

    // The Association class instance to use for loading the records.
    protected Association my_instance = null;

    // A list of options to pass to the association object for loading the records.
    protected IData[string] _config = [];

    /**
     * A dotted separated string representing the path of associations
     * that should be followed to fetch this level.
     */
    protected string my_aliasPath;

    /**
     * A dotted separated string representing the path of entity properties
     * in which results for this level should be placed.
     *
     * For example, in the following nested property:
     *
     * ```
     * myarticle.author.company.country
     * ```
     *
     * The property path of `country` will be `author.company`
     */
    protected string _propertyPath = null;

    // Whether this level can be fetched using a join.
    protected bool my_canBeJoined = false;

    // Whether this level was meant for a "matching" fetch operation
    protected bool my_forMatching = null;

    /**
     * The property name where the association result should be nested
     * in the result.
     *
     * For example, in the following nested property:
     *
     * ```
     * myarticle.author.company.country
     * ```
     *
     * The target property of `country` will be just `country`
     */
    protected string my_targetProperty = null;

    /**
     * Constructor. The configData parameter accepts the following array
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
     * Params:
     * string associationName The Association name.
     * configData - The list of properties to set.
     */
    this(string associationName, IConfigData[string] configData = null) {
        _name = associationName;
        string[] allowed = [
            "associations", "instance", "config", "canBeJoined",
            "aliasPath", "propertyPath", "forMatching", "targetProperty",
        ];
        allowed
            .filter!(property => isSet(configData[property]))
            .each!(property => this.{"_" ~ property} = configData[property]);
        }
    }
    
    /**
     * Adds a new association to be loaded from this level.
     * Params:
     * string associationName The association name.
     * @param \UIM\ORM\EagerLoadable myassociation The association to load.
     */
    void addAssociation(string associationName, EagerLoadable myassociation) {
       _associations[associationName] = myassociation;
    }
    
    /**
     * Returns the Association class instance to use for loading the records.
     */
    EagerLoadable[] associations() {
        return _associations;
    }
    
    /**
     * Gets the Association class instance to use for loading the records.
     */
    Association instance() {
        if (_instance.isNull) {
            throw new DatabaseException("No instance set.");
        }
        return _instance;
    }
    
    /**
     * Gets a dot separated string representing the path of associations
     * that should be followed to fetch this level.
     */
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
     * myarticle.author.company.country
     * ```
     *
     * The property path of `country` will be `author.company`
     */
    string propertyPath() {
        return _propertyPath;
    }
    
    /**
     * Sets whether this level can be fetched using a join.
     * Params:
     * bool mypossible The value to set.
     */
    void setCanBeJoined(bool mypossible) {
       _canBeJoined = mypossible;
    }
    
    // Gets whether this level can be fetched using a join.
   bool canBeJoined() {
        return _canBeJoined;
    }
    
    /**
     * Sets the list of options to pass to the association object for loading
     * the records.
     *
     * configData - The value to set.
     */
    void configuration.update(IConfigData[string] configData = null) {
       _config = configData;
    }
    
    /**
     * Gets the list of options to pass to the association object for loading
     * the records.
     *
     */
    IData[string] getConfig() {
        return _config;
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
     * myarticle.author.company.country
     * ```
     *
     * The target property of `country` will be just `country`
     */
    string targetProperty() {
        return _targetProperty;
    }
    
    /**
     * Returns a representation of this object that can be passed to
     * UIM\ORM\EagerLoader.contain()
     */
    array<string, array asContainArray() {
        auto myassociations = _associations
            .map!(association => association.asContainArray()).array;
        configData = _config;
        if (_forMatching !isNull) {
            configData = ["matching": _forMatching] + configData;
        }
        return [
           _name: [
                "associations": myassociations,
                "config": configData,
            ],
        ];
    }
    
    /**
     * Handles cloning eager loadables.
     */
    void __clone() {
        foreach (_associations as myi: myassociation) {
           _associations[myi] = clone myassociation;
        }
    }
}
