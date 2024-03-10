/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.orm.caches.associations.belongsto;

import uim.orm;

@safe:

/**
 * Represents an 1 - N relationship where the source side of the relation is
 * related to only one record in the target table.
 *
 * An example of a BelongsTo association would be Article belongs to Author.
 */
class BelongsTo : DAssociation {
    // Valid strategies for this type of association
    protected string[] _validStrategies = [
        STRATEGY_JOIN,
        STRATEGY_SELECT,
    ];

    // Gets the name of the field representing the foreign key to the target table.
    string[] getForeignKey() {
      if (_foreignKeys == null) {
          _foreignKeys = _modelKey(this.getTarget().aliasName());
      }

      return _foreignKeys;
    }

    /**
     * Handle cascading deletes.
     *
     * BelongsTo associations are never cleared in a cascading delete scenario.
     *
     * @param DORMDatasource\IEntity anEntity The entity that started the cascaded delete.
     * @param array<string, mixed> options The options for the original delete.
     * @return bool Success.
     */
    bool cascadeDelete_(IEntity anEntity, STRINGAA someOptions = null) {
      return true;
    }

    // Returns default property name based on association name.
    protected string _propertyName() {
        [, name] = pluginSplit(_name);

        return Inflector::underscore(Inflector::singularize(name));
    }

    /**
     * Returns whether the passed table is the owning side for this
     * association. This means that rows in the "target" table would miss important
     * or required information if the row in "source" did not exist.
     *
     * @param DORMTable side The potential Table with ownership
     */
    bool isOwningSide(Table side) {
        return side == this.getTarget();
    }

    // Get the relationship type.
    string type() {
        return self::MANY_TO_ONE;
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
     */
    function saveAssociated(IEntity anEntity, STRINGAA someOptions = null) {
        auto targetEntity = entity.get(this.getProperty());
        if (empty(targetEntity) || !(targetEntity instanceof IEntity)) {
            return entity;
        }

        auto table = this.getTarget();
        targetEntity = table.save(targetEntity, options);
        if (!targetEntity) {
            return false;
        }

        auto properties = array_combine(
            (array)this.getForeignKey(),
            targetEntity.extract((array)this.getBindingKey())
        );
        entity.set(properties, ["guard": false]);

        return entity;
    }

    /**
     * Returns a single or multiple conditions to be appended to the generated join
     * clause for getting the results on the target table.
     *
     * @param array<string, mixed> options list of options passed to attachTo method
     * @return array<DORMdatabases.Expression\IdentifierExpression>
     * @throws \RuntimeException if the number of columns in the foreignKey do not
     * match the number of columns in the target table primaryKeys
     */
    protected array _joinCondition(STRINGAA someOptions) {
        conditions = null;
        tAlias = _name;
        sAlias = _sourceTable.aliasName();
        foreignKey = (array)options["foreignKey"];
        bindingKey = (array)this.getBindingKey();

        if (count(foreignKey) != count(bindingKey)) {
            if (empty(bindingKey)) {
                msg = "The '%s' table does not define a primary key. Please set one.";
                throw new RuntimeException(sprintf(msg, this.getTarget().getTable()));
            }

            msg = "Cannot match provided foreignKey for '%s', got "(%s)" but expected foreign key for "(%s)"";
            throw new RuntimeException(sprintf(
                msg,
                _name,
                implode(", ", foreignKey),
                implode(", ", bindingKey)
            ));
        }

        foreach (foreignKey as k: f) {
            field = sprintf("%s.%s", tAlias, bindingKey[k]);
            value = new IdentifierExpression(sprintf("%s.%s", sAlias, f));
            conditions[field] = value;
        }

        return conditions;
    }


    function eagerLoader(STRINGAA someOptions): Closure
    {
        loader = new SelectLoader([
            "alias": this.aliasName(),
            "sourceAlias": this.getSource().aliasName(),
            "targetAlias": this.getTarget().aliasName(),
            "foreignKey": this.getForeignKey(),
            "bindingKey": this.getBindingKey(),
            "strategy": this.getStrategy(),
            "associationType": this.type(),
            "finder": [this, "find"],
        ]);

        return loader.buildEagerLoader(options);
    }
}
