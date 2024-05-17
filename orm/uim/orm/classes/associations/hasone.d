/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.orm.classes.associations.hasone;

import uim.orm;

@safe:

/**
 * Represents an 1 - 1 relationship where the source side of the relation is
 * related to only one record in the target table and vice versa.
 *
 * An example of a HasOne association would be User has one Profile.
 */
class DHasOneAssociation : DAssociation {
    mixin(AssociationThis!("HasOne"));
    
    // Valid strategies for this type of association
    protected string[] _validStrategies = [
        STRATEGY_JOIN,
        STRATEGY_SELECT,
    ];

    // Gets the name of the field representing the foreign key to the target table.
    string[] foreignKeys() {
        if (_foreignKeys == null) {
            _foreignKeys = _modelKey(source().aliasName());
        }

        return _foreignKeys;
    }

    // Returns default property name based on association name.
    protected string _propertyName() {
        [, name] = pluginSplit(_name);

        return Inflector.underscore(Inflector.singularize(name));
    }

    /**
     * Returns whether the passed table is the owning side for this
     * association. This means that rows in the "target" table would miss important
     * or required information if the row in "source" did not exist.
     *
     * @param DORMTable side The potential Table with ownership
     */
    bool isOwningSide(Table side) {
        return side == source();
    }

    // Get the relationship type.
    string type() {
        return ONE_TO_ONE;
    }

    /**
     * Takes an entity from the source table and looks if there is a field
     * matching the property name for this association. The found entity will be
     * saved on the target table for this association by passing supplied
     * `options`
     *
     * @param DORMDatasource\IORMEntity anEntity an entity from the source table
     * @param Json[string] options options to be passed to the save method in the target table
     * @return DORMDatasource\IORMEntity|false false if entity could not be saved, otherwise it returns
     * the saved entity
     */
    function saveAssociated(IORMEntity anEntity, Json[string] optionData = null) {
        targetEntity = entity.get(getProperty());
        if (targetEntity.isEmpty || !(targetEntity instanceof IORMEntity)) {
            return entity;
        }

        properties = array_combine(
            (array)foreignKeys(),
            entity.extract((array)getBindingKey())
        );
        targetEntity.set(properties, ["guard": false.toJson]);

        if (!getTarget().save(targetEntity, options)) {
            targetEntity.unset(properties.keys);

            return false;
        }

        return entity;
    }


    function eagerLoader(Json[string] optionData): Closure
    {
        loader = new DSelectLoader([
            "alias": this.aliasName(),
            "sourceAlias": source().aliasName(),
            "targetAlias": getTarget().aliasName(),
            "foreignKey": foreignKeys(),
            "bindingKey": getBindingKey(),
            "strategy": getStrategy(),
            "associationType": this.type(),
            "finder": [this, "find"],
        ]);

        return loader.buildEagerLoader(options);
    }


    bool cascaderemove(IORMEntity anEntity, Json[string] optionData = null) {
        helper = new DependentDeleteHelper();

        return helper.cascaderemove(this, entity, options);
    } */
}
mixin(AssociationCalls!("HasOne"));
