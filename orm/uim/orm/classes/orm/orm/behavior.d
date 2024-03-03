module uim.orm;
import uim.orm;

@safe:
/**
 * Base class for behaviors.
 *
 * Behaviors allow you to simulate mixins, and create
 * reusable blocks of application logic, that can be reused across
 * several models. Behaviors also provide a way to hook into model
 * callbacks and augment their behavior.
 *
 * ### Mixin methods
 *
 * Behaviors can provide mixin like features by declaring public
 * methods. These methods will be accessible on the tables the
 * behavior has been added to.
 *
 * ```
 * auto doSomething(myarg1, myarg2) {
 *  // do something
 * }
 * ```
 *
 * Would be called like `mytable.doSomething(myarg1, myarg2);`.
 *
 * ### Callback methods
 *
 * Behaviors can listen to any events fired on a Table. By default,
 * UIM provides a number of lifecycle events your behaviors can
 * listen to:
 *
 * - `beforeFind(IEvent myevent, SelectQuery myquery, ArrayObject options, boolean myprimary)`
 *  Fired before each find operation. By stopping the event and supplying a
 *  return value you can bypass the find operation entirely. Any changes done
 *  to the myquery instance will be retained for the rest of the find. The
 *  myprimary parameter indicates whether this is the root query,
 *  or an associated query.
 *
 * - `buildValidator(IEvent myevent, Validator myvalidator, string myname)`
 *  Fired when the validator object identified by myname is being built. You can use this
 *  callback to add validation rules or add validation providers.
 *
 * - `buildRules(IEvent myevent, RulesChecker myrules)`
 *  Fired when the rules checking object for the table is being built. You can use this
 *  callback to add more rules to the set.
 *
 * - `beforeRules(IEvent myevent, IEntity myentity, ArrayObject options, myoperation)`
 *  Fired before an entity is validated using by a rules checker. By stopping this event,
 *  you can return the final value of the rules checking operation.
 *
 * - `afterRules(IEvent myevent, IEntity myentity, ArrayObject options, bool result, myoperation)`
 *  Fired after the rules have been checked on the entity. By stopping this event,
 *  you can return the final value of the rules checking operation.
 *
 * - `beforeSave(IEvent myevent, IEntity myentity, ArrayObject options)`
 *  Fired before each entity is saved. Stopping this event will abort the save
 *  operation. When the event is stopped the result of the event will be returned.
 *
 * - `afterSave(IEvent myevent, IEntity myentity, ArrayObject options)`
 *  Fired after an entity is saved.
 *
 * - `beforeDelete(IEvent myevent, IEntity myentity, ArrayObject options)`
 *  Fired before an entity is deleted. By stopping this event you will abort
 *  the delete operation.
 *
 * - `afterDelete(IEvent myevent, IEntity myentity, ArrayObject options)`
 *  Fired after an entity has been deleted.
 *
 * In addition to the core events, behaviors can respond to any
 * event fired from your Table classes including custom application
 * specific ones.
 *
 * You can set the priority of a behaviors callbacks by using the
 * `priority` setting when attaching a behavior. This will set the
 * priority for all the callbacks a behavior provides.
 *
 * ### Finder methods
 *
 * Behaviors can provide finder methods that hook into a Table"s
 * find() method. Custom finders are a great way to provide preset
 * queries that relate to your behavior. For example a SluggableBehavior
 * could provide a find("slugged") finder. Behavior finders
 * are implemented the same as other finders. Any method
 * starting with `find` will be setup as a finder. Your finder
 * methods should expect the following arguments:
 *
 * ```
 * findSlugged(SelectQuery myquery, IData[string] options)
 * ```
 *
 * @see \UIM\ORM\Table.addBehavior()
 * @see \UIM\Event\EventManager
 */
class Behavior : IEventListener {
    use InstanceConfigTemplate();

    /**
     * Table instance.
     */
    protected Table my_table;

    /**
     * Reflection method cache for behaviors.
     *
     * Stores the reflected method + finder methods per class.
     * This prevents reflecting the same class multiple times in a single process.
     *
     * @var array<string, array>
     */
    protected static array my_reflectionCache = [];

    /**
     * Default configuration
     *
     * These are merged with user-provided configuration when the behavior is used.
     *
     */
    protected IData[string] _defaultConfigData;

    /**
     * Constructor
     *
     * Merges config with the default and store in the config property
     * Params:
     * \UIM\ORM\Table mytable The table this behavior is attached to.
     * configData - The config for this behavior.
     */
    this(Table mytable, Iconfiguration.getData(string] configData = null) {
        configData = _resolveMethodAliases(
            "implementedFinders",
<<<<<<< HEAD
           _defaultConfigData,
            myConfiguration
=======
           _defaultConfig,
            configData
>>>>>>> 281012f1b957b2df089e0f9ff60905fca492f311
        );
        configData = _resolveMethodAliases(
            "implementedMethods",
<<<<<<< HEAD
           _defaultConfigData,
            myConfiguration
=======
           _defaultConfig,
            configData
>>>>>>> 281012f1b957b2df089e0f9ff60905fca492f311
        );
       _table = mytable;
        configuration.update(configData);
        
        this.initialize(configData);
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
       _defaultConfig = Json .emptyObject;
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
    protected array _resolveMethodAliases(string aKey, array mydefaults, Iconfiguration.getData(string] configData) {
        if (!isSet(mydefaults[aKey], configuration.getData(aKey])) {
            return configData;
        }
        if (configuration.hasKey(aKey) && configuration.getData(aKey] == []) {
            configuration.update(aKey, [], false);
            unset(configuration.getData(aKey]);

            return configData;
        }
        myindexed = array_flip(mydefaults[aKey]);
        myindexedCustom = array_flip(configuration.getData(aKey]);
        foreach (myindexed as mymethod: myalias) {
            if (!isSet(myindexedCustom[mymethod])) {
                myindexedCustom[mymethod] = myalias;
            }
        }
        configuration.update(aKey, array_flip(myindexedCustom), false);
        unset(configuration.getData(aKey]);

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
    IData[string] implementedEvents() {
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
        
        auto configData = this.getConfig();
        auto mypriority = configData("priority", null);
        auto myevents = [];

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
        myeventMethods = [];
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
            "finders": [],
            "methods": [],
        ];

        myreflection = new ReflectionClass(myclass);

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
