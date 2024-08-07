/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
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
    
    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false; 
        }

        _validStrategies = [
            STRATEGY_JOIN,
            STRATEGY_SELECT,
        ];

        return true;
    }

    // Gets the name of the field representing the foreign key to the target table.
    string[] foreignKeys() {
        if (_foreignKeys.isNull) {
            _foreignKeys = _modelKey(source().aliasName());
        }

        return _foreignKeys;
    }

    // Returns default property name based on association name.
    protected string _propertyName() {
        string[] plugItems = pluginSplit(_name);
        auto name = plugItems[1]; 

        return Inflector.singularize(name).underscore;
    }

    /**
     * Returns whether the passed table is the owning side for this
     * association. This means that rows in the "target" table would miss important
     * or required information if the row in "source" did not exist.
     */
    bool isOwningSide(DORMTable side) {
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
     */
    IORMEntity saveAssociated(IORMEntity ormEntity, Json[string] options = null) {
        auto targetEntity = ormEntity.get(getProperty());
        if (targetEntity.isEmpty || !cast(DORMTable)targetEntity) {
            return entity;
        }

        auto properties = chain(foreignKeys(), ormEntity.extract(bindingKeys()));
        targetEntity.set(properties, ["guard": false.toJson]);

        if (!getTarget().save(targetEntity, options)) {
            targetEntity.remove(properties.keys);

            return false;
        }

        return entity;
    }

    Closure eagerLoader(Json[string] options = null) {
        auto loader = new DSelectLoader([
            "alias": this.aliasName(),
            "sourceAlias": source().aliasName(),
            "targetAlias": getTarget().aliasName(),
            "foreignKeys": foreignKeys(),
            "bindingKey": getBindingKey(),
            "strategy": getStrategy(),
            "associationType": this.type(),
            "finder": [this, "find"],
        ]);

        return loader.buildEagerLoader(options);
    }


    bool cascaderemove(IORMEntity ormEntity, Json[string] options = null) {
        auto helper = new DependentDeleteHelper();
        return helper.cascaderemove(this, ormEntity, options);
    }
}
mixin(AssociationCalls!("HasOne"));
