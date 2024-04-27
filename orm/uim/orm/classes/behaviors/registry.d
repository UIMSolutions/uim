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
     * Constructor
     *
     * aTable - The table this registry is attached to.
     * /
    this(DORMTable aTable = null) {
        if (aTable != null) {
            this.setTable(aTable);
        }
    }

    /**
     * Attaches a table instance to this registry.
     *
     * @param DORMTable aTable The table this registry is attached to.
     * /
    @property table(DORMTable aTable) {
        _table = aTable;
        this.setEventManager(aTable.getEventManager());
    }

    /**
     * Resolve a behavior classname.
     *
     * @param string aClassName  Partial classname to resolve.
     * @return string|null Either the correct classname or null.
     * @psalm-return class-string|null
     * /
    static string className(string aClassName ) {
        return App::className(class, "Model/Behavior", "Behavior")
            ?: App::className(class, "ORM/Behavior", "Behavior");
    }

    /**
     * Resolve a behavior classname.
     *
     * Part of the template method for uim\Core\ObjectRegistry::load()
     *
     * @param string aClassName  Partial classname to resolve.
     * @return string|null Either the correct class name or null.
     * @psalm-return class-string|null
     * /
    protected string _resolveClassName(string aClassName ) {
        return className(class);
    }

    /**
     * Throws an exception when a behavior is missing.
     *
     * Part of the template method for uim\Core\ObjectRegistry::load()
     * and uim\Core\ObjectRegistry::remove()
     *
     * aClassName - The classname that is missing.
     * @param string|null plugin The plugin the behavior is missing in.
     * @throws DORMexceptions.MissingBehaviorException
     * /
    protected void _throwMissingClassError(string aClassName , string plugin) {
        throw new DMissingBehaviorException([
            "class": aClassName ~ "Behavior",
            "plugin": plugin,
        ]);
    }

    /**
     * Create the behavior instance.
     *
     * Part of the template method for uim\Core\ObjectRegistry::load()
     * Enabled behaviors will be registered with the event manager.
     *
     * @param string aClassName  The classname that is missing.
     * @param string anAlias The alias of the object.
     * @param array<string, mixed> myConfiguration An array of config to use for the behavior.
     * @return DORMBehavior The constructed behavior class.
     * @psalm-suppress MoreSpecificImplementedParamType
     * /
    protected IBehavior _create(class, string anAlias, Json myConfiguration) {
        /** @var DORMBehavior instance * /
        instance = new class(_table, myConfiguration);
        enable = configuration.get("enabled"] ?? true;
        if (enable) {
            this.getEventManager().on(instance);
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
     * @return array A list of implemented finders and methods.
     * @throws \LogicException when duplicate methods are connected.
     * /
    // TODO protected array _getMethods(Behavior instance, string aClassName , string anAlias) {
        finders = array_change_key_case(instance.implementedFinders());
        aMethodNames = array_change_key_case(instance.implementedMethods());

        foreach (finder, myMethodName; finders) {
            if (isset(_finderMap[finder]) && this.has(_finderMap[finder][0])) {
                duplicate = _finderMap[finder];
                error = sprintf(
                    "%s contains duplicate finder '%s' which is already provided by '%s'",
                    class,
                    finder,
                    duplicate[0]
                );
                throw new DLogicException(error);
            }
            finders[finder] = [alias, methodName];
        }

        foreach (myMethodKey, methodName; methods) {
            if (isset(_methodMap[myMethodKey]) && this.has(_methodMap[myMethodKey][0])) {
                duplicate = _methodMap[myMethodKey];
                error = sprintf(
                    "%s contains duplicate method '%s' which is already provided by '%s'",
                    aClassName,
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
     *
     * @param string aMethodName The method to check for.
     * /
    bool hasMethod(string aMethodName) {
        method = strtolower(method);

        return isset(_methodMap[method]);
    }

    /**
     * Check if any loaded behavior : the named finder.
     *
     * Will return true if any behavior provides a method with
     * the chosen name.
     *
     * @param string aMethodName The method to check for.
     * /
    bool hasFinder(string aMethodName) {
        aMethodName = aMethodName.toLower;

        return isset(_finderMap[aMethodName]);
    }

    /**
     * Invoke a method on a behavior.
     *
     * @param string aMethodName The method to invoke.
     * @param array args The arguments you want to invoke the method with.
     * @return mixed The return value depends on the underlying behavior method.
     * @throws \BadMethodCallException When the method is unknown.
     * /
    function call(string aMethodName, array args = null) {
        aMethodName = strtolower(aMethodName);
        if (this.hasMethod(aMethodName) && this.has(_methodMap[aMethodName][0])) {
            [behavior, callMethod] = _methodMap[aMethodName];

            return _loaded[behavior].{callMethod}(...args);
        }

        throw new BadMethodCallException(
            sprintf("Cannot call '%s' it does not belong to any attached behavior.", aMethodName)
        );
    }

    /**
     * Invoke a finder on a behavior.
     *
     * @param string type The finder type to invoke.
     * @param array args The arguments you want to invoke the method with.
     * @return DORMQuery The return value depends on the underlying behavior method.
     * @throws \BadMethodCallException When the method is unknown.
     * /
    Query callFinder(string type, array args = null) {
        type = type.toLower;

        if (this.hasFinder(type) && this.has(_finderMap[type][0])) {
            [behavior, callMethod] = _finderMap[type];
            callable = [_loaded[behavior], callMethod];

            return callable(...args);
        }

        throw new BadMethodCallException(
            "Cannot call finder '%s' it does not belong to any attached behavior.".format(type)
        );
    } */
}
  auto BehaviorRegistry() { // Singleton
    return DBehaviorRegistry.instance;
  }
