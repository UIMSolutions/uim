module uim.views.classes.forms.form;

import uim.views;

@safe:

/**
 * Form abstraction used to create forms not tied to ORM backed models,
 * or to other permanent datastores. Ideal for implementing forms on top of
 * API services, or contact forms.
 *
 * ### Building a form
 *
 * This class is most useful when subclassed. In a subclass you
 * should define the `_buildSchema`, `validationDefault` and optionally,
 * the `_execute` methods. These allow you to declare your form`s
 * fields, validation and primary action respectively.
 *
 * Forms are conventionally placed in the `App\Form` namespace.
 *
 * @implements \UIM\Event\IEventDispatcher<\UIM\Form\Form>
 */
class DForm : UIMObject, IForm { // }: IEventListener, IEventDispatcher, IValidatorAware {
    mixin(FormThis!(""));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false; 
        }

        return true;
    }

    // #region Constants
    // Name of default validation set.
    const string DEFAULT_VALIDATOR = "default";

    // The alias this object is assigned to validators as.
    const string VALIDATOR_PROVIDER_NAME = "form";

    // The name of the event dispatched when a validator has been built.
    const string BUILD_VALIDATOR_EVENT = "Form.buildValidator";
    // #endregion Constants

    // DSchema class.
    // TODO protected string _schemaclassname = Schema.classname;

    // #region Schema
    // The schema used by this form.
    protected DSchema _schema = null;

    // Set the schema for this form.
    void schema(DSchema newSchema) {
        _schema = newSchema;
    }

    /**
        * Get the schema for this form.
        *
        * This method will call `_buildSchema()` when the schema
        * is first built. This hook method lets you configure the
        * schema or load a pre-defined one.
        */
    DSchema schema() {
        return !_schema.isNull
            ? _schema : _buildSchema(new _schemaClass());
    }

    /**
        * A hook method intended to be implemented by subclasses.
        *
        * You can use this method to define the schema using
        * the methods on {@link \UIM\Form\Schema}, or loads a pre-defined
        * schema from a concrete class.
        */
    protected DSchema _buildSchema(DSchema tableSchema) {
        return tableSchema;
    }
    // #endregion Schema

    // #region data handling
    protected Json[string] _data;
    IForm set(Json[string] newData) {
        newData.byKeyValue.each!(kv => _data.set(kv.key, kv.value));
        return this;
    }

    @property Json[string] data() {
        return _data.dup;
    }

    bool hasKey(string key) {
        return _data.hasKey(key);
    }

    Json[string] get(string[] keys) {
        Json[string] result;
        keys
            .filter!(key => hasKey(key))
            .each!(key => result[key] = get(key));
        
        return result;
    }

    Json get(string key, Json defaultValue = Json(null)) {
        return _data.hasKey(key)
            ? _data[key]
            : defaultValue;
    }
    // #endregion data handling

    // The errors if any
    // TODO protected Json[string] _errors = null;

    /**
     * Params:
     * \UIM\Event\EventManager|null eventManager The event manager.
     * Defaults to a new instance.
     */
    this(DEventManager eventManager = null) {
        if (eventManager !is null) {
            setEventManager(eventManager);
        }
        getEventManager().on(this);
    }

    /**
     * Get the Form callbacks this form is interested in.
     *
     * The conventional method map is:
     *
     * - Form.buildValidator: buildValidator
     */
    IEvent[] implementedEvents() {
        if (method_hasKey(this, "buildValidator")) {
            return [
                BUILD_VALIDATOR_EVENT: "buildValidator",
            ];
        }
        return null;
    }


    // Used to check if someData passes this form`s validation.
    bool validate(Json[string] data, string validatorName = null) {
       _errors = getValidator(validatorName ? validatorName : DEFAULT_VALIDATOR)
            .validate(data);

        return count(_errors) == 0;
    }
    
    /**
     * Get the errors in the form
     * Will return the errors from the last call to `validate()` or `execute()`.
     */
    Json[string] getErrors() {
        return _errors;
    }

    // Returns validation errors for the given field
    Json getError(string fieldName) {
        return _errors.ifNull(fieldName);
    }
    
    /**
     * Set the errors in the form.
     *
     * ```
     * errors = [
     *    "field_name": ["rule_name": 'message"]
     * ];
     *
     * form.setErrors(errors);
     * ```
     * Params:
     * Json[string] errors Errors list.
     */
    void setErrors(Json[string] errors) {
       _errors = errors;
    }
    
    /**
     * Execute the form if it is valid.
     *
     * First validates the form, then calls the `_execute()` hook method.
     * This hook method can be implemented in subclasses to perform
     * the action of the form. This may be sending email, interacting
     * with a remote API, or anything else you may need.
     *
     * ### Options:
     *
     * - validate: Set to `false` to disable validation. Can also be a string of the validator ruleset to be applied.
     * Defaults to `true`/`"default"`.
     * Params:
     * Json[string] data Form data.
     */
    bool execute(Json[string] data, Json[string] options = null) {
       _data = someData;
        auto updatedOptions = options.update["validate": true.toJson];
        if (!options.getBoolean("validate")) {
            return _execute(someData);
        }

        auto validator = options.getBoolean("validate") ? DEFAULT_VALIDATOR : options.getBoolean("validate");
        return _validate(someData, validator) ? _execute(someData): false;
    }

    /**
     * Hook method to be implemented in subclasses.
     *
     * Used by `execute()` to execute the form`s action.
     */
    protected bool _execute(Json[string] formData) {
        return true;
    }

    // Get field data.
    Json getData(string fieldName = null) {
        if (fieldName.isNull) {
            return _data; // null - get all Data
        }

        return Hash.get(_data, field);
    }
    
    /**
     * Saves a variable or an associative array of variables for use inside form data.
     * Params:
     * string[] aName The key to write, can be a dot notation value.
     * Alternatively can be an array containing key(s) and value(s).
     */
    void set(/* string[] */ string name, Json value = null) {
        set([name: value]);
    }

    // Get the printable version of a Form instance.
    Json[string] debugInfo() {
        auto special = [
            "_schema": getSchema().__debugInfo(),
            "_errors": getErrors(),
            "_validator": getValidator().__debugInfo(),
        ];

        return special + get_object_vars(this);
    }
}
