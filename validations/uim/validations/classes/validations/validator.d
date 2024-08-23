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
     */
    protected Json[string] _providers = null;

    protected Json[string] _extraData;
    // An associative array of objects or classes used as a default provider list
    protected static Json[string] _defaultProviders = null;

    // Whether to apply last flag to generated rule(s).
    protected bool _stopOnFailure = false;

    this() {
        /* _useI18n = function_hasKey("\\UIM\\I18n\\__d");
        _providers = _defaultProviders; */
    }

    /**
     * Whether to stop validation rule evaluation on the first failed rule.
     *
     * When enabled the first failing rule per field will cause validation to stop.
     * When disabled all rules will be run even if there are failures.
     * Params:
     * bool shouldStopOnFailure If to apply last flag.
     */
    void setStopOnFailure(bool shouldStopOnFailure = true) {
        _stopOnFailure = shouldStopOnFailure;
    }

    // Validates and returns an array of failed fields and their error messages.
    auto validate(Json[string] data, bool isNewRecord = true) {
        Json[string] myerrors = null;
        /* foreach (ruleNames, fieldName; _fields) {
            auto ruleNames = to!string(ruleNames);
            auto mykeyPresent = data.hasKey(ruleNames);

            auto providers = _providers;
            auto context = compact("data", "newRecord", "field", "providers");

            if (!mykeyPresent && !_checkPresence(fieldName, context)) {
                myerrors.setPath([ruleNames, "_required"], getRequiredMessage(ruleNames));
                continue;
            }
            if (!mykeyPresent) {
                continue;
            }
            auto canBeEmpty = _canBeEmpty(fieldName, context);

            auto myflags = EMPTY_NULL;
            if (_allowEmptyFlags.hasKey(ruleNames)) {
                myflags = _allowEmptyFlags[ruleNames];
            }

            bool myisEmpty = isEmpty(data[ruleNames], myflags);
            if (!canBeEmpty && myisEmpty) {
                myerrors.setPath([ruleNames, "_empty"], getNotEmptyMessage(ruleNames));
                continue;
            }
            if (myisEmpty) {
                continue;
            }

            auto result = _processRules(ruleNames, fieldName, data, isNewRecord);
            if (result) {
                myerrors.set(ruleNames, result);
            }
        } */
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
     */
    void setProvider(string name, /* object */ string providerClassname) {
        _providers[name] = providerClassname;
    }

    /**
     * Returns the provider stored under that name if it exists.
     * Params:
     * string ruleNames The name under which the provider should be set.
     */
    /* object */
    string getProvider(string ruleNames) {
        /*        if (_providers.hasKey(ruleNames)) {
            return _providers[ruleNames];
        }
        if (ruleNames != "default") {
            return null;
        }
        _providers[ruleNames] = new DRulesProvider();

        return _providers[ruleNames]; */
        return null;
    }

    /**
     * Returns the default provider stored under that name if it exists.
     * Params:
     * string ruleNames The name under which the provider should be retrieved.
     */
    static  /* object */ string getDefaultProvider(string ruleNames) {
        // return _defaultProviders.get(ruleNames);
        return null;
    }

    // Associates an object to a name so it can be used as a default provider.
    static void addDefaultProvider(string ruleNames, /* object */ string myobject) {
        _defaultProviders[ruleNames] = myobject;
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
    bool offsethasKey(Json fieldName) {
        // return _fields.getBoolean(fieldName);
        return false;
    }

    // Returns the rule set for a field
    DValidationSet offsetGet(string fieldName) {
        // return _field(fieldName);
        return null;
    }

    // Sets the rule set for a field
    void offsetSet(string fieldName, DValidationSet validationRules) {
        auto myset = new DValidationSet();
        /*    validationRules.byKeyValue.each!(nameRule => myset.add(nameRule.key, nameRule.value));
            myrules = validationRules;
        */
    }

    void offsetSet(string fieldName, Json myrules) {
        // TODO _fields[fieldName] = myrules;
    }

    // Unsets the rule set for a field
    void offsetUnset(string fieldName) {
        _fields.removeKey(fieldName);
    }

    // Returns an iterator for each of the fields to be validated
    /* Traversable<string, DValidationSet> getIterator() {
        return new DArrayIterator(_fields);
    } */

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
     *        .add("title", "required", ["rule", "notBlank"])
     *        .add("user_id", "valid", ["rule", "numeric", "message": "Invalid User"])
     *
     *    myvalidator.add("password", [
     *        "size": ["rule": ["lengthBetween", 8, 20]],
     *        "hasSpecialCharacter": ["rule", "validateSpecialchar", "message": "not valid"]
     *    ]);
     * ```
     */
    /*    auto add(string fieldName, string[] ruleNames, ValidationRule[] validationRules= null) {
    }
 */
    void add(string fieldName, string[] ruleNames, DValidationRule[] validationRules = null) {
        // TODO auto myvalidationSet = field(fieldName);

        /*        if (!isArray(ruleNames)) {
            validationRules = [ruleNames: ruleName];
        } else {
            validationRules = ruleNames;
        }
        validationRules.byKeyValue
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
     */
    auto addNested(
        string rootfieldName,
        DValidator validator,
        string errorMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        auto extraData = ["message": errorMessage, "on": mywhen].filterValues;
        /* 
        auto myvalidationSet = field(rootfieldName); */
        /* myvalidationSet.add(NESTED, extraData ~ ["rule": auto (myvalue, context) use (validator, errorMessage) {
            if (!myvalue.isArray) {
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
     */
    void addNestedMany(
        string rootFieldName,
        DValidator myvalidator,
        string errorMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        /* Json[string] myextra = filterValues(["message": errorMessage, "on": mywhen]);

        auto myvalidationSet = field(rootFieldName); */
        /*        myvalidationSet.add(NESTED, extraData.set("rule": auto (myvalue, context) use (myvalidator, errorMessage) {
            if (!isArray(myvalue)) { return false; }

            providers().each!((name) {
                auto myprovider = getProvider(name);
                myvalidator.setProvider(name, myprovider);
            });

            auto myerrors = null;
            foreach (index: myrow; myvalue) {
                if (!isArray(myrow)) {
                    return false;
                }
                mycheck = myvalidator.validate(myrow, context["newRecord"]);
                if (!mycheck.isEmpty) {
                    myerrors[index] = mycheck;
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
     *        .removeKey("title", "required")
     *        .removeKey("user_id")
     * ```
     */
    void removeKey(string fieldName, string ruleName = null) {
        if (ruleName.isNull) {
            _fields.removeKey(fieldName);
        } else {
            field(fieldName).removeKey(ruleName);
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
     */
    void requirePresence(string[] fieldName, /*Closure|*/ string mymode /* = true */ , string message = null) {
        /* mydefaults = [
            "mode": mymode,
            "message": errorMessage,
        ]; */

        /*        if (!isArray(fieldName)) {
            fieldName = _convertValidatorToArray((string)fieldName, mydefaults);
        }
 */ /*        foreach (fieldName as fieldName: mysetting) {
            mysettings = _convertValidatorToArray((string)fieldName, mydefaults, mysetting);
            string fieldName = currentValue(mysettings.keys);

            field((string)fieldName).requirePresence(mysettings[fieldName]["mode"]);
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
     * return !context["newRecord"] || context.getString("data.role") == "admin";
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
     */
    void allowEmptyFor(
        string fieldName,
        size_t flags = 0, /*Closure|*/
        string when = null  /* = true */ ,
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
     */
    void allowEmptyString(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen /* = true */ ) {
        // TODO return _allowEmptyFor(fieldName, EMPTY_STRING, mywhen, errorMessage);
    }

    /**
     * Requires a field to not be an empty string.
     *
     * Opposite to allowEmptyString()
     */
    void notEmptyString(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen /* = false */ ) {
        mywhen = invertWhenClause(mywhen);
        // TODO return _allowEmptyFor(fieldName, EMPTY_STRING, mywhen, errorMessage);
    }

    /**
     * Allows a field to be an empty array.
     *
     * This method is equivalent to calling allowEmptyFor() with EMPTY_STRING +
     * EMPTY_ARRAY flags.
     */
    void allowEmptyArray(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen /* = true */ ) {
        // TODO return _allowEmptyFor(fieldName, EMPTY_STRING | EMPTY_ARRAY, mywhen, errorMessage);
    }

    /**
     * Require a field to be a non-empty array
     *
     * Opposite to allowEmptyArray()
     */
    void notEmptyArray(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen /* = false */ ) {
        mywhen = invertWhenClause(mywhen);

        // TODO return _allowEmptyFor(fieldName, EMPTY_STRING | EMPTY_ARRAY, mywhen, errorMessage);
    }

    /**
     * Allows a field to be an empty file.
     *
     * This method is equivalent to calling allowEmptyFor() with EMPTY_FILE flag.
     * File fields will not accept `""`, or `[]` as empty values. Only `null` and a file
     * upload with `error` equal to `UPLOAD_ERR_NO_FILE` will be treated as empty.
     */
    void allowEmptyFile(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen /* = true */ ) {
        // TODO return _allowEmptyFor(fieldName, EMPTY_FILE, mywhen, errorMessage);
    }

    /**
     * Require a field to be a not-empty file.
     *
     * Opposite to allowEmptyFile()
     */
    auto notEmptyFile(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen /* = false */ ) {
        mywhen = invertWhenClause(mywhen);

        // TODO return _allowEmptyFor(fieldName, EMPTY_FILE, mywhen, errorMessage);
    }

    /**
     * Allows a field to be an empty date.
     *
     * Empty date values are `null`, `""`, `[]` and arrays where all values are `""`
     * and the `year` key is present.
     */
    auto allowEmptyDate(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen /* = true */ ) { // "create", "update"
        // TODO return _allowEmptyFor(fieldName, EMPTY_STRING | EMPTY_DATE, mywhen, errorMessage);
    }

    // Require a non-empty date value
    auto notEmptyDate(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen /* = false */ ) {
        mywhen = invertWhenClause(mywhen);

        // TODO return _allowEmptyFor(fieldName, EMPTY_STRING | EMPTY_DATE, mywhen, errorMessage);
        return null;
    }

    /**
     * Allows a field to be an empty time.
     *
     * Empty date values are `null`, `""`, `[]` and arrays where all values are `""`
     * and the `hour` key is present.
     *
     * This method is equivalent to calling allowEmptyFor() with EMPTY_STRING +
     * EMPTY_TIME flags.
     */
    auto allowEmptyTime(string fieldName, string errorMessage = null, /*Closure|*/ string mywhenA) {
        // TODO return _allowEmptyFor(fieldName, EMPTY_STRING | EMPTY_TIME, mywhen, errorMessage);
    }

    /**
     * Require a field to be a non-empty time.
     * Opposite to allowEmptyTime()
     */
    void notEmptyTime(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen /* = false */ ) {
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
     * Valid values are true, false, "create", "update". If a Closure is passed then
     * the field will allowed to be empty only when the callback returns false.
     */
    auto allowEmptyDateTime(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen /* = true */ ) {
        // TODO return _allowEmptyFor(fieldName, EMPTY_STRING | EMPTY_DATE | EMPTY_TIME, mywhen, errorMessage);
        return null;

    }

    /**
     * Require a field to be a non empty date/time.
     *
     * Opposite to allowEmptyDateTime
     */
    auto notEmptyDateTime(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen /* = false */ ) {
        // auto mywhen = invertWhenClause(mywhen);
        // TODO return _allowEmptyFor(fieldName, EMPTY_STRING | EMPTY_DATE | EMPTY_TIME, mywhen, errorMessage);
        return this;
    }

    // Converts validator to fieldName: mysettings array
    protected auto _convertValidatorToArray(
        string fieldName,
        Json[string] mydefaults = null,
        Json[string] /* int */ mysettings = null
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
        /*        if (cast(Closure) mywhen) {
            return fn(context) : !mywhen(context);
        } */
        return mywhen;
    }

    // Add a notBlank rule to a field.
    auto notBlank(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        string message;
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "This field cannot be left empty"
                : `__d("uim", "This field cannot be left empty")`;
        }

        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        /* return _add(fieldName, "notBlank", extraData.set(
                "rule", "notBlank",
            ]); */
        return null;

    }

    // Add an alphanumeric rule to a field.
    auto alphaNumeric(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be alphanumeric"
                : `__d("uim", "The provided value must be alphanumeric")`;
        }

        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        /* return _add(fieldName, "alphaNumeric", extraData.set(
                "rule", "alphaNumeric",
            ]); */
        return null;

    }

    // Add a non-alphanumeric rule to a field.
    auto notAlphaNumeric(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must not be alphanumeric"
                : `__d("uim", "The provided value must not be alphanumeric")`;
        }

        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        /* return _add(fieldName, "notAlphaNumeric", extraData.set(
                "rule", "notAlphaNumeric",
            ]); */
        return null;

    }

    // Add an ascii-alphanumeric rule to a field.
    auto asciiAlphaNumeric(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be ASCII-alphanumeric"
                : `__d("uim", "The provided value must be ASCII-alphanumeric")`;
        }

        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        /* return _add(fieldName, "asciiAlphaNumeric", extraData.set(
                "rule", "asciiAlphaNumeric",
            ]); */
        return null;

    }

    // Add a non-ascii alphanumeric rule to a field.
    auto notAsciiAlphaNumeric(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) { // "create" or "update"
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must not be ASCII-alphanumeric"
                : `__d("uim", "The provided value must not be ASCII-alphanumeric")`;
        }

        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        /* return _add(fieldName, "notAsciiAlphaNumeric", extraData.set("rule", "notAsciiAlphaNumeric"));
 */
        return null;
    }

    // Add an rule that ensures a string length is within a range.
    auto lengthBetween(
        string fieldName,
        Json[string] minmaxLengths,
        string errorMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        // if (count(minmaxLengths) != 2) {
        // TODO throw new DInvalidArgumentException("The minmaxLengths argument requires 2 numbers");
        // }

        auto lowerBound = "0"; // minmaxLengths.shift();
        auto upperBound = "1"; // minmaxLengths.shift();
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

        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        /* return _add(fieldName, "lengthBetween", extraData.set(
                "rule": ["lengthBetween", lowerBound, upperBound],
            ]);
 */
        return null;
    }

    // Add a credit card rule to a field.
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
        string errorMessage = null, 
        /*Closure|*/ string mywhen = null
    ) {
        string mytypeEnumeration = allowedTypeOfCards;
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? allowedTypeOfCards == "all"
                    ? "The provided value must be a valid credit card number of any type"
                    : "The provided value must be a valid credit card number of these types: '%s'"
                    .format(mytypeEnumeration)
                : allowedTypeOfCards == "all"
                    ? `__d(
                        "uim",
                        "The provided value must be a valid credit card number of any type"
                    )` : `__d(
                        "uim",
                        "The provided value must be a valid credit card number of these types: '{allowedTypeOfCards}'",
                        allowedTypeOfCards
                    )`;
        }

        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        /* return _add(fieldName, "creditCard", extraData.set(
                "rule": ["creditCard", allowedTypeOfCards, true],
            ]); */
        return null;
    }

    // Add a greater than comparison rule to a field.
    Json[string] greaterThan(
        string fieldName,
        float valueToCompare,
        string errorMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be greater than '%s'".format(
                    valueToCompare)
                : `__d("uim", "The provided value must be greater than '{0}'", valueToCompare)`;
        }

        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        /* return _add(fieldName, "greaterThan", extraData.set("rule": ["comparison", Validation.COMPARE_GREATER, valueToCompare]]); */
        return null;
    }

    // Add a greater than or equal to comparison rule to a field.
    Json[string] greaterThanOrEqual(
        string fieldName,
        float valueToCompare,
        string errorMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be greater than or equal to '%s'".format(valueToCompare)
                : `__d("uim", "The provided value must be greater than or equal to '{0}'", valueToCompare)`;
        }

        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        /*
        return _add(fieldName, "greaterThanOrEqual", extraData.set(
                "rule": [
                    "comparison", Validation.COMPARE_GREATER_OR_EQUAL, valueToCompare
                ],
            ]);
 */
        return null;
    }

    // Add a less than comparison rule to a field.
    auto lessThan(
        string fieldName,
        float valueToCompare,
        string errorMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be less than '%s'".format(
                    valueToCompare)
                : `__d("uim", "The provided value must be less than '{0}'", valueToCompare)`;
        }

        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        /*
        return _add(fieldName, "lessThan", extraData.set(
                "rule": ["comparison", Validation.COMPARE_LESS, valueToCompare],
            ]); */
        return null;
    }

    // Add a less than or equal comparison rule to a field.
    auto lessThanOrEqual(
        string fieldName,
        float valueToCompare,
        string errorMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must be less than or equal to '{0}'", valueToCompare)`
                : "The provided value must be less than or equal to '%s'".format(valueToCompare);
        }

        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        /*       
        return _add(fieldName, "lessThanOrEqual", extraData.set(
                "rule": [
                    "comparison", Validation.COMPARE_LESS_OR_EQUAL, valueToCompare
                ],
            ]);
 */
        return this;
    }

    // Add a equal to comparison rule to a field.
    auto equals(
        string fieldName,
        Json valueToCompare,
        string errorMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be equal to '%s'".format(
                    valueToCompare)
                : `__d("uim", "The provided value must be equal to '{0}'", valueToCompare)`;
        }
        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;

        /* return _add(fieldName, "equals", extraData.set(
                "rule": ["comparison", Validation.COMPARE_EQUAL, value],
            ]); */

        return null;
    }

    // Add a not equal to comparison rule to a field.
    auto notEquals(
        string fieldName,
        Json value,
        string errorMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must not be equal to '%s'".format(
                    value)
                : `__d("uim", "The provided value must not be equal to '{0}'", value)`;
        }

        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        /*        
        return _add(fieldName, "notEquals", extraData.set(
                "rule": ["comparison", Validation.COMPARE_NOT_EQUAL, value],
            ]);
 */
        return null;
    }
    /**
     * Add a rule to compare two fields to each other.
     *
     * If both fields have the exact same value the rule will pass.
     */
    auto sameAs(
        string fieldName,
        string secondField,
        string errorMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be same as '%s'".format(
                    secondField)
                : `__d("uim", "The provided value must be same as '{0}'", secondField)`;
        }

        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        /*       
        return _add(fieldName, "sameAs", extraData.set(
                "rule": [
                    "compareFields", secondField, Validation.COMPARE_SAME
                ],
            ]);
 */
        return null;
    }

    // Add a rule to compare that two fields have different values.
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

        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        /*        
        return _add(fieldName, "notSameAs", extraData.set(
                "rule": [
                    "compareFields", secondField, Validation.COMPARE_NOT_SAME
                ],
            ]);
 */
        return null;
    }

    // Add a rule to compare one field is equal to another.
    auto equalToField(
        string fieldName,
        string secondField,
        string errorMessage = null, /*Closure|*/
        /* Closure */
        string mywhen = null  // "create" , "update"

        

    ) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be equal to the one of field '%s'".format(
                    secondField) : `__d(
                    "uim",
                    "The provided value must be equal to the one of field '{0}'",
                    secondField
                )`;
        }

        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        /* return _add(fieldName, "equalToField", extraData.set(
                "rule": [
                    "compareFields", secondField, Validation.COMPARE_EQUAL
                ],
            ]); */
        return null;
    }

    // Add a rule to compare one field is not equal to another.
    auto notEqualToField(
        string fieldName,
        string secondField,
        string errorMessage = null, /*Closure|*/
        /* Closure */
        string mywhen = null  // "create", "update"

        

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

        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        /*        
        return _add(fieldName, "notEqualToField", extraData.set(
                "rule": [
                    "compareFields", secondField, Validation.COMPARE_NOT_EQUAL
                ],
            ]);
 */
        return null;
    }

    // Add a rule to compare one field is greater than another.
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

        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        /*        
        return _add(fieldName, "greaterThanField", extraData.set(
                "rule": [
                    "compareFields", secondField, Validation.COMPARE_GREATER
                ],
            ]);
 */
        return null;
    }

    // Add a rule to compare one field is greater than or equal to another.
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

        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        /*        
        return _add(fieldName, "greaterThanOrEqualToField", extraData.set(
                "rule": [
                    "compareFields", secondField,
                    Validation.COMPARE_GREATER_OR_EQUAL
                ],
            ]); */
        return null;
    }

    // Add a rule to compare one field is less than another.
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

        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        /*        
        return _add(fieldName, "lessThanField", extraData.set(
                "rule": [
                    "compareFields", secondField, Validation.COMPARE_LESS
                ],
            ]);

 */
        return null;
    }

    // Add a rule to compare one field is less than or equal to another.
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

        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        /*        
        return _add(fieldName, "lessThanOrEqualToField", extraData.set(
                "rule": [
                    "compareFields", secondField,
                    Validation.COMPARE_LESS_OR_EQUAL
                ],
            ]); */
        return null;
    }

    // Add a date format validation rule to a field.
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
                .format(myformatEnumeration) : `__d(
                    "uim",
                    "The provided value must be a date of one of these formats: '{0}'",
                    myformatEnumeration
                )`;
        }

        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        /*        
        return _add(fieldName, "date", extraData.set(
                "rule": ["date", dateFormats],
            ]); */
        return null;
    }

    // Add a date time format validation rule to a field.
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

        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        /* 
        return _add(fieldName, "dateTime", extraData.set(
                "rule": ["datetime", dateFormats],
            ]); */
        return null;
    }

    // Add a time format validation rule to a field.
    auto time(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be a time"
                : `__d("uim", "The provided value must be a time")`;
        }

        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        /*        
        return _add(fieldName, "time", extraData.set(
                "rule", "time",
            ]); */
        return null;
    }

    /**
     * Add a localized time, date or datetime format validation rule to a field.
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

        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        /*        
        return _add(fieldName, "localizedTime", extraData.set(
                "rule": ["localizedTime", parserType],
            ]); */
        return null;
    }

    // Add a boolean validation rule to a field.
    auto isBoolean(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be a boolean"
                : `__d("uim", "The provided value must be a boolean")`;
        }

        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        /* 
        return _add(fieldName, "boolean", extraData.set("rule", "boolean")); */
        return null;
    }

    // Add a decimal validation rule to a field.
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
                    : "The provided value must be decimal with '%s' decimal places".format(
                        numberOfPlaces);

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

        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        /* 
        return _add(fieldName, "decimal", extraData.set(
                "rule": ["decimal", numberOfPlaces],
            ]); */
        return null;
    }

    // Add an email validation rule to a field.
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
        /* Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;

        return _add(fieldName, "email", extraData.set(
                "rule": ["email", shouldCheckMX],
            ]); */
        return null;
    }

    // Add a backed enum validation rule to a field.
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
        
        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        /* 
        return _add(fieldName, "enum", extraData.set(
                "rule": ["enum", myenumclassname],
            ]); */
        return null;
    }

    /**
     * Add an IP validation rule to a field.
     *
     * This rule will accept both IPv4 and IPv6 addresses.
     * Params:
     */
    auto ip(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be an IP address"
                : `__d("uim", "The provided value must be an IP address")`;

        }

        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        /* 
        return _add(fieldName, "ip", extraData.set(
                "rule", "ip",
            ]); */
        return null;
    }

    // Add an IPv4 validation rule to a field.
    auto ipv4(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must be an IPv4 address")`
                : "The provided value must be an IPv4 address";

        }
        /* Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;

        return _add(fieldName, "ipv4", extraData.set(
                "rule": ["ip", "ipv4"],
            ]); */
        return null;
    }

    // Add an IPv6 validation rule to a field.
    auto ipv6(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must be an IPv6 address")`
                : "The provided value must be an IPv6 address";
        }
        /*        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;

        return _add(fieldName, "ipv6", extraData.set(
                "rule": ["ip", "ipv6"],
            ]); */
        return null;
    }

    // Add a string length validation rule to a field.
    auto hasMinLength(string fieldName, int requiredMinLength, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must be at least '{0}' characters long", mymin)`
                : "The provided value must be at least '%s' characters long".format(
                    requiredMinLength);
        }
        /*        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;

        return _add(fieldName, "minLength", extraData.set("rule": ["minLength", requiredMinLength],
            ]); */
        return null;
    }

    // Add a string length validation rule to a field.
    auto minLengthBytes(string fieldName, int requiredMinLength, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must be at least '{0}' bytes long", mymin)`
                : "The provided value must be at least '%s' bytes long".format(requiredMinLength);
        }

        Json[string] myextra;
        myextra
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        /* return _add(fieldName, "minLengthBytes", extraData.set(
                "rule": ["minLengthBytes", requiredMinLength],
            ]); */
        return null;
    }

    // Add a string length validation rule to a field.
    auto maxLength(string fieldName, int allowedMaxlength, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must be at most '{0}' characters long", mymax)`
                : "The provided value must be at most '%s' characters long".format(allowedMaxlength);
        }

        /* Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        return _add(fieldName, "maxLength", extraData.set(
                "rule": ["maxLength", allowedMaxlength],
            ]);*/
        return null;
    }

    // Add a string length validation rule to a field.
    auto maxLengthBytes(string fieldName, int allowedMaxlength, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must be at most '{0}' bytes long", mymax)`
                : "The provided value must be at most '%s' bytes long".format(allowedMaxlength);
        }

        /* Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        return _add(fieldName, "maxLengthBytes", extraData.set(
                "rule": ["maxLengthBytes", allowedMaxlength],
            ]); */
        return null;
    }

    // Add a numeric value validation rule to a field.
    auto numeric(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must be numeric")`
                : "The provided value must be numeric";

        }
        /* Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;

        return _add(fieldName, "numeric", extraData.set(
                "rule", "numeric",
            ]); */
        return null;
    }

    // Add a natural number validation rule to a field.
    auto naturalNumber(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must be a natural number")`
                : "The provided value must be a natural number";
        }
        /*        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;

        return _add(fieldName, "naturalNumber", extraData.set(
                "rule": ["naturalNumber", false],
            ]); */
        return null;
    }

    // Add a validation rule to ensure a field is a non negative integer.
    auto nonNegativeInteger(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null  /* "create" or "update" */ ) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must be a non-negative integer")`
                : "The provided value must be a non-negative integer";
        }
        /*        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;

        return _add(fieldName, "nonNegativeInteger", extraData.set(
                "rule": ["naturalNumber", true],
            ]); */
        return null;
    }

    // Add a validation rule to ensure a field is within a numeric range
    auto range(string fieldName, Json[string] bounds, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        // if (count(bounds) != 2) {
        // TODO throw new DInvalidArgumentException("The minmaxLength argument requires 2 numbers");
        // }
        auto lowerBound = "0"; // minmaxLength.shift();
        auto upperBound = "1"; // minmaxLength.shift();

        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d(
                    "uim",
                    "The provided value must be between '{0}' and '{1}', inclusively",
                    lowerBound, upperBound
                )` : "The provided value must be between '%s' and '%s', inclusively".format(lowerBound, upperBound);
        }
        /*        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;

        return _add(fieldName, "range", extraData.set(
                "rule": ["range", lowerBound, upperBound],
            ]); */
        return null;
    }

    /**
     * Add a validation rule to ensure a field is a URL.
     * This validator does not require a protocol.
     */
    auto url(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must be a URL")`
                : "The provided value must be a URL";
        }

        /* Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        return _add(fieldName, "url", extraData.set("rule": ["url", false],]); */
        return null;

    }

    /**
     * Add a validation rule to ensure a field is a URL.
     *
     * This validator requires the URL to have a protocol.
     */
    auto urlWithProtocol(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must be a URL with protocol")`
                : "The provided value must be a URL with protocol";
        }

        /* Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        return _add(fieldName, "urlWithProtocol", extraData.set(
                "rule": ["url", true],
            ]); */
        return null;
    }

    // Add a validation rule to ensure the field value is within an allowed list.
    auto inList(string fieldName, Json[string] validOptions, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        // auto listEnumeration = mylist.join(", ");
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be one of: '%s'".format("listEnumeration") : `__d(
                    "uim",
                    "The provided value must be one of: '{0}'",
                    listEnumeration
                )`;
        }

        /*        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        return _add(fieldName, "inList", extraData.set(
                "rule": ["inList", validOptions],
            ]); */
        return null;
    }

    // Add a validation rule to ensure the field is a UUID
    auto uuid(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be a UUID"
                : `__d("uim", "The provided value must be a UUID")`;
        }

        /*        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        return _add(fieldName, "uuid", extraData.set(
                "rule", "uuid",
            ]); */
        return null;
    }

    // Add a validation rule to ensure the field is an uploaded file
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
        /* Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;

        return _add(fieldName, "uploadedFile", extraData.set(
                "rule": ["uploadedFile", options],
            ]); */
        return null;
    }

    /**
     * Add a validation rule to ensure the field is a lat/long tuple.
     *
     * e.g. `<lat>, <lng>`
     */
    auto latLong(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must be a latitude/longitude coordinate")`
                : "The provided value must be a latitude/longitude coordinate";
        }
        /* Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        return _add(fieldName, "latLong", extraData.set(
            "rule", "geoCoordinate",
        ]); */
        return null;
    }

    // Add a validation rule to ensure the field is a latitude.
    auto latitude(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must be a latitude")`
                : "The provided value must be a latitude";
        }
        /* Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;

        return _add(fieldName, "latitude", extraData.set(
                "rule", "latitude",
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

        /*        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        return _add(fieldName, "longitude", extraData.set(
                "rule", "longitude",
            ]); */
        return null;
    }

    // Add a validation rule to ensure a field contains only ascii bytes
    auto ascii(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must be ASCII bytes only")`
                : "The provided value must be ASCII bytes only";
        }

        /*        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        return _add(fieldName, "ascii", extraData.set(
                "rule", "ascii",
            ]); */
        return null;
    }

    // Add a validation rule to ensure a field contains only BMP utf8 bytes
    auto utf8(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must be UTF-8 bytes only")`
                : "The provided value must be UTF-8 bytes only";
        }

        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        /*    
        return _add(fieldName, "utf8", extraData.set(
                "rule": ["utf8", ["extended": false.toJson]],
            ]); */
        return null;
    }

    /**
     * Add a validation rule to ensure a field contains only utf8 bytes.
     *
     * This rule will accept 3 and 4 byte UTF8 sequences, which are necessary for emoji.
     */
    auto utf8Extended(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be 3 and 4 byte UTF-8 sequences only"
                : `__d("uim", "The provided value must be 3 and 4 byte UTF-8 sequences only")`;
        }

        /* Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        return _add(fieldName, "utf8Extended", extraData.set(
                "rule": ["utf8", ["extended": true.toJson]],
            ]); */
        return null;
    }

    // Add a validation rule to ensure a field is an integer value.
    auto integer(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must be an integer")`
                : "The provided value must be an integer";
        }

        /* Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        return _add(fieldName, "integer", extraData.set(
                "rule", "isInteger",
            ]); */
        return null;
    }

    // Add a validation rule to ensure that a field contains an array.
    auto array(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must be an array"
                : `__d("uim", "The provided value must be an array")`;
        }

        /* Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        return _add(fieldName, "array", extraData.set(
                "rule", "isArray",
            ]); */
        return null;
    }

    // Add a validation rule to ensure that a field contains a scalar.
    auto scalar(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must be scalar")`
                : "The provided value must be scalar";
        }

        /* Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        return _add(fieldName, "scalar", extraData.set(
                "rule", "isScalar",
            ]); */
        return null;
    }

    // Add a validation rule to ensure a field is a 6 digits hex color value.
    auto hexColor(string fieldName, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must be a hex color")`
                : "The provided value must be a hex color";
        }

        /*        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        return _add(fieldName, "hexColor", extraData.set(
                "rule", "hexColor",
            ]); */

        return null;
    }

    // Add a validation rule for a multiple select. Comparison is case sensitive by default.
    auto multipleOptions(
        string fieldName,
        Json[string] options = null,
        string errorMessage = null, /*Closure|*/
        string mywhen = null
    ) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must be a set of multiple options")`
                : "The provided value must be a set of multiple options";
        }

        /*        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;
        auto mycaseInsensitive = options.getBoolean("caseInsensitive", false);
        options.removeKey("caseInsensitive");

        return _add(fieldName, "multipleOptions", extraData.set(
                "rule": ["multiple", options, mycaseInsensitive],
            ]); */
        return null;
    }

    /**
     * Add a validation rule to ensure that a field is an array containing at least
     * the specified amount of elements
     */
    Json[string] hasAtLeast(string fieldName, int numberOfElements, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must have at least '{0}' elements", mycount)`
                : "The provided value must have at least '%s' elements".format(numberOfElements);

        }
        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;

        /* return _add(fieldName, "hasAtLeast", extraData.set(
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
     */
    Json[string] hasAtMost(string fieldName, int countElements, string errorMessage = null, /*Closure|*/ string mywhen = null) {
        if (errorMessage.isNull) {
            errorMessage = _useI18n
                ? `__d("uim", "The provided value must have at most '{0}' elements", mycount)`
                : "The provided value must have at most '%s' elements".format(countElements);
        }
        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;

        /* return _add(fieldName, "hasAtMost", extraData.set(
            "rule": auto (myvalue) use (countElements) {
                if (isArray(myvalue) && myvalue.hasKey("_ids")) {
                    myvalue = myvalue["_ids"];
                }
                return Validation.numElements(myvalue, Validation.COMPARE_LESS_OR_EQUAL, countElements);
            },
        ]); */
        return null;
    }

    // Returns whether a field can be left empty for a new or already existing record.
    bool isEmptyAllowed(string fieldName, bool isNewRecord) {
        auto myproviders = _providers;
        // auto data = null;
        // auto context = compact("data", "newRecord", "field", "providers");

        // return _canBeEmpty(field(fieldName), context);
        return false;
    }

    // Returns whether a field can be left out for a new or already existing record.
    bool isPresenceRequired(string fieldName, bool isNewRecord) {
        /* myproviders = _providers;
        data = null;
        context = compact("data", "newRecord", "field", "providers");

        return !_checkPresence(field(fieldName), context); */
        return false;
    }

    // Returns whether a field matches against a regular expression.
    auto regex(string fieldName, string regex, string errorMessage = null, /*Closure|*/ string mywhen = null) { // "create" or "update"
        /* if (errorMessage.isNull) {
            errorMessage = !_useI18n
                ? "The provided value must match against the pattern '%s'".format(regex)
                : __d("uim", "The provided value must match against the pattern '{0}'", regex);
        }
        Json[string] extraData = createMap!(string, Json)
            .set("on", mywhen)
            .set("message", errorMessage)
            .filterValues;

        return _add(fieldName, "regex", extraData.set(
            "rule": ["custom", regex],
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
            ? `__d("uim", "This field is required")` : "This field is required";
    }

    // Gets the notEmpty message for a field
    string getNotEmptyMessage(string fieldName) {
        /* if (!_fields.hasKey(fieldName)) {
            return null;
        } */
        /* foreach (ruleName; _fields[fieldName]) {
            if (ruleName.get("rule") == "notBlank" && ruleName.get("message")) {
                return ruleName.get("message");
            }
        }
        if (_allowEmptyMessages.hasKey(fieldName)) {
            return _allowEmptyMessages[fieldName];
        } */

        return _useI18n
            ? `__d("uim", "This field cannot be left empty")` : "This field cannot be left empty";
    }

    /**
     * Returns false if any validation for the passed rule set should be stopped
     * due to the field missing in the data array
     */
    protected bool _checkPresence(DValidationSet fieldName, Json[string] context) {
        auto myrequired = fieldName.isPresenceRequired();
        /* if (cast(Closure) myrequired) {
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

    // Returns true if the field is empty in the passed data array
    protected bool isEmpty(Json data, int myflags) {
        /* if (data.isNull) {
            return true;
        }
        if (data is null && (myflags & EMPTY_STRING)) {
            return true;
        }
        auto myarrayTypes = EMPTY_ARRAY | EMPTY_DATE | EMPTY_TIME;
        if (data is null && (myflags & myarrayTypes)) {
            return true;
        }
        if (data.isArray) {
            auto myallFieldsAreEmpty = true;
            foreach (fieldName; data) {
                if (fieldName !is null && fieldName != "") {
                    myallFieldsAreEmpty = false;
                    break;
                }
            }
            if (myallFieldsAreEmpty) {
                if ((myflags & EMPTY_DATE) && data.hasKey("year")) {
                    return true;
                }
                if ((myflags & EMPTY_TIME) && data.hasKey("hour")) {
                    return true;
                }
            }
        }

        return (myflags & EMPTY_FILE) && cast(IUploadedFile) data && data.getError() == UPLOAD_ERR_NO_FILE; */
        return false;
    }

    /**
     * Iterates over each rule in the validation set and collects the errors resulting
     * from executing them
     */
    protected Json[string] _processRules(string fieldName, DValidationSet validationRules, Json[string] dataToValidator, bool isNewRecord) {
        Json[string] myerrors = null;
        // Loading default provider in case there is none
        getProvider("default");

        auto message = _useI18n
            ? `__d("uim", "The provided value is invalid")` : "The provided value is invalid";

        /* foreach (ruleNames, ruleName; validationRules) {
            auto result = ruleName.process(dataToValidator[fieldName], _providers, compact("newRecord", "data", "field"));
            if (result == true) {
                continue;
            }

            myerrors[ruleNames] = message;
            if (isArray(result) && ruleNames == NESTED) {
                myerrors = result;
            }
            if (isString(result)) {
                myerrors[ruleNames] = result;
            }
            if (ruleName.isLast()) {
                break;
            }
        }
        return myerrors; */
        return null;
    }

    // Get the printable version of this object.
    Json[string] debugInfo() {
        Json[string] info;
        // _fields.byKeyValue.each!(
        /* nameSet => info[nameSet.key] = [
                "isPresenceRequired": nameSet.value.isPresenceRequired(),
                "isEmptyAllowed": nameSet.value.isEmptyAllowed(),
                "rules": nameSet.value.rules().keys(),
            ]); */

        return info
            // TODO .set("_presenceMessages", _presenceMessages)
            // .set("_allowEmptyMessages", _allowEmptyMessages.toJson)
            // .set("_allowEmptyFlags", _allowEmptyFlags.toJson)
            .set("_useI18n", _useI18n)
            /* .set("_stopOnFailure", _stopOnFailure)
            .set("_providers", _providers.keys) *//* 
            .set("_fields", fieldNames) */;
    }
}
