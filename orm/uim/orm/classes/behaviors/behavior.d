/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.orm.classes.behaviors.behavior;

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
 * function doSomething(arg1, arg2) {
 *   // do something
 * }
 * ```
 *
 * Would be called like `table.doSomething(arg1, arg2);`.
 *
 * ### Callback methods
 *
 * Behaviors can listen to any events fired on a Table. By default,
 * UIM provides a number of lifecycle events your behaviors can
 * listen to:
 *
 * - `beforeFind(IEvent event, Query query, ArrayObject options, boolean primary)`
 *   Fired before each find operation. By stopping the event and supplying a
 *   return value you can bypass the find operation entirely. Any changes done
 *   to the query instance will be retained for the rest of the find. The
 *   primary parameter indicates whether this is the root query,
 *   or an associated query.
 *
 * - `buildValidator(IEvent event, Validator validator, string aName)`
 *   Fired when the validator object identified by name is being built. You can use this
 *   callback to add validation rules or add validation providers.
 *
 * - `buildRules(IEvent event, RulesChecker rules)`
 *   Fired when the rules checking object for the table is being built. You can use this
 *   callback to add more rules to the set.
 *
 * - `beforeRules(IEvent event, IEntity anEntity, ArrayObject options, operation)`
 *   Fired before an entity is validated using by a rules checker. By stopping this event,
 *   you can return the final value of the rules checking operation.
 *
 * - `afterRules(IEvent event, IEntity anEntity, ArrayObject options, bool result, operation)`
 *   Fired after the rules have been checked on the entity. By stopping this event,
 *   you can return the final value of the rules checking operation.
 *
 * - `beforeSave(IEvent event, IEntity anEntity, ArrayObject options)`
 *   Fired before each entity is saved. Stopping this event will abort the save
 *   operation. When the event is stopped the result of the event will be returned.
 *
 * - `afterSave(IEvent event, IEntity anEntity, ArrayObject options)`
 *   Fired after an entity is saved.
 *
 * - `beforeDelete_(IEvent event, IEntity anEntity, ArrayObject options)`
 *   Fired before an entity is deleted. By stopping this event you will abort
 *   the delete operation.
 *
 * - `afterDelete_(IEvent event, IEntity anEntity, ArrayObject options)`
 *   Fired after an entity has been deleted.
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
 * findSlugged(Query query, IData[string] optionData)
 * ```
 *
 * @see DORMTable::addBehavior()
 * @see DORMevents.EventManager
 */
class DBehavior { // }: IEventListener {
    mixin TConfigurable!(); 

    bool initialize(IData[string] initData = null) {
        configuration(MemoryConfiguration);
        setConfigurationData(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));

