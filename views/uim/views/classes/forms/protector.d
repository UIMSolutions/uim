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
    
    // Fields list.
    protected Json[string] _fields = null;

    // Validate submitted form data.
    bool validate(Json formData, string formUrl, string sessionId) {
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
    
    this(Json[string] initData = null) {
        if (!initData.isEmpty("unlockedFields")) {
            _unlockedFields = initData["unlockedFields"];
        }
    }
    
    /**
     * Determine which fields of a form should be used for hash.
     * Params:
     * string[]|string fieldName Reference to field to be secured. Can be dot
     * separated string to indicate nesting or array of fieldname parts.
     */
    auto addField(string[] afield, bool shouldLock = true, Json value = null) {
        if (isString(field)) {
            field = getFieldNameParts(field);
        }
        if (isEmpty(field)) {
            return this;
        }
        foreach (unlockField; _unlockedFields) {
            string[] unlockParts = unlockField.split(".");
            if (array_values(array_intersect(field, unlockParts)) == unlockParts) {
                return this;
            }
        }
        field = field.join(".");
        field = to!string(preg_replace("/(\.\d+)+/", "", field));

        if (shouldLock) {
            if (!isIn(field, this.fields, true)) {
                if (value !is null) {
                    _fields[field] = value;

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
    protected string[] getFieldNameParts(string name) {
        if (name != "0") {
            return null;
        }

        if (!name.contains("[")) {
            return name.split(".");
        }
        
        string[] parts = name.split("[").stripText("]", " ");

        return Hash.filter(parts, "strlen");
    }
    
    /**
     * Add to the list of fields that are currently unlocked.
     *
     * Unlocked fields are not included in the field hash.
     */
    auto unlockField(string fieldName) { // fieldName - dot separated name
        if (!isIn(name, _unlockedFields, true)) {
            _unlockedFields ~= fieldName;
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

        foreach (index: aKey; fieldList) {
            if (isString(aKey) && preg_match("/(\.\d+){1,10}/", aKey)) {
                multi[index] = preg_replace("/(\.\d+){1,10}/", "", aKey);
                remove(fieldList[index]);
            } else {
                fieldList[index] = /* (string) */aKey;
            }
        }
        if (!multi.isEmpty) {
            fieldList += array_unique(multi);
        }
        unlockedFields = array_unique(
            chain(
                _unlockedFields,
                unlocked
           )
       );

        /** @var string aKey */
        foreach (index: aKey; fieldList) {
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
                remove(fieldList[index]);
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
    
    // Generate the token data.
    STRINGAA buildTokenData(string url = "", string sessionId = null) {
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
                _unlockedFields,
            ])),
        ];
    }
    
    // Generate validation hash.
    protected string generateHash(string[] fieldNames, Json[string] unlockedFields, string url, string sessionId) {
        hashParts = [
            url,
            serialize(fieldNames),
            unlockedFields.join("|"),
            sessionId,
        ];

        return hash_hmac("sha1", hashParts.join(""), Security.getSalt());
    }
    
    // Create a message for humans to understand why Security token is not matching
    protected string debugTokenNotMatching(Json[string] formData, Json[string] hashParts) {
        auto messages = null;
        if (formData.isNull("_Token.debug")) {
            return "Form protection debug token not found.";
        }
        
        auto expectedParts = Json_decode(urldecode(formData["_Token.debug"]), true);
        if (!isArray(expectedParts) || count(expectedParts) != 3) {
            return "Invalid form protection debug token.";
        }
        
        auto expectedUrl = Hash.get(expectedParts, 0);
        auto url = Hash.get(hashParts, "url");
        if (expectedUrl != url) {
            messages ~= "URL mismatch in POST data (expected `%s` but found `%s`)"
                .format(expectedUrl, url);
        }
        auto expectedFields = Hash.get(expectedParts, 1);
        auto dataFields = Hash.get(hashParts, "fields") ?: [];
        auto fieldsMessages = this.debugCheckFields(
            (array)dataFields,
            expectedFields,
            "Unexpected field `%s` in POST data",
            "Tampered field `%s` in POST data (expected value `%s` but found `%s`)",
            "Missing field `%s` in POST data"
       );
        auto expectedUnlockedFields = Hash.get(expectedParts, 2);
        auto someDataUnlockedFields = Hash.get(hashParts, "unlockedFields") ?: [];
        auto unlockFieldsMessages = this.debugCheckFields(
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
     * Json[string] dataFields Fields array, containing the POST data fields
     * data fields indexed by string (protected).
     */
    protected string[] debugCheckFields(
        Json[string] dataFields,
        Json[string] expectedFields = null,
        string intKeyMessage = "",
        string stringKeyMessage = "",
        string missingMessage = ""
   ) {
        auto messages = matchExistingFields(dataFields, expectedFields,  anIntKeyMessage, stringKeyMessage);
        auto expectedFieldsMessage = this.debugExpectedFields(expectedFields, missingMessage);
        if (!expectedFieldsMessage.isNull) {
            messages ~= expectedFieldsMessage;
        }
        return messages;
    }
    
    // Generate array of messages for the existing fields in POST data, matching dataFields in expectedFields will be unset
    protected string[] matchExistingFields(
        Json[string] dataFields,
        Json[string] expectedFields,
        string intKeyMessage,
        string stringKeyMessage
   ) {
        string[] messages = null;
        dataFields.byKeyValue.each!((kv) {
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
        });
        return messages;
    }
    
    // Generate debug message for the expected fields
    protected string debugExpectedFields(Json[string] expectedFields= null, string missingMessage= null) {
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
            "unlockedFields": _unlockedFields,
            "debugMessage": this.debugMessage,
        ];
    }
}
