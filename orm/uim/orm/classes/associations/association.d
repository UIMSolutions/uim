/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.orm.classes.associations.association;

import uim.orm;

@safe:

/**
 * An Association is a relationship established between two tables and is used
 * to configure and customize the way interconnected records are retrieved.
 */
class DAssociation : IAssociation {
    mixin TConfigurable;
    // TODO use TConventions;
    mixin TLocatorAware;

    this() {
        initialize;
    }

    this(Json[string] initData) {
        this.initialize(initData);
    }

    this(string newName) {
        this();
        this.name(newName);
    }

    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    // Name given to the association, it usually represents the alias assigned to the target associated table
    mixin(TProperty!("string", "name"));

    // Sets whether cascaded deletes should also fire callbacks.
    mixin(TProperty!("bool", "cascadeCallbacks"));

    // Strategy name to use joins for fetching associated records
    const string STRATEGY_JOIN = "join";

    // Strategy name to use a subquery for fetching associated records
    const string STRATEGY_SUBQUERY = "subquery";

    // Strategy name to use a select for fetching associated records
    const string STRATEGY_SELECT = "select";

    // Association type for one to one associations.
    const string ONE_TO_ONE = "oneToOne";

    // Association type for one to many associations.
    const string ONE_TO_MANY = "oneToMany";

    // Association type for many to many associations.
    const string MANY_TO_MANY = "manyToMany";

    // Association type for many to one associations.
    const string MANY_TO_ONE = "manyToOne";

    // The field name in the owning side table that is used to match with the foreignKeys
    protected string[] _bindingKeys;

    // The name of the field representing the foreign key to the table to load
    protected string[] _foreignKeys;

    /**
     * The property name that should be filled with data from the target table
     * in the source table record.
     */
    protected string _propertyName;

    /**
     * The strategy name to be used to fetch associated records. Some association
     * types might not implement but one strategy to fetch records.
     */
    protected string _strategy = STRATEGY_JOIN;

    // The class name of the target table object
    protected string _className;

    /**
     * Whether the records on the target table are dependent on the source table,
     * often used to indicate that records should be removed if the owning record in
     * the source table is deleted.
     */
    protected bool _dependent = false;

    // The type of join to be used when adding the association to a query
    // TODO protected string _joinType = DQuery.JOIN_TYPE_LEFT;
    /* 

    // Name given to the association, it usually represents the alias assigned to the target associated table



    /**
     * A list of conditions to be always included when fetching records from the target association
     *
     * @var \Closure|array
     */
    protected _conditions = null;

    // Whether cascaded deletes should also fire callbacks.
    protected bool _cascadeCallbacks = false;

    // Source table instance
    protected IORMTable _sourceTable;

    // Target table instance
    protected IORMTable _targetTable;

    /**
     * The default finder name to use for fetching rows from the target table
     * With array value, finder name and default options are allowed.
     *
     * @var array|string
     */
    protected _finder = "all";

    // Valid strategies for this association. Subclasses can narrow this down.
    protected string[] _validStrategies = [
        STRATEGY_JOIN,
        STRATEGY_SELECT,
        STRATEGY_SUBQUERY,
    ];

