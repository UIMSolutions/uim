module uim.i18n.helpers.functions;

import uim.i18n;

@safe:
/**
 * Returns a translated string if one is found; Otherwise, the submitted message.
 *
 * @param string singular Text to translate.
 * @param Json[string] arguments Array with arguments or multiple arguments in function.
 */
string __(string singular, Json[string] arguments) {
    /* if (!singular) {
        return null;
    }
    if (isSet(someArguments[0]) && isArray(someArguments[0])) {
        someArguments = someArguments[0];
    }
    return I18n.getTranslator().translate(singular, someArguments); */
    return null; 
}
/**
 * Returns correct plural form of message identified by singular and plural for count count.
 * Some languages have more than one form for plural messages dependent on the count.
 */
string __n(string singularText, string pluralText, size_t count, Json[string] arguments) {
    /* if (!singularText) {
        return null;
    }
    if (isSet(someArguments[0]) && isArray(someArguments[0])) {
        someArguments = someArguments[0];
    }
    return I18n.getTranslator().translate(
        plural,
        ["_count": count, "_singular": singularText] + someArguments
   ); */
   return null;
}

// Allows you to override the current domain for a single message lookup.
string __d(string domainName, string messageToTranslate, Json[string] arguments) {
    if (messageToTranslate.isEmpty) {
        return null;
    }

    /* 
    if (isSet(someArguments[0]) && isArray(someArguments[0])) {
        someArguments = someArguments[0];
    }
    return I18n.getTranslator(domainName).translate(messageToTranslate, someArguments); */
    return null;
}

/**
 * Allows you to override the current domain for a single plural message lookup.
 * Returns correct plural form of message identified by singular and plural for count count
 * from domain domain.
 */
string __dn(string domainName, string singularText, string pluralText, int count, Json[string] arguments): 
{
    if (singular.isEmpty) {
        return null;
    }
    if (isSet(someArguments[0]) && isArray(someArguments[0])) {
        someArguments = someArguments[0];
    }
    return I18n.getTranslator(domainName).translate(
        plural,
        ["_count": count, "_singular": singularText] + someArguments
   );
}
/**
 * Returns a translated string if one is found; Otherwise, the submitted message.
 * The context is a unique identifier for the translations string that makes it unique
 * within the same domain.
 *
 * @param string acontext DContext of the text.
 * @param string singular Text to translate.
 * @param Json[string] arguments Array with arguments or multiple arguments in function.
 */
string __x(string acontext, string singular, Json[string] arguments)
{
    if (!singular) {
        return null;
    }
    if (isSet(someArguments[0]) && someArguments[0].isArray) {
        someArguments = someArguments[0];
    }
    return I18n.getTranslator().translate(singular, ["_context": context] + someArguments);
}
/**
 * Returns correct plural form of message identified by singular and plural for count count.
 * Some languages have more than one form for plural messages dependent on the count.
 * The context is a unique identifier for the translations string that makes it unique
 * within the same domain.
 */
string __xn(string context, string singularText, string pluralText, size_t count, Json[string] arguments) {
    if (!singularText) {
        return null;
    }
    if (isSet(someArguments[0]) && isArray(someArguments[0])) {
        someArguments = someArguments[0];
    }
    return I18n.getTranslator().translate(
        pluralText,
        ["_count": count, "_singular": singularText, "_context": context] + someArguments
   );
}

/**
 * Allows you to override the current domain for a single message lookup.
 * The context is a unique identifier for the translations string that makes it unique
 * within the same domain.
 *
 * @param string domainName Domain.
 * @param string acontext DContext of the text.
 * @param string amsg String to translate.
 * @param Json[string] arguments Array with arguments or multiple arguments in function.
 */
string __dx(string domainName, string acontext, string amsg, Json[string] arguments) {
    if (!message) {
        return null;
    }
    if (isSet(someArguments[0]) && isArray(someArguments[0])) {
        someArguments = someArguments[0];
    }
    return I18n.getTranslator(domainName).translate(
        message,
        ["_context": context] + someArguments
   );
}

/**
 * Returns correct plural form of message identified by singular and plural for count count.
 * Allows you to override the current domain for a single message lookup.
 * The context is a unique identifier for the translations string that makes it unique
 * within the same domain.
 *
 * @param string domainName Domain.
 * @param string acontext DContext of the text.
 * @param string singular Singular text to translate.
 * @param string pluralText Plural text.
 * @param Json[string] arguments Array with arguments or multiple arguments in function.
 */
string __dxn(
    string domainName,
    string acontext,
    string singular,
    string pluralText,
    int count,
    Json[string] arguments
) {
    if (!singular) {
        return null;
    }
    if (isSet(someArguments[0]) && isArray(someArguments[0])) {
        someArguments = someArguments[0];
    }
    return I18n.getTranslator(domainName).translate(
        plural,
        ["_count": count, "_singular": singular, "_context": context] + someArguments
   ); 
} */
