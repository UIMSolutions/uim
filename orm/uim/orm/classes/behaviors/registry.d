/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.orm.classes.behaviors.registry;

import uim.orm;

@safe:

/**
 * BehaviorRegistry is used as a registry for loaded behaviors and handles loading
 * and constructing behavior objects.
 *
 * This class DAlso provides method for checking and dispatching behavior methods.
 *
 * @: DORMCore\ObjectRegistry<DORMBehavior>
 */
class DBehaviorRegistry : DObjectRegistry!DBehavior {
        this() {}

    // }: ObjectRegistry, IEventDispatcher {
    /* 
    mixin TEventDispatcher;

    // The table using this registry.
    protected DORMTable _table;

    // Method mappings.
    protected [][string] _methodMap = null;

    // Finder method mappings.
    protected []string _finderMap = null;

    /**
     
     *
     * aTable - The table this registry is attached to.
     */
    this(DORMTable aTable = null) {
        if (aTable != null) {
            setTable(aTable);
        }
    }

    /**
     * Attaches a table instance to this registry.
     *
     * @param DORMTable aTable The table this registry is attached to.
     */
    @property table(DORMTable aTable) {
        _table = aTable;
        setEventManager(aTable.getEventManager());
    }

    /**
     * Resolve a behavior classname.
     *
     * @param string aClassName  Partial classname to resolve.
     */
    static string className(string aClassName ) {
        return App.className(class, "Model/Behavior", "Behavior")
            ?: App.className(class, "ORM/Behavior", "Behavior");
    }

    /**
     * Resolve a behavior classname.
     *
     * Part of the template method for uim\Core\ObjectRegistry.load()
     */
    protected string _resolveClassName(string partialClassname ) {
        return className(partialClassname);
    }

    /**
     * Throws an exception when a behavior is missing.
     *
     * Part of the template method for uim\Core\ObjectRegistry.load()
     * and uim\Core\ObjectRegistry.remove()
     *
     * aClassName - The classname that is missing.
     */
    protected void _throwMissingClassError(string aClassName , string pluginName) {
        throw new DMissingBehaviorException([
            "class": aClassName ~ "Behavior",
            "plugin": pluginName,
        ]);
    }

    /**
     * Create the behavior instance.
     *
     * Part of the template method for uim\Core\ObjectRegistry.load()
     * Enabled behaviors will be registered with the event manager.
     *
     * @param string aClassName  The classname that is missing.
     * @param string anAlias The alias of the object.
     * @param Json[string] myConfiguration An array of config to use for the behavior.
     */
    protected IBehavior _create(class, string anAlias, Json myConfiguration) {
        /** @var DORMBehavior instance */
        instance = new class(_table, myConfiguration);
        enable = configuration.get("enabled"] ?? true;
        if (enable) {
            getEventManager().on(instance);
        }
        aMethodNames = _getMethods(instance, class, alias);
        _methodMap += aMethodNames["methods"];
        _finderMap += aMethodNames["finders"];

        return instance;
    }

    /**
     * Get the behavior methods and ensure there are no duplicates.
     *
     * Use the implementedEvents() method to exclude callback methods.
     * Methods starting with `_` will be ignored, as will methods
     * declared on uim\orm.Behavior
     *
     * @param DORMBehavior instance The behavior to get methods from.
     * @param string aClassName  The classname that is missing.
     * @param string anAlias The alias of the object.
     */
    protected Json[string] _getMethods(Behavior instance, string aClassName , string anAlias) {
        auto finders = array_change_key_case(instance.implementedFinders());
        auto aMethodNames = array_change_key_case(instance.implementedMethods());

        foreach (finder, myMethodName; finders) {
            if (isset(_finderMap[finder]) && this.has(_finderMap[finder][0])) {
                auto duplicate = _finderMap[finder];
                auto error =  
                    "%s contains duplicate finder '%s' which is already provided by '%s'"
                    .format(class, finder, duplicate[0]);
                throw new DLogicException(error);
            }
            finders[finder] = [alias, methodName];
        }

        foreach (myMethodKey, methodName; methods) {
            if (isset(_methodMap[myMethodKey]) && this.has(_methodMap[myMethodKey][0])) {
                duplicate = _methodMap[myMethodKey];
                auto error =  
                    "%s contains duplicate method '%s' which is already provided by '%s'".format(aClassName,
                    method,
                    duplicate[0]
                );
                throw new DLogicException(error);
            }
            methods[myMethodKey] = [alias, methodName];
        }

        return compact("methods", "finders");
    }

    /**
     * Check if any loaded behavior : a method.
     *
     * Will return true if any behavior provides a non-finder method
     * with the chosen name.
     */
    bool hasMethod(string aMethodName) {
        method = strtolower(aMethodName);

        return isset(_methodMap[aMethodName]);
    }

    /**
     * Check if any loaded behavior : the named finder.
     * Will return true if any behavior provides a method with the chosen name.
     */
    bool hasFinder(string aMethodName) {
        aMethodName = aMethodName.lower;

        return isset(_finderMap[aMethodName]);
    }

    // Invoke a method on a behavior.
    Json call(string aMethodName, Json[string] methodsData = null) {
        aMethodName = strtolower(aMethodName);
        if (this.hasMethod(aMethodName) && this.has(_methodMap[aMethodName][0])) {
            [behavior, callMethod] = _methodMap[aMethodName];

            return _loaded[behavior].{callMethod}(...methodsData);
        }

        throw new BadMethodCallException(
            sprintf("Cannot call '%s' it does not belong to any attached behavior.", aMethodName)
        );
    }

    // Invoke a finder on a behavior.
    DORMQuery callFinder(string finderType, Json[string] methodsData = null) {
        finderType = finderType.lower;

        if (this.hasFinder(finderType) && this.has(_finderMap[finderType][0])) {
            [behavior, callMethod] = _finderMap[finderType];
            callable = [_loaded[behavior], callMethod];

            return callable(...methodsData);
        }

        throw new BadMethodCallException(
            "Cannot call finder '%s' it does not belong to any attached behavior.".format(finderType)
        );
    }
}
  auto BehaviorRegistry() { // Singleton
    return DBehaviorRegistry.instance;
  }
