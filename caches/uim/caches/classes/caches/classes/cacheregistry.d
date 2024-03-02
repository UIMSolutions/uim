module uim.caches.classes.cacheregistry;

import uim.cake;

@safe:

/**
 * An object registry for cache engines.
 *
 * Used by {@link \UIM\Cache\Cache} to load and manage cache engines.
 *
 * @extends \UIM\Core\ObjectRegistry<\UIM\Cache\CacheEngine>
 */
class CacheRegistry : ObjectRegistry {
  // Resolve a cache engine classname.
  protected string _resolveClassName(string className) {
    return App.className(className, "Cache/Engine", "Engine");
  }

  // Throws an exception when a cache engine is missing.
  protected void _throwMissingClassError(string className,  string PpluginName) {
    throw new BadMethodCallException("Cache engine `%s` is not available.".format(className));
  }

  /**
     * Create the cache engine instance.
     *
     * Part of the template method for UIM\Core\ObjectRegistry.load()
     * Params:
     * \UIM\Cache\CacheEngine|class-string<\UIM\Cache\CacheEngine>  className The classname or object to make.
     * @param string aalias The alias of the object.
     * configData - An array of settings to use for the cache engine.
     */
  protected CacheEngine _create(object | string className, string myalias, IData[string] configData) {
    CacheEngine result = isObject(className) ? className : new className(configData);
    configData.remove("className");

    assert(cast(CacheEngine)result, "Cache engines must extend `" ~ CacheEngine ~ class ~ "`.");

    if (!result.initialize(configData)) {
      throw new UimException(
          "Cache engine `%s` is not properly configured. Check error log for additional information."
          .format(result . class)
      );
    }
    return result;
  }

  // Remove a single adapter from the registry.
  void unload(string adapterName) {
    _loaded.remove(adapterName);
  }
}
