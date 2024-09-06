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
    mixin(FormThis!());

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
    protected string _schemaclassname; // = Schema.classname;

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
        /* return !_schema.isNull
            ? _schema : _buildSchema(new _schemaClass()); */
        return null;
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
    void data(Json[string] items) {
    }

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
            ? _data[key] : defaultValue;
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
        /* if (eventManager !is null) {
            eventManager(eventManager);
        }
        getEventManager().on(this);  */
    }

    /**
     * Get the Form callbacks this form is interested in.
     *
     * The conventional method map is:
     *
     * - Form.buildValidator: buildValidator
     */
    IEvent[] implementedEvents() {
        /* if (hasMethod(this, "buildValidator")) {
            return [
                BUILD_VALIDATOR_EVENT: "buildValidator",
            ];
        } */
        return null;
    }

    // Used to check if someData passes this form`s validation.
    bool validate(Json[string] data, string validatorName = null) {
        /* _errors = getValidator(validatorName ? validatorName : DEFAULT_VALIDATOR)
            .validate(data);

        return count(_errors) == 0; */
        return false;
    }

    /**
     * Get the errors in the form
     * Will return the errors from the last call to `validate()` or `execute()`.
     */
    Json[string] getErrors() {
        /*  return _errors; */
        return null;
    }

    // Returns validation errors for the given field
    Json getError(string fieldName) {
        /* return _errors.ifNull(fieldName); */
        return Json(null);
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
     */
    void setErrors(Json[string] errors) {
        /* _errors = errors; */
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
        /* _data = someData;
        options.merge("validate", true);
        if (!options.getBoolean("validate")) {
            return _execute(someData);
        }

        auto validator = options.getBoolean("validate") ? DEFAULT_VALIDATOR
            : options.getBoolean("validate");
        return _validate(someData, validator) ? _execute(someData) : false; */
        return false;
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
        /* return fieldName.isNull
            ? _data // null - get all Data
             : Hash.get(_data, field); */
        return Json(null);
    }

    // #region set
    // Saves a variable or an associative array of variables for use inside form data.
        mixin(DataIndexAssign!());
        mixin(SetDataMulti!("IForm"));
        mixin(SetDataSingle!("IForm"));
        IForm set(string key, Json value) {
            _data.set(key, value);
            return this;
        }
        IForm set(string key, Json[] values) {
            _data.set(key, values);
            return this;
        }
        IForm set(string key, Json[string] values) {
            _data.set(key, values);
            return this;
        }
    // #endregion set

    // Get the printable version of a Form instance.
    override Json[string] debugInfo() {
        return super.debugInfo;
        /* .set("_schema", getSchema().debugInfo())
            .set("_errors", getErrors())
            .set("_validator", getValidator().debugInfo()) */
        ;

        // return special + get_object_vars(this);
    }
}
