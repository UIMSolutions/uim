module uim.caches.classes.caches.cache;

import uim.caches;

@safe:

/**
 * Cache provides a consistent interface to Caching in your application. It allows you
 * to use several different Cache engines, without coupling your application to a specific
 * implementation. It also allows you to change out cache storage or configuration without effecting
 * the rest of your application.
 *
 * ### Configuring Cache engines
 *
 * You can configure Cache engines in your application`s `Config/cache.d` file.
 * A sample configuration would be:
 *
 * ```
 * Cache.config("shared", [
 *  'classname": UIM\Cache\Engine\ApcuEngine.classname,
 *  'prefix": '_app_'
 * ]);
 * ```
 *
 * This would configure an APCu cache engine to the `shared' alias. You could then read and write
 * to that cache alias by using it for the `configName` parameter in the various Cache methods.
 *
 * In general all Cache operations are supported by all cache engines.
 * However, Cache.increment() and Cache.decrement() are not supported by File caching.
 *
 * There are 7 built-in caching engines:
 *
 * - `ApcuEngine` - Uses the APCu object cache, one of the fastest caching engines.
 * - `ArrayEngine` - Uses only memory to store all data, not actually a persistent engine.
 *  Can be useful in test or CLI environment.
 * - `FileEngine` - Uses simple files to store content. Poor performance, but good for
 *  storing large objects, or things that are not IO sensitive. Well suited to development
 *  as it is an easy cache to inspect and manually flush.
 * - `MemcacheEngine` - Uses the PECL.Memcache extension and Memory for storage.
 *  Fast reads/writes, and benefits from memcache being distributed.
 * - `RedisEngine` - Uses redis and D-redis extension to store cache data.
 * - `XcacheEngine` - Uses the Xcache extension, an alternative to APCu.
 */
class DCache : UIMObject, ICache {
    mixin(CacheThis!());
}