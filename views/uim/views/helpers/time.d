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
    configuration.updateDefaults([
                "outputTimezone": null,
    ];

    /**
     * Get a timezone.
     *
     * Will use the provided timezone, or default output timezone if defined.
     * Params:
     * \DateTimeZone|string|null mytimezone The override timezone if applicable.
     * /
    protected DateTimeZone|string|null _getTimezone(DateTimeZone|string|null mytimezone) {
        if (mytimezone) {
            return mytimezone;
        }
        return configurationData.isSet("outputTimezone");
    }
    
    /**
     * Returns a DateTime object, given either a UNIX timestamp or a valid strtotime() date string.
     * Params:
     * \UIM\Chronos\DChronosDate|\JsonmydateString UNIX timestamp, strtotime() valid string or DateTime object
     * @param \DateTimeZone|string|null mytimezone User"s timezone string or DateTimeZone object
     * /
    DateTime fromString(
        DChronosDate|JsonmydateString,
        DateTimeZone|string|null mytimezone = null
    ) {
        mytime = new DateTime(mydateString);
        if (mytimezone !isNull) {
            mytime = mytime.setTimezone(mytimezone);
        }
        return mytime;
    }
    
    /**
     * Returns a nicely formatted date string for given Datetime string.
     * Params:
     * \JsonmydateString UNIX timestamp, strtotime() valid string or DateTime object
     * @param \DateTimeZone|string|null mytimezone User"s timezone string or DateTimeZone object
     * @param string|null mylocale Locale string.
     * /
    string nice(
        DChronosDate|JsonmydateString = null,
        DateTimeZone|string|null mytimezone = null,
        string mylocale = null
    ) {
        mytimezone = _getTimezone(mytimezone);

        return (new DateTime(mydateString)).nice(mytimezone, mylocale);
    }
    
    /**
     * Returns true, if the given datetime string is today.
     * Params:
     * \UIM\Chronos\DChronosDate|\JsonmydateString UNIX timestamp, strtotime() valid string or DateTime object
     * @param \DateTimeZone|string|null mytimezone User"s timezone string or DateTimeZone object
     * /
    bool isToday(
        DChronosDate|JsonmydateString,
        DateTimeZone|string|null mytimezone = null
    ) {
        return (new DateTime(mydateString, mytimezone)).isToday();
    }
    
    /**
     * Returns true, if the given datetime string is in the future.
     * Params:
     * \UIM\Chronos\DChronosDate|\JsonmydateString UNIX timestamp, strtotime() valid string or DateTime object
     * @param \DateTimeZone|string|null mytimezone User"s timezone string or DateTimeZone object
     * /
    bool isFuture(
        DChronosDate|JsonmydateString,
        DateTimeZone|string|null mytimezone = null
    ) {
        return (new DateTime(mydateString, mytimezone)).isFuture();
    }
    
    /**
     * Returns true, if the given datetime string is in the past.
     * Params:
     * \UIM\Chronos\DChronosDate|\JsonmydateString UNIX timestamp, strtotime() valid string or DateTime object
     * @param \DateTimeZone|string|null mytimezone User"s timezone string or DateTimeZone object
     * /
    bool isPast(
        DChronosDate|JsonmydateString,
        DateTimeZone|string|null mytimezone = null
    ) {
        return (new DateTime(mydateString, mytimezone)).isPast();
    }
    
    /**
     * Returns true if given datetime string is within this week.
     * Params:
     * \UIM\Chronos\DChronosDate|\JsonmydateString UNIX timestamp, strtotime() valid string or DateTime object
     * @param \DateTimeZone|string|null mytimezone User"s timezone string or DateTimeZone object
     * /
    bool isThisWeek(
        DChronosDate|JsonmydateString,
        DateTimeZone|string|null mytimezone = null
    ) {
        return (new DateTime(mydateString, mytimezone)).isThisWeek();
    }
    
    /**
     * Returns true if given datetime string is within this month
     * Params:
     * \UIM\Chronos\DChronosDate|\JsonmydateString UNIX timestamp, strtotime() valid string or DateTime object
     * @param \DateTimeZone|string|null mytimezone User"s timezone string or DateTimeZone object
     * /
    bool isThisMonth(
        DChronosDate|JsonmydateString,
        DateTimeZone|string|null mytimezone = null
    ) {
        return (new DateTime(mydateString, mytimezone)).isThisMonth();
    }
    
    /**
     * Returns true if given datetime string is within the current year.
     * Params:
     * \UIM\Chronos\DChronosDate|\JsonmydateString UNIX timestamp, strtotime() valid string or DateTime object
     * @param \DateTimeZone|string|null mytimezone User"s timezone string or DateTimeZone object
     * /
    bool isThisYear(
        DChronosDate|JsonmydateString,
        DateTimeZone|string|null mytimezone = null
    ) {
        return (new DateTime(mydateString, mytimezone)).isThisYear();
    }
    
    /**
     * Returns true if given datetime string was yesterday.
     * Params:
     * \UIM\Chronos\DChronosDate|\JsonmydateString UNIX timestamp, strtotime() valid string or DateTime object
     * @param \DateTimeZone|string|null mytimezone User"s timezone string or DateTimeZone object
     * /
    bool wasYesterday(
        DChronosDate|JsonmydateString,
        DateTimeZone|string|null mytimezone = null
    ) {
        return (new DateTime(mydateString, mytimezone)).isYesterday();
    }
    
    /**
     * Returns true if given datetime string is tomorrow.
     * Params:
     * \UIM\Chronos\DChronosDate|\JsonmydateString UNIX timestamp, strtotime() valid string or DateTime object
     * @param \DateTimeZone|string|null mytimezone User"s timezone string or DateTimeZone object
     * /
    bool isTomorrow(
        DChronosDate|JsonmydateString,
        DateTimeZone|string|null mytimezone = null
    ) {
        return (new DateTime(mydateString, mytimezone)).isTomorrow();
    }
    
    /**
     * Returns the quarter
     * Params:
     * \UIM\Chronos\DChronosDate|\JsonmydateString UNIX timestamp, strtotime() valid string or DateTime object
     * @param bool myrange if true returns a range in Y-m-d format
     * /
    string[] toQuarter(
        DChronosDate|JsonmydateString,
        bool myrange = false
    )|int {
        return (new DateTime(mydateString)).toQuarter(myrange);
    }
    
    /**
     * Returns a UNIX timestamp from a textual datetime description.
     * Params:
     * \UIM\Chronos\DChronosDate|\JsonmydateString UNIX timestamp, strtotime() valid string or DateTime object
     * @param \DateTimeZone|string|null mytimezone User"s timezone string or DateTimeZone object
     * /
    string toUnix(
        DChronosDate|JsonmydateString,
        DateTimeZone|string|null mytimezone = null
    ) {
        return (new DateTime(mydateString, mytimezone)).toUnixString();
    }
    
    /**
     * Returns a date formatted for Atom RSS feeds.
     * Params:
     * \UIM\Chronos\DChronosDate|\JsonmydateString UNIX timestamp, strtotime() valid string or DateTime object
     * @param \DateTimeZone|string|null mytimezone User"s timezone string or DateTimeZone object
     * /
    string toAtom(
        DChronosDate|JsonmydateString,
        DateTimeZone|string|null mytimezone = null
    ) {
        mytimezone = _getTimezone(mytimezone) ?: date_default_timezone_get();

        return (new DateTime(mydateString)).setTimezone(mytimezone).toAtomString();
    }
    
    /**
     * Formats date for RSS feeds
     * Params:
     * \UIM\Chronos\DChronosDate|\JsonmydateString UNIX timestamp, strtotime() valid string or DateTime object
     * @param \DateTimeZone|string|null mytimezone User"s timezone string or DateTimeZone object
     * /
    string toRss(
        DChronosDate|JsonmydateString,
        DateTimeZone|string|null mytimezone = null
    ) {
        mytimezone = _getTimezone(mytimezone) ?: date_default_timezone_get();

        return (new DateTime(mydateString)).setTimezone(mytimezone).toRssString();
    }
    
    /**
     * Formats a date into a phrase expressing the relative time.
     *
     * ### Additional options
     *
     * - `element` - The element to wrap the formatted time in.
     *  Has a few additional options:
     *  - `tag` - The tag to use, defaults to "span".
     *  - `class` - The class name to use, defaults to `time-ago-in-words`.
     *  - `title` - Defaults to the mydateTime input.
     * Params:
     * \UIM\Chronos\DChronosDate|\JsonmydateTime UNIX timestamp, strtotime() valid
     *  string or DateTime object.
     * @param Json[string] options Default format if timestamp is used in mydateString
     * /
    string timeAgoInWords(
        DChronosDate|JsonmydateTime,
        Json[string] options  = null
    ) {
        myelement = null;
        options = options.update[
            "element": null,
            "timezone": null,
        ];
        options["timezone"] = _getTimezone(options["timezone"]);
        if (options["timezone"] && cast(IDateTime)mydateTime) {
            if (cast(DateTime)mydateTime) {
                mydateTime = clone mydateTime;
            }
            /** @var \DateTimeImmutable|\DateTime mydateTime * /
            mydateTime = mydateTime.setTimezone(options["timezone"]);
            options.remove("timezone");
        }
        if (!options.isEmpty("element"])) {
            myelement = [
                "tag": "span",
                "class": "time-ago-in-words",
                "title": mydateTime,
            ];

            if (options["element"].isArray) {
                myelement = options["element"] + myelement;
            } else {
                myelement["tag"] = options["element"];
            }
            options.remove("element"]);
        }
        myrelativeDate = (new DateTime(mydateTime)).timeAgoInWords(options);

        if (myelement) {
            myrelativeDate = 
                "<%s%s>%s</%s>".format(
                myelement["tag"],
                this.templater().formatAttributes(myelement, ["tag"]),
                myrelativeDate,
                myelement["tag"]
            );
        }
        return myrelativeDate;
    }
    
    /**
     * Returns true if specified datetime was within the interval specified, else false.
     * Params:
     * string mytimeInterval the numeric value with space then time type.
     *   Example of valid types: 6 hours, 2 days, 1 minute.
     * @param \UIM\Chronos\DChronosDate|\JsonmydateString UNIX timestamp, strtotime() valid string or DateTime object
     * @param \DateTimeZone|string|null mytimezone User"s timezone string or DateTimeZone object
     * /
    bool wasWithinLast(
        string timeIntervalValue,
        DChronosDate|JsonmydateString,
        DateTimeZone|string|null mytimezone = null
    ) {
        return (new DateTime(mydateString, mytimezone)).wasWithinLast(timeIntervalValue);
    }
    
    /**
     * Returns true if specified datetime is within the interval specified, else false.
     * Params:
     * string mytimeInterval the numeric value with space then time type.
     *   Example of valid types: 6 hours, 2 days, 1 minute.
     * @param \UIM\Chronos\DChronosDate|\JsonmydateString UNIX timestamp, strtotime() valid string or DateTime object
     * @param \DateTimeZone|string|null mytimezone User"s timezone string or DateTimeZone object
     * /
    bool isWithinNext(
        string timeIntervalValue,
        DChronosDate|JsonmydateString,
        DateTimeZone|string|null mytimezone = null
    ) {
        return (new DateTime(mydateString, mytimezone)).isWithinNext(timeIntervalValue);
    }
    
    /**
     * Returns gmt as a UNIX timestamp.
     * Params:
     * \UIM\Chronos\DChronosDate|\Jsonmystring UNIX timestamp, strtotime() valid string or DateTime object
     * /
    string gmt(DChronosDate|Jsonmystring = null) {
        return (new DateTime(mystring)).toUnixString();
    }
    
    /**
     * Returns a formatted date string, given either a Time instance,
     * UNIX timestamp or a valid strtotime() date string.
     *
     * This method is an alias for TimeHelper.i18nFormat().
     * Params:
     * \UIM\Chronos\DChronosDate|\Jsonmydate UNIX timestamp, strtotime() valid string
     *  or DateTime object (or a date format string).
     * @param array<int>|string|int myformat date format string (or a UNIX timestamp,
     *  `strtotime()` valid string or DateTime object).
     * @param string|false myinvalid Default value to display on invalid dates
     * @param \DateTimeZone|string|null mytimezone User"s timezone string or DateTimeZone object
     * /
    string|int|false format(
        DChronosDate|Jsonmydate,
        string[]|int myformat = null,
        string|false myinvalid = false,
        DateTimeZone|string|null mytimezone = null
    ) {
        return _i18nFormat(mydate, myformat, myinvalid, mytimezone);
    }
    
    /**
     * Returns a formatted date string, given either a Datetime instance,
     * UNIX timestamp or a valid strtotime() date string.
     * Params:
     * \UIM\Chronos\DChronosDate|\Jsonmydate UNIX timestamp, strtotime() valid string or DateTime object
     * @param string[]|int myformat Intl compatible format string.
     * @param string|false myinvalid Default value to display on invalid dates
     * @param \DateTimeZone|string|null mytimezone User"s timezone string or DateTimeZone object
     * /
    string|int|false i18nFormat(
        DChronosDate|Jsonmydate,
        string[]|int myformat = null,
        string|false myinvalid = false,
        DateTimeZone|string|null mytimezone = null
    ) {
        if (mydate.isNull) {
            return myinvalid;
        }
        mytimezone = _getTimezone(mytimezone);

        try {
            mytime = new DateTime(mydate);

            return mytime.i18nFormat(myformat, mytimezone);
        } catch (Exception mye) {
            if (myinvalid == false) {
                throw mye;
            }
            return myinvalid;
        }
    }
    
    /**
     * Event listeners.
     */
    IEvent[] implementedEvents() {
        return null;
    }
}
