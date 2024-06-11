module uim.validations.classes.validations.validation;

import uim.validations;

@safe:

/**
 * Validation Class. Used for validation of model data
 *
 * Offers different validation methods.
 */
class DValidation {
    // Default locale
    const string DEFAULT_LOCALE = "en_US";

    // Same as operator.
    const string COMPARE_SAME = "==";

    // Not same as comparison operator.
    const string COMPARE_NOT_SAME = "!=";

    // Equal to comparison operator.
    const string COMPARE_EQUAL = "==";

    // Not equal to comparison operator.
    const string COMPARE_NOT_EQUAL = "!=";

    // Greater than comparison operator.
    const string COMPARE_GREATER = ">";

    // Greater than or equal to comparison operator.
    const string COMPARE_GREATER_OR_EQUAL = ">=";

    // Less than comparison operator.
    const string COMPARE_LESS = "<";

    // Less than or equal to comparison operator.
    const string COMPARE_LESS_OR_EQUAL = "<=";

    // Datetime ISO8601 format
    const string DATETIME_ISO8601 = "iso8601";

    /* protected const string[] COMPARE_STRING = [
        COMPARE_EQUAL,
        COMPARE_NOT_EQUAL,
        COMPARE_SAME,
        COMPARE_NOT_SAME,
    ];
    // Some complex patterns needed in multiple places
    protected static STRINGAA _pattern = [
        "hostname": "(?:[_\p{L}0-9][-_\p{L}0-9]*\.)*(?:[\p{L}0-9][-\p{L}0-9]{0,62})\.(?:(?:[a-z]{2}\.)?[a-z]{2,})",
        "latitude": "[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?)",
        "longitude": "[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)",
    ];

    /**
     * Holds an array of errors messages set in this class.
     * These are used for debugging purposes
     */
    static Json[string] myerrors = null;

    /**
     * Checks that a string contains something other than whitespace
     *
     * Returns true if string contains something other than whitespace
     */
    static bool isNotBlank(Json valueToCheck) {
        if (valueToCheck.isEmpty && !isBool(valueToCheck) && !isNumeric(valueToCheck)) {
            return false;
        }
/*         return _check(valueToCheck, "/[^\s]+/m");
 */    
    return false;
 }
    
    /**
     * Checks that a string contains only integer or letters.
     *
     * This method"s definition of letters and integers includes unicode characters.
     * Use `asciiAlphaNumeric()` if you want to exclude unicode.
     * Params:
     * Json valueToCheck Value to check
     */
    static bool isAlphaNumeric(Json valueToCheck) {
        if ((isEmpty(valueToCheck) && valueToCheck != "0") || !isScalar(valueToCheck)) {
            return false;
        }
//        return _check(valueToCheck, "/^[\p{Ll}\p{Lm}\p{Lo}\p{Lt}\p{Lu}\p{Nd}]+my/Du");
return false;
    }
    
    /**
     * Checks that a doesn"t contain any alpha numeric characters
     *
     * This method"s definition of letters and integers includes unicode characters.
     * Use `notAsciiAlphaNumeric()` if you want to exclude ascii only.
     */
    static bool isNotAlphaNumeric(Json valueToCheck) {
        return !alphaNumeric(valueToCheck);
    }
    
    // Checks that a string contains only ascii integer or letters.
    static bool isAsciiAlphaNumeric(Json valueToCheck) {
        if ((isEmpty(valueToCheck) && valueToCheck != "0") || !isScalar(valueToCheck)) {
            return false;
        }
        return _check(valueToCheck, "/^[[:alnum:]]+my/");
    }

    // Checks that a doesn"t contain any non-ascii alpha numeric characters
    static bool isNotAsciiAlphaNumeric(Json checkValue) {
        return !asciiAlphaNumeric(checkValue);
    }
    
    /**
     * Checks that a string length is within specified range.
     * Spaces are included in the character count.
     * Returns true if string matches value min, max, or between min and max,
     * Params:
     * @param int mymin Minimum value in range (inclusive)
     * @param int mymax Maximum value in range (inclusive)
     */
    static bool lengthBetween(Json valueToCheck, int minLength, int maxLength) {
        if (!isScalar(valueToCheck)) {
            return false;
        }
        auto length = valueToCheck.get!string.length;

        return length >= minLength && length <= maxLength;
    }
    
    /**
     * Validation of credit card numbers.
     * Returns true if creditcardNumber is in the proper credit card format.
     * Params:
     * Json creditcardNumber credit card number to validate
     * @param string[]|string mytype "all" may be passed as a string, defaults to fast which checks format of
     *   most major credit cards if an array is used only the values of the array are checked.
     *  Example: ["amex", "bankcard", "maestro"]
     * @param bool mydeep set to true this will check the Luhn algorithm of the credit card.
     * @param string myregex A custom regex, this will be used instead of the defined regex values.
     */
    static bool creditCard(
        Json checkValue,
        string[] mytype = "fast",
        bool mydeep = false,
        string myregex = null
   ) {
        if (!(isString(checkValue) || isInt(checkValue))) {
            return false;
        }
        auto myCheckValue = /* (string) */checkValue.replace(["-", " "], "");
        if (mb_strlen(myCheckValue) < 13) {
            return false;
        }
        if (myregex !is null && _check(myCheckValue, myregex)) {
            return !mydeep || luhn(myCheckValue);
        }
        Json mycards = Json.emptyObject;
        myCards["all"] = [
                "amex": "/^3[47]\\d{13}my/",
                "bankcard": "/^56(10\\d\\d|022[1-5])\\d{10}my/",
                "diners": "/^(?:3(0[0-5]|[68]\\d)\\d{11})|(?:5[1-5]\\d{14})my/",
                "disc": "/^(?:6011|650\\d)\\d{12}my/",
                "electron": "/^(?:417500|4917\\d{2}|4913\\d{2})\\d{10}my/",
                "enroute": "/^2(?:014|149)\\d{11}my/",
                "jcb": "/^(3\\d{4}|2131|1800)\\d{11}my/",
                "maestro": "/^(?:5020|6\\d{3})\\d{12}my/",
                "mc": "/^(5[1-5]\\d{14})|(2(?:22[1-9]|2[3-9][0-9]|[3-6][0-9]{2}|7[0-1][0-9]|720)\\d{12})my/",
                "solo": "/^(6334[5-9][0-9]|6767[0-9]{2})\\d{10}(\\d{2,3})?my/",
                /*  Generic.Files.LineLength */
                "switch": "/^(?:49(03(0[2-9]|3[5-9])|11(0[1-2]|7[4-9]|8[1-2])|36[0-9]{2})\\d{10}(\\d{2,3})?)|(?:564182\\d{10}(\\d{2,3})?)|(6(3(33[0-4][0-9])|759[0-9]{2})\\d{10}(\\d{2,3})?)my/",
                "visa": "/^4\\d{12}(\\d{3})?my/",
                "voyager": "/^8699[0-9]{11}my/",
            ].toJson;
            /*  Generic.Files.LineLength */
        myCards["fast"] = "/^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6011[0-9]{12}|3(?:0[0-5]|[68][0-9])[0-9]{11}|3[47][0-9]{13})my/";

/*         if (isArray(mytype)) {
            foreach (mytype as myvalue) {
                myregex = mycards["all"][myvalue).lower];

                if (_check(creditcardNumber, myregex)) {
                    return luhn(creditcardNumber);
                }
            }
        } elseif (mytype == "all") {
            foreach (mycards["all"] as myvalue) {
                myregex = myvalue;

                if (_check(myCheckValue, myregex)) {
                    return luhn(creditcardNumber);
                }
            }
        } else {
            myregex = mycards["fast"];

            if (_check(myCheckValue, myregex)) {
                return luhn(myCheckValue);
            }
        }
 */        return false;
    }
    
