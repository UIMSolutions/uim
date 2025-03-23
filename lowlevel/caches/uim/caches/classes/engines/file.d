/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
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

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        configuration
            .setDefault("duration", 3600) // `duration` Specify how long items in this cache configuration last.
            .setDefault("groups", Json.emptyArray) // `groups` List of groups or "tags" associated to every key stored in this config.
            .setDefault("lock", true) // `lock` Used by FileCache. Should files be locked before writing to them?
            .setDefault("mask", std.conv.octal!"664") // `mask` The mask used for created files
            .setDefault("dirMask", std.conv.octal!"770") // `dirMask` The mask used for created folders
            .setDefault("path", Json(null)) // `path` Path to where cachefiles should be saved. Defaults to system"s temp dir.
            .setDefault("prefix", "uim_") // `prefix` Prepended to all entries. 
            .setDefault("serialize", true); // `serialize` Should cache objects be serialized first.

        /* 
        string path = configuration.getString("path", sys_get_temp_dir() ~ DIRECTORY_SEPARATOR ~ "uim_cache" ~ DIRECTORY_SEPARATOR);
        configuration.set("path", path.subString(-1) != DIRECTORY_SEPARATOR
            ? path ~ DIRECTORY_SEPARATOR
            : path;

        if (_groupPrefix) {
            _groupPrefix = _groupPrefix.replace("_", DIRECTORY_SEPARATOR);
        } 
        return _active(); */
        return true;
    }

