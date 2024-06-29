module uim.i18n.classes.i18n;

import uim.i18n;

@safe:

// I18n handles translation of Text and time format strings.
class DI18n {
    mixin TConfigurable;

    this() {
        initialize;
    }

    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);
        
        return true;
    }

    // Default locale
    const string DEFAULT_LOCALE = "en_US";

    // The translators collection
    // protected static TranslatorRegistry _collection = null;

    // The environment default locale
    protected static string _defaultLocale = null;

    /**
     * Returns the translators collection instance. It can be used
     * for getting specific translators based of their name and locale
     * or to configure some aspect of future translations that are not yet constructed.
     */
    static DTranslatorRegistry translators() {
        if (!_collection.isNull) {
            return _collection;
        }
        
        _collection = new DTranslatorRegistry(
            new DCatalogLocator(),
            new DFormatterLocator([
                "default": IcuFormatter.classname,
                "sprintf": PrintFormatter.classname,
            ]),
            locale()
       );

        if (class_exists(Cache.classname)) {
            _collection.cacher(Cache.pool("_uim_core_"));
        }
        return _collection;
    }
    
    /**
     * Sets a translator.
     *
     * Configures future translators, this is achieved by passing a callable
     * as the last argument of this function.
     *
     * ### Example:
     *
     * ```
     * I18n.setTranslator("default", auto () {
     *    catalog = new \UIM\I18n\MessageCatalog();
     *    catalog.setMessages([
     *        'uim": 'Gâteau'
     *    ]);
     *    return catalog;
     * }, "fr_FR");
     *
     * translator = I18n.getTranslator("default", "fr_FR");
     * writeln(translator.translate("uim");
     * ```
     *
     * You can also use the `UIM\I18n\MessagesFileLoader` class to load a specific
     * file from a folder. For example for loading a `_translations.po` file from
     * the `resources/locales/custom` folder, you would do:
     *
     * ```
     * I18n.setTranslator(
     * "default",
     * new DMessagesFileLoader("_translations", "custom", "po"),
     * 'fr_FR'
     *);
     * ```
     */
    static void setTranslator(string domainName, callable loader, string translatorLocale = null) {
        translatorlocale = translatorlocale.ifEmpty(locale());

        auto translators = translators();
        auto loader = translators.setLoaderFallback(domainname, loader);
        auto catalogs = translators.getPackages();
        catalogs.set(domainname, translatorlocale, loader);
    }
    
    /**
     * Returns an instance of a translator that was configured for the name and locale.
     *
     * If no locale is passed then it takes the value returned by the `locale()` method.
     */
    static Translator getTranslator(string domainName = "default", string translatorLocale = null) {
        auto translators = translators();

        if (translatorlocale) {
            currentLocale = translators.locale();
            translators.setLocale(translatorlocale);
        }
        
        auto translator = translators.get(domainName);
        if (translator.isNull) {
            throw new DI18nException(
                "Translator for domain `%s` could not be found.".format(domainname));
        }
        if (isSet(currentLocale)) {
            translators.setLocale(currentLocale);
        }
        return translator;
    }
    
    /**
     * Registers a callable object that can be used for creating new translator
     * instances for the same translations domain. Loaders will be invoked whenever
     * a translator object is requested for a domain that has not been configured or
     * loaded already.
     *
     * Registering loaders is useful when you need to lazily use translations in multiple
     * different locales for the same domain, and don`t want to use the built-in
     * translation service based of `gettext` files.
     *
     * Loader objects will receive two arguments: The domain name that needs to be
     * built, and the locale that is requested. These objects can assemble the messages
     * from any source, but must return an `UIM\I18n\MessageCatalog` object.
     *
     * ### Example:
     *
     * ```
     * use UIM\I18n\MessagesFileLoader;
     * I18n.config("_domain", auto (name, locale) {
     *    // Load resources/locales/locale/filename.po
     *    fileLoader = new DMessagesFileLoader("filename", locale, "po");
     *    return fileLoader();
     * });
     * ```
     *
     * You can also assemble the catalog object yourself:
     *
     * ```
     * use UIM\I18n\MessageCatalog;
     * I18n.config("_domain", auto (name, locale) {
     *    catalog = new DMessageCatalog("default");
     *    messages = (...); // Fetch messages for locale from external service.
     *    catalog.setMessages(message);
     *    catalog.("default");
     *    return catalog;
     * });
     * ```
     * Params:
     * string aName The name of the translator to create a loader for
     * @param callable loader A callable object that should return a MessageCatalog
     * instance to be used for assembling a new translator.
     */
    static void config(string translatorName, callable loader) {
        translators().registerLoader(translatorView, loader);
    }
    
    /**
     * Sets the default locale to use for future translator instances.
     * This also affects the `intl.default_locale` UIM setting.
     */
    static void setLocale(string localName) {
        getDefaultLocale();
        Locale.setDefault(localName);
        if (isSet(_collection)) {
            translators().setLocale(localName);
        }
    }
    
    /**
     * Will return the currently configure locale as stored in the
     * `intl.default_locale` UIM setting.
     */
    static string locale() {
        getDefaultLocale();
        current = Locale.getDefault();
        if (current.isEmpty) {
            current = DEFAULT_LOCALE;
            Locale.setDefault(current);
        }
        return current;
    }
    
    /**
     * Returns the default locale.
     *
     * This returns the default locale before any modifications, i.e.
     * the value as stored in the `intl.default_locale` UIM setting before
     * any manipulation by this class.
    */
    static string getDefaultLocale() {
        return _defaultLocale ??= Locale.getDefault() ?: DEFAULT_LOCALE;
    }
    
    // Returns the currently configured default formatter.
    static string getStandardLogFormatter() {
        return translators().defaultFormatter();
    }
    
    /**
     * Sets the name of the default messages formatter to use for future
     * translator instances. By default, the `default` and `sprintf` formatters
     * are available.
     * Params:
     * string aName The name of the formatter to use.
     */
    static void setStandardLogFormatter(string formatterName) {
        translators().defaultFormatter(formatterName);
    }
    
    // Set if the domain fallback is used.
    static void useFallback(bool enable = true) {
        translators().useFallback(enable);
    }
    
    /**
     * Destroys all translator instances and creates a new empty translations
     * collection.
     */
    static void clear() {
        _collection = null;
    } 
}
