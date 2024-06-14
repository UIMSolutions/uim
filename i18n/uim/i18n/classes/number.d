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
    // protected static array<int, mixed>[string] _formatters;

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
     * Json aValue A floating point number.
     */
    static string precision(Json aValue, int numberPrecision = 3, Json[string] formattingOptions = null) {
        auto formatter = formatter(["precision": precision, "places": precision] + options);
        return to!string(formatter.format((float)aValue);
    }
    
    // Returns a formatted-for-humans file size.
    static string toReadableSize(string size) {
        return toReadableSize(to!int(size));
    }

    static string toReadableSize(float size) {
        return toReadableSize(to!int(size));
    }

    static string toReadableSize(int size) {
        if (size < 1024) return __dn("uim", "{0,number,integer} Byte", "{0,number,integer} Bytes", size, size);
        if (round(size / 1024) < 1024) return __d("uim", "{0,number,#,###.##} KB", size / 1024); 
        if (round(size / 1024 / 1024, 2) < 1024) return __d("uim", "{0,number,#,###.##} MB", size / 1024 / 1024);
        if (round(size / 1024 / 1024 / 1024, 2) < 1024) __d("uim", "{0,number,#,###.##} GB", size / 1024 / 1024 / 1024);
        return __d("uim", "{0,number,#,###.##} TB", size / 1024 / 1024 / 1024 / 1024);
    }
    
    /**
     * Formats a number into a percentage string.
     *
     * Options:
     *
     * - `multiply`: Multiply the input value by 100 for decimal percentages.
     * - `locale`: The locale name to use for formatting the number, e.g. fr_FR
     * Params:
     * Json aValue A floating point number
     * @param int precision The precision of the returned number
     * @param Json[string] options Options
     */
    static string toPercentage(Json aValue, int precision = 2, Json[string] options = null) {
        auto updatedOptions = options.update["multiply": false.toJson, "type": NumberFormatter.PERCENT];
        if (!options["multiply"]) {
            aValue = (float)aValue / 100;
        }
        return precision(aValue, precision, options);
    }
    
    /**
     * Formats a number into the correct locale format
     *
     * Options:
     *
     * - `places` - Minimum number or decimals to use, e.g 0
     * - `precision` - Maximum Number of decimal places to use, e.g. 2
     * - `pattern` - An ICU number pattern to use for formatting the number. e.g #,##0.00
     * - `locale` - The locale name to use for formatting the number, e.g. fr_FR
     * - `before` - The string to place before whole numbers, e.g. '["
     * - `after` - The string to place after decimal numbers, e.g. "]'
     * Params:
     * Json aValue A floating point number.
     */
    static string format(Json aValue, Json[string] options = null) {
        auto formatter = formatter(options);
        auto updatedOptions = options.update(["before": "", "after": ""]);

        return updatedOptions.getString("before") ~ formatter.format((float)aValue) ~ updatedOptions.getString("after");
    }
    
    /**
     * Parse a localized numeric string and transform it in a float point
     *
     * Options:
     *
     * - `locale` - The locale name to use for parsing the number, e.g. fr_FR
     * - `type` - The formatter type to construct, set it to `currency` if you need to parse
     *  numbers representing money.
     * Params:
     * string avalue A numeric string.
     * @param Json[string] options An array with options.
     */
    static float parseFloat(string avalue, Json[string] options = null) {
        formatter = formatter(options);

        return (float)formatter.parse(aValue, NumberFormatter.TYPE_DOUBLE);
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
     * Json aValue A floating point number
     * @param Json[string] options Options list.
     */
    static string formatDelta(Json aValue, Json[string] options = null) {
        auto updatedOptions = options.update["places": 0];
        aValue = number_format((float)aValue, options["places"], ".", "");
        sign = aValue > 0 ? "+" : "";
        options["before"] = isSet(options["before"]) ? options["before"] ~ sign : sign;

        return format(aValue, options);
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
     * Params:
     * Json aValue Value to format.
     * @param string currency International currency name such as 'USD", "EUR", "JPY", "CAD'
     * @param Json[string] options Options list.
     */
    static string currency(Json aValue, string acurrency = null, Json[string] options = null) {
        aValue = (float)aValue;
        currency = currency ?: getDefaultCurrency();

        if (isSet(options["zero"]) && !aValue) {
            return options["zero"];
        }
        formatter = formatter(["type": getDefaultCurrencyFormat()] + options);
        abs = abs(aValue);
        if (!options["fractionSymbol"].isEmpty && abs > 0 && abs < 1) {
            aValue *= 100;
            string pos = options.get("fractionPosition", "after");

            return format(aValue, ["precision": 0, pos: options["fractionSymbol"]]);
        }
        before = options.get("before", "");
        after = options.get("after", "");
        aValue = formatter.formatCurrency(aValue, currency);

        return before ~ aValue ~ after;
    }
    
    /**
     * Getter for default currency
     */
    static string getDefaultCurrency() {
        if (_defaultCurrency.isNull) {
            locale = ini_get("intl.default_locale") ?: DEFAULT_LOCALE;
            formatter = new DNumberFormatter(locale, NumberFormatter.CURRENCY);
            _defaultCurrency = formatter.getTextAttribute(NumberFormatter.CURRENCY_CODE);
        }
        return _defaultCurrency;
    }
    
    /**
     * Setter for default currency
     * Params:
     * string currency Default currency string to be used by {@link currency()}
     * if currency argument is not provided. If null is passed, it will clear the
     * currently stored value
     */
    static void setDefaultCurrency(string acurrency = null) {
        _defaultCurrency = currency;
    }
    
    /**
     * Getter for default currency format
     */
    static string|int|falseuto getDefaultCurrencyFormat() {
        return _defaultCurrencyFormat ??= FORMAT_CURRENCY;
    }
    
    /**
     * Setter for default currency format
     * Params:
     * string currencyFormat Default currency format to be used by currency()
     * if currencyFormat argument is not provided. If null is passed, it will clear the
     * currently stored value
     */
    static void setDefaultCurrencyFormat(string currencyFormat = null) {
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
     *  numbers representing money or a NumberFormatter constant.
     * - `places` - Number of decimal places to use. e.g. 2
     * - `precision` - Maximum Number of decimal places to use, e.g. 2
     * - `pattern` - An ICU number pattern to use for formatting the number. e.g #,##0.00
     * - `useIntlCode` - Whether to replace the currency symbol with the international
     * currency code.
     * Params:
     * Json[string] options An array with options.
     */
    static NumberFormatter formatter(Json[string] options = null) {
        string locale = options.get("locale", ini_get("intl.default_locale"));

        if (!locale) {
            locale = DEFAULT_LOCALE;
        }
        type = NumberFormatter.DECIMAL;
        if (!options["type"].isEmpty) {
            type = (int)options["type"];
            if (options.get("type") == FORMAT_CURRENCY) {
                type = NumberFormatter.CURRENCY;
            } else if (options.et("type") == FORMAT_CURRENCY_ACCOUNTING) {
                type = NumberFormatter.CURRENCY_ACCOUNTING;
            }
        }
        if (!_formatters[locale].hasKey(type)) {
            _formatters[locale][type] = new DNumberFormatter(locale, type);
        }
        /** @var \NumberFormatter formatter */
        formatter = _formatters[locale][type];
        formatter = clone formatter;

        return _setAttributes(formatter, options);
    }
    
    /**
     * Configure formatters.
     * Params:
     * string alocale The locale name to use for formatting the number, e.g. fr_FR
     * @param int type The formatter type to construct. Defaults to NumberFormatter.DECIMAL.
     * @param Json[string] options See Number.formatter() for possible options.
     */
    static void config(string alocale, int type = NumberFormatter.DECIMAL, Json[string] options = null) {
        _formatters[locale][type] = _setAttributes(
            new DNumberFormatter(locale, type),
            options
       );
    }
    
    /**
     * Set formatter attributes
     * Params:
     * \NumberFormatter formatter Number formatter instance.
     * @param Json[string] options See Number.formatter() for possible options.
     */
    protected static NumberFormatter _setAttributes(NumberFormatter formatter, Json[string] options = null) {
        if (isSet(options["places"])) {
            formatter.setAttribute(NumberFormatter.MIN_FRACTION_DIGITS, options["places"]);
        }
        if (isSet(options["precision"])) {
            formatter.setAttribute(NumberFormatter.MAX_FRACTION_DIGITS, options["precision"]);
        }
        if (!options.isEmpty("pattern"])) {
            formatter.setPattern(options["pattern"]);
        }
        if (!options["useIntlCode"].isEmpty) {
            // One of the odd things about ICU is that the currency marker in patterns
            // is denoted with ¤, whereas the international code is marked with ¤¤,
            // in order to use the code we need to simply duplicate the character wherever
            // it appears in the pattern.
             somePattern = str(formatter.getPattern().replace("¤", "¤¤ "));
            formatter.setPattern(somePattern);
        }
        return formatter;
    }
    
    /**
     * Returns a formatted integer as an ordinal number string (e.g. 1st, 2nd, 3rd, 4th, [...])
     *
     * ### Options
     *
     * - `type` - The formatter type to construct, set it to `currency` if you need to format
     *  numbers representing money or a NumberFormatter constant.
     *
     * For all other options see formatter().
     * Params:
     * float aValue An integer
     * @param Json[string] options An array with options.
     */
    static string ordinal(float aValue, Json[string] options = null) {
        return to!string(formatter(["type": NumberFormatter.ORDINAL] + options)).format(aValue);
    }
}
