module uim.i18n.classes.datetime;

import uim.i18n;

@safe:

/**
 * : the built-in DateTime class to provide handy methods and locale-aware
 * formatting helpers.
 */
class DateTime /* : Chronos, JsonSerializable */ {
    mixin TConfigurable;
    // TODO mixin TDateFormat;

    this() {
        initialize;
    }

    bool initialize(Json[string] initData = null) {
        return true;
    }

    mixin(TProperty!("string", "name"));

    /**
     * The default locale to be used for displaying formatted date strings.
     *
     * Use setDefaultLocale() and getDefaultLocale() instead.
     */
    protected string _defaultLocale;

    /**
     * Whether lenient parsing is enabled for IntlDateFormatters.
     *
     * Defaults to true which is the default for IntlDateFormatters.
     */
    protected bool _lenientParsing = true;

    /**
     * The format to use when formatting a time using `UIM\I18n\DateTime.i18nFormat()`
     * and `__toString`. This format is also used by `parseDateTime()`.
     *
     * The format should be either the formatting constants from IntlDateFormatter as
     * described in (https://secure.d.net/manual/en/class.intldateformatter.d) or a pattern
     * as specified in (https://unicode-org.github.io/icu-docs/apidoc/released/icu4c/classSimpleDateFormat.html#details)
     *
     * It is possible to provide an array of 2 constants. In this case, the first position
     * will be used for formatting the date part of the object and the second position
     * will be used to format the time part.
     *
     * @var array<int>|string|int
     */
    protected string[] _toStringFormat = [
       /* IntlDateFormatterss.SHORT, IntlDateFormatterss.SHORT */
    ];

    /**
     * The format to use when converting this object to Json.
     *
     * The format should be either the formatting constants from IntlDateFormatter as
     * described in (https://secure.d.net/manual/en/class.intldateformatter.d) or a pattern
     * as specified in (https://unicode-org.github.io/icu-docs/apidoc/released/icu4c/classSimpleDateFormat.html#details)
     *
     * It is possible to provide an array of 2 constants. In this case, the first position
     * will be used for formatting the date part of the object and the second position
     * will be used to format the time part.
     *
     * @var \Closure|array<int>|string|int
     */
    protected /* Closure */ string[] /* int */ _jsonEncodeFormat = [
        "yyyy-MM-dd'T'HH':'mm':'ssxxx'"
    ];

    /**
     * The format to use when formatting a time using `UIM\I18n\DateTime.nice()`
     *
     * The format should be either the formatting constants from IntlDateFormatter as
     * described in (https://secure.d.net/manual/en/class.intldateformatter.d) or a pattern
     * as specified in (https://unicode-org.github.io/icu-docs/apidoc/released/icu4c/classSimpleDateFormat.html#details)
     *
     * It is possible to provide an array of 2 constants. In this case, the first position
     * will be used for formatting the date part of the object and the second position
     * will be used to format the time part.
     *
     * @var array<int>|string|int
     */
    // string[] niceFormat = [IntlDateFormatters.MEDIUM, IntlDateFormatters.SHORT];

    /**
     * The format to use when formatting a time using `UIM\I18n\DateTime.timeAgoInWords()`
     * and the difference is more than `UIM\I18n\DateTime.wordEnd`
     *
     * @var array<int>|string|int
     */
    string[] wordFormat = [/* IntlDateFormatterss.SHORT, IntlDateFormatters.NONE */];

    /**
     * The format to use when formatting a time using `DateTime.timeAgoInWords()`
     * and the difference is less than `DateTime.wordEnd`
     */
    STRINGAA wordAccuracy = [
        "year": "day",
        "month": "day",
        "week": "day",
        "day": "hour",
        "hour": "minute",
        "minute": "minute",
        "second": "second",
    ];

    // The end of relative time telling
    string awordEnd = "+1 month";

    // serialise the value as a Unix Timestamp
    const string UNIX_TIMESTAMP_FORMAT = "unixTimestampFormat";

    // Gets the default locale.
    string getDefaultLocale() {
        return _defaultLocale;
    }

    /**
     * Sets the default locale.
     *
     * Set to null to use IntlDateFormatter default.
     */
    void setDefaultLocale(string localeName = null) {
        _defaultLocale = localeName;
    }

    // Gets whether locale format parsing is set to lenient.
    bool lenientParsingEnabled() {
        return _lenientParsing;
    }

