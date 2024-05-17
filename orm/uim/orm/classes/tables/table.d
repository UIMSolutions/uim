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
 *  supplying a return value you can bypass the find operation entirely. Any
 *  changes done to the myquery instance will be retained for the rest of the find. The
 *  `myprimary` parameter indicates whether this is the root query, or an
 *  associated query.
 *
 * - `Model.buildValidator` Allows listeners to modify validation rules
 *  for the provided named validator.
 *
 * - `Model.buildRules` Allows listeners to modify the rules checker by adding more rules.
 *
 * - `Model.beforeRules` Fired before an entity is validated using the rules checker.
 *  By stopping this event, you can return the final value of the rules checking operation.
 *
 * - `Model.afterRules` Fired after the rules have been checked on the entity. By
 *  stopping this event, you can return the final value of the rules checking operation.
 *
 * - `Model.beforeSave` Fired before each entity is saved. Stopping this event will
 *  abort the save operation. When the event is stopped the result of the event will be returned.
 *
 * - `Model.afterSave` Fired after an entity is saved.
 *
 * - `Model.afterSaveCommit` Fired after the transaction in which the save operation is
 *  wrapped has been committed. It’s also triggered for non atomic saves where database
 *  operations are implicitly committed. The event is triggered only for the primary
 *  table on which save() is directly called. The event is not triggered if a
 *  transaction is started before calling save.
 *
 * - `Model.beforeDelete` Fired before an entity is deleted. By stopping this
 *  event you will abort the delete operation.
 *
 * - `Model.afterDelete` Fired after an entity has been deleted.
 *
 * ### Callbacks
 *
 * You can subscribe to the events listed above in your table classes by implementing the
 * lifecycle methods below:
 *
 * - `beforeFind(IEvent myevent, SelectQuery myquery, ArrayObject options, boolean myprimary)`
 * - `beforeMarshal(IEvent myevent, ArrayObject mydata, ArrayObject options)`
 * - `afterMarshal(IEvent myevent, IORMEntity myentity, ArrayObject options)`
 * - `buildValidator(IEvent myevent, Validator myvalidator, string myname)`
 * - `buildRules(RulesChecker myrules)`
 * - `beforeRules(IEvent myevent, IORMEntity myentity, ArrayObject options, string myoperation)`
 * - `afterRules(IEvent myevent, IORMEntity myentity, ArrayObject options, bool result, string myoperation)`
 * - `beforeSave(IEvent myevent, IORMEntity myentity, ArrayObject options)`
 * - `afterSave(IEvent myevent, IORMEntity myentity, ArrayObject options)`
 * - `afterSaveCommit(IEvent myevent, IORMEntity myentity, ArrayObject options)`
 * - `beforeremove(IEvent myevent, IORMEntity myentity, ArrayObject options)`
 * - `afterremove(IEvent myevent, IORMEntity myentity, ArrayObject options)`
 * - `afterDeleteCommit(IEvent myevent, IORMEntity myentity, ArrayObject options)`
 */
class DTable { //* }: IRepository, IEventListener, IEventDispatcher, IValidatorAware {
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
        *  represent rows in this table.
        * - eventManager: An instance of an event manager to use for internal events
        * - behaviors: A BehaviorRegistry. Generally not used outside of tests.
        * - associations: An AssociationCollection instance.
        * - validator: A Validator instance which is assigned as the "default"
        *  validation set, or an associative array, where key is the name of the
        *  validation set and value the Validator instance. */

