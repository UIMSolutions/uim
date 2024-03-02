/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.orm.tableregistry;

@safe:
import uim.orm;

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
 * TableRegistry::getTableLocator().setConfig("Users", ["table": "my_users"]);
 *
 * // Prior to 3.6.0
 * TableRegistry::config("Users", ["table": "my_users"]);
 * ```
 *
 * Configuration data is stored *per alias* if you use the same table with
 * multiple aliases you will need to set configuration multiple times.
 *
 * ### Getting instances
 *
 * You can fetch instances out of the registry through `TableLocator::get()`.
 * One instance is stored per alias. Once an alias is populated the same
 * instance will always be returned. This reduces the ORM memory cost and
 * helps make cyclic references easier to solve.
 *
 * ```
 * table = TableRegistry::getTableLocator().get("Users", aConfig);
 *
 * // Prior to 3.6.0
 * table = TableRegistry::get("Users", aConfig);
 * ```
 */
class TableRegistry {
    // Returns a singleton instance of ILocatorimplementation.
    static ILocator getTableLocator() {
        return FactoryLocator::get("Table");
    }

    /**
     * Sets singleton instance of ILocatorimplementation.
     *
     * @param DORMLocator\ILocator tableLocator Instance of a locator to use.
     */
    static void setTableLocator(ILocator tableLocator) {
        FactoryLocator::add("Table", tableLocator);
    }

    /**
     * Set an instance.
     *
     * @param string anAliasName The alias to set.
     * @param DORMTable object The table to set.
     * @return DORMTable
     * @deprecated 3.6.0 Use {@link DORMLocator\TableLocator::set()} instead. Will be removed in 5.0
     */
    static function set(string anAliasName, Table object): Table
    {
        return getTableLocator().set(alias, object);
    }

    /**
     * Removes an instance from the registry.
     *
     * @param string anAliasName The alias to remove.
     * @return void
     * @deprecated 3.6.0 Use {@link DORMLocator\TableLocator::remove()} instead. Will be removed in 5.0
     */
    static void remove(string anAliasName) {
        getTableLocator().remove(alias);
    }

    /**
     * Clears the registry of configuration and instances.
     *
     * @return void
     * @deprecated 3.6.0 Use {@link DORMLocator\TableLocator::clear()} instead. Will be removed in 5.0
     */
    static void clear() {
        getTableLocator().clear();
    }
}
