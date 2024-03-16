module uim.i18n.helpers.functions;

import uim.i18n;

@safe:
/**
 * Returns a translated string if one is found; Otherwise, the submitted message.
 *
 * @param string asingular Text to translate.
 * @param Json ...someArguments Array with arguments or multiple arguments in function.
 * /
string __(string asingular, Json ...someArguments) {
    if (!singular) {
        return "";
    }
    if (isSet(someArguments[0]) && isArray(someArguments[0])) {
        someArguments = someArguments[0];
    }
    return I18n.getTranslator().translate(singular, someArguments);
}
/**
 * Returns correct plural form of message identified by singular and plural for count count.
 * Some languages have more than one form for plural messages dependent on the count.
 *
 * @param string asingular Singular text to translate.
 * @param string aplural Plural text.
 * @param int count Count.
 * @param Json ...someArguments Array with arguments or multiple arguments in function.
 * /
string __n(string asingular, string aplural, int count, Json ...someArguments) {
    if (!singular) {
        return "";
    }
    if (isSet(someArguments[0]) && isArray(someArguments[0])) {
        someArguments = someArguments[0];
    }
    return I18n.getTranslator().translate(
        plural,
        ["_count": count, "_singular": singular] + someArguments
    );
}

/**
 * Allows you to override the current domain for a single message lookup.
 *
 * @param string adomain Domain.
 * @param string amsg String to translate.
 * @param Json ...someArguments Array with arguments or multiple arguments in function.
 * /
string __d(string adomain, string messageToTranslate, Json ...someArguments) {
    if (messageToTranslate.isEmpty) {
        return "";
    }

    if (isSet(someArguments[0]) && isArray(someArguments[0])) {
        someArguments = someArguments[0];
    }
    return I18n.getTranslator(domain).translate(message, someArguments);
}

/**
 * Allows you to override the current domain for a single plural message lookup.
 * Returns correct plural form of message identified by singular and plural for count count
 * from domain domain.
 *
 * @param string adomain Domain.
 * @param string asingular Singular string to translate.
 * @param string aplural Plural.
 * @param int count Count.
 * @param Json ...someArguments Array with arguments or multiple arguments in function.
 * /
string __dn(string adomain, string asingular, string aplural, int count, Json ...someArguments): 
{
    if (singular.isEmpty) {
        return "";
    }
    if (isSet(someArguments[0]) && isArray(someArguments[0])) {
        someArguments = someArguments[0];
    }
    return I18n.getTranslator(domain).translate(
        plural,
        ["_count": count, "_singular": singular] + someArguments
    );
}
/**
 * Returns a translated string if one is found; Otherwise, the submitted message.
 * The context is a unique identifier for the translations string that makes it unique
 * within the same domain.
 *
 * @param string acontext Context of the text.
 * @param string asingular Text to translate.
 * @param Json ...someArguments Array with arguments or multiple arguments in function.
 * /
string __x(string acontext, string asingular, Json ...someArguments)
{
    if (!singular) {
        return "";
    }
    if (isSet(someArguments[0]) && isArray(someArguments[0])) {
        someArguments = someArguments[0];
    }
    return I18n.getTranslator().translate(singular, ["_context": context] + someArguments);
}
/**
 * Returns correct plural form of message identified by singular and plural for count count.
 * Some languages have more than one form for plural messages dependent on the count.
 * The context is a unique identifier for the translations string that makes it unique
 * within the same domain.
 *
 * @param string acontext Context of the text.
 * @param string asingular Singular text to translate.
 * @param string aplural Plural text.
 * @param int count Count.
 * @param Json ...someArguments Array with arguments or multiple arguments in function.
 * /
string __xn(string acontext, string asingular, string aplural, int count, Json ...someArguments) {
    if (!singular) {
        return "";
    }
    if (isSet(someArguments[0]) && isArray(someArguments[0])) {
        someArguments = someArguments[0];
    }
    return I18n.getTranslator().translate(
        plural,
        ["_count": count, "_singular": singular, "_context": context] + someArguments
    );
}

/**
 * Allows you to override the current domain for a single message lookup.
 * The context is a unique identifier for the translations string that makes it unique
 * within the same domain.
 *
 * @param string adomain Domain.
 * @param string acontext Context of the text.
 * @param string amsg String to translate.
 * @param Json ...someArguments Array with arguments or multiple arguments in function.
 * /
string __dx(string adomain, string acontext, string amsg, Json ...someArguments) {
    if (!message) {
        return "";
    }
    if (isSet(someArguments[0]) && isArray(someArguments[0])) {
        someArguments = someArguments[0];
    }
    return I18n.getTranslator(domain).translate(
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
 * @param string adomain Domain.
 * @param string acontext Context of the text.
 * @param string asingular Singular text to translate.
 * @param string aplural Plural text.
 * @param int count Count.
 * @param Json ...someArguments Array with arguments or multiple arguments in function.
 * /
string __dxn(
    string adomain,
    string acontext,
    string asingular,
    string aplural,
    int count,
    Json ...someArguments
) {
    if (!singular) {
        return "";
    }
    if (isSet(someArguments[0]) && isArray(someArguments[0])) {
        someArguments = someArguments[0];
    }
    return I18n.getTranslator(domain).translate(
        plural,
        ["_count": count, "_singular": singular, "_context": context] + someArguments
    ); 
} */
