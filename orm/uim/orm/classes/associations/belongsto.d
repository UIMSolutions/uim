/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
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

    // Sets the name of the field representing the foreign key to the target table.
    void foreignKeys(string[] keys...) {
        foreignKeys(keys.dup);
    }

    void foreignKeys(string[] keys) {
        _foreignKeys = keys;
    }

    // Gets the name of the field representing the foreign key to the target table.
    override string[] foreignKeys() {
      if (_foreignKeys == null) {
        //TODO _foreignKeys = _modelKey(getTarget().aliasName());
      }

      return _foreignKeys;
    }
    
    /**
     * Handle cascading deletes.
     *
     * BelongsTo associations are never cleared in a cascading delete scenario.
     */
    bool cascadeRemoveKey(DORMEntity entity, Json[string] options = null) {
      return true;
    }

    // Returns default property name based on association name.
    protected string _propertyName() {
        /* [, name] = pluginSplit(_name);

        return Inflector.singularize(name).underscore; */
        return null; 
    }

    /**
     * Returns whether the passed table is the owning side for this
     * association. This means that rows in the "target" table would miss important
     * or required information if the row in "source" did not exist.
     */
    override bool isOwningSide(DORMTable side) {
        return side == getTarget();
    }

    // Get the relationship type.
    string type() {
        return MANY_TO_ONE;
    }

    /**
     * Takes an entity from the source table and looks if there is a field
     * matching the property name for this association. The found entity will be
     * saved on the target table for this association by passing supplied
     * `options`
     */
    DORMEntity saveAssociated(DORMEntity ormEntity, Json[string] options = null) {
/*         auto targetEntity = ormEntity.get(getProperty());
        if (targetEntity.isEmpty) || !(cast(DORMEntity)targetEntity)) {
            return ormEntity;
        }

        auto table = getTarget();
        targetEntity = table.save(targetEntity, options);
        if (!targetEntity) {
            return false;
        }

        auto properties =foreignKeys().combine(
            targetEntity.extract(getBindingKeys())
       );
        ormEntity.set(properties, ["guard": Json(false)]);
        return ormEntity;
 */ 
    return null;    
    }

    /**
     * Returns a single or multiple conditions to be appended to the generated join
     * clause for getting the results on the target table.
     */
   /*  protected IExpression[] _joinCondition(Json[string] options = null) {
        auto conditions = null;
        auto tAlias = _name;
        auto sAlias = _sourceTable.aliasName();
        string[] foreignKeys = options.getStringArray("foreignKeys");
        string[] bindingKeys = getBindingKeys();

        if (count(foreignKeys) != count(bindingKeys)) {
            if (bindingKeys.isEmpty) {
                message = "The '%s' table does not define a primary key. Please set one.";
                throw new DRuntimeException(message.format(getTarget().getTable()));
            }

            string message = "";
            throw new DRuntimeException(
"Cannot match provided foreignKeys for '%s', got '(%s)' but expected foreign key for '(%s)'"
                .format(_name, foreignKeys.join(", "), bindingKeys.join(", ")
           ));
        }

        foreach (k, f; foreignKeys) {
            auto field = "%s.%s".format(tAlias, bindingKey[k]);
            auto value = new DIdentifierExpression(format("%s.%s", sAlias, f));
            conditions[field] = value;
        }

        return conditions;
    }
 */

    override IClosure eagerLoader(Json[string] options = null) {
        /* loader = new DSelectLoader(
            "alias": this.aliasName(),
            "sourceAlias": source().aliasName(),
            "targetAlias": getTarget().aliasName(),
            "foreignKeys": foreignKeys(),
            "bindingKey": getBindingKeys(),
            "strategy": getStrategy(),
            "associationType": this.type(),
            "finder": [this, "find"],
        ]);

        return loader.buildEagerLoader(options); */
        return null;
    }
}
mixin(AssociationCalls!("BelongsTo"));

