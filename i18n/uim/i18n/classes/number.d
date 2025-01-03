/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.i18n.classes.number;

import uim.i18n;

@safe:

/**
 * Number helper library.
 * Methods to make numbers more readable.
 */
class DNumber {
    mixin TConfigurable;

    this() {
        initialize;
    }

    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    // Default locale
    const string DEFAULT_LOCALE = "en_US";

    // Format type to format as currency
    const string FORMAT_CURRENCY = "currency";

    // Format type to format as currency, accounting style (negative numbers in parentheses)
    const string FORMAT_CURRENCY_ACCOUNTING = "currency_accounting";

    // A list of number formatters indexed by locale and type
    protected static Json[int][string] _formatters;

    // Default currency used by Number.currency()
    protected static string _defaultCurrency;

    // Default currency format used by Number.currency()
    protected static string _defaultCurrencyFormat;

    /**
     * Formats a number with a level of precision.
     *
     * Options:
     * - `locale`: The locale name to use for formatting the number, e.g. fr_FR
     * Params:
     * Json value A floating point number.
     */
    static string precision(Json value, int numberPrecision = 3, Json[string] formattingOptions = null) {
        /* auto formatter = formatter(["precision": precision, "places": precision] + options);
        return to!string(formatter.format( /* (float)  * / value)); */
        return null; 
    }

    // Returns a formatted-for-humans file size.
    static string toReadableSize(string size) {
        return toReadableSize(to!int(size));
    }

    static string toReadableSize(float size) {
        return toReadableSize(to!int(size));
    }

    static string toReadableSize(int size) {
        /* if (size < 1024)
            return `__dn("uim", "{0,number,integer} Byte", "{0,number,integer} Bytes", size, size)`;
        if (round(size / 1024) < 1024)
            return `__d("uim", "{0,number,#,###.##} KB", size / 1024)`;
        if (round(size / 1024 / 1024, 2) < 1024)
            return `__d("uim", "{0,number,#,###.##} MB", size / 1024 / 1024)`;
        if (round(size / 1024 / 1024 / 1024, 2) < 1024)
            `__d("uim", "{0,number,#,###.##} GB", size / 1024 / 1024 / 1024)`; */
        return `__d("uim", "{0,number,#,###.##} TB", size / 1024 / 1024 / 1024 / 1024)`;
    }

    /**
     * Formats a number into a percentage string.
     * Options:
     * - `multiply`: Multiply the input value by 100 for decimal percentages.
     * - `locale`: The locale name to use for formatting the number, e.g. fr_FR
     */
    static string toPercentage(Json value, int precision = 2, Json[string] options = null) {
        options
            .merge("multiply", false)
            .merge("type", NumberFormatters.PERCENT);
        
        auto doubleValue = 0.0;
        if (!options.getBoolean("multiply")) {
            doubleValue = value.getDouble / 100;
        }
        // return precision(doubleValue, precision, options);
        return null; 
    }

    /**
     * Formats a number into the correct locale format
     *
     * Options:
     * - `places` - Minimum number or decimals to use, e.g 0
     * - `precision` - Maximum Number of decimal places to use, e.g. 2
     * - `pattern` - An ICU number pattern to use for formatting the number. e.g #,##0.00
     * - `locale` - The locale name to use for formatting the number, e.g. fr_FR
     * - `before` - The string to place before whole numbers, e.g. '["
     * - `after` - The string to place after decimal numbers, e.g. "]'
     */
    static string format(Json floatNumber, Json[string] options = null) {
        auto formatter = formatter(options);
        // options.merge(["before", "after"], "");
        /* return options.getString("before") ~ formatter.format(floatNumber.getDouble) ~ options.getString("after"); */
        return null;
    }

