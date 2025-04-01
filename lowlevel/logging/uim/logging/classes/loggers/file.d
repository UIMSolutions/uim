/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.logging.classes.loggers.file;

import uim.logging;
@safe:

version (test_uim_logging) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

/**
 * File Storage stream for Logging. Writes logs to different files
 * based on the level of log it is.
 */
class DFileLogger : DLogger {
  mixin(LoggerThis!("File"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }
    /**
     * Default config for this class
     *
     * - `levels` string or array, levels the engine is interested in
     * - `scopes` string or array, scopes the engine is interested in
     * - `file` Log file name
     * - `path` The path to save logs on.
     * - `size` Used to implement basic log file rotation. If log file size
     * reaches specified size the existing file is renamed by appending timestamp
     * to filename and new log file is created. Can be integer bytes value or
     * human readable string values like "10MB", "100KB" etc.
     * - `rotate` Log files are rotated specified times before being removed.
     * If value is 0, old versions are removed rather then rotated.
     * - `mask` A mask is applied when log files are created. Left empty no chmod
     * is made.
     * - `dirMask` The mask used for created folders.
     *
     */
     configuration
      .setEntry("path", Json(null))
      .setEntry("file", Json(null))
      .setEntry("types", Json(null))
      .setEntry("mask", Json(null));
/*     configuration
      .setEntry(["path", "file", "types", "mask"], Json(null))
      .setEntry(["levels", "scopes"], Json.emptyArray)
      .setEntry("rotate", 10)
      .setEntry("size", 10_485_760) */ // 10M)
      // .setEntry("dirMask", 0770)
      /* .setEntry("formatter", createMap!(string, Json).set("classname", StandardLogFormatter
          .classname)) *//* ; */

    /* auto _path = configuration.getString("path", sys_get_temp_dir() ~ DIRECTORY_SEPARATOR);
        if (!isDir(_path)) {
            mkdir(_path, configuration.getEntry("dirMask"), true);
        }
        if (!configuration.isEmptyEntry("file")) {
           _fileNamename = configuration.getString("file");
            if (!_fileNamename.endsWith(".log")) {
               _fileNamename ~= ".log";
            }
        }
        if (!configuration.isEmptyEntry("size")) {
            _maxFileSize = isNumeric(configuration.getEntry("size"))
                ? configuration.toLong("size")
                : Text.parseFileSize(configuration.getEntry("size"));
        } */

    return true;
  }

  // #region path
  // Path to save log files on.
  protected string _path;
  string path() {
    return _path;
  }
  ILogger path(string newPath) {
    _path = newPath;
    return this;
  }
  // #endregion path

  // #region fileName
  // The name of the file to save logs into.
  protected string _fileName = null;
  // Get filename
  string getOrCreateFileName(string logLevel) {
    string[] debugTypes = ["notice", "info", "debug"];

    string result;
    if (!_fileName.isEmpty) {
      return _fileName;
    } else if (logLevel == "error" || logLevel == "warning") {
      return "error.log";
    } else if (debugTypes.has(logLevel)) {
      return "debug.log";
    }
    return logLevel ~ ".log";
  }
  string fileName() {
    return _fileName;
  }
  ILogger fileName(string newName) {
    _fileName = newName;
    return this;
  }
  // #endregion fileName

  // #region maxFileSize
  // Max file size, used for log file rotation.
  protected int _maxFileSize = 0;
  int maxFileSize() {
    return _maxFileSize;
  };
  ILogger maxFileSize(int newMaxSize) {
    _maxFileSize = newMaxSize;
    return this;
  };
  // #endregion maxFileSize

  // writing to log files.
  void log(int logLevel, string messageToLog, Json[string] messageContext = null) {
    string message; /* = this.interpolate(messageToLog, messageContext);
        message = _formatter.format(logLevel, message, messageContext); */

    string filename; // = fileName(logLevel);
    if (_maxFileSize) {
      _rotateFile(filename);
    }

    string filePath = _path ~ filename;
    Json mask = configuration.getEntry("mask");
    /* if (!mask) {
            file_put_contents(filePath, message ~ "\n", FILE_APPEND);

            return;
        } */

    bool fileExists = isFile(filePath);
    /* file_put_contents(filePath, message ~ "\n", FILE_APPEND); */

    bool selfError = false;
    /* if (!selfError && !fileExists && !chmod(filePath, to!int(mask))) {
            selfError = true;
            trigger_error(
                "Could not apply permission mask `%s` on log file `%s`"
                    .format(mask, filePath),
                    ERRORS.USER_WARNING);
            selfError = false;
        } */
  }

  /**
     * Rotate log file if size specified in config is reached.
     * Also if `rotate` count is reached oldest file is removed.
     * Params:
     * string logFilename Log file name
     */
  protected bool _rotateFile(string logFilename) {
    bool result = false;
    string logFilepath = _path ~ logFilename;
    /* clearstatcache(true, logFilepath); */

    /* if (!isFile(logFilepath) || filesize(logFilepath) < _maxFileSize) {
            return null;
        } */

    /* size_t rotate = configuration.getEntry("rotate");
        result = rotate == 0
            ? unlink(logFilepath) : rename(logFilepath, logFilepath ~ "." ~ time()); */

    /* auto files = glob(logFilepath ~ ".*");
        if (files) {
            size_t filesToDelete = files.length - rotate;
            while (filesToDelete > 0) {
                unlink(to!string(files.shift()));
                filesToDelete--;
            }
        } */
    return result;
  }

  override ILogger log(LogLevels logLevel, string logMessage, Json[string] logContext = null) {
    return this;
  }
}
mixin(LoggerCalls!("File"));

unittest {
    auto logger = new DFileLogger;
    assert(testLogger(logger));
}
