module uim.orm.interfaces.locator;

import uim.orm;

@safe:

// Registries for Table objects should implement this interface.
interface ILocator { // }: BaseILocator {
    // Returns configuration for an alias or the full configuration array for all aliases. 
    Json[string] getConfig(string aliasName = null);

    /**
     * Stores a list of options to be used when instantiating an object
     * with a matching alias.
     */
    // ILocator configuration.set(string[] aliasNames...);
    // ILocator configuration.set(string aliasName, Json[string] options = null);
    ILocator setConfiguration(string[] aliasNames, Json[string] options = null);

    // Get a table instance from the registry.
    DORMTable get(string aliasName, Json[string] options = null);

    // Set a table instance.
    DORMTable set(string aliasName, IRepository repository);
}