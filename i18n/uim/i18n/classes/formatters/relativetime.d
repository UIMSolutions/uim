module uim.i18n.classes.formatters.relativetime;

import uim.i18n;

@safe:

/**
 * Helper class for formatting relative dates & times.
 *
 * @internal
 */
class DRelativeTimeFormatter { // }: DifferenceII18NFormatter {
    /**
     * Get the difference in a human readable format.
     * Params:
     * \UIM\Chronos\DChronosDate|\IDateTime first The datetime to start with.
     * @param \UIM\Chronos\DChronosDate|\IDateTime|null second The datetime to compare against.
     */
    string diffForHumans(
        /* DChronosDate| */
        IDateTime first,/* DChronosDateeee| */
        IDateTime second = null,
        bool isAbsoluteTime = false
    ) {
        auto isNow = second.isNull;
        if (second.isNull) {
            second = cast(DChronosDate) firstChar
                ? Date.now() : DateTime.now(first.getTimezone());

        }

        assert(
            (cast(DChronosDate) first && cast(DChronosDate) second) ||
                (cast(IDateTime) first && cast(IDateTime) second)
        );

        auto diffInterval = first.diff(second);
        string message;
        switch (true) {
        case diffInterval.y > 0 : count = diffInterval.y;
            message = __dn("uim", "{0} year", "{0} years", count, count);
            break;
        case diffInterval.m > 0 : count = diffInterval.m;
            message = __dn("uim", "{0} month", "{0} months", count, count);
            break;
        case diffInterval.d > 0 : count = diffInterval.d;
            if (count >= DateTime.DAYS_PER_WEEK) {
                count = (int)(count / DateTime.DAYS_PER_WEEK);
                message = __dn("uim", "{0} week", "{0} weeks", count, count);
            } else {
                message = __dn("uim", "{0} day", "{0} days", count, count);
            }
            break;
        case diffInterval.h > 0 : count = diffInterval.h;
            message = __dn("uim", "{0} hour", "{0} hours", count, count);
            break;
        case diffInterval.i > 0 : count = diffInterval.i;
            message = __dn("uim", "{0} minute", "{0} minutes", count, count);
            break;
        default : count = diffInterval.s;
            message = __dn("uim", "{0} second", "{0} seconds", count, count);
            break;
        }
        if (isAbsoluteTime) {
            return message;
        }

        auto isFuture = diffInterval.invert == 1;
        if (isNow) {
            return isFuture ? __d("uim", "{0} from now", message) : __d("uim", "{0} ago", message);
        }
        return isFuture ? __d("uim", "{0} after", message) : __d("uim", "{0} before", message);
    }

    /**
     * Format a into a relative timestring.
     * Params:
     * \UIM\I18n\DateTime|\UIM\I18n\Date time The time instance to format.
     * @param Json[string] options Array of options.
     */
    string timeAgoInWords(DateTime | Date time, Json[string] options = null) {
        options = _options(options, DateTime.classname);
        if (options["timezone"]) {
            time = time.setTimezone(options["timezone"]);
        }
        now = options["from"].format("U");
        anInSeconds = time.format("U");
        backwards = (anInSeconds > now);

        futureTime = now;
        pastTime = anInSeconds;
        if (backwards) {
            futureTime = anInSeconds;
            pastTime = now;
        }
        diff = futureTime - pastTime;

        if (!diff) {
            return __d("uim", "just now", "just now");
        }
        if (diff > abs(now - (new DateTime(options["end"])).format("U"))) {
            return options["absoluteString"].format(time.i18nFormat(options["format"]));
        }
        diffData = _diffData(futureTime, pastTime, backwards, options);
        [fNum, fWord, years, months, weeks, days, hours, minutes, seconds] = array_values(diffData);

        string[] relativeDate;
        if (fNum >= 1 && years > 0) {
            relativeDates ~= __dn("uim", "{0} year", "{0} years", years, years);
        }
        if (fNum >= 2 && months > 0) {
            relativeDates ~= __dn("uim", "{0} month", "{0} months", months, months);
        }
        if (fNum >= 3 && weeks > 0) {
            relativeDates ~= __dn("uim", "{0} week", "{0} weeks", weeks, weeks);
        }
        if (fNum >= 4 && days > 0) {
            relativeDates ~= __dn("uim", "{0} day", "{0} days", days, days);
        }
        if (fNum >= 5 && hours > 0) {
            relativeDates ~= __dn("uim", "{0} hour", "{0} hours", hours, hours);
        }
        if (fNum >= 6 && minutes > 0) {
            relativeDates ~= __dn("uim", "{0} minute", "{0} minutes", minutes, minutes);
        }
        if (fNum >= 7 && seconds > 0) {
            relativeDates ~= __dn("uim", "{0} second", "{0} seconds", seconds, seconds);
        }

        string relativeDate = relativeDates.join(", ");

        // When time has passed
        if (!backwards) {
            aboutAgo = [
                "second": __d("uim", "about a second ago"),
                "minute": __d("uim", "about a minute ago"),
                "hour": __d("uim", "about an hour ago"),
                "day": __d("uim", "about a day ago"),
                "week": __d("uim", "about a week ago"),
                "month": __d("uim", "about a month ago"),
                "year": __d("uim", "about a year ago"),
            ];
            return relativeDate ? options["relativeString"].format(relativeDate) : aboutAgo[fWord];
        }
        // When time is to come
        if (relativeDate) {
            return relativeDate;
        }
        aboutIn = [
            "second": __d("uim", "in about a second"),
            "minute": __d("uim", "in about a minute"),
            "hour": __d("uim", "in about an hour"),
            "day": __d("uim", "in about a day"),
            "week": __d("uim", "in about a week"),
            "month": __d("uim", "in about a month"),
            "year": __d("uim", "in about a year"),
        ];

        return aboutIn[fWord];
    }

