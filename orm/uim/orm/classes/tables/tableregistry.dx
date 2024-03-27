module uim.orm;

import uim.orm;

@safe:

/*
/**
 * Provides a registry/factory for Table objects.
 *
 * This registry allows you to centralize the configuration for tables
 * their connections and other meta-data.
 *
 * ### Configuring instances
 *
 * You may need to configure your table objects. Using the `TableLocator` you can
 * centralize configuration. Any configuration set before instances are created
 * will be used when creating instances. If you modify configuration after
 * an instance is made, the instances *will not* be updated.
 *
 * ```
 * TableRegistry.getTableLocator().configuration.update("Users", ["table": "my_users"]);
 * ```
 *
 * Configuration data is stored *per alias* if you use the same table with
 * multiple aliases you will need to set configuration multiple times.
 *
 * ### Getting instances
 *
 * You can fetch instances out of the registry through `TableLocator.get()`.
 * One instance is stored per alias. Once an alias is populated the same
 * instance will always be returned. This reduces the ORM memory cost and
 * helps make cyclic references easier to solve.
 *
 * ```
 * mytable = TableRegistry.getTableLocator().get("Users", configData);
 * ```
 */
class DTableRegistry {
    // Returns a singleton instance of ILocator implementation.
    static ILocator getTableLocator() {
        return FactoryLocator.get("Table");
    }
    
    // Sets singleton instance of ILocator implementation.
    static void setTableLocator(ILocator locatorToUse) {
        FactoryLocator.add("Table", locatorToUse);
    }
}
