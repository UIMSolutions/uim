module uim.views.classes.forms.protector;

import uim.views;

@safe:

/**
 * Protects against form tampering. It ensures that:
 *
 * - Form`s action (URL) is not modified.
 * - Unknown / extra fields are not added to the form.
 * - Existing fields have not been removed from the form.
 * - Values of hidden inputs have not been changed.
 *
 * @internal
 */
class DFormProtector {
    // Unlocked fields.
    protected string[] unlockedFields;

    // Error message providing detail for failed validation.
    protected string _debugMessage;

    // Get validation error message.
    string getError() {
        return _debugMessage;
    }
    
    /*
    // Fields list.
    protected Json[string] fields = null;

    /**
     * Validate submitted form data.
     * Params:
     * Json formData Form data.
     * @param string aurl URL form was POSTed to.
     * @param string asessionId Session id for hash generation.
     */
    bool validate(Json formData, string formUrl, string asessionId) {
        _debugMessage = null;

        auto extractedToken = this.extractToken(formData);
        if (extractedToken.isEmpty) {
            return false;
        }
        auto hashParts = extractHashParts(formData);
        auto generatedToken = this.generateHash(
            hashParts["fields"],
            hashParts["unlockedFields"],
            formUrl,
            sessionId
       );

        if (hash_equals(generatedToken, extractedToken)) {
            return true;
        }
        if (configuration.hasKey("debug")) {
            if (auto debugMessage = debugTokenNotMatching(formData, hashParts + compact("url", "sessionId"))) {
                _debugMessage = debugMessage;
            }
        }
        return false;
    }
    
    /**
     * Construct.
     * Params:
     * Json[string] someData Data array, can contain key `unlockedFields` with list of unlocked fields.
     */
    this(Json[string] data= null) {
        if (!someData.isEmpty("unlockedFields")) {
            this.unlockedFields = someData["unlockedFields"];
        }
    }
    
    /**
     * Determine which fields of a form should be used for hash.
     * Params:
     * string[]|string fieldName Reference to field to be secured. Can be dot
     * separated string to indicate nesting or array of fieldname parts.
     * @param bool lock Whether this field should be part of the validation
     * or excluded as part of the unlockedFields. Default `true`.
     * @param Json aValue Field value, if value should not be tampered with.
     */
    auto addField(string[] afield, bool lock = true, Json aValue = null) {
        if (isString(field)) {
            field = getFieldNameArray(field);
        }
        if (isEmpty(field)) {
            return this;
        }
        foreach (unlockField; this.unlockedFields) {
            string[] unlockParts = unlockField.split(".");
            if (array_values(array_intersect(field, unlockParts)) == unlockParts) {
                return this;
            }
        }
        field = field.join(".");
        field = to!string(preg_replace("/(\.\d+)+/", "", field));

        if (lock) {
            if (!isIn(field, this.fields, true)) {
                if (aValue !is null) {
                    _fields[field] = aValue;

                    return this;
                }
                if (_fields.hasKey(field)) {
                    fields.remove(field);
                }
                _fields ~= field;
            }
        } else {
            this.unlockField(field);
        }
        return this;
    }
    
    /**
     * Parses the field name to create a dot separated name value for use in
     * field hash. If fieldname is of form Model[field] or Model.field an array of
     * fieldname parts like ["Model", "field"] is returned.
     */
    protected string[] getFieldNameArray(string attributeName) {
        if (isEmpty(attributeName) && attributeName != "0") {
            return null;
        }
        if (!attributeName.contains("[")) {
            return Hash.filter(split(".", attributeName));
        }
        
        string[] someParts = attributeName.split("[");
        someParts = array_map(function (el) {
            return strip(el, "]");
        }, someParts);

        return Hash.filter(someParts, "strlen");
    }
    
    /**
     * Add to the list of fields that are currently unlocked.
     *
     * Unlocked fields are not included in the field hash.
     */
    auto unlockField(string fieldName) { // fieldName - dot separated name
        if (!isIn(name, this.unlockedFields, true)) {
            this.unlockedFields ~= fieldName;
        }
         anIndex = array_search(fieldName, this.fields, true);
        if (anIndex == true) {
            remove(_fields[anIndex]);
        }
        remove(_fields[fieldName]);

        return this;
    }
    

    
    /**
     * Extract token from data.
     * Params:
     * Json formData Data to validate.
     */
    protected string extractToken(Json formData) {
        if (!isArray(formData)) {
            _debugMessage = "Request data is not an array.";

            return null;
        }
        
        string message = "`%s` was not found in request data.";
        if (!formData.hasKey("_Token")) {
            _debugMessage = message.format("_Token");

            return null;
        }
        if (!formData["_Token"].hasKey("fields")) {
            _debugMessage = message.format("_Token.fields");

            return null;
        }
        if (!formData.isString("_Token.fields")) {
            _debugMessage = "`_Token.fields` is invalid.";

            return null;
        }
        if (!formData.hasKey("_Token.unlocked")) {
            _debugMessage = message.format("_Token.unlocked");

            return null;
        }
        if (configuration.hasKey("debug") && !formData.hasKey("_Token.debug")) {
            _debugMessage = message.format("_Token.debug");

            return null;
        }
        if (!configuration.hasKey("debug") && formData.hasKey("_Token.debug")) {
            _debugMessage = "Unexpected `_Token.debug` found in request data";
            return null;
        }
        
        string token = urldecode(formData["_Token.fields"]);
        if (token.contains(": ")) {
            [token, ] = split(": ", token, 2);
        }
        return token;
    }
    
