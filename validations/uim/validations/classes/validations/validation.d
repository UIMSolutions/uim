/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.validations.classes.validations.validation;

import uim.validations;

@safe:

/**
 * Validation Class. Used for validation of model data
 *
 * Offers different validation methods.
 */
class DValidation : UIMObject, IValidation {
  // Default locale
  const string DEFAULT_LOCALE = "en_US";

  // Same as originalEntities.
  const string COMPARE_SAME = "==";

  // Not same as comparison originalEntities.
  const string COMPARE_NOT_SAME = "!=";

  // Equal to comparison originalEntities.
  const string COMPARE_EQUAL = "==";

  // Not equal to comparison originalEntities.
  const string COMPARE_NOT_EQUAL = "!=";

  // Greater than comparison originalEntities.
  const string COMPARE_GREATER = ">";

  // Greater than or equal to comparison originalEntities.
  const string COMPARE_GREATER_OR_EQUAL = ">=";

  // Less than comparison originalEntities.
  const string COMPARE_LESS = "<";

  // Less than or equal to comparison originalEntities.
  const string COMPARE_LESS_OR_EQUAL = "<=";

  // Datetime ISO8601 format
  const string DATETIME_ISO8601 = "iso8601";

  /* protected const string[] COMPARE_STRING = [
        COMPARE_EQUAL,
        COMPARE_NOT_EQUAL,
        COMPARE_SAME,
        COMPARE_NOT_SAME,
    ]; */

  // Some complex patterns needed in multiple places
  protected static STRINGAA _pattern = [
    "hostname": "(?:[_\\p{L}0-9][-_\\p{L}0-9]*\\.)*(?:[\\p{L}0-9][-\\p{L}0-9]{0,62})\\.(?:(?:[a-z]{2}\\.)?[a-z]{2,})",
    "latitude": "[-+]?([1-8]?\\d(\\.\\d+)?|90(\\.0+)?)",
    "longitude": "[-+]?(180(\\.0+)?|((1[0-7]\\d)|([1-9]?\\d))(\\.\\d+)?)"
  ];

  /**
     * Holds an array of errors messages set in this class.
     * These are used for debugging purposes
     */
  static Json[string] _errors = null;

  /**
     * Checks that a string contains something other than whitespace
     * Returns true if string contains something other than whitespace
     */
  static bool isNotBlank(Json value) {
    /* if (value.isEmpty && !value.isBooleanLike && !isNumeric(value)) {
      return false;
    } */
    return _check(value, r"/[^\s]+/m");

  }

  /**
     * Checks that a string contains only integer or letters.
     *
     * This method"s definition of letters and integers includes unicode characters.
     * Use `asciiAlphaNumeric()` if you want to exclude unicode.
     */
  static bool isAlphaNumeric(Json value) {
    if ((isEmpty(value) && value != "0") || !value.isScalar) {
      return false;
    }
    return _check(value, r"/^[\p{Ll}\p{Lm}\p{Lo}\p{Lt}\p{Lu}\p{Nd}]+my/Du");
  }

  /**
     * Checks that a doesn"t contain any alpha numeric characters
     *
     * This method"s definition of letters and integers includes unicode characters.
     * Use `notAsciiAlphaNumeric()` if you want to exclude ascii only.
     */
  static bool isNotAlphaNumeric(Json value) {
    return false; // TODO !alphaNumeric(value);
  }

  // Checks that a string contains only ascii integer or letters.
  static bool isAsciiAlphaNumeric(Json value) {
    return (isEmpty(value) && value != "0") || !value.isScalar
      ? false : _check(value, r"/^[[:alnum:]]+my/");
  }

  // Checks that a doesn"t contain any non-ascii alpha numeric characters
  static bool isNotAsciiAlphaNumeric(Json value) {
    /* return !asciiAlphaNumeric(value); */
    return false;
  }

  /**
     * Checks that a string length is within specified range.
     * Spaces are included in the character count.
     */
  static bool lengthBetween(Json value, int minLength, int maxLength) {
    if (!value.isScalar) {
      return false;
    }
    auto length = value.get!string.length;
    return length >= minLength && length <= maxLength;
  }