    /**
     * Parse a localized numeric string and transform it in a float point
     *
     * Options:
     * - `locale` - The locale name to use for parsing the number, e.g. fr_FR
     * - `type` - The formatter type to construct, set it to `currency` if you need to parse
     *  numbers representing money.
     */
    static float parseFloat(string value, Json[string] options = null) {
        auto parseFormatter = formatter(options);
        /* return  /* (float) * / formatter
            .parseFormatter(value, NumberFormatters.TYPE_DOUBLE); */
        return 0;
    }

    /**
     * Formats a number into the correct locale format to show deltas (signed differences in value).
     *
     * ### Options
     *
     * - `places` - Minimum number or decimals to use, e.g 0
     * - `precision` - Maximum Number of decimal places to use, e.g. 2
     * - `locale` - The locale name to use for formatting the number, e.g. fr_FR
     * - `before` - The string to place before whole numbers, e.g. '["
     * - `after` - The string to place after decimal numbers, e.g. "]'
     * Params:
     */
    static string formatDelta(Json value, Json[string] options = null) {
        options.set("places", 0);
        /* auto doubleValue = number_format(
            value.getDouble, options.get("places"], ".", "");
        string sign = doubleValue > 0 ? "+" : "";
        options.set("before", options.getString("before") ~ sign);
        return format
        (value, options); */
        return null; 
    }

    /**
     * Formats a number into a currency format.
     *
     * ### Options
     *
     * - `locale` - The locale name to use for formatting the number, e.g. fr_FR
     * - `fractionSymbol` - The currency symbol to use for fractional numbers.
     * - `fractionPosition` - The position the fraction symbol should be placed
     *  valid options are 'before' & 'after'.
     * - `before` - Text to display before the rendered number
     * - `after` - Text to display after the rendered number
     * - `zero` - The text to use for zero values, can be a string or a number. e.g. 0, "Free!'
     * - `places` - Number of decimal places to use. e.g. 2
     * - `precision` - Maximum Number of decimal places to use, e.g. 2
     * - `pattern` - An ICU number pattern to use for formatting the number. e.g #,##0.00
     * - `useIntlCode` - Whether to replace the currency symbol with the international
     * currency code.
     */
    static string currency(Json value, string currencyName = null, Json[string] options = null) {
        double doubleValue = value.getDouble;
        currencyName = currencyName ? currencyName : getDefaultCurrency();
        if (options.hasKey("zero") && !value) {
            return options.getString("zero");
        }

        /* auto formatter = formatter(
            ["type": getDefaultCurrencyFormat()]/* .merge(options) * /); */
        auto abs = abs(doubleValue);
        if (
            options.hasKey("fractionSymbol") && abs > 0 && abs < 1) {
            doubleValue *= 100;
            string pos = options.getString("fractionPosition", "after");
            /* return format(doubleValue, [
                    "precision": 0,
                    /* pos: options.get("fractionSymbol") * /
                ]); */
        }
        auto before = options.getString("before", "");
        auto after = options.getString("after", "");
        /* return before ~ formatter.formatCurrency(
            doubleValue, currencyName) ~ after; */
        return null; 
    }

    // Getter for default currency
    static string getDefaultCurrency() {
        if (_defaultCurrency.isNull) {
            /* auto locale = ini_get("intl.default_locale") ? ini_get(
                "intl.default_locale") : DEFAULT_LOCALE;
            auto formatter = new NumberFormatters(locale, NumberFormatters
                    .CURRENCY);
            _defaultCurrency = formatter.getTextAttribute(
                NumberFormatters.CURRENCY_CODE); */
        }
        return _defaultCurrency;
    }

    // Setter for default currency
    static void setDefaultCurrency(
        string currency = null) {
        _defaultCurrency = currency;
    }

    // Getter for default currency format
    static string /* int|falseuto */ getDefaultCurrencyFormat() {
        // return _defaultCurrencyFormat ? _defaultCurrencyFormat : FORMAT_CURRENCY;
        return null; 
    }

