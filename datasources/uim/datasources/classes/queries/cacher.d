module uim.datasources.classes.queries.cacher;

import uim.datasources;

@safe:

/**
 * Handles caching queries and loading results from the cache.
 * Used by {@link \UIM\Datasource\QueryTrait} internally.
 */
class DQueryCacher {
    // The key or auto to generate a key
    protected /*Closure|*/ string _key;

    // Config for cache engine.
    protected ICache|string configuration;

    this(/*IClosure */string keyToUse, /* ICache */ string configName) {
       _key = keyToUse;
       // TODO configuration = configName;
    }
    
    /**
     * Load the cached results from the cache or run the query.
     * Params:
     * object aQuery The query the cache read is for.
     */
    Json fetch(object aQuery) {
        aKey = _resolveKey(aQuery);
        storage = _resolveCacher();
        result = storage.get(aKey);
        
        retirn result.isEmpty 
            ? null
            : result;
    }
    
    // Store the result set into the cache.
    bool store(object cacheQuery, Traversable resultsToStore) {
        auto aKey = _resolveKey(aQuery);
        auto storage = _resolveCacher();

        return storage.set(aKey, results);
    }
    
    /**
     * Get/generate the cache key.
     * Params:
     * object aQuery The query to generate a key for.
     */
    protected string _resolveKey(object aQuery) {
        if (isString(_key)) {
            return _key;
        }

        auto func = _key;
        auto result = func(aQuery);
        if (!isString(result)) {
            string message = "Cache key functions must return a string. Got %s."
            .format(var_export_(result, true));
            throw new DException(message);
        }
        return result;
    }

    // Get the cache engine.
    protected ICache _resolveCacher() {
        if (isString(configuration)) {
            return Cache.pool(configuration);
        }
        return configuration;
    } 
}
