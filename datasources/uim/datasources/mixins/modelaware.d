module uim.datasources.mixins.modelaware;

import uim.datasources;

@safe:

/**
 * Provides functionality for loading table classes
 * and other repositories onto properties of the host object.
 *
 * Example users of this template are {@link \UIM\Controller\Controller} and
 * {@link \UIM\Command\Command}.
 */
mixin template TModelAware() {
    /**
     * This object`s primary model class name. Should be a plural form.
     * UIM will not inflect the name.
     *
     * Example: For an object named 'Comments", the modelClass would be 'Comments'.
     * Plugin classes should use `Plugin.Comments` style names to correctly load
     * models from the correct plugin.
     *
     * Use empty string to not use auto-loading on this object. Null auto-detects based on
     * controller name.
     */
    protected string amodelClass = null;

    // A list of overridden model factory functions.
    protected ILocator[] _modelFactories = null;

    // The model type to use.
    protected string _modelType = "Table";

    /**
     * Set the modelClass property based on conventions.
     *
     * If the property is already set it will not be overwritten
     * Params:
     * string aName Class name.
     */
    protected void _setModelClass(string aName) {
        if (this.modelClass.isNull) {
            this.modelClass = aName;
        }
    }
    
    /**
     * Fetch or construct a model instance from a locator.
     *
     * Uses a modelFactory based on `modelType` to fetch and construct a `IRepository`
     * and return it. The default `modelType` can be defined with `setModelType()`.
     *
     * Unlike `loadModel()` this method will *not* set an object property.
     *
     * If a repository provider does not return an object a MissingModelException will
     * be thrown.
     * Params:
     * string modelClass Name of model class to load. Defaults to this.modelClass.
     * The name can be an alias like `'Post'` or FQCN like `App\Model\Table\PostsTable.classname`.
     * @param string modelType The type of repository to load. Defaults to the getModelType() value.
     */
    IRepository fetchModel(string amodelClass = null, string amodelType = null) {
        modelClass ??= this.modelClass;
        if (isEmpty(modelClass)) {
            throw new DUnexpectedValueException("Default modelClass is empty");
        }
        modelType ??= getModelType();

        auto options = null;
        if (indexOf(modelClass, "\\") == false) {
            [, alias] = pluginSplit(modelClass, true);
        } else {
            options["className"] = modelClass;
            /** @psalm-suppress PossiblyFalseOperand */
            alias = substr(
                modelClass,
                indexOf(modelClass, "\\") + 1,
                -modelType.length
            );
            modelClass = alias;
        }
        factory = _modelFactories[modelType] ?? FactoryLocator.get(modelType);

        anInstance = cast(ILocator)factory
            ? factory.get(modelClass, options)
            : factory(modelClass, options);

        if (anInstance) {
            return anInstance;
        }
        throw new DMissingModelException([modelClass, modelType]);
    }
    
    /**
     * Override a existing callable to generate repositories of a given type.
     * Params:
     * string atype The name of the repository type the factory bool is for.
     * @param \UIM\Datasource\Locator\ILocator|callable factory The factory auto used to create instances.
     */
    void modelFactory(string atype, ILocator|callable factory) {
       _modelFactories[type] = factory;
    }
    
    mixin(TProperty!("string", "modelType")); */
} 
