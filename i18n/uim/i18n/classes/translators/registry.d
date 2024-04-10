module uim.i18n.classes.translators.registry;

import uim.i18n;

@safe:

/**
 * Constructs and stores instances of translators that can be
 * retrieved by name and locale.
 */
class DTranslatorRegistry : DObjectRegistry!DTranslator {
        this() {}

    // Fallback loader name.
    const string FALLBACK_LOADER = "_fallback";

    // A registry to retain translator objects.
    // TODO protected ITranslator[string][string] registry = null;

    // The current locale code.
    protected string _localeName = null;

    // A catalog locator.
    //protected DCatalogLocator _catalogs;

    // A formatter locator.
    // protected FormatterLocator _formatters;

    /**
     * A list of loader functions indexed by domain name. Loaders are
     * callables that are invoked as a default for building translation
     * catalogs where none can be found for the combination of translator
     * name and locale.
     * /
    protected callable[] _loaders = [];

    /**
     * The name of the default formatter to use for newly created
     * translators from the fallback loader
     */
    protected string _defaultFormatter = "default";

    // Use fallback-domain for translation loaders.
    protected bool _useFallback = true;

    /**
     * A CacheEngine object that is used to remember translator across
     * requests.
     * /
    protected ICacheEngine _cacher;

    /**
     * Constructor.
     * Params:
     * \UIM\I18n\CatalogLocator catalogs The catalog locator.
     * @param \UIM\I18n\FormatterLocator formatters The formatter locator.
     * @param string localName The default locale code to use.
     * /
    this(
        CatalogLocator catalogs,
        FormatterLocator formatters,
        string localName
    ) {
        _catalogs = catalogs;
        _formatters = formatters;
        _localeName(localName);

        this.registerLoader(FALLBACK_LOADER, auto (name, locale) {
            loader = new DChainMessagesLoader([
                new MessagesFileLoader(name, locale, "mo"),
                new MessagesFileLoader(name, locale, "po"),
            ]);

            formatter = name == "uim" ? "default" : _defaultFormatter;
            catalog = loader();
            catalog.setFormatter(formatter);

            return catalog;
        });
    }
    
    /**
     * Sets the default locale code.
     * Params:
     * string localName The new locale code.
     * /
    void setLocale(string localName) {
        this.locale = locale;
    }
    
    /**
     * Returns the default locale code.
     * /
    string getLocale() {
        return this.locale;
    }
    
    // Returns the translator catalogs
    CatalogLocator getCatalogs() {
        return this.catalogs;
    }
    
    // An object of type FormatterLocator
    FormatterLocator getFormatters() {
        return this.formatters;
    }
    
    /**
     * Sets the CacheEngine instance used to remember translators across
     * requests.
     * Params:
     * \Psr\SimpleCache\ICache&\UIM\Cache\ICacheEngine cacher The cacher instance.
     * /
    void cacher(ICache&ICacheEngine cacher) {
       _cacher = cacher;
    }
    
    /**
     * Gets a translator from the registry by catalog for a locale.
     * Params:
     * string catalogName The translator catalog to retrieve.
     * @param string locale The locale to use; if empty, uses the default
     * locale
     * /
    Translator get(string catalogName, string localName = null) {
        locale ??= this.getLocale();

        if (isSet(this.registry[catalogName][localName])) {
            return this.registry[catalogName][localName];
        }
        if (_cacher is null) {
            return this.registry[catalogName][localName] = _getTranslator(catalogName, locale);
        }
        // Cache keys cannot contain / if they go to file engine.
        keyName = name.replace("/", ".");
        aKey = "translations.{keyName}.{localName}";
        
        Translator translator = _cacher.get(aKey);
        if (!translator) {
            translator = _getTranslator(catalogName, locale);
           _cacher.set(aKey, translator);
        }
        return this.registry[catalogName][localName] = translator;
    }
    
    // Gets a translator from the registry by catalog for a locale.
    protected Translator _getTranslator(string catalogName, string localName) {
        if (this.catalogs.has(catalogName, localName)) {
            return this.createInstance(catalogName, localname);
        }

        ICatalog catalog = _loaders.isSet(catalogName)
            ? _loaders[catalogName](catalogName, localname)
            : _loaders[FALLBACK_LOADER](catalogName, localname);

        catalog = this.setFallbackPackage(catalogName, catalog);
        this.catalogs.set(catalogName, localname, catalog);

        return this.createInstance(catalogName, localname);
    }
    
    // Create translator instance.
    protected Translator createInstance(string catalogName, string localName = null) {
        ICatalog catalog = this.catalogs.get(catalogName, localname);
        auto fallback = catalog.fallback();
        if (!fallback is null) {
            fallback = get(fallback, localname);
        }
        formatter = this.formatters.get(catalog.formatterName());

        return new DTranslator(localName, catalog, formatter, fallback);
    }
    
    /**
     * Registers a loader auto for a catalog name that will be used as a fallback
     * in case no catalog with that name can be found.
     *
     * Loader callbacks will get as first argument the catalog name and the locale as
     * the second argument.
     * Params:
     * string catalogName The name of the translator catalog to register a loader for
     * @param callable loader A callable object that should return a ICatalog
     */
    void registerLoader(string catalogName, ILoader loader) {
        //_loaders[catalogName] = loader;
    }

    /**
     * Sets the name of the default messages formatter to use for future
     * translator instances.
     *
     * If called with no arguments, it will return the currently configured value.
     * /
    string defaultFormatter(string formatterName = null) {
        if (formatterName is null) {
            return _defaultFormatter;
        }
        return _defaultFormatter = formatterName;
    }
    
    // Set if the default domain fallback is used.
    void useFallback(bool enablefallBack = true) {
       _useFallback = enablefallBack;
    }
    
    // Set fallback domain for catalog.
    ICatalog setFallbackPackage(string catalogName, ICatalog catalog) {
        if (catalog.fallback) {
            return catalog;
        }
        
        string fallbackDomain = null;
        if (_useFallback && name != "default") {
            fallbackDomain = "default";
        }
        catalog.(fallbackDomain);
        return catalog;
    }
    
    // Set domain fallback for loader.
    callable setLoaderFallback(string catalogName, ILoader loader) {
        string fallbackDomain = "default";
        if (!_useFallback || name == fallbackDomain) {
            return loader;
        }
        return ICatalog () use (loader, fallbackDomain) {
            ICatalog catalog = loader.catalog();
            if (!catalog.fallback) {
                catalog.(fallbackDomain);
            }
            return catalog;
        };
    } */
}

auto TranslatorRegistry() { // Singleton
    return DTranslatorRegistry.instance;
}
