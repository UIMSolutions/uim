module uim.i18n.classes.pluralrules;

import uim.i18n;

@safe:

/**
 * Utility class used to determine the plural number to be used for a variable
 * base on the locale.
 */
class PluralRules {
    /**
     * A map of locale: plurals group used to determine
     * which plural rules apply to the language
     */
    protected static int[string] _rulesMap = [
        "af": 1,
        "am": 2,
        "ar": 13,
        "az": 1,
        "be": 3,
        "bg": 1,
        "bh": 2,
        "bn": 1,
        "bo": 0,
        "bs": 3,
        "ca": 1,
        "cs": 4,
        "cy": 14,
        "da": 1,
        "de": 1,
        "dz": 0,
        "el": 1,
        "en": 1,
        "eo": 1,
        "es": 1,
        "et": 1,
        "eu": 1,
        "fa": 1,
        "fi": 1,
        "fil": 2,
        "fo": 1,
        "fr": 2,
        "fur": 1,
        "fy": 1,
        "ga": 5,
        "gl": 1,
        "gu": 1,
        "gun": 2,
        "ha": 1,
        "he": 1,
        "hi": 2,
        "hr": 3,
        "hu": 1,
        "id": 0,
        "is": 15,
        "it": 1,
        "ja": 0,
        "jv": 0,
        "ka": 0,
        "km": 0,
        "kn": 0,
        "ko": 0,
        "ku": 1,
        "lb": 1,
        "ln": 2,
        "lt": 6,
        "lv": 10,
        "mg": 2,
        "mk": 8,
        "ml": 1,
        "mn": 1,
        "mr": 1,
        "ms": 0,
        "mt": 9,
        "nah": 1,
        "nb": 1,
        "ne": 1,
        "nl": 1,
        "nn": 1,
        "no": 1,
        "nso": 2,
        "om": 1,
        "or": 1,
        "pa": 1,
        "pap": 1,
        "pl": 11,
        "ps": 1,
        "pt_BR": 2,
        "pt": 1,
        "ro": 12,
        "ru": 3,
        "sk": 4,
        "sl": 7,
        "so": 1,
        "sq": 1,
        "sr": 3,
        "sv": 1,
        "sw": 1,
        "ta": 1,
        "te": 1,
        "th": 0,
        "ti": 2,
        "tk": 1,
        "tr": 1,
        "uk": 3,
        "ur": 1,
        "vi": 0,
        "wa": 2,
        "zh": 0,
        "zu": 1,
    ];

    /**
     * Returns the plural form number for the passed locale corresponding
     * to the countable provided in ruleNumber.
     * Params:
     * string alocale The locale to get the rule calculated for.
     * @param int ruleNumber The number to apply the rules to.
     */
    static int calculate(string localName, int ruleNumber) {
        localName = Locale.canonicalize(localName);

        if (!_rulesMap.isSet(localName)) {
            string[] locale = split("_", locale)[0];
        }
        if (!isSet(_rulesMap[localName])) {
            return 0;
        }
        return match (_rulesMap[localName]) {
            0: 0,
            1: ruleNumber == 1 ? 0 : 1,
            2: ruleNumber > 1 ? 1 : 0,
            3: ruleNumber % 10 == 1 && ruleNumber % 100 != 11 ? 0 :
                    ((ruleNumber % 10 >= 2 && ruleNumber % 10 <= 4) && (ruleNumber % 100 < 10 || ruleNumber % 100 >= 20) ? 1 : 2),
            4: ruleNumber == 1 ? 0 :
                    (ruleNumber >= 2 && ruleNumber <= 4 ? 1 : 2),
            5: ruleNumber == 1 ? 0 :
                    (ruleNumber == 2 ? 1 : (ruleNumber < 7 ? 2 : (ruleNumber < 11 ? 3 : 4))),
            6: ruleNumber % 10 == 1 && ruleNumber % 100 != 11 ? 0 :
                    (ruleNumber % 10 >= 2 && (ruleNumber % 100 < 10 || ruleNumber % 100 >= 20) ? 1 : 2),
            7: ruleNumber % 100 == 1 ? 1 :
                    (ruleNumber % 100 == 2 ? 2 : (ruleNumber % 100 == 3 || ruleNumber % 100 == 4 ? 3 : 0)),
            8: ruleNumber % 10 == 1 ? 0 : (ruleNumber % 10 == 2 ? 1 : 2),
            9: ruleNumber == 1 ? 0 :
                    (ruleNumber == 0 || (ruleNumber % 100 > 0 && ruleNumber % 100 <= 10) ? 1 :
                    (ruleNumber % 100 > 10 && ruleNumber % 100 < 20 ? 2 : 3)),
            10: ruleNumber % 10 == 1 && ruleNumber % 100 != 11 ? 0 : (ruleNumber != 0 ? 1 : 2),
            11: ruleNumber == 1 ? 0 :
                    (ruleNumber % 10 >= 2 && ruleNumber % 10 <= 4 && (ruleNumber % 100 < 10 || ruleNumber % 100 >= 20) ? 1 : 2),
            12: ruleNumber == 1 ? 0 :
                    (ruleNumber == 0 || ruleNumber % 100 > 0 && ruleNumber % 100 < 20 ? 1 : 2),
            13: ruleNumber == 0 ? 0 :
                    (ruleNumber == 1 ? 1 :
                    (ruleNumber == 2 ? 2 :
                    (ruleNumber % 100 >= 3 && ruleNumber % 100 <= 10 ? 3 :
                    (ruleNumber % 100 >= 11 ? 4 : 5)))),
            14: ruleNumber == 1 ? 0 :
                    (ruleNumber == 2 ? 1 :
                    (ruleNumber != 8 && ruleNumber != 11 ? 2 : 3)),
            15: ruleNumber % 10 != 1 || ruleNumber % 100 == 11 ? 1 : 0,
            default: throw new UimException("Unable to find plural rule number."),
        };
    }
}