    /**
     * Setter for default currency format
     * Params:
     * string currencyFormat Default currency format to be used by currency()
     * if currencyFormat argument is not provided. If null is passed, it will clear the
     * currently stored value
     */
    static void setDefaultCurrencyFormat(
        string currencyFormat = null) {
        _defaultCurrencyFormat = currencyFormat;
    }

    /**
     * Returns a formatter object that can be reused for similar formatting task
     * under the same locale and options. This is often a speedier alternative to
     * using other methods in this class DAs only one formatter object needs to be
     * constructed.
     *
     * ### Options
     *
     * - `locale` - The locale name to use for formatting the number, e.g. fr_FR
     * - `type` - The formatter type to construct, set it to `currency` if you need to format
     *  numbers representing money or a NumberFormatters constant.
     * - `places` - Number of decimal places to use. e.g. 2
     * - `precision` - Maximum Number of decimal places to use, e.g. 2
     * - `pattern` - An ICU number pattern to use for formatting the number. e.g #,##0.00
     * - `useIntlCode` - Whether to replace the currency symbol with the international
     * currency code.
     * Params:
     * Json[string] options An array with options.
     */
    static auto formatter(
        Json[string] options = null) {
        string locale;
        /* locale = options.getString("locale", ini_get(
                "intl.default_locale")); */
        if (!locale) {
            locale = "DEFAULT_LOCALE";
        }
        auto type = cast(string)NumberFormatters.DECIMAL;
        if (options.hasKey("type")) {
            type = options.getString("type");
            /* if (type == FORMAT_CURRENCY) {
                type = cast(string) NumberFormatters.CURRENCY;
            } else if (
                type == FORMAT_CURRENCY_ACCOUNTING) {
                type = cast(string) NumberFormatters.CURRENCY_ACCOUNTING;
            } */
        }
        /* if (!_formatters[locale].hasKey(type)) {
            _formatters[locale][type] = new NumberFormatters(
                locale, type);
        } */
        /** @var \NumberFormatter formatter */
        /* formatter = _formatters[locale][type];
        formatter = formatter.clone;

        return _setAttributes(
            formatter, options); */
        return null;
    }

    /**
     * Configure formatters.
     * Params:
     * string alocale The locale name to use for formatting the number, e.g. fr_FR
     */
    /* static void config(string localeName, int formatterType = NumberFormatters.DECIMAL, Json[string] options = null) {
        _formatters[localeName][formatterType] = _setAttributes(
            new NumberFormatters(localeName, type), options);
    } */

    // Set formatter attributes
    /* protected static NumberFormatters _setAttributes(
        NumberFormatters formatter, Json[string] options = null) {
        if (options.hasKey("places")) {
            formatter.setAttribute(
                NumberFormatters.MIN_FRACTION_DIGITS, options.get("places"]);
        }
        if (options.hasKey("precision")) {
            formatter.setAttribute(
                NumberFormatters.MAX_FRACTION_DIGITS, options.get("precision"]);
        }
        if (options.hasKey("pattern")) {
            formatter.setPattern(
                options.get("pattern"]);
        }
        if (options.hasKey(
                "useIntlCode")) {
            // One of the odd things about ICU is that the currency marker in patterns
            // is denoted with ¤, whereas the international code is marked with ¤¤,
            // in order to use the code we need to simply duplicate the character wherever
            // it appears in the pattern.
            formatter.setPattern(
                str(formatter.getPattern()
                    .replace("¤", "¤¤ ")));
        }
        return formatter;
    } */

    /**
     * Returns a formatted integer as an ordinal number string (e.g. 1st, 2nd, 3rd, 4th, [...])
     *
     * ### Options
     *
     * - `type` - The formatter type to construct, set it to `currency` if you need to format
     *  numbers representing money or a NumberFormatters constant.
     *
     * For all other options see formatter().
     * Params:
     * float value An integer
     */
    static string ordinal(float value, Json[string] options = null) {
        /* return to!string(formatter(
                [
                    "type": NumberFormatters.ORDINAL
                ].merge(options))).format(value); */
        return null; 
    }
}
