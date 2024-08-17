/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
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

    IRepository get(string aliasNameName, Json[string] buildOptions = null) {
        auto storeOptions = buildOptions.dup;
        storeOptions.removeKey("allowFallbackClass");

        if (_instances.hasKey(aliasName)) {
            if (!storeOptions.isEmpty && configuration.get(aliasName) != storeOptions) {
                throw new DRuntimeException(
                    "You cannot configure '%s', it already exists in the registry."
                    .format(aliasName));
            }

            return _instances[aliasName];
        }

        configuration.set(aliasName, storeOptions);
        return _instances.set(aliasName, this.createInstance(aliasName, options));
    }

    // Create an instance of a given classname.
    abstract protected IRepository createInstance(string repositoryAlias, Json[string] options = null);

    ILocator set(string repositoryAlias, IRepository repository) {
        return _instances.set(repositoryAlias, repository);
    }

    bool hasKey(string repositoryAlias) {
        return _instances.hasKey(repositoryAlias);
    }

    // #region remove
    ILocator removeKey(string[] aliasNames...) {
        return removeKey(aliasName.dup);
    }

    ILocator removeKey(string[] aliasNames) {
        aliasNames.each!(name => removeOne(name));
        return this;
    }

    protected ILocator removeOne(string aliasName) {
        _instances.removeKey(aliasName);
        configuration.removeKey(aliasName);

        return this;
    }
    // #endregion remove

    ILocator clear() {
        _instances = null;
        _options = null;

        return this;
    } 
}
