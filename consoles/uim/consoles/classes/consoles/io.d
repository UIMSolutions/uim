/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.consoles.classes.consoles.io;

import uim.consoles;

@safe:

/**
 * A wrapper around the various IO operations shell tasks need to do.
 *
 * Packages up the stdout, stderr, and stdin streams providing a simple
 * consistent interface for shells to use. This class DAlso makes mocking streams
 * easy to do in unit tests.
 */
class DConsoleIo : UIMObject {
    // Output constant making verbose shells.
    const int VERBOSE = 2;

    // Output constant for making normal shells.
    const int NORMAL = 1;

    // Output constants for making quiet shells.
    const int QUIET = 0;

    // The current output level.
    protected int _level = NORMAL;

    /**
     * The number of bytes last written to the output stream
     * used when overwriting the previous message.
     */
    protected int _lastWritten = 0;

    // Whether files should be overwritten
    protected bool _shouldOverwrite = false;

    protected bool _isInteractive = true;

    // The output stream
    protected DOutput _output;

    // The error stream
    protected DOutput _err;

    // The input stream
    protected DInput _input;

    // The helper registry.
    protected DConsoleHelperRegistry _helpers;

    this(
        DOutput output = null,
        DOutput errOutput = null,
        DInput input = null,
        DConsoleHelperRegistry helpers = null
    ) {
        /* _output = output ? result : new DOutput("uim://stdout"); */
        _err = errOutput.ifNull(new DOutput("uim://stderr"));
        _input = input.ifNull(new DInput("uim://stdin"));
        _helpers = helpers.ifNull(new DConsoleHelperRegistry());
        /* _helpers.setIo(this); */
    }

    void isInteractive(bool aValue) {
        _isInteractive = aValue; 
    }

    // Get/set the current output level.
    int level(int outputLevel = 0) {
        if (outputLevel != 0) {
            _level = outputLevel;
        }
        return _level;
    }

    // Output at the verbose level.
    ulong verbose(string[] messages...) {
        /* return verbose(messages.dup); */
        return 0;
    }

    ulong verbose(string[] messages, int newLinesToAppend = 1) {
        /* return _writeln(messages, newLinesToAppend, VERBOSE); */
        return 0;
    }

    // Output at all levels.
    ulong quiet(string[] outputMessages...) {
        // return quiet(outputMessages.dup);
        return 0;
    }

    ulong quiet(string[] outputMessages, int newLinesToAppend = 1) {
        /* return _writeln(outputMessages, newLinesToAppend, QUIET); */
        return 0;
    }

    /**
     * Outputs a single or multiple messages to stdout. If no parameters
     * are passed outputs just a newline.
     *
     * ### Output levels
     *
     * There are 3 built-in output level. ConsoleIo.QUIET, ConsoleIo.NORMAL, ConsoleIo.VERBOSE.
     * The verbose and quiet output levels, map to the `verbose` and `quiet` output switches
     * present in most shells. Using ConsoleIo.QUIET for a message means it will always display.
     * While using ConsoleIo.VERBOSE means it will only display when verbose output is toggled.
     */
    int out_(string[] amessage = null, int newLinesToAppend = 1, int outputLevel = NORMAL) {
        /* if (outputLevel > _level) {
            return null;
        }
       _lastWritten = _output.write(message, newLinesToAppend); */

        // return _lastWritten;
        return 0;
    }

    // Convenience method for out() that wraps message between <info> tag
    int info(string[] outputMessages...) {
        // return info(outputMessages.dup);
        return 0;
    }

    int info(string[] messages, int newLinesToAppend = 1, int outputLevel = NORMAL) {
        string messageType = "info";
        auto outputMessages = wrapMessageWithType(messageType, messages);

        // return _writeln(outputMessages, newLinesToAppend, outputLevel);
        return 0;
    }

    // Convenience method for out() that wraps message between <comment> tag
    int comment(string[] outputMessages...) {
        /* return comment(outputMessages.dup); */
        return 0;
    }

    int comment(string[] outputMessages, int newLinesToAppendToAppend = 1, int outputLevel = NORMAL) {
        /* auto message = wrapMessageWithType("comment", outputMessages);
        return _writeln(message, newLinesToAppend, outputLevel); */
        return 0;
    }

    // Convenience method for writeErrorMessages() that wraps message between <warning> tag
    int warning(string[] outputMessages, int newLinesToAppend = 1) {
        /*         auto message = wrapMessageWithType("warning", outputMessages);

        return _writeErrorMessages(message, newLinesToAppend); */
        return 0;
    }