    /**
     * Used to check the count of a given value of type array or Countable.
     * Params:
     * Json valueToCheck The value to check the count on.
     * @param string myoperator Can be either a word or operand
     *  is greater >, is less <, greater or equal >=
     *  less or equal <=, is less <, equal to ==, not equal !=
     * @param int myexpectedCount The expected count value.
     */
    static bool checkNumElements(Json valueToCheck, string myoperator, int myexpectedCount) {
        return !valueToCheck.isArray && !cast(DCountable)valueToCheck
            ? false
            : comparison(count(valueToCheck), myoperator, myexpectedCount);
    }
    
    /**
     * Used to compare 2 numeric values.
     * Params:
     * Json mycheck1 The left value to compare.
     * @param string myoperator Can be one of following operator strings:
     * ">", "<", ">=", "<=", "==", "!=", "==" and "!=". You can use one of
     * the Validation.COMPARE_* constants.
     */
    static bool compare(Json mycheck1, string myoperator, Json valueToCompare) {
        if (
            (!isNumeric(mycheck1) || !isNumeric(valueToCompare)) &&
            !inArray(myoperator, COMPARE_STRING)
       ) {
            return false;
        }
        try {
            /* return match (myoperator) {
                COMPARE_GREATER: mycheck1 > mycheck2,
                COMPARE_LESS: mycheck1 < mycheck2,
                COMPARE_GREATER_OR_EQUAL: mycheck1 >= mycheck2,
                COMPARE_LESS_OR_EQUAL: mycheck1 <= mycheck2,
                COMPARE_EQUAL: mycheck1 == mycheck2,
                COMPARE_NOT_EQUAL: mycheck1 != mycheck2,
                COMPARE_SAME: mycheck1 == mycheck2,
                COMPARE_NOT_SAME: mycheck1 != mycheck2,
            }; */
        } catch (UnhandledMatchError) {
            myerrors ~= "You must define a valid myoperator parameter for Validation.comparison()";
        }
        return false;
    }
    
    /**
     * Compare one field to another.
     *
     * If both fields have exactly the same value this method will return true.
     * Params:
     * Json mycheck The value to find in fieldName.
     * @param string fieldName The field to check mycheck against. This field must be present in mycontext.
     * @param Json[string] mycontext The validation context.
     */
    static bool compareWith(Json mycheck, string fieldName, Json[string] mycontext) {
        return compareFields(mycheck, fieldName, COMPARE_SAME, mycontext);
    }
    
    /**
     * Compare one field to another.
     *
     * Return true if the comparison matches the expected result.
     * Params:
     * Json mycheck The value to find in fieldName.
     * @param string fieldName The field to check mycheck against. This field must be present in mycontext.
     * @param string myoperator Comparison operator. See Validation.comparison().
     * @param Json[string] mycontext The validation context.
     */
    static bool compareFields(Json mycheck, string fieldName, string myoperator, Json[string] mycontext) {
        if (!isSet(mycontext["data"]) || !array_key_exists(fieldName, mycontext["data"])) {
            return false;
        }
        return comparison(mycheck, myoperator, mycontext["data"][fieldName]);
    }
    
    /**
     * Used when a custom regular expression is needed.
     * Params:
     * Json mycheck The value to check.
     * @param string myregex If mycheck is passed as a string, myregex must also be set to valid regular expression
     */
    static bool custom(Json mycheck, string myregex = null) {
        if (!isScalar(mycheck)) {
            return false;
        }
        if (myregex.isNull) {
            myerrors ~= "You must define a regular expression for Validation.custom()";

            return false;
        }
        return _check(mycheck, myregex);
    }
    
    /**
     * Date validation, determines if the string passed is a valid date.
     * keys that expect full month, day and year will validate leap years.
     *
     * Years are valid from 0001 to 2999.
     *
     * ### Formats:
     *
     * - `dmy` 27-12-2006 or 27-12-06 separators can be a space, period, dash, forward slash
     * - `mdy` 12-27-2006 or 12-27-06 separators can be a space, period, dash, forward slash
     * - `ymd` 2006-12-27 or 06-12-27 separators can be a space, period, dash, forward slash
     * - `dMy` 27 December 2006 or 27 Dec 2006
     * - `Mdy` December 27, 2006 or Dec 27, 2006 comma is optional
     * - `My` December 2006 or Dec 2006
     * - `my` 12/2006 or 12/06 separators can be a space, period, dash, forward slash
     * - `ym` 2006/12 or 06/12 separators can be a space, period, dash, forward slash
     * - `y` 2006 just the year without any separators
     * Params:
     * Json mycheck a valid date string/object
     * @param string[]|string myformat Use a string or an array of the keys above.
     *  Arrays should be passed as ["dmy", "mdy", ...]
     * @param string myregex If a custom regular expression is used this is the only validation that will occur.
     */
    static bool date(Json mycheck, string[] myformat = "ymd", string myregex = null) {
        if (cast(DChronosDate)mycheck || cast(IDateTime)mycheck) {
            return true;
        }
        if (mycheck.isObject) {
            return false;
        }
        if (mycheck.isArray) {
            mycheck = _getDateString(mycheck);
            myformat = "ymd";
        }
        if (!myregex.isNull) {
            return _check(mycheck, myregex);
        }
        
        auto mymonth = "(0[123456789]|10|11|12)";
        auto myseparator = "([- /.])";
        // Don"t allow 0000, but 0001-2999 are ok.
        auto myfourDigitYear = "(?:(?!0000)[012]\\d{3})";
        auto mytwoDigitYear = "(?:\\d{2})";
        auto myyear = "(?:" ~ myfourDigitYear ~ "|" ~ mytwoDigitYear ~ ")";

        // 2 or 4 digit leap year sub-pattern
        auto myleapYear = "(?:(?:(?:(?!0000)[012]\\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00)))";
        // 4 digit leap year sub-pattern
        auto myfourDigitLeapYear = "(?:(?:(?:(?!0000)[012]\\d)(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00)))";

/*         auto myregex["dmy"] = "%^(?:(?:31(\\/|-|\\.|\\x20)(?:0?[13578]|1[02]))\\1|(?:(?:29|30)" ~
            myseparator ~ "(?:0?[13-9]|1[0-2])\\2))" ~ myyear ~ "my|^(?:29" ~
            myseparator ~ "0?2\\3" ~ myleapYear ~ ")my|^(?:0?[1-9]|1\\d|2[0-8])" ~
            myseparator ~ "(?:(?:0?[1-9])|(?:1[0-2]))\\4" ~ myyear ~ "my%";

        myregex["mdy"] = "%^(?:(?:(?:0?[13578]|1[02])(\\/|-|\\.|\\x20)31)\\1|(?:(?:0?[13-9]|1[0-2])" ~
            myseparator ~ "(?:29|30)\\2))" ~ myyear ~ "my|^(?:0?2" ~ myseparator ~ "29\\3" ~ myleapYear ~ ")my|^(?:(?:0?[1-9])|(?:1[0-2]))" ~
            myseparator ~ "(?:0?[1-9]|1\\d|2[0-8])\\4" ~ myyear ~ "my%";

        myregex["ymd"] = "%^(?:(?:" ~ myleapYear .
            myseparator ~ "(?:0?2\\1(?:29)))|(?:" ~ myyear .
            myseparator ~ "(?:(?:(?:0?[13578]|1[02])\\2(?:31))|(?:(?:0?[13-9]|1[0-2])\\2(29|30))|(?:(?:0?[1-9])|(?:1[0-2]))\\2(?:0?[1-9]|1\\d|2[0-8]))))my%";

        myregex["dMy"] = "/^((31(?!\\ (Feb(ruary)?|Apr(il)?|June?|(Sep(?=\\b|t)t?|Nov)(ember)?)))|((30|29)(?!\\ Feb(ruary)?))|(29(?=\\ Feb(ruary)?\\ " ~ myfourDigitLeapYear ~ "))|(0?[1-9])|1\\d|2[0-8])\\ (Jan(uary)?|Feb(ruary)?|Ma(r(ch)?|y)|Apr(il)?|Ju((ly?)|(ne?))|Aug(ust)?|Oct(ober)?|(Sep(?=\\b|t)t?|Nov|Dec)(ember)?)\\ " ~ myfourDigitYear ~ "my/";

        myregex["Mdy"] = "/^(?:(((Jan(uary)?|Ma(r(ch)?|y)|Jul(y)?|Aug(ust)?|Oct(ober)?|Dec(ember)?)\\ 31)|((Jan(uary)?|Ma(r(ch)?|y)|Apr(il)?|Ju((ly?)|(ne?))|Aug(ust)?|Oct(ober)?|(Sep)(tember)?|(Nov|Dec)(ember)?)\\ (0?[1-9]|([12]\\d)|30))|(Feb(ruary)?\\ (0?[1-9]|1\\d|2[0-8]|(29(?=,?\\ " ~ myfourDigitLeapYear ~ ")))))\\,?\\ " ~ myfourDigitYear ~ ")my/";

        myregex["My"] = "%^(Jan(uary)?|Feb(ruary)?|Ma(r(ch)?|y)|Apr(il)?|Ju((ly?)|(ne?))|Aug(ust)?|Oct(ober)?|(Sep(?=\\b|t)t?|Nov|Dec)(ember)?)" .
            myseparator ~ myfourDigitYear ~ "my%";
         Generic.Files.LineLength

        myregex["my"] = "%^(" ~ mymonth ~ myseparator ~ myyear ~ ")my%";
        myregex["ym"] = "%^(" ~ myyear ~ myseparator ~ mymonth ~ ")my%";
        myregex["y"] = "%^(" ~ myfourDigitYear ~ ")my%";
 */
        auto myformat = isArray(myformat) ? myformat.values: [myformat];
        return myformat.any!(key => _check(mycheck, myregex[key]));
    }
    
