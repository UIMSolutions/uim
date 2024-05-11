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
     * @var array<string, object|string>
     * @psalm-var array<string, object|class-string>
     */
    // TODO protected Json[string] _providers = null;

    /**
     * An associative array of objects or classes used as a default provider list
     *
     * @var array<string, object|string>
     * @psalm-var array<string, object|class-string>
     */
    protected static Json[string] _defaultProviders = null;


    /**
     * Whether to apply last flag to generated rule(s).
     */
    protected bool _stopOnFailure = false;

    this() {
       _useI18n = function_exists("\UIM\I18n\__d");
       _providers = self._defaultProviders;
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
     */
    array<array> validate(Json[string] data, bool mynewRecord = true) {
        myerrors = null;

        foreach (_fields as myname: myfield) {
            myname = to!string(myname);
            mykeyPresent = array_key_exists(myname, mydata);

            myproviders = _providers;
            mycontext = compact("data", "newRecord", "field", "providers");

            if (!mykeyPresent && !_checkPresence(myfield, mycontext)) {
                myerrors[myname]["_required"] = getRequiredMessage(myname);
                continue;
            }
            if (!mykeyPresent) {
                continue;
            }
            mycanBeEmpty = _canBeEmpty(myfield, mycontext);

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
            result = _processRules(myname, myfield, mydata, mynewRecord);
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
     * string myname [optional] The fieldname to fetch.
     * @param \UIM\Validation\ValidationSet|null myset The set of rules for field
     */
    ValidationSet field(string myname, ?ValidationSet myset = null) {
        if (isEmpty(_fields[myname])) {
            myset = myset ?: new DValidationSet();
           _fields[myname] = myset;
        }
        return _fields[myname];
    }
    
    /**
     * Check whether a validator contains any rules for the given field.
     * Params:
     * string myname The field name to check.
     */
   bool hasField(string myname) {
        return isSet(_fields[myname]);
    }
    
    /**
     * Associates an object to a name so it can be used as a provider. Providers are
     * objects or class names that can contain methods used during validation of for
     * deciding whether a validation rule can be applied. All validation methods,
     * when called will receive the full list of providers stored in this validator.
     * Params:
     * string myname The name under which the provider should be set.
     * @param object|string myobject Provider object or class name.
     * @psalm-param object|class-string myobject
     */
    auto setProvider(string myname, object|string myobject) {
       _providers[myname] = myobject;

        return this;
    }
    
    /**
     * Returns the provider stored under that name if it exists.
     * Params:
     * string myname The name under which the provider should be set.
     */
    object|string|null getProvider(string myname) {
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
    static object|string|null getDefaultProvider(string myname) {
        return self._defaultProviders[myname] ?? null;
    }
    
    /**
     * Associates an object to a name so it can be used as a default provider.
     * Params:
     * string myname The name under which the provider should be set.
     * @param object|string myobject Provider object or class name.
     * @psalm-param object|class-string myobject
     */
    static void addDefaultProvider(string myname, object|string myobject) {
        self._defaultProviders[myname] = myobject;
    }
    
    // Get the list of default providers.
    static string[] getDefaultProviders() {
        return self._defaultProviders.keys;
    }
    
    // Get the list of providers in this validator.
    string[] providers() {
        return _providers.keys;
    }
    
    /**
     * Returns whether a rule set is defined for a field or not
     * Params:
     * string myfield name of the field to check
     */
    bool offsetExists(Json myfield) {
        return isSet(_fields[myfield]);
    }
    
    /**
     * Returns the rule set for a field
     * Params:
     * string|int myfield name of the field to check
     */
    ValidationSet offsetGet(Json myfield) {
        return _field((string)myfield);
    }
    
    /**
     * Sets the rule set for a field
     * Params:
     * string fieldName name of the field to set
     * @param \UIM\Validation\ValidationSet|array myrules set of rules to apply to field
     */
    void offsetSet(string fieldName, Json myrules) {
        if (!cast(ValidationSet)myrules) {
            myset = new DValidationSet();
            foreach (myrules as myname: myrule) {
                myset.add(myname, myrule);
            }
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
        unset(_fields[fieldName]);
    }
    
    /**
     * Returns an iterator for each of the fields to be validated
     */
    Traversable<string, \UIM\Validation\ValidationSet> getIterator() {
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
     *     myvalidator
     *         .add("title", "required", ["rule": "notBlank"])
     *         .add("user_id", "valid", ["rule": "numeric", "message": "Invalid User"])
     *
     *     myvalidator.add("password", [
     *         "size": ["rule": ["lengthBetween", 8, 20]],
     *         "hasSpecialCharacter": ["rule": "validateSpecialchar", "message": "not valid"]
     *     ]);
     * ```
     * Params:
     * string fieldName The name of the field from which the rule will be added
     * @param string[] myname The alias for a single rule or multiple rules array
     * @param \UIM\Validation\ValidationRule|array myrule the rule to add
     * @throws \InvalidArgumentException If numeric index cannot be resolved to a string one
     */
    auto add(string fieldName, string[] myname, ValidationRule|array myrule = []) {
        myvalidationSet = this.field(fieldName);

        if (!isArray(myname)) {
            myrules = [myname: myrule];
        } else {
            myrules = myname;
        }
        myrules.byKeyValue
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
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     */
    auto addNested(
        string rootfieldName,
        Validator myvalidator,
        string myMessage = null,
        Closure|string|null mywhen = null
    ) {
        myextra = array_filter(["message": myMessage, "on": mywhen]);

        myvalidationSet = this.field(rootfieldName);
        myvalidationSet.add(NESTED, myextra ~ ["rule": auto (myvalue, mycontext) use (myvalidator, myMessage) {
            if (!isArray(myvalue)) {
                return false;
            }
            this.providers().each!(name => myvalidator.setProvider(name, getProvider(name)));
            myerrors = myvalidator.validate(myvalue, mycontext["newRecord"]);

            myMessage = myMessage ? [NESTED: myMessage] : [];

            return myerrors.isEmpty ? true : myerrors + myMessage;
        }]);

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
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     */
    auto addNestedMany(
        string rootfieldName,
        Validator myvalidator,
        string myMessage = null,
        Closure|string|null mywhen = null
    ) {
        auto myextra = array_filter(["message": myMessage, "on": mywhen]);

        auto myvalidationSet = this.field(rootfieldName);
        myvalidationSet.add(NESTED, myextra ~ ["rule": auto (myvalue, mycontext) use (myvalidator, myMessage) {
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

        return this;
    }
    
    /**
     * Removes a rule from the set by its name
     *
     * ### Example:
     *
     * ```
     *     myvalidator
     *         .remove("title", "required")
     *         .remove("user_id")
     * ```
     * Params:
     * string fieldName The name of the field from which the rule will be removed
     * @param string|null myrule the name of the rule to be removed
     */
    auto remove(string fieldName, string myrule = null) {
        if (myrule.isNull) {
            unset(_fields[fieldName]);
        } else {
            this.field(fieldName).remove(myrule);
        }
        return this;
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
     * @param \Closure|string mymode Valid values are true, false, "create", "update".
     *  If a Closure is passed then the field will be required only when the callback
     *  returns true.
     * @param string|null myMessage The message to show if the field presence validation fails.
     */
    void requirePresence(string[] fieldName, IClosure|string mymode = true, string myMessage = null) {
        mydefaults = [
            "mode": mymode,
            "message": myMessage,
        ];

        if (!isArray(fieldName)) {
            fieldName = _convertValidatorToArray((string)fieldName, mydefaults);
        }
        foreach (fieldName as myfieldName: mysetting) {
            mysettings = _convertValidatorToArray((string)myfieldName, mydefaults, mysetting);
            string myfieldName = current(mysettings.keys);

            this.field((string)myfieldName).requirePresence(mysettings[myfieldName]["mode"]);
            if (mysettings[myfieldName]["message"]) {
               _presenceMessages[myfieldName] = mysettings[myfieldName]["message"];
            }
        }
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
     * ```
     *// Email can be empty
     * myvalidator.allowEmptyFor("email", Validator.EMPTY_STRING);
     *
     *// Email can be empty on create
     * myvalidator.allowEmptyFor("email", Validator.EMPTY_STRING, Validator.WHEN_CREATE);
     *
     *// Email can be empty on update
     * myvalidator.allowEmptyFor("email", Validator.EMPTY_STRING, Validator.WHEN_UPDATE);
     * ```
     *
     * It is possible to conditionally allow emptiness on a field by passing a callback
     * as a second argument. The callback will receive the validation context array as
     * argument:
     *
     * ```
     * myvalidator.allowEmpty("email", Validator.EMPTY_STRING, auto (mycontext) {
     *  return !mycontext["newRecord"] || mycontext["data"]["role"] == "admin";
     * });
     * ```
     *
     * If you want to allow other kind of empty data on a field, you need to pass other
     * flags:
     *
     * ```
     * myvalidator.allowEmptyFor("photo", Validator.EMPTY_FILE);
     * myvalidator.allowEmptyFor("published", Validator.EMPTY_STRING | Validator.EMPTY_DATE | Validator.EMPTY_TIME);
     * myvalidator.allowEmptyFor("items", Validator.EMPTY_STRING | Validator.EMPTY_ARRAY);
     * ```
     *
     * You can also use convenience wrappers of this method. The following calls are the
     * same as above:
     *
     * ```
     * myvalidator.allowEmptyFile("photo");
     * myvalidator.allowEmptyDateTime("published");
     * myvalidator.allowEmptyArray("items");
     * ```
     * Params:
     * string fieldName The name of the field.
     * @param int myflags A bitmask of EMPTY_* flags which specify what is empty.
     *  If no flags/bitmask is provided only `null` will be allowed as empty value.
     * @param \Closure|string mywhen Indicates when the field is allowed to be empty
     * Valid values are true, false, "create", "update". If a Closure is passed then
     * the field will allowed to be empty only when the callback returns true.
     * @param string|null myMessage The message to show if the field is not
    
     */
    void allowEmptyFor(
        string fieldName,
        int myflags = null,
        Closure|string mywhen = true,
        string myMessage = null
    ) {
        this.field(fieldName).allowEmpty(mywhen);
        if (myMessage) {
           _allowEmptyMessages[fieldName] = myMessage;
        }
        if (myflags !isNull) {
           _allowEmptyFlags[fieldName] = myflags;
        }
    }
    
    /**
     * Allows a field to be an empty string.
     *
     * This method is equivalent to calling allowEmptyFor() with EMPTY_STRING flag.
     * Params:
     * string fieldName The name of the field.
     * @param string|null myMessage The message to show if the field is not
     * @param \Closure|string mywhen Indicates when the field is allowed to be empty
     * Valid values are true, false, "create", "update". If a Closure is passed then
     * the field will allowed to be empty only when the callback returns true.
     * @return this
     */
    auto allowEmptyString(string fieldName, string myMessage = null, IClosure|string mywhen = true) {
        return _allowEmptyFor(fieldName, self.EMPTY_STRING, mywhen, myMessage);
    }
    
    /**
     * Requires a field to not be an empty string.
     *
     * Opposite to allowEmptyString()
     * Params:
     * string fieldName The name of the field.
     * @param string|null myMessage The message to show if the field is empty.
     * @param \Closure|string mywhen Indicates when the field is not allowed
     *  to be empty. Valid values are false (never), "create", "update". If a
     *  Closure is passed then the field will be required to be not empty when
     *  the callback returns true.
     * @return this
     */
    auto notEmptyString(string fieldName, string myMessage = null, IClosure|string mywhen = false) {
        mywhen = this.invertWhenClause(mywhen);

        return _allowEmptyFor(fieldName, self.EMPTY_STRING, mywhen, myMessage);
    }
    
    /**
     * Allows a field to be an empty array.
     *
     * This method is equivalent to calling allowEmptyFor() with EMPTY_STRING +
     * EMPTY_ARRAY flags.
     * Params:
     * string fieldName The name of the field.
     * @param string|null myMessage The message to show if the field is not
     * @param \Closure|string mywhen Indicates when the field is allowed to be empty
     * Valid values are true, false, "create", "update". If a Closure is passed then
     * the field will allowed to be empty only when the callback returns true.
     * @return this
     */
    auto allowEmptyArray(string fieldName, string myMessage = null, IClosure|string mywhen = true) {
        return _allowEmptyFor(fieldName, self.EMPTY_STRING | self.EMPTY_ARRAY, mywhen, myMessage);
    }
    
    /**
     * Require a field to be a non-empty array
     *
     * Opposite to allowEmptyArray()
     * Params:
     * string fieldName The name of the field.
     * @param string|null myMessage The message to show if the field is empty.
     * @param \Closure|string mywhen Indicates when the field is not allowed
     *  to be empty. Valid values are false (never), "create", "update". If a
     *  Closure is passed then the field will be required to be not empty when
     *  the callback returns true.
     * @return this
     */
    auto notEmptyArray(string fieldName, string myMessage = null, IClosure|string mywhen = false) {
        mywhen = this.invertWhenClause(mywhen);

        return _allowEmptyFor(fieldName, self.EMPTY_STRING | self.EMPTY_ARRAY, mywhen, myMessage);
    }
    
    /**
     * Allows a field to be an empty file.
     *
     * This method is equivalent to calling allowEmptyFor() with EMPTY_FILE flag.
     * File fields will not accept `""`, or `[]` as empty values. Only `null` and a file
     * upload with `error` equal to `UPLOAD_ERR_NO_FILE` will be treated as empty.
     * Params:
     * string fieldName The name of the field.
     * @param string|null myMessage The message to show if the field is not
     * @param \Closure|string mywhen Indicates when the field is allowed to be empty
     *  Valid values are true, "create", "update". If a Closure is passed then
     *  the field will allowed to be empty only when the callback returns true.
     * @return this
     */
    auto allowEmptyFile(string fieldName, string myMessage = null, IClosure|string mywhen = true) {
        return _allowEmptyFor(fieldName, self.EMPTY_FILE, mywhen, myMessage);
    }
    
    /**
     * Require a field to be a not-empty file.
     *
     * Opposite to allowEmptyFile()
     * Params:
     * string fieldName The name of the field.
     * @param string|null myMessage The message to show if the field is empty.
     * @param \Closure|string mywhen Indicates when the field is not allowed
     *  to be empty. Valid values are false (never), "create", "update". If a
     *  Closure is passed then the field will be required to be not empty when
     *  the callback returns true.
     * @return this
     */
    auto notEmptyFile(string fieldName, string myMessage = null, IClosure|string mywhen = false) {
        mywhen = this.invertWhenClause(mywhen);

        return _allowEmptyFor(fieldName, self.EMPTY_FILE, mywhen, myMessage);
    }
    
    /**
     * Allows a field to be an empty date.
     *
     * Empty date values are `null`, `""`, `[]` and arrays where all values are `""`
     * and the `year` key is present.
     * Params:
     * string fieldName The name of the field.
     * @param string|null myMessage The message to show if the field is not
     * @param \Closure|string mywhen Indicates when the field is allowed to be empty
     * Valid values are true, false, "create", "update". If a Closure is passed then
     * the field will allowed to be empty only when the callback returns true.
     * @return this
     */
    auto allowEmptyDate(string fieldName, string myMessage = null, IClosure|string mywhen = true) {
        return _allowEmptyFor(fieldName, self.EMPTY_STRING | self.EMPTY_DATE, mywhen, myMessage);
    }
    
    /**
     * Require a non-empty date value
     * Params:
     * string fieldName The name of the field.
     * @param string|null myMessage The message to show if the field is empty.
     * @param \Closure|string mywhen Indicates when the field is not allowed
     *  to be empty. Valid values are false (never), "create", "update". If a
     *  Closure is passed then the field will be required to be not empty when
     *  the callback returns true.
     * @return this
     */
    auto notEmptyDate(string fieldName, string myMessage = null, IClosure|string mywhen = false) {
        mywhen = this.invertWhenClause(mywhen);

        return _allowEmptyFor(fieldName, self.EMPTY_STRING | self.EMPTY_DATE, mywhen, myMessage);
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
     * @param string|null myMessage The message to show if the field is not
     * @param \Closure|string mywhen Indicates when the field is allowed to be empty
     * Valid values are true, false, "create", "update". If a Closure is passed then
     * the field will allowed to be empty only when the callback returns true.
     * @return this
    
     * @see \UIM\Validation\Validator.allowEmptyFor() for examples.
     */
    auto allowEmptyTime(string fieldName, string myMessage = null, IClosure|string mywhen = true) {
        return _allowEmptyFor(fieldName, self.EMPTY_STRING | self.EMPTY_TIME, mywhen, myMessage);
    }
    
    /**
     * Require a field to be a non-empty time.
     *
     * Opposite to allowEmptyTime()
     * Params:
     * string fieldName The name of the field.
     * @param string|null myMessage The message to show if the field is empty.
     * @param \Closure|string mywhen Indicates when the field is not allowed
     *  to be empty. Valid values are false (never), "create", "update". If a
     *  Closure is passed then the field will be required to be not empty when
     *  the callback returns true.
     * @return this
     * @since 3.8.0
     * @see \UIM\Validation\Validator.allowEmptyTime()
     */
    auto notEmptyTime(string fieldName, string myMessage = null, IClosure|string mywhen = false) {
        mywhen = this.invertWhenClause(mywhen);

        return _allowEmptyFor(fieldName, self.EMPTY_STRING | self.EMPTY_TIME, mywhen, myMessage);
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
     * string myfield The name of the field.
     * @param string|null myMessage The message to show if the field is not
     * @param \Closure|string mywhen Indicates when the field is allowed to be empty
     *  Valid values are true, false, "create", "update". If a Closure is passed then
     *  the field will allowed to be empty only when the callback returns false.
     * @return this
    
     * @see \UIM\Validation\Validator.allowEmptyFor() for examples.
     */
    auto allowEmptyDateTime(string myfield, string myMessage = null, IClosure|string mywhen = true) {
        return _allowEmptyFor(myfield, self.EMPTY_STRING | self.EMPTY_DATE | self.EMPTY_TIME, mywhen, myMessage);
    }
    
    /**
     * Require a field to be a non empty date/time.
     *
     * Opposite to allowEmptyDateTime
     * Params:
     * string myfield The name of the field.
     * @param string|null myMessage The message to show if the field is empty.
     * @param \Closure|string mywhen Indicates when the field is not allowed
     *  to be empty. Valid values are false (never), "create", "update". If a
     *  Closure is passed then the field will be required to be not empty when
     *  the callback returns true.
     * @return this
     * @since 3.8.0
     * @see \UIM\Validation\Validator.allowEmptyDateTime()
     */
    auto notEmptyDateTime(string myfield, string myMessage = null, IClosure|string mywhen = false) {
        mywhen = this.invertWhenClause(mywhen);

        return _allowEmptyFor(myfield, self.EMPTY_STRING | self.EMPTY_DATE | self.EMPTY_TIME, mywhen, myMessage);
    }
    
    /**
     * Converts validator to fieldName: mysettings array
     * Params:
     * string fieldNameName name of field
     * @param Json[string] mydefaults default settings
     * @param array<string|int, mixed>|string|int mysettings settings from data
     */
    // TODO protected array<string, array<string|int, mixed>> _convertValidatorToArray(
        string fieldNameName,
        array mydefaults = [],
        string[]|int mysettings = []
    ) {
        if (!mysettings.isArray) {
            myfieldName = (string)mysettings;
            mysettings = null;
        }
        mysettings += mydefaults;

        return [myfieldName: mysettings];
    }
    
    /**
     * Invert a when clause for creating notEmpty rules
     * Params:
     * \Closure|string mywhen Indicates when the field is not allowed
     *  to be empty. Valid values are true (always), "create", "update". If a
     *  Closure is passed then the field will allowed to be empty only when
     *  the callback returns false.
     */
    protected DClosure|string invertWhenClause(Closure|string mywhen) {
        if (mywhen == WHEN_CREATE || mywhen == WHEN_UPDATE) {
            return mywhen == WHEN_CREATE ? WHEN_UPDATE : WHEN_CREATE;
        }
        if (cast(Closure)mywhen) {
            return fn (mycontext): !mywhen(mycontext);
        }
        return mywhen;
    }
    
    /**
     * Add a notBlank rule to a field.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.notBlank()
     */
    auto notBlank(string myfield, string myMessage = null, IClosure|string|null mywhen = null) {
        string message; 
        if (myMessage.isNull) {
            message = !_useI18n
             ? "This field cannot be left empty";
                : __d("uim", "This field cannot be left empty");
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "notBlank", myextra ~ [
            "rule": "notBlank",
        ]);
    }
    
    /**
     * Add an alphanumeric rule to a field.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.alphaNumeric()
     */
    auto alphaNumeric(string myfield, string myMessage = null, IClosure|string|null mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be alphanumeric";
            } else {
                myMessage = __d("uim", "The provided value must be alphanumeric");
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "alphaNumeric", myextra ~ [
            "rule": "alphaNumeric",
        ]);
    }
    
    /**
     * Add a non-alphanumeric rule to a field.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.notAlphaNumeric()
     */
    auto notAlphaNumeric(string myfield, string myMessage = null, IClosure|string|null mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must not be alphanumeric";
            } else {
                myMessage = __d("uim", "The provided value must not be alphanumeric");
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "notAlphaNumeric", myextra ~ [
            "rule": "notAlphaNumeric",
        ]);
    }
    
    /**
     * Add an ascii-alphanumeric rule to a field.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.asciiAlphaNumeric()
     */
    auto asciiAlphaNumeric(string myfield, string myMessage = null, IClosure|string|null mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be ASCII-alphanumeric";
            } else {
                myMessage = __d("uim", "The provided value must be ASCII-alphanumeric");
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "asciiAlphaNumeric", myextra ~ [
            "rule": "asciiAlphaNumeric",
        ]);
    }
    
    /**
     * Add a non-ascii alphanumeric rule to a field.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.notAlphaNumeric()
     */
    auto notAsciiAlphaNumeric(string myfield, string errorMessage = null, IClosure|string|null mywhen = null) {
        auto myMessage = errorMessage;
        if (myMessage.isNull) {
            myMessage = !_useI18n
                ? "The provided value must not be ASCII-alphanumeric"
                : __d("uim", "The provided value must not be ASCII-alphanumeric");
        }
        auto myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "notAsciiAlphaNumeric", myextra ~ [
            "rule": "notAsciiAlphaNumeric",
        ]);
    }
    
    /**
     * Add an rule that ensures a string length is within a range.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param Json[string] myrange The inclusive minimum and maximum length you want permitted.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.alphaNumeric()
     * @return this
     * @throws \InvalidArgumentException
     */
    auto lengthBetween(
        string myfield,
        Json[string] myrange,
        string myMessage = null,
        Closure|string|null mywhen = null
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
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "lengthBetween", myextra ~ [
            "rule": ["lengthBetween", mylowerBound, myupperBound],
        ]);
    }
    
    /**
     * Add a credit card rule to a field.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string[] mytype The type of cards you want to allow. Defaults to "all".
     *  You can also supply an array of accepted card types. e.g `["mastercard", "visa", "amex"]`
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.creditCard()
     */
    auto creditCard(
        string myfield,
        string[] mytype = "all",
        string myMessage = null,
        Closure|string|null mywhen = null
    ) {
        if (isArray(mytype)) {
            mytypeEnumeration = join(", ", mytype);
        } else {
            mytypeEnumeration = mytype;
        }
        if (myMessage.isNull) {
            if (!_useI18n) {
                if (mytype == "all") {
                    myMessage = "The provided value must be a valid credit card number of any type";
                } else {
                    myMessage = "The provided value must be a valid credit card number of these types: `%s`"
                        .format(mytypeEnumeration);
                }
            } else {
                if (mytype == "all") {
                    myMessage = __d(
                        "uim",
                        "The provided value must be a valid credit card number of any type"
                    );
                } else {
                    myMessage = __d(
                        "uim",
                        "The provided value must be a valid credit card number of these types: `{0}`",
                        mytypeEnumeration
                    );
                }
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "creditCard", myextra ~ [
            "rule": ["creditCard", mytype, true],
        ]);
    }
    
    /**
     * Add a greater than comparison rule to a field.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param float myvalue The value user data must be greater than.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.comparison()
     */
    auto greaterThan(
        string myfield,
        float myvalue,
        string myMessage = null,
        Closure|string|null mywhen = null
    ) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be greater than `%s`".format(myvalue);
            } else {
                myMessage = __d("uim", "The provided value must be greater than `{0}`", myvalue);
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "greaterThan", myextra ~ [
            "rule": ["comparison", Validation.COMPARE_GREATER, myvalue],
        ]);
    }
    
    /**
     * Add a greater than or equal to comparison rule to a field.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param float myvalue The value user data must be greater than or equal to.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.comparison()
     */
    auto greaterThanOrEqual(
        string myfield,
        float myvalue,
        string myMessage = null,
        Closure|string|null mywhen = null
    ) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be greater than or equal to `%s`".format(myvalue);
            } else {
                myMessage = __d("uim", "The provided value must be greater than or equal to `{0}`", myvalue);
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "greaterThanOrEqual", myextra ~ [
            "rule": ["comparison", Validation.COMPARE_GREATER_OR_EQUAL, myvalue],
        ]);
    }
    
    /**
     * Add a less than comparison rule to a field.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param float myvalue The value user data must be less than.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.comparison()
     */
    auto lessThan(
        string myfield,
        float myvalue,
        string myMessage = null,
        Closure|string|null mywhen = null
    ) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be less than `%s`"
                .format(myvalue);
            } else {
                myMessage = __d("uim", "The provided value must be less than `{0}`", myvalue);
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "lessThan", myextra ~ [
            "rule": ["comparison", Validation.COMPARE_LESS, myvalue],
        ]);
    }
    
    /**
     * Add a less than or equal comparison rule to a field.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param float myvalue The value user data must be less than or equal to.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     */
    auto lessThanOrEqual(
        string myfield,
        float myvalue,
        string myMessage = null,
        Closure|string|null mywhen = null
    ) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be less than or equal to `%s`".format(myvalue);
            } else {
                myMessage = __d("uim", "The provided value must be less than or equal to `{0}`", myvalue);
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "lessThanOrEqual", myextra ~ [
            "rule": ["comparison", Validation.COMPARE_LESS_OR_EQUAL, myvalue],
        ]);
    }
    
    /**
     * Add a equal to comparison rule to a field.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param Json aValue The value user data must be equal to.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.comparison()
     */
    auto equals(
        string myfield,
        Json aValue,
        string myMessage = null,
        Closure|string|null mywhen = null
    ) {
        if (myMessage.isNull) {
            myMessage = !_useI18n
                ? "The provided value must be equal to `%s`".format(myvalue)
                : = __d("uim", "The provided value must be equal to `{0}`", myvalue);
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "equals", myextra ~ [
            "rule": ["comparison", Validation.COMPARE_EQUAL, myvalue],
        ]);
    }
    
    /**
     * Add a not equal to comparison rule to a field.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param Json aValue The value user data must be not be equal to.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.comparison()
     */
    auto notEquals(
        string myfield,
        Json aValue,
        string myMessage = null,
        Closure|string|null mywhen = null
    ) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must not be equal to `%s`".format(myvalue);
            } else {
                myMessage = __d("uim", "The provided value must not be equal to `{0}`", myvalue);
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "notEquals", myextra ~ [
            "rule": ["comparison", Validation.COMPARE_NOT_EQUAL, myvalue],
        ]);
    }
    
    /**
     * Add a rule to compare two fields to each other.
     *
     * If both fields have the exact same value the rule will pass.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string mysecondField The field you want to compare against.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.compareFields()
     */
    auto sameAs(
        string myfield,
        string mysecondField,
        string myMessage = null,
        Closure|string|null mywhen = null
    ) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = sprintf("The provided value must be same as `%s`", mysecondField);
            } else {
                myMessage = __d("uim", "The provided value must be same as `{0}`", mysecondField);
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "sameAs", myextra ~ [
            "rule": ["compareFields", mysecondField, Validation.COMPARE_SAME],
        ]);
    }
    
    /**
     * Add a rule to compare that two fields have different values.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string mysecondField The field you want to compare against.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.compareFields()
     * @return this
     * @since 3.6.0
     */
    auto notSameAs(
        string myfield,
        string mysecondField,
        string myMessage = null,
        Closure|string|null mywhen = null
    ) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = sprintf("The provided value must not be same as `%s`", mysecondField);
            } else {
                myMessage = __d("uim", "The provided value must not be same as `{0}`", mysecondField);
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "notSameAs", myextra ~ [
            "rule": ["compareFields", mysecondField, Validation.COMPARE_NOT_SAME],
        ]);
    }
    
    /**
     * Add a rule to compare one field is equal to another.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string mysecondField The field you want to compare against.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.compareFields()
     * @return this
     */
    auto equalToField(
        string myfield,
        string mysecondField,
        string myMessage = null,
        Closure|string|null mywhen = null
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
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "equalToField", myextra ~ [
            "rule": ["compareFields", mysecondField, Validation.COMPARE_EQUAL],
        ]);
    }
    
    /**
     * Add a rule to compare one field is not equal to another.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string mysecondField The field you want to compare against.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.compareFields()
     * @return this
     */
    auto notEqualToField(
        string myfield,
        string mysecondField,
        string myMessage = null,
        Closure|string|null mywhen = null
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
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "notEqualToField", myextra ~ [
            "rule": ["compareFields", mysecondField, Validation.COMPARE_NOT_EQUAL],
        ]);
    }
    
    /**
     * Add a rule to compare one field is greater than another.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string mysecondField The field you want to compare against.
     * @param string|null errorMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.compareFields()
     * @return this
     * @since 3.6.0
     */
    auto greaterThanField(
        string myfield,
        string mysecondField,
        string errorMessage = null,
        Closure|string|null mywhen = null
    ) {
        auto myMessage = errorMessage;
        if (myMessage.isNull) {
            myMessage = !_useI18n
                ? sprintf("The provided value must be greater than the one of field `%s`", mysecondField);
                : __d(
                    "uim",
                    "The provided value must be greater than the one of field `{0}`",
                    mysecondField
                );
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "greaterThanField", myextra ~ [
            "rule": ["compareFields", mysecondField, Validation.COMPARE_GREATER],
        ]);
    }
    
    /**
     * Add a rule to compare one field is greater than or equal to another.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string mysecondField The field you want to compare against.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.compareFields()
     * @return this
     * @since 3.6.0
     */
    auto greaterThanOrEqualToField(
        string myfield,
        string mysecondField,
        string myMessage = null,
        Closure|string|null mywhen = null
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
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "greaterThanOrEqualToField", myextra ~ [
            "rule": ["compareFields", mysecondField, Validation.COMPARE_GREATER_OR_EQUAL],
        ]);
    }
    
    /**
     * Add a rule to compare one field is less than another.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string mysecondField The field you want to compare against.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.compareFields()
     * @return this
     */
    auto lessThanField(
        string myfield,
        string mysecondField,
        string myMessage = null,
        Closure|string|null mywhen = null
    ) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be less than the one of field `%s`".format(mysecondField);
            } else {
                myMessage = __d(
                    "uim",
                    "The provided value must be less than the one of field `{0}`",
                    mysecondField
                );
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "lessThanField", myextra ~ [
            "rule": ["compareFields", mysecondField, Validation.COMPARE_LESS],
        ]);
    }
    
    /**
     * Add a rule to compare one field is less than or equal to another.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string mysecondField The field you want to compare against.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.compareFields()
     * @return this
     * @since 3.6.0
     */
    auto lessThanOrEqualToField(
        string myfield,
        string mysecondField,
        string myMessage = null,
        Closure|string|null mywhen = null
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
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "lessThanOrEqualToField", myextra ~ [
            "rule": ["compareFields", mysecondField, Validation.COMPARE_LESS_OR_EQUAL],
        ]);
    }
    
    /**
     * Add a date format validation rule to a field.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string[] myformats A list of accepted date formats.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.date()
     */
    auto date(
        string myfield,
        array myformats = ["ymd"],
        string myMessage = null,
        Closure|string|null mywhen = null
    ) {
        myformatEnumeration = join(", ", myformats);

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
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "date", myextra ~ [
            "rule": ["date", myformats],
        ]);
    }
    
    /**
     * Add a date time format validation rule to a field.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string[] myformats A list of accepted date formats.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.datetime()
     */
    auto dateTime(
        string myfield,
        array myformats = ["ymd"],
        string myMessage = null,
        Closure|string|null mywhen = null
    ) {
        myformatEnumeration = join(", ", myformats);

        if (myMessage.isNull) {
            myMessage = !_useI18n
                ? "The provided value must be a date and time of one of these formats: `%s`"
                    .format(myformatEnumeration
                )
                : __d(
                    "uim",
                    "The provided value must be a date and time of one of these formats: `{0}`",
                    myformatEnumeration
                );
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "dateTime", myextra ~ [
            "rule": ["datetime", myformats],
        ]);
    }
    
    /**
     * Add a time format validation rule to a field.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.time()
     */
    auto time(string myfield, string myMessage = null, IClosure|string|null mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be a time";
            } else {
                myMessage = __d("uim", "The provided value must be a time");
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "time", myextra ~ [
            "rule": "time",
        ]);
    }
    
    /**
     * Add a localized time, date or datetime format validation rule to a field.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string mytype Parser type, one out of "date", "time", and "datetime"
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.localizedTime()
     */
    auto localizedTime(
        string myfield,
        string mytype = "datetime",
        string myMessage = null,
        Closure|string|null mywhen = null
    ) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be a localized time, date or date and time";
            } else {
                myMessage = __d("uim", "The provided value must be a localized time, date or date and time");
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "localizedTime", myextra ~ [
            "rule": ["localizedTime", mytype],
        ]);
    }
    
    /**
     * Add a boolean validation rule to a field.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.boolean()
     */
    auto boolean(string myfield, string myMessage = null, IClosure|string|null mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be a boolean";
            } else {
                myMessage = __d("uim", "The provided value must be a boolean");
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "boolean", myextra ~ [
            "rule": "boolean",
        ]);
    }
    
    /**
     * Add a decimal validation rule to a field.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param int myplaces The number of decimal places to require.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.decimal()
     */
    auto decimal(
        string myfield,
        int myplaces = null,
        string myMessage = null,
        Closure|string|null mywhen = null
    ) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = myplaces.isNull
                    ? "The provided value must be decimal with any number of decimal places, including none"
                    : "The provided value must be decimal with `%s` decimal places".format(myplaces);

            } else {
                myMessage = myplaces.isNull
                    ? __d(
                        "uim",
                        "The provided value must be decimal with any number of decimal places, including none"
                    )
                    : __d(
                        "uim",
                        "The provided value must be decimal with `{0}` decimal places",
                        myplaces
                    );
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "decimal", myextra ~ [
            "rule": ["decimal", myplaces],
        ]);
    }
    
    /**
     * Add an email validation rule to a field.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param bool mycheckMX Whether to check the MX records.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.email()
     */
    auto email(
        string myfield,
        bool mycheckMX = false,
        string myMessage = null,
        Closure|string|null mywhen = null
    ) {
        if (myMessage.isNull) {
            myMessage = !_useI18n
                ? "The provided value must be an e-mail address"
                : __d("uim", "The provided value must be an e-mail address");
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "email", myextra ~ [
            "rule": ["email", mycheckMX],
        ]);
    }
    
    /**
     * Add a backed enum validation rule to a field.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param class-string<\BackedEnum> myenumClassName The valid backed enum class name.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @return this
     * @see \UIM\Validation\Validation.enum()
     * @since 5.0.3
     */
    auto enum(
        string myfield,
        string myenumClassName,
        string myMessage = null,
        Closure|string|null mywhen = null
    ) {
        if (!in_array(BackedEnum.classname, (array)class_implements(myenumClassName), true)) {
            throw new DInvalidArgumentException(
                "The `myenumClassName` argument must be the classname of a valid backed enum."
            );
        }
        if (myMessage.isNull) {
            mycases = array_map(fn (mycase): mycase.value, myenumClassName.cases());
            mycaseOptions = join("`, `", mycases);
            
            myMessage = !_useI18n 
                ? "The provided value must be one of `%s`".format(mycaseOptions)
                : __d("uim", "The provided value must be one of `{0}`", mycaseOptions);

        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "enum", myextra ~ [
            "rule": ["enum", myenumClassName],
        ]);
    }
    
    /**
     * Add an IP validation rule to a field.
     *
     * This rule will accept both IPv4 and IPv6 addresses.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     */
    auto ip(string myfield, string myMessage = null, IClosure|string|null mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be an IP address";
            } else {
                myMessage = __d("uim", "The provided value must be an IP address");
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "ip", myextra ~ [
            "rule": "ip",
        ]);
    }
    
    /**
     * Add an IPv4 validation rule to a field.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.ip()
     */
    auto ipv4(string myfield, string myMessage = null, IClosure|string|null mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be an IPv4 address";
            } else {
                myMessage = __d("uim", "The provided value must be an IPv4 address");
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "ipv4", myextra ~ [
            "rule": ["ip", "ipv4"],
        ]);
    }
    
    /**
     * Add an IPv6 validation rule to a field.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.ip()
     */
    auto ipv6(string myfield, string myMessage = null, IClosure|string|null mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be an IPv6 address";
            } else {
                myMessage = __d("uim", "The provided value must be an IPv6 address");
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "ipv6", myextra ~ [
            "rule": ["ip", "ipv6"],
        ]);
    }
    
    /**
     * Add a string length validation rule to a field.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param int mymin The minimum length required.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.minLength()
     */
    auto minLength(string myfield, int mymin, string myMessage = null, IClosure|string|null mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = sprintf("The provided value must be at least `%s` characters long", mymin);
            } else {
                myMessage = __d("uim", "The provided value must be at least `{0}` characters long", mymin);
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "minLength", myextra ~ [
            "rule": ["minLength", mymin],
        ]);
    }
    
    /**
     * Add a string length validation rule to a field.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param int mymin The minimum length required.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.minLengthBytes()
     */
    auto minLengthBytes(string myfield, int mymin, string myMessage = null, IClosure|string|null mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = sprintf("The provided value must be at least `%s` bytes long", mymin);
            } else {
                myMessage = __d("uim", "The provided value must be at least `{0}` bytes long", mymin);
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "minLengthBytes", myextra ~ [
            "rule": ["minLengthBytes", mymin],
        ]);
    }
    
    /**
     * Add a string length validation rule to a field.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param int mymax The maximum length allowed.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.maxLength()
     */
    auto maxLength(string myfield, int mymax, string myMessage = null, IClosure|string|null mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = sprintf("The provided value must be at most `%s` characters long", mymax);
            } else {
                myMessage = __d("uim", "The provided value must be at most `{0}` characters long", mymax);
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "maxLength", myextra ~ [
            "rule": ["maxLength", mymax],
        ]);
    }
    
    /**
     * Add a string length validation rule to a field.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param int mymax The maximum length allowed.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.maxLengthBytes()
     */
    auto maxLengthBytes(string myfield, int mymax, string myMessage = null, IClosure|string|null mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = sprintf("The provided value must be at most `%s` bytes long", mymax);
            } else {
                myMessage = __d("uim", "The provided value must be at most `{0}` bytes long", mymax);
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "maxLengthBytes", myextra ~ [
            "rule": ["maxLengthBytes", mymax],
        ]);
    }
    
    /**
     * Add a numeric value validation rule to a field.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.numeric()
     */
    auto numeric(string myfield, string myMessage = null, IClosure|string|null mywhen = null) {
        if (myMessage.isNull) {
            myMessage = !_useI18n
                ? "The provided value must be numeric"
                : __d("uim", "The provided value must be numeric");

        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "numeric", myextra ~ [
            "rule": "numeric",
        ]);
    }
    
    /**
     * Add a natural number validation rule to a field.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.naturalNumber()
     */
    auto naturalNumber(string myfield, string myMessage = null, IClosure|string|null mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be a natural number";
            } else {
                myMessage = __d("uim", "The provided value must be a natural number");
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "naturalNumber", myextra ~ [
            "rule": ["naturalNumber", false],
        ]);
    }
    
    /**
     * Add a validation rule to ensure a field is a non negative integer.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.naturalNumber()
     */
    auto nonNegativeInteger(string myfield, string myMessage = null, IClosure|string|null mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be a non-negative integer";
            } else {
                myMessage = __d("uim", "The provided value must be a non-negative integer");
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "nonNegativeInteger", myextra ~ [
            "rule": ["naturalNumber", true],
        ]);
    }
    
    /**
     * Add a validation rule to ensure a field is within a numeric range
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param Json[string] myrange The inclusive upper and lower bounds of the valid range.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.range()
     * @return this
     * @throws \InvalidArgumentException
     */
    auto range(string myfield, Json[string] myrange, string myMessage = null, IClosure|string|null mywhen = null) {
        if (count(myrange) != 2) {
            throw new DInvalidArgumentException("The myrange argument requires 2 numbers");
        }
        mylowerBound = array_shift(myrange);
        myupperBound = array_shift(myrange);

        if (myMessage.isNull) {
            myMessage = !_useI18n 
                ? "The provided value must be between `%s` and `%s`, inclusively"
                    .format(mylowerBound, myupperBound);
                : __d(
                    "uim",
                    "The provided value must be between `{0}` and `{1}`, inclusively",
                    mylowerBound,
                    myupperBound
                );
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "range", myextra ~ [
            "rule": ["range", mylowerBound, myupperBound],
        ]);
    }
    
    /**
     * Add a validation rule to ensure a field is a URL.
     *
     * This validator does not require a protocol.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.url()
     */
    auto url(string myfield, string myMessage = null, IClosure|string|null mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be a URL";
            } else {
                myMessage = __d("uim", "The provided value must be a URL");
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "url", myextra ~ [
            "rule": ["url", false],
        ]);
    }
    
    /**
     * Add a validation rule to ensure a field is a URL.
     *
     * This validator requires the URL to have a protocol.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.url()
     */
    auto urlWithProtocol(string myfield, string myMessage = null, IClosure|string|null mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be a URL with protocol";
            } else {
                myMessage = __d("uim", "The provided value must be a URL with protocol");
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "urlWithProtocol", myextra ~ [
            "rule": ["url", true],
        ]);
    }
    
    /**
     * Add a validation rule to ensure the field value is within an allowed list.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param Json[string] mylist The list of valid options.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.inList()
     */
    auto inList(string myfield, Json[string] mylist, string myMessage = null, IClosure|string|null mywhen = null) {
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
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "inList", myextra ~ [
            "rule": ["inList", mylist],
        ]);
    }
    
    /**
     * Add a validation rule to ensure the field is a UUID
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.uuid()
     */
    auto uuid(string myfield, string myMessage = null, IClosure|string|null mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be a UUID";
            } else {
                myMessage = __d("uim", "The provided value must be a UUID");
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "uuid", myextra ~ [
            "rule": "uuid",
        ]);
    }
    
    /**
     * Add a validation rule to ensure the field is an uploaded file
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param Json[string] options An array of options.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.uploadedFile() For options
     */
    auto uploadedFile(
        string myfield,
        Json[string] options,
        string myMessage = null,
        Closure|string|null mywhen = null
    ) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be an uploaded file";
            } else {
                myMessage = __d("uim", "The provided value must be an uploaded file");
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "uploadedFile", myextra ~ [
            "rule": ["uploadedFile", options],
        ]);
    }
    
    /**
     * Add a validation rule to ensure the field is a lat/long tuple.
     *
     * e.g. `<lat>, <lng>`
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.geoCoordinate()
     */
    auto latLong(string myfield, string myMessage = null, IClosure|string|null mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be a latitude/longitude coordinate";
            } else {
                myMessage = __d("uim", "The provided value must be a latitude/longitude coordinate");
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "latLong", myextra ~ [
            "rule": "geoCoordinate",
        ]);
    }
    
    /**
     * Add a validation rule to ensure the field is a latitude.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.latitude()
     */
    auto latitude(string myfield, string myMessage = null, IClosure|string|null mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be a latitude";
            } else {
                myMessage = __d("uim", "The provided value must be a latitude");
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "latitude", myextra ~ [
            "rule": "latitude",
        ]);
    }
    
    /**
     * Add a validation rule to ensure the field is a longitude.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.longitude()
     */
    auto longitude(string myfield, string myMessage = null, IClosure|string|null mywhen = null) {
        if (myMessage.isNull) {
            myMessage = !_useI18n
                ? "The provided value must be a longitude"
                : __d("uim", "The provided value must be a longitude");

        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "longitude", myextra ~ [
            "rule": "longitude",
        ]);
    }
    
    /**
     * Add a validation rule to ensure a field contains only ascii bytes
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.ascii()
     */
    auto ascii(string myfield, string myMessage = null, IClosure|string|null mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be ASCII bytes only";
            } else {
                myMessage = __d("uim", "The provided value must be ASCII bytes only");
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "ascii", myextra ~ [
            "rule": "ascii",
        ]);
    }
    
    /**
     * Add a validation rule to ensure a field contains only BMP utf8 bytes
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.utf8()
     */
    auto utf8(string myfield, string myMessage = null, IClosure|string|null mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be UTF-8 bytes only";
            } else {
                myMessage = __d("uim", "The provided value must be UTF-8 bytes only");
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "utf8", myextra ~ [
            "rule": ["utf8", ["extended": false.toJson]],
        ]);
    }
    
    /**
     * Add a validation rule to ensure a field contains only utf8 bytes.
     *
     * This rule will accept 3 and 4 byte UTF8 sequences, which are necessary for emoji.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.utf8()
     */
    auto utf8Extended(string myfield, string myMessage = null, IClosure|string|null mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be 3 and 4 byte UTF-8 sequences only";
            } else {
                myMessage = __d("uim", "The provided value must be 3 and 4 byte UTF-8 sequences only");
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "utf8Extended", myextra ~ [
            "rule": ["utf8", ["extended": true.toJson]],
        ]);
    }
    
    /**
     * Add a validation rule to ensure a field is an integer value.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.isInteger()
     */
    auto integer(string myfield, string myMessage = null, IClosure|string|null mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be an integer";
            } else {
                myMessage = __d("uim", "The provided value must be an integer");
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "integer", myextra ~ [
            "rule": "isInteger",
        ]);
    }
    
    /**
     * Add a validation rule to ensure that a field contains an array.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.isArray()
     */
    auto array(string myfield, string myMessage = null, IClosure|string|null mywhen = null) {
        if (myMessage.isNull) {
            if (!_useI18n) {
                myMessage = "The provided value must be an array";
            } else {
                myMessage = __d("uim", "The provided value must be an array");
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "array", myextra ~ [
            "rule": "isArray",
        ]);
    }
    
    /**
     * Add a validation rule to ensure that a field contains a scalar.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     */
    auto scalar(string myfield, string myMessage = null, IClosure|string|null mywhen = null) {
        if (myMessage.isNull) {
            myMessage = "The provided value must be scalar";
            if (_useI18n) {
                myMessage = __d("uim", "The provided value must be scalar");
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "scalar", myextra ~ [
                "rule": "isScalar",
            ]);
    }
    
    /**
     * Add a validation rule to ensure a field is a 6 digits hex color value.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.hexColor()
     */
    auto hexColor(string myfield, string myMessage = null, IClosure|string|null mywhen = null) {
        if (myMessage.isNull) {
            myMessage = "The provided value must be a hex color";
            if (_useI18n) {
                myMessage = __d("uim", "The provided value must be a hex color");
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "hexColor", myextra ~ [
            "rule": "hexColor",
        ]);
    }
    
    /**
     * Add a validation rule for a multiple select. Comparison is case sensitive by default.
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param Json[string] options The options for the validator. Includes the options defined in
     *  \UIM\Validation\Validation.multiple() and the `caseInsensitive` parameter.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.multiple()
     */
    auto multipleOptions(
        string myfield,
        Json[string] optionData = null,
        string myMessage = null,
        Closure|string|null mywhen = null
    ) {
        if (myMessage.isNull) {
            myMessage = "The provided value must be a set of multiple options";
            if (_useI18n) {
                myMessage = __d("uim", "The provided value must be a set of multiple options");
            }
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);
        mycaseInsensitive = options["caseInsensitive"] ?? false;
        options.remove("caseInsensitive"]);

        return _add(myfield, "multipleOptions", myextra ~ [
            "rule": ["multiple", options, mycaseInsensitive],
        ]);
    }
    
    /**
     * Add a validation rule to ensure that a field is an array containing at least
     * the specified amount of elements
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param int mycount The number of elements the array should at least have
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.numElements()
     */
    auto hasAtLeast(string myfield, int mycount, string myMessage = null, IClosure|string|null mywhen = null) {
        if (myMessage.isNull) {
            mymewssage = !_useI18n
                ? sprintf("The provided value must have at least `%s` elements", mycount)
                :  __d("uim", "The provided value must have at least `{0}` elements", mycount);

        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "hasAtLeast", myextra ~ [
            "rule": auto (myvalue) use (mycount) {
                if (isArray(myvalue) && isSet(myvalue["_ids"])) {
                    myvalue = myvalue["_ids"];
                }
                return Validation.numElements(myvalue, Validation.COMPARE_GREATER_OR_EQUAL, mycount);
            },
        ]);
    }
    
    /**
     * Add a validation rule to ensure that a field is an array containing at most
     * the specified amount of elements
     * Params:
     * string myfield The field you want to apply the rule to.
     * @param int mycount The number maximum amount of elements the field should have
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     * @see \UIM\Validation\Validation.numElements()
     */
    auto hasAtMost(string myfield, int mycount, string myMessage = null, IClosure|string|null mywhen = null) {
        if (myMessage.isNull) {
            myMessage = !_useI18n 
                ? "The provided value must have at most `%s` elements".format(mycount)
                : __d("uim", "The provided value must have at most `{0}` elements"mycount);
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(myfield, "hasAtMost", myextra ~ [
            "rule": auto (myvalue) use (mycount) {
                if (isArray(myvalue) && isSet(myvalue["_ids"])) {
                    myvalue = myvalue["_ids"];
                }
                return Validation.numElements(myvalue, Validation.COMPARE_LESS_OR_EQUAL, mycount);
            },
        ]);
    }
    
    /**
     * Returns whether a field can be left empty for a new or already existing
     * record.
     * Params:
     * string myfield Field name.
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
        myproviders = _providers;
        mydata = null;
        mycontext = compact("data", "newRecord", "field", "providers");

        return !_checkPresence(this.field(fieldName), mycontext);
    }
    
    /**
     * Returns whether a field matches against a regular expression.
     * Params:
     * string fieldName Field name.
     * @param string myregex Regular expression.
     * @param string|null myMessage The error message when the rule fails.
     * @param \Closure|string|null mywhen Either "create" or "update" or a Closure that returns
     *  true when the validation rule should be applied.
     */
    auto regex(string fieldName, string myregex, string myMessage = null, IClosure|string|null mywhen = null) {
        if (myMessage.isNull) {
            myMessage = !_useI18n
                ? "The provided value must match against the pattern `%s`".format(myregex)
                : __d("uim", "The provided value must match against the pattern `{0}`", myregex);
        }
        myextra = array_filter(["on": mywhen, "message": myMessage]);

        return _add(fieldName, "regex", myextra ~ [
            "rule": ["custom", myregex],
        ]);
    }
    
    /**
     * Gets the required message for a field
     * Params:
     * string fieldName Field name
     */
    string getRequiredMessage(string fieldName) {
        if (!_fields.isSet(fieldName)) {
            return null;
        }
        if (isSet(_presenceMessages[fieldName])) {
            return _presenceMessages[fieldName];
        }
        if (!_useI18n) {
            myMessage = "This field is required";
        } else {
            myMessage = __d("uim", "This field is required");
        }
        return myMessage;
    }
    
    // Gets the notEmpty message for a field
    
    string getNotEmptyMessage(string fieldName) {
        if (!isSet(_fields[fieldName])) {
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

        myMessage = !_useI18n
            ? "This field cannot be left empty"
            : __d("uim", "This field cannot be left empty");

        return myMessage;
    }
    
    /**
     * Returns false if any validation for the passed rule set should be stopped
     * due to the field missing in the data array
     * Params:
     * \UIM\Validation\ValidationSet myfield The set of rules for a field.
     * @param Json[string] mycontext A key value list of data containing the validation context.
     */
    protected bool _checkPresence(ValidationSet myfield, Json[string] mycontext) {
        myrequired = myfield.isPresenceRequired();

        if (cast(Closure)myrequired) {
            return !myrequired(mycontext);
        }
        mynewRecord = mycontext["newRecord"];
        if (in_array(myrequired, [WHEN_CREATE, WHEN_UPDATE], true)) {
            return (myrequired == WHEN_CREATE && !mynewRecord) ||
                (myrequired == WHEN_UPDATE && mynewRecord);
        }
        return !myrequired;
    }
    
    /**
     * Returns whether the field can be left blank according to `allowEmpty`
     * Params:
     * \UIM\Validation\ValidationSet myfield the set of rules for a field
     * @param Json[string] mycontext a key value list of data containing the validation context.
     */
    protected bool _canBeEmpty(ValidationSet myfield, Json[string] mycontext) {
        myallowed = myfield.isEmptyAllowed();

        if (cast(Closure)myallowed) {
            return myallowed(mycontext);
        }
        mynewRecord = mycontext["newRecord"];
        if (in_array(myallowed, [WHEN_CREATE, WHEN_UPDATE], true)) {
            myallowed = (myallowed == WHEN_CREATE && mynewRecord) ||
                (myallowed == WHEN_UPDATE && !mynewRecord);
        }
        return (bool)myallowed;
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
        if (mydata == "" && (myflags & self.EMPTY_STRING)) {
            return true;
        }
        myarrayTypes = self.EMPTY_ARRAY | self.EMPTY_DATE | self.EMPTY_TIME;
        if (mydata == [] && (myflags & myarrayTypes)) {
            return true;
        }
        if (isArray(mydata)) {
            myallFieldsAreEmpty = true;
            foreach (mydata as myfield) {
                if (myfield !isNull && myfield != "") {
                    myallFieldsAreEmpty = false;
                    break;
                }
            }
            if (myallFieldsAreEmpty) {
                if ((myflags & self.EMPTY_DATE) && isSet(mydata["year"])) {
                    return true;
                }
                if ((myflags & self.EMPTY_TIME) && isSet(mydata["hour"])) {
                    return true;
                }
            }
        }
        if (
            (myflags & self.EMPTY_FILE)
            && cast(IUploadedFile)mydata
            && mydata.getError() == UPLOAD_ERR_NO_FILE
        ) {
            return true;
        }
        return false;
    }
    
    /**
     * Iterates over each rule in the validation set and collects the errors resulting
     * from executing them
     * Params:
     * string myfield The name of the field that is being processed
     * @param \UIM\Validation\ValidationSet myrules the list of rules for a field
     * @param Json[string] data the full data passed to the validator
     * @param bool mynewRecord whether is it a new record or an existing one
     */
    protected Json[string] _processRules(string myfield, ValidationSet myrules, Json[string] data, bool mynewRecord) {
        myerrors = null;
        // Loading default provider in case there is none
        getProvider("default");

        if (!_useI18n) {
            myMessage = "The provided value is invalid";
        } else {
            myMessage = __d("uim", "The provided value is invalid");
        }
        foreach (myname: myrule; myrules) {
            result = myrule.process(mydata[myfield], _providers, compact("newRecord", "data", "field"));
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
    
    /**
     * Get the printable version of this object.
     */
    Json[string] debugInfo() {
        myfields = null;
        foreach (_fields as myname: myfieldSet) {
            myfields[myname] = [
                "isPresenceRequired": myfieldSet.isPresenceRequired(),
                "isEmptyAllowed": myfieldSet.isEmptyAllowed(),
                "rules": myfieldSet.rules().keys,
            ];
        }
        return [
            "_presenceMessages": _presenceMessages,
            "_allowEmptyMessages": _allowEmptyMessages,
            "_allowEmptyFlags": _allowEmptyFlags,
            "_useI18n": _useI18n,
            "_stopOnFailure": _stopOnFailure,
            "_providers": _providers.keys,
            "_fields": myfields,
        ];
    } */
}
