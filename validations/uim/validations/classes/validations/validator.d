module uim.validations.classes.validations.validator;

import uim.validations;

@safe:

/**
 * Validator object encapsulates all methods related to data validations for a model
 * It also provides an API to dynamically change validation rules for each model field.
 *
 * : ArrayAccess to easily modify rules in the set
 * @template-implements \ArrayAccess<string, \UIM\Validation\ValidationSet>
 * @template-implements \IteratorAggregate<string, \UIM\Validation\ValidationSet>
 */
class DValidator { // }: ArrayAccess, IteratorAggregate, Countable {
    // By using "create" you can make fields required when records are first created.
    const string WHEN_CREATE = "create";

    // By using "update", you can make fields required when they are updated.
    const string WHEN_UPDATE = "update";

    // Used to flag nested rules created with addNested() and addNestedMany()
    const string NESTED = "_nested";

    // A flag for allowEmptyFor()
    // When `null` is given, it will be recognized as empty.
    const int EMPTY_NULL = 0;

    // A flag for allowEmptyFor()
    // When an empty string is given, it will be recognized as empty.
    const int EMPTY_STRING = 1;

    // A flag for allowEmptyFor()
    // When an empty array is given, it will be recognized as empty.
    const int EMPTY_ARRAY = 2;

    /**
     * Contains the validation messages associated with checking the presence
     * for each corresponding field.
     */
    protected STRINGAA _presenceMessages = null;

    // Whether to use I18n functions for translating default error messages
    protected bool _useI18n = false;

    /**
     * A flag for allowEmptyFor()
     *
     * The return value of \Psr\Http\Message\IUploadedFile.getError()
     * method must be equal to `UPLOAD_ERR_NO_FILE`.
     */
    const int EMPTY_FILE = 4;

    /**
     * A flag for allowEmptyFor()
     *
     * When an array is given, if it contains the `year` key, and only empty strings
     * or null values, it will be recognized as empty.
     */
    const int EMPTY_DATE = 8;

    /**
     * A flag for allowEmptyFor()
     *
     * When an array is given, if it contains the `hour` key, and only empty strings
     * or null values, it will be recognized as empty.
     */
    const int EMPTY_TIME = 16;

    // Holds the ValidationSet objects array
    protected DValidationSet[string] _fields = null;

    // Contains the validation messages associated with checking the emptiness
    // for each corresponding field.
    protected STRINGAA _allowEmptyMessages = null;

    // Contains the flags which specify what is empty for each corresponding field.
    protected int[string] _allowEmptyFlags = null;

    // A combination of the all EMPTY_* flags
    const int EMPTY_ALL = EMPTY_STRING
        | EMPTY_ARRAY
        | EMPTY_FILE
        | EMPTY_DATE
        | EMPTY_TIME;

    /**
     * An associative array of objects or classes containing methods
     * used for validation
     *
     * @var array<string,  object  string>
     * @psalm-var array<string, object|class-string>
     */
    protected Json[string] _providers = null;

    /**
     * An associative array of objects or classes used as a default provider list
     *
     * @var array<string, object string>
     * @psalm-var array<string, object|class-string>
     */
    protected static Json[string] _defaultProviders = null;

    // Whether to apply last flag to generated rule(s).
    protected bool _stopOnFailure = false;

    this() {
        /* _useI18n = function_exists("\\UIM\\I18n\\__d");
        _providers = _defaultProviders; */
    }

    /**
     * Whether to stop validation rule evaluation on the first failed rule.
     *
     * When enabled the first failing rule per field will cause validation to stop.
     * When disabled all rules will be run even if there are failures.
     * Params:
     * bool mystopOnFailure If to apply last flag.
     */
    void setStopOnFailure(bool mystopOnFailure = true) {
        _stopOnFailure = mystopOnFailure;
    }

    // Validates and returns an array of failed fields and their error messages.
    array<array> validate(Json[string] data, bool isNewRecord = true) {
        auto myerrors = null;
        foreach (myname, fieldName; _fields) {
            myname = to!string(myname);
            mykeyPresent = array_key_exists(myname, mydata);

            myproviders = _providers;
            context = compact("data", "newRecord", "field", "providers");

            if (!mykeyPresent && !_checkPresence(fieldName, context)) {
                myerrors[myname]["_required"] = getRequiredMessage(myname);
                continue;
            }
            if (!mykeyPresent) {
                continue;
            }
            mycanBeEmpty = _canBeEmpty(fieldName, context);

            myflags = EMPTY_NULL;
            if (_allowEmptyFlags.hasKey(myname)) {
                myflags = _allowEmptyFlags[myname];
            }
            myisEmpty = this.isEmpty(mydata[myname], myflags);

            if (!mycanBeEmpty && myisEmpty) {
                myerrors[myname]["_empty"] = getNotEmptyMessage(myname);
                continue;
            }
            if (myisEmpty) {
                continue;
            }
            result = _processRules(myname, fieldName, mydata, isNewRecord);
            if (result) {
                myerrors[myname] = result;
            }
        }
        return myerrors;
    }
    
    /**
     * Returns a ValidationSet object containing all validation rules for a field, if
     * passed a ValidationSet as second argument, it will replace any other rule set defined
     * before
     */
    DValidationSet field(string fieldname, DValidationSet validationSet = null) {
        /* if (!_fields.has(fieldname)) {
            /* validationSet = validationSet ?: new DValidationSet();
           _fields[fieldname] = validationSet; * /
        }
        return _fields[fieldname]; */
        return null;
    }

    // Check whether a validator contains any rules for the given field.
    bool hasField(string fieldName) {
        return _fields.hasKey(fieldName);
    }

    /**
     * Associates an object to a name so it can be used as a provider. Providers are
     * objects or class names that can contain methods used during validation of for
     * deciding whether a validation rule can be applied. All validation methods,
     * when called will receive the full list of providers stored in this validator.
     * Params:
     * string myname The name under which the provider should be set.
     * @param /* object * / string myobject Provider object or class name.
     * @psalm-param object|class-string myobject
     */
    void setProvider(string myname, /* object */ string myobject) {
        _providers[myname] = myobject;
    }

    /**
     * Returns the provider stored under that name if it exists.
     * Params:
     * string myname The name under which the provider should be set.
     */
    /* object */
    string getProvider(string myname) {
        /*         if (_providers.hasKey(myname)) {
            return _providers[myname];
        }
        if (myname != "default") {
            return null;
        }
        _providers[myname] = new DRulesProvider();

        return _providers[myname]; */
        return null;
    }

    /**
     * Returns the default provider stored under that name if it exists.
     * Params:
     * string myname The name under which the provider should be retrieved.
     */
    static  /* object */ string getDefaultProvider(string myname) {
        // return _defaultProviders.get(myname);
        return null;
    }

    /**
     * Associates an object to a name so it can be used as a default provider.
     * Params:
     * string myname The name under which the provider should be set.
     * @param /* object * / string myobject Provider object or class name.
     * @psalm-param object|class-string myobject
     */
    static void addDefaultProvider(string myname, /* object */ string myobject) {
        _defaultProviders[myname] = myobject;
    }

    // Get the list of default providers.
    static string[] getDefaultProviders() {
        return _defaultProviders.keys;
    }

    // Get the list of providers in this validator.
    string[] providers() {
        return _providers.keys;
    }

    // Returns whether a rule set is defined for a field or not
    bool offsetExists(Json fieldName) {
        // return _fields.getBoolean(fieldName);
        return false;
    }

    // Returns the rule set for a field
    DValidationSet offsetGet(string fieldName) {
        // return _field(fieldName);
        return null;
    }

    // Sets the rule set for a field
    void offsetSet(string fieldName, DValidationSet rules) {
        auto myset = new DValidationSet();
        /*     rules.byKeyValue.each!(nameRule => myset.add(nameRule.key, nameRule.value));
            myrules = rules;
        */
    }