    // Return hash parts for the token generation
    protected Json[string] extractHashParts(Json[string] formData) {
        auto fields = extractFields(formData);
        auto unlockedFields = sortedUnlockedFields(formData);

        return [
            "fields": fields,
            "unlockedFields": unlockedFields,
        ];
    }
    
    /**
     * Return the fields list for the hash calculation
     * Params:
     * Json[string] formData Data array
     */
    protected Json[string] extractFields(Json[string] formData) {
        string locked = "";
        string token = urldecode(formData["_Token.fields"]);
        string unlocked = urldecode(formData["_Token.unlocked"]);

        if (token.contains(": ")) {
            [, locked] = split(": ", token, 2);
        }
        remove(formData["_Token"]);

        string[] lockeds = locked ? locked.split("|") : null;
        string[] unlockeds = unlocked ? unlocked.split("|"): [];

        auto fields = Hash.flatten(formData);
        auto fieldList = fields.keys;
        auto multi = lockedFields = null;
         auto isUnlocked = false;

        foreach (anI: aKey; fieldList) {
            if (isString(aKey) && preg_match("/(\.\d+){1,10}/", aKey)) {
                multi[anI] = preg_replace("/(\.\d+){1,10}/", "", aKey);
                remove(fieldList[anI]);
            } else {
                fieldList[anI] = /* (string) */aKey;
            }
        }
        if (!multi.isEmpty) {
            fieldList += array_unique(multi);
        }
        unlockedFields = array_unique(
            chain(
                this.unlockedFields,
                unlocked
           )
       );

        /** @var string aKey */
        foreach (anI: aKey; fieldList) {
             isLocked = isIn(aKey, locked, true);

            if (!unlockedFields.isEmpty) {
                foreach (off; unlockedFields) {
                    string[] offs = off.split(".");
                    field = array_intersect(aKey.split("."), offs).values;
                     isUnlocked = (field == off);
                    if (isUnlocked) {
                        break;
                    }
                }
            }
            if (isUnlocked ||  isLocked) {
                remove(fieldList[anI]);
                if (isLocked) {
                    lockedFields[aKey] = fields[aKey];
                }
            }
        }
        fieldList = fieldList.sort(SORT_STRING);
        ksort(lockedFields, SORT_STRING);
        fieldList += lockedFields;

        return fieldList;
    }
    
    /**
     * Get the sorted unlocked string
     * Params:
     * Json[string] formData Data array
     */
    protected string[] sortedUnlockedFields(Json[string] formData) {
        string unlocked = urldecode(formData["_Token.unlocked"]);
        return !unlocked.isEmpty
            ? unlocked.split("|").sort(SORT_STRING)
            : null;        
    }
    
    /**
     * Generate the token data.
     * Params:
     * string aurl Form URL.
     * @param string asessionId Session Id.
     */
    STRINGAA buildTokenData(string aurl = "", string asessionId= null) {
        auto fields = _fields.dup;
        auto unlockedFields = _unlockedFields.dup;

        auto locked = null;
        fields.byKeyValue
            .each!((kv) {
                if (isNumeric(kv.value)) {
                    kv.value = /* (string) */kv.value;
                }
                if (!isInteger(kv.key)) {
                    locked[kv.key] = kv.value;
                    remove(fields[kv.key]);
                }
            });
        sort(unlockedFields, SORT_STRING);
        sort(fields, SORT_STRING);
        ksort(locked, SORT_STRING);
        fields += locked;

        fields = generateHash(fields, unlockedFields, url, sessionId);
        locked = locked.keys.join("|");

        return [
            "fields": urlencode(fields ~ ": " ~ locked),
            "unlocked": urlencode(join("|", unlockedFields)),
            "debug": urlencode(/* (string) */Json_ncode([
                url,
                this.fields,
                this.unlockedFields,
            ])),
        ];
    }
    
    /**
     * Generate validation hash.
     * Params:
     * Json[string] fields Fields list.
     * @param string[] unlockedFields Unlocked fields.
     * @param string aurl Form URL.
     * @param string asessionId Session Id.
     */
    protected string generateHash(string[] fieldNames, Json[string] unlockedFields, string aurl, string asessionId) {
        hashParts = [
            url,
            serialize(fields),
            unlockedFields.join("|"),
            sessionId,
        ];

        return hash_hmac("sha1", hashParts.join(""), Security.getSalt());
    }
    
