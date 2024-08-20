/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
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
    this() {
    }

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

    // Attaches a table instance to this registry.
    @property void table(DORMTable aTable) {
        _table = aTable;
        setEventManager(aTable.getEventManager());
    }

    // Resolve a behavior classname.
    static string classname(string partialclassname) {
        return App.classname(partialclassname, "Model/Behavior", "Behavior")
            ? App.classname(partialclassname, "Model/Behavior", "Behavior") : App.classname(
                partialclassname, "ORM/Behavior", "Behavior");
    }

    /**
     * Resolve a behavior classname.
     *
     * Part of the template method for uim\Core\ObjectRegistry.load()
     */
    protected string _resolveclassname(string partialclassname) {
        return classname(partialclassname);
    }

    /**
     * Throws an exception when a behavior is missing.
     *
     * Part of the template method for uim\Core\ObjectRegistry.load()
     * and uim\Core\ObjectRegistry.removeKey()
     */
    protected void _throwMissingClassError(string missingClassname, string pluginName) {
        throw new DMissingBehaviorException([
            "class": missingClassname ~ "Behavior",
            "plugin": pluginName,
        ]);
    }

    /**
     * Create the behavior instance.
     *
     * Part of the template method for uim\Core\ObjectRegistry.load()
     * Enabled behaviors will be registered with the event manager.
     */
    protected IBehavior _create(string classname, string aliasname, Json[string] myConfiguration) {
        /* DORMBehavior instance = new class(_table, myConfiguration);
        if (configuration.getBoolean("enabled", true)) {
            getEventManager().on(instance);
        }

        auto methodNames = _getMethods(instance, classname, aliasname);
        _methodMap ~= methodNames["methods"];
        _finderMap ~= methodNames["finders"];

        return instance; */
        return null; 
    }

    /**
     * Get the behavior methods and ensure there are no duplicates.
     *
     * Use the implementedEvents() method to exclude callback methods.
     * Methods starting with `_` will be ignored, as will methods
     * declared on uim\orm.Behavior
     *x
     */
    protected Json[string] _getMethods(DORMBehavior behavior, string missingClassname, string aliasname) {
        auto finders = array_change_key_case(behavior.implementedFinders());
        auto methodNames = array_change_key_case(behavior.implementedMethods());

       /*  foreach (finder, myMethodName; finders) {
            if (isset(_finderMap[finder]) && this.has(_finderMap[finder][0])) {
                auto duplicate = _finderMap[finder];
                auto error =
                    "%s contains duplicate finder '%s' which is already provided by '%s'"
                    .format(class, finder, duplicate[0]);
                throw new DLogicException(error);
            }
            finders[finder] = [aliasname, methodName];
        } */

        foreach (myMethodKey, methodName; methods) {
            if (_methodMap.hasKey(myMethodKey) && this.has(_methodMap[myMethodKey][0])) {
                duplicate = _methodMap[myMethodKey];
                auto error =
                    "%s contains duplicate method '%s' which is already provided by '%s'".format(missingClassname,
                        method,
                        duplicate[0]
                    );
                throw new DLogicException(error);
            }
            methods[myMethodKey] = [aliasname, methodName];
        }

        return compact("methods", "finders");
    }

    /**
     * Check if any loaded behavior : a method.
     *
     * Will return true if any behavior provides a non-finder method
     * with the chosen name.
     */
    bool hasMethod(string methodName) {
        return _methodMap.hasKey(methodName.lower);
    }

    /**
     * Check if any loaded behavior : the named finder.
     * Will return true if any behavior provides a method with the chosen name.
     */
    bool hasFinder(string aMethodName) {
        aMethodName = aMethodName.lower;

        return _finderMap.haskey(aMethodName);
    }

    // Invoke a method on a behavior.
    Json call(string aMethodName, Json[string] methodsData = null) {
        aMethodName = strtolower(aMethodName);
        /* if (hasMethod(aMethodName) && this.has(_methodMap[aMethodName][0])) {
            [behavior, callMethod] = _methodMap[aMethodName];

            return _loaded[behavior]. {
                callMethod
            }
            (...methodsData);
        }

        throw new BadMethodCallException(
            "Cannot call '%s' it does not belong to any attached behavior.".format(aMethodName)
        ); */
    }

    // Invoke a finder on a behavior.
    DORMQuery callFinder(string finderType, Json[string] methodsData = null) {
        finderType = finderType.lower;

        /* if (this.hasFinder(finderType) && this.has(_finderMap[finderType][0])) {
            [behavior, callMethod] = _finderMap[finderType];
            callable = [_loaded[behavior], callMethod];

            return callable(...methodsData);
        }

        throw new BadMethodCallException(
            "Cannot call finder '%s' it does not belong to any attached behavior.".format(
                finderType)
        ); */
    }
}
auto BehaviorRegistry() { // Singleton
    return DBehaviorRegistry.instance;
}
