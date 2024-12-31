/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.i18n.helpers.functions;

import uim.i18n;

@safe:

// Returns a translated string if one is found; Otherwise, the submitted message.
string __(string singularText, Json[string] arguments) {
    if (!singularText) {
        return null;
    }
    /* if (arguments.has(0) && arguments.isArray(0))) {
        arguments = arguments[0];
    } */
    // TODO return I18n.getTranslator().translate(singular, arguments); 
    return null; 
}
/**
 * Returns correct plural form of message identified by singular and plural for count count.
 * Some languages have more than one form for plural messages dependent on the count.
 */
string __n(string singularText, string pluralText, size_t count, Json[string] arguments) {
    if (singularText.isEmpty) {
        return null;
    }
    /*
    if (isSet(arguments[0]) && arguments.isArray(0))) {
        arguments = arguments[0];
    }
    return I18n.getTranslator().translate(
        plural,
        ["_count": count, "_singular": singularText] + arguments
   ); */
    return null;
}

// Allows you to override the current domain for a single message lookup.
string __d(string domainName, string messageToTranslate, Json[string] options) {
    if (messageToTranslate.isEmpty) {
        return null;
    }

    /* 
    if (isSet(options[0]) && options.isArray(0)) {
        options = options[0];
    }
    return I18n.getTranslator(domainName).translate(messageToTranslate, options); */
    return null;
}

/**
 * Allows you to override the current domain for a single plural message lookup.
 * Returns correct plural form of message identified by singular and plural for count count
 * from domain domain.
 */
string __dn(string domainName, string singularText, string pluralText, int count, Json[string] arguments) {
    if (singularText.isEmpty) {
        return null;
    }
    /* if (isSet(arguments[0]) && arguments.isArray(0)) {
        arguments = arguments[0];
    } */
    /* return I18n.getTranslator(domainName).translate(
        plural,
        ["_count": count, "_singular": singularText] + arguments
   ); */
    return null;
}
/**
 * Returns a translated string if one is found; Otherwise, the submitted message.
 * The context is a unique identifier for the translations string that makes it unique
 * within the same domain.
 */
string __x(string context, string singularText, Json[string] arguments) {
    if (!singularText) {
        return null;
    }
    /* if (isSet(arguments[0]) && arguments[0].isArray) {
        arguments = arguments[0];
    } */
    // return I18n.getTranslator().translate(singularText, ["_context": context] + arguments);
    return null;
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
    /* if (isSet(arguments[0]) && arguments.isArray(0)) {
        arguments = arguments[0];
    } */
    /* return I18n.getTranslator().translate(
        pluralText,
        ["_count": count, "_singular": singularText, "_context": context] + arguments
   ); */
    return null;
}

/**
 * Allows you to override the current domain for a single message lookup.
 * The context is a unique identifier for the translations string that makes it unique
 * within the same domain.
 */
string __dx(string domainName, string context, string messageToTranslate, Json[string] arguments) {
    if (!messageToTranslate) {
        return null;
    }
    /* if (isSet(arguments[0]) && argument.isArray(0)) {
        arguments = arguments[0];
    }
    return I18n.getTranslator(domainName).translate(
        messageToTranslate,
        ["_context": context] + arguments
   ); */
    return null;
}

/**
 * Returns correct plural form of message identified by singular and plural for count count.
 * Allows you to override the current domain for a single message lookup.
 * The context is a unique identifier for the translations string that makes it unique
 * within the same domain.
 */
string __dxn(
    string domainName,
    string context,
    string singularText,
    string pluralText,
    int count,
    Json[string] arguments
) {
    if (!singularText) {
        return null;
    }
    /* if (arguments.isArray(0)) {
        arguments = arguments[0];
    }
    return I18n.getTranslator(domainName).translate(
        plural,
        ["_count": count, "_singular": singularText, "_context": context] + arguments
   );  */
    return null;
}