    void offsetSet(string fieldName, Json myrules) {
        // TODO _fields[fieldName] = myrules;
    }

    // Unsets the rule set for a field
    void offsetUnset(Json fieldName) {
        _fields.remove(fieldName);
    }

    // Returns an iterator for each of the fields to be validated
    Traversable<string, DValidationSet> getIterator() {
        return new DArrayIterator(_fields);
    }
    
    // Returns the number of fields having validation rules
    size_t count() {
        // TODO return count(_fields);
        return 0;
    }

    /**
     * Adds a new rule to a field"s rule set. If second argument is an array
     * then rules list for the field will be replaced with second argument and
     * third argument will be ignored.
     *
     * ### Example:
     *
     * ```
     *    myvalidator
     *        .add("title", "required", ["rule": "notBlank"])
     *        .add("user_id", "valid", ["rule": "numeric", "message": "Invalid User"])
     *
     *    myvalidator.add("password", [
     *        "size": ["rule": ["lengthBetween", 8, 20]],
     *        "hasSpecialCharacter": ["rule": "validateSpecialchar", "message": "not valid"]
     *    ]);
     * ```
     * Params:
     * string fieldName The name of the field from which the rule will be added
     * @param string[] myname The alias for a single rule or multiple rules array
     * @param \UIM\Validation\ValidationRule|array myrule the rule to add
     */
    /*     auto add(string fieldName, string[] myname, ValidationRule[] rules= null) {
    }
 */
    void add(string fieldName, string[] myname, DValidationRule[] rules = null) {
        // TODO auto myvalidationSet = this.field(fieldName);

        /*         if (!isArray(myname)) {
            rules = [myname: myrule];
        } else {
            rules = myname;
        }
        rules.byKeyValue
            .each!((nameRule) {
                if (isArray(nameRule.value)) {
                    nameRule.value += [
                        "rule": nameRule.key,
                        "last": _stopOnFailure,
                    ];
                }
                if (!isString(nameRule.key)) {
                    throw new DInvalidArgumentException(
                        "You cannot add validation rules without a `name` key. Update rules array to have string keys."
                    );
                }
                myvalidationSet.add(nameRule.key, nameRule.value);
            });
 */
    }

    /**
     * Adds a nested validator.
     *
     * Nesting validators allows you to define validators for array
     * types. For example, nested validators are ideal when you want to validate a
     * sub-document, or complex array type.
     *
     * This method assumes that the sub-document has a 1:1 relationship with the parent.
     *
     * The providers of the parent validator will be synced into the nested validator, when
     * errors are checked. This ensures that any validation rule providers connected
     * in the parent will have the same values in the nested validator when rules are evaluated.
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto addNested(
        string rootfieldName,
        DValidator validator,
        string errorMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        /* Json[string] myextra = array_filter(["message": errorMessage, "on": mywhen]);

        auto myvalidationSet = this.field(rootfieldName); */
        /* myvalidationSet.add(NESTED, myextra ~ ["rule": auto (myvalue, context) use (validator, errorMessage) {
            if (!isArray(myvalue)) {
                return false;
            }
            providers().each!(name => validator.setProvider(name, getProvider(name)));
            myerrors = validator.validate(myvalue, context["newRecord"]);

            errorMessage = errorMessage ? [NESTED: errorMessage] : [];
            return myerrors.isEmpty ? true : myerrors + errorMessage;
        }]); */