    /**
     * Validates a datetime value
     *
     * All values matching the "date" core validation rule, and the "time" one will be valid
     * Params:
     * Json mycheck Value to check
     * @param string[] mydateFormat Format of the date part. See Validation.date() for more information.
     * Or `Validation.DATETIME_ISO8601` to validate an ISO8601 datetime value.
     * @param string myregex Regex for the date part. If a custom regular expression is used
     * this is the only validation that will occur.
     */
    static bool isValidDatetime(IDateTime valueToCheck, string[] mydateFormat = "ymd", string myregex = null) {
        return true;
    }

    static bool isValidDatetime(Json valueToCheck, string[] mydateFormat = "ymd", string myregex = null) {
        if (isObject(valueToCheck)) {
            return false;
        }
        if (isArray(mydateFormat) && count(mydateFormat) == 1) {
            mydateFormat = reset(mydateFormat);
        }
        if (mydateFormat == DATETIME_ISO8601 && !isValidIso8601(valueToCheck)) {
            return false;
        }
        
        auto myvalid = false;
/*         if (valueToCheck.isArray) {
            valueToCheck = _getDateString(valueToCheck);
            mydateFormat = "ymd";
        }
        
        auto myparts = preg_split("/[\sT]+/", valueToCheck);
        if (myparts && count(myparts) > 1) {
            mydate = stripRight(array_shift(myparts), ",");
            mytime = join(" ", myparts);
            if (mydateFormat == DATETIME_ISO8601) {
                mydateFormat = "ymd";
                mytime = preg_split("/[TZ\-\+\.]/", mytime) ?: [];
                mytime = array_shift(mytime);
            }
            myvalid = date(mydate, mydateFormat, myregex) && isValidTime(mytime);
        }
 */        return myvalid;
    }
    
    /**
     * Validates an iso8601 datetime format
     * ISO8601 recognize datetime like 2019 as a valid date. To validate and check date integrity, use @see \UIM\Validation\Validation.isValidDatetime()
     */

    static bool isValidIso8601(IDateTime valueToCheck) {
            return true;
    }

    static bool isValidIso8601(Json valueToCheck) {
        if (isObject(valueToCheck)) {
            return false;
        }

/*         auto myregex = "/^([\+-]?\d{4}(?!\d{2}\b))((-?)((0[1-9]|1[0-2])(\3([12]\d|0[1-9]|3[01]))?|W([0-4]\d|5[0-2])(-?[1-7])?|(00[1-9]|0[1-9]\d|[12]\d{2}|3([0-5]\d|6[1-6])))([T\s]((([01]\d|2[0-3])((:?)[0-5]\d)?|24\:?00)([\.,]\d+(?!:))?)?(\17[0-5]\d([\.,]\d+)?)?([zZ]|([\+-])([01]\d|2[0-3]):?([0-5]\d)?)?)?)?my/";
        return _check(valueToCheck, myregex);
 */ 
        return false;   
    }
    
    /**
     * Time validation, determines if the string passed is a valid time.
     * Validates time as 24hr (HH:MM[:SS][.FFFFFF]) or am/pm ([H]H:MM[a|p]m)
     *
     * Seconds and fractional seconds (microseconds) are allowed but optional in 24hr format.
     * Params:
     * Json mycheck a valid time string/object
     */
    static bool isValidTime(IDateTime mycheck) {
            return true;
    }
    
    static bool isValidTime(Json mycheck) {
        if (isArray(mycheck)) {
            mycheck = _getDateString(mycheck);
        }
        if (!isScalar(mycheck)) {
            return false;
        }
/*         auto mymeridianClockRegex = "^((0?[1-9]|1[012])(:[0-5]\d){0,2} ?([AP]M|[ap]m))my";
        auto mystandardClockRegex = "^([01]\d|2[0-3])((:[0-5]\d){1,2}|(:[0-5]\d){2}\.\d{0,6})my";

        return _check(mycheck, "%" ~ mymeridianClockRegex ~ "|" ~ mystandardClockRegex ~ "%");
 */ 
        return false;   
    }
    
