module uim.caches.classes.engines.file;

import uim.caches;

@safe:

/**
 * File Storage engine for cache. Filestorage is the slowest cache storage
 * to read and write. However, it is good for servers that don"t have other storage
 * engine available, or have content which is not performance sensitive.
 *
 * You can configure a FileEngine cache, using Cache.config()
 */
class DFileCacheEngine : DCacheEngine {
    mixin(CacheEngineThis!("File"));

    /*
    // Instance of SplFileObject class
    protected SplFileObject my_File;

    /**
     * The default config used unless overridden by runtime configuration
     *
     * - `duration` Specify how long items in this cache configuration last.
     * - `groups` List of groups or "tags" associated to every key stored in this config.
     *   handy for deleting a complete group from cache.
     * - `lock` Used by FileCache. Should files be locked before writing to them?
     * - `mask` The mask used for created files
     * - `dirMask` The mask used for created folders
     * - `path` Path to where cachefiles should be saved. Defaults to system"s temp dir.
     * - `prefix` Prepended to all entries. Good for when you need to share a keyspace
     *   with either another cache config or another application.
     *   cache.gc from ever being called automatically.
     * - `serialize` Should cache objects be serialized first.
     * /

    // True unless FileEngine.__active(); fails
    protected bool my_init = true;

    /**
     * Initialize File Cache Engine
     *
     * Called automatically by the cache frontend.
     * configData - array of setting for the engine
     * /
    override bool initialize(IData[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        /* configuration.updateDefaults([
            "duration": 3600,
            "groups": ArrayData,
            "lock": BooleanData(true),
            "mask": std.conv.octal!"664",
            "dirMask": std.conv.octal!"770",
            "path": null,
            "prefix": "uim_",
            "serialize": BooleanData(true),
        ]); * / 

        configuration["path"] = configuration.get("path", sys_get_temp_dir()~DIRECTORY_SEPARATOR ~ "cake_cache" ~ DIRECTORY_SEPARATOR);
        if (substr(configuration["path"], -1) != DIRECTORY_SEPARATOR) {
            configuration["path"] ~= DIRECTORY_SEPARATOR;
        }
        if (_groupPrefix) {
            _groupPrefix = _groupPrefix.replace("_", DIRECTORY_SEPARATOR);
        } * /
        return _active();
    }

    /**
     * Write data for key into cache
     * Params:
     * string aKey Identifier for the data
     * @param IData aValue Data to be cached
     * @param \DateInterval|int myttl Optional. The TTL value of this item. If no value is sent and
     *  the driver supports TTL then the library may set a default value
     *  for it or let the driver take care of that.
     */
    /* bool set(string dataId, IData cacheData, DateInterval | int myttl = null) {
        if (cacheData == "" || !_init) {
            return false;
        }

        auto aKey = _key(dataId);

        if (_setKey(aKey, true) == false) {
            return false;
        }
        if (!configuration["serialize"].isEmpty) {
            cacheData = serialize(cacheData);
        }
        myexpires = time() + this.duration(myttl);
        mycontents = [myexpires, PHP_EOL, cacheData, PHP_EOL].join();

        if (configuration["lock"]) {
            _File.flock(LOCK_EX);
        }
        _File.rewind();
        mysuccess = _File.ftruncate(0) &&
            _File.fwrite(mycontents) &&
            _File.fflush();

        if (configuration["lock"]) {
            _File.flock(LOCK_UN);
        }
        _File = null;

        return mysuccess;
    } */