        return this;
    }

    /**
     * Adds a nested validator.
     *
     * Nesting validators allows you to define validators for array
     * types. For example, nested validators are ideal when you want to validate many
     * similar sub-documents or complex array types.
     *
     * This method assumes that the sub-document has a 1:N relationship with the parent.
     *
     * The providers of the parent validator will be synced into the nested validator, when
     * errors are checked. This ensures that any validation rule providers connected
     * in the parent will have the same values in the nested validator when rules are evaluated.
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    void addNestedMany(
        string rootFieldName,
        DValidator myvalidator,
        string errorMessage = null, 
        /*Closure|*/ string mywhen = null
    ) {
        /* Json[string] myextra = array_filter(["message": errorMessage, "on": mywhen]);

        auto myvalidationSet = this.field(rootFieldName); */
        /*         myvalidationSet.add(NESTED, myextra ~ ["rule": auto (myvalue, context) use (myvalidator, errorMessage) {
            if (!isArray(myvalue)) { return false; }

            providers().each!((name) {
                auto myprovider = getProvider(name);
                myvalidator.setProvider(name, myprovider);
            });

            auto myerrors = null;
            foreach (myi: myrow; myvalue) {
                if (!isArray(myrow)) {
                    return false;
                }
                mycheck = myvalidator.validate(myrow, context["newRecord"]);
                if (!mycheck.isEmpty) {
                    myerrors[myi] = mycheck;
                }
            }
            errorMessage = errorMessage ? [NESTED: errorMessage] : [];
            return myerrors.isEmpty ? true : myerrors + errorMessage;
        }]);
 */
    }

    /**
     * Removes a rule from the set by its name
     *
     * ### Example:
     *
     * ```
     *    myvalidator
     *        .remove("title", "required")
     *        .remove("user_id")
     * ```
     * Params:
     * string fieldName The name of the field from which the rule will be removed
     * @param string myrule the name of the rule to be removed
     */
    void remove(string fieldName, string myrule = null) {
        if (myrule.isNull) {
            _fields.remove(fieldName);
        } else {
            field(fieldName).remove(myrule);
        }
    }

    /**
     * Sets whether a field is required to be present in data array.
     * You can also pass array. Using an array will let you provide the following
     * keys:
     *
     * - `mode` individual mode for field
     * - `message` individual error message for field
     *
     * You can also set mode and message for all passed fields, the individual
     * setting takes precedence over group settings.
     * Params:
     * array<string|int, mixed>|string fieldName the name of the field or list of fields.
     * @param \/*Closure|* / string mymode Valid values are true, false, "create", "update".
     * If a Closure is passed then the field will be required only when the callback
     * returns true.
     */
    void requirePresence(string[] fieldName, /*Closure|*/ string mymode /*  = true */ , string message = null) {
        /* mydefaults = [
            "mode": mymode,
            "message": errorMessage,
        ]; */

        /*         if (!isArray(fieldName)) {
            fieldName = _convertValidatorToArray((string)fieldName, mydefaults);
        }
 */ /*         foreach (fieldName as fieldName: mysetting) {
            mysettings = _convertValidatorToArray((string)fieldName, mydefaults, mysetting);
            string fieldName = currentValue(mysettings.keys);

            this.field((string)fieldName).requirePresence(mysettings[fieldName]["mode"]);
            if (mysettings[fieldName]["message"]) {
               _presenceMessages[fieldName] = mysettings[fieldName]["message"];
            }
        }
 */
    }

    /**
     * Low-level method to indicate that a field can be empty.
     *
     * This method should generally not be used, and instead you should
     * use:
     *
     * - `allowEmptyString()`
     * - `allowEmptyArray()`
     * - `allowEmptyFile()`
     * - `allowEmptyDate()`
     * - `allowEmptyDatetime()`
     * - `allowEmptyTime()`
     *
     * Should be used as their APIs are simpler to operate and read.
     *
     * You can also set flags, when and message for all passed fields, the individual
     * setting takes precedence over group settings.
     *
     * ### Example:
     *
     * Email can be empty
     * myvalidator.allowEmptyFor("email", Validator.EMPTY_STRING);
     *
     * Email can be empty on create
     * myvalidator.allowEmptyFor("email", Validator.EMPTY_STRING, Validator.WHEN_CREATE);
     *
     * Email can be empty on update
     * myvalidator.allowEmptyFor("email", Validator.EMPTY_STRING, Validator.WHEN_UPDATE);
     *
     * It is possible to conditionally allow emptiness on a field by passing a callback
     * as a second argument. The callback will receive the validation context array as
     * argument:
     *
     * myvalidator.allowEmpty("email", Validator.EMPTY_STRING, auto (context) {
     * return !context["newRecord"] || context["data.role"] == "admin";
     * });
     *
     * If you want to allow other kind of empty data on a field, you need to pass other
     * flags:
     *
     * myvalidator.allowEmptyFor("photo", Validator.EMPTY_FILE);
     * myvalidator.allowEmptyFor("published", Validator.EMPTY_STRING | Validator.EMPTY_DATE | Validator.EMPTY_TIME);
     * myvalidator.allowEmptyFor("items", Validator.EMPTY_STRING | Validator.EMPTY_ARRAY);
     *
     * You can also use convenience wrappers of this method. The following calls are the
     * same as above:
     *
     * myvalidator.allowEmptyFile("photo");
     * myvalidator.allowEmptyDateTime("published");
     * myvalidator.allowEmptyArray("items");
     * Params:
     * @param int myflags A bitmask of EMPTY_* flags which specify what is empty.
     * If no flags/bitmask is provided only `null` will be allowed as empty value.
     * @param \/*Closure|* / string mywhen Indicates when the field is allowed to be empty
     * Valid values are true, false, "create", "update". If a Closure is passed then
     * the field will allowed to be empty only when the callback returns true.
     */
    void allowEmptyFor(
        string fieldName,
        ulong flags = 0, /*Closure|*/
        string when = null  /*  = true */ ,
        string message = null
    ) {
        field(fieldName).allowEmpty(when);
        if (message) {
            _allowEmptyMessages[fieldName] = message;
        }
        /* if (myflags !is null) {
            _allowEmptyFlags[fieldName] = myflags;
        } */
    }

    /**
     * Allows a field to be an empty string.
     *
     * This method is equivalent to calling allowEmptyFor() with EMPTY_STRING flag.
     * Params:
     * @param \/*Closure|* / string mywhen Indicates when the field is allowed to be empty
     * Valid values are true, false, "create", "update". If a Closure is passed then
     * the field will allowed to be empty only when the callback returns true.
     */
    void allowEmptyString(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen /*  = true */ ) {
        // TODO return _allowEmptyFor(fieldName, EMPTY_STRING, mywhen, errorMessage);
    }

    /**
     * Requires a field to not be an empty string.
     *
     * Opposite to allowEmptyString()
     * Params:
     * @param \/*Closure|* / string mywhen Indicates when the field is not allowed
     * to be empty. Valid values are false (never), "create", "update". If a
     * Closure is passed then the field will be required to be not empty when
     * the callback returns true.
     */
    void notEmptyString(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen /*  = false */ ) {
        mywhen = invertWhenClause(mywhen);
        // TODO return _allowEmptyFor(fieldName, EMPTY_STRING, mywhen, errorMessage);
    }

    /**
     * Allows a field to be an empty array.
     *
     * This method is equivalent to calling allowEmptyFor() with EMPTY_STRING +
     * EMPTY_ARRAY flags.
     * Params:
     * @param \/*Closure|* / string mywhen Indicates when the field is allowed to be empty
     * Valid values are true, false, "create", "update". If a Closure is passed then
     * the field will allowed to be empty only when the callback returns true.
     */
    void allowEmptyArray(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen /*  = true */ ) {
        // TODO return _allowEmptyFor(fieldName, EMPTY_STRING | EMPTY_ARRAY, mywhen, errorMessage);
    }

    /**
     * Require a field to be a non-empty array
     *
     * Opposite to allowEmptyArray()
     * Params:
     * @param \/*Closure|* / string mywhen Indicates when the field is not allowed
     * to be empty. Valid values are false (never), "create", "update". If a
     * Closure is passed then the field will be required to be not empty when
     * the callback returns true.
     */
    void notEmptyArray(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen /*  = false */ ) {
        mywhen = invertWhenClause(mywhen);

        // TODO return _allowEmptyFor(fieldName, EMPTY_STRING | EMPTY_ARRAY, mywhen, errorMessage);
    }

    /**
     * Allows a field to be an empty file.
     *
     * This method is equivalent to calling allowEmptyFor() with EMPTY_FILE flag.
     * File fields will not accept `""`, or `[]` as empty values. Only `null` and a file
     * upload with `error` equal to `UPLOAD_ERR_NO_FILE` will be treated as empty.
     * Params:
     * @param \/*Closure|* / string mywhen Indicates when the field is allowed to be empty
     * Valid values are true, "create", "update". If a Closure is passed then
     * the field will allowed to be empty only when the callback returns true.
     */
    void allowEmptyFile(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen /*  = true */ ) {
        // TODO return _allowEmptyFor(fieldName, EMPTY_FILE, mywhen, errorMessage);
    }

    /**
     * Require a field to be a not-empty file.
     *
     * Opposite to allowEmptyFile()
     * Params:
     * @param \/*Closure|* / string mywhen Indicates when the field is not allowed
     * to be empty. Valid values are false (never), "create", "update". If a
     * Closure is passed then the field will be required to be not empty when
     * the callback returns true.
     */
    auto notEmptyFile(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen /*  = false */ ) {
        mywhen = invertWhenClause(mywhen);

        // TODO return _allowEmptyFor(fieldName, EMPTY_FILE, mywhen, errorMessage);
    }

    /**
     * Allows a field to be an empty date.
     *
     * Empty date values are `null`, `""`, `[]` and arrays where all values are `""`
     * and the `year` key is present.
     * Params:
     * @param \/*Closure|* / string mywhen Indicates when the field is allowed to be empty
     * Valid values are true, false, "create", "update". If a Closure is passed then
     * the field will allowed to be empty only when the callback returns true.
     */
    auto allowEmptyDate(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen /*  = true */ ) {
        // TODO return _allowEmptyFor(fieldName, EMPTY_STRING | EMPTY_DATE, mywhen, errorMessage);
    }

    /**
     * Require a non-empty date value
     * Params:
     * @param \/*Closure|* / string mywhen Indicates when the field is not allowed
     * to be empty. Valid values are false (never), "create", "update". If a
     * Closure is passed then the field will be required to be not empty when
     * the callback returns true.
     * @return this
     */
    auto notEmptyDate(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen /*  = false */ ) {
        mywhen = invertWhenClause(mywhen);

        // TODO return _allowEmptyFor(fieldName, EMPTY_STRING | EMPTY_DATE, mywhen, errorMessage);
    }

    /**
     * Allows a field to be an empty time.
     *
     * Empty date values are `null`, `""`, `[]` and arrays where all values are `""`
     * and the `hour` key is present.
     *
     * This method is equivalent to calling allowEmptyFor() with EMPTY_STRING +
     * EMPTY_TIME flags.
     * Params:
     * @param \/*Closure|* / string mywhen Indicates when the field is allowed to be empty
     * Valid values are true, false, "create", "update". If a Closure is passed then
     * the field will allowed to be empty only when the callback returns true.
     */
    auto allowEmptyTime(string fieldName, string errorMessage = null, /*Closure|*/ string mywhenA) {
        // TODO return _allowEmptyFor(fieldName, EMPTY_STRING | EMPTY_TIME, mywhen, errorMessage);
    }

    /**
     * Require a field to be a non-empty time.
     * Opposite to allowEmptyTime()
     * Params:
     * @param \/*Closure|* / string mywhen Indicates when the field is not allowed
     * to be empty. Valid values are false (never), "create", "update". If a
     * Closure is passed then the field will be required to be not empty when
     * the callback returns true.
     */
    void notEmptyTime(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen /*  = false */ ) {
        mywhen = invertWhenClause(mywhen);
        // TODO return _allowEmptyFor(fieldName, EMPTY_STRING | EMPTY_TIME, mywhen, errorMessage);
    }

    /**
     * Allows a field to be an empty date/time.
     *
     * Empty date values are `null`, `""`, `[]` and arrays where all values are `""`
     * and the `year` and `hour` keys are present.
     *
     * This method is equivalent to calling allowEmptyFor() with EMPTY_STRING +
     * EMPTY_DATE + EMPTY_TIME flags.
     * Params:
     * @param \/*Closure|* / string mywhen Indicates when the field is allowed to be empty
     * Valid values are true, false, "create", "update". If a Closure is passed then
     * the field will allowed to be empty only when the callback returns false.
     */
    auto allowEmptyDateTime(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen /*  = true */ ) {
        // TODO return _allowEmptyFor(fieldName, EMPTY_STRING | EMPTY_DATE | EMPTY_TIME, mywhen, errorMessage);
        return null;

    }

    /**
     * Require a field to be a non empty date/time.
     *
     * Opposite to allowEmptyDateTime
     * Params:
     * string fieldName The name of the field.
     * @param string message The message to show if the field is empty.
     * @param \/*Closure|* / string mywhen Indicates when the field is not allowed
     * to be empty. Valid values are false (never), "create", "update". If a
     * Closure is passed then the field will be required to be not empty when
     * the callback returns true.
     * @return this
     */
    auto notEmptyDateTime(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen /*  = false */ ) {
        // auto mywhen = invertWhenClause(mywhen);
        // TODO return _allowEmptyFor(fieldName, EMPTY_STRING | EMPTY_DATE | EMPTY_TIME, mywhen, errorMessage);
        return this;
    }

    /**
     * Converts validator to fieldName: mysettings array
     * Params:
     * string fieldName name of field
     * @param Json[string] mydefaults default settings
     * @param array<string|int, mixed>|string|int mysettings settings from data
     */
    protected auto _convertValidatorToArray(
        string fieldName,
        Json[string] mydefaults = null,
        Json[string] /* |int */ mysettings = null
    ) {
        /* if (!mysettings.isArray) {
            fieldName = to!string(mysettings);
            mysettings = null;
        } */
        mysettings = mysettings.merge(mydefaults);
        return [fieldName: mysettings];
    }

    /**
     * Invert a when clause for creating notEmpty rules
     * Params:
     * /*Closure| / string mywhen Indicates when the field is not allowed
     * to be empty. Valid values are true (always), "create", "update". If a
     * Closure is passed then the field will allowed to be empty only when
     * the callback returns false.
     */
    protected  /*Closure|*/ string invertWhenClause( /*Closure|*/ string mywhen) {
        if (mywhen == WHEN_CREATE || mywhen == WHEN_UPDATE) {
            return mywhen == WHEN_CREATE ? WHEN_UPDATE : WHEN_CREATE;
        }
        /*         if (cast(Closure) mywhen) {
            return fn(context) : !mywhen(context);
        } */
        return mywhen;
    }

    /**
     * Add a notBlank rule to a field.
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto notBlank(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        string message;
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "This field cannot be left empty"
                : `__d("uim", "This field cannot be left empty")`;
        }

        // Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        /* return _add(fieldName, "notBlank", myextra ~ [
                "rule": "notBlank",
            ]); */
        return null;

    }

    /**
     * Add an alphanumeric rule to a field.
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto alphaNumeric(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be alphanumeric"
                : `__d("uim", "The provided value must be alphanumeric")`;
        }

        // Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        /* return _add(fieldName, "alphaNumeric", myextra ~ [
                "rule": "alphaNumeric",
            ]); */
        return null;

    }

    /**
     * Add a non-alphanumeric rule to a field.
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto notAlphaNumeric(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must not be alphanumeric"
                : `__d("uim", "The provided value must not be alphanumeric")`;
        }

        // Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        /* return _add(fieldName, "notAlphaNumeric", myextra ~ [
                "rule": "notAlphaNumeric",
            ]); */
        return null;

    }

    /**
     * Add an ascii-alphanumeric rule to a field.
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto asciiAlphaNumeric(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be ASCII-alphanumeric"
                : `__d("uim", "The provided value must be ASCII-alphanumeric")`;
        }

        // Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        /* return _add(fieldName, "asciiAlphaNumeric", myextra ~ [
                "rule": "asciiAlphaNumeric",
            ]); */
        return null;

    }

    /**
     * Add a non-ascii alphanumeric rule to a field.
     * Params:
     
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto notAsciiAlphaNumeric(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must not be ASCII-alphanumeric"
                : `__d("uim", "The provided value must not be ASCII-alphanumeric")`;
        }

        // Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        /*         return _add(fieldName, "notAsciiAlphaNumeric", myextra ~ [
                "rule": "notAsciiAlphaNumeric",
            ]);
 */
        return null;
    }

    /**
     * Add an rule that ensures a string length is within a range.
     * Params:
     
     * @param Json[string] myrange The inclusive minimum and maximum length you want permitted.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.alphaNumeric()
     * @return this
     */
    auto lengthBetween(
        string fieldName,
        Json[string] myrange,
        string errorMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        // if (count(myrange) != 2) {
            // TODO throw new DInvalidArgumentException("The myrange argument requires 2 numbers");
        // }

        auto lowerBound = "0"; // array_shift(myrange);
        auto upperBound = "1"; // array_shift(myrange);
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The length of the provided value must be between '%s' and '%s', inclusively"
                .format(lowerBound, upperBound) : `__d(
                    "uim",
                    "The length of the provided value must be between '{lowerBound}' and '{upperBound}', inclusively"`
                .mustache([
                    "lowerBound": lowerBound,
                    "upperBound": upperBound
                ]);
        }

        /*         Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        return _add(fieldName, "lengthBetween", myextra ~ [
                "rule": ["lengthBetween", lowerBound, upperBound],
            ]);
 */
        return null;
    }

    /**
     * Add a credit card rule to a field.
     * Params:
     * You can also supply an array of accepted card types. e.g `["mastercard", "visa", "amex"]`
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto creditCard(
        string fieldName,
        string[] allowedTypeOfCards = null,
        string errorMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        return creditCard(fieldName, allowedTypeOfCards.join(", "), errorMessage);
    }

    auto creditCard(
        string fieldName,
        string allowedTypeOfCards = "all",
        string message = null, /*Closure|*/
        string mywhen = null
    ) {
        string mytypeEnumeration = allowedTypeOfCards;
        if (errorMessage.isNull) {
            if (!_useI18n) {
                message = allowedTypeOfCards == "all"
                    ? "The provided value must be a valid credit card number of any type"
                    : "The provided value must be a valid credit card number of these types: '%s'"
                    .format(mytypeEnumeration);
            } else {
                message = allowedTypeOfCards == "all"
                    ? `__d(
                        "uim",
                        "The provided value must be a valid credit card number of any type"
                    )` : `__d(
                        "uim",
                        "The provided value must be a valid credit card number of these types: '{allowedTypeOfCards}'",
                        allowedTypeOfCards
                    )`;
            }
        }

        // Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        /* return _add(fieldName, "creditCard", myextra ~ [
                "rule": ["creditCard", allowedTypeOfCards, true],
            ]); */
        return null;
    }

    /**
     * Add a greater than comparison rule to a field.
     * Params:
     
     * @param float myvalue The value user data must be greater than.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    Json[string] greaterThan(
        string fieldName,
        float myvalue,
        string errorMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be greater than '%s'".format(myvalue)
                : `__d("uim", "The provided value must be greater than '{0}'", myvalue)`;
        }

        // TODO Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        /* return _add(fieldName, "greaterThan", myextra ~ ["rule": ["comparison", Validation.COMPARE_GREATER, myvalue]]); */
        return null;
    }

    /**
     * Add a greater than or equal to comparison rule to a field.
     * Params:
     * @param float myvalue The value user data must be greater than or equal to.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    Json[string] greaterThanOrEqual(
        string fieldName,
        float myvalue,
        string errorMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be greater than or equal to '%s'".format(myvalue)
                : `__d("uim", "The provided value must be greater than or equal to '{0}'", myvalue)`;
        }

        /*         Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        return _add(fieldName, "greaterThanOrEqual", myextra ~ [
                "rule": [
                    "comparison", Validation.COMPARE_GREATER_OR_EQUAL, myvalue
                ],
            ]);
 */
        return null;
    }

    /**
     * Add a less than comparison rule to a field.
     * Params:
     * @param float myvalue The value user data must be less than.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.comparison()
     */
    auto lessThan(
        string fieldName,
        float myvalue,
        string errorMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be less than '%s'".format(myvalue) 
                : `__d("uim", "The provided value must be less than '{0}'", myvalue)`;
        }

        /* Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        return _add(fieldName, "lessThan", myextra ~ [
                "rule": ["comparison", Validation.COMPARE_LESS, myvalue],
            ]); */
        return null;
    }

    /**
     * Add a less than or equal comparison rule to a field.
     * Params:
     * @param float myvalue The value user data must be less than or equal to.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto lessThanOrEqual(
        string fieldName,
        float myvalue,
        string errorMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must be less than or equal to '{0}'", myvalue)`
                : "The provided value must be less than or equal to '%s'".format(myvalue);
        }

        /*         Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        return _add(fieldName, "lessThanOrEqual", myextra ~ [
                "rule": [
                    "comparison", Validation.COMPARE_LESS_OR_EQUAL, myvalue
                ],
            ]);
 */
        return this;
    }

    /**
     * Add a equal to comparison rule to a field.
     * Params:
     * @param Json aValue The value user data must be equal to.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.comparison()
     */
    auto equals(
        string fieldName,
        Json value,
        string errorMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be equal to '%s'".format(
                    value) : `__d("uim", "The provided value must be equal to '{0}'", myvalue)`;
        }
        // Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);

        /* return _add(fieldName, "equals", myextra ~ [
                "rule": ["comparison", Validation.COMPARE_EQUAL, value],
            ]); */

        return null;
    }

    /**
     * Add a not equal to comparison rule to a field.
     * Params:
     
     * @param Json aValue The value user data must be not be equal to.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.comparison()
     */
    auto notEquals(
        string fieldName,
        Json value,
        string errorMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must not be equal to '%s'".format(value)
                : `__d("uim", "The provided value must not be equal to '{0}'", myvalue)`;
        }

        /*         Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        return _add(fieldName, "notEquals", myextra ~ [
                "rule": ["comparison", Validation.COMPARE_NOT_EQUAL, value],
            ]);
 */
        return null;
    }
    /**
     * Add a rule to compare two fields to each other.
     *
     * If both fields have the exact same value the rule will pass.
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.compareFields()
     */
    auto sameAs(
        string fieldName,
        string secondField,
        string mywhen = null
    ) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be same as '%s'".format(secondField)
                : `__d("uim", "The provided value must be same as '{0}'", secondField)`;
        }

        /*         Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        return _add(fieldName, "sameAs", myextra ~ [
                "rule": [
                    "compareFields", secondField, Validation.COMPARE_SAME
                ],
            ]);
 */
        return null;
    }

    /**
     * Add a rule to compare that two fields have different values.
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto notSameAs(
        string fieldName,
        string secondField,
        string errorMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must not be same as '%s'".format(
                    secondField)
                : `__d("uim", "The provided value must not be same as '{0}'", secondField)`;
        }

        /*         Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        return _add(fieldName, "notSameAs", myextra ~ [
                "rule": [
                    "compareFields", secondField, Validation.COMPARE_NOT_SAME
                ],
            ]);
 */
        return null;
    }

    /**
     * Add a rule to compare one field is equal to another.
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto equalToField(
        string fieldName,
        string secondField,
        string errorMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be equal to the one of field '%s'".format(secondField) 
                : `__d(
                    "uim",
                    "The provided value must be equal to the one of field '{0}'",
                    secondField
                )`;
        }

        // TODO Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]); 
        /* return _add(fieldName, "equalToField", myextra ~ [
                "rule": [
                    "compareFields", secondField, Validation.COMPARE_EQUAL
                ],
            ]); */
        return null;
    }

    /**
     * Add a rule to compare one field is not equal to another.
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.compareFields()
     * @return this
     */
    auto notEqualToField(
        string fieldName,
        string secondField,
        string errorMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must not be equal to the one of field '%s'".format(
                    secondField) : `__d(
                    "uim",
                    "The provided value must not be equal to the one of field '{0}'",
                    secondField
                )`;
        }

        /*         Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        return _add(fieldName, "notEqualToField", myextra ~ [
                "rule": [
                    "compareFields", secondField, Validation.COMPARE_NOT_EQUAL
                ],
            ]);
 */
        return null;
    }

    /**
     * Add a rule to compare one field is greater than another.
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.compareFields()
     * @return this
     */
    auto greaterThanField(
        string fieldName,
        string secondField,
        string errorMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be greater than the one of field '%s'".format(
                    secondField) : `__d(
                    "uim",
                    "The provided value must be greater than the one of field '{0}'",
                    secondField
                )`;
        }

        /*         Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        return _add(fieldName, "greaterThanField", myextra ~ [
                "rule": [
                    "compareFields", secondField, Validation.COMPARE_GREATER
                ],
            ]);
 */
        return null;
    }

    /**
     * Add a rule to compare one field is greater than or equal to another.
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto greaterThanOrEqualToField(
        string fieldName,
        string secondField,
        string errorMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be greater than or equal to the one of field '%s'"
                .format(secondField
                ) : `__d(
                    "uim",
                    "The provided value must be greater than or equal to the one of field '{0}'",
                    secondField
                )`;
        }

        /*         Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        return _add(fieldName, "greaterThanOrEqualToField", myextra ~ [
                "rule": [
                    "compareFields", secondField,
                    Validation.COMPARE_GREATER_OR_EQUAL
                ],
            ]); */
        return null;
    }

    /**
     * Add a rule to compare one field is less than another.
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto lessThanField(
        string fieldName,
        string secondField,
        string errorMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be less than the one of field '%s'".format(
                    secondField) : `__d(
                    "uim",
                    "The provided value must be less than the one of field '{0}'",
                    secondField
                )`;
        }

        /*         Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        return _add(fieldName, "lessThanField", myextra ~ [
                "rule": [
                    "compareFields", secondField, Validation.COMPARE_LESS
                ],
            ]);

 */
        return null;
    }

    /**
     * Add a rule to compare one field is less than or equal to another.
     * Params:
     
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto lessThanOrEqualToField(
        string fieldName,
        string secondField,
        string errorMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be less than or equal to the one of field '%s'"
                .format(secondField
                ) : `__d(
                    "uim",
                    "The provided value must be less than or equal to the one of field '{0}'",
                    secondField
                )`;
        }

        /*         Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        return _add(fieldName, "lessThanOrEqualToField", myextra ~ [
                "rule": [
                    "compareFields", secondField,
                    Validation.COMPARE_LESS_OR_EQUAL
                ],
            ]); */
        return null;
    }

    /**
     * Add a date format validation rule to a field.
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto date(
        string fieldName,
        string[] dateFormats = ["ymd"],
        string errorMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        auto myformatEnumeration = dateFormats.join(", ");

        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be a date of one of these formats: '%s'"
                .format(myformatEnumeration) 
                : `__d(
                    "uim",
                    "The provided value must be a date of one of these formats: '{0}'",
                    myformatEnumeration
                )`;
        }

        /*         Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        return _add(fieldName, "date", myextra ~ [
                "rule": ["date", dateFormats],
            ]); */
        return null;
    }

    /**
     * Add a date time format validation rule to a field.
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto dateTime(
        string fieldName,
        string[] dateFormats = ["ymd"],
        string errorMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        auto myformatEnumeration = dateFormats.join(", ");
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be a date and time of one of these formats: '%s'"
                .format(myformatEnumeration) : `__d(
                    "uim",
                    "The provided value must be a date and time of one of these formats: '{0}'",
                    myformatEnumeration
                )`;
        }
        /* Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);

        return _add(fieldName, "dateTime", myextra ~ [
                "rule": ["datetime", dateFormats],
            ]); */
        return null;
    }

    /**
     * Add a time format validation rule to a field.
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto time(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be a time"
                : `__d("uim", "The provided value must be a time")`;
        }

        /*         Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        return _add(fieldName, "time", myextra ~ [
                "rule": "time",
            ]); */
        return null;
    }

    /**
     * Add a localized time, date or datetime format validation rule to a field.
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto localizedTime(
        string fieldName,
        string parserType = "datetime",
        string errorMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be a localized time, date or date and time"
                : `__d("uim", "The provided value must be a localized time, date or date and time")`;
        }

        /*         Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        return _add(fieldName, "localizedTime", myextra ~ [
                "rule": ["localizedTime", parserType],
            ]); */
        return null;
    }

    /**
     * Add a boolean validation rule to a field.
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto isBoolean(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be a boolean"
                : `__d("uim", "The provided value must be a boolean")`;
        }
        /* Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);

        return _add(fieldName, "boolean", myextra ~ [
                "rule": "boolean",
            ]); */
        return null;
    }

    /**
     * Add a decimal validation rule to a field.
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto decimal(
        string fieldName,
        int numberOfPlaces = 0,
        string errorMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (errorMessage.isNull) {
            if (!_useI18n) {
                errorMessage = numberOfPlaces == 0
                    ? "The provided value must be decimal with any number of decimal places, including none"
                    : "The provided value must be decimal with '%s' decimal places".format(numberOfPlaces);

            } else {
                errorMessage = numberOfPlaces == 0
                    ? `__d(
                        "uim",
                        "The provided value must be decimal with any number of decimal places, including none"
                    )` : `__d(
                        "uim",
                        "The provided value must be decimal with '{0}' decimal places",
                        numberOfPlaces
                    )`;
            }
        }
        /* Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);

        return _add(fieldName, "decimal", myextra ~ [
                "rule": ["decimal", numberOfPlaces],
            ]); */
        return null;
    }

    /**
     * Add an email validation rule to a field.
     * Params:
     
     * @param bool shouldCheckMX Whether to check the MX records.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto email(
        string fieldName,
        bool shouldCheckMX = false,
        string errorMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be an e-mail address"
                : `__d("uim", "The provided value must be an e-mail address")`;
        }
        /* Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);

        return _add(fieldName, "email", myextra ~ [
                "rule": ["email", shouldCheckMX],
            ]); */
        return null;
    }

    /**
     * Add a backed enum validation rule to a field.
     * Params:
     
     * @param class-string<\BackedEnum> myenumclassname The valid backed enum class name.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto enumeration(
        string fieldName,
        string myenumclassname,
        string errorMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        /* if (!isIn(BackedEnum.classname, (array) class_implements(myenumclassname), true)) {
            throw new DInvalidArgumentException(
                "The `myenumclassname` argument must be the classname of a valid backed enum."
            );
        } */
        if (errorMessage.isNull) {
            string[] mycases; // TODO = array_map(fn (mycase): mycase.value, myenumclassname.cases());
            string mycaseOptions = mycases.join("`, `");

            errorMessage = !_useI18n
                ? "The provided value must be one of '%s'".format(
                    mycaseOptions)
                : `__d("uim", "The provided value must be one of '{0}'", mycaseOptions)`;

        }
        /* Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);

        return _add(fieldName, "enum", myextra ~ [
                "rule": ["enum", myenumclassname],
            ]); */
        return null;
    }

    /**
     * Add an IP validation rule to a field.
     *
     * This rule will accept both IPv4 and IPv6 addresses.
     * Params:
     
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto ip(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be an IP address"
                : `__d("uim", "The provided value must be an IP address")`;

        }
        /* Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);

        return _add(fieldName, "ip", myextra ~ [
                "rule": "ip",
            ]); */
        return null;
    }

    /**
     * Add an IPv4 validation rule to a field.
     * Params:
     
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.ip()
     */
    auto ipv4(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must be an IPv4 address")`
                : "The provided value must be an IPv4 address";

        }
        /* Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);

        return _add(fieldName, "ipv4", myextra ~ [
                "rule": ["ip", "ipv4"],
            ]); */
        return null;
    }

    /**
     * Add an IPv6 validation rule to a field.
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto ipv6(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must be an IPv6 address")`
                : "The provided value must be an IPv6 address";
        }
        /*         Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);

        return _add(fieldName, "ipv6", myextra ~ [
                "rule": ["ip", "ipv6"],
            ]); */
        return null;
    }

    /**
     * Add a string length validation rule to a field.
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto hasMinLength(string fieldName, int requiredMinLength, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must be at least '{0}' characters long", mymin)`
                : "The provided value must be at least '%s' characters long".format(mymin);
        }
        /*         Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);

        return _add(fieldName, "minLength", myextra ~ ["rule": ["minLength", requiredMinLength],
            ]); */
        return null;
    }

    /**
     * Add a string length validation rule to a field.
     * Params:
     * @param int mymin The minimum length required.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto minLengthBytes(string fieldName, int requiredMinLength, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must be at least '{0}' bytes long", mymin)`
                : "The provided value must be at least '%s' bytes long".format(requiredMinLength);
        }

        /* Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        return _add(fieldName, "minLengthBytes", myextra ~ [
                "rule": ["minLengthBytes", requiredMinLength],
            ]); */
        return null;
    }

    /**
     * Add a string length validation rule to a field.
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto maxLength(string fieldName, int allowedMaxlength, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must be at most '{0}' characters long", mymax)`
                : "The provided value must be at most '%s' characters long".format(mymax);
        }

        /* Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        return _add(fieldName, "maxLength", myextra ~ [
                "rule": ["maxLength", allowedMaxlength],
            ]);*/
        return null;
    }

    /**
     * Add a string length validation rule to a field.
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto maxLengthBytes(string fieldName, int allowedMaxlength, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must be at most '{0}' bytes long", mymax)`
                : "The provided value must be at most '%s' bytes long".format(mymax);
        }

        /* Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        return _add(fieldName, "maxLengthBytes", myextra ~ [
                "rule": ["maxLengthBytes", allowedMaxlength],
            ]); */
        return null;
    }

    /**
     * Add a numeric value validation rule to a field.
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto numeric(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must be numeric")`
                : "The provided value must be numeric";

        }
        /* Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);

        return _add(fieldName, "numeric", myextra ~ [
                "rule": "numeric",
            ]); */
        return null;
    }

    /**
     * Add a natural number validation rule to a field.
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto naturalNumber(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must be a natural number")`
                : "The provided value must be a natural number";
        }
        /*         Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);

        return _add(fieldName, "naturalNumber", myextra ~ [
                "rule": ["naturalNumber", false],
            ]); */
        return null;
    }

    /**
     * Add a validation rule to ensure a field is a non negative integer.
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto nonNegativeInteger(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must be a non-negative integer")`
                : "The provided value must be a non-negative integer";
        }
        /*         Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);

        return _add(fieldName, "nonNegativeInteger", myextra ~ [
                "rule": ["naturalNumber", true],
            ]); */
        return null;
    }

    /**
     * Add a validation rule to ensure a field is within a numeric range
     * Params:
     
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto range(string fieldName, Json[string] bounds, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        // if (count(bounds) != 2) {
            // TODO throw new DInvalidArgumentException("The myrange argument requires 2 numbers");
        // }
        auto lowerBound = "0"; // array_shift(myrange);
        auto upperBound = "1"; // array_shift(myrange);

        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d(
                    "uim",
                    "The provided value must be between '{0}' and '{1}', inclusively",
                    lowerBound, upperBound
                )`
                : "The provided value must be between '%s' and '%s', inclusively".format(lowerBound, upperBound);
        }
        /*         Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);

        return _add(fieldName, "range", myextra ~ [
                "rule": ["range", lowerBound, upperBound],
            ]); */
        return null;
    }

    /**
     * Add a validation rule to ensure a field is a URL.
     * This validator does not require a protocol.
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto url(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must be a URL")`
                : "The provided value must be a URL";
        }

        /* Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        return _add(fieldName, "url", myextra ~ ["rule": ["url", false],]); */
        return null;

    }

    /**
     * Add a validation rule to ensure a field is a URL.
     *
     * This validator requires the URL to have a protocol.
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto urlWithProtocol(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must be a URL with protocol")`
                : "The provided value must be a URL with protocol";
        }
        
        /* Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        return _add(fieldName, "urlWithProtocol", myextra ~ [
                "rule": ["url", true],
            ]); */
        return null; 
    }

    /**
     * Add a validation rule to ensure the field value is within an allowed list.
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto inList(string fieldName, Json[string] validOptions, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        // auto listEnumeration = mylist.join(", ");
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be one of: '%s'".format("listEnumeration")
                : `__d(
                    "uim",
                    "The provided value must be one of: '{0}'",
                    listEnumeration
                )`;
        }

/*         Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        return _add(fieldName, "inList", myextra ~ [
                "rule": ["inList", validOptions],
            ]); */
        return null; 
    }

    /**
     * Add a validation rule to ensure the field is a UUID
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.uuid()
     */
    auto uuid(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be a UUID"
                : `__d("uim", "The provided value must be a UUID")`;
        }
        
