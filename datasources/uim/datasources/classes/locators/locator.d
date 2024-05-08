/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.datasources.classes.locators.locator;

@safe:
import uim.datasources;

// Provides an abstract registry/factory for repository objects.
abstract class DAbstractLocator : ILocator {
    // Instances that belong to the registry.
    protected IRepository[string] _instances;

    // Contains a list of options that were passed to get() method.
    protected Json[string] _options = null;

    /**
     * @param string aliasNameName The aliasName name you want to get.
     * @param Json[string] options The options you want to build the table with.
     * /
    IRepository get(string aliasNameName, Json[string] buildOptions = null) {
        auto storeOptions = buildOptions.dup;
        storeOptions.remove("allowFallbackClass");

        if (_instances.isSet(aliasName)) {
            if (!storeOptions.isEmpty && isset(configuration.update(aliasName]) && configuration.update(aliasName] != storeOptions) {
                throw new DRuntimeException("You cannot configure '%s', it already exists in the registry.".format(aliasName));
            }

            return _instances[aliasName];
        }

        configuration.update(aliasName, storeOptions);

        return _instances[aliasName] = this.createInstance(aliasName, options);
    }

    /**
     * Create an instance of a given classname.
     *
     * @param string aliasNameName Repository aliasNameName.
     * @param Json[string] options The options you want to build the instance with.
     * @return uim.Datasource\
     * /
    abstract protected IRepository createInstance(string aliasNameName, Json[string] optionData);


    function set(string aliasNameName, IRepository repository) {
        return _instances[aliasNameName] = repository;
    }


    bool exists(string aliasNameName) {
        return _instances.hasKey(aliasNameName);
    }


    void remove(string aliasNameName) {
        unset(
            _instances[aliasNameName],
            configuration.update(aliasNameName]
        );
    }


    void clear() {
        _instances = null;
        _options = null;
    } */
}