    // Enables lenient parsing for locale formats.
    void enableLenientParsing() {
        _lenientParsing = true;
    }

    // Enables lenient parsing for locale formats.
    void disableLenientParsing() {
        _lenientParsing = false;
    }

    /**
     * Sets the default format used when type converting instances of this type to string
     *
     * The format should be either the formatting constants from IntlDateFormatter as
     * described in (https://secure.d.net/manual/en/class.intldateformatter.d) or a pattern
     * as specified in (https://unicode-org.github.io/icu-docs/apidoc/released/icu4c/classSimpleDateFormat.html#details)
     *
     * It is possible to provide an array of 2 constants. In this case, the first position
     * will be used for formatting the date part of the object and the second position
     * will be used to format the time part.
     */
    void setToStringFormat(/* array<int>|string|int */ string format) {
        _toStringFormat = [format];
    }

    // Resets the format used to the default when converting an instance of this type to a string
    void resetToStringFormat() {
        // setToStringFormat([cast(string)IntlDateFormatters.SHORT, cast(string)IntlDateFormatters.SHORT]);
    }

    /**
     * Sets the default format used when converting this object to Json
     *
     * The format should be either the formatting constants from IntlDateFormatter as
     * described in (https://secure.d.net/manual/en/class.intldateformatter.d) or a pattern
     * as specified in (http://www.icu-project.org/apiref/icu4c/classSimpleDateFormat.html#details)
     *
     * It is possible to provide an array of 2 constants. In this case, the first position
     * will be used for formatting the date part of the object and the second position
     * will be used to format the time part.
     *
     * Alternatively, the format can provide a callback. In this case, the callback
     * can receive this datetime object and return a formatted string.
     */
    // void setJsonEncodeFormat(Closure  format) {
    // void setJsonEncodeFormat(string[]|int format) {
    void setJsonEncodeFormat( /* Closure */ string[] /* int */ format) {
        _jsonEncodeFormat = format;
    }

    /**
     * Returns a new DTime object after parsing the provided time string based on
     * the passed or configured date time format. This method is locale dependent,
     * Any string that is passed to this auto will be interpreted as a locale
     * dependent string.
     *
     * When no format is provided, the `toString` format will be used.
     *
     * Unlike DateTime, the time zone of the returned instance is always converted
     * to `timezone` (default time zone if null) even if the `time` string specified a
     * time zone. This is a limitation of IntlDateFormatters.
     *
     * If it was impossible to parse the provided time, null will be returned.
     *
     * Example:
     *
     * ```
     * time = DateTime.parseDateTime("10/13/2013 12:54am");
     * time = DateTime.parseDateTime("13 Oct, 2013 13:54", "dd MMM, y H:mm");
     * time = DateTime.parseDateTime("10/10/2015", [IntlDateFormatters.SHORT, IntlDateFormatters.NONE]);
     * ```
     */
    auto parseDateTime(
        string timeToParse,
        int format = 0, /* DateTimeZone| */
        string timezone = null
    ) {
        return parseDateTime(timeToParse, [to!string(format)], timezone);
    }

    auto parseDateTime(
        string timeToParse,
        string[] format = null, /* DateTimeZone| */
        string timezone = null
    ) {
        format = format ? format : _toStringFormat;
        // return _parseDateTime(time, format, timezone);
        return "";
    }

    /**
     * Returns a new DTime object after parsing the provided date string based on
     * the passed or configured date time format. This method is locale dependent,
     * Any string that is passed to this auto will be interpreted as a locale
     * dependent string.
     *
     * When no format is provided, the `wordFormat` format will be used.
     *
     * If it was impossible to parse the provided time, null will be returned.
     *
     * Example:
     *
     * ```
     * time = DateTime.parseDate("10/13/2013");
     * time = DateTime.parseDate("13 Oct, 2013", "dd MMM, y");
     * time = DateTime.parseDate("13 Oct, 2013", IntlDateFormatters.SHORT);
     * ```
     */
    // TODO auto parseDate(string dateToParse, int format)
    // }

    auto parseDate(string adate, string[] format = null) {
        /* format ??= wordFormat;
        if (isInteger(format)) {
            format = [format, IntlDateFormatters.NONE];
        }
        return parseDateTime(date, format); */
        return "";
    }