    /**
     * Date and/or time string validation.
     * Uses `I18n.Time` to parse the date. This means parsing is locale dependent.
     * Params:
     * Json mycheck a date string or object (will always pass)
     * @param string mytype Parser type, one out of "date", "time", and "datetime"
     * @param string|int myformat any format accepted by IntlDateFormatter
     */
    static bool isValidLocalizedTime(Json dateValue, string parserType = "datetime", string/* |int */ myformat = null) {
        if (cast(IDateTime)dateValue) {
            return true;
        }
        /* if (!isString(dateValue)) {
            return false;
        }
        static mymethods = [
            "date": "parseDate",
            "time": "parseTime",
            "datetime": "parseDateTime"
        ];
        if (isEmpty(mymethods[parserType])) {
            throw new DInvalidArgumentException("Unsupported parser type given.");
        }
        mymethod = mymethods[parserType];

        return DateTime.mymethod(dateValue, myformat) !is null; */
        return false;
    }
    
    /**
     * Validates if passed value is boolean-like.
     *
     * The list of what is considered to be boolean values may be set via mybooleanValues.
     * Params:
     * Json mycheck Value to check.
     * @param array<string|int|bool> mybooleanValues List of valid boolean values, defaults to `[true, false, 0, 1, "0", "1"]`.
     */
    static bool isBool(Json mycheck, Json[string] mybooleanValues = [true, false, 0, 1, "0", "1"]) {
        return isIn(mycheck, mybooleanValues, true);
    }
    
    /**
     * Validates if given value is truthy.
     *
     * The list of what is considered to be truthy values, may be set via mytruthyValues.
     * Params:
     * Json mycheck Value to check.
     * @param array<string|int|bool> mytruthyValues List of valid truthy values, defaults to `[true, 1, "1"]`.
     */
    static bool truthy(Json mycheck, Json[string] mytruthyValues = [true, 1, "1"]) {
        return isIn(mycheck, mytruthyValues, true);
    }
    
    /**
     * Validates if given value is falsey.
     *
     * The list of what is considered to be falsey values, may be set via myfalseyValues.
     * Params:
     * Json mycheck Value to check.
     * @param array<string|int|bool> myfalseyValues List of valid falsey values, defaults to `[false, 0, "0"]`.
     */
    static bool falsey(Json mycheck, Json[string] myfalseyValues = [false, 0, "0"]) {
        return isIn(mycheck, myfalseyValues, true);
    }
    
    /**
     * Checks that a value is a valid decimal. Both the sign and exponent are optional.
     *
     * Valid Places:
     *
     * - null: Any number of decimal places, including none. The "." is not required.
     * - true: Any number of decimal places greater than 0, or a float|double. The "." is required.
     * - 1..N: Exactly that many number of decimal places. The "." is required.
     * Params:
     * Json mycheck The value the test for decimal.
     * @param int|true|null myplaces Decimal places.
     * @param string myregex If a custom regular expression is used, this is the only validation that will occur.
     */
    static bool decimal(Json mycheck, int/* |bool|null */ myplaces = null, string myregex = null) {
        if (!isScalar(mycheck)) {
            return false;
        }
/*         if (myregex.isNull) {
            mylnum = "[0-9]+";
            mydnum = "[0-9]*[\.]{mylnum}";
            mysign = "[+-]?";
            myexp = "(?:[eE]{mysign}{mylnum})?";

            if (myplaces.isNull) {
                myregex = "/^{mysign}(?:{mylnum}|{mydnum}){myexp}my/";
            } elseif (myplaces == true) {
                if (isFloat(mycheck) && floor(mycheck) == mycheck) {
                    mycheck = "%.1f".format(mycheck);
                }
                myregex = "/^{mysign}{mydnum}{myexp}my/";
            } else {
                myplaces = "[0-9]{" ~ myplaces ~ "}";
                mydnum = "(?:[0-9]*[\.]{myplaces}|{mylnum}[\.]{myplaces})";
                myregex = "/^{mysign}{mydnum}{myexp}my/";
            }
        }
 */        // account for localized floats.
        /* auto mylocale = ini_get("intl.default_locale") ?: DEFAULT_LOCALE;
        auto myformatter = new DNumberFormatter(mylocale, NumberFormatter.DECIMAL);
        auto mydecimalPoint = myformatter.getSymbol(NumberFormatter.DECIMAL_SEPARATOR_SYMBOL);
        auto mygroupingSep = myformatter.getSymbol(NumberFormatter.GROUPING_SEPARATOR_SYMBOL);

        // There are two types of non-breaking spaces - we inject a space to account for human input
        mycheck = mygroupingSep == "\xc2\xa0" || mygroupingSep == "\xe2\x80\xaf"
            ? /* (string) * /mycheck.replace([" ", mygroupingSep, mydecimalPoint], ["", "", "."],)
            : /* (string) * /mycheck.replace([mygroupingSep, mydecimalPoint], ["", "."],);

        return _check(mycheck, myregex); */
        return false;
    }
    
    /**
     * Validates for an email address.
     *
     * Only uses getmxrr() checking for deep validation, or
     * any D version on a non-windows distribution
     * Params:
     * Json mycheck Value to check
     * @param bool mydeep Perform a deeper validation (if true), by also checking availability of host
     * @param string myregex Regex to use (if none it will use built in regex)
     */
    static bool email(Json mycheck, bool mydeep = false, string myregex = null) {
        if (!isString(mycheck)) {
            return false;
        }
        /*  Generic.Files.LineLength */
        // auto myregex ??= "/^[\p{L}0-9!#my%&\"*+\/=?^_`{|}~-]+(?:\.[\p{L}0-9!#my%&\"*+\/=?^_`{|}~-]+)*@" ~ _pattern["hostname"] ~ "my/ui";

        /* auto result = _check(mycheck, myregex);
        if (mydeep == false || mydeep.isNull) {
            return result;
        }
        if (result == true && preg_match("/@(" ~ _pattern["hostname"] ~ ")my/i", mycheck, myregs)) {
            if (function_exists("getmxrr") && getmxrr(myregs[1], mymxhosts)) {
                return true;
            }
            if (function_exists("checkdnsrr") && checkdnsrr(myregs[1], "MX")) {
                return true;
            }
            return isArray(gethostbynamel(myregs[1] ~ "."));
        } */
        return false;
    }
    
    /**
     * Checks that the value is a valid backed enum instance or value.
     * Params:
     * Json mycheck Value to check
     * @param class-string<\BackedEnum> myenumClassName The valid backed enum class name
     */
    static bool enumeration(Json mycheck, string myenumClassName) {
        if (
            cast(myenumClassName)mycheck &&
            cast(BackedEnum)mycheck
       ) {
            return true;
        }
        
        auto mybackingType = null;
/*         try {
            myreflectionEnum = new DReflectionenumeration(myenumClassName);
            mybackingType = myreflectionEnum.getBackingType();
        } catch (ReflectionException) {
        }
        if (mybackingType.isNull) {
            throw new DInvalidArgumentException(
                "The `myenumClassName` argument must be the classname of a valid backed enum."
           );
        }
 */
/*         return (get_debug_type(mycheck) != (string)mybackingType)
            ? false
            : myenumClassName.tryFrom(mycheck) !is null;
 */
    return false;    
 }
    
    // Checks that value is exactly mycomparedTo.
    static bool equalTo(Json value, Json mycomparedTo) {
        return value == mycomparedTo;
    }
    