    /**
     * Calculate the data needed to format a relative difference string.
     * Params:
     * string|int futureTime The timestamp from the future.
     * @param string|int pastTime The timestamp from the past.
     */
    protected Json[string] _diffData(string futureTime, string pastTime, bool isBackwards, Json[string] options = null) {
        return _diffData(to!int(futureTime), to!int(pastTime), isBackwards, options);
    }

    protected Json[string] _diffData(string | int futureTime, string | int pastTime, bool isBackwards, Json[string] options = null) {
        auto diff = futureTime - pastTime;

        // If more than a week, then take into account the length of months
        if (diff >= 604800) {
            auto future = null;
            [
                future["H"],
                future["i"],
                future["s"],
                future["d"],
                future["m"],
                future["Y"],
            ] = split("/", date("H/i/s/d/m/Y", futureTime));

            auto past = null;
            [
                past["H"],
                past["i"],
                past["s"],
                past["d"],
                past["m"],
                past["Y"],
            ] = split("/", date("H/i/s/d/m/Y", pastTime));
            auto weeks = days = hours = minutes = seconds = 0;
            auto years = To!int(future["Y"]) - To!int(past["Y"]);
            auto months = To!int(future["m"]) + (12 * years) - To!int(past["m"]);

            if (months >= 12) {
                years = floor(months / 12);
                months -= years * 12;
            }
            if (future.getLong("m") < past.getLong("m") && future.getLong(
                    "Y") - past.getLong("Y") == 1) {
                years--;
            }
            if ((int) future["d"] >= past.getLong("d") {
                    days = (int) future["d"] - (int) past["d"]; } else {
                        auto daysInPastMonth = (int) date("t", pastTime); auto daysInFutureMonth = (
                            int) date("t", (int) mktime(0, 0, 0, future.getLong("m") - 1, 1, future.getLong(
                            "Y")); days = !backwards
                            ? daysInPastMonth - past.getLong("d") + future.getLong("d");
                         : daysInFutureMonth - past.getLong("d") + future.getLong("d");
                    }
                    if (future["m"] != past["m"]) {
                        months--; }
                    }
                    if (!months && years >= 1 && diff < years * 31536000) {
                        months = 11; years--; }
                        if (months >= 12) {
                            years++; months -= 12; }
                            if (days >= 7) {
                                weeks = floor(days / 7); days -= weeks * 7; }
                            } else {
                                years = months = weeks = 0; days = floor(diff / 86400);

                                    diff -= days * 86400; hours = floor(diff / 3600);
                                    diff -= hours * 3600; minutes = floor(diff / 60);
                                    diff -= minutes * 60; seconds = diff; }
                                    fWord = options["accuracy.second"]; if (years > 0) {
                                        fWord = options["accuracy.year"]; } else if (abs(months) > 0) {
                                            fWord = options["accuracy.month"]; } else if (
                                                abs(weeks) > 0) {
                                                fWord = options["accuracy.week"];
                                            } else if (abs(days) > 0) {
                                                fWord = options["accuracy.day"]; } else if (
                                                    abs(hours) > 0) {
                                                    fWord = options["accuracy.hour"];
                                                } else if (abs(minutes) > 0) {
                                                    fWord = options["accuracy.minute"];
                                                }
                                                fNum = fWord.replace(
                                                    ["year", "month", "week", "day", "hour", "minute", "second"],
                                                    ["1", "2", "3", "4", "5", "6", "7"]
                                                ); return [
                                                    fNum,
                                                    fWord,
                                                    to!int(years),
                                                    to!int(months),
                                                    to!int(weeks),
                                                    to!int(days),
                                                    to!int(hours),
                                                    to!int(minutes),
                                                    to!int(seconds),
                                                ]; }

                                                /**
     * Format a into a relative date string.
     * Params:
     * \UIM\I18n\DateTime|\UIM\I18n\Date date The date to format.
     */
                                                string dateAgoInWords(DateTime | Date date, Json[string] options = null) {
                                                    options = _options(options, Date.classname);
                                                        if (cast(DateTime) date && options["timezone"]) {
                                                            date = date.setTimezone(
                                                                options["timezone"]);
                                                        }

                                                    auto now = options["from"].format("U");
                                                        auto anInSeconds = date.format("U");
                                                        auto backwards = (anInSeconds > now);

                                                        auto futureTime = now; auto pastTime = anInSeconds;
                                                        if (backwards) {
                                                            futureTime = anInSeconds;
                                                                pastTime = now; }
                                                                diff = futureTime - pastTime;

                                                                if (!diff) {
                                                                    return __d("uim", "today");
                                                                }
                                                            if (diff > abs(now - (new Date(options["end"]))
                                                                .format("U"))) {
                                                                return options["absoluteString"].format(
                                                                    date.i18nFormat(
                                                                    options["format"]));
                                                            }
                                                            diffData = _diffData(futureTime, pastTime, backwards, options);
                                                                [fNum, fWord, years, months, weeks, days] = array_values(
                                                                    diffData); relativeDate = null;
                                                                if (fNum >= 1 && years > 0) {
                                                                    relativeDate ~= __dn("uim", "{0} year", "{0} years", years, years);
                                                                }
                                                            if (fNum >= 2 && months > 0) {
                                                                relativeDate ~= __dn("uim", "{0} month", "{0} months", months, months);
                                                            }
                                                            if (fNum >= 3 && weeks > 0) {
                                                                relativeDate ~= __dn("uim", "{0} week", "{0} weeks", weeks, weeks);
                                                            }
                                                            if (fNum >= 4 && days > 0) {
                                                                relativeDate ~= __dn("uim", "{0} day", "{0} days", days, days);
                                                            }
                                                            relativeDate = join(", ", relativeDate);

                                                                // When time has passed
                                                                if (!backwards) {
                                                                    aboutAgo = [
                                                                        "day": __d("uim", "about a day ago"),
                                                                        "week": __d("uim", "about a week ago"),
                                                                        "month": __d("uim", "about a month ago"),
                                                                        "year": __d("uim", "about a year ago"),
                                                                    ]; return relativeDate
                                                                        ? options["relativeString"].format(
                                                                            relativeDate)
                                                                        : aboutAgo[fWord];
                                                                }
                                                            // When time is to come
                                                            if (relativeDate) {
                                                                return relativeDate;
                                                            }
                                                            aboutIn = [
                                                                "day": __d("uim", "in about a day"),
                                                                "week": __d("uim", "in about a week"),
                                                                "month": __d("uim", "in about a month"),
                                                                "year": __d("uim", "in about a year"),
                                                            ]; return aboutIn[fWord];
                                                        }

                                                    // Build the options for relative date formatting.
                                                    protected Json[string] _options(Json[string] options, string classname) {
                                                        auto updatedOptions = options.update[
                                                            "from": classname.now(),
                                                            "timezone": Json(null),
                                                            "format": classname.wordFormat,
                                                            "accuracy": classname.wordAccuracy,
                                                            "end": classname.wordEnd,
                                                            "relativeString": __d("uim", "%s ago"),
                                                            "absoluteString": __d("uim", "on %s"),
                                                        ]; if (options.isString("accuracy")) {
                                                            auto accuracy = options["accuracy"];
                                                                options["accuracy"] = null;
                                                                classname.wordAccuracy.byKeyValue
                                                                .each!(keyLevel => options.set(
                                                                    "accuracy." ~ keyLevel.key, accuracy));

                                                        } else {
                                                            options["accuracy"] += classname
                                                                .wordAccuracy; }
                                                            return options; }
                                                        }
