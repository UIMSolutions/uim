# uim-caches Introduction

Caching is implemented in the uim-caches library. The library provides a static interface and a unified API for interacting with various caching implementations. Various cache engines are available:

* File cache is a simple cache that uses local files. It is the slowest cache engine. However, since hard drive storage is often quite cheap, files are a good way to store large objects or items that are rarely written to.
* Memcached Uses the Memcached extension.
* Redis provides a fast and persistent caching system similar to Memcached.
* The Apcu uses shared memory on the web server to store objects. This makes it very fast and capable of providing atomic read/write capabilities.
* Array cache stores all data in an array. It does not offer persistent storage and is more suitable for testing.
* Null engine actually saves nothing and fails on all reads.

### Engine Options

Each engine accepts the following options:

* `duration` Specify how long items in this cache configuration last.
* `groups` List of groups or ‘tags’ associated to every key stored in this config. Useful when you need to delete a subset of data from a cache.
* `prefix` Prepended to all entries. Good for when you need to share a keyspace with either another cache config or another application.


### FileEngine Options

FileEngine uses the following engine specific options:

* `<span class="pre">isWindows</span>` Automatically populated with whether the host is windows or not
* `<span class="pre">lock</span>` Should files be locked before writing to them?
* `<span class="pre">mask</span>` The mask used for created files
* `<span class="pre">path</span>` Path to where cachefiles should be saved. Defaults to system’s temp dir.

### RedisEngine Options

RedisEngine uses the following engine specific options:

* `<span class="pre">port</span>` The port your Redis server is running on.
* `<span class="pre">host</span>` The host your Redis server is running on.
* `<span class="pre">database</span>` The database number to use for connection.
* `<span class="pre">password</span>` Redis server password.
* `<span class="pre">persistent</span>` Should a persistent connection be made to Redis.
* `<span class="pre">timeout</span>` Connection timeout for Redis.
* `<span class="pre">unix_socket</span>` Path to a unix socket for Redis.

### MemcacheEngine Options

* `<span class="pre">compress</span>` Whether to compress data.
* `<span class="pre">username</span>` Login to access the Memcache server.
* `<span class="pre">password</span>` Password to access the Memcache server.
* `<span class="pre">persistent</span>` The name of the persistent connection. All configurations using the same persistent value will share a single underlying connection.
* `<span class="pre">serialize</span>` The serializer engine used to serialize data. Available engines are php, igbinary and json. Beside php, the memcached extension must be compiled with the appropriate serializer support.
* `<span class="pre">servers</span>` String or array of memcached servers. If an array MemcacheEngine will use them as a pool.
* `<span class="pre">duration</span>` Be aware that any duration greater than 30 days will be treated as real Unix time value rather than an offset from current time.
* `<span class="pre">options</span>` Additional options for the memcached client. Should be an array of option => value. Use the `<span class="pre">\Memcached::OPT_*</span>` constants as keys.
