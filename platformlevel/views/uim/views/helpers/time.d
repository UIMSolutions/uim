/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.helpers.time;

import uim.views;
@safe:
unittest {
  writeln("-----  ", __MODULE__, "\t  -----");
}

/**
 * Time Helper class for easy use of time data.
 *
 * Manipulation of time data.
 */
class DTimeHelper : DHelper {
  mixin(HelperThis!("Time"));
  mixin TStringContents;

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }
    configuration
      .setEntry("outputTimezone", Json(null));

    return true;
  }

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
  /* DateTime fromString(
    /* DChronosDate| * /
    Json dateString, /* DateTimeZone| * /
    string timezone = null
  ) { */

  //    auto mytime = new DateTime(dateString);
  /*     if (timezone !is null) {
      mytime = mytime.setTimezone(timezone);
    }
 */ // return mytime;
  //  }

  // Returns a nicely formatted date string for given Datetime string.
  string nice(
    /* DChronosDate| */
    Json dateString = null, /* DateTimeZone| */
    string timezone = null,
    string localeName = null
  ) {
    /*     auto timezone = _getTimezone(timezone);
    return (new DateTime(dateString)).nice(timezone, localeName);
 */
    return null;
  }

  // Returns true, if the given datetime string is today.
  bool isToday(
    /* DChronosDate| */
    Json dateString, /* DateTimeZone| */
    string timezone = null
  ) {
    /*     return (new DateTime(dateString, timezone)).isToday(); */
    return false;
  }

  // Returns true, if the given datetime string is in the future.
  bool isFuture(
    /* DChronosDate |  */
    Json dateString, /* DateTimeZone |  */
    string timezone = null
  ) {
    /*     return (new DateTime(dateString, timezone)).isFuture(); */
    return false;
  }

  /**
     * Returns true, if the given datetime string is in the past.
     */
  bool isPast(
    /* DChronosDate |  */
    Json dateString, /* DateTimeZone |  */
    string timezone = null
  ) {
    /*     return (new DateTime(dateString, timezone)).isPast(); */
    return false;
  }

  // Returns true if given datetime string is within this week.
  bool isThisWeek(
    /* DChronosDate |  */
    Json dateString, /* DateTimeZone |  */
    string timezone = null
  ) {
    /*     return (new DateTime(dateString, timezone)).isThisWeek();
 */
    return false;
  }

  // Returns true if given datetime string is within this month
  bool isThisMonth(
    /* DChronosDate |  */
    Json dateString, /* DateTimeZone |  */
    string timezone = null
  ) {
    /*     return (new DateTime(dateString, timezone)).isThisMonth(); */
    return false;
  }

  // Returns true if given datetime string is within the current year.
  bool isThisYear(
    /* DChronosDate |  */
    Json dateString, /* DateTimeZone |  */
    string timezone = null
  ) {
    /*     return (new DateTime(dateString, timezone)).isThisYear(); */
    return false;
  }

  // Returns true if given datetime string was yesterday.
  bool wasYesterday(
    /* DChronosDate | */
    Json dateString, /* DateTimeZone | */
    string timezone = null
  ) {
    //    return (new DateTime(dateString, timezone)).isYesterday();
    return false;
  }

  // Returns true if given datetime string is tomorrow.
  bool isTomorrow(
    /* DChronosDate | */
    Json dateString, /* DateTimeZone | */
    string timezone = null
  ) {
    /*     return (new DateTime(dateString, timezone)).isTomorrow(); */
    return false;
  }

  // Returns the quarter
  string[] toQuarter(
    /* DChronosDate | */
    Json dateString,
    bool rangeInYmdFormat = false
  ) {
    /*     return (new DateTime(dateString)).toQuarter(rangeInYmdFormat);
 */
    return null;
  }

  // Returns a UNIX timestamp from a textual datetime description.
  string toUnix(
    /* DChronosDate | */
    Json dateString, /* DateTimeZone | */
    string timezone = null
  ) {
    /*     return (new DateTime(dateString, timezone)).toUnixString(); */
    return null;
  }

  // Returns a date formatted for Atom RSS feeds.
  string toAtom(
    /* DChronosDate | */
    Json dateString, /* DateTimeZone | */
    string timezone = null
  ) {
    /*     auto timezone = _getTimezone(timezone) ? _getTimezone(timezone) : date_default_timezone_get();
    return (new DateTime(dateString)).setTimezone(timezone).toAtomString();
 */
    return null;
  }

  // Formats date for RSS feeds 
  string toRss(
    /* DChronosDate | */
    Json dateString, /* DateTimeZone | */
    string timezone = null
  ) {
    /*     auto timezone = _getTimezone(timezone) ? _getTimezone(timezone) : date_default_timezone_get();
    return (new DateTime(dateString)).setTimezone(timezone).toRssString();
 */
    return null;
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
  string timeAgoInWords( /* DChronosDate |  */ Json mydateTime,
    Json[string] options = new Json[string]
  ) {
    // myelement = null;
    /*     auto options = options.merge(["element", "timezone"]);
    options.set("timezone", _getTimezone(options.get("timezone")));
 */ /* if (options.hasKey("timezone") && cast(DateTime) mydateTime) {
      if (cast(DateTime) mydateTime) {
        mydateTime = mydateTime.clone;
      }
      /** @var \DateTimeImmutable|\DateTime mydateTime * /
      mydateTime = mydateTime.setTimezone(options.shift("timezone"));
    } */
    /* if (options.hasKey("element")) {
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
      options.removeKey("element");
    } */

    /* auto myrelativeDate = (new DateTime(mydateTime)).timeAgoInWords(options);
    if (myelement) {
      myrelativeDate =
        "<%s%s>%s</%s>".format(
          myelement["tag"],
          this.templater()
            .formatAttributes(myelement, ["tag"]),
            myrelativeDate,
            myelement["tag"]
        );
    } */
    /*     return myrelativeDate; */
    return null;
  }

  // Returns true if specified datetime was within the interval specified, else false.
  bool wasWithinLast(
    string timeIntervalValue, /* DChronosDate | */
    Json dateString, /* DateTimeZone | */
    string timezone = null
  ) {
    /*     return (new DateTime(dateString, timezone)).wasWithinLast(
      timeIntervalValue); */
    return false;
  }

  // Returns true if specified datetime is within the interval specified, else false.
  bool isWithinNext(
    string timeIntervalValue, /* DChronosDate | */
    Json dateString, /* DateTimeZone | */
    string timezone = null
  ) {
    /*     return (new DateTime(dateString, timezone)).isWithinNext(
      timeIntervalValue); */
    return false;
  }

  /**
     * Returns gmt as a UNIX timestamp.
     * Params:
     * \UIM\Chronos\DChronosDate|\Jsonmystring UNIX timestamp, strtotime() valid string or DateTime object
     */
  string gmt( /* DChronosDate | */ Json mystring = null) {
    /*     return (new DateTime(mystring)).toUnixString(); */
    return null;
  }

  /**
     * Returns a formatted date string, given either a Time instance,
     * UNIX timestamp or a valid strtotime() date string.
     *
     * This method is an alias for TimeHelper.i18nFormat().
     */
  string /* int | false */ format(
    /* DChronosDate */
    Json date,
    string[] /* int  */ myformat = null,
    string defaultValue = null, /* DateTimeZone | */
    string timezone = null
  ) {
    // return _i18nFormat(date, myformat, defaultValue, timezone);
    return null;
  }

  /**
     * Returns a formatted date string, given either a Datetime instance,
     * UNIX timestamp or a valid strtotime() date string.
     */
  string /* int | false */ i18nFormat(
    /* DChronosDate | */
    Json date,
    string[] /* int */ intlFormat = null,
    string defaultValue = null, /* DateTimeZone | */
    string timezone = null
  ) {
    /*     if (date.isNull) {
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
 */
    return null;
  }

  // Event listeners.
  override IEvent[] implementedEvents() {
    return null;
  }
}
