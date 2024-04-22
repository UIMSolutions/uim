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
class DForm : IForm { // }: IEventListener, IEventDispatcher, IValidatorAware {
    mixin TConfigurable;

    this() {
        initialize;
    }

    this(IData[string] initData) {
        initialize(initData);
    }

    this(string newName) {
        this();
        this.name(newName);
    }

    bool initialize(IData[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));

    // #region Constants
        // Name of default validation set.
        const string DEFAULT_VALIDATOR = "default";

        // The alias this object is assigned to validators as.
        const string VALIDATOR_PROVIDER_NAME = "form";

        // The name of the event dispatched when a validator has been built.
        const string BUILD_VALIDATOR_EVENT = "Form.buildValidator";
    // #endregion Constants

    // DSchema class.
    protected string _schemaClassname = Schema.className;
    
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
                ? _schema 
                : _buildSchema(new _schemaClass());
        }

        /**
        * A hook method intended to be implemented by subclasses.
        *
        * You can use this method to define the schema using
        * the methods on {@link \UIM\Form\Schema}, or loads a pre-defined
        * schema from a concrete class.
        */
        protected DSchema _buildSchema(Schema tableSchema) {
            return tableSchema;
        }
    // #endregion Schema

    // #region data handling
    protected IData[string] _data;
    /* 
    void set(IData[string] newData) {        
        newData.byKeyValue 
            .each!(kv => _data = Hash.insert(_data, kv.key, kv.value));
        }
    }
    */

        @property IData[string] data() {
        return _data.dup;
        }

        @property void data(IData[string] data) {
        _data = data.dup;
        }
    // #endregion data handling

    // The errors if any
    // TODO // TODO protected array _errors = null;

    /**
     * Constructor
     * Params:
     * \UIM\Event\EventManager|null eventManager The event manager.
     * Defaults to a new instance.
     * /
    this(EventManager eventManager = null) {
        if (eventManager !isNull) {
            this.setEventManager(eventManager);
        }
        this.getEventManager().on(this);
    }

    /**
     * Get the Form callbacks this form is interested in.
     *
     * The conventional method map is:
     *
     * - Form.buildValidator: buildValidator
     * /
    IEvent[] implementedEvents() {
        if (method_exists(this, "buildValidator")) {
            return [
                self.BUILD_VALIDATOR_EVENT: "buildValidator",
            ];
        }
        return null;
    }


    /**
     * Used to check if someData passes this form`s validation.
     * Params:
     * IData[string] data The data to check.
     * @param string validator Validator name.
     * /
    bool validate(IData[string] data, string avalidator = null) {
       _errors = this.getValidator(validator ?: DEFAULT_VALIDATOR)
            .validate(someData);

        return count(_errors) == 0;
    }
    
    /**
     * Get the errors in the form
     *
     * Will return the errors from the last call
     * to `validate()` or `execute()`.
     * /
    array getErrors() {
        return _errors;
    }

    // Returns validation errors for the given field
    array getError(string fieldName) {
        return _errors[fieldName] ? _errors[fieldName] : null;
    }
    
    /**
     * Set the errors in the form.
     *
     * ```
     * errors = [
     *     "field_name": ["rule_name": 'message"]
     * ];
     *
     * form.setErrors(errors);
     * ```
     * Params:
     * array errors Errors list.
     * /
    void setErrors(array errors) {
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
     *  Defaults to `true`/`"default"`.
     * Params:
     * IData[string] data Form data.
     * @param IData[string] options List of options.
     * /
    bool execute(IData[string] data, IData[string] options = null) {
       _data = someData;

        options = options.update["validate": BooleanData(true)];

        if (options["validate"] == false) {
            return _execute(someData);
        }
        validator = options["validate"] == true ? DEFAULT_VALIDATOR : options["validate"];

        return _validate(someData, validator) ? _execute(someData): false;
    }

    /**
     * Hook method to be implemented in subclasses.
     *
     * Used by `execute()` to execute the form`s action.
     * /
    protected bool _execute(array formData) {
        return true;
    }

    // Get field data.
    IData getData(string fieldName = null) {
        if (fieldName is null) {
            return _data; // null - get all Data
        }

        return Hash.get(_data, field);
    }
    
    /**
     * Saves a variable or an associative array of variables for use inside form data.
     * Params:
     * string[] aName The key to write, can be a dot notation value.
     * Alternatively can be an array containing key(s) and value(s).
     * @param IData aValue Value to set for var
     * /
    void set(string aName, IData aValue = null) {
        set([aName: aValue]);
    }
    

    // Get the printable version of a Form instance.
    STRINGAA debugInfo() {
        special = [
            '_schema": this.getSchema().__debugInfo(),
            '_errors": this.getErrors(),
            '_validator": this.getValidator().__debugInfo(),
        ];

        return special + get_object_vars(this);
    } */
}
