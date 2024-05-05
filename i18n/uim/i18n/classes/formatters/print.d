module uim.i18n.classes.formatters.print;

import uim.i18n;

@safe:

// A formatter that will interpolate variables and select the correct plural form when required
class DPrintFormatter : DI18NFormatter {
    // Returns a string with all passed variables interpolated into the original message. 
    string format(string messageLocale, string messageToTranslate, string[] tokenValues) {
        // TODO return messageToTranslate.format(tokenValues);
        return null; 
    } 
}