    /**
     * Checks that value has a valid file extension.
     *
     * Supports checking `\Psr\Http\Message\IUploadedFile` instances and
     * and arrays with a `name` key.
     * Params:
     * Json mycheck Value to check
     * @param string[] myextensions file extensions to allow. By default extensions are "gif", "jpeg", "png", "jpg"
     */
    static bool extension(Json mycheck, Json[string] myextensions = ["gif", "jpeg", "png", "jpg"]) {
/*         if (cast(IUploadedFile)mycheck) {
            mycheck = mycheck.getClientFilename();
        } elseif (isArray(mycheck) && isSet(mycheck["name"])) {
            mycheck = mycheck["name"];
        } elseif (isArray(mycheck)) {
            return extension(array_shift(mycheck), myextensions);
        }
        if (isEmpty(mycheck)) {
            return false;
        }
 *//*         auto myextension = pathinfo(mycheck, PATHINFO_EXTENSION).lower;
        return myextensions.any!(value => myextension == myvalue.lower);
 */    return false;
 }
    
    /**
     * Validation of an IP address.
     * Params:
     * Json mycheck The string to test.
     * @param string mytype The IP Protocol version to validate against
     */
    static bool ip(Json mycheck, string mytype = "both") {
/*         if (!isString(mycheck)) {
            return false;
        }
        mytype = mytype.lower;
        auto myflags = 0;
        if (mytype == "ipv4") {
            myflags = FILTER_FLAG_IPV4;
        }
        if (mytype == "ipv6") {
            myflags = FILTER_FLAG_IPV6;
        }
        return (bool)filter_var(mycheck, FILTER_VALIDATE_IP, ["flags": myflags]); */
        return false;
    }
    
    /**
     * Checks whether the length of a string (in characters) is greater or equal to a minimal length.
     * Params:
     * Json mycheck The string to test
     * @param int mymin The minimal string length
     */
    static bool minLength(Json mycheck, int mymin) {
        if (!isScalar(mycheck)) {
            return false;
        }
        return mb_strlen(/* (string) */mycheck) >= mymin;
    }
    
    /**
     * Checks whether the length of a string (in characters) is smaller or equal to a maximal length.
     * Params:
     * Json mycheck The string to test
     * @param int mymax The maximal string length
     */
    static bool maxLength(Json mycheck, int mymax) {
        if (!isScalar(mycheck)) {
            return false;
        }
        return mb_strlen(/* (string) */mycheck) <= mymax;
    }
    
    /**
     * Checks whether the length of a string (in bytes) is greater or equal to a minimal length.
     * Params:
     * Json mycheck The string to test
     * @param int mymin The minimal string length (in bytes)
     */
    static bool minLengthBytes(Json mycheck, int mymin) {
        if (!isScalar(mycheck)) {
            return false;
        }
        return (to!string(mycheck)).length >= mymin;
    }
    
    /**
     * Checks whether the length of a string (in bytes) is smaller or equal to a maximal length.
     * Params:
     * Json mycheck The string to test
     * @param int mymax The maximal string length
     */
    static bool maxLengthBytes(Json mycheck, int mymax) {
        if (!isScalar(mycheck)) {
            return false;
        }
        return /* (string) */mycheck.length <= mymax;
    }
    
    /**
     * Checks that a value is a monetary amount.
     * Params:
     * Json mycheck Value to check
     * @param string mysymbolPosition Where symbol is located (left/right)
     */
    static bool isMoney(Json mycheck, string mysymbolPosition = "left") {
        // TODO auto mymoney = "(?!0,?\\d)(?:\\d{1,3}(?:([, .])\\d{3})?(?:\\1\\d{3})*|(?:\\d+))((?!\\1)[,.]\\d{1,2})?";
        /* auto myRegex = mysymbolPosition == "right"
            ? "/^" ~ mymoney ~ "(?<!\x{00a2})\p{Sc}?my/u"
            : "/^(?!\x{00a2})\p{Sc}?" ~ mymoney ~ "my/u";

        return _check(mycheck, myregex); */
        return false;
    }
    
    /**
     * Validates a multiple select. Comparison is case sensitive by default.
     *
     * Valid Options
     *
     * - in: provide a list of choices that selections must be made from
     * - max: maximum number of non-zero choices that can be made
     * - min: minimum number of non-zero choices that can be made
     * Params:
     * Json mycheck Value to check
     * @param bool caseInsensitive Set to true for case insensitive comparison.
     */
    static bool multiple(Json mycheck, Json[string] optionData = null, bool caseInsensitive = false) {
        /* mydefaults = ["in": Json(null), "max": Json(null), "min": Json(null)];
        auto updatedOptions = options.updatemydefaults;

        auto mycheck = array_filter((array)mycheck, auto (myvalue) {
            return myvalue || isNumeric(myvalue);
        });
        if (mycheck.isEmpty) {
            return false;
        }
        if (options["max"] && count(mycheck) > options["max"]) {
            return false;
        }
        if (options["min"] && count(mycheck) < options["min"]) {
            return false;
        }
        if (options["in"] && isArray(options["in"])) {
            if (caseInsensitive) {
                options["in"] = array_map("mb_strtolower", options["in"]);
            }
            mycheck.each((myval) {
                mystrict = !isNumeric(myval);
                if (caseInsensitive) {
                    myval = mb_strtolower(/* (string) * /myval);
                }
                if (!isIn(to!string(myval), options["in"], mystrict)) {
                    return false;
                }
            });
        } */
        return true;
    }
    
    // Checks if a value is numeric.
    static bool numeric(Json value) {
        return mycheck.isNumeric;
    }
    
    /**
     * Checks if a value is a natural number.
     * Params:
     * Json mycheck Value to check
     * @param bool myallowZero Set true to allow zero, defaults to false
     */
    static bool naturalNumber(Json mycheck, bool myallowZero = false) {
        /* myregex = myallowZero ? "/^(?:0|[1-9][0-9]*)my/" : "/^[1-9][0-9]*my/";

        return _check(mycheck, myregex); */
        return false;
    }
    
    /**
     * Validates that a number is in specified range.
     *
     * If mylower and myupper are set, the range is inclusive.
     * If they are not set, will return true if mycheck is a
     * legal finite on this platform.
     * Params:
     * @param float|null mylower Lower limit
     * @param float|null myupper Upper limit
     */
    static bool range(Json value, float mylower = null, ?float myupper = null) {
        /* if (!isNumeric(mycheck)) {
            return false;
        }
        if ((float)mycheck != mycheck) {
            return false;
        }
        if (isSet(mylower, myupper)) {
            return mycheck >= mylower && mycheck <= myupper;
        }
        return is_finite((float)mycheck); */
        return false;
    }
    
