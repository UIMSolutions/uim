module uim.orm;

import uim.orm;

@safe:

/**
 * BehaviorRegistry is used as a registry for loaded behaviors and handles loading
 * and constructing behavior objects.
 *
 * This class also provides method for checking and dispatching behavior methods.
 *
 * @extends \UIM\Core\ObjectRegistry<\UIM\ORM\Behavior>
 * @implements \UIM\Event\IEventDispatcher<\UIM\ORM\Table>
 */
class BehaviorRegistry : ObjectRegistry, IEventDispatcher {
    /**
     * @use \UIM\Event\EventDispatcherTrait<\UIM\ORM\Table>
     */
    mixin EventDispatcherTemplate();

    // The table using this registry.
    protected Table my_table;

    // Method mappings.
    protected array[string] my_methodMap = [];

    // Finder method mappings.
    protected array[string] my_finderMap = [];

    /**
     * Constructor
     * Params:
     * \UIM\ORM\Table|null mytable The table this registry is attached to.
     */
    this(Table mytable = null) {
        if (mytable !isNull) {
            this.setTable(mytable);
        }
    }

    /**
     * Attaches a table instance to this registry.
     * Params:
     * \UIM\ORM\Table mytable The table this registry is attached to.
     */
    void setTable(Table mytable) {
       _table = mytable;
        this.setEventManager(mytable.getEventManager());
    }
    
    /**
     * Resolve a behavior classname.
     * Params:
     * string myclass Partial classname to resolve.
     * /
    static string className(string myclass) {
        return App.className(myclass, "Model/Behavior", "Behavior")
            ?: App.className(myclass, "ORM/Behavior", "Behavior");
    }
    
    /**
     * Resolve a behavior classname.
     *
     * Part of the template method for UIM\Core\ObjectRegistry.load()
     * Params:
     * string myclass Partial classname to resolve.
     */
    protected string|int|false _resolveClassName(string myclass) {
        /** @var class-string<\UIM\ORM\Behavior>|null */
        return className(myclass);
    }
    
    /**
     * Throws an exception when a behavior is missing.
     *
     * Part of the template method for UIM\Core\ObjectRegistry.load()
     * and UIM\Core\ObjectRegistry.unload()
     * Params:
     * string myclass The classname that is missing.
     * @param string myplugin The plugin the behavior is missing in.
     */
    protected void _throwMissingClassError(string myclass, string myplugin) {
        throw new MissingBehaviorException([
            "class": myclass ~ "Behavior",
            "plugin": myplugin,
        ]);
    }
    
    /**
     * Create the behavior instance.
     *
     * Part of the template method for UIM\Core\ObjectRegistry.load()
     * Enabled behaviors will be registered with the event manager.
     * Params:
     * \UIM\ORM\Behavior|class-string<\UIM\ORM\Behavior> myclass The classname that is missing.
     * @param string aliasToObject The alias of the object.
     * configData - An array of config to use for the behavior.
     */
    protected Behavior _create(object|string myclass, string aliasToObject, IData[string] configData) {
        if (isObject(myclass)) {
            return myclass;
        }
        myinstance = new myclass(_table, configData);

        myenable = configData("enabled"] ?? true;
        if (myenable) {
            this.getEventManager().on(myinstance);
        }
        mymethods = _getMethods(myinstance, myclass, aliasToObject);
       _methodMap += mymethods["methods"];
       _finderMap += mymethods["finders"];

        return myinstance;
    }
    
    /**
     * Get the behavior methods and ensure there are no duplicates.
     *
     * Use the implementedEvents() method to exclude callback methods.
     * Methods starting with `_` will be ignored, as will methods
     * declared on UIM\ORM\Behavior
     * Params:
     * \UIM\ORM\Behavior myinstance The behavior to get methods from.
     * @param string myclass The classname that is missing.
     * @param string aliasToObject The alias of the object.
     */
    protected array _getMethods(Behavior myinstance, string myclass, string aliasToObject) {
        myfinders = array_change_key_case(myinstance.implementedFinders());
        mymethods = array_change_key_case(myinstance.implementedMethods());

        myfinders.byKeyValue
            .each!((finderMethod) {
                if (isSet(_finderMap[finderMethod.key]) && this.has(_finderMap[finderMethod.key][0])) {
                    auto myduplicate = _finderMap[finderMethod.key];
                    auto myerror = 
                        "`%s` contains duplicate finder `%s` which is already provided by `%s`."
                        .format(myclass, finderMethod.key, myduplicate[0]);
                    throw new LogicException(myerror);
                }
                myfinders[finderMethod.key] = [aliasToObject, finderMethod.value];
            });

        mymethods.byKeyValue
            .filter!(methodName => isSet(_methodMap[methodName.key]) && this.has(_methodMap[methodName.key][0]))
            .each!((methodName) {
                auto myduplicate = _methodMap[methodName.key];
                auto myerror = "`%s` contains duplicate method `%s` which is already provided by `%s`."
                    .format(myclass, methodName.key, myduplicate[0]);
                throw new LogicException(myerror);
            });
            mymethods[mymethod] = [aliasToObject, mymethodName];
        }

        return compact("methods", "finders");
    }
    
    /**
     * Check if any loaded behavior : a method.
     *
     * Will return true if any behavior provides a non-finder method
     * with the chosen name.
     * Params:
     * string mymethod The method to check for.
     */
   bool hasMethod(string mymethod) {
        mymethod = mymethod.toLower;

        return isSet(_methodMap[mymethod]);
    }
    
    /**
     * Check if any loaded behavior : the named finder.
     *
     * Will return true if any behavior provides a method with
     * the chosen name.
     * Params:
     * string mymethod The method to check for.
     */
   bool hasFinder(string mymethod) {
        mymethod = mymethod.toLower;

        return isSet(_finderMap[mymethod]);
    }
    
    /**
     * Invoke a method on a behavior.
     * Params:
     * string mymethod The method to invoke.
     * @param array myargs The arguments you want to invoke the method with.
     */
    Json call(string mymethod, array myargs = []) {
        mymethod = mymethod.toLower;
        if (this.hasMethod(mymethod) && this.has(_methodMap[mymethod][0])) {
            [mybehavior, mycallMethod] = _methodMap[mymethod];

            return _loaded[mybehavior].{mycallMethod}(...myargs);
        }
        throw new BadMethodCallException(
            "Cannot call `%s`, it does not belong to any attached behavior."
            .format(mymethod)
        );
    }
    
    /**
     * Invoke a finder on a behavior.
     *
     * @internal
     * @template TSubject of \UIM\Datasource\IEntity|array
     * @param string mytype The finder type to invoke.
     * @param \UIM\ORM\Query\SelectQuery<TSubject> myquery The query object to apply the finder options to.
     * @param Json ...myargs Arguments that match up to finder-specific parameters
     */
    SelectQuery<TSubject> callFinder(string mytype, SelectQuery myquery, Json ...myargs) {
        mytype = mytype.toLower;

        if (this.hasFinder(mytype) && this.has(_finderMap[mytype][0])) {
            [mybehavior, mycallMethod] = _finderMap[mytype];
            mycallable = _loaded[mybehavior].mycallMethod(...);

            return _table.invokeFinder(mycallable, myquery, myargs);
        }
        throw new BadMethodCallException(
            "Cannot call finder `%s`, it does not belong to any attached behavior.".format(mytype)
        );
    }
}
