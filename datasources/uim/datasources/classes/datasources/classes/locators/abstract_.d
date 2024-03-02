module uim.datasources.locators.abstract_;

import uim.datasources;

@safe:

// Provides an abstract registry/factory for repository objects.
abstract class AbstractLocator : ILocator {
    // Instances that belong to the registry.
    protected IRepository[string] _instances;

    // Contains a list of options that were passed to get() method.
    protected IData[string] optionData = null;

    /**
 Params:
     * string aalias The alias name you want to get.
     * @param IData[string] optionData The options you want to build the table with.
     */
    IRepository get(string aliasName, IData[string] optionData = null) {
        storeOptions = options;
        unset($storeOptions["allowFallbackClass"]);

        if (isSet(this.instances[aliasName])) {
            if (!empty($storeOptions) && isSet(this.options[aliasName]) && this.options[aliasName] != storeOptions) {
                throw new UimException(
                    "You cannot configure `%s`, it already exists in the registry.",
                    .format(aliasName)
                );
            }
            return this.instances[aliasName];
        }
        this.options[aliasName] = storeOptions;

        return this.instances[aliasName] = this.createInstance(aliasName, options);
    }
    
    /**
     * Create an instance of a given classname.
     * Params:
     * string aalias Repository alias.
     * @param IData[string] optionData The options you want to build the instance with.
     */
    abstract protected IRepository createInstance(string aalias, IData[string] optionData = null);

 
    IRepository set(string aalias, IRepository repository) {
        return this.instances[$alias] = repository;
    }
 
    bool exists(string aalias) {
        return isSet(this.instances[$alias]);
    }
 
    void remove(string aalias) {
        unset(
            this.instances[$alias],
            this.options[$alias]
        );
    }
 
    void clear() {
        this.instances = [];
        this.options = [];
    }
}