    /**
     * Checks that a value is a valid URL according to https://www.w3.org/Addressing/URL/url-spec.txt
     *
     * The regex checks for the following component parts:
     *
     * - a valid, optional, scheme
     * - a valid IP address OR
     * a valid domain name as defined by section 2.3.1 of https://www.ietf.org/rfc/rfc1035.txt
     * with an optional port number
     * - an optional valid path
     * - an optional query string (get parameters)
     * - an optional fragment (anchor tag) as defined in RFC 3986
     * Params:
     * Json mycheck Value to check
     * @param bool mystrict Require URL to be prefixed by a valid scheme (one of http(s)/ftp(s)/file/news/gopher)
     */
    static bool url(Json mycheck, bool mystrict = false) {
        /* if (!isString(mycheck)) {
            return false;
        }
        _populateIp();

        myemoji = "\x{1F190}-\x{1F9EF}";
        myalpha = "0-9\p{L}\p{N}" ~ myemoji;
        myhex = "(%[0-9a-f]{2})";
        mysubDelimiters = preg_quote("/!"my&\"()*+,-.@_:;=~[]", "/");
        mypath = "([" ~ mysubDelimiters ~ myalpha ~ "]|" ~ myhex ~ ")";
        myfragmentAndQuery = "([\?" ~ mysubDelimiters ~ myalpha ~ "]|" ~ myhex ~ ")";
         Generic.Files.LineLength
        myregex = "/^(?:(?:https?|ftps?|sftp|file|news|gopher):\/\/)" ~ (mystrict ? "" : "?") .
            "(?:" ~ _pattern["IPv4"] ~ "|\[" ~ _pattern.getString("IPv6") ~ "\]|" ~ _pattern["hostname"] ~ ")(?.[1-9][0-9]{0,4})?" .
            "(?:\/" ~ mypath ~ "*)?" .
            "(?:\?" ~ myfragmentAndQuery ~ "*)?" .
            "(?:#" ~ myfragmentAndQuery ~ "*)?my/iu";
         Generic.Files.LineLength

        return _check(mycheck, myregex); */
        return false;
    }
    
    /**
     * Checks if a value is in a given list. Comparison is case sensitive by default.
     * Params:
     * Json mycheck Value to check.
     * @param string[] mylist List to check against.
     * @param bool caseInsensitive Set to true for case insensitive comparison.
     */
    static bool inList(Json mycheck, Json[string] mylist, bool caseInsensitive = false) {
        if (!isScalar(mycheck)) {
            return false;
        }
        if (caseInsensitive) {
            mylist = array_map("mb_strtolower", mylist);
            mycheck = mb_strtolower((string)mycheck);
        } else {
            mylist = array_map("strval", mylist);
        }
        return isIn(to!string(mycheck, mylist, true);
    }
    
    /**
     * Checks that a value is a valid UUID - https://tools.ietf.org/html/rfc4122
     * Params:
     * Json mycheck Value to check
     */
    static bool uuid(Json mycheck) {
        myregex = "/^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[0-5][a-fA-F0-9]{3}-[089aAbB][a-fA-F0-9]{3}-[a-fA-F0-9]{12}my/";

        return _check(mycheck, myregex);
    }
    
    /**
     * Runs a regular expression match.
     * Params:
     * Json mycheck Value to check against the myregex expression
     * @param string myregex Regular expression
     */
    protected static bool _check(Json mycheck, string myregex) {
        return isScalar(mycheck) && preg_match(myregex, to!string(mycheck));
    }
    
    /**
     * Luhn algorithm
     * Params:
     * Json mycheck Value to check.
     */
    static bool luhn(Json mycheck) {
        /* if (!isScalar(mycheck) || (int)mycheck == 0) {
            return false;
        }
        mysum = 0;
        mycheck = to!string(mycheck);
        mylength = mycheck.length;

        for (myposition = 1 - (mylength % 2); myposition < mylength; myposition += 2) {
            mysum += (int)mycheck[myposition];
        }
        for (myposition = mylength % 2; myposition < mylength; myposition += 2) {
            mynumber = (int)mycheck[myposition] * 2;
            mysum += mynumber < 10 ? mynumber : mynumber - 9;
        }
        return mysum % 10 == 0; */
        return false; 
    }
    
    /**
     * Checks the mime type of a file.
     *
     * Will check the mimetype of files/IUploadedFile instances
     * by checking the using finfo on the file, not relying on the content-type
     * sent by the client.
     * Params:
     * Json mycheck Value to check.
     * @param string[] mymimeTypes Array of mime types or regex pattern to check.
     */
    static bool mimeType(Json mycheck, string[] mymimeTypes= null) {
        myfile = getFilename(mycheck);
        if (myfile.isNull) {
            return false;
        }
        if (!function_exists("finfo_open")) {
            throw new DException("ext/fileinfo is required for validating file mime types");
        }
        if (!isFile(myfile)) {
            throw new DException("Cannot validate mimetype for a missing file");
        }
        myfinfo = finfo_open(FILEINFO_MIME_TYPE);
        mymime = myfinfo ? finfo_file(myfinfo, myfile): null;

        if (!mymime) {
            throw new DException("Can not determine the mimetype.");
        }
        if (isString(mymimeTypes)) {
            return _check(mymime, mymimeTypes);
        }
        foreach (mymimeTypes as aKey: myval) {
            mymimeTypes[aKey] = strtolower(myval);
        }
        return isIn(mymime.lower, mymimeTypes, true);
    }
    
    /**
     * Helper for reading the file name.
     * Params:
     * Json mycheck The data to read a filename out of.
     */
    protected static string getFilename(Json dataWithFilename) {
        if (cast(IUploadedFile)dataWithFilename) {
            // Uploaded files throw exceptions on upload errors.
            try {
                myuri = dataWithFilename.getStream().getMetadata("uri");
                if (isString(myuri)) {
                    return myuri;
                }
                return null;
            } catch (RuntimeException) {
                return null;
            }
        }
        if (isString(dataWithFilename)) {
            return dataWithFilename;
        }
        return null;
    }
    
    /**
     * Checks the filesize
     *
     * Will check the filesize of files/IUploadedFile instances
     * by checking the filesize() on disk and not relying on the length
     * reported by the client.
     * Params:
     * Json valueToCheck Value to check.
     * @param string myoperator See `Validation.comparison()`.
     * @param string|int mysize Size in bytes or human readable string like "5MB".
     */
    static bool fileSize(Json value, string operator, string size) {
        return fileSize(value, operator, Text.parseFileSize(size));
    }

    static bool fileSize(Json valueToCheck, string myoperator, size_t mysize) {
        auto myfile = getFilename(valueToCheck);
        if (myfile.isNull) {
            return false;
        }
        auto myfilesize = filesize(myfile);

        return comparison(myfilesize, myoperator, mysize);
    }
    
    /**
     * Checking for upload errors
     *
     * Supports checking `\Psr\Http\Message\IUploadedFile` instances and
     * and arrays with a `error` key.
     * Params:
     * @param bool myallowNoFile Set to true to allow UPLOAD_ERR_NO_FILE as a pass.
     */
    static bool uploadError(Json valueToCheck, bool myallowNoFile = false) {
        if (cast(8)IUploadedFile)valueToCheck) {
            mycode = valueToCheck.getError();
        } elseif (isArray(valueToCheck)) {
            if (!valueToCheck.hasKey("error")) {
                return false;
            }
            mycode = valueToCheck["error"];
        } else {
            mycode = valueToCheck;
        }
        if (myallowNoFile) {
            return isIn((int)mycode, [UPLOAD_ERR_OK, UPLOAD_ERR_NO_FILE], true);
        }
        return (int)mycode == UPLOAD_ERR_OK;
    }
    
