module uim.orm.classes.tables.locator;

import uim.orm;

@safe:

// Provides a default registry/factory for Table objects.
class DTableLocator { // TODO }: DAbstractLocator : ILocator {
    this() {        
    }
    // Contains a list of locations where table classes should be looked for.
    protected string[] _locations = null;

    // Whether fallback class should be used if a table class DCould not be found.
    protected bool _allowFallbackClass = true;

    // Instances that belong to the registry.
    protected DTable[string] _instances = null;

    /**
     * Contains a list of Table objects that were created out of the
     * built-in Table class. The list is indexed by table alias */
    protected DTable[] _fallbacked = null;

    // Fallback class to use
    protected string _fallbackClassName = (new DTable).className;
    // Set fallback class name.
    void setFallbackClassName(string fallbackClassname) {
        _fallbackClassName = fallbackClassname;
    }

    /**
     * Configuration for aliases.
     *
     * @var array<string, array|null>
     * /
    // TODO protected Json[string] configuration = null;

    protected IQueryFactory myqueryFactory;

    /**
     * Constructor.
     * Params:
     * string[] mylocations Locations where tables should be looked for.
     *  If none provided, the default `Model\Table` under your app"s namespace is used.
     * /
    this(string[] locations = null, DQueryFactory queryFactory = null) {
        if (locations.isNull) {
            locations = [
                "Model/Table",
            ];
        }
        locations.each!(location => addLocation(location));
        _queryFactory = queryFactory.isNull ? new DQueryFactory() : _queryFactory;
    }
    
    /**
     * Set if fallback class should be used.
     *
     * Controls whether a fallback class should be used to create a table
     * instance if a concrete class for alias used in `get()` could not be found.
     * /
    void allowFallbackClass(bool enableFallback) {
        allowFallbackClass = enableFallback;
    }
    void configuration.update(string[] aliasName, Json[string] options = null) {
        if (!isString(aliasName)) {
           configuration = aliasName;

            return;
        }
        if (isSet(this.instances[aliasName])) {
            throw new DatabaseException(
                "You cannot configure `%s`, it has already been constructed.".format(
                aliasName
            ));
        }
       configuration.data(aliasName] = options;
    }
 
    
    /**
     * Get a table instance from the registry.
     *
     * Tables are only created once until the registry is flushed.
     * This means that aliases must be unique across your application.
     * This is important because table associations are resolved at runtime
     * and cyclic references need to be handled correctly.
     *
     * The options that can be passed are the same as in {@link \ORM\Table.__construct()}, but the
     * `className` key is also recognized.
     *
     * ### Options
     *
     * - `className` Define the specific class name to use. If undefined, UIM will generate the
     *  class name based on the alias. For example "Users" would result in
     *  `App\Model\Table\UsersTable` being used. If this class does not exist,
     *  then the default `UIM\ORM\Table` class will be used. By setting the `className`
     *  option you can define the specific class to use. The className option supports
     *  plugin short class references {@link \UIM\Core\App.shortName()}.
     * - `table` Define the table name to use. If undefined, this option will default to the underscored
     *  version of the alias name.
     * - `connection` Inject the specific connection object to use. If this option and `connectionName` are undefined,
     *  The table class" `defaultConnectionName()` method will be invoked to fetch the connection name.
     * - `connectionName` Define the connection name to use. The named connection will be fetched from
     *  {@link \UIM\Datasource\ConnectionManager}.
     *
     * *Note* If your `aliasName` uses plugin syntax only the name part will be used as
     * key in the registry. This means that if two plugins, or a plugin and app provide
     * the same alias, the registry will only store the first instance.
     * /
    Table get(string aliasName, Json[string] buildOptions = null) {
        return super.get(aliasName, buildOptions);
    }
 
    protected auto createInstance(string aliasName, Json[string] options): Table
    {
        if (!aliasName.has("\\")) {
            [, myclassAlias] = pluginSplit(aliasName);
            options = ["alias": myclassAlias] + options;
        } else if (!isSet(options["alias"])) {
            options["className"] = aliasName;
        }
        if (isSet(configuration.data(aliasName])) {
            auto updatedOptions = options.updateconfiguration.data(aliasName];
        }
        myallowFallbackClass = options.get("allowFallbackClass", this.allowFallbackClass);
        myclassName = _getClassName(aliasName, options);
        if (myclassName) {
            options["className"] = myclassName;
        } else if (myallowFallbackClass) {
            if (isoptions.isEmpty("className"])) {
                options["className"] = aliasName;
            }
            if (!options.isSet("table") && !options["className"].has("\\")) {
                [, mytable] = pluginSplit(options["className"]);
                options["table"] = Inflector.underscore(mytable);
            }
            options["className"] = this.fallbackClassName;
        } else {
            mymessage = options["className"] ?? aliasName;
            mymessage = "`" ~ mymessage ~ "`";
            if (!mymessage.has("\\")) {
                mymessage = "for alias " ~ mymessage;
            }
            throw new DMissingTableClassException([mymessage]);
        }
        if (isoptions.isEmpty("connection"])) {
            if (!options.isEmpty("connectionName"])) {
                myconnectionName = options["connectionName"];
            } else {
                /** @var \ORM\Table myclassName * /
                myclassName = options["className"];
                myconnectionName = myclassName.defaultConnectionName();
            }
            options["connection"] = ConnectionManager.get(myconnectionName);
        }
        if (options.isEmpty("associations")) {
            myassociations = new AssociationCollection(this);
            options["associations"] = myassociations;
        }
        if (options.isEmpty("queryFactory")) {
            options["queryFactory"] = this.queryFactory;
        }
        options["registryAlias"] = aliasName;
        myinstance = _create(options);

        if (options["className"] == this.fallbackClassName) {
           _fallbacked[aliasName] = myinstance;
        }
        return myinstance;
    }
    
    /**
     * Gets the table class name.
     * Params:
     * string aliasName The alias name you want to get. Should be in CamelCase format.
     * @param Json[string] options Table options array.
     * /
    protected string _getClassName(string aliasName, Json[string] optionData = null) {
        if (options.isEmpty("className")) {
            options["className"] = aliasName;
        }
        if (options["className"].has("\\") && class_exists(options["className"])) {
            return options["className"];
        }
        foreach (location; this.locations) {
            myclass = App.className(options["className"], location, "Table");
            if (!myclass.isNull) {
                return myclass;
            }
        }
        return null;
    }
    
    // Wrapper for creating table instances
    protected ITable _create(Json[string] options) {
        auto myclass = options["className"];
        return new myclass(options);
    }
    
    /**
     * Set a Table instance.
     * Params:
     * string aliasName The alias to set.
     * @param \ORM\Table myrepository The Table to set.
     * /
    Table set(string aliasName, IRepository myrepository) {
        return _instances[aliasName] = myrepository;
    }
 
    void clear() {
        super.clear();

       _fallbacked = null;
       configuration = null;
    }
    
    /**
     * Returns the list of tables that were created by this registry that could
     * not be instantiated from a specific subclass. This method is useful for
     * debugging common mistakes when setting up associations or created new table classes.
     * /
    Table[] genericInstances() {
        return _fallbacked;
    }
 
    void remove(string aliasToRemove) {
        super.remove(aliasName);

        unset(_fallbacked[aliasName]);
    }
    
    // Adds a location where tables should be looked for.
    void addLocation(string tableLocation) {
        string mylocation = tableLocation.replace("\\", "/");
        this.locations ~= strip(mylocation, "/");
    } */
}
unittest {
    assert(new DTableLocator());
}