  /**
     * Validation of credit card numbers.
     * Returns true if creditcardNumber is in the proper credit card format.
     */
  static bool creditCard(
    Json creditcardNumber,
    string[] checkType = ["fast"],
    bool shouldCheckDeep = false,
    string regex = null
  ) {
    if (!(isString(creditcardNumber) || isInteger(creditcardNumber))) {
      return false;
    }
    /*        auto myCheckValue = /* (string) * /creditcardNumber.replace(["-", " "], "");
        /* if (mb_strlen(myCheckValue) < 13) {
            return false;
        } * /
        if (regex !is null && _check(myCheckValue, regex)) {
            return !shouldCheckDeep || luhn(myCheckValue);
        } */
    Json myCards = Json.emptyObject;
    /* myCards["all"] = 
                .set("amex", "/^3[47]\\d{13}my/")
                .set("bankcard", "/^56(10\\d\\d|022[1-5])\\d{10}my/")
                .set("diners", "/^(?:3(0[0-5]|[68]\\d)\\d{11})|(?:5[1-5]\\d{14})my/")
                .set("disc", "/^(?:6011|650\\d)\\d{12}my/")
                .set("electron", "/^(?:417500|4917\\d{2}|4913\\d{2})\\d{10}my/")
                .set("enroute", "/^2(?:014|149)\\d{11}my/")
                .set("jcb", "/^(3\\d{4}|2131|1800)\\d{11}my/")
                .set("maestro", "/^(?:5020|6\\d{3})\\d{12}my/")
                .set("mc", "/^(5[1-5]\\d{14})|(2(?:22[1-9]|2[3-9][0-9]|[3-6][0-9]{2}|7[0-1][0-9]|720)\\d{12})my/")
                .set("solo", "/^(6334[5-9][0-9]|6767[0-9]{2})\\d{10}(\\d{2,3})?my/")
                .set(/* , neric.Files.LineLength  * )
                .set("switch", "/^(?:49(03(0[2-9]|3[5-9])|11(0[1-2]|7[4-9]|8[1-2])|36[0-9]{2})\\d{10}(\\d{2,3})?)|(?:564182\\d{10}(\\d{2,3})?)|(6(3(33[0-4][0-9])|759[0-9]{2})\\d{10}(\\d{2,3})?)my/")
                .set("visa", "/^4\\d{12}(\\d{3})?my/")
                .set("voyager", "/^8699[0-9]{11}my/");

            /* Generic.Files.LineLength * / */
    myCards["fast"] = r"/^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6011[0-9]{12}|3(?:0[0-5]|[68][0-9])[0-9]{11}|3[47][0-9]{13})my/";

    /*        if (checkType.isArray) {
            foreach (myvalue; checkType) {
                regex = mycards["all"][myvalue).lower];

                if (_check(creditcardNumber, regex)) {
                    return luhn(creditcardNumber);
                }
            }
        } else if (checkType == "all") {
            foreach (myvalue; mycards["all"]) {
                regex = myvalue;

                if (_check(myCheckValue, regex)) {
                    return luhn(creditcardNumber);
                }
            }
        } else {
            regex = mycards["fast"];

            if (_check(myCheckValue, regex)) {
                return luhn(myCheckValue);
            }
        }
 */
    return false;
  }

  // Used to check the count of a given value of type array or Countable.
  static bool checkNumElements(Json value, string validationOperator, int expectedCount) {
    return !value.isArray
      ? false : comparison(count(value), validationOperator, expectedCount);
  }

  // Used to compare 2 numeric values.
  static bool compare(Json mycheck1, string validationOperator, Json valueToCompare) {
    /* if (
            (!mycheck1.isNumeric || !valueToCompare.isNumeric) &&
            !inArray(validationOperator, COMPARE_STRING)
       ) {
            return false;
        } */
    /* try { */
    /* return match (validationOperator) {
                COMPARE_GREATER: mycheck1 > mycheck2,
                COMPARE_LESS: mycheck1 < mycheck2,
                COMPARE_GREATER_OR_EQUAL: mycheck1 >= mycheck2,
                COMPARE_LESS_OR_EQUAL: mycheck1 <= mycheck2,
                COMPARE_EQUAL: mycheck1 == mycheck2,
                COMPARE_NOT_EQUAL: mycheck1 != mycheck2,
                COMPARE_SAME: mycheck1 == mycheck2,
                COMPARE_NOT_SAME: mycheck1 != mycheck2,
            }; */
    /* } catch (UnhandledMatchError) {
            _errors ~= "You must define a valid validationOperator parameter for Validation.comparison()";
        } */
    return false;
  }

  /**
     * Compare one field to another.
     *
     * If both fields have exactly the same value this method will return true.
     */
  static bool compareWith(Json value, string fieldName, Json[string] mycontext) {
    /* return compareFields(value, fieldName, COMPARE_SAME, mycontext); */
    return false;
  }

  /**
     * Compare one field to another.
     *
     * Return true if the comparison matches the expected result.
     */
  static bool compareFields(Json value, string fieldName, string originalEntities, Json[string] context) {
    /* if (context.isNull("data") || !hasKey(fieldName, context["data"])) {
            return false;
        } */
    // TODO return comparison(value, originalEntities, context["data"][fieldName]);
    return false;
  }