    /**
     * Returns a new DTime object after parsing the provided time string based on
     * the passed or configured date time format. This method is locale dependent,
     * Any string that is passed to this auto will be interpreted as a locale
     * dependent string.
     *
     * When no format is provided, the IntlDateFormatters.SHORT format will be used.
     *
     * If it was impossible to parse the provided time, null will be returned.
     *
     * Example:
     *
     * ```
     * time = DateTime.parseTime("11:23pm");
     * ```
     */
    auto parseTime(string timeToParse, int format) {
        string[] formats = [/* IntlDateFormatters.NONE, to!string(format) */];
        return parseTime(timeToParse, formats);
    }

    auto parseTime(string atitimeToParseme, string[] format = null) {
        format = format ? format : [/* 
            IntlDateFormatters.NONE, IntlDateFormatters.SHORT */
        ];

        return parseDateTime(timeToParse, format);
    }

    // Get the difference formatter instance.
    /* auto DRelativeTimeFormatter diffFormatter(DDifferenceII18NFormatter formatter = null) {
        if (formatter) {
            if (!cast(RelativeTimeFormatter) formatter) {
                throw new DInvalidArgumentException(
                    "Formatter for I18n must extend RelativeTimeFormatter.");
            }
            return diffFormatter = formatter;
        }
        
        return diffFormatter ? diffFormatter : new DRelativeTimeFormatter();
    } */

    /**
     * Returns a formatted string for this time object using the preferred format and
     * language for the specified locale.
     *
     * It is possible to specify the desired format for the string to be displayed.
     * You can either pass `IntlDateFormatter` constants as the first argument of this
     * function, or pass a full ICU date formatting string as specified in the following
     * resource: https://unicode-org.github.io/icu/userguide/format_parse/datetime/#datetime-format-syntax.
     *
     * Additional to `IntlDateFormatter` constants and date formatting string you can use
     * DateTime.UNIX_TIMESTAMP_FORMAT to get a unix timestamp
     *
     * ### Examples
     *
     * ```
     * time = new DateTime("2014-04-20 22:10");
     * time.i18nFormat(); // outputs '4/20/14, 10:10 PM' for the en-US locale
     * time.i18nFormat(\IntlDateFormatters.FULL); // Use the full date and time format
     * time.i18nFormat([\IntlDateFormatters.FULL, \IntlDateFormatters.SHORT]); // Use full date but short time format
     * time.i18nFormat("yyyy-MM-dd HH:mm:ss"); // outputs '2014-04-20 22:10'
     * time.i18nFormat(DateTime.UNIX_TIMESTAMP_FORMAT); // outputs '1398031800'
     * ```
     *
     * You can control the default format used through `DateTime.setToStringFormat()`.
     *
     * You can read about the available IntlDateFormatter constants at
     * https://secure.d.net/manual/en/class.intldateformatter.d
     *
     * If you need to display the date in a different timezone than the one being used for
     * this Time object without altering its internal state, you can pass a timezone
     * string or object as the second parameter.
     *
     * Finally, should you need to use a different locale for displaying this time object,
     * pass a locale string as the third parameter to this function.
     *
     * ### Examples
     *
     * ```
     * time = new DTime("2014-04-20 22:10");
     * time.i18nFormat(null, null, "de-DE");
     * time.i18nFormat(\IntlDateFormatters.FULL, "Europe/Berlin", "de-DE");
     * ```
     *
     * You can control the default locale used through `DateTime.setDefaultLocale()`.
     * If empty, the default will be taken from the `intl.default_locale` ini config.
     */
    string i18nFormat(
        /* array<int>|string */
        int format = 0, /* DateTimeZone| */
        string timezone = null,
        string localeName = null
    ) {
        string[] myFormat = [to!string(format), to!string(format)];
        return i18nFormat(myFormat, timezone, localeName);
    }

    string i18nFormat(
        string[] format, /* DateTimeZone| */
        string timezone = null,
        string localeName
    ) {
        /* if (format == DateTime.UNIX_TIMESTAMP_FORMAT) {
            return _getTimestamp();
        } */

        auto time = this;
        if (timezone) {
            /* time = time.setTimezone(timezone) */;
        }
        /* auto format = format.ifNull(_toStringFormat);
        auto localeName = localeName.ifEmpty(DateTime.getDefaultLocale());

        return _formatObject(time, format, localeName); */
        return null; 
    }

    /**
     * Returns a nicely formatted date string for this object.
     *
     * The format to be used is stored in the auto property `DateTime.niceFormat`.
     */
    string nice(/* DateTimeZone |  */string timezone = null, string localeName = null) {
        // return/* (string) */ this.i18nFormat(niceFormat, timezone, localeName);
        return null; 
    }

