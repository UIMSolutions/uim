module uim.errors.classes.debugger;

import uim.errors;

@safe:

/**
 * Provide custom logging and error handling.
 *
 * Debugger : PHP`s default error handling and gives
 * simpler to use more powerful interfaces.
 *
 * @link https://book.UIM.org/5/en/development/debugging.html#namespace-UIM\Error
 */
class DDebugger {
    mixin TConfigurable!();
    
    this() {
        initialize;
    }

    this(IData[string] initData) {
        initialize(initData);
    }

    this(string name) {
        this().name(name);
    }

    // Hook method
    bool initialize(IData[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));
    /*

    // Default configuration
    configuration.updateDefaults([
        "outputMask": ArrayData,
        "exportFormatter": null,
        "editor": StringData("phpstorm"),
    ];

    // A map of editors to their link templates.
    protected STRINGAA editors = [
        "atom": "atom://core/open/file?filename={file}&line={line}",
        "emacs": "emacs://open?url=file://{file}&line={line}",
        "macvim": "mvim://open/?url=file://{file}&line={line}",
        "phpstorm": "phpstorm://open?file={file}&line={line}",
        "sublime": "subl://open?url=file://{file}&line={line}",
        "textmate": "txmt://open?url=file://{file}&line={line}",
        "vscode": "vscode://file/{file}:{line}",
    ];

    //Holds current output data when outputFormat is false.
    protected array _data = null;

    this() {
        docRef = ini_get("docref_root");
        if (isEmpty(docRef) && function_exists("ini_set")) {
            ini_set("docref_root", "https://secure.d.net/");
        }
        if (!defined("E_RECOVERABLE_ERROR")) {
            define("E_RECOVERABLE_ERROR", 4096);
        }
        aConfig = array_intersect_key((array)Configure.read("Debugger"), _defaultConfigData);
        configuration.update(aConfig);
    }
    
    /**
     * Returns a reference to the Debugger singleton object instance.
     * Params:
     * class-string<\UIM\Error\Debugger>|null  className Class name.
     * /
    static static getInstance(string className = null) {
        /** @var array<int, static>  anInstance * /
        static  anInstance = null;
        if (className) {
            if (!anInstance || strtolower(className) != get_class(anInstance[0]).toLower) {
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
     * IData[string]|string aKey The key to get/set, or a complete array of configs.
     * @param mixed|null aValue The value to set.
     * @param bool merge Whether to recursively merge or overwrite existing config, defaults to true.
     * @throws \UIM\Core\Exception\UimException When trying to set a key that is invalid.
     * /
    static IData[string] configSettings = nullInstance(string[] aKey = null, IData aValue = null, bool merge = true) {
        if (aKey is null) {
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
     * Params:
     * STRINGAA aValue An array where keys are replaced by their values in output.
     * @param bool merge Whether to recursively merge or overwrite existing config, defaults to true.
     * /
    static void setOutputMask(array aValue, bool merge = true) {
        configInstance("outputMask", aValue, merge);
    }
    
    /**
     * Add an editor link format
     *
     * Template strings can use the `{file}` and `{line}` placeholders.
     * Closures templates must return a string, and accept two parameters:
     * The file and line.
     * Params:
     * string aName The name of the editor.
     * @param \Closure|string atemplate The string template or closure
     * /
    static void addEditor(string aName, IClosure|string atemplate) {
         anInstance = getInstance();
         anInstance.editors[name] = template;
    }
    
    /**
     * Choose the editor link style you want to use.
     * Params:
     * string aName The editor name.
     * /
    static void setEditor(string aName) {
         anInstance = getInstance();
        if (!isSet(anInstance.editors[name])) {
            known = join(", ", anInstance.editors.keys);
            throw new DInvalidArgumentException(
                "Unknown editor `%s`. Known editors are `%s`."
                .format(name, known
            ));
        }
         anInstance.setConfig("editor", name);
    }
    
    /**
     * Get a formatted URL for the active editor.
     * Params:
     * string afile The file to create a link for.
     * @param int line The line number to create a link for.
     * /
    static string editorUrl(string afile, int line) {
         anInstance = getInstance();
        editor =  anInstance.configuration.get("editor");
        if (!anInstance.editors.isSet(editor)) {
            throw new DInvalidArgumentException(
                "Cannot format editor URL `%s` is not a known editor."
                .format(editor));
        }
        template =  anInstance.editors[editor];
        if (isString(template)) {
            return template.replace(["{file}", "{line}"], [file, (string)line]);
        }
        return template(file, line);
    }
    
    /**
     * Recursively formats and outputs the contents of the supplied variable.
     * Params:
     * IData var The variable to dump.
     * @param int maxDepth The depth to output to. Defaults to 3.
     * /
    static void dump(IData var, int maxDepth = 3) {
        pr(exportVar(var, maxDepth));
    }
    
    /**
     * Creates an entry in the log file. The log entry will contain a stack trace from where it was called.
     * as well as export the variable using exportVar. By default, the log is written to the debug log.
     * Params:
     * IData var Variable or content to log.
     * @param string|int level Type of log to use. Defaults to 'debug'.
     * @param int maxDepth The depth to output to. Defaults to 3.
     * /
    static void log(IData var, string|int level = "debug", int maxDepth = 3) {
        /** @var string asource * /
        source = trace(["start": 1]);
        source ~= "\n";

        Log.write(
            level,
            "\n" ~ source ~ exportVarAsPlainText(var, maxDepth)
        );
    }
    
    /**
     * Get the frames from exception that are not present in parent
     * Params:
     * \Throwable exception The exception to get frames from.
     * @param ?\Throwable parent The parent exception to compare frames with.
     * /
    static array getUniqueFrames(Throwable exception, Throwable parent) {
        if (parent is null) {
            return exception.getTrace();
        }
        parentFrames = parent.getTrace();
        frames = exception.getTrace();

        parentCount = count(parentFrames) - 1;
        frameCount = count(frames) - 1;

        // Reverse loop through both traces removing frames that
        // are the same.
        for (anI = frameCount, p = parentCount;  anI >= 0 && p >= 0; p--) {
            parentTail = parentFrames[p];
            tail = frames[anI];

            // Frames without file/line are never equal to another frame.
             isEqual = (
                (
                    isSet(tail["file"]) &&
                    isSet(tail["line"]) &&
                    isSet(parentTail["file"]) &&
                    isSet(parentTail["line"])
                ) &&
                (tail["file"] == parentTail["file"]) &&
                (tail["line"] == parentTail["line"])
            );
            if (isEqual) {
                unset(frames[anI]);
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
     *   format is 'array' or 'points' the return will be an array.
     * - `args` - Should arguments for functions be shown? If true, the arguments for each method call
     *  will be displayed.
     * - `start` - The stack frame to start generating a trace from. Defaults to 0
     * Params:
     * IData[string] options Format for outputting stack trace.
     * /
    static string[] trace(IData[string] options = null) {
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
     *   format is 'array' or 'points' the return will be an array.
     * - `args` - Should arguments for functions be shown? If true, the arguments for each method call
     *  will be displayed.
     * - `start` - The stack frame to start generating a trace from. Defaults to 0
     * Params:
     * \Throwable|array backtrace Trace as array or an exception object.
     * @param IData[string] options Format for outputting stack trace.
     * @link https://book.UIM.org/5/en/development/debugging.html#generating-stack-traces
     * /
    static string[] formatTrace(Throwable|array backtrace, IData[string] options = null) {
        if (cast(Throwable)backtrace) {
            backtrace = backtrace.getTrace();
        }
        defaults = [
            "depth": 999,
            "format": "text",
            "args": BooleanData(false),
            "start": 0,
            "scope": null,
            "exclude": ["call_user_func_array", "trigger_error"],
        ];
        options = Hash.merge(defaults, options);

        count = count(backtrace) + 1;
        back = null;

        for (anI = options["start"];  anI < count &&  anI < options["depth"];  anI++) {
            frame = ["file": "[main]", "line": ""];
            if (isSet(backtrace[anI])) {
                frame = backtrace[anI] ~ ["file": "[internal]", "line": "??"];
            }
            signature = reference = frame["file"];
            if (!frame["class"].isEmpty) {
                signature = frame["class"] ~ frame["type"] ~ frame["function"];
                reference = signature ~ "(";
                if (options["args"] && isSet(frame["args"])) {
                    someArguments = null;
                    foreach (frame["args"] as arg) {
                        someArguments ~= Debugger.exportVar(arg);
                    }
                    reference ~= join(", ", someArguments);
                }
                reference ~= ")";
            }
            if (in_array(signature, options["exclude"], true)) {
                continue;
            }
            if (options["format"] == "points") {
                back ~= ["file": frame["file"], "line": frame["line"], "reference": reference];
            } else if (options["format"] == "array") {
                if (!options["args"]) {
                    unset(frame["args"]);
                }
                back ~= frame;
            } else if (options["format"] == "text") {
                somePath = trimPath(frame["file"]);
                back ~= "%s - %s, line %d".format(reference, somePath, frame["line"]);
            } else {
                debug(options);
                throw new DInvalidArgumentException(
                    "Invalid trace format of `{options["format"]}` chosen. Must be one of `array`, `points` or `text`."
                );
            }
        }
        if (options["format"] == "array" || options["format"] == "points") {
            return back;
        }
        return join("\n", back);
    }
    
    /**
     * Shortens file paths by replacing the application base path with 'APP", and the UIM core
     * path with 'CORE'.
     * /
    static string trimPath(string pathToShorten) {
        if (defined("APP") && pathToShorten.startWith(APP)) {
            return pathToShorten.replace(APP, "APP/");
        }
        if (defined("CAKE_CORE_INCLUDE_PATH") && pathToShorten.startWith(CAKE_CORE_INCLUDE_PATH)) {
            return pathToShorten.replace(CAKE_CORE_INCLUDE_PATH, "CORE");
        }
        return defined("ROOT") && pathToShorten.startWith(ROOT)
            ? pathToShorten.replace(ROOT, "ROOT")
            : pathToShorten;
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
     * are processed with highlight_string() as well, so they have basic PHP syntax highlighting
     * applied.
     * Params:
     * string afile Absolute path to a PHP file.
     * @param int line Line number to highlight.
     * @param int context Number of lines of context to extract above and below line.
     * /
    static string[] excerpt(string afile, int line, int context = 2) {
        lines = null;
        if (!file_exists(file)) {
            return null;
        }
        someData = file_get_contents(file);
        if (isEmpty(someData)) {
            return lines;
        }
        if (someData.has("\n")) {
            string[] someData = split("\n", someData);
        }
        line--;
        if (!isSet(someData[line])) {
            return lines;
        }
        for (anI = line - context;  anI < line + context + 1;  anI++) {
            if (!isSet(someData[anI])) {
                continue;
            }
            string = .replace(["\r\n", "\n"], "", _highlight(someData[anI]));
            if (anI == line) {
                lines ~= "<span class="code-highlight">" ~ string ~ "</span>";
            } else {
                lines ~= string;
            }
        }
        return lines;
    }
    
    /**
     * Wraps the highlight_string auto in case the server API does not
     * implement the auto as it is the case of the HipHop interpreter
     * Params:
     * string astr The string to convert.
     * /
    protected static string _highlight(string astr) {
        if (function_exists("hphp_log") || function_exists("hphp_gettid")) {
            return htmlentities(str);
        }
        added = false;
        if (!str.has("")) {
            added = true;
            str = " \n" ~ str;
        }
        highlight = highlight_string(str, true);
        if (added) {
            highlight = highlight.replace(
                ["&lt;?php&nbsp;<br/>", "&lt;?php&nbsp;<br />"],
                "");
        }
        return highlight;
    }
    
    /**
     * Get the configured export formatter or infer one based on the environment.
     * /
    IErrorFormatter getExportFormatter() {
         anInstance = getInstance();
         className =  anInstance.configuration.get("exportFormatter");
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
        if (!cast(IErrorFormatter)anInstance ) {
            throw new UimException(
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
     * Params:
     * IData var Variable to convert.
     * @param int maxDepth The depth to output to. Defaults to 3.
     * /
    static string exportVar(IData var, int maxDepth = 3) {
        auto context = new DebugContext(maxDepth);
        auto node = export(var, context);

        return getInstance().getExportFormatter().dump(node);
    }
    
    /**
     * Converts a variable to a plain text string.
     * Params:
     * IData var Variable to convert.
     * @param int maxDepth The depth to output to. Defaults to 3.
     * /
    static string exportVarAsPlainText(IData var, int maxDepth = 3) {
        return (new DTextFormatter()).dump(
            export(var, new DebugContext(maxDepth))
        );
    }
    
    /**
     * Convert the variable to the internal node tree.
     *
     * The node tree can be manipulated and serialized more easily
     * than many object graphs can.
     * Params:
     * IData var Variable to convert.
     * @param int maxDepth The depth to generate nodes to. Defaults to 3.
     * /
    static IErrorNode exportVarAsNodes(IData var, int maxDepth = 3) {
        return export(var, new DebugContext(maxDepth));
    }
    
    /**
     * Protected export auto used to keep track of indentation and recursion.
     * Params:
     * IData var The variable to dump.
     * @param \UIM\Error\Debug\DebugContext context Dump context
     * /
    protected static IErrorNode export(IData var, DebugContext context) {
        string type = getType(var);

        if (type.startWith("resource ")) {
            return new DScalarNode(type, var);
        }
        return match (type) {
            "float", "string", "null": new DScalarNode(type, var),
            "bool": new DScalarNode("bool", var),
            "int": new DScalarNode("int", var),
            "array": exportArray(var, context.withAddedDepth()),
            "unknown": new DSpecialNode("(unknown)"),
            default: exportObject(var, context.withAddedDepth()),
        };
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
     * array var The array to export.
     * @param \UIM\Error\Debug\DebugContext context The current dump context.
     * @return \UIM\Error\Debug\ArrayNode Exported array.
     * /
    protected static ArrayNode exportArray(array var, DebugContext context) {
        someItems = null;

        remaining = context.remainingDepth();
        if (remaining >= 0) {
            outputMask = outputMask();
            foreach (aKey: val; var) {
                if (array_key_exists(aKey, outputMask)) {
                    node = new DScalarNode("string", outputMask[aKey]);
                } else if (val != var) {
                    // Dump all the items without increasing depth.
                    node = export(val, context);
                } else {
                    // Likely recursion, so we increase depth.
                    node = export(val, context.withAddedDepth());
                }
                 someItems ~= new ArrayItemNode(export(aKey, context), node);
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
     * /
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
                    foreach ((array)var.__debugInfo() as aKey: val) {
                        node.addProperty(new DPropertyNode("'{aKey}'", null, export(val, context)));
                    }
                    return node;
                } catch (Exception  anException) {
                    return new DSpecialNode("(unable to export object: { anException.getMessage()})");
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
                        new DPropertyNode((string)kv.key, "public", export(kv.value, context.withAddedDepth()))
                    );
            });
            ref = new DReflectionObject(var);

            filters = [
                ReflectionProperty.IS_PROTECTED: "protected",
                ReflectionProperty.IS_PRIVATE: "private",
            ];
            foreach (filter: visibility; filters) {
                reflectionProperties = ref.getProperties(filter);
                foreach (reflectionProperty; reflectionProperties) {
                    reflectionProperty.setAccessible(true);

                    if (
                        method_exists(reflectionProperty, "isInitialized") &&
                        !reflectionProperty.isInitialized(var)
                    ) {
                        aValue = new DSpecialNode("[uninitialized]");
                    } else {
                        aValue = export(reflectionProperty.getValue(var), context.withAddedDepth());
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
    
    /**
     * Get the type of the given variable. Will return the class name
     * for objects.
     * Params:
     * IData var The variable to get the type of.
     * /
    static string getType(IData variableToCheck) {
        string variableType = get_debug_type(variableToCheck);

        switch(variableType) {
            case "double":
                return "float";
            case "unknown type":
                return "unknown";
            default:    
                return variableType;
        }
    }
    
    /**
     * Prints out debug information about given variable.
     * Params:
     * IData var Variable to show debug information for.
     * @param array location If contains keys "file" and "line" their values will
     *   be used to show location info.
     * @param bool|null showHtml If set to true, the method prints the debug
     *   data encoded as HTML. If false, plain text formatting will be used.
     *   If null, the format will be chosen based on the configured exportFormatter, or
     *   environment conditions.
     * /
    static void printVar(IData var, array location = [], ?bool showHtml = null) {
        location ~= ["file": null, "line": null];
        if (location["file"]) {
            location["file"] = trimPath((string)location["file"]);
        }
        debugger = getInstance();
        restore = null;
        if (showHtml !isNull) {
            restore = debugger.configuration.get("exportFormatter");
            debugger.setConfig("exportFormatter", showHtml ? HtmlFormatter.classname : TextFormatter.classname);
        }
        contents = exportVar(var, 25);
        formatter = debugger.getExportFormatter();

        if (restore) {
            debugger.setConfig("exportFormatter", restore);
        }
        writeln(formatter.formatWrapper(contents, location);
    }
    
    /**
     * Format an exception message to be HTML formatted.
     *
     * Does the following formatting operations:
     *
     * - HTML escape the message.
     * - Convert `bool` into `<code>bool</code>`
     * - Convert newlines into `<br>`
     * Params:
     * string messageToFormat The string message to format.
     * /
    static string formatHtmlMessage(string messageToFormat) {
        string message = htmlAttribEscape(messageToFormat);
        message = (string)preg_replace("/`([^`]+)`/", "<code>0</code>", message);

        return nl2br(message);
    }
    
    // Verifies that the application`s salt and cipher seed value has been changed from the default value.
    static void checkSecurityKeys() {
        salt = Security.getSalt();
        if (salt == "__SALT__" || salt.length< 32) {
            trigger_error(
                "Please change the value of `Security.salt` in `ROOT/config/app_local.d` " ~
                "to a random value of at least 32 characters.",
                E_USER_NOTICE
            );
        }
    } */
}
