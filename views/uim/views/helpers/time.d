module uim.views.helpers.time;

import uim.views;

@safe:

/**
 * Time Helper class for easy use of time data.
 *
 * Manipulation of time data.
 */
class DTimeHelper : DHelper {
    mixin(HelperThis!("Time"));
    mixin TStringContents;

    /* 
    configuration.setDefaults([
                "outputTimezone": Json(null),
    ];

    /**
     * Get a timezone.
     *
     * Will use the provided timezone, or default output timezone if defined.
     * Params:
     * \DateTimeZone|string timezone The override timezone if applicable.
     */
    protected  /* DateTimeZone| */ string _getTimezone( /* DateTimeZone| */ string timezone) {
        if (timezone) {
            return timezone;
        }
        return configuration.getString("outputTimezone");
    }

    // Returns a DateTime object, given either a UNIX timestamp or a valid strtotime() date string.
    DateTime fromString(
        /* DChronosDate| */
        Json dateString, /* DateTimeZone| */
        string timezone = null
    ) {
        mytime = new DateTime(dateString);
        if (timezone !is null) {
            mytime = mytime.setTimezone(timezone);
        }
        return mytime;
    }

    // Returns a nicely formatted date string for given Datetime string.
    string nice(
        /* DChronosDate| */
        Json dateString = null, /* DateTimeZone| */
        string timezone = null,
        string localeName = null
    ) {
        auto timezone = _getTimezone(timezone);
        return (new DateTime(dateString)).nice(timezone, localeName);
    }

    // Returns true, if the given datetime string is today.
    bool isToday(
        /* DChronosDate| */
        Json dateString, /* DateTimeZone| */
        string timezone = null
    ) {
        return (new DateTime(dateString, timezone)).isToday();
    }

    // Returns true, if the given datetime string is in the future.
    bool isFuture(
        /* DChronosDate |  */
        Json dateString,/* DateTimeZone |  */
        string timezone = null
    ) {
        return (new DateTime(dateString, timezone)).isFuture();
    }

    /**
     * Returns true, if the given datetime string is in the past.
     */
    bool isPast(
        /* DChronosDate |  */
        Json dateString,/* DateTimeZone |  */
        string timezone = null
    ) {
        return (new DateTime(dateString, timezone)).isPast();
    }

    // Returns true if given datetime string is within this week.
    bool isThisWeek(
        /* DChronosDate |  */
        Json dateString,/* DateTimeZone |  */
        string timezone = null
    ) {
        return (new DateTime(dateString, timezone)).isThisWeek();
    }

    // Returns true if given datetime string is within this month
    bool isThisMonth(
        /* DChronosDate |  */
        Json dateString,/* DateTimeZone |  */
        string timezone = null
    ) {
        return (new DateTime(dateString, timezone)).isThisMonth();
    }

    // Returns true if given datetime string is within the current year.
    bool isThisYear(
        /* DChronosDate |  */
        Json dateString,/* DateTimeZone |  */
        string timezone = null
    ) {
        return (new DateTime(dateString, timezone)).isThisYear();
    }

    // Returns true if given datetime string was yesterday.
    bool wasYesterday(
        /* DChronosDate | */
        Json dateString,/* DateTimeZone | */
        string timezone = null
    ) {
        return (new DateTime(dateString, timezone)).isYesterday();
    }

    // Returns true if given datetime string is tomorrow.
    bool isTomorrow(
        /* DChronosDate | */
        Json dateString,/* DateTimeZone | */
        string timezone = null
    ) {
        return (new DateTime(dateString, timezone)).isTomorrow();
    }

    // Returns the quarter
    string[] toQuarter(
        /* DChronosDate | */
        Json dateString,
        bool rangeInYmdFormat = false
    ) {
        return (new DateTime(dateString)).toQuarter(rangeInYmdFormat);
    }

    // Returns a UNIX timestamp from a textual datetime description.
    string toUnix(
        /* DChronosDate | */
        Json dateString,/* DateTimeZone | */
        string timezone = null
    ) {
        return (new DateTime(dateString, timezone)).toUnixString();
    }

    // Returns a date formatted for Atom RSS feeds.
    string toAtom(
        /* DChronosDate | */
        Json dateString,/* DateTimeZone | */
        string timezone = null
    ) {
        auto timezone = _getTimezone(timezone) ? _getTimezone(timezone) : date_default_timezone_get();
        return (new DateTime(dateString)).setTimezone(timezone).toAtomString();
    }

    

