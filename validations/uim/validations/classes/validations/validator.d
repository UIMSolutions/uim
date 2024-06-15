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

    /**
     * Validates and returns an array of failed fields and their error messages.
     * Params:
     * Json[string] data The data to be checked for errors
     * @param bool mynewRecord whether the data to be validated is new or to be updated.
     * /
    array<array> validate(Json[string] data, bool mynewRecord = true) {
        myerrors = null;

        foreach (_fields as myname: fieldName) {
            myname = to!string(myname);
            mykeyPresent = array_key_exists(myname, mydata);

            myproviders = _providers;
            mycontext = compact("data", "newRecord", "field", "providers");

            if (!mykeyPresent && !_checkPresence(fieldName, mycontext)) {
                myerrors[myname]["_required"] = getRequiredMessage(myname);
                continue;
            }
            if (!mykeyPresent) {
                continue;
            }
            mycanBeEmpty = _canBeEmpty(fieldName, mycontext);

            myflags = EMPTY_NULL;
            if (isSet(_allowEmptyFlags[myname])) {
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
            result = _processRules(myname, fieldName, mydata, mynewRecord);
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
     * Params:
     * @param \UIM\Validation\ValidationSet|null myset The set of rules for field
     */
    DValidationSet field(string fieldname, DValidationSet myset = null) {
        /* if (!_fields.has(fieldname)) {
            /* myset = myset ?: new DValidationSet();
           _fields[fieldname] = myset; * /
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
        if (isSet(_providers[myname])) {
            return _providers[myname];
        }
        if (myname != "default") {
            return null;
        }
        _providers[myname] = new DRulesProvider();

        return _providers[myname];
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
        return _fields.get(fieldName);
    }

    // Returns the rule set for a field
    DValidationSet offsetGet(string fieldName) {
        return _field(fieldName);
    }

    /**
     * Sets the rule set for a field
     * Params:
     * string fieldName name of the field to set
     * @param \UIM\Validation\ValidationSet|array myrules set of rules to apply to field
     */
    void offsetSet(string fieldName, Json myrules) {
        if (!cast(DValidationSet) myrules) {
            myset = new DValidationSet();
            myrules.byKeyValue.each!(nameRule => myset.add(nameRule.key, nameRule.value));
            myrules = myset;
        }
        _fields[fieldName] = myrules;
    }

    /**
     * Unsets the rule set for a field
     * Params:
     * string fieldName name of the field to unset
     */
    void offsetUnset(Json fieldName) {
        remove(_fields[fieldName]);
    }

    /**
     * Returns an iterator for each of the fields to be validated
     * /
    Traversable<string, DValidationSet> getIterator() {
        return new DArrayIterator(_fields);
    }
    
    /**
     * Returns the number of fields having validation rules
     */
    size_t count() {
        return count(_fields);
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
    auto add(string fieldName, string[] myname, DValidationRule[] rules = null) {
        auto myvalidationSet = this.field(fieldName);

        if (!isArray(myname)) {
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
        return this;
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
     * string rootfieldName The root field for the nested validator.
     * @param \UIM\Validation\Validator myvalidator The nested validator.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto addNested(
        string rootfieldName,
        DValidator myvalidator,
        string myMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        Json[string] myextra = array_filter(["message": myMessage, "on": mywhen]);

        auto myvalidationSet = this.field(rootfieldName);
        /* myvalidationSet.add(NESTED, myextra ~ ["rule": auto (myvalue, mycontext) use (myvalidator, myMessage) {
            if (!isArray(myvalue)) {
                return false;
            }
            this.providers().each!(name => myvalidator.setProvider(name, getProvider(name)));
            myerrors = myvalidator.validate(myvalue, mycontext["newRecord"]);

            myMessage = myMessage ? [NESTED: myMessage] : [];

            return myerrors.isEmpty ? true : myerrors + myMessage;
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
     * string rootfieldName The root field for the nested validator.
     * @param \UIM\Validation\Validator myvalidator The nested validator.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    void addNestedMany(
        string rootfieldName,
        DValidator myvalidator,
        string myMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        Json[string] myextra = array_filter(["message": myMessage, "on": mywhen]);

        auto myvalidationSet = this.field(rootfieldName);
        /*         myvalidationSet.add(NESTED, myextra ~ ["rule": auto (myvalue, mycontext) use (myvalidator, myMessage) {
            if (!isArray(myvalue)) { return false; }

            this.providers().each!((name) {
                auto myprovider = getProvider(name);
                myvalidator.setProvider(name, myprovider);
            });

            auto myerrors = null;
            foreach (myvalue as myi: myrow) {
                if (!isArray(myrow)) {
                    return false;
                }
                mycheck = myvalidator.validate(myrow, mycontext["newRecord"]);
                if (!mycheck.isEmpty) {
                    myerrors[myi] = mycheck;
                }
            }
            myMessage = myMessage ? [NESTED: myMessage] : [];

            return myerrors.isEmpty ? true : myerrors + myMessage;
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
            remove(_fields[fieldName]);
        } else {
            this.field(fieldName).remove(myrule);
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
     * @param string myMessage The message to show if the field presence validation fails.
     */
    void requirePresence(string[] fieldName, /*Closure|*/ string mymode/*  = true */, string myMessage = null) {
        mydefaults = [
            "mode": mymode,
            "message": myMessage,
        ];

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
     * myvalidator.allowEmpty("email", Validator.EMPTY_STRING, auto (mycontext) {
     * return !mycontext["newRecord"] || mycontext["data.role"] == "admin";
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
     * @param string myMessage The message to show if the field is not
     */
    void allowEmptyFor(
        string fieldName,
        int myflags = 0, /*Closure|*/
        string mywhen = null/*  = true */,
        string myMessage = null
    ) {
        this.field(fieldName).allowEmpty(mywhen);
        if (myMessage) {
            _allowEmptyMessages[fieldName] = myMessage;
        }
        if (myflags !is null) {
            _allowEmptyFlags[fieldName] = myflags;
        }
    }

    /**
     * Allows a field to be an empty string.
     *
     * This method is equivalent to calling allowEmptyFor() with EMPTY_STRING flag.
     * Params:
     * string fieldName The name of the field.
     * @param string myMessage The message to show if the field is not
     * @param \/*Closure|* / string mywhen Indicates when the field is allowed to be empty
     * Valid values are true, false, "create", "update". If a Closure is passed then
     * the field will allowed to be empty only when the callback returns true.
     */
    auto allowEmptyString(string fieldName, string myMessage = null, /*Closure|*/ string mywhen/*  = true */) {
        return _allowEmptyFor(fieldName, EMPTY_STRING, mywhen, myMessage);
    }

    /**
     * Requires a field to not be an empty string.
     *
     * Opposite to allowEmptyString()
     * Params:
     * string fieldName The name of the field.
     * @param string myMessage The message to show if the field is empty.
     * @param \/*Closure|* / string mywhen Indicates when the field is not allowed
     * to be empty. Valid values are false (never), "create", "update". If a
     * Closure is passed then the field will be required to be not empty when
     * the callback returns true.
     */
    auto notEmptyString(string fieldName, string message = null, /*Closure|*/ string mywhen/*  = false */) {
        mywhen = invertWhenClause(mywhen);
        return _allowEmptyFor(fieldName, EMPTY_STRING, mywhen, message);
    }

    /**
     * Allows a field to be an empty array.
     *
     * This method is equivalent to calling allowEmptyFor() with EMPTY_STRING +
     * EMPTY_ARRAY flags.
     * Params:
     * string fieldName The name of the field.
     * @param string myMessage The message to show if the field is not
     * @param \/*Closure|* / string mywhen Indicates when the field is allowed to be empty
     * Valid values are true, false, "create", "update". If a Closure is passed then
     * the field will allowed to be empty only when the callback returns true.
     */
    auto allowEmptyArray(string fieldName, string myMessage = null, /*Closure|*/ string mywhen/*  = true */) {
        return _allowEmptyFor(fieldName, EMPTY_STRING | EMPTY_ARRAY, mywhen, myMessage);
    }

    /**
     * Require a field to be a non-empty array
     *
     * Opposite to allowEmptyArray()
     * Params:
     * string fieldName The name of the field.
     * @param string myMessage The message to show if the field is empty.
     * @param \/*Closure|* / string mywhen Indicates when the field is not allowed
     * to be empty. Valid values are false (never), "create", "update". If a
     * Closure is passed then the field will be required to be not empty when
     * the callback returns true.
     */
    auto notEmptyArray(string fieldName, string myMessage = null, /*Closure|*/ string mywhen/*  = false */) {
        mywhen = this.invertWhenClause(mywhen);

        return _allowEmptyFor(fieldName, EMPTY_STRING | EMPTY_ARRAY, mywhen, myMessage);
    }

    /**
     * Allows a field to be an empty file.
     *
     * This method is equivalent to calling allowEmptyFor() with EMPTY_FILE flag.
     * File fields will not accept `""`, or `[]` as empty values. Only `null` and a file
     * upload with `error` equal to `UPLOAD_ERR_NO_FILE` will be treated as empty.
     * Params:
     * string fieldName The name of the field.
     * @param string myMessage The message to show if the field is not
     * @param \/*Closure|* / string mywhen Indicates when the field is allowed to be empty
     * Valid values are true, "create", "update". If a Closure is passed then
     * the field will allowed to be empty only when the callback returns true.
     * @return this
     */
    auto allowEmptyFile(string fieldName, string myMessage = null, /*Closure|*/ string mywhen/*  = true */) {
        return _allowEmptyFor(fieldName, EMPTY_FILE, mywhen, myMessage);
    }

    /**
     * Require a field to be a not-empty file.
     *
     * Opposite to allowEmptyFile()
     * Params:
     * string fieldName The name of the field.
     * @param string myMessage The message to show if the field is empty.
     * @param \/*Closure|* / string mywhen Indicates when the field is not allowed
     * to be empty. Valid values are false (never), "create", "update". If a
     * Closure is passed then the field will be required to be not empty when
     * the callback returns true.
     */
    auto notEmptyFile(string fieldName, string myMessage = null, /*Closure|*/ string mywhen/*  = false */) {
        mywhen = this.invertWhenClause(mywhen);

        return _allowEmptyFor(fieldName, EMPTY_FILE, mywhen, myMessage);
    }

    /**
     * Allows a field to be an empty date.
     *
     * Empty date values are `null`, `""`, `[]` and arrays where all values are `""`
     * and the `year` key is present.
     * Params:
     * string fieldName The name of the field.
     * @param string myMessage The message to show if the field is not
     * @param \/*Closure|* / string mywhen Indicates when the field is allowed to be empty
     * Valid values are true, false, "create", "update". If a Closure is passed then
     * the field will allowed to be empty only when the callback returns true.
     */
    auto allowEmptyDate(string fieldName, string myMessage = null, /*Closure|*/ string mywhen/*  = true */) {
        return _allowEmptyFor(fieldName, EMPTY_STRING | EMPTY_DATE, mywhen, myMessage);
    }

    /**
     * Require a non-empty date value
     * Params:
     * string fieldName The name of the field.
     * @param string myMessage The message to show if the field is empty.
     * @param \/*Closure|* / string mywhen Indicates when the field is not allowed
     * to be empty. Valid values are false (never), "create", "update". If a
     * Closure is passed then the field will be required to be not empty when
     * the callback returns true.
     * @return this
     */
    auto notEmptyDate(string fieldName, string myMessage = null, /*Closure|*/ string mywhen/*  = false */) {
        mywhen = this.invertWhenClause(mywhen);

        return _allowEmptyFor(fieldName, EMPTY_STRING | EMPTY_DATE, mywhen, myMessage);
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
     * string fieldName The name of the field.
     * @param string myMessage The message to show if the field is not
     * @param \/*Closure|* / string mywhen Indicates when the field is allowed to be empty
     * Valid values are true, false, "create", "update". If a Closure is passed then
     * the field will allowed to be empty only when the callback returns true.
     */
    auto allowEmptyTime(string fieldName, string myMessage = null, /*Closure|*/ string mywhenA) {
        return _allowEmptyFor(fieldName, EMPTY_STRING | EMPTY_TIME, mywhen, myMessage);
    }

    /**
     * Require a field to be a non-empty time.
     *
     * Opposite to allowEmptyTime()
     * Params:
     * string fieldName The name of the field.
     * @param string myMessage The message to show if the field is empty.
     * @param \/*Closure|* / string mywhen Indicates when the field is not allowed
     * to be empty. Valid values are false (never), "create", "update". If a
     * Closure is passed then the field will be required to be not empty when
     * the callback returns true.
     * @see \UIM\Validation\Validator.allowEmptyTime()
     */
    auto notEmptyTime(string fieldName, string myMessage = null, /*Closure|*/ string mywhen/*  = false */) {
        auto mywhen = this.invertWhenClause(mywhen);

        return _allowEmptyFor(fieldName, EMPTY_STRING | EMPTY_TIME, mywhen, myMessage);
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
     * string fieldName The name of the field.
     * @param string myMessage The message to show if the field is not
     * @param \/*Closure|* / string mywhen Indicates when the field is allowed to be empty
     * Valid values are true, false, "create", "update". If a Closure is passed then
     * the field will allowed to be empty only when the callback returns false.
     */
    auto allowEmptyDateTime(string fieldName, string myMessage = null, /*Closure|*/ string mywhen/*  = true */) {
        return _allowEmptyFor(fieldName, EMPTY_STRING | EMPTY_DATE | EMPTY_TIME, mywhen, myMessage);
    }

    /**
     * Require a field to be a non empty date/time.
     *
     * Opposite to allowEmptyDateTime
     * Params:
     * string fieldName The name of the field.
     * @param string myMessage The message to show if the field is empty.
     * @param \/*Closure|* / string mywhen Indicates when the field is not allowed
     * to be empty. Valid values are false (never), "create", "update". If a
     * Closure is passed then the field will be required to be not empty when
     * the callback returns true.
     * @return this
     */
    auto notEmptyDateTime(string fieldName, string myMessage = null, /*Closure|*/ string mywhen/*  = false */) {
        mywhen = this.invertWhenClause(mywhen);

        return _allowEmptyFor(fieldName, EMPTY_STRING | EMPTY_DATE | EMPTY_TIME, mywhen, myMessage);
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
            return fn(mycontext) : !mywhen(mycontext);
        } */
        return mywhen;
    }

    /**
     * Add a notBlank rule to a field.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.notBlank()
     */
    auto notBlank(string fieldName, string myMessage = null, /*Closure|*/ string mywhen = null) {
        string message;
        if (myMessage.isNull) {
            message = !_useI18n
                ? "This field cannot be left empty" : __d("uim", "This field cannot be left empty");
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "notBlank", myextra ~ [
                "rule": "notBlank",
            ]);
    }

    /**
     * Add an alphanumeric rule to a field.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.alphaNumeric()
     */
    auto alphaNumeric(string fieldName, string myMessage = null, /*Closure|*/ string mywhen = null) {
        if (myMessage.isNull) {
            myMessage = !_useI18n
                ? "The provided value must be alphanumeric" : __d("uim", "The provided value must be alphanumeric");
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "alphaNumeric", myextra ~ [
                "rule": "alphaNumeric",
            ]);
    }

    /**
     * Add a non-alphanumeric rule to a field.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.notAlphaNumeric()
     */
    auto notAlphaNumeric(string fieldName, string myMessage = null, /*Closure|*/ string mywhen = null) {
        if (myMessage.isNull) {

            if (!_useI18n) {
                myMessage = "The provided value must not be alphanumeric";
            } else {
                myMessage = __d("uim", "The provided value must not be alphanumeric");
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "notAlphaNumeric", myextra ~ [
                "rule": "notAlphaNumeric",
            ]);
    }

    /**
     * Add an ascii-alphanumeric rule to a field.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.asciiAlphaNumeric()
     */
    auto asciiAlphaNumeric(string fieldName, string myMessage = null, /*Closure|*/ string mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be ASCII-alphanumeric";
            } else {
                myMessage = __d("uim", "The provided value must be ASCII-alphanumeric");
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "asciiAlphaNumeric", myextra ~ [
                "rule": "asciiAlphaNumeric",
            ]);
    }

    /**
     * Add a non-ascii alphanumeric rule to a field.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.notAlphaNumeric()
     */
    auto notAsciiAlphaNumeric(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        auto myMessage = errorMessage;
        if (myMessage.isNull) {
            myMessage = !_useI18n
                ? "The provided value must not be ASCII-alphanumeric" : __d("uim", "The provided value must not be ASCII-alphanumeric");
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "notAsciiAlphaNumeric", myextra ~ [
                "rule": "notAsciiAlphaNumeric",
            ]);
    }

    /**
     * Add an rule that ensures a string length is within a range.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param Json[string] myrange The inclusive minimum and maximum length you want permitted.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.alphaNumeric()
     * @return this
     */
    auto lengthBetween(
        string fieldName,
        Json[string] myrange,
        string myMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (count(myrange) != 2) {
            throw new DInvalidArgumentException("The myrange argument requires 2 numbers");
        }
        mylowerBound = array_shift(myrange);
        myupperBound = array_shift(myrange);

        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage =
                    "The length of the provided value must be between `%s` and `%s`, inclusively"
                    .format(mylowerBound,
                        myupperBound
                    );
            } else {
                myMessage = __d(
                    "uim",
                    "The length of the provided value must be between `{0}` and `{1}`, inclusively",
                    mylowerBound,
                    myupperBound
                );
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "lengthBetween", myextra ~ [
                "rule": ["lengthBetween", mylowerBound, myupperBound],
            ]);
    }

    /**
     * Add a credit card rule to a field.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param string[] mytype The type of cards you want to allow. Defaults to "all".
     * You can also supply an array of accepted card types. e.g `["mastercard", "visa", "amex"]`
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.creditCard()
     */
    auto creditCard(
        string fieldName,
        string[] mytyp = null,
        string myMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        return creditCard(fieldName, mytype.join(", "), myMessage);
    }

    auto creditCard(
        string fieldName,
        string mytype = "all",
        string myMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        string mytypeEnumeration = mytype;

        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = mytype == "all"
                    ? "The provided value must be a valid credit card number of any type"
                    : "The provided value must be a valid credit card number of these types: `%s`"
                    .format(mytypeEnumeration);
            } else {
                myMessage = mytype == "all"
                    ? __d(
                        "uim",
                        "The provided value must be a valid credit card number of any type"
                    ) : __d(
                        "uim",
                        "The provided value must be a valid credit card number of these types: `{0}`",
                        mytypeEnumeration
                    );
            }
        }

        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);
        return _add(fieldName, "creditCard", myextra ~ [
                "rule": ["creditCard", mytype, true],
            ]);
    }

    /**
     * Add a greater than comparison rule to a field.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param float myvalue The value user data must be greater than.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    Json[string] greaterThan(
        string fieldName,
        float myvalue,
        string myMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (myMessage.isNull) {
            myMessage = !_useI18n
                ? "The provided value must be greater than `%s`".format(myvalue) : __d("uim", "The provided value must be greater than `{0}`", myvalue);
        }

        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);
        /* return _add(fieldName, "greaterThan", myextra ~ ["rule": ["comparison", Validation.COMPARE_GREATER, myvalue]]); */
        return null;
    }

    /**
     * Add a greater than or equal to comparison rule to a field.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param float myvalue The value user data must be greater than or equal to.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.comparison()
     */
    Json[string] greaterThanOrEqual(
        string fieldName,
        float myvalue,
        string myMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be greater than or equal to `%s`".format(
                    myvalue);
            } else {
                myMessage = __d("uim", "The provided value must be greater than or equal to `{0}`", myvalue);
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "greaterThanOrEqual", myextra ~ [
                "rule": [
                    "comparison", Validation.COMPARE_GREATER_OR_EQUAL, myvalue
                ],
            ]);
    }

    /**
     * Add a less than comparison rule to a field.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param float myvalue The value user data must be less than.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.comparison()
     */
    auto lessThan(
        string fieldName,
        float myvalue,
        string myMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (myMessage.isNull) {
            myMessage = !_useI18n
                ? "The provided value must be less than `%s`".format(myvalue) : __d("uim", "The provided value must be less than `{0}`", myvalue);
        }

        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);
        return _add(fieldName, "lessThan", myextra ~ [
                "rule": ["comparison", Validation.COMPARE_LESS, myvalue],
            ]);
    }

    /**
     * Add a less than or equal comparison rule to a field.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param float myvalue The value user data must be less than or equal to.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto lessThanOrEqual(
        string fieldName,
        float myvalue,
        string myMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be less than or equal to `%s`".format(myvalue);
            } else {
                myMessage = __d("uim", "The provided value must be less than or equal to `{0}`", myvalue);
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "lessThanOrEqual", myextra ~ [
                "rule": [
                    "comparison", Validation.COMPARE_LESS_OR_EQUAL, myvalue
                ],
            ]);
    }

    /**
     * Add a equal to comparison rule to a field.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param Json aValue The value user data must be equal to.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.comparison()
     */
    auto equals(
        string fieldName,
        Json aValue,
        string myMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (myMessage.isNull) {
            myMessage = !_useI18n
                ? "The provided value must be equal to `%s`".format(myvalue) : __d("uim", "The provided value must be equal to `{0}`", myvalue);
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "equals", myextra ~ [
                "rule": ["comparison", Validation.COMPARE_EQUAL, myvalue],
            ]);
    }

    /**
     * Add a not equal to comparison rule to a field.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param Json aValue The value user data must be not be equal to.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.comparison()
     */
    auto notEquals(
        string fieldName,
        Json aValue,
        string myMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must not be equal to `%s`".format(myvalue);
            } else {
                myMessage = __d("uim", "The provided value must not be equal to `{0}`", myvalue);
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "notEquals", myextra ~ [
                "rule": ["comparison", Validation.COMPARE_NOT_EQUAL, myvalue],
            ]);
    }

    /**
     * Add a rule to compare two fields to each other.
     *
     * If both fields have the exact same value the rule will pass.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param string mysecondField The field you want to compare against.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.compareFields()
     */
    auto sameAs(
        string fieldName,
        string mysecondField,
        string myMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = sprintf("The provided value must be same as `%s`", mysecondField);
            } else {
                myMessage = __d("uim", "The provided value must be same as `{0}`", mysecondField);
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "sameAs", myextra ~ [
                "rule": [
                    "compareFields", mysecondField, Validation.COMPARE_SAME
                ],
            ]);
    }

    /**
     * Add a rule to compare that two fields have different values.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param string mysecondField The field you want to compare against.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.compareFields()
     * @return this
     */
    auto notSameAs(
        string fieldName,
        string mysecondField,
        string myMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must not be same as `%s`".format(mysecondField);
            } else {
                myMessage = __d("uim", "The provided value must not be same as `{0}`", mysecondField);
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "notSameAs", myextra ~ [
                "rule": [
                    "compareFields", mysecondField, Validation.COMPARE_NOT_SAME
                ],
            ]);
    }

    /**
     * Add a rule to compare one field is equal to another.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param string mysecondField The field you want to compare against.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto equalToField(
        string fieldName,
        string mysecondField,
        string myMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = sprintf("The provided value must be equal to the one of field `%s`", mysecondField);
            } else {
                myMessage = __d(
                    "uim",
                    "The provided value must be equal to the one of field `{0}`",
                    mysecondField
                );
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "equalToField", myextra ~ [
                "rule": [
                    "compareFields", mysecondField, Validation.COMPARE_EQUAL
                ],
            ]);
    }

    /**
     * Add a rule to compare one field is not equal to another.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param string mysecondField The field you want to compare against.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.compareFields()
     * @return this
     */
    auto notEqualToField(
        string fieldName,
        string mysecondField,
        string myMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = sprintf("The provided value must not be equal to the one of field `%s`", mysecondField);
            } else {
                myMessage = __d(
                    "uim",
                    "The provided value must not be equal to the one of field `{0}`",
                    mysecondField
                );
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "notEqualToField", myextra ~ [
                "rule": [
                    "compareFields", mysecondField, Validation.COMPARE_NOT_EQUAL
                ],
            ]);
    }

    /**
     * Add a rule to compare one field is greater than another.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param string mysecondField The field you want to compare against.
     * @param string errorMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.compareFields()
     * @return this
     */
    auto greaterThanField(
        string fieldName,
        string mysecondField,
        string errorMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        auto myMessage = errorMessage;
        if (myMessage.isNull) {
            myMessage = !_useI18n
                ? sprintf("The provided value must be greater than the one of field `%s`", mysecondField) : __d(
                    "uim",
                    "The provided value must be greater than the one of field `{0}`",
                    mysecondField
                );
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "greaterThanField", myextra ~ [
                "rule": [
                    "compareFields", mysecondField, Validation.COMPARE_GREATER
                ],
            ]);
    }

    /**
     * Add a rule to compare one field is greater than or equal to another.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param string mysecondField The field you want to compare against.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.compareFields()
     * @return this
     */
    auto greaterThanOrEqualToField(
        string fieldName,
        string mysecondField,
        string myMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage =
                    "The provided value must be greater than or equal to the one of field `%s`"
                    .format(mysecondField
                    );
            } else {
                myMessage = __d(
                    "uim",
                    "The provided value must be greater than or equal to the one of field `{0}`",
                    mysecondField
                );
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "greaterThanOrEqualToField", myextra ~ [
                "rule": [
                    "compareFields", mysecondField,
                    Validation.COMPARE_GREATER_OR_EQUAL
                ],
            ]);
    }

    /**
     * Add a rule to compare one field is less than another.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param string mysecondField The field you want to compare against.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.compareFields()
     */
    auto lessThanField(
        string fieldName,
        string mysecondField,
        string myMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be less than the one of field `%s`".format(
                    mysecondField);
            } else {
                myMessage = __d(
                    "uim",
                    "The provided value must be less than the one of field `{0}`",
                    mysecondField
                );
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "lessThanField", myextra ~ [
                "rule": [
                    "compareFields", mysecondField, Validation.COMPARE_LESS
                ],
            ]);
    }

    /**
     * Add a rule to compare one field is less than or equal to another.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param string mysecondField The field you want to compare against.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.compareFields()
     * @return this
     */
    auto lessThanOrEqualToField(
        string fieldName,
        string mysecondField,
        string myMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage =
                    "The provided value must be less than or equal to the one of field `%s`"
                    .format(mysecondField
                    );
            } else {
                myMessage = __d(
                    "uim",
                    "The provided value must be less than or equal to the one of field `{0}`",
                    mysecondField
                );
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "lessThanOrEqualToField", myextra ~ [
                "rule": [
                    "compareFields", mysecondField,
                    Validation.COMPARE_LESS_OR_EQUAL
                ],
            ]);
    }

    /**
     * Add a date format validation rule to a field.
     * Params:
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto date(
        string fieldName,
        string[] dateFormats = ["ymd"],
        string myMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        auto myformatEnumeration = join(", ", dateFormats);

        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = sprintf(
                    "The provided value must be a date of one of these formats: `%s`",
                    myformatEnumeration
                );
            } else {
                myMessage = __d(
                    "uim",
                    "The provided value must be a date of one of these formats: `{0}`",
                    myformatEnumeration
                );
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "date", myextra ~ [
                "rule": ["date", dateFormats],
            ]);
    }

    /**
     * Add a date time format validation rule to a field.
     * Params:
     * @param string[] dateFormats A list of accepted date formats.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto dateTime(
        string fieldName,
        string[] dateFormats = ["ymd"],
        string myMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        myformatEnumeration = join(", ", dateFormats);

        if (myMessage.isNull) {
            myMessage = !_useI18n
                ? "The provided value must be a date and time of one of these formats: `%s`"
                .format(myformatEnumeration
                ) : __d(
                    "uim",
                    "The provided value must be a date and time of one of these formats: `{0}`",
                    myformatEnumeration
                );
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "dateTime", myextra ~ [
                "rule": ["datetime", dateFormats],
            ]);
    }

    /**
     * Add a time format validation rule to a field.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.time()
     */
    auto time(string fieldName, string myMessage = null, /*Closure|*/ string mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be a time";
            } else {
                myMessage = __d("uim", "The provided value must be a time");
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "time", myextra ~ [
                "rule": "time",
            ]);
    }

    /**
     * Add a localized time, date or datetime format validation rule to a field.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param string mytype Parser type, one out of "date", "time", and "datetime"
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto localizedTime(
        string fieldName,
        string mytype = "datetime",
        string myMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be a localized time, date or date and time";
            } else {
                myMessage = __d("uim", "The provided value must be a localized time, date or date and time");
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "localizedTime", myextra ~ [
                "rule": ["localizedTime", mytype],
            ]);
    }

    /**
     * Add a boolean validation rule to a field.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.isBoolean()
     */
    auto isBoolean(string fieldName, string myMessage = null, /*Closure|*/ string mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be a boolean";
            } else {
                myMessage = __d("uim", "The provided value must be a boolean");
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "boolean", myextra ~ [
                "rule": "boolean",
            ]);
    }

    /**
     * Add a decimal validation rule to a field.
     * Params:
     * @param int myplaces The number of decimal places to require.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto decimal(
        string fieldName,
        int myplaces = 0,
        string myMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = myplaces.isNull
                    ? "The provided value must be decimal with any number of decimal places, including none"
                    : "The provided value must be decimal with `%s` decimal places".format(
                        myplaces);

            } else {
                myMessage = myplaces.isNull
                    ? __d(
                        "uim",
                        "The provided value must be decimal with any number of decimal places, including none"
                    ) : __d(
                        "uim",
                        "The provided value must be decimal with `{0}` decimal places",
                        myplaces
                    );
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "decimal", myextra ~ [
                "rule": ["decimal", myplaces],
            ]);
    }

    /**
     * Add an email validation rule to a field.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param bool mycheckMX Whether to check the MX records.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto email(
        string fieldName,
        bool mycheckMX = false,
        string myMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (myMessage.isNull) {
            myMessage = !_useI18n
                ? "The provided value must be an e-mail address" : __d("uim", "The provided value must be an e-mail address");
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "email", myextra ~ [
                "rule": ["email", mycheckMX],
            ]);
    }

    /**
     * Add a backed enum validation rule to a field.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param class-string<\BackedEnum> myenumClassName The valid backed enum class name.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto enumeration(
        string fieldName,
        string myenumClassName,
        string myMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        /* if (!isIn(BackedEnum.classname, (array) class_implements(myenumClassName), true)) {
            throw new DInvalidArgumentException(
                "The `myenumClassName` argument must be the classname of a valid backed enum."
            );
        } */
        if (myMessage.isNull) {
            string[] mycases; // TODO = array_map(fn (mycase): mycase.value, myenumClassName.cases());
            string mycaseOptions = mycases.join("`, `");

            myMessage = !_useI18n
                ? "The provided value must be one of `%s`".format(mycaseOptions) : __d("uim", "The provided value must be one of `{0}`", mycaseOptions);

        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "enum", myextra ~ [
                "rule": ["enum", myenumClassName],
            ]);
    }

    /**
     * Add an IP validation rule to a field.
     *
     * This rule will accept both IPv4 and IPv6 addresses.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto ip(string fieldName, string myMessage = null, /*Closure|*/ string mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be an IP address";
            } else {
                myMessage = __d("uim", "The provided value must be an IP address");
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "ip", myextra ~ [
                "rule": "ip",
            ]);
    }

    /**
     * Add an IPv4 validation rule to a field.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.ip()
     */
    auto ipv4(string fieldName, string myMessage = null, /*Closure|*/ string mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be an IPv4 address";
            } else {
                myMessage = __d("uim", "The provided value must be an IPv4 address");
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "ipv4", myextra ~ [
                "rule": ["ip", "ipv4"],
            ]);
    }

    /**
     * Add an IPv6 validation rule to a field.
     * Params:
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto ipv6(string fieldName, string myMessage = null, /*Closure|*/ string mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be an IPv6 address";
            } else {
                myMessage = __d("uim", "The provided value must be an IPv6 address");
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "ipv6", myextra ~ [
                "rule": ["ip", "ipv6"],
            ]);
    }

    /**
     * Add a string length validation rule to a field.
     * Params:
     * @param int mymin The minimum length required.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto minLength(string fieldName, int mymin, string myMessage = null, /*Closure|*/ string mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = sprintf("The provided value must be at least `%s` characters long", mymin);
            } else {
                myMessage = __d("uim", "The provided value must be at least `{0}` characters long", mymin);
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "minLength", myextra ~ [
                "rule": ["minLength", mymin],
            ]);
    }

    /**
     * Add a string length validation rule to a field.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param int mymin The minimum length required.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto minLengthBytes(string fieldName, int mymin, string myMessage = null, /*Closure|*/ string mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = sprintf("The provided value must be at least `%s` bytes long", mymin);
            } else {
                myMessage = __d("uim", "The provided value must be at least `{0}` bytes long", mymin);
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "minLengthBytes", myextra ~ [
                "rule": ["minLengthBytes", mymin],
            ]);
    }

    /**
     * Add a string length validation rule to a field.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param int mymax The maximum length allowed.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto maxLength(string fieldName, int mymax, string myMessage = null, /*Closure|*/ string mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = sprintf("The provided value must be at most `%s` characters long", mymax);
            } else {
                myMessage = __d("uim", "The provided value must be at most `{0}` characters long", mymax);
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "maxLength", myextra ~ [
                "rule": ["maxLength", mymax],
            ]);
    }

    /**
     * Add a string length validation rule to a field.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param int mymax The maximum length allowed.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto maxLengthBytes(string fieldName, int mymax, string myMessage = null, /*Closure|*/ string mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be at most `%s` bytes long".format(mymax);
            } else {
                myMessage = __d("uim", "The provided value must be at most `{0}` bytes long", mymax);
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "maxLengthBytes", myextra ~ [
                "rule": ["maxLengthBytes", mymax],
            ]);
    }

    /**
     * Add a numeric value validation rule to a field.
     * Params:
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto numeric(string fieldName, string myMessage = null, /*Closure|*/ string mywhen = null) {
        if (myMessage.isNull) {
            myMessage = !_useI18n
                ? "The provided value must be numeric" : __d("uim", "The provided value must be numeric");

        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "numeric", myextra ~ [
                "rule": "numeric",
            ]);
    }

    /**
     * Add a natural number validation rule to a field.
     * Params:
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto naturalNumber(string fieldName, string myMessage = null, /*Closure|*/ string mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be a natural number";
            } else {
                myMessage = __d("uim", "The provided value must be a natural number");
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "naturalNumber", myextra ~ [
                "rule": ["naturalNumber", false],
            ]);
    }

    /**
     * Add a validation rule to ensure a field is a non negative integer.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.naturalNumber()
     */
    auto nonNegativeInteger(string fieldName, string myMessage = null, /*Closure|*/ string mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be a non-negative integer";
            } else {
                myMessage = __d("uim", "The provided value must be a non-negative integer");
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "nonNegativeInteger", myextra ~ [
                "rule": ["naturalNumber", true],
            ]);
    }

    /**
     * Add a validation rule to ensure a field is within a numeric range
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param Json[string] myrange The inclusive upper and lower bounds of the valid range.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto range(string fieldName, Json[string] myrange, string myMessage = null, /*Closure|*/ string mywhen = null) {
        if (count(myrange) != 2) {
            throw new DInvalidArgumentException("The myrange argument requires 2 numbers");
        }
        auto mylowerBound = array_shift(myrange);
        auto myupperBound = array_shift(myrange);

        if (myMessage.isNull) {
            myMessage = !_useI18n
                ? "The provided value must be between `%s` and `%s`, inclusively".format(mylowerBound, myupperBound) : __d(
                    "uim",
                    "The provided value must be between `{0}` and `{1}`, inclusively",
                    mylowerBound, myupperBound
                );
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "range", myextra ~ [
                "rule": ["range", mylowerBound, myupperBound],
            ]);
    }

    /**
     * Add a validation rule to ensure a field is a URL.
     *
     * This validator does not require a protocol.
     * Params:
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto url(string fieldName, string myMessage = null, /*Closure|*/ string mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be a URL";
            } else {
                myMessage = __d("uim", "The provided value must be a URL");
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "url", myextra ~ [
                "rule": ["url", false],
            ]);
    }

    /**
     * Add a validation rule to ensure a field is a URL.
     *
     * This validator requires the URL to have a protocol.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.url()
     */
    auto urlWithProtocol(string fieldName, string myMessage = null, /*Closure|*/ string mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be a URL with protocol";
            } else {
                myMessage = __d("uim", "The provided value must be a URL with protocol");
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "urlWithProtocol", myextra ~ [
                "rule": ["url", true],
            ]);
    }

    /**
     * Add a validation rule to ensure the field value is within an allowed list.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param Json[string] mylist The list of valid options.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto inList(string fieldName, Json[string] mylist, string myMessage = null, /*Closure|*/ string mywhen = null) {
        mylistEnumeration = join(", ", mylist);

        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = sprintf("The provided value must be one of: `%s`", mylistEnumeration);
            } else {
                myMessage = __d(
                    "uim",
                    "The provided value must be one of: `{0}`",
                    mylistEnumeration
                );
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "inList", myextra ~ [
                "rule": ["inList", mylist],
            ]);
    }

    /**
     * Add a validation rule to ensure the field is a UUID
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.uuid()
     */
    auto uuid(string fieldName, string myMessage = null, /*Closure|*/ string mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be a UUID";
            } else {
                myMessage = __d("uim", "The provided value must be a UUID");
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "uuid", myextra ~ [
                "rule": "uuid",
            ]);
    }

    /**
     * Add a validation rule to ensure the field is an uploaded file
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param Json[string] options An array of options.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.uploadedFile() For options
     */
    auto uploadedFile(
        string fieldName,
        Json[string] options,
        string myMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be an uploaded file";
            } else {
                myMessage = __d("uim", "The provided value must be an uploaded file");
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "uploadedFile", myextra ~ [
                "rule": ["uploadedFile", options],
            ]);
    }

    /**
     * Add a validation rule to ensure the field is a lat/long tuple.
     *
     * e.g. `<lat>, <lng>`
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.geoCoordinate()
     */
    auto latLong(string fieldName, string myMessage = null, /*Closure|*/ string mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be a latitude/longitude coordinate";
            } else {
                myMessage = __d("uim", "The provided value must be a latitude/longitude coordinate");
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "latLong", myextra ~ [
                "rule": "geoCoordinate",
            ]);
    }

    /**
     * Add a validation rule to ensure the field is a latitude.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.latitude()
     */
    auto latitude(string fieldName, string myMessage = null, /*Closure|*/ string mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be a latitude";
            } else {
                myMessage = __d("uim", "The provided value must be a latitude");
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "latitude", myextra ~ [
                "rule": "latitude",
            ]);
    }

    /**
     * Add a validation rule to ensure the field is a longitude.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.longitude()
     */
    auto longitude(string fieldName, string myMessage = null, /*Closure|*/ string mywhen = null) {
        if (myMessage.isNull) {
            myMessage = !_useI18n
                ? "The provided value must be a longitude" : __d("uim", "The provided value must be a longitude");

        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "longitude", myextra ~ [
                "rule": "longitude",
            ]);
    }

    /**
     * Add a validation rule to ensure a field contains only ascii bytes
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.ascii()
     */
    auto ascii(string fieldName, string myMessage = null, /*Closure|*/ string mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be ASCII bytes only";
            } else {
                myMessage = __d("uim", "The provided value must be ASCII bytes only");
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "ascii", myextra ~ [
                "rule": "ascii",
            ]);
    }

    /**
     * Add a validation rule to ensure a field contains only BMP utf8 bytes
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.utf8()
     */
    auto utf8(string fieldName, string myMessage = null, /*Closure|*/ string mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be UTF-8 bytes only";
            } else {
                myMessage = __d("uim", "The provided value must be UTF-8 bytes only");
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "utf8", myextra ~ [
                "rule": ["utf8", ["extended": false.toJson]],
            ]);
    }

    /**
     * Add a validation rule to ensure a field contains only utf8 bytes.
     *
     * This rule will accept 3 and 4 byte UTF8 sequences, which are necessary for emoji.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.utf8()
     */
    auto utf8Extended(string fieldName, string myMessage = null, /*Closure|*/ string mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be 3 and 4 byte UTF-8 sequences only";
            } else {
                myMessage = __d("uim", "The provided value must be 3 and 4 byte UTF-8 sequences only");
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "utf8Extended", myextra ~ [
                "rule": ["utf8", ["extended": true.toJson]],
            ]);
    }

    /**
     * Add a validation rule to ensure a field is an integer value.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.isInteger()
     */
    auto integer(string fieldName, string myMessage = null, /*Closure|*/ string mywhen = null) {
        if (myMessage.isNull) {
            myMessage = !_useI18n
                ? myMessage = "The provided value must be an integer" : __d("uim", "The provided value must be an integer");
        }

        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);
        return _add(fieldName, "integer", myextra ~ [
                "rule": "isInteger",
            ]);
    }

    /**
     * Add a validation rule to ensure that a field contains an array.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.isArray()
     */
    auto array(string fieldName, string myMessage = null, /*Closure|*/ string mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be an array";
            } else {
                myMessage = __d("uim", "The provided value must be an array");
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "array", myextra ~ [
                "rule": "isArray",
            ]);
    }

    /**
     * Add a validation rule to ensure that a field contains a scalar.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto scalar(string fieldName, string myMessage = null, /*Closure|*/ string mywhen = null) {
        if (myMessage.isNull) {
            myMessage = "The provided value must be scalar";
            if (_useI18n) {
                myMessage = __d("uim", "The provided value must be scalar");
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "scalar", myextra ~ [
                "rule": "isScalar",
            ]);
    }

    /**
     * Add a validation rule to ensure a field is a 6 digits hex color value.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.hexColor()
     */
    auto hexColor(string fieldName, string myMessage = null, /*Closure|*/ string mywhen = null) {
        if (myMessage.isNull) {
            myMessage = "The provided value must be a hex color";
            if (_useI18n) {
                myMessage = __d("uim", "The provided value must be a hex color");
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "hexColor", myextra ~ [
                "rule": "hexColor",
            ]);
    }

    /**
     * Add a validation rule for a multiple select. Comparison is case sensitive by default.
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param Json[string] options The options for the validator. Includes the options defined in
     * \UIM\Validation\Validation.multiple() and the `caseInsensitive` parameter.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.multiple()
     */
    auto multipleOptions(
        string fieldName,
        Json[string] optionData = null,
        string myMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (myMessage.isNull) {
            myMessage = "The provided value must be a set of multiple options";
            if (_useI18n) {
                myMessage = __d("uim", "The provided value must be a set of multiple options");
            }
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);
        auto mycaseInsensitive = options.getBoolean("caseInsensitive", false);
        options.remove("caseInsensitive");

        return _add(fieldName, "multipleOptions", myextra ~ [
                "rule": ["multiple", options, mycaseInsensitive],
            ]);
    }

    /**
     * Add a validation rule to ensure that a field is an array containing at least
     * the specified amount of elements
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param int mycount The number of elements the array should at least have
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.numElements()
     */
    Json[string] hasAtLeast(string fieldName, int mycount, string myMessage = null, /*Closure|*/ string mywhen = null) {
        if (myMessage.isNull) {
            myMessage = !_useI18n
                ? sprintf("The provided value must have at least `%s` elements", mycount) : __d("uim", "The provided value must have at least `{0}` elements", mycount);

        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        /* return _add(fieldName, "hasAtLeast", myextra ~ [
            "rule": auto (myvalue) use (mycount) {
                if (isArray(myvalue) && isSet(myvalue["_ids"])) {
                    myvalue = myvalue["_ids"];
                }
                return Validation.numElements(myvalue, Validation.COMPARE_GREATER_OR_EQUAL, mycount);
            },
        ]); */
        return null;
    }

    /**
     * Add a validation rule to ensure that a field is an array containing at most
     * the specified amount of elements
     * Params:
     * string fieldName The field you want to apply the rule to.
     * @param int mycount The number maximum amount of elements the field should have
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.numElements()
     */
    Json[string] hasAtMost(string fieldName, int mycount, string myMessage = null, /*Closure|*/ string mywhen = null) {
        if (myMessage.isNull) {
            myMessage = !_useI18n
                ? "The provided value must have at most `%s` elements".format(mycount) : __d("uim", "The provided value must have at most `{0}` elements", mycount);
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        /* return _add(fieldName, "hasAtMost", myextra ~ [
            "rule": auto (myvalue) use (mycount) {
                if (isArray(myvalue) && isSet(myvalue["_ids"])) {
                    myvalue = myvalue["_ids"];
                }
                return Validation.numElements(myvalue, Validation.COMPARE_LESS_OR_EQUAL, mycount);
            },
        ]); */
        return null;
    }

    /**
     * Returns whether a field can be left empty for a new or already existing
     * record.
     * Params:
     * string fieldName Field name.
     * @param bool mynewRecord whether the data to be validated is new or to be updated.
     */
    bool isEmptyAllowed(string fieldName, bool mynewRecord) {
        myproviders = _providers;
        mydata = null;
        mycontext = compact("data", "newRecord", "field", "providers");

        return _canBeEmpty(this.field(fieldName), mycontext);
    }

    /**
     * Returns whether a field can be left out for a new or already existing
     * record.
     * Params:
     * string fieldName Field name.
     * @param bool mynewRecord Whether the data to be validated is new or to be updated.
     */
    bool isPresenceRequired(string fieldName, bool mynewRecord) {
        /*  myproviders = _providers;
        mydata = null;
        mycontext = compact("data", "newRecord", "field", "providers");

        return !_checkPresence(this.field(fieldName), mycontext); */
        return false;
    }

    /**
     * Returns whether a field matches against a regular expression.
     * Params:
     * string fieldName Field name.
     * @param string myregex Regular expression.
     * @param string myMessage The error message when the rule fails.
     * @param \/*Closure|* / string mywhen Either "create" or "update" or a Closure that returns
     * true when the validation rule should be applied.
     */
    auto regex(string fieldName, string myregex, string myMessage = null, /*Closure|*/ string mywhen = null) {
        /* if (myMessage.isNull) {
            myMessage = !_useI18n
                ? "The provided value must match against the pattern `%s`".format(myregex)
                : __d("uim", "The provided value must match against the pattern `{0}`", myregex);
        }
        Json[string] myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "regex", myextra ~ [
            "rule": ["custom", myregex],
        ]); */
        return false;
    }

    /**
     * Gets the required message for a field
     * Params:
     * string fieldName Field name
     */
    string getRequiredMessage(string fieldName) {
        if (!_fields.hasKey(fieldName)) {
            return null;
        }
        if (isSet(_presenceMessages[fieldName])) {
            return _presenceMessages[fieldName];
        }
        auto myMessage = !_useI18n
            ? "This field is required" : __d("uim", "This field is required");

        return myMessage;
    }

    // Gets the notEmpty message for a field
    string getNotEmptyMessage(string fieldName) {
        if (!_fields.hasKey(fieldName)) {
            return null;
        }
        foreach (myrule; _fields[fieldName]) {
            if (myrule.get("rule") == "notBlank" && myrule.get("message")) {
                return myrule.get("message");
            }
        }
        if (isSet(_allowEmptyMessages[fieldName])) {
            return _allowEmptyMessages[fieldName];
        }

        return !_useI18n
            ? "This field cannot be left empty" : __d("uim", "This field cannot be left empty");
    }

    /**
     * Returns false if any validation for the passed rule set should be stopped
     * due to the field missing in the data array
     * Params:
     * \UIM\Validation\ValidationSet fieldName The set of rules for a field.
     * @param Json[string] mycontext A key value list of data containing the validation context.
     */
    protected bool _checkPresence(DValidationSet fieldName, Json[string] mycontext) {
        auto myrequired = fieldName.isPresenceRequired();
        if (cast(Closure) myrequired) {
            return !myrequired(mycontext);
        }

        auto mynewRecord = mycontext["newRecord"];
        if (myrequired.isIn([WHEN_CREATE, WHEN_UPDATE])) {
            return (myrequired == WHEN_CREATE && !mynewRecord) ||
                (myrequired == WHEN_UPDATE && mynewRecord);
        }
        return !myrequired;
    }

    /**
     * Returns whether the field can be left blank according to `allowEmpty`
     * Params:
     * \UIM\Validation\ValidationSet fieldName the set of rules for a field
     * @param Json[string] mycontext a key value list of data containing the validation context.
     */
    protected bool _canBeEmpty(DValidationSet fieldName, Json[string] mycontext) {
        auto myallowed = fieldName.isEmptyAllowed();
        if (cast(Closure) myallowed) {
            return myallowed(mycontext);
        }

        auto mynewRecord = mycontext["newRecord"];
        if (myallowed.isIn([WHEN_CREATE, WHEN_UPDATE])) {
            myallowed = (myallowed == WHEN_CREATE && mynewRecord) ||
                (myallowed == WHEN_UPDATE && !mynewRecord);
        }
        return !myallowed.isEmpty;
    }

    /**
     * Returns true if the field is empty in the passed data array
     * Params:
     * Json mydata Value to check against.
     * @param int myflags A bitmask of EMPTY_* flags which specify what is empty
     */
    protected bool isEmpty(Json mydata, int myflags) {
        if (mydata.isNull) {
            return true;
        }
        if (mydata == "" && (myflags & EMPTY_STRING)) {
            return true;
        }
        myarrayTypes = EMPTY_ARRAY | EMPTY_DATE | EMPTY_TIME;
        if (mydata == [] && (myflags & myarrayTypes)) {
            return true;
        }
        if (isArray(mydata)) {
            myallFieldsAreEmpty = true;
            foreach (mydata; fieldName) {
                if (fieldName !is null && fieldName != "") {
                    myallFieldsAreEmpty = false;
                    break;
                }
            }
            if (myallFieldsAreEmpty) {
                if ((myflags & EMPTY_DATE) && isSet(mydata["year"])) {
                    return true;
                }
                if ((myflags & EMPTY_TIME) && isSet(mydata["hour"])) {
                    return true;
                }
            }
        }

        return (myflags & EMPTY_FILE) && cast(IUploadedFile) mydata && mydata.getError() == UPLOAD_ERR_NO_FILE;
    }

    /**
     * Iterates over each rule in the validation set and collects the errors resulting
     * from executing them
     * Params:
     * string fieldName The name of the field that is being processed
     * @param \UIM\Validation\ValidationSet myrules the list of rules for a field
     * @param Json[string] data the full data passed to the validator
     * @param bool mynewRecord whether is it a new record or an existing one
     */
    protected Json[string] _processRules(string fieldName, DValidationSet myrules, Json[string] data, bool mynewRecord) {
        Json[string] myerrors = null;
        // Loading default provider in case there is none
        getProvider("default");

        auto myMessage = !_useI18n
            ? "The provided value is invalid" : __d("uim", "The provided value is invalid");

        foreach (myname, myrule; myrules) {
            auto result = myrule.process(mydata[fieldName], _providers, compact("newRecord", "data", "field"));
            if (result == true) {
                continue;
            }

            myerrors[myname] = myMessage;
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
        return myerrors;
    }

    // Get the printable version of this object.
    Json[string] debugInfo() {
        Json[string] fields = null;
        _fields.byKeyValue.each!(
            nameSet => fields[nameSet.key] = [
                "isPresenceRequired": nameSet.value.isPresenceRequired(),
                "isEmptyAllowed": nameSet.value.isEmptyAllowed(),
                "rules": nameSet.value.rules().keys(),
            ]);

        return [
            "_presenceMessages": _presenceMessages,
            "_allowEmptyMessages": _allowEmptyMessages,
            "_allowEmptyFlags": _allowEmptyFlags,
            "_useI18n": _useI18n,
            "_stopOnFailure": _stopOnFailure,
            "_providers": _providers.keys,
            "_fields": fieldNames,
        ];
    }
}