    /*
    mixin InstanceConfigTemplate;

    /**
     * Table instance.
     *
     * @var DORMTable
     * /
    protected _table;

    /**
     * Reflection method cache for behaviors.
     *
     * Stores the reflected method + finder methods per class.
     * This prevents reflecting the same class multiple times in a single process.
     *
     * @var array<string, array>
     * /
    protected static _reflectionCache = null;

    /**
     * Default configuration
     *
     * These are merged with user-provided configuration when the behavior is used.
     *
     * @var array<string, mixed>
     * /
    protected _defaultConfig = null;

    /**
     * Constructor
     *
     * Merges config with the default and store in the config property
     *
     * @param DORMDORMTable aTable The table this behavior is attached to.
     * @param array<string, mixed> myConfiguration The config for this behavior.
     * /
    this(DORMTable aTable, IData[string] configData) {
        myConfiguration = _resolveMethodAliases(
            "implementedFinders",
            _defaultConfig,
            myConfiguration
        );
        myConfiguration = _resolveMethodAliases(
            "implementedMethods",
            _defaultConfig,
            myConfiguration
        );
        _table = table;
        configuration.update(myConfiguration);
        this.initialize(myConfiguration);
    }

    /**
     * Constructor hook method.
     *
     * Implement this method to avoid having to overwrite
     * the constructor and call parent.
     *
     * @param array<string, mixed> myConfiguration The configuration settings provided to this behavior.
     * /
    bool initialize(IData[string] myConfiguration) {
    }

    

    /**
     * Get the table instance this behavior is bound to.
     *
     * @return DORMTable The bound table instance.
     * /
    function table(): Table
    {
        return _table;
    }

    /**
     * Removes aliased methods that would otherwise be duplicated by userland configuration.
     *
     * @param string aKey The key to filter.
     * @param array<string, mixed> defaults The default method mappings.
     * @param array<string, mixed> myConfiguration The customized method mappings.
     * @return array A de-duped list of config data.
     * /
    protected array _resolveMethodAliases(string aKey, array defaults, IData myConfiguration) {
        if (!isset(defaults[key], myconfiguration[key])) {
            return myConfiguration;
        }
        if (isset(myconfiguration[key]) && myconfiguration[key] == []) {
            configuration.update(key, [], false);
            unset(myconfiguration[key]);

            return myConfiguration;
        }

        indexed = array_flip(defaults[key]);
        indexedCustom = array_flip(myconfiguration[key]);
        foreach (indexed as method: alias) {
            if (!isset(indexedCustom[method])) {
                indexedCustom[method] = alias;
            }
        }
        configuration.update(key, array_flip(indexedCustom), false);
        unset(myconfiguration[key]);

        return myConfiguration;
    }

    /**
     * verifyConfig
     *
     * Checks that implemented keys contain values pointing at callable.
     *
     * @return void
     * @throws DORMCore\exceptions.UIMException if config are invalid
     * /
    void verifyConfig() {
        keys = ["implementedFinders", "implementedMethods"];
        foreach (keys as key) {
            if (!isset(configuration[key])) {
                continue;
            }

            foreach (configuration[key] as method) {
                if (!is_callable([this, method])) {
                    throw new UIMException(sprintf(
                        "The method %s is not callable on class %s",
                        method,
                        class
                    ));
                }
            }
        }
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
     * @return array<string, mixed>
     * /
    array implementedEvents() {
        eventMap = [
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
        myConfiguration = configuration;
        priority = myconfiguration["priority"] ?? null;
        events = null;

        foreach (eventMap as event: method) {
            if (!method_exists(this, method)) {
                continue;
            }
            if (priority == null) {
                events[event] = method;
            } else {
                events[event] = [
                    "callable": method,
                    "priority": priority,
                ];
            }
        }

        return events;
    }

    /**
     * implementedFinders
     *
     * Provides an alias.methodname map of which finders a behavior implements. Example:
     *
     * ```
     *  [
     *    "this": "findThis",
     *    "alias": "findMethodName"
     *  ]
     * ```
     *
     * With the above example, a call to `table.find("this")` will call `behavior.findThis()`
     * and a call to `table.find("alias")` will call `behavior.findMethodName()`
     *
     * It is recommended, though not required, to define implementedFinders in the config property
     * of child classes such that it is not necessary to use reflections to derive the available
     * method list. See core behaviors for examples
     *
     * @return array
     * @throws \ReflectionException
     * /
    array implementedFinders() {
        methods = this.getConfig("implementedFinders");
        if (isset(methods)) {
            return methods;
        }

        return _reflectionCache()["finders"];
    }

    /**
     * implementedMethods
     *
     * Provides an alias.methodname map of which methods a behavior implements. Example:
     *
     * ```
     *  [
     *    "method": "method",
     *    "aliasedMethod": "somethingElse"
     *  ]
     * ```
     *
     * With the above example, a call to `table.method()` will call `behavior.method()`
     * and a call to `table.aliasedMethod()` will call `behavior.somethingElse()`
     *
     * It is recommended, though not required, to define implementedFinders in the config property
     * of child classes such that it is not necessary to use reflections to derive the available
     * method list. See core behaviors for examples
     *
     * @return array
     * @throws \ReflectionException
     * /
    array implementedMethods() {
        methods = this.getConfig("implementedMethods");
        if (isset(methods)) {
            return methods;
        }

        return _reflectionCache()["methods"];
    }

    /**
     * Gets the methods implemented by this behavior
     *
     * Uses the implementedEvents() method to exclude callback methods.
     * Methods starting with `_` will be ignored, as will methods
     * declared on Cake\orm.Behavior
     *
     * @return array
     * @throws \ReflectionException
     * /
    protected array _reflectionCache() {
        class = class;
        if (isset(self::_reflectionCache[class])) {
            return self::_reflectionCache[class];
        }

        events = this.implementedEvents();
        eventMethods = null;
        foreach (events as binding) {
            if ((binding.isArray && isset(binding["callable"])) {
                /** @var string callable * /
                callable = binding["callable"];
                binding = callable;
            }
            eventMethods[binding] = true;
        }

        baseClass = self::class;
        if (isset(self::_reflectionCache[baseClass])) {
            baseMethods = self::_reflectionCache[baseClass];
        } else {
            baseMethods = get_class_methods(baseClass);
            self::_reflectionCache[baseClass] = baseMethods;
        }

        return = [
            "finders": [],
            "methods": [],
        ];

        reflection = new ReflectionClass(class);

        foreach (reflection.getMethods(ReflectionMethod::IS_PUBLIC) as method) {
            methodName = method.getName();
            if (
                in_array(methodName, baseMethods, true) ||
                isset(eventMethods[methodName])
            ) {
                continue;
            }

            if (substr(methodName, 0, 4) == "find") {
                return["finders"][lcfirst(substr(methodName, 4))] = methodName;
            } else {
                return["methods"][methodName] = methodName;
            }
        }

        return self::_reflectionCache[class] = return;
    } */
}
