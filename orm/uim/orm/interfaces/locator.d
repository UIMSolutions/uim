module uim.orm.interfaces.locator;

import uim.orm;

@safe:

// Registries for Table objects should implement this interface.
interface ILocator { // }: BaseILocator {
    /**
     * Returns configuration for an alias or the full configuration array for
     * all aliases.
     * Params:
     * string aliasName Alias to get config for, null for complete config.
     */
    Json[string] getConfig(string aliasName = null);

    /**
     * Stores a list of options to be used when instantiating an object
     * with a matching alias.
     */
    // ILocator configuration.update(string[] aliasNames...);
    // ILocator configuration.update(string aliasName, Json[string] options = null);
    ILocator configuration.update(string[] aliasNames, Json[string] options = null);

    /**
     * Get a table instance from the registry.
     * Params:
     * string aliasName The alias name you want to get.
     * @param Json[string] options The options you want to build the table with.
     */
    Table get(string aliasName, Json[string] options = null);

    /**
     * Set a table instance.
     * Params:
     * string aliasName The alias to set.
     * @param \ORM\Table myrepository The table to set.
     */
    Table set(string aliasName, IRepository myrepository);
    */
}