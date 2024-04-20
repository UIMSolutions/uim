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
    /**
     * Instances that belong to the registry.
     *
     * @var array<string, uim.Datasource\>
     * /
    protected IRepository[string] instances;

    // Contains a list of options that were passed to get() method.
    // TODO protected array[string] options = null;

    /**
     * {@inheritDoc}
     *
     * @param string alias The alias name you want to get.
     * @param array<string, mixed> options The options you want to build the table with.
     * /
    IRepository get(string alias, IData[string] optionData = null) {
        auto storeOptions = options;
        storeOptions.remove("allowFallbackClass");

        if (this.instances.isSet(alias)) {
            if (!empty(storeOptions) && isset(configuration.update(alias]) && configuration.update(alias] != storeOptions) {
                throw new DRuntimeException(sprintf(
                    "You cannot configure '%s', it already exists in the registry.",
                    alias
                ));
            }

            return _instances[alias];
        }

        configuration.update(alias, storeOptions);

        return _instances[alias] = this.createInstance(alias, options);
    }

    /**
     * Create an instance of a given classname.
     *
     * @param string alias Repository alias.
     * @param array<string, mixed> options The options you want to build the instance with.
     * @return uim.Datasource\
     * /
    abstract protected IRepository createInstance(string alias, IData[string] optionData);


    function set(string alias, IRepository repository) {
        return _instances[alias] = repository;
    }


    bool exists(string alias) {
        return isset(this.instances[alias]);
    }


    void remove(string alias) {
        unset(
            this.instances[alias],
            configuration.update(alias]
        );
    }


    void clear() {
        this.instances = null;
        this.options = null;
    } */
}
