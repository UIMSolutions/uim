module uim.i18n.classes.formatters.print;

import uim.i18n;

@safe:

/**
 * A formatter that will interpolate variables using sprintf and
 * select the correct plural form when required
 */
class PrintFormatter : DI18NFormatter {
    // Returns a string with all passed variables interpolated into the original message. 
    /* string format(string messageLocale, string messageToTranslate, string[] tokenValues) {
        return messageToTranslate.format(tokenValues);
    } */ 
}
