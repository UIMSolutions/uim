module uim.orm.classes.tables.table;

import uim.orm;

@safe:

/**
 * Represents a single database table.
 *
 * Exposes methods for retrieving data out of it, and manages the associations
 * this table has to other tables. Multiple instances of this class DCan be created
 * for the same database table with different aliases, this allows you to address
 * your database structure in a richer and more expressive way.
 *
 * ### Retrieving data
 *
 * The primary way to retrieve data is using Table.find(). See that method
 * for more information.
 *
 * ### Dynamic finders
 *
 * In addition to the standard find(mytype) finder methods, UIM provides dynamic
 * finder methods. These methods allow you to easily set basic conditions up. For example
 * to filter users by username you would call
 *
 * ```
 * myquery = myusers.findByUsername("mark");
 * ```
 *
 * You can also combine conditions on multiple fields using either `Or` or `And`:
 *
 * ```
 * myquery = myusers.findByUsernameOrEmail("mark", "mark@example.org");
 * ```
 *
 * ### Bulk updates/deletes
 *
 * You can use Table.updateAll() and Table.deleteAll() to do bulk updates/deletes.
 * You should be aware that events will *not* be fired for bulk updates/deletes.
 *
 * ### Events
 *
 * Table objects emit several events during as life-cycle hooks during find, delete and save
 * operations. All events use the UIM event package:
 *
 * - `Model.beforeFind` Fired before each find operation. By stopping the event and
 * supplying a return value you can bypass the find operation entirely. Any
 * changes done to the myquery instance will be retained for the rest of the find. The
 * `myprimary` parameter indicates whether this is the root query, or an
 * associated query.
 *
 * - `Model.buildValidator` Allows listeners to modify validation rules
 * for the provided named validator.
 *
 * - `Model.buildRules` Allows listeners to modify the rules checker by adding more rules.
 *
 * - `Model.beforeRules` Fired before an entity is validated using the rules checker.
 * By stopping this event, you can return the final value of the rules checking operation.
 *
 * - `Model.afterRules` Fired after the rules have been checked on the entity. By
 * stopping this event, you can return the final value of the rules checking operation.
 *
 * - `Model.beforeSave` Fired before each entity is saved. Stopping this event will
 * abort the save operation. When the event is stopped the result of the event will be returned.
 *
 * - `Model.afterSave` Fired after an entity is saved.
 *
 * - `Model.afterSaveCommit` Fired after the transaction in which the save operation is
 * wrapped has been committed. It’s also triggered for non atomic saves where database
 * operations are implicitly committed. The event is triggered only for the primary
 * table on which save() is directly called. The event is not triggered if a
 * transaction is started before calling save.
 *
 * - `Model.beforeDelete` Fired before an entity is deleted. By stopping this
 * event you will abort the delete operation.
 *
 * - `Model.afterDelete` Fired after an entity has been deleted.
 *
 * ### Callbacks
 *
 * You can subscribe to the events listed above in your table classes by implementing the
 * lifecycle methods below:
 *
 * - `beforeFind(IEvent myevent, SelectQuery myquery, Json[string] options, boolean myprimary)`
 * - `beforeMarshal(IEvent myevent, Json[string] mydata, Json[string] options)`
 * - `afterMarshal(IEvent myevent, IORMEntity myentity, Json[string] options)`
 * - `buildValidator(IEvent myevent, Validator myvalidator, string myname)`
 * - `buildRules(RulesChecker myrules)`
 * - `beforeRules(IEvent myevent, IORMEntity myentity, Json[string] options, string myoperation)`
 * - `afterRules(IEvent myevent, IORMEntity myentity, Json[string] options, bool result, string myoperation)`
 * - `beforeSave(IEvent myevent, IORMEntity myentity, Json[string] options)`
 * - `afterSave(IEvent myevent, IORMEntity myentity, Json[string] options)`
 * - `afterSaveCommit(IEvent myevent, IORMEntity myentity, Json[string] options)`
 * - `beforeremove(IEvent myevent, IORMEntity myentity, Json[string] options)`
 * - `afterremove(IEvent myevent, IORMEntity myentity, Json[string] options)`
 * - `afterDeleteCommit(IEvent myevent, IORMEntity myentity, Json[string] options)`
 */
class DTable { //* }: IRepository, DEventListener, IEventDispatcher, IValidatorAware {
    mixin TEventDispatcher;
    mixin TConfigurable;
    mixin TConventions;
    mixin TLocatorAware;
    mixin TRulesAware;
    mixin TValidatorAware;

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

        /**
        * Initializes a new instance
        *
        * The configData array understands the following keys:
        *
        * - alias: Alias to be assigned to this table (default to table name)
        * - connection: The connection instance to use
        * - entityClass: The fully namespaced class name of the entity class that will
        * represent rows in this table.
        * - eventManager: An instance of an event manager to use for internal events
        * - behaviors: A BehaviorRegistry. Generally not used outside of tests.
        * - associations: An AssociationCollection instance.
        * - validator: A Validator instance which is assigned as the "default"
        * validation set, or an associative array, where key is the name of the
        * validation set and value the Validator instance. */

