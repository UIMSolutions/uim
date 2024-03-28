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
    /**
     * Valid strategies for this type of association
     *
     * @var array<string>
     * /
    protected string[] _validStrategies = [
        STRATEGY_JOIN,
        STRATEGY_SELECT,
    ];

    /**
     * Gets the name of the field representing the foreign key to the target table.
     *
     * @return array<string>|string
     * /
    function getForeignKeys() {
        if (_foreignKey == null) {
            _foreignKey = _modelKey(this.getSource().aliasName());
        }

        return _foreignKey;
    }

    // Returns default property name based on association name.
    protected string _propertyName() {
        [, name] = pluginSplit(_name);

        return Inflector.underscore(Inflector::singularize(name));
    }

    /**
     * Returns whether the passed table is the owning side for this
     * association. This means that rows in the "target" table would miss important
     * or required information if the row in "source" did not exist.
     *
     * @param DORMTable side The potential Table with ownership
     * /
    bool isOwningSide(Table side) {
        return side == this.getSource();
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
     * @param DORMDatasource\IEntity anEntity an entity from the source table
     * @param array<string, mixed> options options to be passed to the save method in the target table
     * @return DORMDatasource\IEntity|false false if entity could not be saved, otherwise it returns
     * the saved entity
     * @see DORMTable::save()
     * /
    function saveAssociated(IEntity anEntity, IData[string] optionData = null) {
        targetEntity = entity.get(this.getProperty());
        if (empty(targetEntity) || !(targetEntity instanceof IEntity)) {
            return entity;
        }

        properties = array_combine(
            (array)this.getForeignKeys(),
            entity.extract((array)this.getBindingKey())
        );
        targetEntity.set(properties, ["guard": BooleanData(false)]);

        if (!this.getTarget().save(targetEntity, options)) {
            targetEntity.unset(properties.keys);

            return false;
        }

        return entity;
    }


    function eagerLoader(IData[string] optionData): Closure
    {
        loader = new DSelectLoader([
            "alias": this.aliasName(),
            "sourceAlias": this.getSource().aliasName(),
            "targetAlias": this.getTarget().aliasName(),
            "foreignKey": this.getForeignKeys(),
            "bindingKey": this.getBindingKey(),
            "strategy": this.getStrategy(),
            "associationType": this.type(),
            "finder": [this, "find"],
        ]);

        return loader.buildEagerLoader(options);
    }


    bool cascadeDelete_(IEntity anEntity, IData[string] optionData = null) {
        helper = new DependentDeleteHelper();

        return helper.cascadeDelete_(this, entity, options);
    } */
}
mixin(AssociationCalls!("HasOne"));