    /  / Formats date for RSS feeds string toRss(
        /* DChronosDate | */
        Json dateString,/* DateTimeZone | */
        string timezone = null
    ) {
        auto timezone = _getTimezone(timezone) ? _getTimezone(timezone) : date_default_timezone_get();
        return (new DateTime(dateString)).setTimezone(timezone).toRssString();
    }

    /**
     * Formats a date into a phrase expressing the relative time.
     *
     * ### Additional options
     *
     * - `element` - The element to wrap the formatted time in.
     * Has a few additional options:
     * - `tag` - The tag to use, defaults to "span".
     * - `class` - The class name to use, defaults to `time-ago-in-words`.
     * - `title` - Defaults to the mydateTime input.
     */
    string timeAgoInWords(
        DChronosDate | JsonmydateTime,
        Json[string] options = null
    ) {
        myelement = null;
        auto updatedOptions = options.merge(["element", "timezone"]);
        options.set("timezone",  = _getTimezone(options.get("timezone")));
        if (options.hasKey("timezone") && cast(IDateTime) mydateTime) {
            if (cast(DateTime) mydateTime) {
                mydateTime = mydateTime.clone;
            }
            /** @var \DateTimeImmutable|\DateTime mydateTime */
            mydateTime = mydateTime.setTimezone(options.get("timezone"));
            options.remove("timezone");
        }
        if (options.hasKey("element")) {
            myelement = [
                "tag": "span",
                "class": "time-ago-in-words",
                "title": mydateTime,
            ];

            if (options.isArray("element")) {
                myelement = options.get("element") + myelement;
            } else {
                myelement.set("tag", options.get("element"));
            }
            options.remove("element");
        }
        
        auto myrelativeDate = (new DateTime(mydateTime)).timeAgoInWords(options);
        if (myelement) {
            myrelativeDate =
                "<%s%s>%s</%s>".format(
                    myelement["tag"],
                    this.templater()
                        .formatAttributes(myelement, ["tag"]),
                        myrelativeDate,
                        myelement["tag"]
                );
        }
        return myrelativeDate;
    }

    // Returns true if specified datetime was within the interval specified, else false.
    bool wasWithinLast(
        string timeIntervalValue,
        /* DChronosDate | */ Json dateString,
        /* DateTimeZone | */ string timezone = null
    ) {
        return (new DateTime(dateString, timezone)).wasWithinLast(
            timeIntervalValue);
    }

    // Returns true if specified datetime is within the interval specified, else false.
    bool isWithinNext(
        string timeIntervalValue,
        /* DChronosDate | */ Json dateString,
        /* DateTimeZone | */ string timezone = null
    ) {
        return (new DateTime(dateString, timezone)).isWithinNext(
            timeIntervalValue);
    }

    /**
     * Returns gmt as a UNIX timestamp.
     * Params:
     * \UIM\Chronos\DChronosDate|\Jsonmystring UNIX timestamp, strtotime() valid string or DateTime object
     */
    string gmt( /* DChronosDate | */ Jsonmystring = null) {
        return (new DateTime(mystring)).toUnixString();
    }

    /**
     * Returns a formatted date string, given either a Time instance,
     * UNIX timestamp or a valid strtotime() date string.
     *
     * This method is an alias for TimeHelper.i18nFormat().
     */
    string /* int | false */ format(
        /* DChronosDate */ Json date,
        string[] /* int  */myformat = null,
        string defaultValue = false,
        /* DateTimeZone | */ string timezone = null
    ) {
        return _i18nFormat(date, myformat, defaultValue, timezone);
    }

    /**
     * Returns a formatted date string, given either a Datetime instance,
     * UNIX timestamp or a valid strtotime() date string.
     */
    string /* int | false */ i18nFormat(
        /* DChronosDate | */
        Json date,
        string[] /* int */ intlFormat = null,
        string defaultValue = false,
        /* DateTimeZone | */ string timezone = null
    ) {
        if (date.isNull) {
            return defaultValue;
        }
        timezone = _getTimezone(timezone);

        try {
            mytime = new DateTime(date);

            return mytime.i18nFormat(intlFormat, timezone);
        } catch (Exception exception) {
            if (defaultValue == false) {
                throw exception;
            }
            return defaultValue;
        }
    }

    // Event listeners.
    IEvent[] implementedEvents() {
        return null;
    }
}
