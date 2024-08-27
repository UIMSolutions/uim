module uim.views.helpers.number;

import uim.views;

@safe:

/**
 * Number helper library.
 *
 * Methods to make numbers more readable.
 *
 * @method string ordinal(float myvalue, Json[string] options = null) See Number.ordinal()
 * @method string precision(Json mynumber, int myprecision = 3, Json[string] options = null) See Number.precision()
 * @method string toPercentage(Json myvalue, int myprecision = 3, Json[string] options = null) See Number.toPercentage()
 * @method string toReadableSize(Json mysize) See Number.toReadableSize()
 */
class DNumberHelper : DHelper {
    mixin(HelperThis!("Number"));

    override IEvent[] implementedEvents() {
        return null;
    }

    // Call methods from UIM\I18n\Number utility class
    Json __call(string methodName, Json[string] params) {
        // return Number.{methodName}(...params);
        return Json(null);
    }
    
    /**
     * Formats a number into the correct locale format
     *
     * Options:
     *
     * - `places` - Minimum number or decimals to use, e.g 0
     * - `precision` - Maximum Number of decimal places to use, e.g. 2
     * - `locale` - The locale name to use for formatting the number, e.g. fr_FR
     * - `before` - The string to place before whole numbers, e.g. "["
     * - `after` - The string to place after decimal numbers, e.g. "]"
     * - `escape` - Whether to escape html in resulting string
     * Params:
     * Json mynumber A floating point number.
     */
    string format(Json mynumber, Json[string] options = null) {
        // TODOD 
        /* auto formattedNumber = Number.format(mynumber, options);
        auto auto updatedOptions = options.update["escape": true.toJson];

        return options.get("escape"] ? htmlAttributeEscape(formattedNumber) : formattedNumber; */
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
     *  valid options are "before" & "after".
     * - `before` - Text to display before the rendered number
     * - `after` - Text to display after the rendered number
     * - `zero` - The text to use for zero values, can be a string or a number. e.g. 0, "Free!"
     * - `places` - Number of decimal places to use. e.g. 2
     * - `precision` - Maximum Number of decimal places to use, e.g. 2
     * - `pattern` - An ICU number pattern to use for formatting the number. e.g #,##0.00
     * - `useIntlCode` - Whether to replace the currency symbol with the international
     * currency code.
     * - `escape` - Whether to escape html in resulting string
     * Params:
     * string|float mynumber Value to format.
     */
    string currency(float value, string currencyName = null, Json[string] options = null) {
        // return currency(Number.currency(value, currencyName, options), currencyName, options);
        return null;
    }

    string currency(string mynumber, string currencyName = null, Json[string] options = null) {
/*         auto formattedCurrency = Number.currency(mynumber, currencyName, options);
        options.merge("escape", true);
        return options.hasKey("escape") ? htmlAttributeEscape(formattedCurrency) : formattedCurrency;
        */
        return null;    
 }
    
    /**
     * Formats a number into the correct locale format to show deltas (signed differences in value).
     *
     * ### Options
     *
     * - `places` - Minimum number or decimals to use, e.g 0
     * - `precision` - Maximum Number of decimal places to use, e.g. 2
     * - `locale` - The locale name to use for formatting the number, e.g. fr_FR
     * - `before` - The string to place before whole numbers, e.g. "["
     * - `after` - The string to place after decimal numbers, e.g. "]"
     * - `escape` - Set to false to prevent escaping
     */
    string formatDelta(float value, Json[string] options = null) {
        // return formatDelta(Number.formatDelta(value, options));
        return null;
    }

    string formatDelta(string value, Json[string] options = null) {
/*         auto formattedNumber = Number.formatDelta(value, options);
        options.merge("escape", true);
        return options.hasKey("escape") ? htmlAttributeEscape(formattedNumber) : formattedNumber; */
        return null;    
    }
}
