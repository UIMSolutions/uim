module uim.i18n.classes.time;

import uim.i18n;

@safe:

/**
 * : time class provided by Chronos.
 *
 * Adds handy methods and locale-aware formatting helpers.
 */
class DTime { // : ChronosTime, JsonSerializable {
    mixin TConfigurable;
    // TODO mixin TDateFormat;

    this() {
        initialize;
    }

    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);
        
        return true;
    }

    // #region StringFormat
    /*
    /**
     * Sets the default format used when type converting instances of this type to string
     *
     * The format should be either the formatting constants from IntlDateFormatter as
     * described in (https://secure.d.net/manual/en/class.intldateformatter.d) or a pattern
     * as specified in (https://unicode-org.github.io/icu-docs/apidoc/released/icu4c/classSimpleDateFormat.html#details)
     * Params:
     * string|int format Format.
     */
    static void setToStringFormat(string format) {
        _toStringFormat = format;
    }
    
    // Resets the format used to the default when converting an instance of this type to a string
    static void resetToStringFormat() {
        setToStringFormat(IntlDateFormatter.SHORT);
    }
    // #endregion StringFormat

    /**
     * The format to use when formatting a time using `UIM\I18n\Time.i18nFormat()`
     * and `__toString`.
     *
     * The format should be either the formatting constants from IntlDateFormatter as
     * described in (https://secure.d.net/manual/en/class.intldateformatter.d) or a pattern
     * as specified in (https://unicode-org.github.io/icu-docs/apidoc/released/icu4c/classSimpleDateFormat.html#details)
     *
     * @var string|int
     */
    protected static string|int _toStringFormat = IntlDateFormatter.SHORT;

    /**
     * The format to use when converting this object to Json.
     *
     * The format should be either the formatting constants from IntlDateFormatter as
     * described in (https://secure.d.net/manual/en/class.intldateformatter.d) or a pattern
     * as specified in (https://unicode-org.github.io/icu-docs/apidoc/released/icu4c/classSimpleDateFormat.html#details)
     */
    protected static /*Closure|*/ string|int _JsonEncodeFormat = "HH':'mm':'ss";

    /**
     * The format to use when formatting a time using `UIM\I18n\Time.nice()`
     *
     * The format should be either the formatting constants from IntlDateFormatter as
     * described in (https://secure.d.net/manual/en/class.intldateformatter.d) or a pattern
     * as specified in (https://unicode-org.github.io/icu-docs/apidoc/released/icu4c/classSimpleDateFormat.html#details)
     *
     * @var string|int
     */
    static string|int niceFormat = IntlDateFormatter.MEDIUM;
    
    /**
     * Sets the default format used when converting this object to Json
     *
     * The format should be either the formatting constants from IntlDateFormatter as
     * described in (https://secure.d.net/manual/en/class.intldateformatter.d) or a pattern
     * as specified in (http://www.icu-project.org/apiref/icu4c/classSimpleDateFormat.html#details)
     *
     * Alternatively, the format can provide a callback. In this case, the callback
     * can receive this object and return a formatted string.
     *
     * @param \/*Closure|*/ string|int format Format.
     */
    static void setJsonEncodeFormat(/*Closure|*/ string|int format) {
        _JsonEncodeFormat = format;
    }
    
    /**
     * Returns a new DTime object after parsing the provided time string based on
     * the passed or configured date time format. This method is locale dependent,
     * Any string that is passed to this auto will be interpreted as a locale
     * dependent string.
     *
     * When no format is provided, the IntlDateFormatter.SHORT format will be used.
     *
     * If it was impossible to parse the provided time, null will be returned.
     *
     * Example:
     *
     * ```
     * time = Time.parseTime("11:23pm");
     * ```
     */
    static static parseTime(string timeToParse, string /* |int */ format = null) {
        format = format.ifEmpty([IntlDateFormatter.NONE, IntlDateFormatter.SHORT]);
        if (isInt(format)) {
            format = [IntlDateFormatter.NONE, format];
        }
        return _parseDateTime(timeToParse, format);
    }
    
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
     * time = new DTime("23:10:10");
     * time.i18nFormat();
     * time.i18nFormat(\IntlDateFormatter.FULL);
     * time.i18nFormat("HH": 'mm": `ss");
     * ```
     *
     * You can control the default format used through `Time.setToStringFormat()`.
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
     * time = new DTime("2014-04-20");
     * time.i18nFormat("de-DE");
     * time.i18nFormat(\IntlDateFormatter.FULL, "de-DE");
     * ```
     *
     * You can control the default locale used through `DateTime.setDefaultLocale()`.
     * If empty, the default will be taken from the `intl.default_locale` ini config.
     */
    string /* int */  i18nFormat(
        string /* int */ format = null,
        string localName = null
   ) {
        if (format == DateTime.UNIX_TIMESTAMP_FORMAT) {
            throw new DInvalidArgumentException("UNIT_TIMESTAMP_FORMAT is not supported for Time.");
        }
        format ??= _toStringFormat;
        format = isInt(format) ? [IntlDateFormatter.NONE, format] : format;
        localName = localName ?: DateTime.getDefaultLocale();

        return _formatObject(toNative(), format, localName);
    }
    
    /**
     * Returns a nicely formatted date string for this object.
     *
     * The format to be used is stored in the static property `Time.niceFormat`.
     */
    string nice(string localeName = null) {
        return to!string(this.i18nFormat(niceFormat, localeName));
    }
    
    // Returns a string that should be serialized when converting this object to Json
    string JsonSerialize() {
        if (cast(DClosure)_JsonEncodeFormat) {
            return call_user_func(_JsonEncodeFormat, this);
        }
        return _i18nFormat(_JsonEncodeFormat);
    } */
 
    override string toString() {
        // TODO return to!string(this.i18nFormat());
        return null; 
    }  
}