/*         Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        return _add(fieldName, "uuid", myextra ~ [
                "rule": "uuid",
            ]); */
        return null; 
    }

    /**
     * Add a validation rule to ensure the field is an uploaded file
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto uploadedFile(
        string fieldName,
        Json[string] options,
        string errorMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must be an uploaded file")`
                : "The provided value must be an uploaded file";
        }
        /* Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);

        return _add(fieldName, "uploadedFile", myextra ~ [
                "rule": ["uploadedFile", options],
            ]); */
        return null; 
    }

    /**
     * Add a validation rule to ensure the field is a lat/long tuple.
     *
     * e.g. `<lat>, <lng>`
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto latLong(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
            ? `__d("uim", "The provided value must be a latitude/longitude coordinate")`
            : "The provided value must be a latitude/longitude coordinate";
        }
        /* Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        return _add(fieldName, "latLong", myextra ~ [
            "rule": "geoCoordinate",
        ]); */
        return null; 
    }

    /**
     * Add a validation rule to ensure the field is a latitude.
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto latitude(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must be a latitude")`
                : "The provided value must be a latitude";
        }
        /* Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);

        return _add(fieldName, "latitude", myextra ~ [
                "rule": "latitude",
            ]); */
        return null; 
    }

    // Add a validation rule to ensure the field is a longitude.
    auto longitude(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be a longitude" 
                : `__d("uim", "The provided value must be a longitude")`;

        }