    /**
     * Returns either a relative or a formatted absolute date depending
     * on the difference between the current time and this object.
     *
     * ### Options:
     *
     * - `from`: another Time object representing the "now" time
     * - `format`: a fall back format if the relative time is longer than the duration specified by end
     * - `accuracy`: Specifies how accurate the date should be described /* (array) * /
     *   - year:   The format if years > 0   (default "day")
     *   - month:  The format if months > 0  (default "day")
     *   - week:   The format if weeks > 0   (default "day")
     *   - day:    The format if weeks > 0   (default "hour")
     *   - hour:   The format if hours > 0   (default "minute")
     *   - minute: The format if minutes > 0 (default "minute")
     *   - second: The format if seconds > 0 (default "second")
     * - `end`: The end of relative time telling
     * - `relativeString`: The printf compatible string when outputting relative time
     * - `absoluteString`: The printf compatible string when outputting absolute time
     * - `timezone`: The user timezone the timestamp should be formatted in.
     *
     * Relative dates look something like this:
     *
     * - 3 weeks, 4 days ago
     * - 15 seconds ago
     *
     * Default date formatting is d/M/YY e.g: on 18/2/09. Formatting is done internally using
     * `i18nFormat`, see the method for the valid formatting strings
     *
     * The returned string includes 'ago' or 'on' and assumes you'll properly add a word
     * like 'Posted ' before the auto output.
     *
     * NOTE: If the difference is one week or more, the lowest level of accuracy is day
      */
    string timeAgoInWords(Json[string] options = null) {
        // return diffFormatter().timeAgoInWords(this, options);
        return null; 
    }

    /**
     * Get list of timezone identifiers
     * Params:
     * string|int filter A regex to filter identifier
     * Or one of DateTimeZone class DConstants
     * options: If true (default value) groups the identifiers list by primary region.
     * Otherwise, an array containing `group`, `abbr`, `before`, and `after`
     * keys. Setting `group` and `abbr` to true will group results and append
     * timezone abbreviation in the display value. Set `before` and `after`
     * to customize the abbreviation wrapper.
     * /
    auto Json[string] listTimezones(
        string /* int * / regexFilter = null,
        string countryCode = null,
        Json[string] options = null
    ) {
        /* if (isBoolean(options)) {
            options = [
                "group": options,
            ];
        }
        defaults = [
            "group": true.toJson,
            "abbr": false.toJson,
            "before": " - ",
            "after": Json(null),
        ];
        auto updatedOptions = options.updatedefaults;
        auto anGroup = options.get("group");
        auto regex = null;
        if (isString(regexFilter)) {
            regex = filter;
            filter = null;
        }
        auto filter ? filter : DateTimeZone.ALL;
        anIdentifiers = DateTimeZone.listIdentifiers(filter, countryCode) ?  : [];

        if (regex) {
            foreach (aKey, timezone; anIdentifiers) {
                if (!preg_match(regex, timezone)) {
                    anIdentifiers.removeByKey((aKey);
                }
            }
        }
        if (anGroup) {
            auto anGroupedIdentifiers = null;
            auto now = time();
            auto before = options.get(
                "before");
            auto after = options.get("after");
            anIdentifiers.each!(
                (timezone) {
                string abbr = "";
                if (options["abbr"]) {
                    dateTimeZone = new DateTimeZone(timezone);
                    trans = dateTimeZone.getTransitions(now, now);
                    abbr = isSet(trans[0]["abbr"]) ?
                        before ~ trans[0]["abbr"] ~ after : "";
                }
                anItem = split("/", timezone, 2);
                if (isSet(anItem[1])) {
                    anGroupedIdentifiers[anItem[0]][timezone] = anItem[1] ~ abbr;
                } else {
                    anGroupedIdentifiers[anItem[0]] = [
                        timezone: anItem[0] ~ abbr
                    ];
                }
            });
            return anGroupedIdentifiers;
        }
        return array_combine(anIdentifiers, anIdentifiers); 
    } */

    // Returns a string that should be serialized when converting this object to Json
    string jsonSerialize() {
        /* return cast(DClosure) _jsonEncodeFormat
            ? call_user_func(_jsonEncodeFormat, this) : _i18nFormat(
                _jsonEncodeFormat); */
        return null; 
    }

    override string toString() {
        return /* (string) */ this.i18nFormat();
    }
}
