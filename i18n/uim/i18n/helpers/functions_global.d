module source.uim.i18n.helpers.functions_global;

if (!function_exists("__")) {
    /**
     * Returns a translated string if one is found; Otherwise, the submitted message.
     * Params:
     * string asingular Text to translate.
     * @param Json ...someArguments Array with arguments or multiple arguments in function.
     */
    string __(string asingular, Json ...someArguments) {
        return cake__(singular, ...someArguments);
    }
}

if (!function_exists("__n")) {
    /**
     * Returns correct plural form of message identified by singular and plural for count count.
     * Some languages have more than one form for plural messages dependent on the count.
     * Params:
     * string asingular Singular text to translate.
     * @param string aplural Plural text.
     * @param int count Count.
     * @param Json ...someArguments Array with arguments or multiple arguments in function.
     */
    string|int|false __n(string asingular, string aplural, int count, Json ...someArguments) {
        return cake__n(singular, plural, count, ...someArguments);
    }
}

if (!function_exists("__d")) {
    /**
     * Allows you to override the current domain for a single message lookup.
     * Params:
     * string adomain Domain.
     * @param string amsg String to translate.
     * @param Json ...someArguments Array with arguments or multiple arguments in function.
     */
    string __d(string adomain, string amsg, Json ...someArguments) {
        return cake__d(domain, message, ...someArguments);
    }
}

if (!function_exists("__dn")) {
    /**
     * Allows you to override the current domain for a single plural message lookup.
     * Returns correct plural form of message identified by singular and plural for count count
     * from domain domain.
     * Params:
     * string adomain Domain.
     * @param string asingular Singular string to translate.
     * @param string aplural Plural.
     * @param int count Count.
     * @param Json ...someArguments Array with arguments or multiple arguments in function.
     */
    string __dn(string adomain, string asingular, string aplural, int count, Json ...someArguments) {
        return cake__dn(domain, singular, plural, count, ...someArguments);
    }
}

if (!function_exists("__x")) {
    /**
     * Returns a translated string if one is found; Otherwise, the submitted message.
     * The context is a unique identifier for the translations string that makes it unique
     * within the same domain.
     * Params:
     * string acontext Context of the text.
     * @param string asingular Text to translate.
     * @param Json ...someArguments Array with arguments or multiple arguments in function.
     */
    string __x(string acontext, string asingular, Json ...someArguments) {
        return cake__x(context, singular, ...someArguments);
    }
}

if (!function_exists("__xn")) {
    /**
     * Returns correct plural form of message identified by singular and plural for count count.
     * Some languages have more than one form for plural messages dependent on the count.
     * The context is a unique identifier for the translations string that makes it unique
     * within the same domain.
     * Params:
     * string acontext Context of the text.
     * @param string asingular Singular text to translate.
     * @param string aplural Plural text.
     * @param int count Count.
     * @param Json ...someArguments Array with arguments or multiple arguments in function.
     */
    string __xn(string acontext, string asingular, string aplural, int count, Json ...someArguments) {
        return cake__xn(context, singular, plural, count, ...someArguments);
    }
}

if (!function_exists("__dx")) {
    /**
     * Allows you to override the current domain for a single message lookup.
     * The context is a unique identifier for the translations string that makes it unique
     * within the same domain.
     * Params:
     * string adomain Domain.
     * @param string acontext Context of the text.
     * @param string amsg String to translate.
     * @param Json ...someArguments Array with arguments or multiple arguments in function.
     */
    string __dx(string adomain, string acontext, string amsg, Json ...someArguments) {
        return cake__dx(domain, context, message, ...someArguments);
    }
}

if (!function_exists("__dxn")) {
    /**
     * Returns correct plural form of message identified by singular and plural for count count.
     * Allows you to override the current domain for a single message lookup.
     * The context is a unique identifier for the translations string that makes it unique
     * within the same domain.
     * Params:
     * string adomain Domain.
     * @param string acontext Context of the text.
     * @param string asingular Singular text to translate.
     * @param string aplural Plural text.
     * @param int count Count.
     * @param Json ...someArguments Array with arguments or multiple arguments in function.
     */
    string __dxn(
        string adomain,
        string acontext,
        string asingular,
        string aplural,
        int count,
        Json ...someArguments
    ) {
        return cake__dxn(domain, context, singular, plural, count, ...someArguments);
    }
}