/*         Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        return _add(fieldName, "longitude", myextra ~ [
                "rule": "longitude",
            ]); */
        return null; 
    }

    /**
     * Add a validation rule to ensure a field contains only ascii bytes
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto ascii(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            message = _useI18n
                ? `__d("uim", "The provided value must be ASCII bytes only")`
                : "The provided value must be ASCII bytes only";
        }

/*         Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        return _add(fieldName, "ascii", myextra ~ [
                "rule": "ascii",
            ]); */
        return null; 
    }

    /**
     * Add a validation rule to ensure a field contains only BMP utf8 bytes
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto utf8(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            message = _useI18n
                ? `__d("uim", "The provided value must be UTF-8 bytes only")`
                : "The provided value must be UTF-8 bytes only";
        }

        /* Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        return _add(fieldName, "utf8", myextra ~ [
                "rule": ["utf8", ["extended": false.toJson]],
            ]); */
        return null; 
    }

    /**
     * Add a validation rule to ensure a field contains only utf8 bytes.
     *
     * This rule will accept 3 and 4 byte UTF8 sequences, which are necessary for emoji.
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto utf8Extended(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be 3 and 4 byte UTF-8 sequences only"
                : `__d("uim", "The provided value must be 3 and 4 byte UTF-8 sequences only")`;
        }

        /* Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        return _add(fieldName, "utf8Extended", myextra ~ [
                "rule": ["utf8", ["extended": true.toJson]],
            ]); */
        return null; 
    }

    /**
     * Add a validation rule to ensure a field is an integer value.
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto integer(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            message = _useI18n
                ? `__d("uim", "The provided value must be an integer")`
                : "The provided value must be an integer"; 
        }

        /* Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        return _add(fieldName, "integer", myextra ~ [
                "rule": "isInteger",
            ]); */
        return null; 
    }

    /**
     * Add a validation rule to ensure that a field contains an array.
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto array(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be an array"
                : `__d("uim", "The provided value must be an array")`;
        }

        /* Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        return _add(fieldName, "array", myextra ~ [
                "rule": "isArray",
            ]); */
        return null; 
    }

    /**
     * Add a validation rule to ensure that a field contains a scalar.
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto scalar(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            message = _useI18n
                ? `__d("uim", "The provided value must be scalar")`
                : "The provided value must be scalar";
        }

        /* Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        return _add(fieldName, "scalar", myextra ~ [
                "rule": "isScalar",
            ]); */
        return null; 
    }

    /**
     * Add a validation rule to ensure a field is a 6 digits hex color value.
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto hexColor(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            message = _useI18n
                ? `__d("uim", "The provided value must be a hex color")`
                : "The provided value must be a hex color";
        }

/*         Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        return _add(fieldName, "hexColor", myextra ~ [
                "rule": "hexColor",
            ]); */

        return null; 
    }

    /**
     * Add a validation rule for a multiple select. Comparison is case sensitive by default.
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto multipleOptions(
        string fieldName,
        Json[string] options = null,
        string message = null, /*Closure|*/
        string mywhen = null
    ) {
        if (errorMessage.isNull) {
            message = _useI18n
                ? `__d("uim", "The provided value must be a set of multiple options")`
                : "The provided value must be a set of multiple options";
        }

/*         Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);
        auto mycaseInsensitive = options.getBoolean("caseInsensitive", false);
        options.remove("caseInsensitive");

        return _add(fieldName, "multipleOptions", myextra ~ [
                "rule": ["multiple", options, mycaseInsensitive],
            ]); */
        return null; 
    }

    /**
     * Add a validation rule to ensure that a field is an array containing at least
     * the specified amount of elements
     * Params:
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    Json[string] hasAtLeast(string fieldName, int numberOfElements, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must have at least '{0}' elements", mycount)`
                : "The provided value must have at least '%s' elements".format(numberOfElements); 

        }
        // Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);

        /* return _add(fieldName, "hasAtLeast", myextra ~ [
            "rule": auto (myvalue) use (numberOfElements) {
                if (isArray(myvalue) && myvalue.hasKey("_ids")) {
                    myvalue = myvalue["_ids"];
                }
                return Validation.numElements(myvalue, Validation.COMPARE_GREATER_OR_EQUAL, numberOfElements);
            },
        ]); */
        return null;
    }

    /**
     * Add a validation rule to ensure that a field is an array containing at most
     * the specified amount of elements
     * Params:
     * @param int mycount The number maximum amount of elements the field should have
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.numElements()
     */
    Json[string] hasAtMost(string fieldName, int mycount, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must have at most '{0}' elements", mycount)`
                : "The provided value must have at most '%s' elements".format(mycount); 
        }
        // Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);

        /* return _add(fieldName, "hasAtMost", myextra ~ [
            "rule": auto (myvalue) use (mycount) {
                if (isArray(myvalue) && myvalue.hasKey("_ids")) {
                    myvalue = myvalue["_ids"];
                }
                return Validation.numElements(myvalue, Validation.COMPARE_LESS_OR_EQUAL, mycount);
            },
        ]); */
        return null;
    }

    /**
     * Returns whether a field can be left empty for a new or already existing record.
     * Params:
     * @param bool isNewRecord whether the data to be validated is new or to be updated.
     */
    bool isEmptyAllowed(string fieldName, bool isNewRecord) {
        auto myproviders = _providers;
        // auto mydata = null;
        // auto context = compact("data", "newRecord", "field", "providers");

        // return _canBeEmpty(this.field(fieldName), context);
        return false;
    }

    /**
     * Returns whether a field can be left out for a new or already existing
     * record.
     * Params:
     * @param bool isNewRecord Whether the data to be validated is new or to be updated.
     */
    bool isPresenceRequired(string fieldName, bool isNewRecord) {
        /*  myproviders = _providers;
        mydata = null;
        context = compact("data", "newRecord", "field", "providers");

        return !_checkPresence(this.field(fieldName), context); */
        return false;
    }

    /**
     * Returns whether a field matches against a regular expression.
     * Params:
     * @param string myregex Regular expression.
     * @param string message The error errorMessage when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto regex(string fieldName, string myregex, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        /* if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must match against the pattern '%s'".format(myregex)
                : __d("uim", "The provided value must match against the pattern '{0}'", myregex);
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": errorMessage]);

        return _add(fieldName, "regex", myextra ~ [
            "rule": ["custom", myregex],
        ]); */
        return false;
    }

    // Gets the required message for a field
    string getRequiredMessage(string fieldName) {
        if (!_fields.hasKey(fieldName)) {
            return null;
        }
        if (_presenceMessages.hasKey(fieldName)) {
            return _presenceMessages[fieldName];
        }
        
        return _useI18n
            ? `__d("uim", "This field is required")`
            : "This field is required";
    }

    // Gets the notEmpty message for a field
    string getNotEmptyMessage(string fieldName) {
        /* if (!_fields.hasKey(fieldName)) {
            return null;
        } */
        /* foreach (myrule; _fields[fieldName]) {
            if (myrule.get("rule") == "notBlank" && myrule.get("message")) {
                return myrule.get("message");
            }
        }
        if (_allowEmptyMessages.hasKey(fieldName)) {
            return _allowEmptyMessages[fieldName];
        } */

        return _useI18n
            ? `__d("uim", "This field cannot be left empty")`
            : "This field cannot be left empty"; 
    }

    /**
     * Returns false if any validation for the passed rule set should be stopped
     * due to the field missing in the data array
     */
    protected bool _checkPresence(DValidationSet fieldName, Json[string] context) {
        auto myrequired = fieldName.isPresenceRequired();
        /*  if (cast(Closure) myrequired) {
            return !myrequired(context);
        } */

        /* auto isNewRecord = context["newRecord"];
        if (myrequired.isIn([WHEN_CREATE, WHEN_UPDATE])) {
            return (myrequired == WHEN_CREATE && !isNewRecord) ||
                (myrequired == WHEN_UPDATE && isNewRecord);
        }
        return !myrequired; */
        return false;
    }

    /**
     * Returns whether the field can be left blank according to `allowEmpty`
     * Params:
     * \UIM\Validation\ValidationSet fieldName the set of rules for a field
     */
    protected bool _canBeEmpty(DValidationSet fieldName, Json[string] context) {
        auto myallowed = fieldName.isEmptyAllowed();
        /* if (cast(Closure) myallowed) {
            return myallowed(context);
        } */

        /* auto isNewRecord = context["newRecord"];
        if (myallowed.isIn([WHEN_CREATE, WHEN_UPDATE])) {
            myallowed = (myallowed == WHEN_CREATE && isNewRecord) ||
                (myallowed == WHEN_UPDATE && !isNewRecord);
        }
        return !myallowed.isEmpty */
        return false;
    }

    /**
     * Returns true if the field is empty in the passed data array
     * Params:
     * Json mydata Value to check against.
     * @param int myflags A bitmask of EMPTY_* flags which specify what is empty
     */
    protected bool isEmpty(Json mydata, int myflags) {
        /* if (mydata.isNull) {
            return true;
        }
        if (mydata is null && (myflags & EMPTY_STRING)) {
            return true;
        }
        auto myarrayTypes = EMPTY_ARRAY | EMPTY_DATE | EMPTY_TIME;
        if (mydata is null && (myflags & myarrayTypes)) {
            return true;
        }
        if (isArray(mydata)) {
            auto myallFieldsAreEmpty = true;
            foreach (fieldName; mydata) {
                if (fieldName !is null && fieldName != "") {
                    myallFieldsAreEmpty = false;
                    break;
                }
            }
            if (myallFieldsAreEmpty) {
                if ((myflags & EMPTY_DATE) && mydata.hasKey("year")) {
                    return true;
                }
                if ((myflags & EMPTY_TIME) && mydata.hasKey("hour")) {
                    return true;
                }
            }
        }

        return (myflags & EMPTY_FILE) && cast(IUploadedFile) mydata && mydata.getError() == UPLOAD_ERR_NO_FILE; */
        return false; 
    }

    /**
     * Iterates over each rule in the validation set and collects the errors resulting
     * from executing them
     * Params:
     * @param \UIM\Validation\ValidationSet myrules the list of rules for a field
     * @param Json[string] data the full data passed to the validator
     */
    protected Json[string] _processRules(string fieldName, DValidationSet myrules, Json[string] data, bool isNewRecord) {
        Json[string] myerrors = null;
        // Loading default provider in case there is none
        getProvider("default");

        auto message = _useI18n
            ? `__d("uim", "The provided value is invalid")`
            : "The provided value is invalid"; 

        /* foreach (myname, myrule; myrules) {
            auto result = myrule.process(mydata[fieldName], _providers, compact("newRecord", "data", "field"));
            if (result == true) {
                continue;
            }

            myerrors[myname] = message;
            if (isArray(result) && myname == NESTED) {
                myerrors = result;
            }
            if (isString(result)) {
                myerrors[myname] = result;
            }
            if (myrule.isLast()) {
                break;
            }
        }
        return myerrors; */
        return null; 
    }

    // Get the printable version of this object.
    Json[string] debugInfo() {
        Json[string] fields = null;
        // _fields.byKeyValue.each!(
            /* nameSet => fields[nameSet.key] = [
                "isPresenceRequired": nameSet.value.isPresenceRequired(),
                "isEmptyAllowed": nameSet.value.isEmptyAllowed(),
                "rules": nameSet.value.rules().keys(),
            ]); */

        /* return [
            "_presenceMessages": _presenceMessages,
            "_allowEmptyMessages": _allowEmptyMessages,
            "_allowEmptyFlags": _allowEmptyFlags,
            "_useI18n": _useI18n,
            "_stopOnFailure": _stopOnFailure,
            "_providers": _providers.keys,
            "_fields": fieldNames,
        ]; */
        return null; 
    }
}
