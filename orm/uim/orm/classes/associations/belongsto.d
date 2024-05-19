/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.orm.classes.associations.belongsto;

import uim.orm;

@safe:

/**
 * Represents an 1 - N relationship where the source side of the relation is
 * related to only one record in the target table.
 *
 * An example of a BelongsTo association would be Article belongs to Author.
 */
class DBelongsToAssociation : DAssociation {
    mixin(AssociationThis!("BelongsTo"));

    // Sets the name of the field representing the foreign key to the target table.
    void foreignKeys(string[] keys...) {
        foreignKeys(keys.dup);
    }

    void foreignKeys(string[] keys) {
        _foreignKeys = keys;
    }

    // Gets the name of the field representing the foreign key to the target table.
    string[] foreignKeyss() {
      if (_foreignKeyss == null) {
        //TODO _foreignKeyss = _modelKey(getTarget().aliasName());
      }

      return _foreignKeyss;
    }
    
    // Valid strategies for this type of association
    protected string[] _validStrategies = [
        STRATEGY_JOIN,
        STRATEGY_SELECT,
    ];

    /**
     * Handle cascading deletes.
     *
     * BelongsTo associations are never cleared in a cascading delete scenario.
     *
     * @param DORMDatasource\IORMEntity anEntity The entity that started the cascaded delete.
     * @param Json[string] options The options for the original delete.
     */
    bool cascaderemove(IORMEntity anEntity, Json[string] optionData = null) {
      return true;
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
        return side == getTarget();
    }

    // Get the relationship type.
    string type() {
        return self.MANY_TO_ONE;
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
    IORMEntity saveAssociated(IORMEntity anEntity, Json[string] optionData = null) {
        auto targetEntity = entity.get(getProperty());
        if (targetEntity.isEmpty) || !(cast(IORMEntity)targetEntity)) {
            return entity;
        }

        auto table = getTarget();
        targetEntity = table.save(targetEntity, options);
        if (!targetEntity) {
            return false;
        }

        auto properties = array_combine(
            (array)foreignKeys(),
            targetEntity.extract((array)getBindingKey())
        );
        entity.set(properties, ["guard": false.toJson]);

        return entity;
    }

    /**
     * Returns a single or multiple conditions to be appended to the generated join
     * clause for getting the results on the target table.
     *
     * @param Json[string] options list of options passed to attachTo method
     * @return array<DORMdatabases.Expression\IdentifierExpression>
     * @throws \RuntimeException if the number of columns in the foreignKeys do not
     * match the number of columns in the target table primaryKeys
     */
    protected Json[string] _joinCondition(Json[string] optionData) {
        conditions = null;
        tAlias = _name;
        sAlias = _sourceTable.aliasName();
        foreignKeys = (array)options["foreignKeys"];
        bindingKey = (array)getBindingKey();

        if (count(foreignKeys) != count(bindingKey)) {
            if (bindingKey.isEmpty) {
                msg = "The '%s' table does not define a primary key. Please set one.";
                throw new DRuntimeException(msg.format(getTarget().getTable()));
            }

            msg = "Cannot match provided foreignKeys for '%s', got '(%s)' but expected foreign key for '(%s)'";
            throw new DRuntimeException(format(
                msg,
                _name,
                implode(", ", foreignKeys),
                implode(", ", bindingKey)
            ));
        }

        foreach (foreignKeys as k: f) {
            field = sprintf("%s.%s", tAlias, bindingKey[k]);
            value = new DIdentifierExpression(format("%s.%s", sAlias, f));
            conditions[field] = value;
        }

        return conditions;
    }


    function eagerLoader(Json[string] optionData): Closure
    {
        loader = new DSelectLoader([
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
}
mixin(AssociationCalls!("BelongsTo"));

