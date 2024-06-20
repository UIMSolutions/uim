module uim.errors.classes.debugger;

import uim.errors;

@safe:

/**
 * Provide custom logging and error handling.
 *
 * Debugger : D`s default error handling and gives
 * simpler to use more powerful interfaces.
 */
class DDebugger {
    mixin TConfigurable;

    this() {
        initialize;
    }

    this(Json[string] initData) {
        initialize(initData);
    }

    this(string name) {
        this().name(name);
    }

    // Hook method
    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        configuration.updateDefaults([
            "outputMask": Json.emptyArray,
            "exportFormatter": Json(null),
            "editor": Json("Dstorm"),
        ]);

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

    mixin(TProperty!("string", "name"));

    // A map of editors to their link templates.
    protected STRINGAA _editors;

    /**
     * Add an editor link format
     *
     * Template strings can use the `{file}` and `{line}` placeholders.
     * Closures templates must return a string, and accept two parameters:
     * The file and line.
     * Params:
     * @param \/*Closure|*/ string atemplate The string template or closure
     */
    static void addEditor(string editorName, /* IClosure */ string atemplate) {
        auto anInstance = getInstance();
        anInstance.editors[editorName] = template;
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
     * @param int line The line number to create a link for.
     */
    static string editorUrl(string afile, int line) {
        auto anInstance = getInstance();
        editor = anInstance.configuration.get("editor");
        if (!anInstance.editors.hasKey(editor)) {
            throw new DInvalidArgumentException(
                "Cannot format editor URL `%s` is not a known editor."
                    .format(editor));
        }
        template = anInstance.editors[editor];
        if (isString(template)) {
            return template.replace(["{file}", "{line}"], [file, (string) line]);
        }
        return template(file, line);
    }
    /*
    //Holds current output data when outputFormat is false.
    protected Json[string] _data = null;

    this() {
        docRef = ini_get("docref_root");
        if (isEmpty(docRef) && function_exists("ini_set")) {
            ini_set("docref_root", "https://secure.d.net/");
        }
        if (!defined("E_RECOVERABLE_ERROR")) {
            define("E_RECOVERABLE_ERROR", 4096);
        }
        aConfig = array_intersectinternalKey(/* (array) */configuration.get("Debugger"), _defaultConfigData);
        configuration.update(aConfig);
    }
    
    /**
     * Returns a reference to the Debugger singleton object instance.
     * Params:
     * class-string<\UIM\Error\Debugger>|null  className Class name.
     */
    static static getInstance(string className = null) {
        /** @var array<int, static>  anInstance */
        static anInstance = null;
        if (className) {
            if (!anInstance || strtolower(className) != get_class(anInstance[0]).lower) {
                anInstance[0] = new className();
            }
        }
        if (!anInstance) {
            anInstance[0] = new Debugger();
        }
        return anInstance[0];
    }

    /**
     * Read or write configuration options for the Debugger instance.
     * Params:
     * Json[string]|string aKey The key to get/set, or a complete array of configs.
     * @param mixed|null aValue The value to set.
     * @param bool merge Whether to recursively merge or overwrite existing config, defaults to true.
     */
    static Json[string] configSettings = nullInstance(string[] aKey = null, Json aValue = null, bool merge = true) {
        if (aKey.isNull) {
            return getInstance().configuration.get(aKey);
        }

        if (isArray(aKey) || func_num_args() >= 2) {
            return getInstance().setConfig(aKey, aValue, merge);
        }
        return getInstance().configuration.get(aKey);
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

    /**
     * Recursively formats and outputs the contents of the supplied variable.
     * Params:
     * Json var The variable to dump.
     * @param int maxDepth The depth to output to. Defaults to 3.
     */
    static void dump(Json var, int maxDepth = 3) {
        pr(exportVar(var, maxDepth));
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
        for (anI = frameCount, p = parentCount; anI >= 0 && p >= 0; p--) {
            parentTail = parentFrames[p];
            tail = frames[anI];

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
                remove(frames[anI]);
                anI--;
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
     * Params:
     * Json[string] options Format for outputting stack trace.
     */
    static string[] trace(Json[string] options = null) {
        // Remove the frame for Debugger.trace()
        backtrace = debug_backtrace();
        array_shift(backtrace);

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
        defaults = [
            "depth": 999.toJson,
            "format": "text".toJson,
            "args": false.toJson,
            "start": 0.toJson,
            "scope": Json(null),
            "exclude": ["call_user_func_array", "trigger_error"].toJson,
        ];

        auto mergedOptions = Hash.merge(defaults, options);
        auto count = count(backtrace) + 1;
        string[] back = null;

        for (anI = mergedOptions["start"]; anI < count && anI < mergedOptions["depth"]; anI++) {
            frame = ["file": "[main]", "line": ""];
            if (isSet(backtrace[anI])) {
                frame = backtrace[anI] ~ ["file": "[internal]", "line": "??"];
            }
            string signature = frame.getString("file");
            string reference = frame.getString("file");
            if (!frame.isEmpty("class")) {
                string signature = frame.getString("class") ~ frame.getString("type") ~ frame.getString("function");
                string reference = signature ~ "(";
                if (mergedOptions["args"] && isSet(frame["args"])) {
                    reference ~= frame["args"].map!(arg => Debugger.exportVar(arg)).join(", ");
                }
                reference ~= ")";
            }
            if (isIn(signature, mergedOptions["exclude"], true)) {
                continue;
            }
            if (mergedOptions.getString("format") == "points") {
                back ~= [
                    "file": frame["file"],
                    "line": frame["line"],
                    "reference": reference
                ];
            } else if (mergedOptions.getString("format") == "array") {
                if (!mergedOptions["args"]) {
                    remove(frame["args"]);
                }
                back ~= frame;
            } else if (mergedOptions.getString("format") == "text") {
                somePath = trimPath(frame["file"]);
                back ~= "%s - %s, line %d".format(reference, somePath, frame["line"]);
            } else {
                debug (mergedOptions);
                throw new DInvalidArgumentException(
                    "Invalid trace format of `{mergedOptions[\"format\"]}` chosen. Must be one of `array`, `points` or `text`."
               );
            }
        }
        if (mergedOptions.getString("format") == "array" || mergedOptions.getString("format") == "points") {
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
     * are processed with highlight_string() as well, so they have basic D syntax highlighting
     * applied.
     * Params:
     * @param int context Number of lines of context to extract above and below lineToHighlight.
     */
    static string[] excerpt(string filePath, int lineToHighlight, int numberOfLinesToExtract = 2) {
        string[] lines = null;
        if (!fileExists(filePath)) {
            return null;
        }
        
        string[] someData = file_get_contents(filePath);
        if (someData.isEmpty) {
            return lines;
        }
        if (someData.contains("\n")) {
            someData = someData.split("\n");
        }
        lineToHighlight--;
        if (!isSet(someData[lineToHighlight])) {
            return lines;
        }
        for (anI = lineToHighlight - numberOfLinesToExtract; anI < lineToHighlight + numberOfLinesToExtract + 1;
            anI++) {
            if (!isSet(someData[anI])) {
                continue;
            }
            string lineToHighlight = _highlight(someData[anI]).replace(["\r\n", "\n"], "");
            lines ~= anI == lineToHighlight
                ? "<span class=\"code-highlight\">" ~ string ~ "</span>" : lineToHighlight;
        }
        return lines;
    }

    /**
     * Wraps the highlight_string auto in case the server API does not
     * implement the auto as it is the case of the HipHop interpreter
     */
    protected static string _highlight(string stringToConvert) {
        if (function_exists("hD_log") || function_exists("hD_gettid")) {
            return htmlentities(stringToConvert);
        }
        added = false;
        if (!stringToConvert.contains("")) {
            added = true;
            stringToConvert = " \n" ~ stringToConvert;
        }
        highlight = highlight_string(stringToConvert, true);
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
        auto className = anInstance.configuration.get("exportFormatter");
        if (!className) {
            if (ConsoleFormatter.environmentMatches()) {
                className = ConsoleFormatter.classname;
            } else if (HtmlFormatter.environmentMatches()) {
                className = HtmlFormatter.classname;
            } else {
                className = TextFormatter.classname;
            }
        }
        anInstance = new className();
        if (!cast(IErrorFormatter) anInstance) {
            throw new DException(
                "The `%s` formatter does not implement `%s`."
                    .format(className, IErrorFormatter.classname)
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
        auto context = new DebugContext(maxDepth);
        auto node = export_(varToConvert, context);

        return getInstance().getExportFormatter().dump(node);
    }

    /**
     * Converts a variable to a plain text string.
     * Params:
     * Json var Variable to convert.
     * @param int maxDepth The depth to output to. Defaults to 3.
     */
    static string exportVarAsPlainText(Json var, int maxDepth = 3) {
        return (new DTextFormatter()).dump(
            export_(var, new DebugContext(maxDepth))
       );
    }

    /**
     * Convert the variable to the internal node tree.
     *
     * The node tree can be manipulated and serialized more easily
     * than many object graphs can.
     * Params:
     * Json var Variable to convert.
     * @param int maxDepth The depth to generate nodes to. Defaults to 3.
     */
    static IErrorNode exportVarAsNodes(Json var, int maxDepth = 3) {
        return export_(var, new DebugContext(maxDepth));
    }

    /**
     * Protected export auto used to keep track of indentation and recursion.
     * Params:
     * Json var The variable to dump.
     * @param \UIM\Error\Debug\DebugContext context Dump context
     */
    protected static IErrorNode export_(Json var, DebugContext context) {
        string type = getType(var);

        if (type.startWith("resource ")) {
            return new DScalarNode(type, var);
        }
        return null; // TODO 
        /* return match(type) {
            "float", "string", "null" : new DScalarNode(type, var),
            "bool" : new DScalarNode("bool", var),
            "int" : new DScalarNode("int", var),
            "array" : exportArray(var, context.withAddedDepth()),
            "unknown" : new DSpecialNode("(unknown)"),
            default : exportObject(var, context.withAddedDepth()),
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
     * Params:
     * Json[string] var The array to export.
     * @param \UIM\Error\Debug\DebugContext context The current dump context.
     */
    protected static ArrayNode exportArray(Json[string] var, DebugContext context) {
        someItems = null;

        remaining = context.remainingDepth();
        if (remaining >= 0) {
            outputMask = outputMask();
            foreach (aKey : val; var) {
                if (array_key_exists(aKey, outputMask)) {
                    node = new DScalarNode("string", outputMask[aKey]);
                } else if (val != var) {
                    // Dump all the items without increasing depth.
                    node = export_(val, context);
                } else {
                    // Likely recursion, so we increase depth.
                    node = export_(val, context.withAddedDepth());
                }
                someItems ~= new ArrayItemNode(export_(aKey, context), node);
            }
        } else {
            someItems ~= new ArrayItemNode(
                new DScalarNode("string", ""),
                new DSpecialNode("[maximum depth reached]")
           );
        }
        return new ArrayNode(someItems);
    }

    /**
     * Handles object to node conversion.
     * Params:
     * object var Object to convert.
     * @param \UIM\Error\Debug\DebugContext context The dump context.
     */
    protected static IErrorNode exportObject(object var, DebugContext context) {
        isRef = context.hasReference(var);
        refNum = context.getReferenceId(var);

        className = var.classname;
        if (isRef) {
            return new DReferenceNode(className, refNum);
        }
        node = new DClassNode(className, refNum);

        remaining = context.remainingDepth();
        if (remaining > 0) {
            if (method_exists(var, "__debugInfo")) {
                try {
                    foreach (/* (array) */ var.__debugInfo() as aKey : val) {
                        node.addProperty(new DPropertyNode("'{aKey}'", null, export_(val, context)));
                    }
                    return node;
                } catch (Exception anException) {
                    return new DSpecialNode(
                        "(unable to export object: { anException.getMessage()})");
                }
            }
            outputMask = outputMask();
            objectVars = get_object_vars(var);
            objectVars.byKeyValue
                .each!((kv) {
                    if (outputMask.hasKey(kv.key)) {
                        kv.value = outputMask[kv.key];
                    }
                    node.addProperty(
                        new DPropertyNode((string) kv.key, "public", export_(kv.value, context.withAddedDepth()))
                   );
                });
            ref = new DReflectionObject(var);

            filters = [
                ReflectionProperty.IS_PROTECTED: "protected",
                ReflectionProperty.IS_PRIVATE: "private",
            ];
            foreach (filter : visibility; filters) {
                reflectionProperties = ref.getProperties(filter);
                foreach (reflectionProperty; reflectionProperties) {
                    reflectionProperty.setAccessible(true);

                    if (
                        method_exists(reflectionProperty, "isInitialized") &&
                        !reflectionProperty.isInitialized(var)
                       ) {
                        aValue = new DSpecialNode("[uninitialized]");
                    } else {
                        aValue = export_(reflectionProperty.getValue(var), context.withAddedDepth());
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
        return node;
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
        auto locationData ~= ["file": Json(null), "line": Json(null)];
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
        writeln(formatter.formatWrapper(contents, locationData));
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
        string message = htmlAttributeEscape(messageToFormat);
        message = (string) preg_replace("/`([^`]+)`/", "<code>0</code>", message);

        return nl2br(message);
    }

    // Verifies that the application`s salt and cipher seed value has been changed from the default value.
    static void checkSecurityKeys() {
        salt = Security.getSalt();
        if (salt == "__SALT__" || salt.length < 32) {
            trigger_error(
                "Please change the value of `Security.salt` in `ROOT/config/app_local.d` " ~
                    "to a random value of at least 32 characters.",
                    E_USER_NOTICE
           );
        }
    }
}