    /**
     * Read a key from the cache
     * Params:
     * @param IData defaultValue Default value to return if the key does not exist.
     * /
    IData get(string dataId, IData defaultValue = null) {
        auto key = _key(dataId);

        if (!_init || _setKey(key) == false) {
            return defaultValue;
        }
        if (configuration["lock"]) {
            _File.flock(LOCK_SH);
        }
        _File.rewind();
        mytime = time();
        mycachetime = to!int(_File.current());

        if (mycachetime < mytime) {
            if (configuration["lock"]) {
                _File.flock(LOCK_UN);
            }
            return defaultValue;
        }
        string myData = "";
        _File.next();
        while (_File.valid()) {
            /** @psalm-suppress PossiblyInvalidOperand * /
            myData ~= _File.current();
            _File.next();
        }
        if (configuration["lock"]) {
            _File.flock(LOCK_UN);
        }
        myData = trim(myData);

        if (myData != "" && !empty(configuration["serialize"])) {
            myData = unserialize(myData);
        }
        return myData;
    }

    /**
     * Delete a key from the cache
     * Params:
     * string aKey Identifier for the data
     * /
    bool delete_(string dataId) {
        auto aKey = _key(dataId);

        if (_setKey(aKey) == false || !_init) {
            return false;
        }
        auto mypath = _File.getRealPath();
        unset(_File);

        if (mypath == false) {
            return false;
        }

        return @unlink(mypath) ;

    }

    // Delete all values from the cache
    bool clear() {
        if (!_init) {
            return false;
        }
        unset(_File);

        _clearDirectory(configuration["path"]);

        mydirectory = new DRecursiveDirectoryIterator(
            configuration["path"],
            FilesystemIterator.SKIP_DOTS
        );
        /** @var \RecursiveDirectoryIterator<\SplFileInfo> myiterator Coerce for phpstan/psalm * /
        auto myIterator = new DRecursiveIteratorIterator(
            mydirectory,
            RecursiveIteratorIterator.SELF_FIRST
        );
        mycleared = [];
        foreach (myfileInfo; myiterator) {
            if (myfileInfo.isFile()) {
                unset(myfileInfo);
                continue;
            }
            myrealPath = myfileInfo.getRealPath();
            if (!myrealPath) {
                unset(myfileInfo);
                continue;
            }
            mypath = myrealPath ~ DIRECTORY_SEPARATOR;
            if (!in_array(mypath, mycleared, true)) {
                _clearDirectory(mypath);
                mycleared ~= mypath;
            }
            // possible inner iterators need to be unset too in order for locks on parents to be released
            unset(myfileInfo);
        }
        // unsetting iterators helps releasing possible locks in certain environments,
        // which could otherwise make `rmdir()` fail
        unset(mydirectory, myiterator);

        return true;
    }

    // Used to clear a directory of matching files.
    protected void _clearDirectory(string pathToSearch) {
        if (!isDir(pathToSearch)) {
            return;
        }
        mydir = dir(pathToSearch);
        if (!mydir) {
            return;
        }
        myprefixLength = configuration["prefix"].length;

        while ((myentry = mydir.read()) != false) {
            if (substr(myentry, 0, myprefixLength) != configuration["prefix"]) {
                continue;
            }
            try {
                myfile = new DSplFileObject(mypath ~ myentry, "r");
            } catch (Exception) {
                continue;
            }
            if (myfile.isFile()) {
                myfilePath = myfile.getRealPath();
                unset(myfile);
            }
        }
        mydir.close();
    }

    /**
     * Not implemented
     * Params:
     * string aKey The key to decrement
     * @param int anOffset The number to offset
     * /
    int decrement(string decrementKey, int anOffset = 1) {
        throw new LogicException("Files cannot be atomically decremented.");
    }

    /**
     * Not implemented
     * Params:
     * string aKey The key to increment
     * @param int anOffset The number to offset
     * /
    int increment(string incrementKey, int anOffset = 1) {
        throw new LogicException("Files cannot be atomically incremented.");
    }

    /**
     * Sets the current cache key this class is managing, and creates a writable SplFileObject
     * for the cache file the key is referring to.
     * Params:
     * string aKey The key
     * @param bool mycreateKey Whether the key should be created if it doesn"t exists, or not
     * /
    /* protected bool _setKey(string aKey, bool mycreateKey = false) {
        mygroups = null;
        if (_groupPrefix) {
            mygroups = vsprintf(_groupPrefix, this.groups());
        }
        mydir = configuration["path"] ~ mygroups;

        if (!isDir(mydir)) {
            mkdir(mydir, configuration["dirMask"], true);
        }
        mypath = new DSplFileInfo(mydir ~ aKey);

        if (!mycreateKey && !mypath.isFile()) {
            return false;
        }
        /** @psalm-suppress TypeDoesNotContainType * /
        if (
            !isSet(_File) ||
            _File.getBasename() != aKey ||
            _File.valid() == false
            ) {
            myexists = isFile(mypath.getPathname());
            try {
                _File = mypath.openFile("c+");
            } catch (Exception mye) {
                trigger_error(mye.getMessage(), E_USER_WARNING);

                return false;
            }
            unset(mypath);

            if (!myexists && !chmod(_File.getPathname(), (int) configuration["mask"])) {
                trigger_error(
                    "Could not apply permission mask `%s` on cache file `%s`"
                        .format(_File.getPathname(),
                            configuration["mask"]
                        ), E_USER_WARNING);
            }
        }
        return true;
    } */ 

    // Determine if cache directory is writable
    /* protected bool _active() {
        mydir = new DSplFileInfo(configuration["path"]);
        mypath = mydir.getPathname();
        mysuccess = true;
        if (!isDir(mypath)) {
            mysuccess = @mkdir(mypath, configuration["dirMask"], true) ;
        }
        myisWritableDir = (mydir.isDir() && mydir.isWritable());
        if (!mysuccess || (_init && !myisWritableDir)) {
            _init = false;
            trigger_error("%s is not writable"
                    .format(configuration["path"]
                    ), E_USER_WARNING);
        }
        return mysuccess;
    } * /

    protected string _key(string aKey) {
        auto newKey = super._key(aKey);

        return rawurlencode(newKey);
    }

    /**
     * Recursively deletes all files under any directory named as mygroup
     * Params:
     * string mygroup The group to clear.
         * /
    bool clearGroup(string groupName) {
        unset(_File);

        auto myprefix = to!string( configuration["prefix"]);

        auto mydirectoryIterator = new DRecursiveDirectoryIterator(configuration["path"]);
        auto mycontents = new DRecursiveIteratorIterator(
            mydirectoryIterator,
            RecursiveIteratorIterator.CHILD_FIRST
        );
        /** @var array<\SplFileInfo> myfiltered */
        /* auto myfiltered = new DCallbackFilterIterator(
            mycontents,
            auto(SplFileInfo mycurrent) use(groupName, myprefix) {
            if (!mycurrent.isFile()) {
                return false;}
                myhasPrefix = myprefix == "" || str_starts_with(mycurrent.getBasename(), myprefix);
                    return myhasPrefix
                    ? mycurrent.getPathname()
                    .has(
                        DIRECTORY_SEPARATOR ~ groupName ~ DIRECTORY_SEPARATOR
                    ) : false;}

                );

                myfiltered.each!((obj) {
                    auto mypath = obj.getPathName(); unset(obj); 
                    @unlink(mypath) ;});
                    // unsetting iterators helps releasing possible locks in certain environments,
                    // which could otherwise make `rmdir()` fail
                    unset(mydirectoryIterator, mycontents, myfiltered);

                    return true;
                }
            } * /
        return false;
    } */
}
mixin(CacheEngineCalls!("File"));
