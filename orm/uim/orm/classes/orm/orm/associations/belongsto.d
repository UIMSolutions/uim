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
        self.STRATEGY_JOIN,
        self.STRATEGY_SELECT,
    ];

    string[] getForeignKey() {
        if (!isSet(_foreignKey)) {
            _foreignKey = _modelKey(this.getTarget().aliasName());
        }
        return _foreignKey;
    }

    /**
     * Sets the name of the field representing the foreign key to the target table.
     * Params:
     * string[]|string|false aKey the key or keys to be used to link both tables together, if set to `false`
     * no join conditions will be generated automatically.
     */
    void setForeignKey(string[] aKey...) {
        setForeignKey(aKey.dup);
    }

    void setForeignKey(string[] aKey) {
        _foreignKey = aKey;
    }

    /**
     * Handle cascading deletes.
     *
     * BelongsTo associations are never cleared in a cascading delete scenario.
     * Params:
     * \UIM\Datasource\IEntity entity The entity that started the cascaded delete.
     * @param IData[string] options The options for the original delete.
     */
    bool cascadeDelete(IEntityentity, IData[string] options = null) {
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
     * Params:
     * \UIM\ORM\Table side The potential Table with ownership
     */
    bool isOwningSide(Tableside) {
        return side == this.getTarget();
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
     * Params:
     * \UIM\Datasource\IEntity entity an entity from the source table
     * @param IData[string] options options to be passed to the save method in the target table
     */
    IEntity saveAssociated(IEntity sourceTableEntity, IData[string] options = null) {
        auto targetEntity = sourceTableEntity.get(this.getProperty());
        if (isEmpty(targetEntity) || !(cast(IEntity) targetEntity)) {
            return sourceTableEntity;
        }
        aTable = this.getTarget();
        targetEntity = aTable.save(targetEntity, options);
        if (!targetEntity) {
            return false;
        }
        /** @var string[] foreignKeys */
        foreignKeys = (array) this.getForeignKey();
        properties = array_combine(
            foreignKeys,
            targetEntity.extract((array) this.getBindingKey())
        );
        entity.set(properties, ["guard": false]);

        return entity;
    }

    /**
     * Returns a single or multiple conditions to be appended to the generated join
     * clause for getting the results on the target table.
     * Params:
     * IData[string] options list of options passed to attachTo method
     */
    protected IdentifierExpression[] _joinCondition(IData[string] options = null) {
        auto myConditions = [];
        auto mytAlias = _name;
        auto mysAlias = _sourceTable.aliasName();
        auto myforeignKey = (array)options["foreignKey"];
        auto mybindingKey = (array) this.getBindingKey();

        string message;
        if (count(foreignKey) != count(bindingKey)) {
            if (isEmpty(bindingKey)) {
                message = "The `%s` table does not define a primary key. Please set one.";
                throw new DatabaseException(message.format(this.getTarget().getTable()));
            }
            message = "Cannot match provided foreignKey for `%s`, got `(%s)` but expected foreign key for `(%s)`.";
            throw new DatabaseException(message
                    .format(
                        _name,
                        join(", ", foreignKey),
                        join(", ", bindingKey)
                    )
            );
        }
        foreignKey.byKeyValue
            .each!((kv) {
                string field = "%s.%s".format(tAlias, bindingKey[kv.key]);
                auto aValue = new IdentifierExpression("%s.%s".format(sAlias, kv.value));
                myConditions[field] = aValue;
            });
        return conditions;
    }

    Closure eagerLoader(IData[string] options = null) {
        loader = new SelectLoader([
                "alias": this.aliasName(),
                "sourceAlias": this.getSource()
                .aliasName(),
                "targetAlias": this.getTarget().aliasName(),
                "foreignKey": this.getForeignKey(),
                "bindingKey": this.getBindingKey(),
                "strategy": this.getStrategy(),
                "associationType": this.type(),
                "finder": this.find(...),
            ]);

        return loader.buildEagerLoader(options);
    }
}
