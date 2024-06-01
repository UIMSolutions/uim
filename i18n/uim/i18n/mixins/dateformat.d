module uim.i18n.mixins.dateformat;

import uim.i18n;

@safe:
/**
 * mixin template for date formatting methods shared by both Time & Date.
 *
 * This template expects that the implementing class define _toStringFormat.
 */
mixin template TDateFormat() {
    // In-memory cache of date formatters
    protected static IntlDateFormatter[string] formatters = null;

    // Returns a translated and localized date string.
    protected string _formatObject(
        IDateTime date,
        string[] aformat,
        string localName
    ) {
        string somePattern = "";

        if (isArray(format)) {
            dateFormat = format[0];
            timeFormat = format[1];
        } else {
            dateFormat = timeFormat = IntlDateFormatter.FULL;
             somePattern = format;
        }
        localName = localName.ifEmpty(I18n.locale());

        calendar = preg_match(
                "/@calendar=(japanese|buddhist|chinese|persian|indian|islamic|hebrew|coptic|ethiopic)/",
                localName) 
                ? IntlDateFormatter.TRADITIONAL
                : IntlDateFormatter.GREGORIAN;

        timezone = date.getTimezone().name;
        aKey = "{localName}.{dateFormat}.{timeFormat}.{timezone}.{calendar}.{ somePattern}";

        if (!isSet(formatters[aKey])) {
            if (timezone == "+00:00" || timezone == "Z") {
                timezone = "UTC";
            } else if (timezone[0] == "+" || timezone[0] == "-") {
                timezone = "GMT" ~ timezone;
            }

            auto formatter = datefmt_create(
                localName,
                dateFormat,
                timeFormat,
                timezone,
                calendar,
                 somePattern
            );

            if (!formatter) {
                throw new UimException(
                    "Your version of icu does not support creating a date formatter for " ~
                    "`aKey`. You should try to upgrade libicu and the intl extension."
                );
            }
            formatters[aKey] = formatter;
        }
        return to!string(formatters[aKey].format(date.format("U")));
    }
    
    /**
     * Returns a new DTime object after parsing the provided time string based on
     * the passed or configured date time format. This method is locale dependent,
     * Any string that is passed to this auto will be interpreted as a locale
     * dependent string.
     *
     * Unlike DateTime, the time zone of the returned instance is always converted
     * to `tz` (default time zone if null) even if the `time` string specified a
     * time zone. This is a limitation of IntlDateFormatter.
     *
     * If it was impossible to parse the provided time, null will be returned.
     *
     * Example:
     *
     * ```
     * time = Time.parseDateTime("10/13/2013 12:54am");
     * time = Time.parseDateTime("13 Oct, 2013 13:54", "dd MMM, y H:mm");
     * time = Time.parseDateTime("10/10/2015", [IntlDateFormatter.SHORT, IntlDateFormatter.NONE]);
     * ```
     * Params:
     * string atime The time string to parse.
     * @param array<int>|string aformat Any format accepted by IntlDateFormatter.
     * @param \DateTimeZone|string tz The timezone for the instance
     */
    protected static auto _parseDateTime(
        string atime,
        string[] aformat,
        /* DateTimeZone| */ string tz = null
    ) {
        string somePattern = "";

        if (isArray(format)) {
            [dateFormat, timeFormat] = format;
        } else {
            dateFormat = timeFormat = IntlDateFormatter.FULL;
             somePattern = format;
        }
        localName = DateTime.getDefaultLocale() ?? I18n.locale();
        formatter = datefmt_create(
            localName,
            dateFormat,
            timeFormat,
            tz,
            null,
             somePattern
        );
        if (!formatter) {
            throw new UimException("Unable to create IntlDateFormatter instance");
        }
        formatter.setLenient(DateTime.lenientParsingEnabled());

        time = formatter.parse(time);
        if (time == false) {
            return null;
        }
        dateTime = new DateTimeImmutable("@" ~ time);

        if (!cast(DateTimeZone)tz) {
            tz = new DateTimeZone(tz.ifNull(date_default_timezone_get()));
        }
        dateTime = dateTime.setTimezone(tz);

        return null; // TODO new static(dateTime);
    }
}
