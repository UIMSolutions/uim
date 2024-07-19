/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
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
 *  // do something
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
 * - `beforeFind(IEvent event, Query query, Json[string] options, boolean primary)`
 *  Fired before each find operation. By stopping the event and supplying a
 *  return value you can bypass the find operation entirely. Any changes done
 *  to the query instance will be retained for the rest of the find. The
 *  primary parameter indicates whether this is the root query,
 *  or an associated query.
 *
 * - `buildValidator(IEvent event, Validator validator, string aName)`
 *  Fired when the validator object identified by name is being built. You can use this
 *  callback to add validation rules or add validation providers.
 *
 * - `buildRules(IEvent event, RulesChecker rules)`
 *  Fired when the rules checking object for the table is being built. You can use this
 *  callback to add more rules to the set.
 *
 * - `beforeRules(IEvent event, IORMEntity anEntity, Json[string] options, operation)`
 *  Fired before an entity is validated using by a rules checker. By stopping this event,
 *  you can return the final value of the rules checking operation.
 *
 * - `afterRules(IEvent event, IORMEntity anEntity, Json[string] options, bool result, operation)`
 *  Fired after the rules have been checked on the entity. By stopping this event,
 *  you can return the final value of the rules checking operation.
 *
 * - `beforeSave(IEvent event, IORMEntity anEntity, Json[string] options)`
 *  Fired before each entity is saved. Stopping this event will abort the save
 *  operation. When the event is stopped the result of the event will be returned.
 *
 * - `afterSave(IEvent event, IORMEntity anEntity, Json[string] options)`
 *  Fired after an entity is saved.
 *
 * - `beforeremove(IEvent event, IORMEntity anEntity, Json[string] options)`
 *  Fired before an entity is deleted. By stopping this event you will abort
 *  the delete operation.
 *
 * - `afterremove(IEvent event, IORMEntity anEntity, Json[string] options)`
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
 * findSlugged(Query query, Json[string] options = null)
 * ```
 */
class DBehavior : DEventListener {
    mixin TConfigurable;

    this() {
        initialize;
        this.name("Behavior");
    }

    this(Json[string] initData) {
        initialize(initData);
        this.name("Behavior");
    }

    this(string name) {
        this().name(name);
    }

    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));

    IEvent[] implementedEvents() {
        return null;
    }

    /**
     * Table instance.
    protected DORMTable _table;

    /**
     * Reflection method cache for behaviors.
     *
     * Stores the reflected method + finder methods per class.
     * This prevents reflecting the same class multiple times in a single process.
     */
    protected static Json[string] _reflectionCache = null;

    this(DORMTable attachedTable, Json[string] configData) {
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
        _table = attachedTable;
        configuration.set(myConfiguration);
        this.initialize(myConfiguration);
    }

    // Get the table instance this behavior is bound to.
    DORMTable table() {
        return _table;
    }

    // Removes aliased methods that would otherwise be duplicated by userland configuration.
    protected Json[string] _resolveMethodAliases(string key, Json[string] defaultMethodMap, Json[string] myConfiguration) {
        if (defaultMethodMap.isNull(key) && configuration.isNull(key)) {
            return configuration;
        }
        if (configuration.hasKey(key) && configuration.isEmpty(key)) {
            configuration.set(key, [], false);
            configuration.remove(key);

            return configuration;
        }

        auto indexed = array_flip(defaultMethodMap[key]);
        auto indexedCustom = array_flip(configuration.get(key));
        indexed.byKeyValue.each!((methodAlias) {
            if (!indexedCustom.hasKey(methodAlias.key)) {
                indexedCustom[methodAlias.key] = methodAlias.value;
            }
        });
        configuration.set(key, array_flip(indexedCustom), false);
        configuration.remove(key);

        return configuration;
    }

    /**
     * verifyConfig
     * Checks that implemented keys contain values pointing at callable.
     */
    void verifyConfig() {
        ["implementedFinders", "implementedMethods"]
            filter(key => configuration.hasKey(key))
            .each!((key) {
                foreach (method; configuration.getStringArray(key)) {
                    if (!is_callable([this, method])) {
                        throw new DException(
                            "The method %s is not callable on class %s"
                            .format(method, classname));
                    }
                }
            });
    }

    /**
     * Gets the Model callbacks this behavior is interested in.
     *
     * By defining one of the callback methods a behavior is assumed
     * to be interested in the related event.
     *
     * Override this method if you need to add non-conventional event listeners.
     * Or if you want your behavior to listen to non-standard events.
     */
    Json[string] implementedEvents() {
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
        auto configData = configuration.data;
        
        Json priority = configuration.get("priority");
        Json[string] events = null;
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
     * [
     *   "this": "findThis",
     *   "alias": "findMethodName"
     * ]
     * ```
     *
     * With the above example, a call to `table.find("this")` will call `behavior.findThis()`
     * and a call to `table.find("alias")` will call `behavior.findMethodName()`
     *
     * It is recommended, though not required, to define implementedFinders in the config property
     * of child classes such that it is not necessary to use reflections to derive the available
     * method list. See core behaviors for examples
     */
    Json[string] implementedFinders() {
        methods = this.configuration.get("implementedFinders");
        if (methods !is null) {
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
     * [
     *   "method": "method",
     *   "aliasedMethod": "somethingElse"
     * ]
     * ```
     *
     * With the above example, a call to `table.method()` will call `behavior.method()`
     * and a call to `table.aliasedMethod()` will call `behavior.somethingElse()`
     *
     * It is recommended, though not required, to define implementedFinders in the config property
     * of child classes such that it is not necessary to use reflections to derive the available
     * method list. See core behaviors for examples
     */
    Json[string] implementedMethods() {
        auto methods = configuration.get("implementedMethods");
        if (!methods.isNull) {
            return methods.toJsonMap;
        }

        return _reflectionCache()["methods"];
    }

    /**
     * Gets the methods implemented by this behavior
     *
     * Uses the implementedEvents() method to exclude callback methods.
     * Methods starting with `_` will be ignored, as will methods
     * declared on uim\orm.Behavior
     */
    protected Json[string] _reflectionCache() {
        class = class;
        if (_reflectionCache.hasJey(class)) {
            return _reflectionCache[class];
        }

        auto events = this.implementedEvents();
        bool[string] eventMethods = null;
        foreach (binding; events) {
            if (binding.isArray && binding.hasKey("callable")) {
                /** @var string callable */
                callable = binding["callable"];
                binding = callable;
            }
            eventMethods[binding] = true;
        }

        auto baseClass = class;
        if (_reflectionCache.haskey(baseClass)) {
            baseMethods = _reflectionCache[baseClass];
        } else {
            baseMethods = get_class_methods(baseClass);
            _reflectionCache[baseClass] = baseMethods;
        }

        return = [
            "finders": Json.emptyArray,
            "methods": Json.emptyArray,
        ];

        reflection = new DReflectionClass(class);

        foreach (method; reflection.getMethods(ReflectionMethod.IS_PUBLIC)) {
            auto methodName = method.getName();
            if (isIn(methodName, baseMethods, true) || eventMethods.hasKey(methodName)) {
                continue;
            }

            if (subString(methodName, 0, 4) == "find") {
                return["finders"][lcfirst(subString(methodName, 4))] = methodName;
            } else {
                return["methods"][methodName] = methodName;
            }
        }

        return _reflectionCache[class] = return;
    }
}
