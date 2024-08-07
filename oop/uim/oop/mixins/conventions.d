module uim.oop.mixins.conventions;

import uim.oop;

@safe:

// Provides methods that allow other classes access to conventions based inflections.
mixin template TConventions() {
    /*
    // Creates a fixture name
    protected string _fixtureName(string modelclassname) {
        return modelclassname.camelize;
    }
    
    //  Creates the proper entity name (singular) for the specified name
    protected string _entityName(string modelName) {
        return Inflector.singularize(modelName.camelize);
    }
    
    /**
     * Creates the proper underscored model key for associations
     *
     * If the input contains a dot, assume that the right side is the real table name.
     */
    protected string _modelKey(string modelclassname) {
        // TODO [, name] = pluginSplit(modelclassname);    
        // return Inflector.singularize(name).underscore ~ "_id";
        return null; 
    }
    
    // Creates the proper model name from a foreign key
    protected string _modelNameFromKey(string foreignKeys) {
        aKey = aKey.replace("_id", "");

        return Inflector.pluralize(aKey).camelize;
    }
    
    // Creates the singular name for use in views.
    protected string _singularName(string aName) {
        return Inflector.variable(Inflector.singularize(name));
    }
    
    // Creates the plural variable name for views
    protected string _variableName(string aName) {
        return Inflector.variable(name);
    }
    
    /**
     * Creates the singular human name used in views
     * Params:
     * string aName Controller name
     */
    protected string _singularHumanName(string aName) {
        return Inflector.underscore(Inflector.singularize(name)).humanize;
    }
    
    // Creates a camelized version of name
    protected string _camelize(string aName) {
        return name.camelize;
    }
    
    // Creates the plural human name used in views
    protected string _pluralHumanName(string controllerName) {
        return Inflector.underscore(controllerName).humanize;
    }
    
    // Find the correct path for a plugin. Scans pluginPaths for the plugin you want.
    protected string _pluginPath(string pluginName) {
        if (Plugin.isLoaded(pluginName)) {
            return Plugin.path(pluginName);
        }
        return currentValue(App.path("plugins")) ~ pluginName ~ DIRECTORY_SEPARATOR;
    }
    
    // Return plugin`s namespace
    protected string _pluginNamespace(string pluginName) {
        return pluginName.replace("/", "\\", pluginName);
    } 
}
