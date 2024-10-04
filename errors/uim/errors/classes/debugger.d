/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.classes.debugger;

import uim.errors;

@safe:

/**
 * Provide custom logging and error handling.
 *
 * Debugger : D`s default error handling and gives
 * simpler to use more powerful interfaces.
 */
class DDebugger : UIMObject {
    this() {
        super();
    }

    this(Json[string] initData) {
        super(initData);
    }

    this(string name, Json[string] initData = null) {
        super(name, initData);
    }

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        configuration
            .setDefault("outputMask", Json.emptyArray)
            .setDefault("exportFormatter", Json(null))
            .setDefault("editor", "Dstorm");

        _editors = [
            "atom": "atom://core/open/file?filename={file}&line={line}",
            "emacs": "emacs://open?url=file://{file}&line={line}",
            "macvim": "mvim://open/?url=file://{file}&line={line}",
            "Dstorm": "Dstorm://open?file={file}&line={line}",
            "sublime": "subl://open?url=file://{file}&line={line}",
            "textmate": "txmt://open?url=file://{file}&line={line}",
            "vscode": "vscode://file/{file}:{line}",
        ];

        return true;
    }

    // A map of editors to their link templates.
    protected STRINGAA _editors;

    /**
     * Add an editor link format
     *
     * Template strings can use the `{file}` and `{line}` placeholders.
     * Closures templates must return a string, and accept two parameters:
     * The file and line.
     */
    static void addEditor(string editorName, /* IClosure */ string templateText) {
        getInstance().editors[editorName] = templateText;
    }

    // Choose the editor link style you want to use.
    static void setEditor(string editorName) {
        auto anInstance = getInstance();
        if (!anInstance.editors.hasKey(editorName)) {
            auto known = anInstance.editors.keys.join(", ");
            throw new DInvalidArgumentException(
                "Unknown editor `%s`. Known editors are `%s`."
                    .format(editorName, known)
            );
        }
        anInstance.configuration.set("editor", name);
    }

    /**
     * Get a formatted URL for the active editor.
     * Params:
     * string afile The file to create a link for.
     */
    static string editorUrl(string filename, int lineNumber) {
        auto anInstance = getInstance();
        auto editor = anInstance.configuration.get("editor");
        if (!anInstance.editors.hasKey(editor)) {
            throw new DInvalidArgumentException(
                "Cannot format editor URL `%s` is not a known editor."
                    .format(editor));
        }
        auto templateText = anInstance.editors[editor];
        if (isString(templateText)) {
            return templateText.replace(["{file}", "{lineNumber}"], [
                    filename, to!string(lineNumber)
                ]);
        }
        return templateText(file, lineNumber);
    }
    /*
    //Holds current output data when outputFormat is false.
    protected Json[string] _data = null;

    this() {
        docRef = ini_get("docref_root");
        if (isEmpty(docRef) && function_hasKey("ini_set")) {
            ini_set("docref_root", "https://secure.d.net/");
        }
        if (!defined("ERRORS.RECOVERABLE_ERROR")) {
            define("ERRORS.RECOVERABLE_ERROR", 4096);
        }
        aConfig = intersectinternalKey(configuration.getArray("Debugger"), _defaultConfigData);
        configuration.set(aConfig);
    }
    
    // Returns a reference to the Debugger singleton object instance.
    /* static static getInstance(string classname = null) {
        /** @var array<int, static>  anInstance * /
        static anInstance = null;
        if (classname) {
            if (!anInstance || strtolower(classname) != get_class(anInstance[0]).lower) {
                anInstance[0] = new classname();
            }
        }
        if (!anInstance) {
            anInstance[0] = new Debugger();
        }
        return anInstance[0];
    } */

    /**
     * Read or write configuration options for the Debugger instance.
     * Params:
     * Json[string]|string key The key to get/set, or a complete array of configs.
     */
    static Json[string] nullInstance(string[] key = null, Json aValue = null, bool shouldMerge = true) {
        if (key.isNull) {
            // return getInstance().configuration.get(key);
        }

        /*         if (isArray(key) || func_num_args() >= 2) {
            return getInstance().setConfig(key, aValue, shouldMerge);
        }
 */
        // return getInstance().configuration.get(key);
        return null;
    }

    // Reads the current output masking.
    static STRINGAA outputMask() {
        return configInstance("outputMask");
    }

    /**
     * Sets configurable masking of debugger output by property name and array key names.
     *
     * ### Example
     *
     * Debugger.setOutputMask(["password": '[*************]");
     */
    static void setOutputMask(Json[string] keyReplaceData, bool shouldMerge = true) {
        configInstance("outputMask", keyReplaceData, shouldMerge);
    }

    // Recursively formats and outputs the contents of the supplied variable.
    static void dump(Json valueToDump, int maxOutputDepth = 3) {
        pr(exportVar(valueToDump, maxOutputDepth));
    }

    /**
     * Creates an entry in the log file. The log entry will contain a stack trace from where it was called.
     * as well as export the variable using exportVar. By default, the log is written to the debug log.
     */
    static void log(Json varToLog, string levelType = "debug", int maxDepth = 3) {
        string source = trace(["start": 1]);
        source ~= "\n";

        Log.write(
            levelType,
            "\n" ~ source ~ exportVarAsPlainText(varToLog, maxDepth)
        );
    }

    // Get the frames from exception that are not present in parent
    static Json[string] getUniqueFrames(Throwable exception, Throwable parent) {
        if (parent.isNull) {
            return exception.getTrace();
        }
        parentFrames = parent.getTrace();
        frames = exception.getTrace();

        parentCount = count(parentFrames) - 1;
        frameCount = count(frames) - 1;

        // Reverse loop through both traces removing frames that
        // are the same.
        for (index = frameCount, p = parentCount; index >= 0 && p >= 0; p--) {
            parentTail = parentFrames[p];
            tail = frames[index];

            // Frames without file/line are never equal to another frame.
            isEqual = (
                (
                    tail.hasAllKeys("file", "line") &&
                    parentTail.hasAllKeys("file", "line")
            ) &&
                (tail["file"] == parentTail["file"]) &&
                (tail["line"] == parentTail["line"])
            );
            if (isEqual) {
                removeKey(frames[index]);
                index--;
            }
        }
        return frames;
    }

    /**
     * Outputs a stack trace based on the supplied options.
     *
     * ### Options
     *
     * - `depth` - The number of stack frames to return. Defaults to 999
     * - `format` - The format you want the return. Defaults to the currently selected format. If
     *  format is 'array' or 'points' the return will be an array.
     * - `args` - Should arguments for functions be shown? If true, the arguments for each method call
     * will be displayed.
     * - `start` - The stack frame to start generating a trace from. Defaults to 0
     */
    static string[] trace(Json[string] options = null) {
        // Remove the frame for Debugger.trace()
        backtrace = debug_backtrace();
        backtrace.shift;

        return Debugger.formatTrace(backtrace, options);
    }

    /**
     * Formats a stack trace based on the supplied options.
     *
     * ### Options
     *
     * - `depth` - The number of stack frames to return. Defaults to 999
     * - `format` - The format you want the return. Defaults to 'text'. If
     *  format is 'array' or 'points' the return will be an array.
     * - `args` - Should arguments for functions be shown? If true, the arguments for each method call
     * will be displayed.
     * - `start` - The stack frame to start generating a trace from. Defaults to 0
     */
    static string[] formatTrace(Throwable backtrace, Json[string] options = null) {
        if (cast(Throwable) backtrace) {
            backtrace = backtrace.getTrace();
        }

        options
            .merge("depth", 999)
            .merge("format", "text")
            .merge("args", false)
            .merge("start", 0)
            .merge("scope", Json(null))
            .merge("exclude", ["call_user_func_array", "trigger_error"]);

        auto count = count(backtrace) + 1;
        string[] back = null;

        for (index = options.getLong("start"); index < count && index < options.getLong("depth");
            index++) {
            frame = ["file": "[main]", "line": ""];
            if (isSet(backtrace[index])) {
                frame = backtrace[index] ~ ["file": "[internal]", "line": "??"];
            }
            string signature = frame.getString("file");
            string reference = frame.getString("file");
            if (!frame.isEmpty("class")) {
                string signature = frame.getString("class") ~ frame.getString(
                    "type") ~ frame.getString("function");
                string reference = signature ~ "(";
                if (options.hasKey("args") && frame.hasKey("args")) {
                    reference ~= frame["args"].map!(arg => Debugger.exportVar(arg)).join(", ");
                }
                reference ~= ")";
            }
            if (isIn(signature, options.get("exclude"), true)) {
                continue;
            }

            if (options.getString("format") == "points") {
                back ~= [
                    "file": frame("file"),
                    "line": frame("line"),
                    "reference": reference
                ];
            } else if (options.getString("format") == "array") {
                if (!options.hasKey("args")) {
                    frame.removeKey("args");
                }
                back ~= frame;
            } else if (options.getString("format") == "text") {
                somePath = trimPath(frame["file"]);
                back ~= "%s - %s, line %d".format(reference, somePath, frame["line"]);
            } else {
                /* debug (options);
                throw new DInvalidArgumentException(
                    "Invalid trace format of `{options.get(\"format\"]}` chosen. Must be one of `array`, `points` or `text`."
               ); */
            }
        }
        if (options.getString("format") == "array" || options.getString("format") == "points") {
            return back;
        }
        return back.join("\n");
    }

    // Shortens file paths by replacing the application base path with 'APP", and the UIM core path with 'CORE'.
    static string trimPath(string pathToShorten) {
        if (defined("APP") && pathToShorten.startWith(APP)) {
            return pathToShorten.replace(APP, "APP/");
        }
        if (defined("uim_CORE_INCLUDE_PATH") && pathToShorten.startWith(uim_CORE_INCLUDE_PATH)) {
            return pathToShorten.replace(uim_CORE_INCLUDE_PATH, "CORE");
        }
        return defined("ROOT") && pathToShorten.startWith(ROOT)
            ? pathToShorten.replace(ROOT, "ROOT") : pathToShorten;
    }

    /**
     * Grabs an excerpt from a file and highlights a given line of code.
     *
     * Usage:
     *
     * ```
     * Debugger.excerpt("/path/to/file", 100, 4);
     * ```
     *
     * The above would return an array of 8 items. The 4th item would be the provided line,
     * and would be wrapped in `<span class="code-highlight"></span>`. All the lines
     * are processed with highlight_string() as well, so they have basic UIM syntax highlighting
     * applied.
     */
    static string[] excerpt(string filePath, int lineToHighlight, int numberOfLinesToExtract = 2) {
        string[] lines = null;
        if (!filehasKey(filePath)) {
            return null;
        }

        string[] contents = file_get_contents(filePath);
        if (contents.isEmpty) {
            return lines;
        }
        if (contents.contains("\n")) {
            contents = someData.split("\n");
        }
        lineToHighlight--;
        if (contents.isNull(lineToHighlight)) {
            return lines;
        }

        for (index = lineToHighlight - numberOfLinesToExtract; index < lineToHighlight + numberOfLinesToExtract + 1;
            index++) {
            if (contents[index]!is null) {
                continue;
            }
            string lineToHighlight = _highlight(someData[index]).replace([
                "\r\n", "\n"
            ], "");
            lines ~= index == lineToHighlight
                ? htmlDoubleTag("span", ["code-highlight"], "string") : lineToHighlight;
        }
        return lines;
    }

    /**
     * Wraps the highlight_string auto in case the server API does not
     * implement the auto as it is the case of the HipHop interpreter
     */
    protected static string _highlight(string stringToConvert) {
        if (function_hasKey("hD_log") || function_hasKey("hD_gettid")) {
            return htmlentities(stringToConvert);
        }

        bool added = false;
        if (!stringToConvert.contains("")) {
            added = true;
            stringToConvert = " \n" ~ stringToConvert;
        }

        string highlight = highlight_string(stringToConvert, true);
        if (added) {
            highlight = highlight.replace(
                ["&lt;?D&nbsp;<br/>", "&lt;?D&nbsp;<br />"],
                "");
        }
        return highlight;
    }

    // Get the configured export formatter or infer one based on the environment.
    IErrorFormatter getExportFormatter() {
        auto anInstance = getInstance();
        auto classname = anInstance.configuration.get("exportFormatter");
        if (!classname) {
            if (DConsoleFormatter.environmentMatches()) {
                classname = ConsoleFormatter.classname;
            } else if (HtmlFormatter.environmentMatches()) {
                classname = HtmlFormatter.classname;
            } else {
                classname = TextFormatter.classname;
            }
        }
        anInstance = new classname();
        if (!cast(IErrorFormatter) anInstance) {
            throw new DException(
                "The `%s` formatter does not implement `%s`."
                    .format(classname, IErrorFormatter.classname)
            );
        }
        return anInstance;
    }

    /**
     * Converts a variable to a string for debug output.
     *
     * *Note:* The following keys will have their contents
     * replaced with `*****`:
     *
     * - password
     * - login
     * - host
     * - database
     * - port
     * - prefix
     * - schema
     *
     * This is done to protect database credentials, which could be accidentally
     * shown in an error message if UIM is deployed in development mode.
     */
    static string exportVar(Json varToConvert, int maxDepth = 3) {
        auto context = new DDebugContext(maxDepth);
        auto node = export_(varToConvert, context);

        return getInstance().getExportFormatter().dump(node);
    }

    /**
     * Converts a variable to a plain text string.
     * Params:
     * Json var Variable to convert.
     */
    static string exportVarAsPlainText(Json var, int maxOutputDepth = 3) {
        return (new DTextFormatter()).dump(
            export_(var, new DDebugContext(maxOutputDepth))
        );
    }

    /**
     * Convert the variable to the internal node tree.
     *
     * The node tree can be manipulated and serialized more easily
     * than many object graphs can.
     */
    static IErrorNode exportVarAsNodes(Json valueToConvert, int maxOutputDepth = 3) {
        return export_(valueToConvert, new DDebugContext(maxOutputDepth));
    }

    /**
     * Protected export auto used to keep track of indentation and recursion.
     * Params:
     * Json var The variable to dump.
     */
    protected static IErrorNode export_(Json valueToDump, DDebugContext context) {
        string type = getType(valueToDump);

        if (type.startWith("resource ")) {
            return new DScalarNode(type, valueToDump);
        }
        return null; // TODO 
        /* return match(type) {
            "float", "string", "null" : new DScalarNode(type, valueToDump),
            "bool" : new DScalarNode("bool", valueToDump),
            "int" : new DScalarNode("int", valueToDump),
            "array" : exportArray(valueToDump, context.withAddedDepth()),
            "unknown" : new DSpecialNode("(unknown)"),
            default : exportObject(valueToDump, context.withAddedDepth()),
        }; */
    }

    /**
     * Export an array type object. Filters out keys used in datasource configuration.
     *
     * The following keys are replaced with ***
     *
     * - password
     * - login
     * - host
     * - database
     * - port
     * - prefix
     * - schema
     */
    protected static ArrayNode exportArray(Json[string] exportValues, DDebugContext dumpContext) {
        auto someItems = null;

        auto remaining = dumpContext.remainingDepth();
        if (remaining >= 0) {
            outputMask = outputMask();
            exportValues.byKeyValue((item) {
                if (hasKey(item.key, outputMask)) {
                    node = new DScalarNode("string", outputMask[item.key]);
                } else if (item.value != exportValues) {
                    // Dump all the items without increasing depth.
                    node = export_(item.value, dumpContext);
                } else {
                    // Likely recursion, so we increase depth.
                    node = export_(item.value, dumpContext.withAddedDepth());
                }
                someItems ~= new ArrayItemNode(export_(item.key, dumpContext), node);
            });
        } else {
            someItems ~= new ArrayItemNode(
                new DScalarNode("string", ""),
                new DSpecialNode("[maximum depth reached]")
            );
        }
        return new ArrayNode(someItems);
    }

    // Handles object to node conversion.
    protected static IErrorNode exportObject(object objToConvert, DDebugContext dumpContext) {
        /* auto isRef = dumpContext.hasReference(objToConvert);
        auto refNum = dumpContext.getReferenceId(objToConvert);

        auto objClassname = var.classname;
        if (isRef) {
            return new DReferenceNode(classname, refNum);
        }

        auto node = new DClassNode(classname, refNum);
        auto remaining = dumpContext.remainingDepth();
        if (remaining > 0) {
            if (hasMethod(objToConvert, "debugInfo")) {
                 try {
                    foreach (key, val; /* (array) * / objToConvert.debugInfo()) {
                        node.addProperty(new DPropertyNode("'{key}'", null, export_(val, dumpContext)));
                    }
                    return node;
                } catch (Exception anException) {
                    return new DSpecialNode(
                        "(unable to export object: { anException.message()})");
                }
             }
            auto outputMask = outputMask();
            auto objectVars = get_object_vars(objToConvert);
            objectVars.byKeyValue
                .each!((kv) {
                    if (outputMask.hasKey(kv.key)) {
                        kv.value = outputMask[kv.key];
                    }
                    node.addProperty(
                        new DPropertyNode((string) kv.key, "public", export_(kv.value, dumpContext.withAddedDepth()))
                   );
                });
            ref = new DReflectionObject(objToConvert);

            filters = [
                ReflectionProperty.IS_PROTECTED: "protected",
                ReflectionProperty.IS_PRIVATE: "private",
            ];
            foreach (filter : visibility; filters) {
                reflectionProperties = ref.getProperties(filter);
                foreach (reflectionProperty; reflectionProperties) {
                    reflectionProperty.setAccessible(true);

                    if (
                        hasMethod(reflectionProperty, "isInitialized") &&
                        !reflectionProperty.isInitialized(objToConvert)
                       ) {
                        aValue = new DSpecialNode("[uninitialized]");
                    } else {
                        aValue = export_(reflectionProperty.getValue(objToConvert), dumpContext.withAddedDepth());
                    }
                    node.addProperty(
                        new DPropertyNode(
                            reflectionProperty.name,
                            visibility,
                            aValue
                   )
                   );
                }
            }
        }
        return node; */
        return null;
    }

    // Get the type of the given variable. Will return the class name for objects.
    static string getType(Json variableToCheck) {
        string variableType = get_debug_type(variableToCheck);

        switch (variableType) {
        case "double":
            return "float";
        case "unknown type":
            return "unknown";
        default:
            return variableType;
        }
    }

    // Prints out debug information about given variable.
    static void printVar(Json debugValue, Json[string] locationData = null, string showHtml = null) {
        /* auto locationData ~= ["file": Json(null), "line": Json(null)];
        if (locationData["file"]) {
            locationData["file"] = trimPath((string) locationData["file"]);
        }

        auto debugger = getInstance();
        auto restore = null;
        if (!showHtml.isNull) {
            restore = debugger.configuration.get("exportFormatter");
            debugger.configuration.set("exportFormatter", showHtml == "true" ? HtmlFormatter.classname
                    : TextFormatter.classname);
        }
        auto contents = exportVar(debugValue, 25);
        auto formatter = debugger.getExportFormatter();

        if (restore) {
            debugger.setConfig("exportFormatter", restore);
        }
        writeln(formatter.formatWrapper(contents, locationData)); */
    }

    /**
     * Format an exception message to be HTML formatted.
     *
     * Does the following formatting operations:
     *
     * - HTML escape the message.
     * - Convert `bool` into `<code>bool</code>`
     * - Convert newlines into `<br>`
     */
    static string formatHtmlMessage(string messageToFormat) {
        /* string message = htmlAttributeEscape(messageToFormat);
        message = (string) preg_replace("/`([^`]+)`/", "<code>0</code>", message);

        return nl2br(message); */
        return null;
    }

    // Verifies that the application`s salt and cipher seed value has been changed from the default value.
    static void checkSecurityKeys() {
        salt = Security.getSalt();
        if (salt == "__SALT__" || salt.length < 32) {
            trigger_error(
                "Please change the value of `Security.salt` in `ROOT/config/app_local.d` " ~
                    "to a random value of at least 32 characters.",
                    ERRORS.USER_NOTICE
            );
        }
    }
}
