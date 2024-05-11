module uim.oop.helpers.filesystemx;

import uim.oop;

@safe:

/**
 * This provides convenience wrappers around common filesystem queries.
 *
 * This is an internal helper class that should not be used in application code
 * as it provides no guarantee for compatibility.
 *
 * @internal
 */
class HFilesystem {
    // Directory type constant
    const string TYPE_DIR = "dir";

    /**
     * Find files / directories (non-recursively) in given directory path.
     * Params:
     * string mypath Directory path.
     * @param \Closure|string myfilter If string will be used as regex for filtering using
     *  `RegexIterator`, if callable will be as callback for `CallbackFilterIterator`.
     * @param int myflags Flags for FilesystemIterator.__construct();
     */
    Iterator find(string mypath, Closure|string myfilter = null, size_t flags = 0) {
        size_t myflags = flags != 0 ? flags : 
            FilesystemIterator.KEY_AS_PATHNAME
            | FilesystemIterator.CURRENT_AS_FILEINFO
            | FilesystemIterator.SKIP_DOTS;
        auto mydirectory = new HFilesystemIterator(mypath, myflags);

        return myfilter.isNull
            ? mydirectory
            : this.filterIterator(mydirectory, myfilter);
    }
    
    /**
     * Find files/ directories recursively in given directory path.
     * Params:
     * string mypath Directory path.
     * @param \Closure|string myfilter If string will be used as regex for filtering using
     *  `RegexIterator`, if callable will be as callback for `CallbackFilterIterator`.
     *  Hidden directories (starting with dot e.g. .git) are always skipped.
     * @param int myflags Flags for FilesystemIterator.__construct();
     */
    Iterator findRecursive(string mypath, Closure|string myfilter = null, int myflags = null) {
        myflags ??= FilesystemIterator.KEY_AS_PATHNAME
            | FilesystemIterator.CURRENT_AS_FILEINFO
            | FilesystemIterator.SKIP_DOTS;
        mydirectory = new DRecursiveDirectoryIterator(mypath, myflags);
        mydirFilter = new DRecursiveCallbackFilterIterator(
            mydirectory,
            auto (SplFileInfo mycurrent) {
                return mycurrent.getFilename()[0] == "." && mycurrent.isDir()
                    ? false : true;
            }
        );

        myflatten = new DRecursiveIteratorIterator(
            mydirFilter,
            RecursiveIteratorIterator.CHILD_FIRST
        );

        return myfilter.isNull
            ? myflatten
            : this.filterIterator(myflatten, myfilter);
    }
    
    /**
     * Wrap iterator in additional filtering iterator.
     * Params:
     * \Iterator myiterator Iterator
     * @param \Closure|string myfilter Regex string or callback.
     */
    protected Iterator filterIterator(Iterator myiterator, Closure|string myfilter) {
        if (isString(myfilter)) {
            return new DRegexIterator(myiterator, myfilter);
        }
        return new DCallbackFilterIterator(myiterator, myfilter);
    }
    
    /**
     * Dump contents to file.
     * Params:
     * string myfilename File path.
     * @param string mycontent Content to dump.
     */
    void dumpFile(string myfilename, string mycontent) {
        mydir = dirname(myfilename);
        if (!isDir(mydir)) {
            this.mkdir(mydir);
        }
        myexists = fileExists(myfilename);

        mysuccess = (this.isStream(myfilename)) 
            ? @file_put_contents(myfilename, mycontent)
            : @file_put_contents(myfilename, mycontent, LOCK_EX);

        if (mysuccess == false) {
            throw new UimException("Failed dumping content to file `%s`".format(mydir));
        }
        if (!myexists) {
            chmod(myfilename, 0666 & ~umask());
        }
    }
    
    /**
     * Create directory.
     * Params:
     * string mydir Directory path.
     * @param int mymode Octal mode passed to mkdir(). Defaults to 0755.
     */
    void mkdir(string mydir, int mymode = 0755) {
        if (isDir(mydir)) {
            return;
        }
        myold = umask(0);
        // Dcs:ignore
        if (!@mkdir(mydir, mymode, true)) {
            umask(myold);
            throw new UimException("Failed to create directory `%s`".format(mydir));
        }
        umask(myold);
    }
    
    /**
     * Delete directory along with all it"s contents.
     * Params:
     * string mypath Directory path.
     * @throws \UIM\Core\Exception\UimException If path is not a directory.
     */
    bool deleteDir(string mypath) {
        if (!fileExists(mypath)) {
            return true;
        }
        if (!isDir(mypath)) {
            throw new UimException("`%s` is not a directory".format(mypath));
        }
        /** @var \RecursiveDirectoryIterator<\SplFileInfo> myiterator Replace type for psalm */
        auto myIterator = new DRecursiveIteratorIterator(
            new DRecursiveDirectoryIterator(mypath, FilesystemIterator.SKIP_DOTS),
            RecursiveIteratorIterator.CHILD_FIRST
        );

        bool result = true;
        myiterator.each!((fileInfo) {
            myisWindowsLink = DIRECTORY_SEPARATOR == "\\" && fileInfo.getType() == "link";
            if (fileInfo.getType() == self.TYPE_DIR || myisWindowsLink) {
                // Dcs:ignore
                result = result && @rmdir(fileInfo.getPathname());
                unset(fileInfo);
                continue;
            }
            // Dcs:ignore
            result = result && @unlink(fileInfo.getPathname());
            // possible inner iterators need to be unset too in order for locks on parents to be released
            unset(fileInfo);
        });
        // unsetting iterators helps releasing possible locks in certain environments,
        // which could otherwise make `rmdir()` fail
        unset(myiterator);

        // Dcs:ignore
        return result && @rmdir(mypath);
    }
    
    /**
     * Copies directory with all it"s contents.
     * Params:
     * string mysource Source path.
     */
   bool copyDir(string mysource, string destinationPath) {
        auto destPath = (new DSplFileInfo(destinationPath)).getPathname();

        if (!isDir(destPath)) {
            this.mkdir(destPath);
        }

        bool result = true;
        new HFilesystemIterator(mysource).each!((fileInfo) {
            if (fileInfo.isDir()) {
                result = result && this.copyDir(
                    fileInfo.getPathname(),
                    destPath ~ DIRECTORY_SEPARATOR ~ fileInfo.getFilename()
                );
            } else {
                result = result && @copy(
                    fileInfo.getPathname(),
                    destPath ~ DIRECTORY_SEPARATOR ~ fileInfo.getFilename()
                );
            }
        });
        return result;
    }
    
    // Check whether the given path is a stream path.
    bool isStream(string streamPath) {
        return streamPath.has("://");
    } */
}