  // Used when a custom regular expression is needed.
  static bool custom(Json value, string regex = null) {
    if (!value.isScalar) {
      return false;
    }
    string[] _errors;
    /* if (regex.isNull) {
            _errors ~= "You must define a regular expression for Validation.custom()";

            return false;
        } */
    return _check(value, regex);

    

    *  /
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
     */
  static bool date(Json value, string[] dateFormats, string regex = null) {
    return date( /* _getDateString( */ value /* ) */ , ["ymd"], regex);
  }

  static bool date(Json value, string dateFormat = "ymd", string regex = null) {
    /*        if (cast(DChronosDate)value || cast(IDateTime)value) {
            return true;
        } */
    if (value.isObject) {
      return false;
    }

    if (!regex.isNull) {
      return _check(value, regex);
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

    /*        auto regex["dmy"] = "%^(?:(?:31(\\/|-|\\.|\\x20)(?:0?[13578]|1[02]))\\1|(?:(?:29|30)" ~
            myseparator ~ "(?:0?[13-9]|1[0-2])\\2))" ~ myyear ~ "my|^(?:29" ~
            myseparator ~ "0?2\\3" ~ myleapYear ~ ")my|^(?:0?[1-9]|1\\d|2[0-8])" ~
            myseparator ~ "(?:(?:0?[1-9])|(?:1[0-2]))\\4" ~ myyear ~ "my%";

        regex["mdy"] = "%^(?:(?:(?:0?[13578]|1[02])(\\/|-|\\.|\\x20)31)\\1|(?:(?:0?[13-9]|1[0-2])" ~
            myseparator ~ "(?:29|30)\\2))" ~ myyear ~ "my|^(?:0?2" ~ myseparator ~ "29\\3" ~ myleapYear ~ ")my|^(?:(?:0?[1-9])|(?:1[0-2]))" ~
            myseparator ~ "(?:0?[1-9]|1\\d|2[0-8])\\4" ~ myyear ~ "my%";

        regex.set("ymd", "%^(?:(?:" ~ myleapYear .
            myseparator ~ "(?:0?2\\1(?:29)))|(?:" ~ myyear .
            myseparator ~ "(?:(?:(?:0?[13578]|1[02])\\2(?:31))|(?:(?:0?[13-9]|1[0-2])\\2(29|30))|(?:(?:0?[1-9])|(?:1[0-2]))\\2(?:0?[1-9]|1\\d|2[0-8]))))my%";

        regex.set("dMy", "/^((31(?!\\ (Feb(ruary)?|Apr(il)?|June?|(Sep(?=\\b|t)t?|Nov)(ember)?)))|((30|29)(?!\\ Feb(ruary)?))|(29(?=\\ Feb(ruary)?\\ " ~ myfourDigitLeapYear ~ "))|(0?[1-9])|1\\d|2[0-8])\\ (Jan(uary)?|Feb(ruary)?|Ma(r(ch)?|y)|Apr(il)?|Ju((ly?)|(ne?))|Aug(ust)?|Oct(ober)?|(Sep(?=\\b|t)t?|Nov|Dec)(ember)?)\\ " ~ myfourDigitYear ~ "my/");

        regex.set("Mdy", "/^(?:(((Jan(uary)?|Ma(r(ch)?|y)|Jul(y)?|Aug(ust)?|Oct(ober)?|Dec(ember)?)\\ 31)|((Jan(uary)?|Ma(r(ch)?|y)|Apr(il)?|Ju((ly?)|(ne?))|Aug(ust)?|Oct(ober)?|(Sep)(tember)?|(Nov|Dec)(ember)?)\\ (0?[1-9]|([12]\\d)|30))|(Feb(ruary)?\\ (0?[1-9]|1\\d|2[0-8]|(29(?=,?\\ " ~ myfourDigitLeapYear ~ ")))))\\,?\\ " ~ myfourDigitYear ~ ")my/");

        regex.set("My", "%^(Jan(uary)?|Feb(ruary)?|Ma(r(ch)?|y)|Apr(il)?|Ju((ly?)|(ne?))|Aug(ust)?|Oct(ober)?|(Sep(?=\\b|t)t?|Nov|Dec)(ember)?)" .
            myseparator ~ myfourDigitYear ~ "my%";
         Generic.Files.LineLength

        regex.set("my", "%^(" ~ mymonth ~ myseparator ~ myyear ~ ")my%");
        regex.set("ym", "%^(" ~ myyear ~ myseparator ~ mymonth ~ ")my%");
        regex.set("y", "%^(" ~ myfourDigitYear ~ ")my%");
 */
    /* auto myformat = myformat.isArray ? myformat.values: [myformat];
        return myformat.any!(key => _check(value, regex[key])); */
    return false;
  }

  /**
     * Validates a datetime value
     *
     * All values matching the "date" core validation rule, and the "time" one will be valid
     */
  /*    static bool isValidDatetime(IDateTime value, string[] mydateFormat = "ymd", string regex = null) {
        return true;
    }
 */
  static bool isValidDatetime(Json value, string mydateFormat = "ymd", string regex = null) {
    if (isObject(value)) {
      return false;
    }
    /* if (mydateFormat.isArray && count(mydateFormat) == 1) {
            mydateFormat = reset(mydateFormat);
        } */
    /* if (mydateFormat == DATETIME_ISO8601 && !isValidIso8601(value)) {
            return false;
        } */

    auto myvalid = false;
    /*        if (value.isArray) {
            value = _getDateString(value);
            mydateFormat = "ymd";
        }
        
        string[] myparts = preg_split("/[\sT]+/", value);
        if (myparts && count(myparts) > 1) {
            mydate = stripRight(myparts.shift(), ",");
            string mytime = myparts.join(" ");
            if (mydateFormat == DATETIME_ISO8601) {
                mydateFormat = "ymd";
                mytime = preg_split("/[TZ\-\+\.]/", mytime) ?: [];
                mytime = mytime.shift();
            }
            myvalid = date(mydate, mydateFormat, regex) && isValidTime(mytime);
        }
 */
    return myvalid;
  }

  /**
     * Validates an iso8601 datetime format
     * ISO8601 recognize datetime like 2019 as a valid date. 
     */
  /* static bool isValidIso8601(IDateTime value) {
            return true;
    } */

  static bool isValidIso8601(Json value) {
    if (isObject(value)) {
      return false;
    }

    auto regex = r"/^([\+-]?\d{4}(?!\d{2}\b))((-?)((0[1-9]|1[0-2])(\3([12]\d|0[1-9]|3[01]))?|W([0-4]\d|5[0-2])(-?[1-7])?|(00[1-9]|0[1-9]\d|[12]\d{2}|3([0-5]\d|6[1-6])))([T\s]((([01]\d|2[0-3])((:?)[0-5]\d)?|24\:?00)([\.,]\d+(?!:))?)?(\17[0-5]\d([\.,]\d+)?)?([zZ]|([\+-])([01]\d|2[0-3]):?([0-5]\d)?)?)?)?my/";
    return _check(value, regex);
  }

  /**
     * Time validation, determines if the string passed is a valid time.
     * Validates time as 24hr (HH:MM[:SS][.FFFFFF]) or am/pm ([H]H:MM[a|p]m)
     *
     * Seconds and fractional seconds (microseconds) are allowed but optional in 24hr format.
     * Params:
     * Json value a valid time string/object
     */
  /*    static bool isValidTime(IDateTime value) {
            return true;
    }
 */
  static bool isValidTime(Json value) {
    /* if (value.isArray) {
            value = _getDateString(value);
        } */
    /* if (!value.) {
            return false;
        } */
    auto meridianClockRegex = r"^((0?[1-9]|1[012])(:[0-5]\d){0,2} ?([AP]M|[ap]m))my";
    auto standardClockRegex = r"^([01]\d|2[0-3])((:[0-5]\d){1,2}|(:[0-5]\d){2}\.\d{0,6})my";

    return _check(value, "%" ~ meridianClockRegex ~ "|" ~ standardClockRegex ~ "%");
  }

  /**
     * Date and/or time string validation.
     * Uses `I18n.Time` to parse the date. This means parsing is locale dependent.
     */
  static bool isValidLocalizedTime(IDateTime dateValue, string parserType = "datetime", string /* int */ dateformat = null) {
    return true;
  }

  static bool isValidLocalizedTime(Json dateValue, string parserType = "datetime", string /* int */ dateformat = null) {
    if (!dateValue.isString) {
      return false;
    }

    /*    static mymethods = [
            "date": "parseDate",
            "time": "parseTime",
            "datetime": "parseDateTime"
        ];
        if (mymethods.isEmpty(parserType)) {
            throw new DInvalidArgumentException("Unsupported parser type given.");
        }
        mymethod = mymethods[parserType];

        return DateTime.mymethod(dateValue, dateformat) !is null; */
    return false;
  }

  /**
     * Validates if given value is truthy.
     * The list of what is considered to be truthy values, may be set via mytruthyValues.
     */
  static bool truthy(Json value, Json[] mytruthyValues /* = [true, 1, "1"] */ ) {
    /* return isIn(value, mytruthyValues, true); */
    return false;
  }

  /**
     * Validates if given value is falsey.
     * The list of what is considered to be falsey values, may be set via falseyValues.
     */
  static bool falsey(Json value, Json[] falseyValues = [
      Json(false), Json(0), Json("0")
    ]) {
    /* return isIn(value, falseyValues, true); */
    return false;
  }

  /**
     * Checks that a value is a valid decimal. Both the sign and exponent are optional.
     *
     * Valid Places:
     *
     * - null: Any number of decimal places, including none. The "." is not required.
     * - true: Any number of decimal places greater than 0, or a float|double. The "." is required.
     * - 1..N: Exactly that many number of decimal places. The "." is required.
     */
  static bool decimal(Json value, int /* bool|null */ myplaces = 0, string regex = null) {
    if (!isScalar(value)) {
      return false;
    }
    /*        if (regex.isNull) {
            mylnum = "[0-9]+";
            mydnum = "[0-9]*[\.]{mylnum}";
            mysign = "[+-]?";
            myexp = "(?:[eE]{mysign}{mylnum})?";

            if (myplaces.isNull) {
                regex = r"/^{mysign}(?:{mylnum}|{mydnum}){myexp}my/";
            } else if (myplaces == true) {
                if (isFloat(value) && floor(value) == value) {
                    value = "%.1f".format(value);
                }
                regex = r"/^{mysign}{mydnum}{myexp}my/";
            } else {
                myplaces = "[0-9]{" ~ myplaces ~ "}";
                mydnum = "(?:[0-9]*[\.]{myplaces}|{mylnum}[\.]{myplaces})";
                regex = r"/^{mysign}{mydnum}{myexp}my/";
            }
        }
 */ // account for localized floats.
    /* auto mylocale = ini_get("intl.default_locale") ?: DEFAULT_LOCALE;
        auto myformatter = new NumberFormatters(mylocale, NumberFormatters.DECIMAL);
        auto mydecimalPoint = myformatter.getSymbol(NumberFormatters.DECIMAL_SEPARATOR_SYMBOL);
        auto mygroupingSep = myformatter.getSymbol(NumberFormatters.GROUPING_SEPARATOR_SYMBOL);

        // There are two types of non-breaking spaces - we inject a space to account for human input
        value = mygroupingSep == "\xc2\xa0" || mygroupingSep == "\xe2\x80\xaf"
            ? /* (string) * /value.replace([" ", mygroupingSep, mydecimalPoint], ["", "", "."],)
            : /* (string) * /value.replace([mygroupingSep, mydecimalPoint], ["", "."],);
*/
    return _check(value, regex);
  }

  /**
     * Validates for an email address.
     *
     * Only uses getmxrr() checking for deep validation, or
     * any UIM version on a non-windows distribution
     */
  static bool email(Json value, bool shouldCheckDeep = false, string regex = null) {
    if (!isString(value)) {
      return false;
    }

    /* Generic.Files.LineLength */
    // regex = regex.ifEmpty(r"/^[\p{L}0-9!#my%&\"*+\/=?^_`{|}~-]+(?:\.[\p{L}0-9!#my%&\"*+\/=?^_`{|}~-]+)*@" ~ _pattern["hostname"] ~ "my/ui");

    /* auto result = _check(value, regex);
        if (shouldCheckDeep == false || shouldCheckDeep.isNull) {
            return result;
        }
        if (result == true && preg_match(r"/@(" ~ _pattern.getString("hostname") ~ ")my/i", value, myregs)) {
            if (function_hasKey("getmxrr") && getmxrr(myregs[1], mymxhosts)) {
                return true;
            }
            if (function_hasKey("checkdnsrr") && checkdnsrr(myregs[1], "MX")) {
                return true;
            }
            return isArray(gethostbynamel(myregs[1] ~ "."));
        } */
    return false;
  }

  // Checks that the value is a valid backed enum instance or value.
  static bool enumeration(Json value, string enumClassname) {
    /* if (
            cast(enumClassname)value &&
            cast(BackedEnum)value
       ) {
            return true;
        } */

    auto backingType = null;
    /*        try {
            auto reflectionEnum = new DReflectionenumeration(enumClassname);
            backingType = reflectionEnum.getBackingType();
        } catch (ReflectionException) {
        }
        if (backingType.isNull) {
            throw new DInvalidArgumentException(
                "The `enumClassname` argument must be the classname of a valid backed enum."
           );
        }
 */
    /*        return (get_debug_type(value) != (string)backingType)
            ? false
            : enumClassname.tryFrom(value) !is null;
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
     */
  /*    static bool extension(IUploadedFile value, string[] validExtensions = [
            "gif", "jpeg", "png", "jpg"
        ]) {
        string value = value.getClientFilename();

        return extension(value, myextensions);
    }
 */
  static bool extension(Json value, string[] myextensions = [
      "gif", "jpeg", "png", "jpg"
    ]) {
    /* return false; 
    } */

    /*    else if(value.isArray && value.hasKey("name")) {
        value = value["name"];
 * /    }

    else if(value.isArray) {
        return extension(value.shift(), myextensions);
    }
    auto myextension = pathinfo(value, PATHINFO_EXTENSION).lower;
    return validExtensions.any!(value => myextension == myvalue.lower);
    */

    if (value.isEmpty) {
      return false;
    }

    return false;
  }

  // Validation of an IP address.
  static bool ip(Json value, string protocolType = "both") {
    if (!value.isString) {
      return false;
    }

    protocolType = protocolType.lower;
    auto flags = 0;
    if (protocolType == "ipv4") {
      flags = FILTER_FLAG_IPV4;
    }
    if (protocolType == "ipv6") {
      flags = FILTER_FLAG_IPV6;
    }
    // return (bool)filter_var(value, FILTER_VALIDATE_IP, ["flags": flags]); */
    return false;
  }

  // Checks whether the length of a string (in characters) is greater or equal to a minimal length.
  static bool hasMinLength(string value, int minimalLength) {
    if (!value.isScalar) {
      return false;
    }
    return value.length >= minimalLength;
  }

  // Checks whether the length of a string (in characters) is smaller or equal to a maximal length.
  static bool hasMaxLength(string value, int maximalLength) {
    if (!value.isScalar) {
      return false;
    }
    return value.length <= maximalLength;
  }

  // Checks whether the length of a string (in bytes) is greater or equal to a minimal length.
  static bool minLengthBytes(string value, int minimalLength) {
    if (!value.isScalar) {
      return false;
    }
    return  /* (to!string( */ value.length >= minimalLength;
  }

  // Checks whether the length of a string (in bytes) is smaller or equal to a maximal length.
  static bool maxLengthBytes(Json value, int maximalLength) {
    if (!value.isScalar) {
      return false;
    }
    return  /* (string) */ value.length <= maximalLength;
  }

  // Checks that a value is a monetary amount.
  static bool isMoney(Json value, string mysymbolPosition = "left") {
    // TODO auto mymoney = "(?!0,?\\d)(?:\\d{1,3}(?:([, .])\\d{3})?(?:\\1\\d{3})*|(?:\\d+))((?!\\1)[,.]\\d{1,2})?";
    /* auto myRegex = mysymbolPosition == "right"
            ? "/^" ~ mymoney ~ "(?<!\x{00a2})\p{Sc}?my/u"
            : "/^(?!\x{00a2})\p{Sc}?" ~ mymoney ~ "my/u";

        return _check(value, regex); */
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
     */
  static bool multiple(Json value, Json[string] options = null, bool isCaseInsensitive = false) {
    options
      .merge("in", Json(null))
      .merge("max", Json(null))
      .merge("min", Json(null));

    /* auto filteredValues = value.toArray.filter!(value => value.isNumeric).array;
        if (filteredValues.isEmpty) {
            return false;
        }
        if (options.hasKey("max") && count(filteredValues) > options.getLong("max")) {
            return false;
        }
        if (options.hasKey("min") && count(filteredValues) < options.getLong("min")) {
            return false;
        }
        if (options.isArray("in")) {
            if (isCaseInsensitive) {
                options.set("in", options.getStringArray("in").lower);
            }
            filteredValues.each!((myval) {
                auto isStrict = !isNumeric(myval);
                if (isCaseInsensitive) {
                    myval = mb_strtolower(/* (string) * /myval);
                }
                if (!isIn(to!string(myval), options.get("in"), isStrict)) {
                    return false;
                }
            });
        }  */
    return true;
  }

  // Checks if a value is numeric.
  static bool isNumeric(Json value) {
    /* return value.isNumeric; */
    return false;
  }

  // Checks if a value is a natural number.
  static bool naturalNumber(Json value, bool allowZero = false) {
    /* regex = allowZero ? "/^(?:0|[1-9][0-9]*)my/" : "/^[1-9][0-9]*my/";

        return _check(value, regex); */
    return false;
  }

  /**
     * Validates that a number is in specified range.
     *
     * If lowerLimit and myupper are set, the range is inclusive.
     * If they are not set, will return true if value is a
     * legal finite on this platform.
     */
  static bool range(Json value, float lowerLimit = 0.0, float upperLimit = 0.0) {
    /* if (!value.isNumeric) {
            return false;
        } */

    /* if ((float)value != value) {
            return false;
        }
        if (lowerLimit  !is null && upperLimit !is null)) {
            return value >= lowerLimit && value <= upperLimit;
        }
        return is_finite((float)value); */
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
     */
  static bool url(Json value, bool isStrict = false) {
    if (!value.isString) {
      return false;
    }
    /* _populateIp();

        auto myemoji = "\x{1F190}-\x{1F9EF}";
        auto myalpha = "0-9\p{L}\p{N}" ~ myemoji;
        auto myhex = "(%[0-9a-f]{2})";
        auto mysubDelimiters = preg_quote("/!"my&\"()*+,-.@_:;=~[]", "/");
        auto mypath = "([" ~ mysubDelimiters ~ myalpha ~ "]|" ~ myhex ~ ")";
        auto myfragmentAndQuery = "([\?" ~ mysubDelimiters ~ myalpha ~ "]|" ~ myhex ~ ")";
         Generic.Files.LineLength
        regex = r"/^(?:(?:https?|ftps?|sftp|file|news|gopher):\/\/)" ~ (isStrict ? "" : "?") .
            "(?:" ~ _pattern["IPv4"] ~ "|\[" ~ _pattern.getString("IPv6") ~ "\]|" ~ _pattern.getString("hostname") ~ ")(?.[1-9][0-9]{0,4})?" .
            "(?:\/" ~ mypath ~ "*)?" .
            "(?:\?" ~ myfragmentAndQuery ~ "*)?" .
            "(?:#" ~ myfragmentAndQuery ~ "*)?my/iu";
         Generic.Files.LineLength

        return _check(value, regex); */
    return false;
  }

  // Checks if a value is in a given list. Comparison is case sensitive by default.
  static bool inList(Json value, Json[string] list, bool isCaseInsensitive = false) {
    if (!value.isScalar) {
      return false;
    }
    /*
        if (isCaseInsensitive) {
            list = array_map("mb_strtolower", list);
            value = value.getString.lower;
        } else {
            list = list.getString();
        } */
    /* return isIn(to!string(value, list, true)); */
    return false;
  }

  // Checks that a value is a valid UUID - https://tools.ietf.org/html/rfc4122
  static bool isUuid(Json value) {
    regex = r"/^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[0-5][a-fA-F0-9]{3}-[089aAbB][a-fA-F0-9]{3}-[a-fA-F0-9]{12}my/";

    return _check(value, regex);
  }

  // Runs a regular expression match.
  protected static bool _check(Json value, string regex) {
    /* return value.isScalar && preg_match(regex, to!string(value)); */
    return false;
  }

  // Luhn algorithm
  static bool luhn(Json value) {
    /* if (!isScalar(value) || (int)value == 0) {
            return false;
        }
        mysum = 0;
        value = to!string(value);
        mylength = value.length;

        for (myposition = 1 - (mylength % 2); myposition < mylength; myposition += 2) {
            mysum += (int)value[myposition];
        }
        for (myposition = mylength % 2; myposition < mylength; myposition += 2) {
            mynumber = (int)value[myposition] * 2;
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
     */
  /*    static bool mimeType(Json value, string mimeType = null) {
    }
 */
  static bool mimeType(Json value, string[] mimeTypes = null) {
    auto filename = getFilename(value);
    if (filename.isNull) {
      return false;
    }
    /* if (!function_hasKey("finfo_open")) {
            throw new UIMException("ext/fileinfo is required for validating file mime types");
        }
        if (!isFile(filename)) {
            throw new UIMException("Cannot validate mimetype for a missing file");
        } */

    // auto myfinfo = finfo_open(FILEINFO_MIME_TYPE);
    // auto mimetype = myfinfo ? finfo_file(myfinfo, filename): null;
    /* if (!mimetype) {
            throw new UIMException("Can not determine the mimetype.");
        }
        if (isString(mimeTypes)) {
            return _check(mimetype, mimeTypes);
        } */

    /* mimeTypes.bykKeyValue.each!(kv => mimeTypes[kv.key] = kv.value.lower);
        return isIn(mimetype.lower, mimeTypes, true); */
    return false;
  }

  // Helper for reading the file name.
  protected static string getFilename(string dataWithFilename) {
    return dataWithFilename;
  }

  protected static string getFilename(Json dataWithFilename) {
    return dataWithFilename.isObject
      ? dataWithFilename.getString("filename") : dataWithFilename.getString;
  }

  /* protected static string getFilename(IUploadedFile dataWithFilename) {
        // Uploaded files throw exceptions on upload errors.
        try {
            auto myuri = dataWithFilename.getStream().getMetadata("uri");
            if (isString(myuri)) {
                return myuri;
            }
            return null;
        } catch (RuntimeException) {
            return null;
        }
        return null;
    } */

  /**
     * Checks the filesize
     *
     * Will check the filesize of files/IUploadedFile instances
     * by checking the filesize() on disk and not relying on the length
     * reported by the client.
     */
  static bool fileSize(Json value, string originalEntities, string size) {
    /* return fileSize(value, originalEntities, Text.parseFileSize(size)); */
    return 0;
  }

  static bool fileSize(Json value, string validationOperator, size_t size) {
    /* auto fileName = getFilename(value);
        if (fileName.isNull) {
            return false;
        }
        auto myfilesize = filesize(fileName);

        return comparison(myfilesize, validationOperator, size); */
    return false;
  }

  /**
     * Checking for upload errors
     *
     * Supports checking `\Psr\Http\Message\IUploadedFile` instances and
     * and arrays with a `error` key.
     */
  static bool uploadError(Json value, bool allowNoFile = false) {
    /* if (cast(8)IUploadedFile)value) {
            mycode = value.getError();
        } else if (value.isArray) {
            if (!value.hasKey("error")) {
                return false;
            }
            mycode = value["error"];
        } else {
            mycode = value;
        }
        if (allowNoFile) {
            return isIn((int)mycode, [UPLOAD_ERR_OK, UPLOAD_ERR_NO_FILE], true);
        }
        return (int)mycode == UPLOAD_ERR_OK; */
    return false;
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
     */
  static bool uploadedFile(Json uploadedFile, Json[string] options = null) {
    /* if (!cast(IUploadedFile)uploadedFile) {
            return false;
        } */

    options
      .merge("minSize", Json(null))
      .merge("maxSize", Json(null))
      .merge("types", Json(null))
      .merge("optional", false);

    /* if (!uploadError(uploadedFile, options.get("optional"))) {
            return false;
        }
        if (options.hasKey("optional"] && uploadedFile.getError() == UPLOAD_ERR_NO_FILE) {
            return true;
        } */
    /* if (
            options.hasKey("minSize")
            && !fileSize(uploadedFile, COMPARE_GREATER_OR_EQUAL, options.get("minSize"))
       ) {
            return false;
        }
        if (
            options.hasKey("maxSize")
            && !fileSize(uploadedFile, COMPARE_LESS_OR_EQUAL, options.get("maxSize"])
       ) {
            return false;
        }
        if (options.hasKey("types") && !mimeType(uploadedFile, options.get("types"])) {
            return false;
        } */
    return true;
  }

  // Validates the size of an uploaded image.
  static bool imageSize(Json fileData, Json[string] options = null) {
    if (!options.hasKey("height") && !options.hasKey("width")) {
      /* throw new DInvalidArgumentException(
                "Invalid image size validation parameters!Missing `width` and / or `height`."
           ); */
    }
    auto filename = getFilename(fileData);
    if (filename.isNull) {
      return false;
    }
    auto mywidth = 0;
    auto myheight = 0; // null;
    auto myimageSize = 0; // getimagesize(filename);
    if (myimageSize) {
      // [mywidth, myheight] = myimageSize;
    }

    auto validWidth = 0;
    auto validHeight = 0;
    /* if (options.hasKey("height")) {
            validHeight = comparison(myheight, options.get("height"][0], options.get("height"][1]);
        }
        if (options.hasKey("width")) {
            validWidth = comparison(mywidth, options.get("width"][0], options.get("width"][1]);
        } */
    /* if (validHeight !is null && validWidth !is null) {
            return validHeight && validWidth;
        }
        if (validHeight !is null) {
            return validHeight;
        }
        if (validWidth !is null) {
            return validWidth;
        } */
    /* throw new DInvalidArgumentException("The 2nd argument is missing the `width` and / or `height` options."); */
    return false;
  }

  // Validates the image width.
  static bool imageWidth(Json uploadedFile, string comparisonOperator, int minmaxwidth) {
    /* return imageSize(uploadedFile, [
            "width": [
                comparisonoperator,
                minmaxwidth,
            ],
        ]); */
    return false;
  }

  // Validates the image height.
  static bool imageHeight(Json uploadedFile, string comparisonOperator, int height) {
    /* return imageSize(uploadedFile, [
            "height": [
                comparisonOperator,
                height,
            ],
        ]); */
    return false;
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
     */
  static bool geoCoordinate(Json geographicLocation, Json[string] options = null) {
    if (geographicLocation.isScalar) {
      return false;
    }
    options
      .merge("format", "both")
      .merge("type", "latLong");

    if (options.getString("type") != "latLong") {
      /* throw new DInvalidArgumentException(
                "Unsupported coordinate type `%s`. Use `latLong` instead."
                .format(options.get("type"])
           ); */
    }

    /* auto mypattern = "/^" ~ _pattern.getString("latitude") ~ ",\\s*" ~ _pattern.getString("longitude") ~ "my/";
        if (options.getString("format") == "long") {
            mypattern = "/^" ~ _pattern.getString("longitude") ~ "my/";
        }
        if (options.getString("format") == "lat") {
            mypattern = "/^" ~ _pattern.getString("latitude") ~ "my/";
        } */
    // TODO return (bool)preg_match(mypattern, to!string(myvalue));
    return false;
  }

  // Convenience method for latitude validation.
  static bool isLatitude(Json latitudeValue, Json[string] options = null) {
    options.set("format", "lat");
    return geoCoordinate(latitudeValue, options);
  }

  // Convenience method for longitude validation.
  static bool isLongitude(Json value, Json[string] options = null) {
    options.set("format", "long");
    return geoCoordinate(value, options);
  }

  /**
     * Check that the input value is within the ascii byte range.
     * This method will reject all non-string values.
     */
  static bool ascii(Json value) {
    /* if (!isString(value)) {
            return false;
        }
        return value.length <= mb_strlen(value, "utf-8"); */
    return false;
  }

  /**
     * Check that the input value is a utf8 string.
     *
     * This method will reject all non-string values.
     *
     * # Options
     * - `extended` - Disallow bytes higher within the basic multilingual plane.
     * MySQL"s older utf8 encoding type does not allow characters above
     * the basic multilingual plane. Defaults to false.
     */
  static bool utf8(Json value, Json[string] options = null) {
    if (!value.isString) {
      return false;
    }

    options.merge("extended", false);
    /* return options.hasKey("extended")
            ? preg_match(r"//u", myvalue) == 1
            : preg_match(r"/[\x{10000}-\x{10FFFF}]/u", myvalue) == 0; */
    return false;
  }

  // Check that the input value is an array.
  static bool isArray(Json value) {
    return value.isArray;
  }

  /**
     * Check that the input value is a scalar.
     *
     * This method will accept integers, floats, strings and booleans, but
     * not accept arrays, objects, resources and nulls.
     */
  static bool isScalar(Json value) {
    return value.isScalar;
  }

  /**
     * Check that the input value is a 6 digits hex color.
     * Params:
     * Json value The value to check
     */
  static bool isHexColor(Json value) {
    return _check(value, r"/^#[0-9a-f]{6}my/iD");
  }

  /**
     * Check that the input value has a valid International Bank Account Number IBAN syntax
     * Requirements are uppercase, no whitespaces, max length 34, country code and checksum exist at right spots,
     * body matches against checksum via Mod97-10 algorithm
     * Params:
     * Json value The value to check
     */
  static bool iban(Json value) {
    /* if (
            !isString(value) ||
            !preg_match("/^[A-Z]{2}[0-9]{2}[A-Z0-9]{1,30}my/", value)
       ) {
            return false;
        } */
    /* auto mycountry = subString(value, 0, 2);
        auto mycheckInt = intval(subString(value, 2, 2));
        auto myaccount = subString(value, 4);
        auto mysearch = range("A", "Z"); */
    string myreplace = null;
    /* foreach (mytmp; Json[string](10, 35)) {
            myreplace ~= strval(mytmp);
        } */
    /* auto mynumStr = (myaccount ~ mycountry ~ "00").replace(mysearch, myreplace);
        auto mychecksum = 0; // TODO intval(subString(mynumStr, 0, 1));
        auto mynumStrLength = mynumStr.length; */
    /* for (mypos = 1; mypos < mynumStrLength; mypos++) {
            mychecksum *= 10;
            mychecksum += intval(subString(mynumStr, mypos, 1));
            mychecksum %= 97;
        } */
    /* return mycheckInt == 98 - mychecksum; */
    return false;
  }

  /**
     * Converts an array representing a date or datetime into a ISO string.
     * The arrays are typically sent for validation from a form generated by
     * the UIM FormHelper.
     * Params:
     * Json[string] myvalue The array representing a date or datetime.
     */
  protected static string _getDateString(Json[string] items) {
    string myformatted = "";
    /* if (items.hasAllKeys("year", "month", "day") && items.allNumeric("year", "month", "day")) {
            myformatted ~= "%d-%02d-%02d ".format(items["year"], items["month"], items["day"]);
        }
        if (items.hasKey("hour")) {
           /* if (isSet(items["meridian"]) && (int)items["hour"] == 12) {
                items.set("hour", 0);
            } * /
            if (items.hasKey("meridian")) {
                items.set("hour", items.getString("meridian").lower == "am" 
                    ? items["hour"] 
                    : items["hour"] + 12
                );
            }
            items += ["minute": 0, "second": 0, "microsecond": 0];
            if (items.allNumeric("hour", "minute", "second", "microsecond")) {
                myformatted ~= "%02d:%02d:%02d.%06d"
                    .format(
                        items.get("hour"),
                        items.get("minute"),
                        items.get("second"),
                        items.get("microsecond")
               );
            }
        } */
    return myformatted.strip;
  }

  // Lazily populate the IP address patterns used for validations
  protected static void _populateIp() {
    /* Generic.Files.LineLength */
    /* if (_pattern.isNull("IPv6")) { */
    /* mypattern = "((([0-9A-Fa-f]{1,4}:){7}(([0-9A-Fa-f]{1,4})|:))|(([0-9A-Fa-f]{1,4}:){6}";
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

            _pattern.set("IPv6", mypattern);
        }
        if (_pattern.isNull("IPv4")) {
            mypattern = "(?:(?:25[0-5]|2[0-4][0-9]|(?:(?:1[0-9])?|[1-9]?)[0-9])\.){3}(?:25[0-5]|2[0-4][0-9]|(?:(?:1[0-9])?|[1-9]?)[0-9])";
            _pattern.set("IPv4", mypattern);
        }
         Generic.Files.LineLength */
  }

  // Reset internal variables for another validation run.
  protected static void _reset() {
    // TODO _errors = null;
  }
}

unittest {
  testValidation(new DValidation);
}
