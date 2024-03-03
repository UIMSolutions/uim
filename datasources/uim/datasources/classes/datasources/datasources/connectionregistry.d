module uim.datasources;

import uim.datasources;

@safe:

// A registry object for connection instances.
class ConnectionRegistry : ObjectRegistry {
    /**
     * Resolve a datasource classname.
     *
     * Part of the template method for UIM\Core\ObjectRegistry.load()
     */
    protected string _resolveClassName(string className) {
        return App.className(className, "Datasource");
    }
    
    /**
     * Throws an exception when a datasource is missing
     *
     * Part of the template method for UIM\Core\ObjectRegistry.load()
     * Params:
     * @param string plugin The plugin the datasource is missing in.
     */
    protected void _throwMissingClassError(string className, string aplugin) {
        throw new MissingDatasourceException([
            "class":  className,
            "plugin": plugin,
        ]);
    }
    
    /**
     * Create the connection object with the correct settings.
     *
     * Part of the template method for UIM\Core\ObjectRegistry.load()
     *
     * If a closure is passed as first argument, The returned value of this
     * auto will be the result from calling the closure.
     */
    protected IConnection _create(string className, string objectAlias, IData[string] configData) {
        configData.remove("className");

        return new className(configData);
    }
    protected IConnection _create(Object className, string objectAlias, IData[string] configData) {
        return cast(Closure)className 
            ? className(objectAlias)
            : className;
    }

    // Remove a single adapter from the registry.
    void unload(string adapterName) {
        unset(_loaded[adapterName]);
    }
}
