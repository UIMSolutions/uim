module uim.i18n.classes.middlewares.localeselector;

import uim.i18n;

@safe:

/**
 * Sets the runtime default locale for the request based on the
 * Accept-Language header. The default will only be set if it matches the list of passed valid locales.
 */
class LocaleSelectorMiddleware : D18NMiddleware {
    // List of valid locales for the request
    protected string[] _locales;

    // locales A list of accepted locales, or ["*"] to accept any locale header value.
    this(string[] locales = null) {
        _locales = locales;
    }
    
    // Set locale based on request headers.
    IResponse process(IServerRequest serverRequest, IRequestHandler requestHandler) {
        auto locale = Locale.acceptFromHttp(request.getHeaderLine("Accept-Language"));
        if (!locale) {
            return requestHandler.handle(serverRequest);
        }
        if (this.locales != ["*"]) {
            locale = Locale.lookup(this.locales, locale, true);
        }
        if (locale || this.locales == ["*"]) {
            I18n.setLocale(locale);
        }
        return requestHandler.handle(serverRequest);
    }
}