        if (!configuration.isEmpty("registryAlias"))) {
            this.registryKey(configuration.get("registryAlias"));
        }

        // table: Name of the database table to represent
        if (!igData.isEmpty("table"))) {
            setTable(configuration.get("table"));
        }
        if (!configuration.isEmpty("alias"))) {
            aliasName(configuration.get("alias"));
        }
        if (!configuration.isEmpty("connection"))) {
            setConnection(configuration.get("connection"));
        }
        if (!configuration.isEmpty("queryFactory"))) {
            this.queryFactory = configuration.get("queryFactory");
        }

        // schema: A \UIM\Database\Schema\TableISchema object or an array that can be passed to it.
        if (!configuration.isEmpty("schema"))) {
            setSchema(configuration.get("schema"));
        }
        if (!configuration.isEmpty("entityClass")) {
            setEntityClass(configuration.get("entityClass"));
        }
        myeventManager = mybehaviors = myassociations = null;
        if (!configuration.isEmpty("eventManager")) {
            myeventManager = configuration.get("eventManager");
        }
        if (!configuration.isEmpty("behaviors")) {
            mybehaviors = configuration.get("behaviors");
        }
        if (!configuration.isEmpty("associations")) {
            myassociations = configuration.get("associations");
        }
        if (!configuration.isEmpty("validator")) {
            if (!isArray(configuration.get("validator"))) {
                setValidator(DEFAULT_VALIDATOR, configuration.get("validator"));
            } else {
                configuration.get("validator").byKeyValue
                    .each!(nameValidator => setValidator(nameValidator.key, nameValidator
                            .value));
            }
        }
        _eventManager = myeventManager.ifNull(new DEventManager());
        _behaviors = mybehaviors.ifNull(new BehaviorRegistry());
        _behaviors.setTable(this);
        _associations = myassociations.ifNull(new AssociationCollection());
        /** @psalm-suppress TypeDoesNotContainType */
        queryFactory = queryFactory.ifNull(new DQueryFactory());

        assert(_eventManager !is null, "EventManager not available");

        _eventManager.on(this);
        dispatchEvent("Model.initialize"); */

        return true;
    }

    // Name given to the association, it usually represents the alias assigned to the target associated table
    mixin(TProperty!("string", "name"));

    // Name of default validation set.
    const string DEFAULT_VALIDATOR = "default";

    // The alias this object is assigned to validators as.
    const string VALIDATOR_PROVIDER_NAME = "table";

    // The name of the event dispatched when a validator has been built.
    const string BUILD_VALIDATOR_EVENT = "Model.buildValidator";

    // The IsUnique class name that is used.
    // TODO const string IS_UNIQUE_CLASS = IsUnique.classname;

    // Name of the table as it can be found in the database
    protected string _tableName = null;

    /**
     * Human name giving to this particular instance. Multiple objects representing
     * the same database table can exist by using different aliases.
     */
    protected string _aliasName = null;

    // The name of the field that represents the primary key in the table
    protected string[] _primaryKeys = null;

    // The name of the field that represents a human-readable representation of a row
    protected string[] _displayFields = null;

    // The name of the class that represent a single row for this table
    protected string _entityClass = null;

    // Registry key used to create this table object
    protected string _registryAlias = null;

    // The rules class name that is used.
    // TODO const RulesChecker RULES_CLASS = RulesChecker.classname;

    // Connection instance
    // TODO protected DConnection _connection = null;

    // The schema object containing a description of this table fields
    // TODO protected ITableISchema _schema = null;

    // The associations container for this Table.
    // TODO protected IAssociationCollection _associations;

    /*
    // BehaviorRegistry for this table
    protected IBehaviorRegistry _behaviors;

    protected IQueryFactory myqueryFactory;
    
    /**
     * Get the default connection name.
     *
     * This method is used to get the fallback connection name if an
     * instance is created through the TableLocator without a connection.
     */
    static string defaultConnectionName() {
        return "default";
    }
    
    /**
     * Initialize a table instance. Called after the constructor.
     *
     * You can use this method to define associations, attach behaviors
     * define validation and do any other initialization logic you need.
     *
     * ```
     * auto initialize(Json[string] initData = null)
     * {
     *    this.belongsTo("Users");
     *    this.belongsToMany("Tagging.Tags");
     *    primaryKeys("something_else");
     * }
     * ```
     * Params:
     * Json[string] configData Configuration options passed to the constructor
     */
    bool initialize(Json[string] initData = null) {
        return super.initialize(initData);
    }
    
    /**
     * Sets the database table name.
     *
     * This can include the database schema name in the form "schema.table".
     * If the name must be quoted, enable automatic identifier quoting.
     */
    void setTable(string tableName) {
       _table = tableName;
    }
    
    /**
     * Returns the database table name.
     *
     * This can include the database schema name if set using `setTable()`.
     */
    string getTable() {
        if (_table.isNull) {
            mytable = namespaceSplit(class);
            mytable = subString(to!string(end(mytable)), 0, -5) ?: _aliasName;
            if (!mytable) {
                throw new DException(
                    "You must specify either the `alias` or the `table` option for the constructor."
               );
            }
           _table = Inflector.underscore(mytable);
        }
        return _table;
    }
    
    // Sets the table alias.
    void aliasName(string aliasName) {
       _aliasName = aliasName;
    }
    
    // Returns the table alias.
    string aliasName() {
        if (_aliasName.isNull) {
            aliasName = namespaceSplit(class);
            aliasName = subString(to!string(end(aliasName), 0, -5)) ?: _table;
            if (!aliasName) {
                throw new DException(
                    "You must specify either the `alias` or the `table` option for the constructor."
               );
            }
           _aliasName = aliasName;
        }
        return _aliasName;
    }
    
    /**
     * Alias a field with the table"s current alias.
     * If field is already aliased it will result in no-op.
     */
    string aliasField(string fieldName) {
        if (fieldName.contains(".")) {
            return fieldName;
        }
        return _aliasNameName() ~ "." ~ fieldName;
    }
    
    /**
     * Sets the table registry key used to create this table instance.
     * Params:
     * string myregistryAlias The key used to access this object.
     */
    void registryKey(string key) {
       _registryAlias = key;
    }
    
    // Returns the table registry key used to create this table instance.
    string registryKey() {
        return _registryAlias = _registryAlias.ifEmpty(aliasName());
    }
    
    // Sets the connection instance.
    void setConnection(Connection myconnection) {
       _connection = myconnection;
    }
    
    // Returns the connection instance.
    Connection getConnection() {
        if (!_connection) {
            myconnection = ConnectionManager.get(defaultConnectionName());
            assert(cast(DConnection)myconnection);
           _connection = myconnection;
        }
        return _connection;
    }
    
    // Returns the schema table object describing this table"s properties.
    TableISchema getSchema() {
        if (_schema.isNull) {
           _schema = getConnection()
                .getSchemaCollection()
                .describe(getTable());
            if (configuration.hasKey("debug")) {
                this.checkAliasLengths();
            }
        }
        /** @var \UIM\Database\Schema\TableISchema */
        return _schema;
    }
    
    /**
     * Sets the schema table object describing this table"s properties.
     *
     * If an array is passed, a new DTableISchema will be constructed
     * out of it and used as the schema for this table.
     * Params:
     * \UIM\Database\Schema\TableISchema|array myschema Schema to be used for this table
     */
    void setSchema(TableISchema[string] newSchemas) {
        if (isArray(newSchemas)) {
            auto constraints = null;

            if (newSchemas.hasKey("_constraints")) {
                constraints = newSchemas["_constraints"];
                newSchemas.remove("_constraints");
            }

            newSchemas = getConnection().getDriver().newTableSchema(getTable(), newSchemas);
            foreach (myname, myvalue; constraints) {
                newSchemas.addConstraint(myname, myvalue);
            }
        }
    }
    void setSchema(TableISchema newSchema) {
       _schema = newSchema;
        if (configuration.hasKey("debug")) {
            checkAliasLengths();
        }
    }
    
    /**
     * Checks if all table name + column name combinations used for
     * queries fit into the max length allowed by database driver.
     */
    protected void checkAliasLengths() {
        if (_schema.isNull) {
            throw new DatabaseException(
                "Unable to check max alias lengths for `%s` without schema."
                .format(aliasName()
           ));
        }
        
        auto maxLength = getConnection().getDriver().getMaxAliasLength();
        if (maxLength.isNull) {
            return;
        }
        string aliasName = aliasName();
        _schema.columns().each!(name => checkAliasLength(aliasName, name, maxLength)); 
    }

    protected void checkAliasLength(string aliasName, string name, size_t maxLength) {
        if ((tableName ~ "__" ~ name).length > maxLength) {
            size_t nameLength = maxLength - 2;
            throw new DatabaseException(
                ("ORM queries generate field aliases using the table name/alias and column name. " ~
                "The table alias `%s` and column `%` create an alias longer than (%s). " ~
                "You must change the table schema in the database and shorten either the table or column " ~
                "identifier so they fit within the database alias limits.")
                .format(tableName, name, nameLength)
           );
        }
    }
    
    /**
     * Test to see if a Table has a specific field/column.
     *
     * Delegates to the schema object and checks for column presence
     * using the Schema\Table instance.
     * Params:
     * string fieldName The field to check for.
     */
    bool hasField(string fieldName) {
        return _getSchema().getColumn(fieldName) !is null;
    }
    
    /**
     * Sets the primary key field name.
     * Params:
     * string[]|string aKey Sets a new name to be used as primary key
     */
    void primaryKeys(string[] keys...) {
       primaryKeys(keys.dup);
    }
    void primaryKeys(string[] keys) {
       _primaryKeys = keys;
    }
    
    // Returns the primary key field name.
    string[] primaryKeys() {
        return _primaryKeys.isNull
            ? getSchema().primaryKeys()
            : _primaryKeys;
    }
    
    // Sets the display field.
    void displayfields(string[] fieldNames) {
       _displayFields = fieldName;
    }
    
    // Returns the display field.
    string[] displayfields() {
        if (_displayFields !is null) {
            return _displayFields;
        }
        
        auto myschema = getSchema();
        foreach (fieldName; ["title", "name", "label"]) {
            if (myschema.hasColumn(fieldName)) {
                return _displayFields = fieldName;
            }
        }
        myschema.columns().each!((mycolumn) {
            auto columnSchema = myschema.getColumn(column);
            if (
                columnSchema &&
                columnSchema["null"] != true &&
                columnSchema.getString("type") == "string" &&
                !preg_match("/pass|token|secret/i", column)
           ) {
                return _displayFields = column;
            }
        });
        return _displayFields = this.primaryKeys();
    }
    
    // Returns the class used to hydrate rows for this table.
    string getEntityClass() {
        if (!_entityClass) {
            auto defaultValue = Entity.classname;
            auto myself = class;
            string[] myparts = mysplit("\\");

            if (myself == classname || count(myparts) < 3) {
                return _entityClass = defaultValue;
            }
            string aliasName = Inflector.classify(Inflector.underscore(subString(array_pop(myparts), 0, -5)));
            string myname = array_slice(myparts, 0, -1).join("\\") ~ "\\Entity\\" ~ aliasName;
            if (!class_exists(myname)) {
                return _entityClass = defaultValue;
            }
            /** @var class-string<\UIM\Datasource\IORMEntity>|null myclass */
            myclass = App.classname(myname, "Model/Entity");
            if (!myclass) {
                throw new DMissingEntityException([myname]);
            }
           _entityClass = myclass;
        }
        return _entityClass;
    }
    
    // Sets the class used to hydrate rows for this table.
    void setEntityClass(string nameOfClass) {
        /** @var class-string<\UIM\Datasource\IORMEntity>|null myclass */
        auto myclass = App.classname(nameOfClass, "Model/Entity");
        if (myclass.isNull) {
            throw new DMissingEntityException([myname]);
        }
       _entityClass = myclass;
    }
    
    /**
     * Add a behavior.
     *
     * Adds a behavior to this table"s behavior collection. Behaviors
     * provide an easy way to create horizontally re-usable features
     * that can provide template like functionality, and allow for events
     * to be listened to.
     *
     * Example:
     *
     * Load a behavior, with some settings.
     *
     * ```
     * this.addBehavior("Tree", ["parent": "parentId"]);
     * ```
     *
     * Behaviors are generally loaded during Table.initialize().
     */
    void addBehavior(string behaviorName, Json[string] options = null) {
       _behaviors.load(behaviorName, options);
    }
    
    /**
     * Adds an array of behaviors to the table"s behavior collection.
     *
     * Example:
     *
     * ```
     * this.addBehaviors([
     *    "Timestamp",
     *    "Tree": ["level": "level"],
     * ]);
     * ```
     */
    void addBehaviors(Json[string] behaviorsToLoad) {
        foreach (myname, options; behaviorsToLoad) {
            if (isInteger(myname)) {
                myname = options;
                options = null;
            }
            this.addBehavior(myname, options);
        }
    }
    
    /**
     * Removes a behavior from this table"s behavior registry.
     *
     * Example:
     *
     * Remove a behavior from this table.
     *
     * ```
     * this.removeBehavior("Tree");
     * ```
     * Params:
     * string myname The alias that the behavior was added with.
     */
    void removeBehavior(string myname) {
       _behaviors.unload(myname);
    }
    
    /**
     * Returns the behavior registry for this table.
     */
    BehaviorRegistry behaviors() {
        return _behaviors;
    }
    
    /**
     * Get a behavior from the registry.
     * Params:
     * string myname The behavior alias to get from the registry.
     */
    DArrayAttributeBehavior getBehavior(string behaviorAlias) {
        if (!_behaviors.has(behaviorAlias)) {
            throw new DInvalidArgumentException(
                "The `%s` behavior is not defined on `%s`."
                .format(behaviorAlias, class)
           );
        }

        return _behaviors.get(behaviorAlias);
    }
    
    // Check if a behavior with the given alias has been loaded.
    bool hasBehavior(string behaviorAlias) {
        return _behaviors.has(behaviorAlias);
    }
    
    /**
     * Returns an association object configured for the specified alias.
     *
     * The name argument also supports dot syntax to access deeper associations.
     *
     * ```
     * myusers = getAssociation("Articles.Comments.Users");
     * ```
     *
     * Note that this method requires the association to be present or otherwise
     * throws an exception.
     * If you are not sure, use hasAssociation() before calling this method.
     * Params:
     * string myname The alias used for the association.
     */
    DAssociation getAssociation(string associationAlias) {
        auto association = findAssociation(associationAlias);
        if (!association) {
            auto assocationKeys = this.associations().keys();

            auto message = "The `{myname}` association is not defined on `{aliasName()}`.";
            if (assocationKeys) {
                message ~= "\nValid associations are: " ~ join(", ", assocationKeys);
            }
            throw new DInvalidArgumentException(message);
        }
        return association;
    }
    
    /**
     * Checks whether a specific association exists on this Table instance.
     *
     * The name argument also supports dot syntax to access deeper associations.
     *
     * ```
     * myhasUsers = this.hasAssociation("Articles.Comments.Users");
     * ```
     */
   bool hasAssociation(string associationName) {
        return _findAssociation(associationName) !is null;
    }
    
    /**
     * Returns an association object configured for the specified alias if any.
     *
     * The name argument also supports dot syntax to access deeper associations.
     *
     * ```
     * myusers = getAssociation("Articles.Comments.Users");
     * ```
     * Params:
     * string myname The alias used for the association.
     */
    protected IAssociation findAssociation(string associationName) {
        if (!associationName.contains(".")) {
            return _associations.get(associationName);
        }
        result = null;
        [associationName, mynext] = array_pad(split(".", associationName, 2), 2, null);
        if (associationName !is null) {
            result = _associations.get(associationName);
        }
        if (result !is null && mynext !is null) {
            result = result.getTarget().getAssociation(mynext);
        }
        return result;
    }
    
    /**
     * Get the associations collection for this table.
     */
    AssociationCollection associations() {
        return _associations;
    }
    
    /**
     * Setup multiple associations.
     *
     * It takes an array containing set of table names indexed by association type
     * as argument:
     *
     * ```
     * this.Posts.addAssociations([
     * "belongsTo": [
     *   "Users": ["classname": "App\Model\Table\UsersTable"]
     * ],
     * "hasMany": ["Comments"],
     * "belongsToMany": ["Tags"]
     * ]);
     * ```
     *
     * Each association type accepts multiple associations where the keys
     * are the aliases, and the values are association config data. If numeric
     * keys are used the values will be treated as association aliases.
     * Params:
     * Json[string] params Set of associations to bind (indexed by association type)
     */
    void addAssociations(Json[string] params) {
        foreach (myassocType: mytables; params) {
            foreach (myassociated: options; mytables) {
                if (isNumeric(myassociated)) {
                    myassociated = options;
                    options = null;
                }
                this.{myassocType}(myassociated, options);
            }
        }
    }
    
    /**
     * Creates a new BelongsTo association between this table and a target
     * table. A "belongs to" association is a N-1 relationship where this table
     * is the N side, and where there is a single associated record in the target
     * table for each one in this table.
     *
     * Target table can be inferred by its name, which is provided in the
     * first argument, or you can either pass the to be instantiated or
     * an instance of it directly.
     *
     * The options array accept the following keys:
     *
     * - classname: The class name of the target table object
     * - targetTable: An instance of a table object to be used as the target table
     * - foreignKeys: The name of the field to use as foreign key, if false none
     * will be used
     * - conditions: array with a list of conditions to filter the join with
     * - joinType: The type of join to be used (e.g. INNER)
     * - strategy: The loading strategy to use. "join" and "select" are supported.
     * - finder: The finder method to use when loading records from this association.
     * Defaults to "all". When the strategy is "join", only the fields, containments,
     * and where conditions will be used from the finder.
     *
     * This method will return the association object that was built.
     */
    BelongsTo belongsTo(string associatedName, Json[string] options = null) {
        auto updatedOptions = options.update["sourceTable": this];

        /** @var \ORM\Association\BelongsTo */
        return _associations.load(BelongsTo.classname, associatedName, options);
    }
    
    /**
     * Creates a new DHasOne association between this table and a target
     * table. A "has one" association is a 1-1 relationship.
     *
     * Target table can be inferred by its name, which is provided in the
     * first argument, or you can either pass the class name to be instantiated or
     * an instance of it directly.
     *
     * The options array accept the following keys:
     *
     * - classname: The class name of the target table object
     * - targetTable: An instance of a table object to be used as the target table
     * - foreignKeys: The name of the field to use as foreign key, if false none
     * will be used
     * - dependent: Set to true if you want UIM to cascade deletes to the
     * associated table when an entity is removed on this table. The delete operation
     * on the associated table will not cascade further. To get recursive cascades enable
     * `cascadeCallbacks` as well. Set to false if you don"t want UIM to remove
     * associated data, or when you are using database constraints.
     * - cascadeCallbacks: Set to true if you want UIM to fire callbacks on
     * cascaded deletes. If false the ORM will use deleteAll() to remove data.
     * When true records will be loaded and then deleted.
     * - conditions: array with a list of conditions to filter the join with
     * - joinType: The type of join to be used (e.g. LEFT)
     * - strategy: The loading strategy to use. "join" and "select" are supported.
     * - finder: The finder method to use when loading records from this association.
     * Defaults to "all". When the strategy is "join", only the fields, containments,
     * and where conditions will be used from the finder.
     *
     * This method will return the association object that was built.
     */
    HasOne hasOne(string associatedName, Json[string] options = null) {
        auto updatedOptions = options.update["sourceTable": this];

        return _associations.load(HasOne.classname, associatedName, options);
    }
    
    /**
     * Creates a new DHasMany association between this table and a target
     * table. A "has many" association is a 1-N relationship.
     *
     * Target table can be inferred by its name, which is provided in the
     * first argument, or you can either pass the class name to be instantiated or
     * an instance of it directly.
     *
     * The options array accept the following keys:
     *
     * - classname: The class name of the target table object
     * - targetTable: An instance of a table object to be used as the target table
     * - foreignKeys: The name of the field to use as foreign key, if false none
     * will be used
     * - dependent: Set to true if you want UIM to cascade deletes to the
     * associated table when an entity is removed on this table. The delete operation
     * on the associated table will not cascade further. To get recursive cascades enable
     * `cascadeCallbacks` as well. Set to false if you don"t want UIM to remove
     * associated data, or when you are using database constraints.
     * - cascadeCallbacks: Set to true if you want UIM to fire callbacks on
     * cascaded deletes. If false the ORM will use deleteAll() to remove data.
     * When true records will be loaded and then deleted.
     * - conditions: array with a list of conditions to filter the join with
     * - sort: The order in which results for this association should be returned
     * - saveStrategy: Either "append" or "replace". When "append" the current records
     * are appended to any records in the database. When "replace" associated records
     * not in the current set will be removed. If the foreign key is a null able column
     * or if `dependent` is true records will be orphaned.
     * - strategy: The strategy to be used for selecting results Either "select"
     * or "subquery". If subquery is selected the query used to return results
     * in the source table will be used as conditions for getting rows in the
     * target table.
     * - finder: The finder method to use when loading records from this association.
     * Defaults to "all".
     *
     * This method will return the association object that was built.
     * Params:
     * string myassociated the alias for the target table. This is used to
     * uniquely identify the association
     */
    HasMany hasMany(string myassociated, Json[string] options = null) {
        auto updatedOptions = options.update["sourceTable": this];

        /** @var \ORM\Association\HasMany */
        return _associations.load(HasMany.classname, myassociated, options);
    }
    
    /**
     * Creates a new BelongsToMany association between this table and a target
     * table. A "belongs to many" association is a M-N relationship.
     *
     * Target table can be inferred by its name, which is provided in the
     * first argument, or you can either pass the class name to be instantiated or
     * an instance of it directly.
     *
     * The options array accept the following keys:
     *
     * - classname: The class name of the target table object.
     * - targetTable: An instance of a table object to be used as the target table.
     * - foreignKeys: The name of the field to use as foreign key.
     * - targetForeignKey: The name of the field to use as the target foreign key.
     * - joinTable: The name of the table representing the link between the two
     * - through: If you choose to use an already instantiated link table, set this
     * key to a configured Table instance containing associations to both the source
     * and target tables in this association.
     * - dependent: Set to false, if you do not want junction table records removed
     * when an owning record is removed.
     * - cascadeCallbacks: Set to true if you want UIM to fire callbacks on
     * cascaded deletes. If false the ORM will use deleteAll() to remove data.
     * When true join/junction table records will be loaded and then deleted.
     * - conditions: array with a list of conditions to filter the join with.
     * - sort: The order in which results for this association should be returned.
     * - strategy: The strategy to be used for selecting results Either "select"
     * or "subquery". If subquery is selected the query used to return results
     * in the source table will be used as conditions for getting rows in the
     * target table.
     * - saveStrategy: Either "append" or "replace". Indicates the mode to be used
     * for saving associated entities. The former will only create new links
     * between both side of the relation and the latter will do a wipe and
     * replace to create the links between the passed entities when saving.
     * - strategy: The loading strategy to use. "select" and "subquery" are supported.
     * - finder: The finder method to use when loading records from this association.
     * Defaults to "all".
     *
     * This method will return the association object that was built.
     * Params:
     * string myassociated the alias for the target table. This is used to
     * uniquely identify the association
     */
    BelongsToMany belongsToMany(string myassociated, Json[string] options = null) {
        auto updatedOptions = options.update["sourceTable": this];

        /** @var \ORM\Association\BelongsToMany */
        return _associations.load(BelongsToMany.classname, myassociated, options);
    }
    
    /**
     * Creates a new Query for this repository and applies some defaults based on the
     * type of search that was selected.
     *
     * ### Model.beforeFind event
     *
     * Each find() will trigger a `Model.beforeFind` event for all attached
     * listeners. Any listener can set a valid result set using myquery
     *
     * By default, following special named arguments are recognized which are
     * used as select query options:
     *
     * - fields
     * - conditions
     * - order
     * - limit
     * - offset
     * - page
     * - group
     * - having
     * - contain
     * - join
     *
     * ### Usage
     *
     * ```
     * myquery = myarticles.find("all",
     * conditions: ["published": 1],
     * limit: 10,
     * contain: ["Users", "Comments"]
     *);
     * ```
     *
     * Using the builder interface:
     *
     * ```
     * myquery = myarticles.find()
     * .where(["published": 1])
     * .limit(10)
     * .contain(["Users", "Comments"]);
     * ```
     *
     * ### Calling finders
     *
     * The find() method is the entry point for custom finder methods.
     * You can invoke a finder by specifying the type.
     *
     * This will invoke the `findPublished` method:
     *
     * ```
     * myquery = myarticles.find("published");
     * ```
     *
     * ## Typed finder arguments
     *
     * Finders must have a `SelectQuery` instance as their 1st argument and any
     * additional parameters as needed.
     *
     * Here, the finder "findByCategory" has an integer `mycategory` parameter:
     *
     * ```
     * auto findByCategory(SelectQuery myquery, int mycategory): SelectQuery
     * {
     *   return myquery;
     * }
     * ```
     *
     * This finder can be called as:
     *
     * ```
     * myquery = myarticles.find("byCategory", mycategory);
     * ```
     *
     * or using named arguments as:
     * ```
     * myquery = myarticles.find(type: "byCategory", category: mycategory);
     * ```
     * Params:
     * string mytype the type of query to perform
     * @param Json ...arguments Arguments that match up to finder-specific parameters
     */
    SelectQuery find(string mytype = "all", Json ...arguments) {
        return _callFinder(mytype, this.selectQuery(), ...arguments);
    }
    
    /**
     * Returns the query as passed.
     *
     * By default findAll() applies no query clauses, you can override this
     * method in subclasses to modify how `find("all")` works.
     * Params:
     * \ORM\Query\SelectQuery myquery The query to find with
     */
    SelectQuery findAll(SelectQuery myquery) {
        return myquery;
    }
    
    /**
     * Sets up a query object so results appear as an indexed array, useful for any
     * place where you would want a list such as for populating input select boxes.
     *
     * When calling this finder, the fields passed are used to determine what should
     * be used as the array key, value and optionally what to group the results by.
     * By default, the primary key for the model is used for the key, and the display
     * field as value.
     *
     * The results of this finder will be in the following form:
     *
     * ```
     * [
     * 1: "value for id 1",
     * 2: "value for id 2",
     * 4: "value for id 4"
     * ]
     * ```
     *
     * You can specify which property will be used as the key and which as value,
     * when not specified, it will use the results of calling `primaryKeys` and
     * `displayField` respectively in this table:
     *
     * ```
     * mytable.find("list", keyField: "name", valueField: "age");
     * ```
     *
     * The `valueField` can also be an array, in which case you can also specify
     * the `valueSeparator` option to control how the values will be concatenated:
     *
     * ```
     * mytable.find("list",  valueField: ["first_name", "last_name"], valueSeparator: " | ");
     * ```
     *
     * The results of this finder will be in the following form:
     *
     * ```
     * [
     * 1: "John | Doe",
     * 2: "Steve | Smith"
     * ]
     * ```
     *
     * Results can be put together in bigger groups when they share a property, you
     * can customize the property to use for grouping by setting `groupField`:
     *
     * ```
     * mytable.find("list", groupField: "category_id");
     * ```
     *
     * When using a `groupField` results will be returned in this format:
     *
     * ```
     * [
     * "group_1": [
     *    1: "value for id 1",
     *    2: "value for id 2",
     * ]
     * "group_2": [
     *    4: "value for id 4"
     * ]
     * ]
     * ```
     * Params:
     * \ORM\Query\SelectQuery myquery The query to find with
     */
    SelectQuery findList(
        SelectQuery myquery,
       /* Closure */ string[]|string keyField = null,
       /* Closure */ string[]|string myvalueField = null,
       /* Closure */ string[]|string mygroupField = null,
        string myvalueSeparator = ";"
   ) {
        keyField ??= this.primaryKeys();
        myvalueField ??= displayfields();

        if (
            !myquery.clause("select") &&
            !isObject(keyField) &&
            !isObject(myvalueField) &&
            !isObject(mygroupField)
       ) {
            fieldNames = chain(
                /* (array) */keyField,
                /* (array) */myvalueField,
                /* (array) */mygroupField
           );
            mycolumns = getSchema().columns();
            if (count(fieldNames) == count(array_intersect(fieldNames, mycolumns))) {
                myquery.select(fieldNames);
            }
        }
        options = _setFieldMatchers(
            compact("keyField", "valueField", "groupField", "valueSeparator"),
            ["keyField", "valueField", "groupField"]
       );

        return myquery.formatResults(fn (ICollection results) =>
            results.combine(
                options["keyField"],
                options["valueField"],
                options["groupField"]
           ));
    }
    
    /**
     * Results for this finder will be a nested array, and is appropriate if you want
     * to use the parent_id field of your model data to build nested results.
     *
     * Values belonging to a parent row based on their parent_id value will be
     * recursively nested inside the parent row values using the `children` property
     *
     * You can customize what fields are used for nesting results, by default the
     * primary key and the `parent_id` fields are used. If you wish to change
     * these defaults you need to provide the `keyField`, `parentField` or `nestingKey`
     * arguments:
     *
     * ```
     * mytable.find("threaded", keyField: "id", parentField: "ancestor_id", nestingKey: "children");
     * ```
     * Params:
     * \ORM\Query\SelectQuery myquery The query to find with
     */
    DSelectQuery findThreaded(
        DSelectQuery selectquery,
       /* Closure */ /* string[]| */string keyField = null,
       /* Closure */ /* string[]| */string parentField = "parent_id",
        string nestingKey = "children"
   ) {
        keyField ??= this.primaryKeys();

        options = _setFieldMatchers(compact("keyField", "parentField"), ["keyField", "parentField"]);

        return selectquery.formatResults(fn (ICollection results) =>
            results.nest(options["keyField"], options["parentField"], nestingKey));
    }
    
    /**
     * Out of an options array, check if the keys described in `someKeys` are arrays
     * and change the values for closures that will concatenate the each of the
     * properties in the value array when passed a row.
     *
     * This is an auxiliary auto used for result formatters that can accept
     * composite keys when comparing values.
     */
    protected Json[string] _setFieldMatchers(Json[string] options, Json[string] keys) {
        keys.each!((field) {
            if (!options[field].isArray) {
                continue;
            }
            if (count(options[field]) == 1) {
                options[field] = currentValue(options[field]);
                continue;
            }
            
            auto fieldNames = options.get(field);
            auto myglue = isIn(field, ["keyField", "parentField"], true) ? ";" : options.get("valueSeparator");
            options[field] = auto (myrow) use (fieldNames, myglue) {
                auto mymatches = fieldNames.each!(fld => myrow[fld]).array;
                return join(myglue, mymatches);
            };
        }
        return options;
    }
    
    /**

     * ### Usage
     *
     * Get an article and some relationships:
     *
     * ```
     * myarticle = myarticles.get(1, ["contain": ["Users", "Comments"]]);
     * ```
     * Params:
     * @param \Psr\SimpleCache\ICache|string mycache The cache config to use.
     * Defaults to `null`, i.e. no caching.
     * @param \/*Closure|* / string mycacheKey The cache key to use. If not provided
     * one will be autogenerated if `mycache` is not null.
     */
    IORMEntity get(
        Json primaryKey,
        /* string[]| */string myfinder = "all",
        /* ICache| */string cacheConfig = null,
        /*Closure|*/ string mycacheKey = null,
        Json arguments
   ) {
        if (primaryKey.isNull) {
            throw new DInvalidPrimaryKeyException(
                "Record not found in table `%s` with primary key `[NULL]`."
                .format(getTable()
           ));
        }
        auto keys = (array)this.primaryKeys();
        auto aliasName = aliasName();
        foreach (myindex, mykeyname; keys) {
            keys[myindex] = aliasName ~ "." ~ mykeyname;
        }
        if (!isArray(primaryKey)) {
            primaryKey = [primaryKey];
        }
        if (count(keys) != count(primaryKey)) {
            primaryKey = primaryKey ?: [null];
            primaryKey = array_map(function (keys) {
                return var_export_(keys, true);
            }, primaryKey);

            throw new DInvalidPrimaryKeyException(
                "Record not found in table `%s` with primary key `[%s]`."
                .format(getTable(), join(", ", primaryKey)
           ));
        }
        myconditions = array_combine(keys, primaryKey);

        if (isArray(myfinder)) {
            deprecationWarning(
                "5.0.0",
                "Calling Table.get() with options array is deprecated."
                    ~ " Use named arguments instead."
           );

            arguments += myfinder;
            myfinder = arguments.getString("finder", "all");
            if (arguments.hasKey("cache")) {
                cacheConfig = arguments["cache"];
            }
            if (arguments.hasKey("key")) {
                mycacheKey = arguments["key"];
            }
            remove(arguments["key"], arguments["cache"], arguments["finder"]);
        }
        myquery = this.find(myfinder, ...arguments).where(myconditions);

        if (cacheConfig) {
            if (!mycacheKey) {
                mycacheKey = "get-%s-%s-%s"
                    .format(
                        getConnection().configName(),
                        getTable(),
                        Json_encode(primaryKey, Json_THROW_ON_ERROR)
                   );
            }
            myquery.cache(mycacheKey, cacheConfig);
        }
        return myquery.firstOrFail();
    }
    
    /**
     * Handles the logic executing of a worker inside a transaction.
     * Params:
     * callable myworker The worker that will run inside the transaction.
     */
    protected Json _executeTransaction(callable myworker, bool isAtomic = true) {
        /* if (isAtomic) {
            return _getConnection().transactional(fn (): myworker());
        } */
        return myworker();
    }
    
    // Checks if the caller would have executed a commit on a transaction.
    protected bool _transactionCommitted(bool isAtomic, bool isPrimary) {
        return !getConnection().inTransaction() && (isAtomic || isPrimary);
    }
    
    /**
     * Finds an existing record or creates a new one.
     *
     * A find() will be done to locate an existing record using the attributes
     * defined in mysearch. If records matches the conditions, the first record
     * will be returned.
     *
     * If no record can be found, a new DORMEntity will be created
     * with the mysearch properties. If a callback is provided, it will be
     * called allowing you to define additional default values. The new
     * entity will be saved and returned.
     *
     * If your find conditions require custom order, associations or conditions, then the mysearch
     * parameter can be a callable that takes the Query as the argument, or a \ORM\Query\SelectQuery object passed
     * as the mysearch parameter. Allowing you to customize the find results.
     *
     * ### Options
     *
     * The options array is passed to the save method with exception to the following keys:
     *
     * - atomic: Whether to execute the methods for find, save and callbacks inside a database
     * transaction (default: true)
     * - defaults: Whether to use the search criteria as default values for the new DORMEntity (default: true)
     * Params:
     * \ORM\Query\SelectQuery|callable|array mysearch The criteria to find existing
     * records by. Note that when you pass a query object you"ll have to use
     * the 2nd arg of the method to modify the entity data before saving.
     */
    IORMEntity findOrCreate(
        DSelectQuery/* |callable|array */ mysearch,
        /* callable aCallback = null, */
        Json[string] options = null
   ) {
        options = new Json[string](options ~ [
            "atomic": true.toJson,
            "defaults": true.toJson,
        ]);

        IORMEntity entity = null;
        /* entity = _executeTransaction(
            fn (): _processFindOrCreate(mysearch, null /* mycallback */, options.getArrayCopy()),
            options["atomic"]
       ); */

        if (entity && _transactionCommitted(options.get("atomic"), true)) {
            dispatchEvent("Model.afterSaveCommit", compact("entity", "options"));
        }
        return entity;
    }
    
    // Performs the actual find and/or create of an entity based on the passed options.
    protected IORMEntity _processFindOrCreate(
        DSelectQuery/* |callable|array */ mysearch,
        // callable aCallback = null,
        Json[string] options = null
   ) {
        auto myquery = _getFindOrCreateQuery(mysearch);

        auto myrow = myquery.first();
        if (myrow !is null) {
            return myrow;
        }
        myentity = this.newEmptyEntity();
        if (options["defaults"] && isArray(mysearch)) {
            myaccessibleFields = array_combine(mysearch.keys, array_fill(0, count(mysearch), true));
            myentity = this.patchEntity(myentity, mysearch, ["accessibleFields": myaccessibleFields]);
        }
        if (mycallback !is null) {
            myentity = mycallback(myentity) ?: myentity;
        }
        options.remove("defaults");

        result = this.save(myentity, options);

        if (result == false) {
            throw new DPersistenceFailedException(myentity, ["findOrCreate"]);
        }
        return myentity;
    }
    
    /**
     * Gets the query object for findOrCreate().
     * Params:
     * \ORM\Query\SelectQuery|callable|array mysearch The criteria to find existing records by.
     */
    protected ISelectQuery _getFindOrCreateQuery(SelectQuery|callable|array mysearch) {
        if (isCallable(mysearch)) {
            myquery = this.find();
            mysearch(myquery);
        } else if (isArray(mysearch)) {
            myquery = this.find().where(mysearch);
        } else {
            myquery = mysearch;
        }
        return myquery;
    }
    
    // Creates a new DSelectQuery instance for a table.
    SelectQuery query() {
        return _selectQuery();
    }
    
    // Creates a new select query
    SelectQuery selectQuery() {
        return _queryFactory.select(this);
    }
    
    // Creates a new insert query
    InsertQuery insertQuery() {
        return _queryFactory.insert(this);
    }
    
    // Creates a new update query
    UpdateQuery updateQuery() {
        return _queryFactory.update(this);
    }
    
    /**
     * Creates a new delete query
     */
    DeleteQuery deleteQuery() {
        return _queryFactory.remove(this);
    }
    
    /**
     * Creates a new Query instance with field auto aliasing disabled.
     *
     * This is useful for subqueries.
     */
    SelectQuery subquery() {
        return _queryFactory.select(this).disableAutoAliasing();
    }
    
    /**
     * Update all matching records.
     *
     * Sets the fieldNames to the provided values based on myconditions.
     * This method will *not* trigger beforeSave/afterSave events. If you need those
     * first load a collection of records and update them.
     * Params:
     * \UIM\Database\Expression\QueryExpression|\/*Closure|*/ string[]|string fieldNames A hash of field: new value.
     * @param \UIM\Database\Expression\QueryExpression|\/*Closure|*/ string[]|string myconditions Conditions to be used, accepts anything Query.where()
     */
    int updateAll(
        QueryExpression|/*Closure|*/ string[]|string fieldNames,
        QueryExpression|/*Closure|*/ string[]|string myconditions
   ) {
        mystatement = this.updateQuery()
            .set(fieldNames)
            .where(myconditions)
            .execute();

        return mystatement.rowCount();
    }
    
    /**
     * Deletes all records matching the provided conditions.
     *
     * This method will *not* trigger beforeDelete/afterDelete events. If you
     * need those first load a collection of records and delete them.
     *
     * This method will *not* execute on associations" `cascade` attribute. You should
     * use database foreign keys + ON CASCADE rules if you need cascading deletes combined
     * with this method.
     * Params:
     * \UIM\Database\Expression\QueryExpression|\/*Closure|*/ string[]|string myconditions Conditions to be used, accepts anything Query.where()
     * can take.
     */
    int deleteAll(QueryExpression|/*Closure|*/ string[]|string myconditions) {
        auto mystatement = this.deleteQuery()
            .where(myconditions)
            .execute();

        return mystatement.rowCount();
    }
 
    bool exists(QueryExpression|/*Closure|*/ string[]|string myconditions) {
        return (bool)count(
            this.find("all")
            .select(["existing": 1])
            .where(myconditions)
            .limit(1)
            .disableHydration()
            .toJString()
       );
    }
    
    /**
     * ### Options
     *
     * The options array accepts the following keys:
     *
     * - atomic: Whether to execute the save and callbacks inside a database
     * transaction (default: true)
     * - checkRules: Whether to check the rules on entity before saving, if the checking
     * fails, it will abort the save operation. (default:true)
     * - associated: If `true` it will save 1st level associated entities as they are found
     * in the passed `myentity` whenever the property defined for the association
     * is marked as dirty. If an array, it will be interpreted as the list of associations
     * to be saved. It is possible to provide different options for saving on associated
     * table objects using this key by making the custom options the array value.
     * If `false` no associated records will be saved. (default: `true`)
     * - checkExisting: Whether to check if the entity already exists, assuming that the
     * entity is marked as not new, and the primary key has been set.
     *
     * ### Events
     *
     * When saving, this method will trigger four events:
     *
     * - Model.beforeRules: Will be triggered right before any rule checking is done
     * for the passed entity if the `checkRules` key in options is not set to false.
     * Listeners will receive as arguments the entity, options array and the operation type.
     * If the event is stopped the rules check result will be set to the result of the event it
     * - Model.afterRules: Will be triggered right after the `checkRules()` method is
     * called for the entity. Listeners will receive as arguments the entity,
     * options array, the result of checking the rules and the operation type.
     * If the event is stopped the checking result will be set to the result of
     * the event it
     * - Model.beforeSave: Will be triggered just before the list of fields to be
     * persisted is calculated. It receives both the entity and the options as
     * arguments. The options array is passed as an Json[string], so any changes in
     * it will be reflected in every listener and remembered at the end of the event
     * so it can be used for the rest of the save operation. Returning false in any
     * of the listeners will abort the saving process. If the event is stopped
     * using the event API, the event object"s `result` property will be returned.
     * This can be useful when having your own saving strategy implemented inside a
     * listener.
     * - Model.afterSave: Will be triggered after a successful insert or save,
     * listeners will receive the entity and the options array as arguments. The type
     * of operation performed (insert or update) can be determined by checking the
     * entity"s method `isNew`, true meaning an insert and false an update.
     * - Model.afterSaveCommit: Will be triggered after the transaction is committed
     * for atomic save, listeners will receive the entity and the options array
     * as arguments.
     *
     * This method will determine whether the passed entity needs to be
     * inserted or updated in the database. It does that by checking the `isNew`
     * method on the entity. If the entity to be saved returns a non-empty value from
     * its `errors()` method, it will not be saved.
     *
     * ### Saving on associated tables
     *
     * This method will by default persist entities belonging to associated tables,
     * whenever a dirty property matching the name of the property name set for an
     * association in this table. It is possible to control what associations will
     * be saved and to pass additional option for saving them.
     *
     * ```
     * Only save the comments association
     * myarticles.save(myentity, ["associated": ["Comments"]]);
     *
     * Save the company, the employees and related addresses for each of them.
     * For employees do not check the entity rules
     * mycompanies.save(myentity, [
     * "associated": [
     *   "Employees": [
     *     "associated": ["Addresses"],
     *     "checkRules": false.toJson
     *   ]
     * ]
     * ]);
     *
     * Save no associations
     * myarticles.save(myentity, ["associated": false.toJson]);
     * ```
     */
    IORMEntity save(IORMEntity entityToSave,
        Json[string] options = null
   ) {
        options = new Json[string](options ~ [
            "atomic": true.toJson,
            "associated": true.toJson,
            "checkRules": true.toJson,
            "checkExisting": true.toJson,
            "_primary": true.toJson,
            "_cleanOnSuccess": true.toJson,
        ]);

        if (entityToSave.hasErrors(options.getBoolean("associated"))) {
            return false;
        }
        if (entityToSave.isNew() == false && !entityToSave.isChanged()) {
            return entityToSave;
        }
        mysuccess = _executeTransaction(
            fn (): _processSave(entityToSave, options),
            options["atomic"]
       );

        if (mysuccess) {
            if (_transactionCommitted(options["atomic"], options["_primary"])) {
                dispatchEvent("Model.afterSaveCommit", compact("entity", "options"));
            }
            if (options.hasAnyKeys("atomic", "_primary")) {
                if (options.jasKey("_cleanOnSuccess")) {
                    entityToSave.clean();
                    entityToSave.setNew(false);
                }
                entityToSave.setSource(this.registryKey());
            }
        }
        return mysuccess;
    }
    
    /**
     * Try to save an entity or throw a PersistenceFailedException if the application rules checks failed,
     * the entity contains errors or the save was aborted by a callback.
     * Params:
     * \UIM\Datasource\IORMEntity entityToSave the entity to be saved
     * @param Json[string] options The options to use when saving.
     */
    IORMEntity saveOrFail(IORMEntity entityToSave, Json[string] options = null) {
        mysaved = this.save(entityToSave, options);
        if (mysaved == false) {
            throw new DPersistenceFailedException(entityToSave, ["save"]);
        }
        return mysaved;
    }
    
    /**
     * Performs the actual saving of an entity based on the passed options.
     * Params:
     * \UIM\Datasource\IORMEntity entityToSave the entity to be saved
     * @param \Json[string]<string, mixed> options the options to use for the save operation
     */
    protected IORMEntity|false _processSave(IORMEntity entityToSave, Json[string] options) {
        auto myprimaryColumns = (array)this.primaryKeys();

        if (options["checkExisting"] && myprimaryColumns && entityToSave.isNew() && entityToSave.has(myprimaryColumns)) {
            auto aliasName = aliasName();
            auto myconditions = null;
            entityToSave.extract(myprimaryColumns).byKeyValue.each!(kv => myconditions.set(["aliasName", kv.key], kv.value));
            entityToSave.setNew(!this.exists(myconditions));
        }
        auto mymode = entityToSave.isNew() ? RulesChecker.CREATE : RulesChecker.UPDATE;
        if (options["checkRules"] && !this.checkRules(entityToSave, mymode, options)) {
            return false;
        }
        options["associated"] = _associations.normalizeKeys(options["associated"]);
        auto myevent = dispatchEvent("Model.beforeSave", compact("entity", "options"));

        if (myevent.isStopped()) {
            auto result = myevent.getResult();
            if (result.isNull) {
                return false;
            }
            if (result == true) {
                assert(
                    cast(IORMEntity)result,                    
                    "The beforeSave callback must return `false` or `IORMEntity` instance. Got `%s` instead."
                    .format(get_debug_type(result))
               );
            }
            return result;
        }
        auto mysaved = _associations.saveParents(
            this,
            entityToSave,
            options["associated"],
            ["_primary": false.toJson] + options.getArrayCopy()
       );

        if (!mysaved && options["atomic"]) {
            return false;
        }
        auto mydata = entityToSave.extract(getSchema().columns(), true);
        auto myisNew = entityToSave.isNew();

        auto mysuccess = myisNew
            ? _insert(entityToSave, mydata)
            : _update(entityToSave, mydata);

        if (mysuccess) {
            mysuccess = _onSaveSuccess(entityToSave, options);
        }
        if (!mysuccess && myisNew) {
            entityToSave.remove(this.primaryKeys());
            entityToSave.setNew(true);
        }
        return mysuccess ? entityToSave : false;
    }
    
    /**
     * Handles the saving of children associations and executing the afterSave logic
     * once the entity for this table has been saved successfully.
     * Params:
     * \UIM\Datasource\IORMEntity entityToSave the entity to be saved
     * @param \Json[string]<string, mixed> options the options to use for the save operation
     */
    protected bool _onSaveSuccess(IORMEntity entityToSave, Json[string] options) {
        mysuccess = _associations.saveChildren(
            this,
            entityToSave,
            options["associated"],
            ["_primary": false.toJson] + options.getArrayCopy()
       );

        if (!mysuccess && options["atomic"]) {
            return false;
        }
        dispatchEvent("Model.afterSave", compact("entity", "options"));

        if (options["atomic"] && !getConnection().inTransaction()) {
            throw new DRolledbackTransactionException(["table": class]);
        }
        if (!options.hasKey("atomic") && !options.hasKey("_primary") {
            entityToSave.clean();
            entityToSave.setNew(false);
            entityToSave.setSource(this.registryKey());
        }
        return true;
    }
    
    /**
     * Auxiliary auto to handle the insert of an entity"s data in the table
     * Params:
     * \UIM\Datasource\IORMEntity myentity the subject entity from were mydata was extracted
     * @param Json[string] data The actual data that needs to be saved
     */
    protected IORMEntity _insert(IORMEntity myentity, Json[string] data) {
        auto primaryKeys = (array)this.primaryKeys();
        if (isEmpty(primaryKeys)) {
            mymsg = "Cannot insert row in `%s` table, it has no primary key."
                .format(getTable());
            throw new DatabaseException(mymsg);
        }
        auto someKeys = array_fill(0, count(primaryKeys), null);
        auto myid = (array)_newId(primaryKeys) + someKeys;

        // Generate primary keys preferring values in mydata.
        primaryKeys = array_combine(primaryKeys, myid);
        primaryKeys = array_intersectinternalKey(mydata, primaryKeys) + primaryKeys;

        myfilteredKeys = array_filter(primaryKeys, auto (value) {
            return value !is null;
        });
        mydata += myfilteredKeys;

        if (count(primaryKeys) > 1) {
            myschema = getSchema();
            foreach (key, value; myprimary) {
                if (!mydata.hasKey(key) && myschema.getColumn(key).isEmpty("autoIncrement")) {
                    auto message = "Cannot insert row, some of the primary key values are missing. ";
                    message ~= 
                        "Got (%s), expecting (%s)"
                        .format(
                        myfilteredKeys + myentity.extract(myprimary.keys).join(", "),
                        myprimary.keys.join(", ")
                   );
                    throw new DatabaseException(mymsg);
                }
            }
        }
        if (mydata.isEmpty) {
            return false;
        }
        mystatement = this.insertQuery().insert(mydata.keys)
            .values(mydata)
            .execute();

        mysuccess = false;
        if (mystatement.rowCount() != 0) {
            mysuccess = myentity;
            myentity.set(myfilteredKeys, ["guard": false.toJson]);
            myschema = getSchema();
            mydriver = getConnection().getDriver();
            foreach (key, value; myprimary) {
                if (!mydata.hasKey(key)) {
                    myid = mystatement.lastInsertId(getTable(), key);
                    mytype = myschema.getColumnType(key);
                    assert(mytype !is null);
                    myentity.set(key, TypeFactory.build(mytype).ToD(myid, mydriver));
                    break;
                }
            }
        }
        return mysuccess;
    }
    
    /**
     * Generate a primary key value for a new record.
     *
     * By default, this uses the type system to generate a new primary key
     * value if possible. You can override this method if you have specific requirements
     * for id generation.
     *
     * Note: The ORM will not generate primary key values for composite primary keys.
     * You can overwrite _newId() in your table class.
     * Params:
     * string[] myprimary The primary key columns to get a new DID for.
     */
    protected string _newId(Json[string] myprimary) {
        if (!myprimary || count(myprimary) > 1) {
            return null;
        }
        mytypeName = getSchema().getColumnType(myprimary[0]);
        assert(mytypeName !is null);
        mytype = TypeFactory.build(mytypeName);

        return mytype.newId();
    }
    
    /**
     * Auxiliary auto to handle the update of an entity"s data in the table
     * Params:
     * \UIM\Datasource\IORMEntity myentity the subject entity from were mydata was extracted
     * @param Json[string] data The actual data that needs to be saved
     */
    protected IORMEntity _update(IORMEntity myentity, Json[string] data) {
        myprimaryColumns = (array)this.primaryKeys();
        primaryKey = myentity.extract(myprimaryColumns);

        mydata = array_diffinternalKey(mydata, primaryKey);
        if (isEmpty(mydata)) {
            return myentity;
        }
        if (count(myprimaryColumns) == 0) {
            myentityClass = myentity.classname;
            mytable = getTable();
            mymessage = "Cannot update `myentityClass`. The `mytable` has no primary key.";
            throw new DInvalidArgumentException(mymessage);
        }
        if (!myentity.has(myprimaryColumns)) {
            mymessage = "All primary key value(s) are needed for updating, ";
            mymessage ~= myentity.classname ~ " is missing " ~ myprimaryColumns.join(", ");
            throw new DInvalidArgumentException(mymessage);
        }
        mystatement = this.updateQuery()
            .set(mydata)
            .where(primaryKey)
            .execute();

        return mystatement.errorCode() == "00000" ? myentity : false;
    }
    
    /**
     * Persists multiple entities of a table.
     *
     * The records will be saved in a transaction which will be rolled back if
     * any one of the records fails to save due to failed validation or database
     * error.
     */
    IORMEntity[] saveMany(
        IORMEntity[] entities,
        Json[string] options = null
   ) {
        try {
            return _saveMany(entities, options);
        } catch (PersistenceFailedException myexception) {
            return false;
        }
    }
    
    /**
     * Persists multiple entities of a table.
     *
     * The records will be saved in a transaction which will be rolled back if
     * any one of the records fails to save due to failed validation or database
     * error.
     * Params:
     * iterable<\UIM\Datasource\IORMEntity> entities Entities to save.
     * @param Json[string] options Options used when calling Table.save() for each entity.
     */
    iterable<\UIM\Datasource\IORMEntity> saveManyOrFail(Json[string] entities, Json[string] options = null) {
        return _saveMany(entities, options);
    }
    
    /**
     * @param iterable<\UIM\Datasource\IORMEntity> entities Entities to save.
     * @param Json[string] options Options used when calling Table.save() for each entity.
     */
    protected IORMEntity[] _saveMany(
        range entities,
        Json[string] options = null
   ): range {
        options = new Json[string](
            options ~ [
                "atomic": true.toJson,
                "checkRules": true.toJson,
                "_primary": true.toJson,
            ]
       );
        options["_cleanOnSuccess"] = false;

        bool[] myisNew;
        mycleanupOnFailure = void (entities) use (&myisNew) {
            foreach (key: myentity; entities) {
                if (isSet(myisNew[key]) && myisNew[key]) {
                    myentity.remove(this.primaryKeys());
                    myentity.setNew(true);
                }
            }
        };

        myfailed = null;
        try {
            getConnection()
                .transactional(function () use (entities, options, &myisNew, &myfailed) {
                    // Cache array cast since options are the same for each entity
                    options = (array)options;
                    foreach (key: myentity; entities) {
                        myisNew[key] = myentity.isNew();
                        if (this.save(myentity, options) == false) {
                            myfailed = myentity;

                            return false;
                        }
                    }
                });
        } catch (Exception exception) {
            mycleanupOnFailure(entities);

            throw exception;
        }
        if (myfailed !is null) {
            mycleanupOnFailure(entities);

            throw new DPersistenceFailedException(myfailed, ["saveMany"]);
        }
        mycleanupOnSuccess = void (IORMEntity myentity) use (&mycleanupOnSuccess) {
            myentity.clean();
            myentity.setNew(false);

            foreach (myentity.toJString().keys as fieldName) {
                myvalue = myentity.get(fieldName);

                if (cast(IORMEntity)myvalue) {
                    mycleanupOnSuccess(myvalue);
                } else if (isArray(myvalue) && cast(IORMEntity)currentValue(myvalue)) {
                    myvalue.each!(associated => mycleanupOnSuccess(associated));
                }
            }
        };

        if (_transactionCommitted(options["atomic"], options["_primary"])) {
            foreach (entities as myentity) {
                dispatchEvent("Model.afterSaveCommit", compact("entity", "options"));
                if (options["atomic"] || options["_primary"]) {
                    mycleanupOnSuccess(myentity);
                }
            }
        }
        return entities;
    }
    
    /**

     * For HasMany and HasOne associations records will be removed based on
     * the dependent option. Join table records in BelongsToMany associations
     * will always be removed. You can use the `cascadeCallbacks` option
     * when defining associations to change how associated data is deleted.
     *
     * ### Options
     *
     * - `atomic` Defaults to true. When true the deletion happens within a transaction.
     * - `checkRules` Defaults to true. Check deletion rules before deleting the record.
     *
     * ### Events
     *
     * - `Model.beforeDelete` Fired before the delete occurs. If stopped the delete
     * will be aborted. Receives the event, entity, and options.
     * - `Model.afterDelete` Fired after the delete has been successful. Receives
     * the event, entity, and options.
     * - `Model.afterDeleteCommit` Fired after the transaction is committed for
     * an atomic delete. Receives the event, entity, and options.
     *
     * The options argument will be converted into an \Json[string] instance
     * for the duration of the callbacks, this allows listeners to modify
     * the options used in the delete operation.
     * Params:
     * \UIM\Datasource\IORMEntity myentity The entity to remove.
     * @param Json[string] options The options for the delete.
         */
    bool remove(IORMEntity myentity, Json[string] options = null) {
        options = new Json[string](options ~ [
            "atomic": true.toJson,
            "checkRules": true.toJson,
            "_primary": true.toJson,
        ]);

        mysuccess = _executeTransaction(
            fn (): _processremove(myentity, options),
            options["atomic"]
       );

        if (mysuccess && _transactionCommitted(options["atomic"], options["_primary"])) {
            dispatchEvent("Model.afterDeleteCommit", [
                "entity": myentity,
                "options": options,
            ]);
        }
        return mysuccess;
    }
    
    /**
     * Deletes multiple entities of a table.
     *
     * The records will be deleted in a transaction which will be rolled back if
     * any one of the records fails to delete due to failed validation or database
     * error.
     * Params:
     * iterable<\UIM\Datasource\IORMEntity> entities Entities to delete.
     */
    IORMEntity[] deleteMany(Json[string] entities, Json[string] options = null) {
        auto myfailed = _deleteMany(entities, options);
        return myfailed !is null
            ? false
            : entities;
    }
    
    /**
     * Deletes multiple entities of a table.
     *
     * The records will be deleted in a transaction which will be rolled back if
     * any one of the records fails to delete due to failed validation or database
     * error.
     * Params:
     * iterable<\UIM\Datasource\IORMEntity> entities Entities to delete.
     * @param Json[string] options Options used when calling Table.save() for each entity.
     */
    iterable<\UIM\Datasource\IORMEntity> deleteManyOrFail(Json[string] entities, Json[string] options = null) {
        auto myfailed = _deleteMany(entities, options);

        if (myfailed !is null) {
            throw new DPersistenceFailedException(myfailed, ["deleteMany"]);
        }
        return entities;
    }
    
    protected IORMEntity _deleteMany(Json[string] entities, Json[string] options = null) {
        options = new Json[string](options ~ [
                "atomic": true.toJson,
                "checkRules": true.toJson,
                "_primary": true.toJson,
            ]);

        myfailed = _executeTransaction(function () use (entities, options) {
            foreach (entities as myentity) {
                if (!_processremove(myentity, options)) {
                    return myentity;
                }
            }
            return null;
        }, options["atomic"]);

        if (myfailed.isNull && _transactionCommitted(options["atomic"], options["_primary"])) {
            entities.each!(entity => 
                dispatchEvent("Model.afterDeleteCommit", [
                    "entity": entity.toJson,
                    "options": options.toJson,
                ]));
        }
        return myfailed;
    }
    
    /**
     * Try to delete an entity or throw a PersistenceFailedException if the entity is new,
     * has no primary key value, application rules checks failed or the delete was aborted by a callback.
     * Params:
     * \UIM\Datasource\IORMEntity myentity The entity to remove.
     */
    bool deleteOrFail(IORMEntity entityToRemove, Json[string] options = null) {
        auto mydeleted = remove(entityToRemove, options);
        if (!mydeleted) {
            throw new DPersistenceFailedException(entityToRemove, ["delete"]);
        }
        return mydeleted;
    }
    
    /**
     * Perform the delete operation.
     *
     * Will delete the entity provided. Will remove rows from any
     * dependent associations, and clear out join tables for BelongsToMany associations.
     * Params:
     * \UIM\Datasource\IORMEntity myentity The entity to delete.
     * @param \Json[string]<string, mixed> options The options for the delete.
     * passed entity
     */
    protected bool _processremove(IORMEntity myentity, Json[string] options) {
        if (myentity.isNew()) {
            return false;
        }
        
        auto primaryKey = (array)this.primaryKeys();
        if (!myentity.has(primaryKey)) {
            mymsg = "Deleting requires all primary key values.";
            throw new DInvalidArgumentException(mymsg);
        }
        if (options["checkRules"] && !this.checkRules(myentity, RulesChecker.DELETE, options)) {
            return false;
        }
        myevent = dispatchEvent("Model.beforeDelete", [
            "entity": myentity.toJson,
            "options": options.toJson,
        ]);

        if (myevent.isStopped()) {
            return (bool)myevent.getResult();
        }
        mysuccess = _associations.cascadeRemove(
            myentity,
            ["_primary": false.toJson + options.getArrayCopy()}
       );
        if (!mysuccess) {
            return mysuccess;
        }
        mystatement = this.deleteQuery()
            .where(myentity.extract(primaryKey))
            .execute();

        if (mystatement.rowCount() < 1) {
            return false;
        }
        dispatchEvent("Model.afterDelete", [
            "entity": myentity.toJson,
            "options": options,
        ]);

        return true;
    }
    
    /**
     * Returns true if the finder exists for the table
     * Params:
     * string mytype name of finder to check
     */
   bool hasFinder(string finderType) {
        auto finderName = "find" ~ finderType;
        return method_exists(this, finderName) || _behaviors.hasFinder(finderType);
    }
    
    // Calls a finder method and applies it to the passed query.
    SelectQuery<TSubject> callFinder(string finderType, DSelectQuery myquery, Json arguments) {
        string myfinder = "find" ~ finderType;
        if (method_exists(this, myfinder)) {
            return _invokeFinder(this.{myfinder}(...), myquery, arguments);
        }
        if (_behaviors.hasFinder(finderType)) {
            return _behaviors.callFinder(finderType, myquery, arguments);
        }
        throw new BadMethodCallException(
            "Unknown finder method `%s` on `%s`.".format(
            finderType,
            class
       ));
    }
    
    /**
     * @internal
     * @template TSubject of \UIM\Datasource\IORMEntity|array
     * @param \Closure mycallable Callable.
     * @param \ORM\Query\SelectQuery<TSubject> myquery The query object.
     * @param Json[string] arguments Arguments for the callable.
     */
    SelectQuery<TSubject> invokeFinder(Closure mycallable, SelectQuery myquery, Json[string] arguments) {
        auto myreflected = new DReflectionFunction(mycallable);
        auto params = myreflected.getParameters();
        auto mysecondParam = params[1] ?? null;
        auto mysecondParamType = null;

        if (arguments is null || isSet(arguments[0])) {
            mysecondParamType = mysecondParam?.getType();
            mysecondParamTypeName = cast(ReflectionNamedType)mysecondParamType ? mysecondParamType.name: null;
            // Backwards compatibility of 4.x style finders with signature `findFoo(SelectQuery myquery, Json[string] options = null)`
            // called as `find("foo")` or `find("foo", [..])`
            if (
                count(params) == 2 &&
                mysecondParam?.name == "options" &&
                !mysecondParam.isVariadic() &&
                (mysecondParamType.isNull || mysecondParamTypeName == "array")
           ) {
                if (isSet(arguments[0])) {
                    deprecationWarning(
                        "5.0.0",
                        "Using options array for the `find()` call is deprecated."
                        ~ " Use named arguments instead."
                   );

                    arguments = arguments[0];
                }
                myquery.applyOptions(arguments);

                return mycallable(myquery, myquery.getOptions());
            }
            // Backwards compatibility for core finders like `findList()` called in 4.x style
            // with an array `find("list", ["valueField": "foo"])` instead of `find("list", valueField: "foo")`
            if (isSet(arguments[0]) && isArray(arguments[0]) && mysecondParamTypeName != "array") {
                deprecationWarning(
                    "5.0.0",
                    "Calling `{myreflected.name}` finder with options array is deprecated."
                     ~ " Use named arguments instead."
               );

                arguments = arguments[0];
            }
        }
        if (arguments) {
            myquery.applyOptions(arguments);
            // Fetch custom args without the query options.
            arguments = myquery.getOptions();

            remove(params[0]);
            mylastParam = end(params);
            reset(params);

            if (mylastParam == false || !mylastParam.isVariadic()) {
                string[] myparamNames = params.map!(param => myparam.name).array;
                arguments.byKeyValue
                    .filter(kv => isString(kv.key) && !myparamNames.has(kv.key))
                    .each!(kv => remove(arguments[kv.key]));
            }
        }
        return mycallable(myquery, ...arguments);
    }
    
    /**
     * Provides the dynamic findBy and findAllBy methods.
     * Params:
     * string mymethod The method name that was fired.
     * @param Json[string] arguments List of arguments passed to the function.
     */
    protected ISelectQuery _dynamicFinder(string mymethod, Json[string] arguments) {
        mymethod = Inflector.underscore(mymethod);
        preg_match("/^find_([\w]+)_by_/", mymethod, mymatches);
        if (isEmpty(mymatches)) {
            // find_by_is 8 characters.
            fieldNames = subString(mymethod, 8);
            myfindType = "all";
        } else {
            fieldNames = subString(mymethod, mymatches[0].length);
            myfindType = Inflector.variable(mymatches[1]);
        }
        myhasOr = fieldNames.contains("_or_");
        myhasAnd = fieldNames.contains("_and_");

        mymakeConditions = auto (fieldNames, arguments) {
            myconditions = null;
            if (count(arguments) < count(fieldNames)) {
                throw new BadMethodCallException(format(
                    "Not enough arguments for magic finder. Got %s required %s",
                    count(arguments),
                    count(fieldNames)
               ));
            }
            fieldNames.each!(field => myconditions[this.aliasField(field)] = array_shift(arguments));
            return myconditions;
        };

        if (myhasOr == true && myhasAnd == true) {
            throw new BadMethodCallException(
                "Cannot mix "and" & "or" in a magic finder. Use find() instead."
           );
        }
        if (myhasOr == false && myhasAnd == false) {
            myconditions = mymakeConditions([fieldNames], arguments);
        } else if (myhasOr == true) {
            string[] fieldNames = fieldNames.split("_or_");
            myconditions = [
                "OR": mymakeConditions(fieldNames, arguments),
            ];
        } else {
            string[] fieldNames = fieldNames.split("_and_");
            myconditions = mymakeConditions(fieldNames, arguments);
        }
        return _find(myfindType, conditions: myconditions);
    }
    
    /**
     * Handles behavior delegation + dynamic finders.
     *
     * If your Table uses any behaviors you can call them as if
     * they were on the table object.
     * Params:
     * @param Json[string] arguments List of arguments passed to the function
     */
    Json __call(string methodToInvoke, Json[string] arguments) {
        if (_behaviors.hasMethod(methodToInvoke)) {
            return _behaviors.call(methodToInvoke, arguments);
        }
        if (preg_match("/^find(?:\w+)?By/", methodToInvoke) > 0) {
            return _dynamicFinder(methodToInvoke, arguments);
        }
        throw new BadMethodCallException(
            "Unknown method `%s` called on `%s`".format(methodToInvoke, class)
       );
    }
    
    /**
     * Returns the association named after the passed value if exists, otherwise
     * throws an exception.
     */
    DAssociation __get(string associationName) {
        auto myassociation = _associations.get(associationName);
        if (!myassociation) {
            throw new DatabaseException(
                "Undefined property `%s`. " .
                "You have not defined the `%s` association on `%s`."
                .format(associationName, associationName, class));
        }
        return myassociation;
    }
    
    /**
     * Returns whether an association named after the passed value
     * exists for this table.
     * Params:
     * string myproperty the association name
     */
   bool __isSet(string associationName) {
        return _associations.has(associationName);
    }
    
    /**
     * Get the object used to marshal/convert array data into objects.
     *
     * Override this method if you want a table object to use custom
     * marshalling logic.
     */
    DMarshaller marshaller() {
        return new DMarshaller(this);
    }
    
    IORMEntity newEmptyEntity() {
        myclass = getEntityClass();

        return new myclass([], ["source": this.registryKey()]);
    }
    
    /**

     * By default all the associations on this table will be hydrated. You can
     * limit which associations are built, or include deeper associations
     * using the options parameter:
     *
     * ```
     * myarticle = this.Articles.newEntity(
     * this.request[),
     * ["associated": ["Tags", "Comments.Users"]]
     *);
     * ```
     *
     * You can limit fields that will be present in the constructed entity by
     * passing the `fields` option, which is also accepted for associations:
     *
     * ```
     * myarticle = this.Articles.newEntity(this.request[), [
     * "fields": ["title", "body", "tags", "comments"],
     * "associated": ["Tags", "Comments.Users": ["fields": "username"]]
     * ]
     *);
     * ```
     *
     * The `fields` option lets remove or restrict input data from ending up in
     * the entity. If you"d like to relax the entity"s default accessible fields,
     * you can use the `accessibleFields` option:
     *
     * ```
     * myarticle = this.Articles.newEntity(
     * this.request[),
     * ["accessibleFields": ["protected_field": true.toJson]]
     *);
     * ```
     *
     * By default, the data is validated before being passed to the new DORMEntity. In
     * the case of invalid fields, those will not be present in the resulting object.
     * The `validate` option can be used to disable validation on the passed data:
     *
     * ```
     * myarticle = this.Articles.newEntity(
     * this.request[),
     * ["validate": false.toJson]
     *);
     * ```
     *
     * You can also pass the name of the validator to use in the `validate` option.
     * If `null` is passed to the first param of this function, no validation will
     * be performed.
     *
     * You can use the `Model.beforeMarshal` event to modify request data
     * before it is converted into entities.
     */
    IORMEntity newEntity(Json[string] data, Json[string] options = null) {
        options.set("associated", options.ifNull("associated", _associations.keys()));
        return _marshaller().one(data, options);
    }
    
    /**

     * By default all the associations on this table will be hydrated. You can
     * limit which associations are built, or include deeper associations
     * using the options parameter:
     *
     * ```
     * myarticles = this.Articles.newEntities(
     * this.request[),
     * ["associated": ["Tags", "Comments.Users"]]
     *);
     * ```
     *
     * You can limit fields that will be present in the constructed entities by
     * passing the `fields` option, which is also accepted for associations:
     *
     * ```
     * myarticles = this.Articles.newEntities(this.request[), [
     * "fields": ["title", "body", "tags", "comments"],
     * "associated": ["Tags", "Comments.Users": ["fields": "username"]]
     * ]
     *);
     * ```
     *
     * You can use the `Model.beforeMarshal` event to modify request data
     * before it is converted into entities.
     * Params:
     * Json[string] data The data to build an entity with.
     * @param Json[string] options A list of options for the objects hydration.
     */
    IORMEntity[] newEntities(Json[string] data, Json[string] options = null) {
        options["associated"] ??= _associations.keys();

        return _marshaller().many(mydata, options);
    }
    
    /**

     * When merging HasMany or BelongsToMany associations, all the entities in the
     * `mydata` array will appear, those that can be matched by primary key will get
     * the data merged, but those that cannot, will be discarded.
     *
     * You can limit fields that will be present in the merged entity by
     * passing the `fields` option, which is also accepted for associations:
     *
     * ```
     * myarticle = this.Articles.patchEntity(myarticle, this.request[), [
     * "fields": ["title", "body", "tags", "comments"],
     * "associated": ["Tags", "Comments.Users": ["fields": "username"]]
     * ]
     *);
     * ```
     *
     * ```
     * myarticle = this.Articles.patchEntity(myarticle, this.request[), [
     * "associated": [
     *   "Tags": ["accessibleFields": ["*": true.toJson]]
     * ]
     * ]);
     * ```
     *
     * By default, the data is validated before being passed to the entity. In
     * the case of invalid fields, those will not be assigned to the entity.
     * The `validate` option can be used to disable validation on the passed data:
     *
     * ```
     * myarticle = this.patchEntity(myarticle, this.request[),[
     * "validate": false.toJson
     * ]);
     * ```
     *
     * You can use the `Model.beforeMarshal` event to modify request data
     * before it is converted into entities.
     *
     * When patching scalar values (null/booleans/string/integer/float), if the property
     * presently has an identical value, the setter will not be called, and the
     * property will not be marked as dirty. This is an optimization to prevent unnecessary field
     * updates when persisting entities.
     */
    IORMEntity patchEntity(IORMEntity entity, Json[string] dataToMerge, Json[string] options = null) {
        options["associated"] ??= _associations.keys();
        return _marshaller().merge(entity, dataToMerge, options);
    }
    
    /**

     * Those entries in `entities` that cannot be matched to any record in
     * `mydata` will be discarded. Records in `mydata` that could not be matched will
     * be marshalled as a new DORMEntity.
     *
     * When merging HasMany or BelongsToMany associations, all the entities in the
     * `mydata` array will appear, those that can be matched by primary key will get
     * the data merged, but those that cannot, will be discarded.
     *
     * You can limit fields that will be present in the merged entities by
     * passing the `fields` option, which is also accepted for associations:
     *
     * ```
     * myarticles = this.Articles.patchEntities(myarticles, this.request[), [
     * "fields": ["title", "body", "tags", "comments"],
     * "associated": ["Tags", "Comments.Users": ["fields": "username"]]
     * ]
     *);
     * ```
     *
     * You can use the `Model.beforeMarshal` event to modify request data
     * before it is converted into entities.
     * Params:
     * iterable<\UIM\Datasource\IORMEntity> entities the entities that will get the
     * data merged in
     */
    IORMEntity[] patchEntities(Json[string] entities, Json[string] data, Json[string] options = null) {
        options.set("associated", options.ifNull("associated", _associations.keys()));
        return _marshaller().mergeMany(entities, data, options);
    }
    
    /**
     * Validator method used to check the uniqueness of a value for a column.
     * This is meant to be used with the validation API and not to be called
     * directly.
     *
     * ### Example:
     *
     * ```
     * myvalidator.add("email", [
     * "unique": ["rule": "validateUnique", "provider": "table"]
     * ])
     * ```
     *
     * Unique validation can be scoped to the value of another column:
     *
     * ```
     * myvalidator.add("email", [
     * "unique": [
     *    "rule": ["validateUnique", ["scope": "site_id"]],
     *    "provider": "table"
     * ]
     * ]);
     * ```
     *
     * In the above example, the email uniqueness will be scoped to only rows having
     * the same site_id. Scoping will only be used if the scoping field is present in
     * the data to be validated.
     * Json aValue The value of column to be checked for uniqueness.
     */
    bool validateUnique(Json columnValue, Json[string] options, Json[string] context = null) {
        if (context.isNull) {
            context = options;
        }
        auto myentity = new DORMEntity(
            context["data"],
            [
                "useSetters": false.toJson,
                "markNew": context["newRecord"],
                "source": this.registryKey(),
            ]
       );
        fieldNames = array_merge(
            [context["field"]],
            options.hasKey("scope") ? options.getArray("scope") : []
       );

        auto values = myentity.extract(fieldNames);
        foreach (fieldName; values) {
            if (fieldName !is null && !isScalar(fieldName)) {
                return false;
            }
        }
        myclass = IS_UNIQUE_CLASS;

        IsUnique myrule = new myclass(fieldNames, options);
        return myrule(myentity, ["repository": this]);
    }
    
    /**
     * Get the Model callbacks this table is interested in.
     *
     * By implementing the conventional methods a table class is assumed
     * to be interested in the related event.
     *
     * Override this method if you need to add non-conventional event listeners.
     * Or if you want you table to listen to non-standard events.
     *
     * The conventional method map is:
     *
     * - Model.beforeMarshal: beforeMarshal
     * - Model.afterMarshal: afterMarshal
     * - Model.buildValidator: buildValidator
     * - Model.beforeFind: beforeFind
     * - Model.beforeSave: beforeSave
     * - Model.afterSave: afterSave
     * - Model.afterSaveCommit: afterSaveCommit
     * - Model.beforeDelete: beforeDelete
     * - Model.afterDelete: afterDelete
     * - Model.afterDeleteCommit: afterDeleteCommit
     * - Model.beforeRules: beforeRules
     * - Model.afterRules: afterRules
     *
     */
    IEvent[] implementedEvents() {
        auto myeventMap = [
            "Model.beforeMarshal": "beforeMarshal",
            "Model.afterMarshal": "afterMarshal",
            "Model.buildValidator": "buildValidator",
            "Model.beforeFind": "beforeFind",
            "Model.beforeSave": "beforeSave",
            "Model.afterSave": "afterSave",
            "Model.afterSaveCommit": "afterSaveCommit",
            "Model.beforeDelete": "beforeDelete",
            "Model.afterDelete": "afterDelete",
            "Model.afterDeleteCommit": "afterDeleteCommit",
            "Model.beforeRules": "beforeRules",
            "Model.afterRules": "afterRules",
        ];
        myevents = null;

        foreach (myeventMap as myevent: mymethod) {
            if (!method_exists(this, mymethod)) {
                continue;
            }
            myevents[myevent] = mymethod;
        }
        return myevents;
    }
    
    /**
 Params:
     * \ORM\RulesChecker myrules The rules object to be modified.
     */
    RulesChecker buildRules(RulesChecker myrules) {
        return myrules;
    }
    
    /**
     * Loads the specified associations in the passed entity or list of entities
     * by executing extra queries in the database and merging the results in the
     * appropriate properties.
     *
     * ### Example:
     *
     * ```
     * myuser = myusersTable.get(1);
     * myuser = myusersTable.loadInto(myuser, ["Articles.Tags", "Articles.Comments"]);
     * writeln(myuser.articles[0].title;
     * ```
     *
     * You can also load associations for multiple entities at once
     *
     * ### Example:
     *
     * ```
     * myusers = myusersTable.find().where([...]).toList();
     * myusers = myusersTable.loadInto(myusers, ["Articles.Tags", "Articles.Comments"]);
     * writeln(myuser[1].articles[0].title;
     * ```
     *
     * The properties for the associations to be loaded will be overwritten on each entity.
     * Params:
     * \UIM\Datasource\IORMEntity|array<\UIM\Datasource\IORMEntity> entities a single entity or list of entities
     * @param Json[string] mycontain A `contain()` compatible array.
     */
    IORMEntity[] loadInto(IORMEntity|array entities, Json[string] mycontain) {
        return (new DLazyEagerLoader()).loadInto(entities, mycontain, this);
    }
 
    protected bool validationMethodExists(string methodName) {
        return method_exists(this, methodName) || this.behaviors().hasMethod(methodName);
    }
    
    /**
     * Returns an array that can be used to describe the internal state of this object.
     */
    Json[string] debugInfo() {
        myconn = getConnection();

        return [
            "registryAlias": this.registryKey(),
            "table": getTable(),
            "alias": aliasName(),
            "entityClass": getEntityClass(),
            "associations": _associations.keys(),
            "behaviors": _behaviors.loaded(),
            "defaultConnection": defaultConnectionName(),
            "connectionName": myconn.configName(),
        ];
    }
}
