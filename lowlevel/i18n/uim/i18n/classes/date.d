/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.i18n.classes.date;

import uim.i18n;
@safe:

version (test_uim_i18n) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

/**
 * Date class provided by Chronos.
 *
 * Adds handy methods and locale-aware formatting helpers.
 */
class Date { // }: DChronosDate, JsonSerializable {
        mixin TConfigurable;

        this() {
        initialize;
    }

    bool initialize(Json[string] initData = null) {
        return true;
    }

    mixin(TProperty!("string", "name"));

    /*
    // TODO mixin TDateFormat;

    /**
     * The format to use when formatting a time using `UIM\I18n\Date.i18nFormat()`
     * and `__toString`.
     *
     * The format should be either the formatting constants from IntlDateFormatter as
     * described in (https://secure.d.net/manual/en/class.intldateformatter.d) or a pattern
     * as specified in (https://unicode-org.github.io/icu-docs/apidoc/released/icu4c/classSimpleDateFormat.html#details)
     *
     * @var string|int
     */
    /*    protected static string _toStringFormat = IntlDateFormatters.SHORT; */

    /**
     * The format to use when converting this object to Json.
     *
     * The format should be either the formatting constants from IntlDateFormatter as described in (https://secure.d.net/manual/en/class.intldateformatter.d) or a pattern
     * as specified in (https://unicode-org.github.io/icu-docs/apidoc/released/icu4c/classSimpleDateFormat.html#details)
     *
     * @var \/* * / string|int
     */
    /*    protected static string _JsonEncodeFormat = "yyyy-MM-dd"; */

    /**
     * The format to use when formatting a time using `UIM\I18n\Date.timeAgoInWords()`
     * and the difference is more than `UIM\I18n\Date.wordEnd`
     *
     * @var string|int
     */
    /*    static string wordFormat = IntlDateFormatters.SHORT; */

    /**
     * The format to use when formatting a time using `UIM\I18n\Date.nice()`
     *
     * The format should be either the formatting constants from IntlDateFormatter as
     * described in (https://secure.d.net/manual/en/class.intldateformatter.d) or a pattern
     * as specified in (https://unicode-org.github.io/icu-docs/apidoc/released/icu4c/classSimpleDateFormat.html#details)
     */
    /*    static string niceFormat = IntlDateFormatters.MEDIUM; */

    /**
     * The format to use when formatting a time using `Date.timeAgoInWords()`
     * and the difference is less than `Date.wordEnd`
     */
    /*    static string[] wordAccuracy = [
        "year": "day",
        "month": "day",
        "week": "day",
        "day": "day",
        "hour": "day",
        "minute": "day",
        "second": "day",
    ];

    // The end of relative time telling
    static string awordEnd = "+1 month"; */

    /**
     * Sets the default format used when type converting instances of this type to string
     *
     * The format should be either the formatting constants from IntlDateFormatter as
     * described in (https://secure.d.net/manual/en/class.intldateformatter.d) or a pattern
     * as specified in (https://unicode-org.github.io/icu-docs/apidoc/released/icu4c/classSimpleDateFormat.html#details)
     */
    /*    static void setToStringFormat(int format) {
        setToStringFormat(to!string(format));
    } */

    /*    static void setToStringFormat(string format) {
        _toStringFormat = format;
    } */

    /**
     * Sets the default format used when converting this object to Json
     *
     * The format should be either the formatting constants from IntlDateFormatter as
     * described in (https://secure.d.net/manual/en/class.intldateformatter.d) or a pattern
     * as specified in (http://www.icu-project.org/apiref/icu4c/classSimpleDateFormat.html#details)
     *
     * Alternatively, the format can provide a callback. In this case, the callback
     * can receive this object and return a formatted string.
     */
    /*    static void setJsonEncodeFormat(DClosure format) {
        _jsonEncodeFormat = format;
    } */

    /*    static void setJsonEncodeFormat(string format) {
        _jsonEncodeFormat = format;
    } */

    /**
     * Returns a new Date object after parsing the provided date string based on
     * the passed or configured format. This method is locale dependent,
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
     * time = Date.parseDate("10/13/2013");
     * time = Date.parseDate("13 Oct, 2013", "dd MMM, y");
     * time = Date.parseDate("13 Oct, 2013", IntlDateFormatters.SHORT);
     * ```
     */
    /*    static auto parseDate(string dateToParse, int format) {
        return parseDate(dateToParse, to!string(format));
    }

    static auto parseDate(string dateToParse, string format = null) {
        string checkedFormat = !format.isEmpty ? format : wordFormat;
        return _parseDateTime(dateToParse, checkedFormat);
    } */