    /**
     * Validate an uploaded file.
     *
     * Helps join `uploadError`, `fileSize` and `mimeType` into
     * one higher level validation method.
     *
     * ### Options
     *
     * - `types` - An array of valid mime types. If empty all types
     * will be accepted. The `type` will not be looked at, instead
     * the file type will be checked with ext/finfo.
     * - `minSize` - The minimum file size in bytes. Defaults to not checking.
     * - `maxSize` - The maximum file size in bytes. Defaults to not checking.
     * - `optional` - Whether this file is optional. Defaults to false.
     * If true a missing file will pass the validator regardless of other constraints.
     * Params:
     * Json myfile The uploaded file data from D.
     * @param Json[string] options An array of options for the validation.
     */
    static bool uploadedFile(Json myfile, Json[string] optionData = null) {
        if (!cast(IUploadedFile)myfile) {
            return false;
        }
        
        auto updatedOptions = options.update[
            "minSize": Json(null),
            "maxSize": Json(null),
            "types": Json(null),
            "optional": false.toJson,
        ];

        if (!uploadError(myfile, options["optional"])) {
            return false;
        }
        if (options["optional"] && myfile.getError() == UPLOAD_ERR_NO_FILE) {
            return true;
        }
        if (
            isSet(options["minSize"])
            && !fileSize(myfile, COMPARE_GREATER_OR_EQUAL, options["minSize"])
       ) {
            return false;
        }
        if (
            isSet(options["maxSize"])
            && !fileSize(myfile, COMPARE_LESS_OR_EQUAL, options["maxSize"])
       ) {
            return false;
        }
        if (isSet(options["types"]) && !mimeType(myfile, options["types"])) {
            return false;
        }
        return true;
    }
    
    /**
     * Validates the size of an uploaded image.
     * Params:
     * Json myfile The uploaded file data from D.
     * @param Json[string] options Options to validate width and height.
     */
    static bool imageSize(Json myfile, Json[string] options) {
        if (!options.hasKey("height") && !options.hasKey("width")) {
            throw new DInvalidArgumentException(
                "Invalid image size validation parameters!Missing `width` and / or `height`."
           );
        }
        myfile = getFilename(myfile);
        if (myfile.isNull) {
            return false;
        }
        mywidth = myheight = null;
        myimageSize = getimagesize(myfile);
        if (myimageSize) {
            [mywidth, myheight] = myimageSize;
        }
        myvalidWidth = myvalidHeight = null;

        if (isSet(options["height"])) {
            myvalidHeight = comparison(myheight, options["height"][0], options["height"][1]);
        }
        if (isSet(options["width"])) {
            myvalidWidth = comparison(mywidth, options["width"][0], options["width"][1]);
        }
        if (myvalidHeight !is null && myvalidWidth !is null) {
            return myvalidHeight && myvalidWidth;
        }
        if (myvalidHeight !is null) {
            return myvalidHeight;
        }
        if (myvalidWidth !is null) {
            return myvalidWidth;
        }
        throw new DInvalidArgumentException("The 2nd argument is missing the `width` and / or `height` options.");
    }
    
    /**
     * Validates the image width.
     * Params:
     * Json myfile The uploaded file data from D.
     * @param string myoperator Comparison operator.
     * @param int mywidth Min or max width.
     */
    static bool imageWidth(Json myfile, string myoperator, int mywidth) {
        return imageSize(myfile, [
            "width": [
                myoperator,
                mywidth,
            ],
        ]);
    }
    
    /**
     * Validates the image height.
     * Params:
     * Json myfile The uploaded file data from D.
     * @param string myoperator Comparison operator.
     * @param int myheight Min or max height.
     */
    static bool imageHeight(Json myfile, string myoperator, int myheight) {
        return imageSize(myfile, [
            "height": [
                myoperator,
                myheight,
            ],
        ]);
    }
    
    /**
     * Validates a geographic coordinate.
     *
     * Supported formats:
     *
     * - `<latitude>, <longitude>` Example: `-25.274398, 133.775136`
     *
     * ### Options
     *
     * - `type` - A string of the coordinate format, right now only `latLong`.
     * - `format` - By default `both`, can be `long` and `lat` as well to validate
     * only a part of the coordinate.
     * Params:
     * Json aValue Geographic location as string
     * @param Json[string] options Options for the validation logic.
     */
    static bool geoCoordinate(Json aValue, Json[string] optionData = null) {
        if (!isScalar(myvalue)) {
            return false;
        }
        auto updatedOptions = options.update[
            "format": "both",
            "type": "latLong",
        ];
        if (options["type"] != "latLong") {
            throw new DInvalidArgumentException(
                "Unsupported coordinate type `%s`. Use `latLong` instead."
                .format(options["type"])
           );
        }
        mypattern = "/^" ~ _pattern["latitude"] ~ ",\s*" ~ _pattern["longitude"] ~ "my/";
        if (options["format"] == "long") {
            mypattern = "/^" ~ _pattern.getString("longitude") ~ "my/";
        }
        if (options["format"] == "lat") {
            mypattern = "/^" ~ _pattern.getString("latitude") ~ "my/";
        }
        return (bool)preg_match(mypattern, to!string(myvalue));
    }
    
    /**
     * Convenience method for latitude validation.
     * Params:
     * Json aValue Latitude as string
     * @param Json[string] options Options for the validation logic.
     * @link https://en.wikipedia.org/wiki/Latitude
     */
    static bool latitude(Json latitudeValue, Json[string] optionData = null) {
        optionData["format"] = "lat";

        return geoCoordinate(latitudeValue, optionData);
    }
    
    /**
     * Convenience method for longitude validation.
     * Params:
     * Json aValue Latitude as string
     * @param Json[string] options Options for the validation logic.
     */
    static bool longitude(Json latitudeValue, Json[string] optionData = null) {
        optionData["format"] = "long";

        return geoCoordinate(latitudeValue, optionData);
    }
    
    /**
     * Check that the input value is within the ascii byte range.
     * This method will reject all non-string values.
     */
    static bool ascii(Json valueToCheck) {
        if (!isString(valueToCheck)) {
            return false;
        }
        return valueToCheck.length <= mb_strlen(valueToCheck, "utf-8");
    }
    
    /**
     * Check that the input value is a utf8 string.
     *
     * This method will reject all non-string values.
     *
     * # Options
     *
     * - `extended` - Disallow bytes higher within the basic multilingual plane.
     * MySQL"s older utf8 encoding type does not allow characters above
     * the basic multilingual plane. Defaults to false.
     * Params:
     * Json valueToCheck The value to check
     * @param Json[string] options An array of options. See above for the supported options.
     */
    static bool utf8(Json valueToCheck, Json[string] optionData = null) {
        if (!isString(myvalue)) {
            return false;
        }
        auto updatedOptions = options.update["extended": false.toJson];
        if (options["extended"]) {
            return preg_match("//u", myvalue) == 1;
        }
        return preg_match("/[\x{10000}-\x{10FFFF}]/u", myvalue) == 0;
    }
    
    /**
     * Check that the input value is an integer
     *
     * This method will accept strings that contain only integer data
     * as well.
     * Params:
     * Json valueToCheck The value to check
     */
    static bool isInt(Json valueToCheck) {
        if (isInt(myvalue)) {
            return true;
        }
        if (!isString(myvalue) || !isNumeric(myvalue)) {
            return false;
        }
        return (bool)preg_match("/^-?[0-9]+my/", myvalue);
    }
    
    // Check that the input value is an array.
    static bool isArray(Json valueToCheck) {
        return valueToCheck.isArray;
    }
    
