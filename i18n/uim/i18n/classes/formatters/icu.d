module uim.i18n.classes.formatters.icu;

import uim.i18n;

@safe:

// A formatter that will interpolate variables using the MessageFormatter class
class IcuFormatter : Formatter {
    // Returns a string with all passed variables interpolated into the original message.
    string format(string messageLocale, string messageToTranslate, string[] tokenValues) {
        if (messageToTranslate.isEmpty) {
            return messageToTranslate;
        }
        
        auto formatter = new MessageFormatter(messageLocale, messageToTranslate);
        string result = formatter.format(tokenValues);
        if (result.isEmpty) {
            throw new I18nException(formatter.getErrorMessage(), formatter.getErrorCode());
        }
        return result;
    }
}
