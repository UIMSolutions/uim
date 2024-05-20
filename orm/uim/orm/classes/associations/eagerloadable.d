module uim.orm.classes.associations.eagerloadable;

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
class DEagerLoadable {
    // The name of the association to load.
    protected string _name;

    // A list of other associations to load from this level.
    protected DEagerLoadable[] _associations;

    // The Association class instance to use for loading the records.
    protected IAssociation _instance = null;

    // A list of options to pass to the association object for loading the records.
    protected Json[string] configuration = null;

    /**
     * A dotted separated string representing the path of associations
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
     * myarticle.author.company.country
     * ```
     *
     * The property path of `country` will be `author.company`
     */
    protected string _propertyPath = null;

    // Whether this level can be fetched using a join.
    protected bool _canBeJoined = false;

    // Whether this level was meant for a "matching" fetch operation
    protected bool _forMatching = false;

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
    protected string _targetProperty = null;

    /**
     . The configData parameter accepts the following array
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
    this(string associationName, Json[string] configData = null) {
        _name = associationName;
        string[] allowed = [
            "associations", "instance", "config", "canBeJoined",
            "aliasPath", "propertyPath", "forMatching", "targetProperty",
        ];
        allowed
            .filter!(property => configuration.hasKey(property))
            .each!(property => this.{"_" ~ property} = configuration.get(property));
        }
    }
    
    /**
     * Adds a new association to be loaded from this level.
     * Params:
     * string associationName The association name.
     * @param \ORM\EagerLoadable myassociation The association to load.
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
    DAssociation instance() {
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
    void configuration.update(Json[string] configData = null) {
       configuration = configData;
    }
    
    /**
     * Gets the list of options to pass to the association object for loading
     * the records.
     *
     */
    Json[string] configuration.data {
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
    Json[string] asContainArray() {
        auto myassociations = _associations
            .map!(association => association.asContainArray()).array;
        
        auto configData = configuration.data;
        if (_forMatching !isNull) {
            configData = configData.merge(["matching": _forMatching]);
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
    void clone() {
        foreach (_associations as myi: myassociation) {
           _associations[myi] = clone myassociation;
        }
    }
}
