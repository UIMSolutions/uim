/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.datasources.connections.registry;

@safe:
import uim.datasources;

// A registry object for connection instances.
class DDSConnectionRegistry : ObjectRegistry {
    /**
     * Resolve a datasource classname.
     *
     * Part of the template method for Cake\Core\ObjectRegistry::load()
     *
     * @param string myClass Partial classname to resolve.
     * @return string|null Either the correct class name or null.
     */
    /* protected Nullable!string _resolveClassName(string myClass) {
        return App::className(myClass, "Datasource");
    } */

    /**
     * Throws an exception when a datasource is missing
     *
     * Part of the template method for Cake\Core\ObjectRegistry::load()
     *
     * @param string myClass The classname that is missing.
     * @param string|null myPlugin The plugin the datasource is missing in.
     * @throws \Cake\Datasource\Exception\MissingDatasourceException
     */
    protected void _throwMissingClassError(string className, string pluginName) {
        throw new MissingDatasourceException([
            "class": className,
            "plugin": pluginName,
        ]);
    }

    /**
     * Create the connection object with the correct settings.
     *
     * Part of the template method for Cake\Core\ObjectRegistry::load()
     *
     * If a callable is passed as first argument, The returned value of this
     * function will be the result of the callable.
     *
     * @param \Cake\Datasource\IConnection|callable|string myClass The classname or object to make.
     * @param string aliasName The alias of the object.
     * @param array<string, mixed> myConfig An array of settings to use for the datasource.
     * returns IConnection A connection with the correct settings.
     */
    protected IConnection _create(myClass, string aliasName, array myConfig) {
        if (is_callable(myClass)) {
            return myClass(myAlias);
        }

        if (is_object(myClass)) {
            return myClass;
        }

        unset(myConfig["className"]);

        return new myClass(myConfig);
    }

    /**
     * Remove a single adapter from the registry.
     * aName - The adapter name.
     */
    /* DDSConnectionRegistry unload(string aName) {
        unset(_loaded[aName]);

        return this;
    } */
}