    /**
     * Convenience method for writeErrorMessages() that wraps message between <error> tag
     * Params:
     * string[]|string amessage A string or an array of strings to output
     */
    int error(string[] message, int newLinesToAppend = 1) {
        /* string messageType = "error";
        message = wrapMessageWithType(messageType, message); */

        // return _writeErrorMessages(message, newLinesToAppend);
        return 0;
    }

    // Convenience method for out() that wraps message between <success> tag
    int success(string[] message, int newLinesToAppend = 1, int outputLevel = NORMAL) {
        string messageType = "success";
        message = wrapMessageWithType(messageType, message);

        // return _writeln(message, newLinesToAppend, outputLevel);
        return 0;
    }

    // Halts the the current process with a StopException.
    void abort(string errorMessage, int errorCode /* = DCommand.CODE_ERROR */ ) {
        // error(errorMessage);

        // throw new DStopException(errorMessage, errorCode);
    }

    // Wraps a message with a given message type, e.g. <warning>
    protected string[] wrapMessageWithType(string messageType, string[] messages) {
        return messages
            .map!(message => wrapMessageWithType(messageType, message))
            .array;
    }

    protected string wrapMessageWithType(string messageType, string message) {
        return "<%s>%s</%s>".format(messageType, message, messageType);
    }

    /**
     * Overwrite some already output text.
     *
     * Useful for building progress bars, or when you want to replace
     * text already output to the screen with new text.
     *
     * **Warning** You cannot overwrite text that contains newLinesToAppend.
     * Params:
     * string[]|string amessage The message to output.
     */
    void overwrite(string[] amessage, int newLinesToAppend = 1, int bytesToOverwrite = 0) {
        bytesToOverwrite = bytesToOverwrite ? bytesToOverwrite : _lastWritten;

        // Output backspaces.
        // writeln(str_repeat("\x08", bytesToOverwrite), 0);

        auto newBytes = 0; ///* (int) */ writeln(message, 0);

        // Fill any remaining bytes with spaces.
        auto fill = bytesToOverwrite - newBytes;
        if (fill > 0) {
            // writeln(str_repeat(" ", fill), 0);
        }
        if (newLinesToAppend) {
            writeln(this.nl(newLinesToAppend), 0);
        }
        // Store length of content + fill so if the new content
        // is shorter than the old content the next overwrite will work.
        if (fill > 0) {
            _lastWritten = newBytes + fill;
        }
    }

    /**
     * Outputs a single or multiple error messages to stderr. If no parameters
     * are passed outputs just a newline.
     */
    int writeErrorMessages(string[] messages...) {
        // return writeErrorMessages(messages.dup);
        return 0;
    }

    int writeErrorMessages(string[] messages, int newLinesToAppend = 1) {
        // return _err.write(messages, newLinesToAppend);
        return 0;
    }

    // Returns a single or multiple linefeeds sequences.
    string nl(int linefeedMultiplier = 1) {
        // return str_repeat(DOutput.LF, linefeedMultiplier);
        return null;
    }

    // Outputs a series of minus characters to the standard output, acts as a visual separator.
    void hr(int newLinesToAppend = 0, int widthOfLine = 79) {
        writeln("", newLinesToAppend);
        // writeln(str_repeat("-", widthOfLine));
        writeln("", newLinesToAppend);
    }

    // Prompts the user for input, and returns it.
    string ask(string promptText, string defaultInputValue = null) {
        return _getInput(promptText, null, defaultInputValue);
    }

    // Change the output mode of the stdout stream
    void setOutputAs(int outputMode) {
        _output.setOutputAs(outputMode);
    }

    // Gets defined styles.
    Json[string] styles() {
        return _output.styles();
    }

    // Get defined style.
    Json[string] getStyle(string styleToGet) {
        return _output.getStyle(styleToGet);
    }

    // Adds a new output style.
    void setStyle(string styleToSet, Json[string] styleDefinition) {
        _output.setStyle(styleToSet, styleDefinition);
    }

    // Prompts the user for input based on a list of options, and returns it.
    string askChoice(string promptText, string option, string defaultInput = null) {
        string[] options;
        /* if (option.contains(",")) {
            options = option.split(",");
        } else if (option.contains("/")) {
            options = option.split("/");
        } else {
            options = [option];
        }

        return askChoice(string promptText, string[] aoptions, string adefault = null); */
        return null;
    }

    string askChoice(string aprompt, string[] choices, string defaultValue = null) {
        string printChoices = "(" ~ choices.join("/") ~ ")";
        // choices = chain(choices.lower, choices.upper, choices);

        string anIn = "";
        /* while (anIn.isEmpty || !anIn.isIn(choices)) {
            // anIn = _getInput(prompt, printOptions, defaultValue);
        } */
        return anIn;
    }