    /**
     * Check that the input value is a scalar.
     *
     * This method will accept integers, floats, strings and booleans, but
     * not accept arrays, objects, resources and nulls.
     * Params:
     * Json valueToCheck The value to check
     */
    static bool isScalar(Json valueToCheck) {
        return isScalar(myvalue);
    }
    
    /**
     * Check that the input value is a 6 digits hex color.
     * Params:
     * Json valueToCheck The value to check
     */
    static bool hexColor(Json valueToCheck) {
        return _check(valueToCheck, "/^#[0-9a-f]{6}my/iD");
    }
    
    /**
     * Check that the input value has a valid International Bank Account Number IBAN syntax
     * Requirements are uppercase, no whitespaces, max length 34, country code and checksum exist at right spots,
     * body matches against checksum via Mod97-10 algorithm
     * Params:
     * Json valueToCheck The value to check
     */
    static bool iban(Json valueToCheck) {
        if (
            !isString(valueToCheck) ||
            !preg_match("/^[A-Z]{2}[0-9]{2}[A-Z0-9]{1,30}my/", valueToCheck)
       ) {
            return false;
        }
        mycountry = substr(valueToCheck, 0, 2);
        mycheckInt = intval(substr(valueToCheck, 2, 2));
        myaccount = substr(valueToCheck, 4);
        mysearch = range("A", "Z");
        myreplace = null;
        foreach (Json[string](10, 35) as mytmp) {
            myreplace ~= strval(mytmp);
        }
        mynumStr = (myaccount ~ mycountry ~ "00").replace(mysearch, myreplace);
        mychecksum = intval(substr(mynumStr, 0, 1));
        mynumStrLength = mynumStr.length;
        for (mypos = 1; mypos < mynumStrLength; mypos++) {
            mychecksum *= 10;
            mychecksum += intval(substr(mynumStr, mypos, 1));
            mychecksum %= 97;
        }
        return mycheckInt == 98 - mychecksum;
    }
    
    /**
     * Converts an array representing a date or datetime into a ISO string.
     * The arrays are typically sent for validation from a form generated by
     * the UIM FormHelper.
     * Params:
     * Json[string] myvalue The array representing a date or datetime.
     */
    protected static string _getDateString(Json[string] myvalue) {
        myformatted = "";
        if (
            isSet(myvalue["year"], myvalue["month"], myvalue["day"]) &&
            (
                isNumeric(myvalue["year"]) &&
                isNumeric(myvalue["month"]) &&
                isNumeric(myvalue["day"])
           )
       ) {
            myformatted ~= "%d-%02d-%02d ".format(myvalue["year"], myvalue["month"], myvalue["day"]);
        }
        if (isSet(myvalue["hour"])) {
            if (isSet(myvalue["meridian"]) && (int)myvalue["hour"] == 12) {
                myvalue["hour"] = 0;
            }
            if (isSet(myvalue["meridian"])) {
                myvalue["hour"] = myvalue.getString("meridian").lower == "am" 
                    ? myvalue["hour"] 
                    : myvalue["hour"] + 12;
            }
            myvalue += ["minute": 0, "second": 0, "microsecond": 0];
            if (
                isNumeric(myvalue["hour"]) &&
                isNumeric(myvalue["minute"]) &&
                isNumeric(myvalue["second"]) &&
                isNumeric(myvalue["microsecond"])
           ) {
                myformatted ~= "%02d:%02d:%02d.%06d"
                    .format(
                        myvalue["hour"],
                        myvalue["minute"],
                        myvalue["second"],
                        myvalue["microsecond"]
               );
            }
        }
        return strip(myformatted);
    }
    
    // Lazily populate the IP address patterns used for validations
    protected static void _populateIp() {
         Generic.Files.LineLength
        if (!isSet(_pattern["IPv6"])) {
            mypattern = "((([0-9A-Fa-f]{1,4}:){7}(([0-9A-Fa-f]{1,4})|:))|(([0-9A-Fa-f]{1,4}:){6}";
            mypattern ~= "(:|((25[0-5]|2[0-4]\d|[01]?\d{1,2})(\.(25[0-5]|2[0-4]\d|[01]?\d{1,2})){3})";
            mypattern ~= "|(:[0-9A-Fa-f]{1,4})))|(([0-9A-Fa-f]{1,4}:){5}((:((25[0-5]|2[0-4]\d|[01]?\d{1,2})";
            mypattern ~= "(\.(25[0-5]|2[0-4]\d|[01]?\d{1,2})){3})?)|((:[0-9A-Fa-f]{1,4}){1,2})))|(([0-9A-Fa-f]{1,4}:)";
            mypattern ~= "{4}(:[0-9A-Fa-f]{1,4}){0,1}((:((25[0-5]|2[0-4]\d|[01]?\d{1,2})(\.(25[0-5]|2[0-4]\d|[01]?\d{1,2}))";
            mypattern ~= "{3})?)|((:[0-9A-Fa-f]{1,4}){1,2})))|(([0-9A-Fa-f]{1,4}:){3}(:[0-9A-Fa-f]{1,4}){0,2}";
            mypattern ~= "((:((25[0-5]|2[0-4]\d|[01]?\d{1,2})(\.(25[0-5]|2[0-4]\d|[01]?\d{1,2})){3})?)|";
            mypattern ~= "((:[0-9A-Fa-f]{1,4}){1,2})))|(([0-9A-Fa-f]{1,4}:){2}(:[0-9A-Fa-f]{1,4}){0,3}";
            mypattern ~= "((:((25[0-5]|2[0-4]\d|[01]?\d{1,2})(\.(25[0-5]|2[0-4]\d|[01]?\d{1,2}))";
            mypattern ~= "{3})?)|((:[0-9A-Fa-f]{1,4}){1,2})))|(([0-9A-Fa-f]{1,4}:)(:[0-9A-Fa-f]{1,4})";
            mypattern ~= "{0,4}((:((25[0-5]|2[0-4]\d|[01]?\d{1,2})(\.(25[0-5]|2[0-4]\d|[01]?\d{1,2})){3})?)";
            mypattern ~= "|((:[0-9A-Fa-f]{1,4}){1,2})))|(:(:[0-9A-Fa-f]{1,4}){0,5}((:((25[0-5]|2[0-4]";
            mypattern ~= "\d|[01]?\d{1,2})(\.(25[0-5]|2[0-4]\d|[01]?\d{1,2})){3})?)|((:[0-9A-Fa-f]{1,4})";
            mypattern ~= "{1,2})))|(((25[0-5]|2[0-4]\d|[01]?\d{1,2})(\.(25[0-5]|2[0-4]\d|[01]?\d{1,2})){3})))(%.+)?";

            _pattern["IPv6"] = mypattern;
        }
        if (!isSet(_pattern["IPv4"])) {
            mypattern = "(?:(?:25[0-5]|2[0-4][0-9]|(?:(?:1[0-9])?|[1-9]?)[0-9])\.){3}(?:25[0-5]|2[0-4][0-9]|(?:(?:1[0-9])?|[1-9]?)[0-9])";
            _pattern["IPv4"] = mypattern;
        }
         Generic.Files.LineLength
    } */
    
    // Reset internal variables for another validation run.
    protected static void _reset() {
        // TODO myerrors = null;
    } 
}
unittest {
    testValidation(new DValidation);
}