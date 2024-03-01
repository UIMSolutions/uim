module uim.i18n.classes.formatters.formatter;

import uim.i18n;

@safe:

// A formatter that will interpolate variables using the MessageFormatter class
class Formatter : IFormatter {
    // Returns a string with all passed variables interpolated into the original message. 
    string format(string messageLocale, string messageToTranslate, string[] tokenValues) {
        return messageToTranslate;
    }
}