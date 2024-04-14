module datasources.uim.datasources.classes.entities.registry;

import uim.datasources;

@safe:

// A registry object for Datasource instances.
class DDatasourceRegistry : DObjectRegistry!IDatasource {
    /**
     * Resolve a datasource classname.
     *
     * Part of the template method for UIM\Core\ObjectRegistry.load()
     * /
    protected string _resolveClassName(string className) {
        return App.className(className, "Datasource");
    }
    
    /**
     * Throws an exception when a datasource is missing
     *
     * Part of the template method for UIM\Core\ObjectRegistry.load()
     * Params:
     * @param string plugin The plugin the datasource is missing in.
     * /
    protected void _throwMissingClassError(string className, string aplugin) {
        throw new DMissingDatasourceException([
            "class":  className,
            "plugin": plugin,
        ]);
    }
    
    protected IDatasource _create(Object className, string objectAlias, IData[string] configData) {
        return cast(DClosure)className 
            ? className(objectAlias)
            : className;
    }

    // Remove a single adapter from the registry.
    void unload(string adapterName) {
        unset(_loaded[adapterName]);
    } */
}
auto DatasourceRegistry() { return DDatasourceRegistry.instance; }


    