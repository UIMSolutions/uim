module uim.i18n.classes.time;

import uim.i18n;

@safe:

/**
 * : time class provided by Chronos.
 *
 * Adds handy methods and locale-aware formatting helpers.
 */
class Time : ChronosTime, JsonSerializable, Stringable {
    use DateFormatTemplate();

    /**
     * The format to use when formatting a time using `UIM\I18n\Time.i18nFormat()`
     * and `__toString`.
     *
     * The format should be either the formatting constants from IntlDateFormatter as
     * described in (https://secure.d.net/manual/en/class.intldateformatter.d) or a pattern
     * as specified in (https://unicode-org.github.io/icu-docs/apidoc/released/icu4c/classSimpleDateFormat.html#details)
     *
     * @var string|int
     * @see \UIM\I18n\Time.i18nFormat()
     * /
    protected static string|int _toStringFormat = IntlDateFormatter.SHORT;

    /**
     * The format to use when converting this object to JSON.
     *
     * The format should be either the formatting constants from IntlDateFormatter as
     * described in (https://secure.d.net/manual/en/class.intldateformatter.d) or a pattern
     * as specified in (https://unicode-org.github.io/icu-docs/apidoc/released/icu4c/classSimpleDateFormat.html#details)
     *
     * @var \Closure|string|int
     * @see \UIM\I18n\Date.i18nFormat()
     * /
    protected static Closure|string|int _jsonEncodeFormat = "HH':'mm':'ss";

    /**
     * The format to use when formatting a time using `UIM\I18n\Time.nice()`
     *
     * The format should be either the formatting constants from IntlDateFormatter as
     * described in (https://secure.d.net/manual/en/class.intldateformatter.d) or a pattern
     * as specified in (https://unicode-org.github.io/icu-docs/apidoc/released/icu4c/classSimpleDateFormat.html#details)
     *
     * @var string|int
     * @see \UIM\I18n\Time.nice()
     * /
    static string|int niceFormat = IntlDateFormatter.MEDIUM;

    /**
     * Sets the default format used when type converting instances of this type to string
     *
     * The format should be either the formatting constants from IntlDateFormatter as
     * described in (https://secure.d.net/manual/en/class.intldateformatter.d) or a pattern
     * as specified in (https://unicode-org.github.io/icu-docs/apidoc/released/icu4c/classSimpleDateFormat.html#details)
     * Params:
     * string|int format Format.
     * /
    static auto setToStringFormat(string format) {
        _toStringFormat = format;
    }
    
    // Resets the format used to the default when converting an instance of this type to a string
    static void resetToStringFormat() {
        setToStringFormat(IntlDateFormatter.SHORT);
    }
    
    /**
     * Sets the default format used when converting this object to JSON
     *
     * The format should be either the formatting constants from IntlDateFormatter as
     * described in (https://secure.d.net/manual/en/class.intldateformatter.d) or a pattern
     * as specified in (http://www.icu-project.org/apiref/icu4c/classSimpleDateFormat.html#details)
     *
     * Alternatively, the format can provide a callback. In this case, the callback
     * can receive this object and return a formatted string.
     *
     * @param \Closure|string|int format Format.
     * /
    static void setJsonEncodeFormat(Closure|string|int format) {
        _jsonEncodeFormat = format;
    }
    
    /**
     * Returns a new Time object after parsing the provided time string based on
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
     * Params:
     * string atime The time string to parse.
     * @param string|int format Any format accepted by IntlDateFormatter.
     * /
    static static parseTime(string atime, string|int format = null) {
        format ??= [IntlDateFormatter.NONE, IntlDateFormatter.SHORT];
        if (isInt(format)) {
            format = [IntlDateFormatter.NONE, format];
        }
        return _parseDateTime(time, format);
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
     * time = new Time("23:10:10");
     * time.i18nFormat();
     * time.i18nFormat(\IntlDateFormatter.FULL);
     * time.i18nFormat("HH":'mm":`ss");
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
     * time = new Time("2014-04-20");
     * time.i18nFormat("de-DE");
     * time.i18nFormat(\IntlDateFormatter.FULL, "de-DE");
     * ```
     *
     * You can control the default locale used through `DateTime.setDefaultLocale()`.
     * If empty, the default will be taken from the `intl.default_locale` ini config.
     * Params:
     * string|int format Format string.
     * @param string locale The locale name in which the time should be displayed (e.g. pt-BR)
     */
    string|int i18nFormat(
        string|int format = null,
        string alocale = null
    ) {
        if (format == DateTime.UNIX_TIMESTAMP_FORMAT) {
            throw new InvalidArgumentException("UNIT_TIMESTAMP_FORMAT is not supported for Time.");
        }
        format ??= _toStringFormat;
        format = isInt(format) ? [IntlDateFormatter.NONE, format] : format;
        locale = locale ?: DateTime.getDefaultLocale();

        return _formatObject(this.toNative(), format, locale);
    }
    
    /**
     * Returns a nicely formatted date string for this object.
     *
     * The format to be used is stored in the static property `Time.niceFormat`.
     */
    string nice(string localeName = null) {
        return (string)this.i18nFormat(niceFormat, localeName);
    }
    
    // Returns a string that should be serialized when converting this object to JSON
    string jsonSerialize() {
        if (cast(Closure)_jsonEncodeFormat) {
            return call_user_func(_jsonEncodeFormat, this);
        }
        return this.i18nFormat(_jsonEncodeFormat);
    }
 
    override string toString() {
        return (string)this.i18nFormat();
    }
}