/*     override long decrement(string itemKey, int decValue = 1) {
        // TODO throw new DLogicException("Files cannot be atomically decremented.");
        return 0;
    }

    override long increment(string itemKey, int incValue = 1) {
        // TODO 
        // throw new DLogicException("Files cannot be atomically incremented.");
        return 0;
    }
 */
    // True unless FileEngine.__active(); fails
    protected bool _init = true;

    // Instance of SplFileObject class
    // TODO protected DSplFileObject _splFileObject;

    // Write data for key into cache
    /* override */
    bool set(string dataId, Json cacheData) {
        /* TODO if (cacheData is null || !_init) {
            return false;
        }

        auto aKey = internalKey(dataId);

        if (_setKey(aKey, true) == false) {
            return false;
        }
        if (!configuration.isEmpty("serialize")) {
            cacheData = serialize(cacheData);
        }
        myexpires = time() + duration(timeToLive);
        mycontents = [myexpires, D_EOL, cacheData, D_EOL].join();

        if (configuration.hasKey("lock")) {
            _File.flock(LOCK_EX);
        }
        _File.rewind();
        mysuccess = _File.ftruncate(0) &&
            _File.fwrite(mycontents) &&
            _File.fflush();

        if (configuration.hasKey("lock")) {
            _File.flock(LOCK_UN);
        }
        _File = null;

        return mysuccess; */
        return false;
    }

    /* 
    // Read a key from the cache
    Json get(string dataId, Json defaultValue = Json(null)) {
        auto key = internalKey(dataId);

        if (!_init || _setcorrectKey(key) == false) {
            return defaultValue;
        }
        if (configuration.hasKey("lock")) {
            _File.flock(LOCK_SH);
        }
        _File.rewind();
        auto mytime = time();
        auto mycachetime = to!int(_File.currentValue());

        if (mycachetime < mytime) {
            if (configuration.hasKey("lock")) {
                _File.flock(LOCK_UN);
            }
            return defaultValue;
        }
        string myData = "";
        _File.next();
        while (_File.valid()) {
            /** @psalm-suppress PossiblyInvalidOperand * /
            myData ~= _File.currentValue();
            _File.next();
        }
        if (configuration.hasKey("lock")) {
            _File.flock(LOCK_UN);
        }
        myData = myData.strip;

        if (myData != "" && !configuration.isEMpty("serialize")) {
            myData = unserialize(myData);
        }
        return myData;
    }

    // Delete a key from the cache
    override bool removeKey(string dataId) {
        auto key = internalKey(dataId);

        if (_setcorrectKey(key) == false || !_init) {
            return false;
        }
        auto mypath = _File.getRealPath();
        removeKey(_File);

        return mypath.isEmpty
            ? false
            : @unlink(mypath) ;
    }

    // Delete all values from the cache
    bool clear() {
        if (!_init) {
            return false;
        }
        removeKey(_File);

        _clearDirectory(configuration.get("path"]);

        mydirectory = new DRecursiveDirectoryIterator(
            configuration.get("path"],
            FilesystemIterator.SKIP_DOTS
       );
        /** @var \RecursiveDirectoryIterator<\DFileInfo> myiterator Coerce for Dstan/psalm * /
        auto myIterator = new DRecursiveIteratorIterator(
            mydirectory,
            RecursiveIteratorIterator.SELF_FIRST
       );
        
        string[] mycleared;
        myiterator.each!((myfileInfo) {
            if (myfileInfo.isFile()) {
                removeKey(myfileInfo);
                continue;
            }
            
            auto myrealPath = myfileInfo.getRealPath();
            if (!myrealPath) {
                removeKey(myfileInfo);
                continue;
            }

            string mypath = myrealPath ~ DIRECTORY_SEPARATOR;
            if (!mycleared.has(mypath)) {
                _clearDirectory(mypath);
                mycleared ~= mypath;
            }
            // possible inner iterators need to be unset too in order for locks on parents to be released
            removeKey(myfileInfo);
        });
        // unsetting iterators helps releasing possible locks in certain environments,
        // which could otherwise make `rmdir()` fail
        removeKey(mydirectory, myiterator);

        return true;
    }

    // Used to clear a directory of matching files.
    protected void _clearDirectory(string pathToSearch) {
        if (!isDir(pathToSearch)) {
            return;
        }
        
        auto mydir = dir(pathToSearch);
        if (!mydir) {
            return;
        }
        myprefixLength = configuration.get("prefix").length;

        while ((myentry = mydir.read()) == true) {
            if (subString(myentry, 0, myprefixLength) != configuration.get("prefix")) {
                continue;
            }
            try {
                myfile = new DSplFileObject(mypath ~ myentry, "r");
            } catch (Exception) {
                continue;
            }
            if (myfile.isFile()) {
                myfilePath = myfile.getRealPath();
                removeKey(myfile);
            }
        }
        mydir.close();
    }

    /**
     * Sets the current cache key this class is managing, and creates a writable SplFileObject
     * for the cache file the key is referring to.
     */
    /* protected bool _setKey(string key, bool createKeyIfNotExists = false) {
        mygroups = null;
        if (_groupPrefix) {
            mygroups = vsprintf(_groupPrefix, this.groups());
        }
        mydir = configuration.getString("path") ~ mygroups;

        if (!isDir(mydir)) {
            mkdir(mydir, configuration.get("dirMask"), true);
        }
        mypath = new DFileInfo(mydir ~ key);

        if (!createKeyIfNotExists && !mypath.isFile()) {
            return false;
        }
        /** @psalm-suppress TypeDoesNotContainType * /
        if (
            _File is null ||
            _File.getBasename() != key ||
            _File.valid() == false
           ) {
            myexists = isFile(mypath.getPathname());
            try {
                _File = mypath.openFile("c+");
            } catch (Exception exception) {
                trigger_error(exception.message(), ERRORS.USER_WARNING);

                return false;
            }
            mypath = null;

            if (!myexists && !chmod(_File.getPathname(), configuration.getLong("mask"])) {
                trigger_error(
                    "Could not apply permission mask `%s` on cache file `%s`"
                        .format(_File.getPathname(),
                            configuration.get("mask"]
                       ), ERRORS.USER_WARNING);
            }
        }
        return true;
    } */

    // Determine if cache directory is writable
    /* protected bool _active() {
        mydir = new DFileInfo(configuration.get("path"]);
        mypath = mydir.getPathname();
        mysuccess = true;
        if (!isDir(mypath)) {
            mysuccess = @mkdir(mypath, configuration.get("dirMask"], true) ;
        }
        myisWritableDir = (mydir.isDir() && mydir.isWritable());
        if (!mysuccess || (_init && !myisWritableDir)) {
            _init = false;
            trigger_error("%s is not writable"
                    .format(configuration.get("path"]
                   ), ERRORS.USER_WARNING);
        }
        return mysuccess;
    } */

    /* override */ protected string internalKey(string key) {
        // auto newKey = super.internalcorrectKey(key);
        /* return rawUrlEncode(newKey); */
        return null;
    }

    // Recursively deletes all files under any directory named as mygroup
    /* override */ bool clearGroup(string groupName) {
        // TODO
        /* removeKey(_File);

        string myprefix = configuration.getString("prefix");

        DRecursiveDirectoryIterator mydirectoryIterator = new DRecursiveDirectoryIterator(
            configuration.get("path"));
        DRecursiveIteratorIterator mycontents = new DRecursiveIteratorIterator(
            mydirectoryIterator,
            RecursiveIteratorIterator.CHILD_FIRST
       );
        // TODO 
        /* 
        DFileInfo[] myfiltered = new DCallbackFilterIterator(
            mycontents,
            auto(DFileInfo mycurrent) use(groupName, myprefix) {
            if (!mycurrent.isFile()) {
                return false;}
                myhasPrefix = myprefix is null || str_starts_with(mycurrent.getBasename(), myprefix);
                    return myhasPrefix
                    ? mycurrent.getPathname()
                    .has(
                        DIRECTORY_SEPARATOR ~ groupName ~ DIRECTORY_SEPARATOR
                   ) : false;}

               );

                myfiltered.each!((obj) {
                    auto mypath = obj.getPathName(); removeKey(obj); @unlink(mypath) ;
                });
                // unsetting iterators helps releasing possible locks in certain environments,
                // which could otherwise make `rmdir()` fail
                removeKey(mydirectoryIterator, mycontents, myfiltered);

                return true;
            }
        } */
        return false;
    }
}

mixin(CacheEngineCalls!("File"));
