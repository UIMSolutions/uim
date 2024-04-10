module uim.orm;
import uim.orm;

@safe:

class DBehavior : IEventListener {
    mixin TConfigurable!();
    
    this() {
        initialize;
    }

    this(IData[string] initData) {
        initialize(initData);
    }

    this(string name) {
        this().name(name);
    }

    // Hook method
    bool initialize(IData[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));

    // Table instance.
    protected ITable my_table;

    /**
     * Reflection method cache for behaviors.
     *
     * Stores the reflected method + finder methods per class.
     * This prevents reflecting the same class multiple times in a single process.
     *
     * @var array<string, array>
     * /
    protected static array my_reflectionCache = null;

    /**
     * Constructor
     *
     * Merges config with the default and store in the config property
     * Params:
     * \UIM\ORM\Table mytable The table this behavior is attached to.
     * configData - The config for this behavior.
     */
    this(Table mytable, IData[string] configData = null) {
        configData = _resolveMethodAliases(
            "implementedFinders",
           _defaultConfigData,
            myConfiguration
        );
        configData = _resolveMethodAliases(
            "implementedMethods",
           _defaultConfigData,
            myConfiguration
        );
       _table = mytable;
        configuration.update(configData);
        
        this.initialize(initData);
    }
    
    /**
     * Constructor hook method.
     *
     * Implement this method to avoid having to overwrite
     * the constructor and call parent.
     *
     * configData - The configuration settings provided to this behavior.
     */

    bool initialize(IData[string] initData = null) {
      
    }
    
    /**
     * Get the table instance this behavior is bound to.
     */
    Table table() {
        return _table;
    }
    
