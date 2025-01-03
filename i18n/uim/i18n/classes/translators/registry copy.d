/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module i18n.uim.i18n.classes.translators.registry copy;path(path(path(

import uim.i18n;

@safe:

/**
 * Constructs and stores instances of translators that can be
 * retrieved by name and locale.
 */
class DTranslatorRegistry : DObjectRegistry!DTranslator {
    this() {
    }

    // Fallback loader name.
    const string FALLBACK_LOADER = "_fallback";

    // A registry to retain translator objects.
    // TODO protected ITranslator[string][string] registry = null;

    // The current locale code.
    protected string _localName;

    // A catalog locator.
    protected DCatalogLocator _catalogLocator;

    // A formatter locator.
    protected DFormatterLocator _formatters;

    /**
     * The name of the default formatter to use for newly created
     * translators from the fallback loader
     */
    protected string _defaultFormatter = "default";

    // Use fallback-domain for translation loaders.
    protected bool _useFallback = true;

    // A CacheEngine object that is used to remember translator across requests.
    // TODO protected ICacheEngine _cacher;

    /**
     * A list of loader functions indexed by domain name. Loaders are
     * callables that are invoked as a default for building translation
     * catalogs where none can be found for the combination of translator
     * name and locale.
     */
    // protected callable[] _loaders = null;

    this(
        DCatalogLocator catalogLocator,
        DFormatterLocator formatterLocator,
        string localName
   ) {
        _catalogLocator = catalogLocator;
        _formatters = formatterLocator;
        // _localeName(localName);

        /* registerLoader(FALLBACK_LOADER, auto (name, localName) {
            loader = new DChainMessagesLoader([
                new DMessagesFileLoader(name, localName, "mo"),
                new DMessagesFileLoader(name, localName, "po"),
            ]);

            string formatter = name == "uim" ? "default" : _defaultFormatter;
            
            auto catalog = loader();
            catalog.setFormatter(formatter);

            return catalog;
        }); */
    }
    
    // Sets the default locale code.
    void localeName(string name) {
        _localName = name;
    }
    
    // Returns the default locale code.
    string localName() {
        return _localName;
    }
    
    // Returns the translator catalogs
    DCatalogLocator getCatalogs() {
        return _catalogLocator;
    }
    
    // An object of type FormatterLocator
    DFormatterLocator getFormatters() {
        return _formatters;
    }
    
    // Sets the CacheEngine instance used to remember translators across requests.
   /* void cacher(/* ICache * / DCacheEngine cacher) {
       _cacher = cacher;
    } */
    
    // Gets a translator from the registry by catalog for a locale.
    DTranslator translator(string catalogName, string localName = null) {
        // localName = localName ? localName : localName();

    /*
        if (registry.hasKey([catalogName, localName])) {
            return _registry.getPath([catalogName, localName]);
        }

        if (_cacher.isNull) {
            _registry.register([catalogName, localName], _getTranslator(catalogName, locale)).getPath([catalogName, localName]);
        }
        // Cache keys cannot contain / if they go to file engine.
        auto keyName = name.replace("/", ".");
        auto aKey = "translations.{keyName}.{localName}";
        
        DTranslator translator = _cacher.get(aKey);
        if (!translator) {
            translator = _getTranslator(catalogName, locale);
           _cacher.set(aKey, translator);
        }
        return _registry.register([catalogName, localName], translator).getPath([catalogName, localName]); */
        return null; 
    }
    
    // Gets a translator from the registry by catalog for a locale.
    protected ITranslator _getTranslator(string catalogName, string localName) {
        /* if (_catalogLocator.has(catalogName, localName)) {
            return createInstance(catalogName, localName);
        }

       /* IMessageCatalog catalog = _loaders.hasKey(catalogName)
            ? _loaders[catalogName](catalogName, localname)
            : _loaders[FALLBACK_LOADER](catalogName, localname);

        catalog = setFallbackPackage(catalogName, catalog);
        _catalogLocator.set(catalogName, localname, catalog); * / 

        return createInstance(catalogName, localName); */
        return null; 
    }
    
    // Create translator instance.
    protected ITranslator createInstance(string catalogName, string localName = null) {
        IMessageCatalog catalog = _catalogLocator.get(catalogName, localName);
        
        /* auto fallback = catalog.fallback();
        if (!fallback.isNull) {
            fallback = get(fallback, localName);
        }
        formatter = _formatters.get(catalog.formatterName());

        return new DTranslator(localName, catalog, formatter, fallback); */
        return null; 
    }
    
    /**
     * Registers a loader auto for a catalog name that will be used as a fallback
     * in case no catalog with that name can be found.
     *
     * Loader callbacks will get as first argument the catalog name and the locale as
     * the second argument.
     */
    void registerLoader(string catalogName, ILoader loader) {
        //_loaders[catalogName] = loader;
    }

    /**
     * Sets the name of the default messages formatter to use for future
     * translator instances.
     *
     * If called with no arguments, it will return the currently configured value.
     */
    string defaultFormatter(string formatterName = null) {
        if (formatterName.isNull) {
            return _defaultFormatter;
        }
        _defaultFormatter = formatterName;
        return _defaultFormatter;
    }
    
    // Set if the default domain fallback is used.
    void useFallback(bool enablefallBack = true) {
       _useFallback = enablefallBack;
    }
    
    // Set fallback domain for catalog.
    IMessageCatalog setFallbackPackage(string catalogName, IMessageCatalog catalog) {
        /* if (catalog.fallback) {
            return catalog;
        }
        
        string fallbackDomain = null;
        if (_useFallback && name != "default") {
            fallbackDomain = "default";
        }
        catalog.(fallbackDomain);
        return catalog; */
        return null; 
    }
    
    // Set domain fallback for loader.
    IMessageCatalog setLoaderFallback(string catalogName, ILoader loader) {
        string fallbackDomain = "default";
        /* if (!_useFallback || catalogName == fallbackDomain) {
            return loader;
        } */
        /* return IMessageCatalog () use (loader, fallbackDomain) {
            IMessageCatalog catalog = loader.catalog();
            if (!catalog.fallback) {
                catalog.(fallbackDomain);
            }
            return catalog;
        }; */
        return null; 
    }
}

auto TranslatorRegistry() { // Singleton
    return DTranslatorRegistry.registry;
}