        if (!configuration.isEmpty("registryAlias"))) {
            this.registryKey(configuration.data("registryAlias"));
        }

        // table: Name of the database table to represent
        if (!igData.isEmpty("table"))) {
            setTable(configuration.data("table"));
        }
        if (!configuration.isEmpty("alias"))) {
            aliasName(configuration.data("alias"));
        }
        if (!configuration.isEmpty("connection"))) {
            setConnection(configuration.data("connection"));
        }
        if (!configuration.isEmpty("queryFactory"))) {
            this.queryFactory = configuration.data("queryFactory");
        }

        // schema: A \UIM\Database\Schema\TableISchema object or an array that can be passed to it.
        if (!configuration.isEmpty("schema"))) {
            setSchema(configuration.data("schema"));
        }
        if (!configuration.isEmpty("entityClass")) {
            setEntityClass(configuration.data("entityClass"));
        }
        myeventManager = mybehaviors = myassociations = null;
        if (!configuration.isEmpty("eventManager")) {
            myeventManager = configuration.data("eventManager");
        }
        if (!configuration.isEmpty("behaviors")) {
            mybehaviors = configuration.data("behaviors");
        }
        if (!configuration.isEmpty("associations")) {
            myassociations = configuration.data("associations");
        }
        if (!configuration.isEmpty("validator")) {
            if (!isArray(configuration.data("validator"))) {
                setValidator(DEFAULT_VALIDATOR, configuration.data("validator"));
            } else {
                configuration.data("validator").byKeyValue
                    .each!(nameValidator => setValidator(nameValidator.key, nameValidator
                            .value));
            }
        }
        _eventManager = myeventManager ?  : new DEventManager();
        _behaviors = mybehaviors ?  : new BehaviorRegistry();
        _behaviors.setTable(this);
        _associations = myassociations ?  : new AssociationCollection();
        /** @psalm-suppress TypeDoesNotContainType */
        this.queryFactory ??= new DQueryFactory();

        assert(_eventManager !isNull, "EventManager not available");

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
    protected string[] _primaryKey = null;

    // The name of the field that represents a human-readable representation of a row
    protected string[] _displayField = null;

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
     *     this.belongsTo("Users");
     *     this.belongsToMany("Tagging.Tags");
     *     setPrimaryKey("something_else");
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
            mytable = substr(to!string(end(mytable)), 0, -5) ?: _aliasName;
            if (!mytable) {
                throw new UimException(
                    "You must specify either the `alias` or the `table` option for the constructor."
                );
            }
           _table = Inflector.underscore(mytable);
        }
        return _table;
    }
    
    /**
     * Sets the table alias.
     * Params:
     * string aliasName Table alias
     */
    void aliasName(string tableAlias) {
       _aliasName = tableAlias;
    }
    
    // Returns the table alias.
    string aliasName() {
        if (_aliasName.isNull) {
            aliasName = namespaceSplit(class);
            aliasName = substr(to!string(end(aliasName), 0, -5)) ?: _table;
            if (!aliasName) {
                throw new UimException(
                    "You must specify either the `alias` or the `table` option for the constructor."
                );
            }
           _aliasName = aliasName;
        }
        return _aliasName;
    }
    
    /**
     * Alias a field with the table"s current alias.
     *
     * If field is already aliased it will result in no-op.
     * Params:
     * string fieldName The field to alias.
     */
    string aliasField(string fieldName) {
        if (fieldName.has(".")) {
            return fieldName;
        }
        return _aliasNameName() ~ "." ~ fieldName;
    }
    
    /**
     * Sets the table registry key used to create this table instance.
     * Params:
     * string myregistryAlias The key used to access this object.
     */
    void registryKey(string myregistryAlias) {
       _registryAlias = myregistryAlias;
    }
    
    // Returns the table registry key used to create this table instance.
    string registryKey() {
        return _registryAlias ??= aliasName();
    }
    
    /**
     * Sets the connection instance.
     * Params:
     * \UIM\Database\Connection myconnection The connection instance
     */
    auto setConnection(Connection myconnection) {
       _connection = myconnection;

        return this;
    }
    
    /**
     * Returns the connection instance.
     */
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
            if (configuration.get("debug")) {
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
    auto setSchema(TableISchema|array myschema) {
        if (isArray(myschema)) {
            auto constraints = null;

            if (myschema.isSet("_constraints")) {
                constraints = myschema["_constraints"];
                unset(myschema["_constraints"]);
            }
            myschema = getConnection().getDriver().newTableSchema(getTable(), myschema);

            foreach (constraints as myname: myvalue) {
                myschema.addConstraint(myname, myvalue);
            }
        }
       _schema = myschema;
        if (configuration.get("debug")) {
            this.checkAliasLengths();
        }
        return this;
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
                .format(tableName, name, nameLength);
            );
        };
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
        return _getSchema().getColumn(fieldName) !isNull;
    }
    
    /**
     * Sets the primary key field name.
     * Params:
     * string[]|string aKey Sets a new name to be used as primary key
     */
    auto setPrimaryKey(string[]|string aKey) {
       _primaryKey = aKey;

        return this;
    }
    
    // Returns the primary key field name.
    string[]|string primaryKeys() {
        if (_primaryKey.isNull) {
            aKey = getSchema().primaryKeys();
            if (count(aKey) == 1) {
                aKey = aKey[0];
            }
           _primaryKey = aKey;
        }
        return _primaryKey;
    }
    
    /**
     * Sets the display field.
     * Params:
     * string[]|string fieldName Name to be used as display field.
     */
    auto setDisplayField(string[]|string fieldName) {
       _displayField = fieldName;

        return this;
    }
    
    /**
     * Returns the display field.
     */
    string[] getDisplayField() {
        if (_displayField !isNull) {
            return _displayField;
        }
        myschema = getSchema();
        foreach (["title", "name", "label"] as fieldName) {
            if (myschema.hasColumn(fieldName)) {
                return _displayField = fieldName;
            }
        }
        myschema.columns().each!((mycolumn) {
            auto columnSchema = myschema.getColumn(column);
            if (
                columnSchema &&
                columnSchema["null"] != true &&
                columnSchema["type"] == "string" &&
                !preg_match("/pass|token|secret/i", column)
            ) {
                return _displayField = column;
            }
        });
        return _displayField = this.primaryKeys();
    }
    
    /**
     * Returns the class used to hydrate rows for this table.
     */
    string getEntityClass() {
        if (!_entityClass) {
            mydefault = Entity.classname;
            myself = class;
            string[] myparts = myself.split("\\");

            if (myself == self.classname || count(myparts) < 3) {
                return _entityClass = mydefault;
            }
            aliasName = Inflector.classify(Inflector.underscore(substr(array_pop(myparts), 0, -5)));
            myname = join("\\", array_slice(myparts, 0, -1)) ~ "\\Entity\\" ~ aliasName;
            if (!class_exists(myname)) {
                return _entityClass = mydefault;
            }
            /** @var class-string<\UIM\Datasource\IORMEntity>|null myclass */
            myclass = App.className(myname, "Model/Entity");
            if (!myclass) {
                throw new DMissingEntityException([myname]);
            }
           _entityClass = myclass;
        }
        return _entityClass;
    }
    
    /**
     * Sets the class used to hydrate rows for this table.
     * Params:
     * string myname The name of the class to use
     * @throws \ORM\Exception\MissingEntityException when the entity class DCannot be found
     */
    auto setEntityClass(string myname) {
        /** @var class-string<\UIM\Datasource\IORMEntity>|null myclass */
        myclass = App.className(myname, "Model/Entity");
        if (myclass.isNull) {
            throw new DMissingEntityException([myname]);
        }
       _entityClass = myclass;

        return this;
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
     * Params:
     * string myname The name of the behavior. Can be a short class reference.
     * @param Json[string] options The options for the behavior to use.
     * @throws \RuntimeException If a behavior is being reloaded.
     */
    void addBehavior(string behaviorName, Json[string] optionData = null) {
       _behaviors.load(behaviorName, options);
    }
    
    /**
     * Adds an array of behaviors to the table"s behavior collection.
     *
     * Example:
     *
     * ```
     * this.addBehaviors([
     *     "Timestamp",
     *     "Tree": ["level": "level"],
     * ]);
     * ```
     */
    void addBehaviors(Json[string] behaviorsToLoad) {
        foreach (behaviorsToLoad as myname: options) {
            if (isInt(myname)) {
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
    Behavior getBehavior(string myname) {
        if (!_behaviors.has(myname)) {
            throw new DInvalidArgumentException(
                "The `%s` behavior is not defined on `%s`."
                .format(myname, class)
            );
        }

        return _behaviors.get(myname);
    }
    
    /**
     * Check if a behavior with the given alias has been loaded.
     * Params:
     * string myname The behavior alias to check.
     */
    bool hasBehavior(string myname) {
        return _behaviors.has(myname);
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
    DAssociation getAssociation(string myname) {
        myassociation = this.findAssociation(myname);
        if (!myassociation) {
            myassocations = this.associations().keys();

            mymessage = "The `{myname}` association is not defined on `{aliasName()}`.";
            if (myassocations) {
                mymessage ~= "\nValid associations are: " ~ join(", ", myassocations);
            }
            throw new DInvalidArgumentException(mymessage);
        }
        return myassociation;
    }
    
    /**
     * Checks whether a specific association exists on this Table instance.
     *
     * The name argument also supports dot syntax to access deeper associations.
     *
     * ```
     * myhasUsers = this.hasAssociation("Articles.Comments.Users");
     * ```
     * Params:
     * string myname The alias used for the association.
     */
   bool hasAssociation(string myname) {
        return _findAssociation(myname) !isNull;
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
    protected IAssociation findAssociation(string myname) {
        if (!myname.has(".")) {
            return _associations.get(myname);
        }
        result = null;
        [myname, mynext] = array_pad(split(".", myname, 2), 2, null);
        if (myname !isNull) {
            result = _associations.get(myname);
        }
        if (result !isNull && mynext !isNull) {
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
     *  "belongsTo": [
     *    "Users": ["className": "App\Model\Table\UsersTable"]
     *  ],
     *  "hasMany": ["Comments"],
     *  "belongsToMany": ["Tags"]
     * ]);
     * ```
     *
     * Each association type accepts multiple associations where the keys
     * are the aliases, and the values are association config data. If numeric
     * keys are used the values will be treated as association aliases.
     * Params:
     * Json[string] myparams Set of associations to bind (indexed by association type)
     */
    void addAssociations(Json[string] myparams) {
        foreach (myparams as myassocType: mytables) {
            foreach (mytables as myassociated: options) {
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
     * - className: The class name of the target table object
     * - targetTable: An instance of a table object to be used as the target table
     * - foreignKey: The name of the field to use as foreign key, if false none
     *  will be used
     * - conditions: array with a list of conditions to filter the join with
     * - joinType: The type of join to be used (e.g. INNER)
     * - strategy: The loading strategy to use. "join" and "select" are supported.
     * - finder: The finder method to use when loading records from this association.
     *  Defaults to "all". When the strategy is "join", only the fields, containments,
     *  and where conditions will be used from the finder.
     *
     * This method will return the association object that was built.
     * Params:
     * string myassociated the alias for the target table. This is used to
     * uniquely identify the association
     * @param Json[string] options list of options to configure the association definition
     */
    BelongsTo belongsTo(string myassociated, Json[string] optionData = null) {
        auto updatedOptions = options.update["sourceTable": this];

        /** @var \ORM\Association\BelongsTo */
        return _associations.load(BelongsTo.classname, myassociated, options);
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
     * - className: The class name of the target table object
     * - targetTable: An instance of a table object to be used as the target table
     * - foreignKey: The name of the field to use as foreign key, if false none
     *  will be used
     * - dependent: Set to true if you want UIM to cascade deletes to the
     *  associated table when an entity is removed on this table. The delete operation
     *  on the associated table will not cascade further. To get recursive cascades enable
     *  `cascadeCallbacks` as well. Set to false if you don"t want UIM to remove
     *  associated data, or when you are using database constraints.
     * - cascadeCallbacks: Set to true if you want UIM to fire callbacks on
     *  cascaded deletes. If false the ORM will use deleteAll() to remove data.
     *  When true records will be loaded and then deleted.
     * - conditions: array with a list of conditions to filter the join with
     * - joinType: The type of join to be used (e.g. LEFT)
     * - strategy: The loading strategy to use. "join" and "select" are supported.
     * - finder: The finder method to use when loading records from this association.
     *  Defaults to "all". When the strategy is "join", only the fields, containments,
     *  and where conditions will be used from the finder.
     *
     * This method will return the association object that was built.
     * Params:
     * string myassociated the alias for the target table. This is used to
     * uniquely identify the association
     * @param Json[string] options list of options to configure the association definition
     */
    HasOne hasOne(string myassociated, Json[string] optionData = null) {
        auto updatedOptions = options.update["sourceTable": this];

        return _associations.load(HasOne.classname, myassociated, options);
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
     * - className: The class name of the target table object
     * - targetTable: An instance of a table object to be used as the target table
     * - foreignKey: The name of the field to use as foreign key, if false none
     *  will be used
     * - dependent: Set to true if you want UIM to cascade deletes to the
     *  associated table when an entity is removed on this table. The delete operation
     *  on the associated table will not cascade further. To get recursive cascades enable
     *  `cascadeCallbacks` as well. Set to false if you don"t want UIM to remove
     *  associated data, or when you are using database constraints.
     * - cascadeCallbacks: Set to true if you want UIM to fire callbacks on
     *  cascaded deletes. If false the ORM will use deleteAll() to remove data.
     *  When true records will be loaded and then deleted.
     * - conditions: array with a list of conditions to filter the join with
     * - sort: The order in which results for this association should be returned
     * - saveStrategy: Either "append" or "replace". When "append" the current records
     *  are appended to any records in the database. When "replace" associated records
     *  not in the current set will be removed. If the foreign key is a null able column
     *  or if `dependent` is true records will be orphaned.
     * - strategy: The strategy to be used for selecting results Either "select"
     *  or "subquery". If subquery is selected the query used to return results
     *  in the source table will be used as conditions for getting rows in the
     *  target table.
     * - finder: The finder method to use when loading records from this association.
     *  Defaults to "all".
     *
     * This method will return the association object that was built.
     * Params:
     * string myassociated the alias for the target table. This is used to
     * uniquely identify the association
     * @param Json[string] options list of options to configure the association definition
     */
    HasMany hasMany(string myassociated, Json[string] optionData = null) {
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
     * - className: The class name of the target table object.
     * - targetTable: An instance of a table object to be used as the target table.
     * - foreignKey: The name of the field to use as foreign key.
     * - targetForeignKey: The name of the field to use as the target foreign key.
     * - joinTable: The name of the table representing the link between the two
     * - through: If you choose to use an already instantiated link table, set this
     *  key to a configured Table instance containing associations to both the source
     *  and target tables in this association.
     * - dependent: Set to false, if you do not want junction table records removed
     *  when an owning record is removed.
     * - cascadeCallbacks: Set to true if you want UIM to fire callbacks on
     *  cascaded deletes. If false the ORM will use deleteAll() to remove data.
     *  When true join/junction table records will be loaded and then deleted.
     * - conditions: array with a list of conditions to filter the join with.
     * - sort: The order in which results for this association should be returned.
     * - strategy: The strategy to be used for selecting results Either "select"
     *  or "subquery". If subquery is selected the query used to return results
     *  in the source table will be used as conditions for getting rows in the
     *  target table.
     * - saveStrategy: Either "append" or "replace". Indicates the mode to be used
     *  for saving associated entities. The former will only create new links
     *  between both side of the relation and the latter will do a wipe and
     *  replace to create the links between the passed entities when saving.
     * - strategy: The loading strategy to use. "select" and "subquery" are supported.
     * - finder: The finder method to use when loading records from this association.
     *  Defaults to "all".
     *
     * This method will return the association object that was built.
     * Params:
     * string myassociated the alias for the target table. This is used to
     * uniquely identify the association
     * @param Json[string] options list of options to configure the association definition
     */
    BelongsToMany belongsToMany(string myassociated, Json[string] optionData = null) {
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
     *  conditions: ["published": 1],
     *  limit: 10,
     *  contain: ["Users", "Comments"]
     * );
     * ```
     *
     * Using the builder interface:
     *
     * ```
     * myquery = myarticles.find()
     *  .where(["published": 1])
     *  .limit(10)
     *  .contain(["Users", "Comments"]);
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
     *    return myquery;
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
     * @param Json ...myargs Arguments that match up to finder-specific parameters
     */
    SelectQuery find(string mytype = "all", Json ...myargs) {
        return _callFinder(mytype, this.selectQuery(), ...myargs);
    }
    
    /**
     * Returns the query as passed.
     *
     * By default findAll() applies no query clauses, you can override this
     * method in subclasses to modify how `find("all")` works.
     * Params:
     * \ORM\Query\SelectQuery myquery The query to find with
     * @return \ORM\Query\SelectQuery The query builder
     */
    auto findAll(SelectQuery myquery): SelectQuery
    {
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
     * when not specified, it will use the results of calling `primaryKey` and
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
     *     1: "value for id 1",
     *     2: "value for id 2",
     * ]
     * "group_2": [
     *     4: "value for id 4"
     * ]
     * ]
     * ```
     * Params:
     * \ORM\Query\SelectQuery myquery The query to find with
     */
    SelectQuery findList(
        SelectQuery myquery,
        Closure|string[]|string mykeyField = null,
        Closure|string[]|string myvalueField = null,
        Closure|string[]|string mygroupField = null,
        string myvalueSeparator = ";"
    ) {
        mykeyField ??= this.primaryKeys();
        myvalueField ??= getDisplayField();

        if (
            !myquery.clause("select") &&
            !isObject(mykeyField) &&
            !isObject(myvalueField) &&
            !isObject(mygroupField)
        ) {
            fieldNames = chain(
                (array)mykeyField,
                (array)myvalueField,
                (array)mygroupField
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
     * @param \Closure|string[]|string mykeyField The path to the key field.
     * @param \Closure|string[]|string myparentField The path to the parent field.
     * @param string mynestingKey The key to nest children under.
     */
    SelectQuery findThreaded(
        SelectQuery myquery,
        Closure|string[]|string mykeyField = null,
        Closure|string[]|string myparentField = "parent_id",
        string mynestingKey = "children"
    ) {
        mykeyField ??= this.primaryKeys();

        options = _setFieldMatchers(compact("keyField", "parentField"), ["keyField", "parentField"]);

        return myquery.formatResults(fn (ICollection results) =>
            results.nest(options["keyField"], options["parentField"], mynestingKey));
    }
    
    /**
     * Out of an options array, check if the keys described in `someKeys` are arrays
     * and change the values for closures that will concatenate the each of the
     * properties in the value array when passed a row.
     *
     * This is an auxiliary auto used for result formatters that can accept
     * composite keys when comparing values.
     * Params:
     * Json[string] options the original options passed to a finder
     * @param string[] someKeys the keys to check in options to build matchers from
     * the associated value
     */
    protected Json[string] _setFieldMatchers(Json[string] options, Json[string] someKeys) {
        someKeys.each!((field) {
            if (!options[field].isArray) {
                continue;
            }
            if (count(options[field]) == 1) {
                options[field] = current(options[field]);
                continue;
            }
            
            auto fieldNames = options[field];
            auto myglue = in_array(field, ["keyField", "parentField"], true) ? ";" : options["valueSeparator"];
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
     * Json myprimaryKey primary key value to find
     * @param string[]|string myfinder The finder to use. Passing an options array is deprecated.
     * @param \Psr\SimpleCache\ICache|string mycache The cache config to use.
     *  Defaults to `null`, i.e. no caching.
     * @param \Closure|string mycacheKey The cache key to use. If not provided
     *  one will be autogenerated if `mycache` is not null.
     * @param Json ...myargs Arguments that query options or finder specific parameters.
     */
    IORMEntity get(
        Json myprimaryKey,
        string[]|string myfinder = "all",
        ICache|string mycache = null,
        Closure|string mycacheKey = null,
        Json ...myargs
    ) {
        if (myprimaryKey.isNull) {
            throw new DInvalidPrimaryKeyException(
                "Record not found in table `%s` with primary key `[NULL]`."
                .format(getTable()
            ));
        }
        aKey = (array)this.primaryKeys();
        aliasName = aliasName();
        foreach (myindex: mykeyname; aKey) {
            aKey[myindex] = aliasName ~ "." ~ mykeyname;
        }
        if (!isArray(myprimaryKey)) {
            myprimaryKey = [myprimaryKey];
        }
        if (count(aKey) != count(myprimaryKey)) {
            myprimaryKey = myprimaryKey ?: [null];
            myprimaryKey = array_map(function (aKey) {
                return var_export(aKey, true);
            }, myprimaryKey);

            throw new DInvalidPrimaryKeyException(
                "Record not found in table `%s` with primary key `[%s]`."
                .format(getTable(), join(", ", myprimaryKey)
            ));
        }
        myconditions = array_combine(aKey, myprimaryKey);

        if (isArray(myfinder)) {
            deprecationWarning(
                "5.0.0",
                "Calling Table.get() with options array is deprecated."
                    ~ " Use named arguments instead."
            );

            myargs += myfinder;
            myfinder = myargs["finder"] ?? "all";
            if (isSet(myargs["cache"])) {
                mycache = myargs["cache"];
            }
            if (isSet(myargs["key"])) {
                mycacheKey = myargs["key"];
            }
            unset(myargs["key"], myargs["cache"], myargs["finder"]);
        }
        myquery = this.find(myfinder, ...myargs).where(myconditions);

        if (mycache) {
            if (!mycacheKey) {
                mycacheKey = "get-%s-%s-%s"
                    .format(
                        getConnection().configName(),
                        getTable(),
                        Json_encode(myprimaryKey, Json_THROW_ON_ERROR)
                    );
            }
            myquery.cache(mycacheKey, mycache);
        }
        return myquery.firstOrFail();
    }
    
    /**
     * Handles the logic executing of a worker inside a transaction.
     * Params:
     * callable myworker The worker that will run inside the transaction.
     * @param bool myatomic Whether to execute the worker inside a database transaction.
     */
    protected Json _executeTransaction(callable myworker, bool myatomic = true) {
        if (myatomic) {
            return _getConnection().transactional(fn (): myworker());
        }
        return myworker();
    }
    
    /**
     * Checks if the caller would have executed a commit on a transaction.
     * Params:
     * bool myatomic True if an atomic transaction was used.
     * @param bool myprimary True if a primary was used.
     */
    protected bool _transactionCommitted(bool myatomic, bool myprimary) {
        return !getConnection().inTransaction() && (myatomic || myprimary);
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
     *  transaction (default: true)
     * - defaults: Whether to use the search criteria as default values for the new DORMEntity (default: true)
     * Params:
     * \ORM\Query\SelectQuery|callable|array mysearch The criteria to find existing
     *  records by. Note that when you pass a query object you"ll have to use
     *  the 2nd arg of the method to modify the entity data before saving.
     * @param callable|null mycallback A callback that will be invoked for newly
     *  created entities. This callback will be called *before* the entity
     *  is persisted.
     * @param Json[string] options The options to use when saving.
     */
    IORMEntity findOrCreate(
        SelectQuery|callable|array mysearch,
        ?callable aCallback = null,
        Json[string] optionData = null
    ) {
        options = new ArrayObject(options ~ [
            "atomic": true.toJson,
            "defaults": true.toJson,
        ]);

        myentity = _executeTransaction(
            fn (): _processFindOrCreate(mysearch, mycallback, options.getArrayCopy()),
            options["atomic"]
        );

        if (myentity && _transactionCommitted(options["atomic"], true)) {
            dispatchEvent("Model.afterSaveCommit", compact("entity", "options"));
        }
        return myentity;
    }
    
    /**
     * Performs the actual find and/or create of an entity based on the passed options.
     * Params:
     * \ORM\Query\SelectQuery|callable|array mysearch The criteria to find an existing record by, or a callable tha will
     *  customize the find query.
     * @param callable|null mycallback A callback that will be invoked for newly
     *  created entities. This callback will be called *before* the entity
     *  is persisted.
     * @param Json[string] options The options to use when saving.
     * @return \UIM\Datasource\IORMEntity|array An entity.
     * @throws \ORM\Exception\PersistenceFailedException When the entity couldn"t be saved
     * @throws \InvalidArgumentException
     */
    protected IORMEntity|array _processFindOrCreate(
        SelectQuery|callable|array mysearch,
        ?callable aCallback = null,
        Json[string] optionData = null
    ) {
        myquery = _getFindOrCreateQuery(mysearch);

        myrow = myquery.first();
        if (myrow !isNull) {
            return myrow;
        }
        myentity = this.newEmptyEntity();
        if (options["defaults"] && isArray(mysearch)) {
            myaccessibleFields = array_combine(mysearch.keys, array_fill(0, count(mysearch), true));
            myentity = this.patchEntity(myentity, mysearch, ["accessibleFields": myaccessibleFields]);
        }
        if (mycallback !isNull) {
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
    
    /**
     * Creates a new insert query
     */
    InsertQuery insertQuery() {
        return _queryFactory.insert(this);
    }
    
    /**
     * Creates a new update query
     *
     * @return \ORM\Query\UpdateQuery
     */
    auto updateQuery(): UpdateQuery
    {
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
     * \UIM\Database\Expression\QueryExpression|\Closure|string[]|string fieldNames A hash of field: new value.
     * @param \UIM\Database\Expression\QueryExpression|\Closure|string[]|string myconditions Conditions to be used, accepts anything Query.where()
     */
    int updateAll(
        QueryExpression|Closure|string[]|string fieldNames,
        QueryExpression|Closure|string[]|string myconditions
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
     * \UIM\Database\Expression\QueryExpression|\Closure|string[]|string myconditions Conditions to be used, accepts anything Query.where()
     * can take.
     * @return int Returns the number of affected rows.
     */
    int deleteAll(QueryExpression|Closure|string[]|string myconditions) {
        auto mystatement = this.deleteQuery()
            .where(myconditions)
            .execute();

        return mystatement.rowCount();
    }
 
    bool exists(QueryExpression|Closure|string[]|string myconditions) {
        return (bool)count(
            this.find("all")
            .select(["existing": 1])
            .where(myconditions)
            .limit(1)
            .disableHydration()
            .toArray()
        );
    }
    
    /**

     * ### Options
     *
     * The options array accepts the following keys:
     *
     * - atomic: Whether to execute the save and callbacks inside a database
     *  transaction (default: true)
     * - checkRules: Whether to check the rules on entity before saving, if the checking
     *  fails, it will abort the save operation. (default:true)
     * - associated: If `true` it will save 1st level associated entities as they are found
     *  in the passed `myentity` whenever the property defined for the association
     *  is marked as dirty. If an array, it will be interpreted as the list of associations
     *  to be saved. It is possible to provide different options for saving on associated
     *  table objects using this key by making the custom options the array value.
     *  If `false` no associated records will be saved. (default: `true`)
     * - checkExisting: Whether to check if the entity already exists, assuming that the
     *  entity is marked as not new, and the primary key has been set.
     *
     * ### Events
     *
     * When saving, this method will trigger four events:
     *
     * - Model.beforeRules: Will be triggered right before any rule checking is done
     *  for the passed entity if the `checkRules` key in options is not set to false.
     *  Listeners will receive as arguments the entity, options array and the operation type.
     *  If the event is stopped the rules check result will be set to the result of the event itself.
     * - Model.afterRules: Will be triggered right after the `checkRules()` method is
     *  called for the entity. Listeners will receive as arguments the entity,
     *  options array, the result of checking the rules and the operation type.
     *  If the event is stopped the checking result will be set to the result of
     *  the event itself.
     * - Model.beforeSave: Will be triggered just before the list of fields to be
     *  persisted is calculated. It receives both the entity and the options as
     *  arguments. The options array is passed as an ArrayObject, so any changes in
     *  it will be reflected in every listener and remembered at the end of the event
     *  so it can be used for the rest of the save operation. Returning false in any
     *  of the listeners will abort the saving process. If the event is stopped
     *  using the event API, the event object"s `result` property will be returned.
     *  This can be useful when having your own saving strategy implemented inside a
     *  listener.
     * - Model.afterSave: Will be triggered after a successful insert or save,
     *  listeners will receive the entity and the options array as arguments. The type
     *  of operation performed (insert or update) can be determined by checking the
     *  entity"s method `isNew`, true meaning an insert and false an update.
     * - Model.afterSaveCommit: Will be triggered after the transaction is committed
     *  for atomic save, listeners will receive the entity and the options array
     *  as arguments.
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
     *// Only save the comments association
     * myarticles.save(myentity, ["associated": ["Comments"]]);
     *
     *// Save the company, the employees and related addresses for each of them.
     *// For employees do not check the entity rules
     * mycompanies.save(myentity, [
     *  "associated": [
     *    "Employees": [
     *      "associated": ["Addresses"],
     *      "checkRules": false.toJson
     *    ]
     *  ]
     * ]);
     *
     *// Save no associations
     * myarticles.save(myentity, ["associated": false.toJson]);
     * ```
     * Params:
     * \UIM\Datasource\IORMEntity myentity the entity to be saved
     * @param Json[string] options The options to use when saving.
     */
    IORMEntity|false save(
        IORMEntity myentity,
        Json[string] optionData = null
    ) {
        options = new ArrayObject(options ~ [
            "atomic": true.toJson,
            "associated": true.toJson,
            "checkRules": true.toJson,
            "checkExisting": true.toJson,
            "_primary": true.toJson,
            "_cleanOnSuccess": true.toJson,
        ]);

        if (myentity.hasErrors((bool)options["associated"])) {
            return false;
        }
        if (myentity.isNew() == false && !myentity.isDirty()) {
            return myentity;
        }
        mysuccess = _executeTransaction(
            fn (): _processSave(myentity, options),
            options["atomic"]
        );

        if (mysuccess) {
            if (_transactionCommitted(options["atomic"], options["_primary"])) {
                dispatchEvent("Model.afterSaveCommit", compact("entity", "options"));
            }
            if (options["atomic"] || options["_primary"]) {
                if (options["_cleanOnSuccess"]) {
                    myentity.clean();
                    myentity.setNew(false);
                }
                myentity.setSource(this.registryKey());
            }
        }
        return mysuccess;
    }
    
    /**
     * Try to save an entity or throw a PersistenceFailedException if the application rules checks failed,
     * the entity contains errors or the save was aborted by a callback.
     * Params:
     * \UIM\Datasource\IORMEntity myentity the entity to be saved
     * @param Json[string] options The options to use when saving.
     */
    IORMEntity saveOrFail(IORMEntity myentity, Json[string] optionData = null) {
        mysaved = this.save(myentity, options);
        if (mysaved == false) {
            throw new DPersistenceFailedException(myentity, ["save"]);
        }
        return mysaved;
    }
    
    /**
     * Performs the actual saving of an entity based on the passed options.
     * Params:
     * \UIM\Datasource\IORMEntity myentity the entity to be saved
     * @param \ArrayObject<string, mixed> options the options to use for the save operation
     */
    protected IORMEntity|false _processSave(IORMEntity myentity, ArrayObject options) {
        myprimaryColumns = (array)this.primaryKeys();

        if (options["checkExisting"] && myprimaryColumns && myentity.isNew() && myentity.has(myprimaryColumns)) {
            aliasName = aliasName();
            myconditions = null;
            foreach (myentity.extract(myprimaryColumns) as myKey: myv) {
                myconditions["aliasName.myKey"] = myv;
            }
            myentity.setNew(!this.exists(myconditions));
        }
        mymode = myentity.isNew() ? RulesChecker.CREATE : RulesChecker.UPDATE;
        if (options["checkRules"] && !this.checkRules(myentity, mymode, options)) {
            return false;
        }
        options["associated"] = _associations.normalizeKeys(options["associated"]);
        myevent = dispatchEvent("Model.beforeSave", compact("entity", "options"));

        if (myevent.isStopped()) {
            result = myevent.getResult();
            if (result.isNull) {
                return false;
            }
            if (result != false) {
                assert(
                    cast(IORMEntity)result,                    
                    "The beforeSave callback must return `false` or `IORMEntity` instance. Got `%s` instead."
                    .format(get_debug_type(result))
                );
            }
            return result;
        }
        mysaved = _associations.saveParents(
            this,
            myentity,
            options["associated"],
            ["_primary": false.toJson] + options.getArrayCopy()
        );

        if (!mysaved && options["atomic"]) {
            return false;
        }
        mydata = myentity.extract(getSchema().columns(), true);
        myisNew = myentity.isNew();

        mysuccess = myisNew
            ? _insert(myentity, mydata)
            : _update(myentity, mydata);

        if (mysuccess) {
            mysuccess = _onSaveSuccess(myentity, options);
        }
        if (!mysuccess && myisNew) {
            myentity.unset(this.primaryKeys());
            myentity.setNew(true);
        }
        return mysuccess ? myentity : false;
    }
    
    /**
     * Handles the saving of children associations and executing the afterSave logic
     * once the entity for this table has been saved successfully.
     * Params:
     * \UIM\Datasource\IORMEntity myentity the entity to be saved
     * @param \ArrayObject<string, mixed> options the options to use for the save operation
     */
    protected bool _onSaveSuccess(IORMEntity myentity, ArrayObject options) {
        mysuccess = _associations.saveChildren(
            this,
            myentity,
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
        if (!options["atomic"] && !options["_primary"]) {
            myentity.clean();
            myentity.setNew(false);
            myentity.setSource(this.registryKey());
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
        auto primaryKey = (array)this.primaryKeys();
        if (isEmpty(primaryKey)) {
            mymsg = "Cannot insert row in `%s` table, it has no primary key."
                .format(getTable());
            throw new DatabaseException(mymsg);
        }
        someKeys = array_fill(0, count(primaryKey), null);
        myid = (array)_newId(primaryKey) + someKeys;

        // Generate primary keys preferring values in mydata.
        primaryKey = array_combine(primaryKey, myid);
        primaryKey = array_intersect_key(mydata, primaryKey) + primaryKey;

        myfilteredKeys = array_filter(primaryKey, auto (myv) {
            return myv !isNull;
        });
        mydata += myfilteredKeys;

        if (count(primaryKey) > 1) {
            myschema = getSchema();
            foreach (myKey: myv; myprimary) {
                if (!mydata.isSet(myKey) && myschema.getColumn(myKey)["autoIncrement"].isEmpty) {
                    mymsg = "Cannot insert row, some of the primary key values are missing. ";
                    mymsg ~= 
                        "Got (%s), expecting (%s)"
                        .format(
                        join(", ", myfilteredKeys + myentity.extract(myprimary.keys)),
                        join(", ", myprimary.keys)
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
            foreach (aKey: myv; myprimary ) {
                if (!mydata.isSet(aKey)) {
                    myid = mystatement.lastInsertId(getTable(), aKey);
                    mytype = myschema.getColumnType(aKey);
                    assert(mytype !isNull);
                    myentity.set(aKey, TypeFactory.build(mytype).ToD(myid, mydriver));
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
     * @return string Either null or the primary key value or a list of primary key values.
     */
    protected string _newId(Json[string] myprimary) {
        if (!myprimary || count(myprimary) > 1) {
            return null;
        }
        mytypeName = getSchema().getColumnType(myprimary[0]);
        assert(mytypeName !isNull);
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
        myprimaryKey = myentity.extract(myprimaryColumns);

        mydata = array_diff_key(mydata, myprimaryKey);
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
            .where(myprimaryKey)
            .execute();

        return mystatement.errorCode() == "00000" ? myentity : false;
    }
    
    /**
     * Persists multiple entities of a table.
     *
     * The records will be saved in a transaction which will be rolled back if
     * any one of the records fails to save due to failed validation or database
     * error.
     * Params:
     * iterable<\UIM\Datasource\IORMEntity> myentities Entities to save.
     * @param Json[string] options Options used when calling Table.save() for each entity.
     * @return iterable<\UIM\Datasource\IORMEntity>|false False on failure, entities list on success.
     * @throws \Exception
     */
    auto saveMany(
        range myentities,
        Json[string] optionData = null
    ): iterable|false {
        try {
            return _saveMany(myentities, options);
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
     * iterable<\UIM\Datasource\IORMEntity> myentities Entities to save.
     * @param Json[string] options Options used when calling Table.save() for each entity.
     */
    iterable<\UIM\Datasource\IORMEntity> saveManyOrFail(Json[string] myentities, Json[string] optionData = null) {
        return _saveMany(myentities, options);
    }
    
    /**
     * @param iterable<\UIM\Datasource\IORMEntity> myentities Entities to save.
     * @param Json[string] options Options used when calling Table.save() for each entity.
     * @throws \ORM\Exception\PersistenceFailedException If an entity couldn"t be saved.
     * @throws \Exception If an entity couldn"t be saved.
     * @return iterable<\UIM\Datasource\IORMEntity> Entities list.
     */
    protected auto _saveMany(
        range myentities,
        Json[string] optionData = null
    ): range {
        options = new ArrayObject(
            options ~ [
                "atomic": true.toJson,
                "checkRules": true.toJson,
                "_primary": true.toJson,
            ]
        );
        options["_cleanOnSuccess"] = false;

        bool[] myisNew;
        mycleanupOnFailure = void (myentities) use (&myisNew) {
            foreach (myentities as aKey: myentity) {
                if (isSet(myisNew[aKey]) && myisNew[aKey]) {
                    myentity.unset(this.primaryKeys());
                    myentity.setNew(true);
                }
            }
        };

        myfailed = null;
        try {
            getConnection()
                .transactional(function () use (myentities, options, &myisNew, &myfailed) {
                    // Cache array cast since options are the same for each entity
                    options = (array)options;
                    foreach (myentities as aKey: myentity) {
                        myisNew[aKey] = myentity.isNew();
                        if (this.save(myentity, options) == false) {
                            myfailed = myentity;

                            return false;
                        }
                    }
                });
        } catch (Exception mye) {
            mycleanupOnFailure(myentities);

            throw mye;
        }
        if (myfailed !isNull) {
            mycleanupOnFailure(myentities);

            throw new DPersistenceFailedException(myfailed, ["saveMany"]);
        }
        mycleanupOnSuccess = void (IORMEntity myentity) use (&mycleanupOnSuccess) {
            myentity.clean();
            myentity.setNew(false);

            foreach (myentity.toArray().keys as fieldName) {
                myvalue = myentity.get(fieldName);

                if (cast(IORMEntity)myvalue) {
                    mycleanupOnSuccess(myvalue);
                } else if (isArray(myvalue) && cast(IORMEntity)current(myvalue)) {
                    myvalue.each!(associated => mycleanupOnSuccess(associated));
                }
            }
        };

        if (_transactionCommitted(options["atomic"], options["_primary"])) {
            foreach (myentities as myentity) {
                dispatchEvent("Model.afterSaveCommit", compact("entity", "options"));
                if (options["atomic"] || options["_primary"]) {
                    mycleanupOnSuccess(myentity);
                }
            }
        }
        return myentities;
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
     *  will be aborted. Receives the event, entity, and options.
     * - `Model.afterDelete` Fired after the delete has been successful. Receives
     *  the event, entity, and options.
     * - `Model.afterDeleteCommit` Fired after the transaction is committed for
     *  an atomic delete. Receives the event, entity, and options.
     *
     * The options argument will be converted into an \ArrayObject instance
     * for the duration of the callbacks, this allows listeners to modify
     * the options used in the delete operation.
     * Params:
     * \UIM\Datasource\IORMEntity myentity The entity to remove.
     * @param Json[string] options The options for the delete.
         */
    bool remove(IORMEntity myentity, Json[string] optionData = null) {
        options = new ArrayObject(options ~ [
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
     * iterable<\UIM\Datasource\IORMEntity> myentities Entities to delete.
     * @param Json[string] options Options used when calling Table.save() for each entity.
     */
    IORMEntity[] deleteMany(Json[string] myentities, Json[string] optionData = null) {
        myfailed = _deleteMany(myentities, options);

        if (myfailed !isNull) {
            return false;
        }
        return myentities;
    }
    
    /**
     * Deletes multiple entities of a table.
     *
     * The records will be deleted in a transaction which will be rolled back if
     * any one of the records fails to delete due to failed validation or database
     * error.
     * Params:
     * iterable<\UIM\Datasource\IORMEntity> myentities Entities to delete.
     * @param Json[string] options Options used when calling Table.save() for each entity.
     */
    iterable<\UIM\Datasource\IORMEntity> deleteManyOrFail(Json[string] myentities, Json[string] optionData = null) {
        myfailed = _deleteMany(myentities, options);

        if (myfailed !isNull) {
            throw new DPersistenceFailedException(myfailed, ["deleteMany"]);
        }
        return myentities;
    }
    
    /**
     * @param iterable<\UIM\Datasource\IORMEntity> myentities Entities to delete.
     * @param Json[string] options Options used.
     */
    protected IORMEntity _deleteMany(Json[string] myentities, Json[string] optionData = null) {
        options = new ArrayObject(options ~ [
                "atomic": true.toJson,
                "checkRules": true.toJson,
                "_primary": true.toJson,
            ]);

        myfailed = _executeTransaction(function () use (myentities, options) {
            foreach (myentities as myentity) {
                if (!_processremove(myentity, options)) {
                    return myentity;
                }
            }
            return null;
        }, options["atomic"]);

        if (myfailed.isNull && _transactionCommitted(options["atomic"], options["_primary"])) {
            myentities.each!(entity => 
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
     * @param Json[string] options The options for the delete.
     */
    bool deleteOrFail(IORMEntity myentity, Json[string] optionData = null) {
        mydeleted = remove(myentity, options);
        if (mydeleted == false) {
            throw new DPersistenceFailedException(myentity, ["delete"]);
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
     * @param \ArrayObject<string, mixed> options The options for the delete.
     * @throws \InvalidArgumentException if there are no primary key values of the
     * passed entity
     */
    protected bool _processremove(IORMEntity myentity, ArrayObject options) {
        if (myentity.isNew()) {
            return false;
        }
        myprimaryKey = (array)this.primaryKeys();
        if (!myentity.has(myprimaryKey)) {
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
        mysuccess = _associations.cascaderemove(
            myentity,
            ["_primary": false.toJson + options.getArrayCopy()
        );
        if (!mysuccess) {
            return mysuccess;
        }
        mystatement = this.deleteQuery()
            .where(myentity.extract(myprimaryKey))
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
   bool hasFinder(string mytype) {
        myfinder = "find" ~ mytype;

        return method_exists(this, myfinder) || _behaviors.hasFinder(mytype);
    }
    
    /**
     * Calls a finder method and applies it to the passed query.
     *
     * @internal
     * @template TSubject of \UIM\Datasource\IORMEntity|array
     * @param string mytype Name of the finder to be called.
     * @param \ORM\Query\SelectQuery<TSubject> myquery The query object to apply the finder options to.
     * @param Json ...myargs Arguments that match up to finder-specific parameters
     */
    SelectQuery<TSubject> callFinder(string mytype, SelectQuery myquery, Json ...myargs) {
        string myfinder = "find" ~ mytype;
        if (method_exists(this, myfinder)) {
            return _invokeFinder(this.{myfinder}(...), myquery, myargs);
        }
        if (_behaviors.hasFinder(mytype)) {
            return _behaviors.callFinder(mytype, myquery, ...myargs);
        }
        throw new BadMethodCallException(
            "Unknown finder method `%s` on `%s`.".format(
            mytype,
            class
        ));
    }
    
    /**
     * @internal
     * @template TSubject of \UIM\Datasource\IORMEntity|array
     * @param \Closure mycallable Callable.
     * @param \ORM\Query\SelectQuery<TSubject> myquery The query object.
     * @param Json[string] myargs Arguments for the callable.
     */
    SelectQuery<TSubject> invokeFinder(Closure mycallable, SelectQuery myquery, Json[string] myargs) {
        auto myreflected = new DReflectionFunction(mycallable);
        auto myparams = myreflected.getParameters();
        auto mysecondParam = myparams[1] ?? null;
        auto mysecondParamType = null;

        if (myargs == [] || isSet(myargs[0])) {
            mysecondParamType = mysecondParam?.getType();
            mysecondParamTypeName = cast(ReflectionNamedType)mysecondParamType ? mysecondParamType.name: null;
            // Backwards compatibility of 4.x style finders with signature `findFoo(SelectQuery myquery, Json[string] options)`
            // called as `find("foo")` or `find("foo", [..])`
            if (
                count(myparams) == 2 &&
                mysecondParam?.name == "options" &&
                !mysecondParam.isVariadic() &&
                (mysecondParamType.isNull || mysecondParamTypeName == "array")
            ) {
                if (isSet(myargs[0])) {
                    deprecationWarning(
                        "5.0.0",
                        "Using options array for the `find()` call is deprecated."
                        ~ " Use named arguments instead."
                    );

                    myargs = myargs[0];
                }
                myquery.applyOptions(myargs);

                return mycallable(myquery, myquery.getOptions());
            }
            // Backwards compatibility for core finders like `findList()` called in 4.x style
            // with an array `find("list", ["valueField": "foo"])` instead of `find("list", valueField: "foo")`
            if (isSet(myargs[0]) && isArray(myargs[0]) && mysecondParamTypeName != "array") {
                deprecationWarning(
                    "5.0.0",
                    "Calling `{myreflected.name}` finder with options array is deprecated."
                     ~ " Use named arguments instead."
                );

                myargs = myargs[0];
            }
        }
        if (myargs) {
            myquery.applyOptions(myargs);
            // Fetch custom args without the query options.
            myargs = myquery.getOptions();

            unset(myparams[0]);
            mylastParam = end(myparams);
            reset(myparams);

            if (mylastParam == false || !mylastParam.isVariadic()) {
                myparamNames = null;
                foreach (myparams as myparam) {
                    myparamNames ~= myparam.name;
                }
                myargs.byKeyValue
                    .filter(kv => isString(kv.key) && !in_array(kv.key, myparamNames, true))
                    .each!(kv => unset(myargs[kv.key]));
            }
        }
        return mycallable(myquery, ...myargs);
    }
    
    /**
     * Provides the dynamic findBy and findAllBy methods.
     * Params:
     * string mymethod The method name that was fired.
     * @param Json[string] myargs List of arguments passed to the function.
     */
    protected ISelectQuery _dynamicFinder(string mymethod, Json[string] myargs) {
        mymethod = Inflector.underscore(mymethod);
        preg_match("/^find_([\w]+)_by_/", mymethod, mymatches);
        if (isEmpty(mymatches)) {
            // find_by_is 8 characters.
            fieldNames = substr(mymethod, 8);
            myfindType = "all";
        } else {
            fieldNames = substr(mymethod, mymatches[0].length);
            myfindType = Inflector.variable(mymatches[1]);
        }
        myhasOr = fieldNames.has("_or_");
        myhasAnd = fieldNames.has("_and_");

        mymakeConditions = auto (fieldNames, myargs) {
            myconditions = null;
            if (count(myargs) < count(fieldNames)) {
                throw new BadMethodCallException(sprintf(
                    "Not enough arguments for magic finder. Got %s required %s",
                    count(myargs),
                    count(fieldNames)
                ));
            }
            fieldNames.each!(field => myconditions[this.aliasField(field)] = array_shift(myargs));
            return myconditions;
        };

        if (myhasOr != false && myhasAnd != false) {
            throw new BadMethodCallException(
                "Cannot mix "and" & "or" in a magic finder. Use find() instead."
            );
        }
        if (myhasOr == false && myhasAnd == false) {
            myconditions = mymakeConditions([fieldNames], myargs);
        } else if (myhasOr != false) {
            string[] fieldNames = fieldNames.split("_or_");
            myconditions = [
                "OR": mymakeConditions(fieldNames, myargs),
            ];
        } else {
            string[] fieldNames = fieldNames.split("_and_");
            myconditions = mymakeConditions(fieldNames, myargs);
        }
        return _find(myfindType, conditions: myconditions);
    }
    
    /**
     * Handles behavior delegation + dynamic finders.
     *
     * If your Table uses any behaviors you can call them as if
     * they were on the table object.
     * Params:
     * @param Json[string] myargs List of arguments passed to the function
     */
    Json __call(string methodToInvoke, Json[string] myargs) {
        if (_behaviors.hasMethod(methodToInvoke)) {
            return _behaviors.call(methodToInvoke, myargs);
        }
        if (preg_match("/^find(?:\w+)?By/", methodToInvoke) > 0) {
            return _dynamicFinder(methodToInvoke, myargs);
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
                .format(associationName, associationName, class ));
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
     *  this.request[),
     *  ["associated": ["Tags", "Comments.Users"]]
     * );
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
     * );
     * ```
     *
     * The `fields` option lets remove or restrict input data from ending up in
     * the entity. If you"d like to relax the entity"s default accessible fields,
     * you can use the `accessibleFields` option:
     *
     * ```
     * myarticle = this.Articles.newEntity(
     *  this.request[),
     *  ["accessibleFields": ["protected_field": true.toJson]]
     * );
     * ```
     *
     * By default, the data is validated before being passed to the new DORMEntity. In
     * the case of invalid fields, those will not be present in the resulting object.
     * The `validate` option can be used to disable validation on the passed data:
     *
     * ```
     * myarticle = this.Articles.newEntity(
     *  this.request[),
     *  ["validate": false.toJson]
     * );
     * ```
     *
     * You can also pass the name of the validator to use in the `validate` option.
     * If `null` is passed to the first param of this function, no validation will
     * be performed.
     *
     * You can use the `Model.beforeMarshal` event to modify request data
     * before it is converted into entities.
     * Params:
     * Json[string] data The data to build an entity with.
     * @param Json[string] options A list of options for the object hydration.
     * @return \UIM\Datasource\IORMEntity
     */
    auto newEntity(Json[string] data, Json[string] optionData = null): IORMEntity
    {
        options["associated"] ??= _associations.keys();

        return _marshaller().one(mydata, options);
    }
    
    /**

     * By default all the associations on this table will be hydrated. You can
     * limit which associations are built, or include deeper associations
     * using the options parameter:
     *
     * ```
     * myarticles = this.Articles.newEntities(
     *  this.request[),
     *  ["associated": ["Tags", "Comments.Users"]]
     * );
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
     * );
     * ```
     *
     * You can use the `Model.beforeMarshal` event to modify request data
     * before it is converted into entities.
     * Params:
     * Json[string] data The data to build an entity with.
     * @param Json[string] options A list of options for the objects hydration.
     */
    IORMEntity[] newEntities(Json[string] data, Json[string] optionData = null) {
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
     * );
     * ```
     *
     * ```
     * myarticle = this.Articles.patchEntity(myarticle, this.request[), [
     *  "associated": [
     *    "Tags": ["accessibleFields": ["*": true.toJson]]
     *  ]
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
     * Params:
     * \UIM\Datasource\IORMEntity myentity the entity that will get the
     * data merged in
     * @param Json[string] data key value list of fields to be merged into the entity
     * @param Json[string] options A list of options for the object hydration.
     */
    IORMEntity patchEntity(IORMEntity myentity, Json[string] data, Json[string] optionData = null) {
        options["associated"] ??= _associations.keys();

        return _marshaller().merge(myentity, mydata, options);
    }
    
    /**

     * Those entries in `myentities` that cannot be matched to any record in
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
     * );
     * ```
     *
     * You can use the `Model.beforeMarshal` event to modify request data
     * before it is converted into entities.
     * Params:
     * iterable<\UIM\Datasource\IORMEntity> myentities the entities that will get the
     * data merged in
     * @param Json[string] data list of arrays to be merged into the entities
     * @param Json[string] options A list of options for the objects hydration.
     */
    IORMEntity[] patchEntities(Json[string] myentities, Json[string] data, Json[string] optionData = null) {
        options["associated"] ??= _associations.keys();

        return _marshaller().mergeMany(myentities, mydata, options);
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
     *     "rule": ["validateUnique", ["scope": "site_id"]],
     *     "provider": "table"
     * ]
     * ]);
     * ```
     *
     * In the above example, the email uniqueness will be scoped to only rows having
     * the same site_id. Scoping will only be used if the scoping field is present in
     * the data to be validated.
     * Params:
     * Json aValue The value of column to be checked for uniqueness.
     * @param Json[string] options The options array, optionally containing the "scope" key.
     *  May also be the validation context, if there are no options.
     * @param array|null mycontext Either the validation context or null.
     * @return bool True if the value is unique, or false if a non-scalar, non-unique value was given.
     */
    bool validateUnique(Json aValue, Json[string] options, Json[string] mycontext = null) {
        if (mycontext.isNull) {
            mycontext = options;
        }
        myentity = new DORMEntity(
            mycontext["data"],
            [
                "useSetters": false.toJson,
                "markNew": mycontext["newRecord"],
                "source": this.registryKey(),
            ]
        );
        fieldNames = array_merge(
            [mycontext["field"]],
            isSet(options["scope"]) ? (array)options["scope"] : []
        );
        myvalues = myentity.extract(fieldNames);
        foreach (myvalues as fieldName) {
            if (fieldName !isNull && !isScalar(fieldName)) {
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
        myeventMap = [
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
     * \UIM\Datasource\IORMEntity|array<\UIM\Datasource\IORMEntity> myentities a single entity or list of entities
     * @param Json[string] mycontain A `contain()` compatible array.
     */
    IORMEntity[] loadInto(IORMEntity|array myentities, Json[string] mycontain) {
        return (new DLazyEagerLoader()).loadInto(myentities, mycontain, this);
    }
 
    protected bool validationMethodExists(string myname) {
        return method_exists(this, myname) || this.behaviors().hasMethod(myname);
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
    } */
}