    /**
     . Subclasses can override _options function to get the original
     * list of passed options if expecting any other special key
     *
     * anAliasName - The name given to the association
     * @param Json[string] options A list of properties to be set on this object
     */
    this(string anAliasName, Json[string] optionData = null) {
        defaults = [
            "cascadeCallbacks",
            "className",
            "conditions",
            "dependent",
            "finder",
            "bindingKeys",
            "foreignKeys",
            "joinType",
            "tableLocator",
            "propertyName",
            "sourceTable",
            "targetTable",
        ];
        foreach (property; defaults) {
            if (property in options) {
                this. {
                    "_" ~ property
                }

                

                = options[property];
            }
        }

        if (_className.isEmpty) {
            _className = anAliasName;
        }

        [, name] = pluginSplit(anAliasName);
        _name = name;

        _options(options);

        if (!options.isEmpty("strategy"])) {
            setStrategy(options["strategy"]);
        }
    }

    /**
     * Sets the class name of the target table object.
     *
     * @param string anClassName Class name to set.
     * @return this
     * @throws \InvalidArgumentException In case the class name is set after the target table has been
     *  resolved, and it doesn"t match the target table"s class name.
     */
    void setClassName(string anClassName) {
        if (
            _targetTable != null &&
            get_class(_targetTable) != App
            .className(className, "Model/Table", "Table")
            ) {
            throw new DInvalidArgumentException(format(
                    "The class name '%s' doesn\"t match the target table class name of '%s'.",
                    className,
                    get_class(_targetTable)
            ));
        }

        _className = className;
    }

    // Gets the class name of the target table object.
    string getClassName() {
        return _className;
    }

    /**
     * Sets the table instance for the source side of the association.
     *
     * @param DORMDORMTable aTable the instance to be assigned as source side
     */
    void setSource(DORMTable aTable) {
        _sourceTable = table;
    }

    // Gets the table instance for the source side of the association.
    Table source() {
        return _sourceTable;
    }

    // Sets the table instance for the target side of the association.
    void setTarget(DORMTable aTable) {
        _targetTable = table;
    }

    // Gets the table instance for the target side of the association.
    DORMTable getTarget() {
        if (_targetTable == null) {
            if (indexOf(_className, ".")) {
                [plugin] = pluginSplit(_className, true);
                registryAlias = (string) plugin._name;
            } else {
                registryAlias = _name;
            }

            tableLocator = getTableLocator();

            myConfiguration = null;
            exists = tableLocator.exists(registryAlias);
            if (!exists) {
                myConfiguration = ["className": _className];
            }
            _targetTable = tableLocator.get(registryAlias, myConfiguration);

            if (exists) {
                className = App.className(_className, "Model/Table", "Table") ?  : Table:
                 : class;

                if (!_targetTable instanceof className) {
                    errorMessage = "%s association '%s' of type '%s' to '%s' doesn\"t match the expected class '%s'~ ";
                    errorMessage ~= "You can\"t have an association of the same name with a different target ";
                    errorMessage ~= ""c lassName" option anywhere in your app.";

                    throw new DRuntimeException(format(
                            errorMessage,
                            _sourceTable == null ? "null" : get_class(_sourceTable),
                            getName(),
                            this.type(),
                            get_class(_targetTable),
                            className
                    ));
                }
            }
        }

        return _targetTable;
    }

    /**
     * Sets a list of conditions to be always included when fetching records from
     * the target association.
     *
     * @param \Closure|array conditions list of conditions to be used
     */
    void setConditions(conditions) {
        _conditions = conditions;
    }

    /**
     * Gets a list of conditions to be always included when fetching records from
     * the target association.
     * @return \Closure|array
     */
    auto getConditions() {
        return _conditions;
    }

    /**
     * Sets the name of the field representing the binding field with the target table.
     * When not manually specified the primary key of the owning side table is used.
     *
     * @param string[]|string aKey the table field or fields to be used to link both tables together
     */
    void setBindingKeys(key) {
        _bindingKeys = key;
    }

    /**
     * Gets the name of the field representing the binding field with the target table.
     * When not manually specified the primary key of the owning side table is used.
     *
     * @return string[]|string
     */
    function getBindingKeys() {
        if (_bindingKeys == null) {
            _bindingKeys = this.isOwningSide(source()) ?
                source()
                .primaryKeys() : getTarget().primaryKeys();
        }

        return _bindingKeys;
    }

    // Gets the name of the field representing the foreign key to the target table.
    string[] foreignKeys() {
        return _foreignKeys;
    }

    // Sets the name of the field representing the foreign key to the target table.
    void setForeignKeys(string[] keys) {
        _foreignKeys = keys;
    }

    /**
     * Sets whether the records on the target table are dependent on the source table.
     *
     * This is primarily used to indicate that records should be removed if the owning record in
     * the source table is deleted.
     *
     * If no parameters are passed the current setting is returned.
     *
     * @param bool dependent Set the dependent mode. Use null to read the current state.
     */
    voidsetDependent(bool dependent) {
        _dependent = dependent;
    }

    /**
     * Sets whether the records on the target table are dependent on the source table.
     *
     * This is primarily used to indicate that records should be removed if the owning record in
     * the source table is deleted.
     */
    bool getDependent() {
        return _dependent;
    }

    /**
     * Whether this association can be expressed directly in a query join
     *
     * @param Json[string] options custom options key that could alter the return value
     */
    bool canBeJoined(Json[string] optionData = null) {
        strategy = options.get() "strategy", getStrategy());

        return strategy == this.STRATEGY_JOIN;
    }

    /**
     * Sets the type of join to be used when adding the association to a query.
     *
     * @param string type the join type to be used (e.g. INNER)
     */
    voidsetJoinType(string type) {
        _joinType = type;
    }

    /**
     * Gets the type of join to be used when adding the association to a query.
     */
    string getJoinType() {
        return _joinType;
    }

    /**
     * Sets the property name that should be filled with data from the target table
     * in the source table record.
     *
     * @param string aName The name of the association property. Use null to read the current value.
     */
    void setProperty(string aName) {
        _propertyName = name;
    }

    /**
     * Gets the property name that should be filled with data from the target table
     * in the source table record.
     */
    string getProperty() {
        if (!_propertyName) {
            _propertyName = _propertyName();
            if (in_array(_propertyName, _sourceTable.getSchema().columns(), true)) {
                msg = "Association property name '%s' clashes with field of same name of table '%s'." ~
                    " You should explicitly specify the " propertyName" option.";
                trigger_error(
                    sprintf(msg, _propertyName, _sourceTable.getTable()),
                    E_USER_WARNING
                );
            }
        }

        return _propertyName;
    }

    /**
     * Returns default property name based on association name.
     */
    protected string _propertyName() {
        [, name] = pluginSplit(_name);

        return Inflector.underscore(name);
    }

    /**
     * Sets the strategy name to be used to fetch associated records. Keep in mind
     * that some association types might not implement but a default strategy,
     * rendering any changes to this setting void.
     *
     * @param string aName The strategy type. Use null to read the current value.
     * @throws \InvalidArgumentException When an invalid strategy is provided.
     */
    void setStrategy(string aName) {
        if (!in_array(name, _validStrategies, true)) {
            throw new DInvalidArgumentException(
                "Invalid strategy '%s' was provided. Valid options are (%s)."
                    .format(name, implode(", ", _validStrategies));

            

            );
        }
        _strategy = name;
    }

    /**
     * Gets the strategy name to be used to fetch associated records. Keep in mind
     * that some association types might not implement but a default strategy,
     * rendering any changes to this setting void.
     */
    string getStrategy() {
        return _strategy;
    }

    /**
     * Gets the default finder to use for fetching rows from the target table.
     *
     * @return array|string
     */
    function getFinder() {
        return _finder;
    }

    /**
     * Sets the default finder to use for fetching rows from the target table.
     *
     * @param array|string finder the finder name to use or array of finder name and option.
     */
    voidsetFinder(finder) {
        _finder = finder;
    }

    /**
     * Override this function to initialize any concrete association class, it will
     * get passed the original list of options used in the constructor
     *
     * @param Json[string] options List of options used for initialization
     */
    protected void _options(Json[string] optionData) {
    }

    /**
     * Alters a Query object to include the associated target table data in the final
     * result
     *
     * The options array accept the following keys:
     *
     * - includeFields: Whether to include target model fields in the result or not
     * - foreignKeys: The name of the field to use as foreign key, if false none
     *   will be used
     * - conditions: array with a list of conditions to filter the join with, this
     *   will be merged with any conditions originally configured for this association
     * - fields: a list of fields in the target table to include in the result
     * - aliasPath: A dot separated string representing the path of association names
     *   followed from the passed query main table to this association.
     * - propertyPath: A dot separated string representing the path of association
     *   properties to be followed from the passed query main entity to this
     *   association
     * - joinType: The SQL join type to use in the query.
     * - negateMatch: Will append a condition to the passed query for excluding matches.
     *   with this association.
     *
     * @param DORMQuery query the query to be altered to include the target table data
     * @param Json[string] options Any extra options or overrides to be taken in account
     * @throws \RuntimeException Unable to build the query or associations.
     */
    void attachTo(Query query, Json[string] optionData = null) {
        target = getTarget();
        table = target.getTable();

        auto updatedOptions = options.update[
            "includeFields": true.toJson,
            "foreignKeys": foreignKeys(),
            "conditions": Json.emptyArray,
            "joinType": getJoinType(),
            "fields": Json.emptyArray,
            "table": table,
            "finder": getFinder(),
        ];

        // This is set by joinWith to disable matching results
        if (options["fields"] == false) {
            options["fields"] = null;
            options["includeFields"] = false;
        }

        if (!options.isEmpty("foreignKeys"])) {
            joinCondition = _joinCondition(options);
            if (joinCondition) {
                options["conditions"] ~= joinCondition;
            }
        }

        [finder, opts] = _extractFinder(options["finder"]);
        dummy = this
            .find(finder, opts)
            .eagerLoaded(true);

        if (!options.isEmpty("queryBuilder"])) {
            dummy = options["queryBuilder"](dummy);
            if (!(dummy instanceof Query)) {
                throw new DRuntimeException(format(
                        "Query builder for association '%s' did not return a query",
                        getName()
                ));
            }
        }

        if (
            !options.isEmpty("matching"]) &&
            _strategy == STRATEGY_JOIN &&
            dummy.getContain()
            ) {
            throw new DRuntimeException(
                "`{getName()}` association cannot contain() associations when using JOIN strategy."
            );
        }

        dummy.where(options["conditions"]);
        _dispatchBeforeFind(dummy);

        query.join([
            _name: [
                "table": options["table"],
                "conditions": dummy.clause("where"),
                "type": options["joinType"],

            

        ]]);

        _appendFields(query, dummy, options);
        _formatAssociationResults(query, dummy, options);
        _bindNewAssociations(query, dummy, options);
        _appendNotMatching(query, options);
    }

    /**
     * Conditionally adds a condition to the passed Query that will make it find
     * records where there is no match with this association.
     *
     * @param DORMQuery query The query to modify
     * @param Json[string] options Options array containing the `negateMatch` key.
     */
    protected void _appendNotMatching(Query query, Json[string] optionData) {
        target = _targetTable;
        if (!options.isEmpty("negateMatch"])) {
            primaryKeys = query.aliasFields((array) target.primaryKeys(), _name);
            query.andWhere(function(exp) use(primaryKeys) {
                array_map([exp, "isNull"], primaryKeys);

                return exp;
            });
        }
    }

    /**
     * Correctly nests a result row associated values into the correct array keys inside the
     * source results.
     *
     * @param Json[string] row The row to transform
     * @param string nestKey The array key under which the results for this association
     *   should be found
     * @param bool joined Whether the row is a result of a direct join
     *   with this association
     * @param string targetProperty The property name in the source results where the association
     * data shuld be nested in. Will use the default one if not provided.
     */
    array transformRow(Json[string] row, string nestKey, bool joined, string targetProperty = null) {
        sourceAlias = source().aliasName();
        nestKey = nestKey ?  : _name;
        targetProperty = targetProperty ?  : getProperty();
        if (isset(row[sourceAlias])) {
            row[sourceAlias][targetProperty] = row[nestKey];
            unset(row[nestKey]);
        }

        return row;
    }

    /**
     * Returns a modified row after appending a property for this association
     * with the default empty value according to whether the association was
     * joined or fetched externally.
     *
     * @param Json[string] row The row to set a default on.
     * @param bool joined Whether the row is a result of a direct join
     *   with this association
     * @return Json[string]
     */
    array defaultRowValue(Json[string] row, bool joined) {
        sourceAlias = source().aliasName();
        if (isset(row[sourceAlias])) {
            row[sourceAlias][getProperty()] = null;
        }

        return row;
    }

    /**
     * Proxies the finding operation to the target table"s find method
     * and modifies the query accordingly based of this association
     * configuration
     *
     * @param Json[string]|string type the type of query to perform, if an array is passed,
     *   it will be interpreted as the `options` parameter
     * @param Json[string] options The options to for the find
     */
    IQuery find(type = null, Json[string] optionData = null) {
        type = type ?  : getFinder();
        [type, opts] = _extractFinder(type);

        return _getTarget()
            .find(type, options + opts)
            .where(getConditions());
    }

    /**
     * Proxies the operation to the target table"s exists method after
     * appending the default conditions for this association
     *
     * @param DORMdatabases.IExpression|\Closure|array|string conditions The conditions to use
     * for checking if any record matches.
     */
    bool exists(conditions) {
        conditions = this.find()
            .where(conditions)
            .clause("where");

        return _getTarget().exists(conditions);
    }

    /**
     * Proxies the update operation to the target table"s updateAll method
     *
     * @param Json[string] fields A hash of field: new value.
     * @param DORMdatabases.IExpression|\Closure|array|string conditions Conditions to be used, accepts anything Query.where()
     * can take.
     * @return int Count Returns the affected rows.
     */
    int updateAll(string[] fieldNames, conditions) {
        expression = this.find()
            .where(conditions)
            .clause("where");

        return _getTarget().updateAll(fields, expression);
    }

    /**
     * Proxies the delete operation to the target table"s deleteAll method
     *
     * @param DORMdatabases.IExpression|\Closure|array|string conditions Conditions to be used, accepts anything Query.where()
     * can take.
     * @return int Returns the number of affected rows.
     */
    int deleteAll(conditions) {
        expression = this.find()
            .where(conditions)
            .clause("where");

        return _getTarget().deleteAll(expression);
    }

    /**
     * Returns true if the eager loading process will require a set of the owning table"s
     * binding keys in order to use them as a filter in the finder query.
     *
     * @param Json[string] options The options containing the strategy to be used.
     * @return bool true if a list of keys will be required
     */
    bool requiresKeys(Json[string] optionData = null) {
        strategy = options["strategy"] ?  ? getStrategy();

        return strategy == STRATEGY_SELECT;
    }

    /**
     * Triggers beforeFind on the target table for the query this association is
     * attaching to
     *
     * @param DORMQuery query the query this association is attaching itself to
     */
    protected void _dispatchBeforeFind(Query query) {
        query.triggerBeforeFind();
    }

    /**
     * Helper function used to conditionally append fields to the select clause of
     * a query from the fields found in another query object.
     *
     * @param DORMQuery query the query that will get the fields appended to
     * @param DORMQuery surrogate the query having the fields to be copied from
     * @param Json[string] options options passed to the method `attachTo`
     */
    protected void _appendFields(Query query, Query surrogate, Json[string] optionData) {
        if (query.getEagerLoader().isAutoFieldsEnabled() == false) {
            return;
        }

        fields = array_merge(surrogate.clause("select"), options["fields"]);

        if (
            (fields.isEmpty && options["includeFields"]) ||
            surrogate.isAutoFieldsEnabled()
            ) {
            fields = array_merge(fields, _targetTable.getSchema().columns());
        }

        query.select(query.aliasFields(fields, _name));
        query.addDefaultTypes(_targetTable);
    }

    /**
     * Adds a formatter function to the passed `query` if the `surrogate` query
     * declares any other formatter. Since the `surrogate` query correspond to
     * the associated target table, the resulting formatter will be the result of
     * applying the surrogate formatters to only the property corresponding to
     * such table.
     *
     * @param DORMQuery query the query that will get the formatter applied to
     * @param DORMQuery surrogate the query having formatters for the associated
     * target table.
     * @param Json[string] options options passed to the method `attachTo`
     */
    protected void _formatAssociationResults(Query query, Query surrogate, Json[string] optionData) {
        formatters = surrogate.getResultFormatters();

        if (!formatters || options.isEmpty("propertyPath"])) {
            return;
        }

        property = options["propertyPath"];
        propertyPath = explode(".", property);
        query.formatResults(
            function(ICollection results, query) use(formatters, property, propertyPath) {
            extracted = null;
            foreach (results as result) {
                foreach (propertyPath as propertyPathItem) {
                    if (!isset(result[propertyPathItem])) {
                        result = null;
                        break;
                    }
                    result = result[propertyPathItem];
                }
                extracted ~= result;
            }
            extracted = new DCollection(extracted);
            foreach (formatters as callable) {
                extracted = callable(extracted, query);
                if (!extracted instanceof IResultset) {
                    extracted = new DResultsetDecorator(extracted);
                }
            }

            results = results.insert(property, extracted);
            if (query.isHydrationEnabled()) {
                results = results.map(function(result) {
                    result.clean();

                    return result;
                });
            }

            return results;
        },
    Query:
         : PREPEND
        );
    }

    /**
     * Applies all attachable associations to `query` out of the containments found
     * in the `surrogate` query.
     *
     * Copies all contained associations from the `surrogate` query into the
     * passed `query`. Containments are altered so that they respect the associations
     * chain from which they originated.
     *
     * @param DORMQuery query the query that will get the associations attached to
     * @param DORMQuery surrogate the query having the containments to be attached
     * @param Json[string] options options passed to the method `attachTo`
     */
    protected void _bindNewAssociations(Query query, Query surrogate, Json[string] optionData) {
        loader = surrogate.getEagerLoader();
        contain = loader.getContain();
        matching = loader.getMatching();

        if (!contain && !matching) {
            return;
        }

        newContain = null;
        foreach (contain as alias : value) {
            newContain[options["aliasPath"] ~ "." ~ alias] = value;
        }

        eagerLoader = query.getEagerLoader();
        if (newContain) {
            eagerLoader.contain(newContain);
        }

        foreach (matching as alias : value) {
            eagerLoader.setMatching(
                options["aliasPath"] ~ "." ~ alias,
                value["queryBuilder"],
                value
            );
        }
    }

    /**
     * Returns a single or multiple conditions to be appended to the generated join
     * clause for getting the results on the target table.
     *
     * @param Json[string] options list of options passed to attachTo method
     * @return array
     * @throws \RuntimeException if the number of columns in the foreignKeys do not
     * match the number of columns in the source table primaryKeys
     */
    protected Json[string] _joinCondition(Json[string] optionData) {
        auto conditions = null;
        auto tAlias = _name;
        auto sAlias = source().aliasName();
        auto foreignKeys = (array) options["foreignKeys"];
        auto bindingKeys = (array) getBindingKeys();

        if (count(foreignKeys) != count(bindingKeys)) {
            if (bindingKeys.isEmpty) {
                table = getTarget().getTable();
                if (this.isOwningSide(source())) {
                    table = source().getTable();
                }
                msg = "The '%s' table does not define a primary key, and cannot have join conditions generated.";
                throw new DRuntimeException(format(msg, table));
            }

            msg = "Cannot match provided foreignKeys for '%s', got "( % s) " but expected foreign key for "(

                

                    % s) "";
            throw new DRuntimeException(format(
                    msg,
                    _name,
                    implode(", ", foreignKeys),
                    implode(", ", bindingKeys)
            ));
        }

        foreach (foreignKeys as k : f) {
            field = sprintf("%s.%s", sAlias, bindingKeys[k]);
            value = new DIdentifierExpression(format("%s.%s", tAlias, f));
            conditions[field] = value;
        }

        return conditions;
    }

    /**
     * Helper method to infer the requested finder and its options.
     *
     * Returns the inferred options from the finder type.
     *
     * ### Examples:
     *
     * The following will call the finder "translations" with the value of the finder as its options:
     * query.contain(["Comments": ["finder": ["translations"]]]);
     * query.contain(["Comments": ["finder": ["translations": Json.emptyArray]]]);
     * query.contain(["Comments": ["finder": ["translations": ["locales": ["en_US"]]]]]);
     *
     * @param array|string finderData The finder name or an array having the name as key
     * and options as value.
     */
    protected Json[string] _extractFinder(finderData) {
        finderData = (array) finderData;

        if (key(finderData).isNumeric) {
            return [current(finderData), []];
        }

        return [key(finderData), current(finderData)];
    }

    /**
     * Proxies property retrieval to the target table. This is handy for getting this
     * association"s associations
     *
     * @param string property the property name
     * @return DORMAssociation
     * @throws \RuntimeException if no association with such name exists
     */
    function __get(property) {
        return _getTarget(). {
            property
        };
    }

    /**
     * Proxies the isset call to the target table. This is handy to check if the
     * target table has another association with the passed name
     *
     * @param string property the property name
     */
    bool __isSet(property) {
        return isset(getTarget(). {
            property
        });
    }

    /**
     * Proxies method calls to the target table.
     *
     * @param string method name of the method to be invoked
     * @param Json[string] argument List of arguments passed to the function
     */
    Json __call(method, argument) {
        return _getTarget().method(...argument);
    }

    /**
     * Get the relationship type.
     *
     * @return string Constant of either ONE_TO_ONE, MANY_TO_ONE, ONE_TO_MANY or MANY_TO_MANY.
     */
    abstract string type();

    /**
     * Eager loads a list of records in the target table that are related to another
     * set of records in the source table. Source records can be specified in two ways:
     * first one is by passing a Query object setup to find on the source table and
     * the other way is by explicitly passing an array of primary key values from
     * the source table.
     *
     * The required way of passing related source records is controlled by "strategy"
     * When the subquery strategy is used it will require a query on the source table.
     * When using the select strategy, the list of primary keys will be used.
     *
     * Returns a closure that should be run for each record returned in a specific
     * Query. This callable will be responsible for injecting the fields that are
     * related to each specific passed row.
     *
     * Options array accepts the following keys:
     *
     * - query: Query object setup to find the source table records
     * - keys: List of primary key values from the source table
     * - foreignKeys: The name of the field used to relate both tables
     * - conditions: List of conditions to be passed to the query where() method
     * - sort: The direction in which the records should be returned
     * - fields: List of fields to select from the target table
     * - contain: List of related tables to eager load associated to the target table
     * - strategy: The name of strategy to use for finding target table records
     * - nestKey: The array key under which results will be found when transforming the row
     */
    abstract Closure eagerLoader(Json[string] optionData);

    /**
     * Handles cascading a delete from an associated model.
     *
     * Each implementing class should handle the cascaded delete as
     * required.
     *
     * @param DORMDatasource\IORMEntity anEntity The entity that started the cascaded delete.
     * @param Json[string] options The options for the original delete.
     * @return bool Success
     */
abstract bool cascaderemove(IORMEntity anEntity, Json[string] optionData = null);

/**
     * Returns whether the passed table is the owning side for this
     * association. This means that rows in the "target" table would miss important
     * or required information if the row in "source" did not exist.
     *
     * @param DORMTable side The potential Table with ownership
     */
    abstract bool isOwningSide(Table side);

    /**
     * Extract the target"s association data our from the passed entity and proxies
     * the saving operation to the target table.
     *
     * @param DORMDatasource\IORMEntity anEntity the data to be saved
     * @param Json[string] options The options for saving associated data.
     */
    abstract IORMEntity saveAssociated(IORMEntity anEntity, Json[string] optionData = null);
}