    // Prompts the user for input, and returns it.
    protected string _getInput(string promptText, string options, string defaultValue) {
        if (!_isInteractive) {
            // return to!string(defaultValue);
        } 

        string optionsText = !options.isEmpty? " options " : "";

        string defaultText = !defaultValue.isNull ? "[%s] ".format(defaultValue) : "";
        // _output.write("<question>" ~ promptText ~ "</question>%s\n%s> ".fomat(optionsText, defaultText), 0);
        string result = _input.read();

        result = !result.isNull
            ? result.strip : "";

        return !result.isEmpty
            ? result : defaultValue;
    }

    /**
     * Connects or disconnects the loggers to the console output.
     *
     * Used to enable or disable logging stream output to stdout and stderr
     * If you don`t wish all log output in stdout or stderr
     * through uim`s Log class, call this auto with `enable=false`.
     *
     * If you would like to take full control of how console application logging
     * to stdout works add a logger that uses `'classname": 'Console'`. By
     * providing a console logger you replace the framework default behavior.
     * Params:
     * int|bool enable Use a boolean to enable/toggle all logging. Use
     * one of the verbosity constants (VERBOSE, QUIET, NORMAL)
     * to control logging levels. VERBOSE enables debug logs, NORMAL does not include debug logs,
     * QUIET disables notice, info and debug logs.
     */
    void setLoggers(bool enable) {
        /* Log.drop("stdout");
        Log.drop("stderr");
        if (enable == false) {
            return;
        }
        // If the application has configured a console logger
        // we don`t add a redundant one.
        Log.configured().each!((loggerName) {
            auto log = Log.engine(loggerName);
            if (cast(DConsoleLog) log) {
                return;
            }
        }); */

        string[] outLevels = ["notice", "info"];
        if (enable == VERBOSE || enable == true) {
            outLevels ~= "debug";
        }
        if (enable != QUIET) {
            /* stdout = new DConsoleLog([
                    "types": outLevels,
                    "stream": _output,
                ]);
            Log.configuration.set("stdout", ["engine": stdout]); */
        }
        /* auto stderr = new DConsoleLog(createmap!(string, Json)
            .set("types", ["emergency", "alert", "critical", "error", "warning"])
            .set("stream", _err); */
        // Log.configuration.set("stderr", ["engine": stderr]);
    }

    /**
     * Render a Console Helper
     *
     * Create and render the output for a helper object. If the helper
     * object has not already been loaded, it will be loaded and constructed.
     *
     * nameToRender The name of the helper to render
     * initData - Configuration data for the helper.
     * returns = Created helper instance.
     */
    /* DHelper helper(string nameToRender, Json[string] initData = null) {
        auto renderName = capitalize(nameToRender);
        return _helpers.load(renderName, initData);
    } */

    /**
     * Create a file at the given path.
     *
     * This method will prompt the user if a file will be overwritten.
     * Setting `forceOverwrite` to true will suppress this behavior
     * and always overwrite the file.
     *
     * If the user replies `a` subsequent `forceOverwrite` parameters will
     * be coerced to true and all files will be overwritten.
     */
    bool createFile(string fileCreationPath, string contentsForFile, bool shouldOverwrite = false) {
        /* writeln();
        shouldOverwrite = shouldOverwrite || _forceOverwrite; */

        /*         if (filehasKey(fileCreationPath) && shouldOverwrite == false) {
            warning("File `{fileCreationPath}` exists");
            aKey = askChoice("Do you want to overwrite?", [
                    "y", "n", "a", "q"
                ], "n");
            aKey = aKey.lower;

            if (aKey == "q") {
                error("Quitting.", 2);
                throw new DStopException("Not creating file. Quitting.");
            }
            if (aKey == "a") {
                _forceOverwrite = true;
                aKey = "y";
            }
            if (aKey != "y") {
                writeln("Skip `{fileCreationPath}`", 2);
                return false;
            }
        } else {
            writeln("Creating file {fileCreationPath}");
        }
 */ /* try {
            // Create the directory using the current user permissions.
            directory = dirname(fileCreationPath);
            if (!filehasKey(directory)) {
                mkdir(directory, 0777 ^ umask(), true);
            }
            file = new DSplFileObject(fileCreationPath, "w");
        } catch (RuntimeException) {
            error("Could not write to `{fileCreationPath}`. Permission denied.", 2);

            return false;
        } */
        /* file.rewind();
        file.fwrite(contentsForFile); */
        /* if (filehasKey(fileCreationPath)) {
            writeln("<success>Wrote</success> `{fileCreationPath}`");

            return true;
        } */
        /* error("Could not write to `{fileCreationPath}`.", 2); */
        return false;
    }
}
