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
    
    // Valid strategies for this type of association
    protected string[] _validStrategies = [
        STRATEGY_JOIN,
        STRATEGY_SELECT,
    ];

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

        return Inflector.underscore(Inflector.singularize(name));
    }

    /**
     * Returns whether the passed table is the owning side for this
     * association. This means that rows in the "target" table would miss important
     * or required information if the row in "source" did not exist.
     *
     * @param DORMTable side The potential Table with ownership
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
     *
     * @param DORMDatasource\IORMEntity anEntity an entity from the source table
     * @param Json[string] options options to be passed to the save method in the target table
     */
    IORMEntity saveAssociated(IORMEntity anEntity, Json[string] options = null) {
        auto targetEntity = entity.get(getProperty());
        if (targetEntity.isEmpty || !cast(DORMTable)targetEntity) {
            return entity;
        }

        auto properties = chain(foreignKeys(), entity.extract(bindingKeys()));
        targetEntity.set(properties, ["guard": false.toJson]);

        if (!getTarget().save(targetEntity, options)) {
            targetEntity.remove(properties.keys);

            return false;
        }

        return entity;
    }


    Closure eagerLoader(Json[string] options) {
        auto loader = new DSelectLoader([
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


    bool cascadeRemove(IORMEntity anEntity, Json[string] options = null) {
        helper = new DependentDeleteHelper();

        return helper.cascadeRemove(this, entity, options);
    }
}
mixin(AssociationCalls!("HasOne"));
