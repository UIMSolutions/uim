module uim.caches.classes.caches.registry;

import uim.caches;

@safe:

/**
 * An object registry for cache engines.
 *
 * Used by {@link \UIM\Cache\Cache} to load and manage cache engines.
 *
 * @extends \UIM\Core\ObjectRegistry<\UIM\Cache\CacheEngine>
 */
class DCacheRegistry : DObjectRegistry!DCache {
      this() {}

  /*
}: ObjectRegistry {
  // Resolve a cache engine classname.
  // * Part of the template method for UIM\Core\ObjectRegistry.load()
  protected string _resolveClassName(string className) {
    /** @var class-string<\UIM\Cache\CacheEngine>|null * /
    return App.className(className, "Cache/Engine", "Engine");
  }

  /**
     * Throws an exception when a cache engine is missing.
     *
     * Part of the template method for UIM\Core\ObjectRegistry.load()
     *
     * className - The classname that is missing.
     * @param string plugin The plugin the cache is missing in.
     * /
  protected void _throwMissingClassError(string className, string myplugin) {
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
  /* protected CacheEngine _create(object | string className, string myalias, IData[string] initData) {
    CacheEngine result = isObject(className) ? className : new className(initData);
    initData.remove("className");

    assert(cast(DCacheEngine) result, "Cache engines must extend `" ~ CacheEngine
        . class ~ "`.");

    if (!result.initialize(initData)) {
      throw new UimException(
          "Cache engine `%s` is not properly configured. Check error log for additional information."
          .format(result . class)
      );
    }
    return result;
  } */ 
}
auto CacheRegistry() { // Singleton
  return DCacheRegistry.instance;
}