    /**
     * Create a message for humans to understand why Security token is not matching
     * Params:
     * Json[string] formData Data.
     * @param Json[string] hashParts Elements used to generate the Token hash
     */
    protected string debugTokenNotMatching(Json[string] formData, Json[string] hashParts) {
        messages = null;
        if (formData.isNull("_Token.debug")) {
            return "Form protection debug token not found.";
        }
        expectedParts = Json_decode(urldecode(formData["_Token.debug"]), true);
        if (!isArray(expectedParts) || count(expectedParts) != 3) {
            return "Invalid form protection debug token.";
        }
        expectedUrl = Hash.get(expectedParts, 0);
        url = Hash.get(hashParts, "url");
        if (expectedUrl != url) {
            messages ~= "URL mismatch in POST data (expected `%s` but found `%s`)"
                .format(expectedUrl, url);
        }
        expectedFields = Hash.get(expectedParts, 1);
        someDataFields = Hash.get(hashParts, "fields") ?: [];
        fieldsMessages = this.debugCheckFields(
            (array)someDataFields,
            expectedFields,
            "Unexpected field `%s` in POST data",
            "Tampered field `%s` in POST data (expected value `%s` but found `%s`)",
            "Missing field `%s` in POST data"
       );
        expectedUnlockedFields = Hash.get(expectedParts, 2);
        someDataUnlockedFields = Hash.get(hashParts, "unlockedFields") ?: [];
        unlockFieldsMessages = this.debugCheckFields(
            (array)someDataUnlockedFields,
            expectedUnlockedFields,
            "Unexpected unlocked field `%s` in POST data",
            "",
            "Missing unlocked field: `%s`"
       );

        messages = chain(messages, fieldsMessages, unlockFieldsMessages);
        return messages.join(", ", );
    }
    
    /**
     * Iterates data array to check against expected
     * Params:
     * Json[string] someDataFields Fields array, containing the POST data fields
     * @param Json[string] expectedFields Fields array, containing the expected fields we should have in POST
     * @param string aintKeyMessage Message string if unexpected found in data fields indexed by int (not protected)
     * @param string astringKeyMessage Message string if tampered found in
     * data fields indexed by string (protected).
     * @param string amissingMessage Message string if missing field
     */
    protected string[] debugCheckFields(
        Json[string] someDataFields,
        Json[string] expectedFields= null,
        string aintKeyMessage = "",
        string astringKeyMessage = "",
        string amissingMessage = ""
   ) {
        auto messages = this.matchExistingFields(someDataFields, expectedFields,  anIntKeyMessage, stringKeyMessage);
        auto expectedFieldsMessage = this.debugExpectedFields(expectedFields, missingMessage);
        if (!expectedFieldsMessage.isNull) {
            messages ~= expectedFieldsMessage;
        }
        return messages;
    }
    
    /**
     * Generate array of messages for the existing fields in POST data, matching dataFields in expectedFields
     * will be unset
     * Params:
     * Json[string] someDataFields Fields array, containing the POST data fields
     * @param Json[string] expectedFields Fields array, containing the expected fields we should have in POST
     * @param string aintKeyMessage Message string if unexpected found in data fields indexed by int (not protected)
     * @param string astringKeyMessage Message string if tampered found in
     * data fields indexed by string (protected)
     */
    protected string[] matchExistingFields(
        array someDataFields,
        array &expectedFields,
        string aintKeyMessage,
        string astringKeyMessage
   ) {
        string[] messages = null;
        someDataFields.byKeyValue.each!((kv) {
            if (isInteger(kv.key)) {
                foundKey = array_search(kv.value, expectedFields, true);
                if (foundKey == false) {
                    messages ~= anIntKeyMessage.format(kv.value);
                } else {
                    expectedFields.remove(foundKey);
                }
            } else {
                if (expectedFields.hasKey(kv.key) && kv.value != expectedFields[kv.key]) {
                    messages ~= stringKeyMessage
                    .format(kv.key, expectedFields[kv.key], kv.value);
                }
                expectedFields.remove(kv.key);
            }
        }
        return messages;
    }
    
    /**
     * Generate debug message for the expected fields
     * Params:
     * Json[string] expectedFields Expected fields
     * @param string amissingMessage Message template
     */
    protected string debugExpectedFields(Json[string] expectedFields= null, string amissingMessage= null) {
        if (count(expectedFields) == 0) {
            return null;
        }
        expectedFieldNames = expectedFields
            .map!(kv, debugExpectedField(kv.key, kv.value))
            .array;

        return missingMessage.format(join(", ", expectedFieldNames));
    }
    protected string debugExpectedField(aKey, expectedField) {
        return isInteger(aKey)
            ? expectedField
            : aKey;
    }
    
    // Return debug info
    Json[string] debugInfo() {
        return [
            "fields": this.fields,
            "unlockedFields": this.unlockedFields,
            "debugMessage": this.debugMessage,
        ];
    }
}
