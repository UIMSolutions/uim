module uim.views.helpers.number;

import uim.views;

@safe:

/**
 * Number helper library.
 *
 * Methods to make numbers more readable.
 *
 * @method string ordinal(float|int myvalue, Json[string] options  = null) See Number.ordinal()
 * @method string precision(Json mynumber, int myprecision = 3, Json[string] options  = null) See Number.precision()
 * @method string toPercentage(Json myvalue, int myprecision = 3, Json[string] options  = null) See Number.toPercentage()
 * @method string toReadableSize(Json mysize) See Number.toReadableSize()
 */
class DNumberHelper : DHelper {
    mixin(HelperThis!("Number"));

    IEvent[] implementedEvents() {
        return null;
    }

    /**
     * Call methods from UIM\I18n\Number utility class
     * Params:
     * string mymethod Method to invoke
     * @param Json[string] myparams Array of params for the method.
     * /
    Json __call(string mymethod, Json[string] myparams) {
        return Number.{mymethod}(...myparams);
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
    string format(Json mynumber, Json[string] options  = null) {
        // TODOD 
        /* auto formattedNumber = Number.format(mynumber, options);
        auto options = options.update["escape": true.toJson];

        return options["escape"] ? htmlAttribEscape(formattedNumber) : formattedNumber; */
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
     *   valid options are "before" & "after".
     * - `before` - Text to display before the rendered number
     * - `after` - Text to display after the rendered number
     * - `zero` - The text to use for zero values, can be a string or a number. e.g. 0, "Free!"
     * - `places` - Number of decimal places to use. e.g. 2
     * - `precision` - Maximum Number of decimal places to use, e.g. 2
     * - `pattern` - An ICU number pattern to use for formatting the number. e.g #,##0.00
     * - `useIntlCode` - Whether to replace the currency symbol with the international
     *  currency code.
     * - `escape` - Whether to escape html in resulting string
     * Params:
     * string|float mynumber Value to format.
     * @param string|null mycurrency International currency name such as "USD", "EUR", "JPY", "CAD"
     * @param Json[string] options Options list.
     * /
    string currency(string|float mynumber, string mycurrency = null, Json[string] options  = null) {
        auto formattedCurrency = Number.currency(mynumber, mycurrency, options);
        auto options = options.update["escape": true.toJson];

        return options["escape"] ? htmlAttribEscape(formattedCurrency) : formattedCurrency;
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
     * Params:
     * string|float myvalue A floating point number
     * @param Json[string] options Options list.
     * /
    string formatDelta(string|float myvalue, Json[string] options  = null) {
        myformatted = Number.formatDelta(myvalue, options);
        options = options.update["escape": true.toJson];

        return options["escape"] ? htmlAttribEscape(myformatted): myformatted;
    } */
}