    // Get the difference formatter instance.
    /**
     * Returns a formatted string for this time object using the preferred format and
     * language for the specified locale.
     *
     * It is possible to specify the desired format for the string to be displayed.
     * You can either pass `IntlDateFormatter` constants as the first argument of this
     * function, or pass a full ICU date formatting string as specified in the following
     * resource: https://unicode-org.github.io/icu/userguide/format_parse/datetime/#datetime-format-syntax.
     *
     * ### Examples
     *
     * ```
     * date = new Date("2014-04-20");
     * date.i18nFormat(); // outputs '4/20/14' for the en-US locale
     * date.i18nFormat(\IntlDateFormatters.FULL); // Use the full date format
     * date.i18nFormat("yyyy-MM-dd"); // outputs '2014-04-20'
     * ```
     *
     * You can control the default format used through `Date.setToStringFormat()`.
     *
     * You can read about the available IntlDateFormatter constants at
     * https://secure.d.net/manual/en/class.intldateformatter.d
     *
     * Should you need to use a different locale for displaying this time object,
     * pass a locale string as the third parameter to this function.
     *
     * ### Examples
     *
     * ```
     * date = new Date("2014-04-20");
     * time.i18nFormat(null, "de-DE");
     * time.i18nFormat(\IntlDateFormatters.FULL, "de-DE");
     * ```
     *
     * You can control the default locale used through `Date.setDefaultLocale()`.
     * If empty, the default will be taken from the `intl.default_locale` ini config.
     */
    /* string i18nFormat(int format, string localeName = null) {
        return i18nFormat(to!string(format), localeName);
    } */

    /*    string i18nFormat(string format = null, string localeName = null) {
        if (format == DateTime.UNIX_TIMESTAMP_FORMAT) {
            throw new DInvalidArgumentException("UNIT_TIMESTAMP_FORMAT is not supported for Date.");
        }
        localname = localeName.isEmpty ? DateTime.getDefaultLocale() : localeName;

        return _formatObject(this.native, format, localeName);
    } */

    /**
     * Returns a nicely formatted date string for this object.
     *
     * The format to be used is stored in the static property `Date.niceFormat`.
     * Params:
     * string localname The localname name in which the date should be displayed (e.g. pt-BR)
     */
    /*    string nice(string localeName = null) {
        return to!string(i18nFormat(niceFormat, localeName));
    } */

    /**
     * Returns either a relative or a formatted absolute date depending
     * on the difference between the current date and this object.
     *
     * ### Options:
     *
     * - `from`: another Date object representing the "now" date
     * - `format`: a fall back format if the relative time is longer than the duration specified by end
     * - `accuracy`: Specifies how accurate the date should be described /* (array) * /
     *   - year:   The format if years > 0   (default "day")
     *   - month:  The format if months > 0  (default "day")
     *   - week:   The format if weeks > 0   (default "day")
     *   - day:    The format if weeks > 0   (default "day")
     * - `end`: The end of relative date telling
     * - `relativeString`: The printf compatible string when outputting relative date
     * - `absoluteString`: The printf compatible string when outputting absolute date
     * - `timezone`: The user timezone the timestamp should be formatted in.
     *
     * Relative dates look something like this:
     *
     * - 3 weeks, 4 days ago
     * - 1 day ago
     *
     * Default date formatting is d/M/YY e.g: on 18/2/09. Formatting is done internally using
     * `i18nFormat`, see the method for the valid formatting strings.
     *
     * The returned string includes 'ago' or 'on' and assumes you'll properly add a word
     * like 'Posted ' before the auto output.
     *
     * NOTE: If the difference is one week or more, the lowest level of accuracy is day.
     */
    /* string timeAgoInWords(Json[string] options = new Json[string]) {
        return diffFormatter().dateAgoInWords(this, options);
    }

    // Returns a string that should be serialized when converting this object to Json
    string JsonSerialize() {
        return _i18nFormat(_jsonEncodeFormat);
    } */

    /*    override string toString() {
        return to!string(i18nFormat());
    } */
}
