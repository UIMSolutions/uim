module uim.i18n.classes.formatters.icu;

import uim.i18n;

@safe:

// A formatter that will interpolate variables using the MessageFormatter class
class DIcuFormatter : DI18NFormatter {
    // Returns a string with all passed variables interpolated into the original message.
    override string format(string messageLocale, string messageToTranslate, string[] tokenValues) {
        if (messageToTranslate.isEmpty) {
            return messageToTranslate;
        }
        
        // TODO auto formatter = new DMessageFormatter(messageLocale, messageToTranslate);
        string result; // TODO = formatter.format(tokenValues);
        /* if (result.isEmpty) {
            throw new DI18nException(formatter.getErrorMessage(), formatter.getErrorCode());
        } */ 
        return result;
    }
}