    /**
     * Removes aliased methods that would otherwise be duplicated by userland configuration.
     * Params:
     * string aKey The key to filter.
     * @param IData[string] mydefaults The default method mappings.
     * configData - The customized method mappings.
     */
    protected array _resolveMethodAliases(string aKey, array mydefaults, IData[string] configData) {
        if (!isSet(mydefaults[aKey], configuration[aKey])) {
            return configData;
        }
        if (configuration.hasKey(aKey) && configuration[aKey] == []) {
            configuration.update(aKey, [], false);
            configuration.remove(aKey]);

            return configData;
        }
        myindexed = array_flip(mydefaults[aKey]);
        myindexedCustom = array_flip(configuration[aKey]);
        foreach (myindexed as mymethod: myalias) {
            if (!isSet(myindexedCustom[mymethod])) {
                myindexedCustom[mymethod] = myalias;
            }
        }
        configuration.update(aKey, array_flip(myindexedCustom), false);
        configuration.remove(aKey]);

        return configData;
    }
    
    /**
     * verifyConfig
     *
     * Checks that implemented keys contain values pointing at callable.
     */
    void verifyConfig() {
        ["implementedFinders", "implementedMethods"]
            .filter!(key => isSet(configuration.data(aKey]))
            .each!(key => configuration.data(aKey]
                .filter!(method => !isCallable([this, mymethod]))
                .each!(method => throw new UimException(
                        "The method `%s` is not callable on class `%s`."
                        .format(method, class))));

    }
    
    /**
     * Gets the Model callbacks this behavior is interested in.
     *
     * By defining one of the callback methods a behavior is assumed
     * to be interested in the related event.
     *
     * Override this method if you need to add non-conventional event listeners.
     * Or if you want your behavior to listen to non-standard events.
     *
     */
    IEvents[] implementedEvents() {
        myeventMap = [
            "Model.beforeMarshal": "beforeMarshal",
            "Model.afterMarshal": "afterMarshal",
            "Model.beforeFind": "beforeFind",
            "Model.beforeSave": "beforeSave",
            "Model.afterSave": "afterSave",
            "Model.afterSaveCommit": "afterSaveCommit",
            "Model.beforeDelete": "beforeDelete",
            "Model.afterDelete": "afterDelete",
            "Model.afterDeleteCommit": "afterDeleteCommit",
            "Model.buildValidator": "buildValidator",
            "Model.buildRules": "buildRules",
            "Model.beforeRules": "beforeRules",
            "Model.afterRules": "afterRules",
        ];
        
        auto configData = this.configuration.data;
        auto mypriority = configData("priority", null);
        auto myevents = null;

        myeventMap.byKeyValue
            .filter!(eventMethod => method_exists(this, eventMethod.value))
            .each!(eventMethod => myevents[eventMethod.key] = mypriority.isNull
                ? eventMethod.value
                : [
                    "callable": eventMethod.value,
                    "priority": mypriority,
                ]);
        }
        return myevents;
    }
    
    /**
     * implementedFinders
     *
     * Provides an alias.methodname map of which finders a behavior implements. Example:
     *
     * ```
     * [
     *   "this": "findThis",
     *   "alias": "findMethodName"
     * ]
     * ```
     *
     * With the above example, a call to `mytable.find("this")` will call `mybehavior.findThis()`
     * and a call to `mytable.find("alias")` will call `mybehavior.findMethodName()`
     *
     * It is recommended, though not required, to define implementedFinders in the config property
     * of child classes such that it is not necessary to use reflections to derive the available
     * method list. See core behaviors for examples
     */
    array implementedFinders() {
        mymethods = configurationData.isSet("implementedFinders");
        if (isSet(mymethods)) {
            return mymethods;
        }
        return _reflectionCache()["finders"];
    }
    
    /**
     * implementedMethods
     *
     * Provides an alias.methodname map of which methods a behavior implements. Example:
     *
     * ```
     * [
     *   "method": "method",
     *   "aliasedMethod": "somethingElse"
     * ]
     * ```
     *
     * With the above example, a call to `mytable.method()` will call `mybehavior.method()`
     * and a call to `mytable.aliasedMethod()` will call `mybehavior.somethingElse()`
     *
     * It is recommended, though not required, to define implementedFinders in the config property
     * of child classes such that it is not necessary to use reflections to derive the available
     * method list. See core behaviors for examples
     */
    array implementedMethods() {
        mymethods = configurationData.isSet("implementedMethods");
        if (isSet(mymethods)) {
            return mymethods;
        }
        return _reflectionCache()["methods"];
    }
    
    /**
     * Gets the methods implemented by this behavior
     *
     * Uses the implementedEvents() method to exclude callback methods.
     * Methods starting with `_` will be ignored, as will methods
     * declared on UIM\ORM\Behavior
     */
    protected array _reflectionCache() {
        myclass = class;
        if (isSet(self.my_reflectionCache[myclass])) {
            return self.my_reflectionCache[myclass];
        }
        myevents = this.implementedEvents();
        myeventMethods = null;
        foreach (myevents as mybinding) {
            if (isArray(mybinding) && isSet(mybinding["callable"])) {
                mycallable = mybinding["callable"];
                assert(isString(mycallable));
                mybinding = mycallable;
            }
            myeventMethods[mybinding] = true;
        }
        mybaseClass = self.classname;
        if (isSet(self.my_reflectionCache[mybaseClass])) {
            mybaseMethods = self.my_reflectionCache[mybaseClass];
        } else {
            mybaseMethods = get_class_methods(mybaseClass);
            self.my_reflectionCache[mybaseClass] = mybaseMethods;
        }
        result = [
            "finders": ArrayData,
            "methods": ArrayData,
        ];

        myreflection = new DReflectionClass(myclass);

        foreach (myreflection.getMethods(ReflectionMethod.IS_PUBLIC) as mymethod) {
            mymethodName = mymethod.name;
            if (
                in_array(mymethodName, mybaseMethods, true) ||
                isSet(myeventMethods[mymethodName])
            ) {
                continue;
            }
            if (mymethodName.startsWith("find")) {
                result["finders"][lcfirst(substr(mymethodName, 4))] = mymethodName;
            } else {
                result["methods"][mymethodName] = mymethodName;
            }
        }
        return self.my_reflectionCache[myclass] = result;
    }
}
