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
    bool validate(Json formData, string aurl, string asessionId) {
        this.debugMessage = null;

        auto extractedToken = this.extractToken(formData);
        if (isEmpty(extractedToken)) {
            return false;
        }
        auto hashParts = this.extractHashParts(formData);
        auto generatedToken = this.generateHash(
            hashParts["fields"],
            hashParts["unlockedFields"],
            url,
            sessionId
        );

        if (hash_equals(generatedToken, extractedToken)) {
            return true;
        }
        if (configuration.get("debug")) {
            debugMessage = this.debugTokenNotMatching(formData, hashParts + compact("url", "sessionId"));
            if (debugMessage) {
                this.debugMessage = debugMessage;
            }
        }
        return false;
    }
    
    /**
     * Construct.
     * Params:
     * Json[string] someData Data array, can contain key `unlockedFields` with list of unlocked fields.
     */
    this(Json[string] data = []) {
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
            if (!in_array(field, this.fields, true)) {
                if (aValue !is null) {
                    this.fields[field] = aValue;

                    return this;
                }
                if (isSet(this.fields[field])) {
                    unset(this.fields[field]);
                }
                this.fields ~= field;
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
        if (!attributeName.has("[")) {
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
        if (!in_array(name, this.unlockedFields, true)) {
            this.unlockedFields ~= fieldName;
        }
         anIndex = array_search(fieldName, this.fields, true);
        if (anIndex != false) {
            unset(this.fields[anIndex]);
        }
        unset(this.fields[fieldName]);

        return this;
    }
    

    
    /**
     * Extract token from data.
     * Params:
     * Json formData Data to validate.
     */
    protected string extractToken(Json formData) {
        if (!isArray(formData)) {
            this.debugMessage = "Request data is not an array.";

            return null;
        }
        
        string message = "`%s` was not found in request data.";
        if (!isSet(formData"_Token"])) {
            this.debugMessage = message.format("_Token");

            return null;
        }
        if (!formData["_Token"].hasKey("fields")) {
            this.debugMessage = message.format("_Token.fields");

            return null;
        }
        if (!isString(formData["_Token.fields"])) {
            this.debugMessage = "`_Token.fields` is invalid.";

            return null;
        }
        if (!isSet(formData["_Token.unlocked"])) {
            this.debugMessage = message.format("_Token.unlocked");

            return null;
        }
        if (configuration.get("debug") && !isSet(formData["_Token.debug"])) {
            this.debugMessage = message.format("_Token.debug");

            return null;
        }
        if (!configuration.hasKey("debug") && isSet(formData["_Token.debug"])) {
            this.debugMessage = "Unexpected `_Token.debug` found in request data";

            return null;
        }
        token = urldecode(formData["_Token.fields"]);
        if (token.has(": ")) {
            [token, ] = split(": ", token, 2);
        }
        return token;
    }
    
    /**
     * Return hash parts for the token generation
     */
    protected Json[string] extractHashParts(Json[string] formData) {
        auti fields = this.extractFields(formData);
        unlockedFields = this.sortedUnlockedFields(formData);

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
        auto token = urldecode(formData["_Token.fields"]);
        auto unlocked = urldecode(formData["_Token.unlocked"]);

        if (token.has(": ")) {
            [, locked] = split(": ", token, 2);
        }
        unset(formData["_Token"]);

        locked = locked ? locked.split("|") : null;
        unlocked = unlocked ? split("|", unlocked): [];

        fields = Hash.flatten(formData);
        fieldList = fields.keys;
        multi = lockedFields = null;
         isUnlocked = false;

        foreach (fieldList as  anI: aKey) {
            if (isString(aKey) && preg_match("/(\.\d+){1,10}/", aKey)) {
                multi[anI] = preg_replace("/(\.\d+){1,10}/", "", aKey);
                unset(fieldList[anI]);
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
             isLocked = in_array(aKey, locked, true);

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
                unset(fieldList[anI]);
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
        if (unlocked.isEmpty) {
            return null;
        }
        
        return unlocked.split("|").sort(SORT_STRING);
    }
    
    /**
     * Generate the token data.
     * Params:
     * string aurl Form URL.
     * @param string asessionId Session Id.
     */
    STRINGAA buildTokenData(string aurl = "", string asessionId= null) {
        auto fields = this.fields;
        auto unlockedFields = this.unlockedFields;

        auto locked = null;
        fields.byKeyValue
            .each!((kv) {
                if (isNumeric(kv.value)) {
                    kv.value = /* (string) */kv.value;
                }
                if (!isInt(kv.key)) {
                    locked[kv.key] = kv.value;
                    unset(fields[kv.key]);
                }
            });
        sort(unlockedFields, SORT_STRING);
        sort(fields, SORT_STRING);
        ksort(locked, SORT_STRING);
        fields += locked;

        fields = this.generateHash(fields, unlockedFields, url, sessionId);
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
        if (!isSet(formData["_Token.debug"])) {
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

        return join(", ", messages);
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
        array someDataFields,
        array expectedFields = [],
        string aintKeyMessage = "",
        string astringKeyMessage = "",
        string amissingMessage = ""
    ) {
        messages = this.matchExistingFields(someDataFields, expectedFields,  anIntKeyMessage, stringKeyMessage);
        expectedFieldsMessage = this.debugExpectedFields(expectedFields, missingMessage);
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
        messages = null;
        foreach (someDataFields as aKey: aValue) {
            if (isInt(aKey)) {
                foundKey = array_search(aValue, expectedFields, true);
                if (foundKey == false) {
                    messages ~= anIntKeyMessage.format(aValue);
                } else {
                    unset(expectedFields[foundKey]);
                }
            } else {
                if (isSet(expectedFields[aKey]) && aValue != expectedFields[aKey]) {
                    messages ~= stringKeyMessage
                    .format(aKey, expectedFields[aKey], aValue);
                }
                unset(expectedFields[aKey]);
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
    protected string debugExpectedFields(Json[string] expectedFields = [], string amissingMessage= null) {
        if (count(expectedFields) == 0) {
            return null;
        }
        expectedFieldNames = expectedFields
            .map!(kv, debugExpectedField(kv.key, kv.value))
            .array;

        return missingMessage.format(join(", ", expectedFieldNames));
    }
    protected string debugExpectedField(aKey, expectedField) {
        return isInt(aKey)
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
