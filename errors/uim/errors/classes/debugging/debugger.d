
/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.errors.classes.debugging.debugger;

import uim.errors;

@safe:
/**
 * Provide custom logging and error handling.
 * Debugger : D"s default error handling and gives simpler to use more powerful interfaces.
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
            "editor": Json("Dstorm")
        ]);

        return true;
    }

    mixin(TProperty!("string", "name"));

    // The current output format.
    protected string _outputFormat = "js";

    /**
     * Templates used when generating trace or error strings. Can be global or indexed by the format
     * value used in _outputFormat.
     */
    protected Json[string][string] _stringContents = [
        "log": [
            // These templates are not actually used, as Debugger.log() is called instead.
            "trace": "{:reference} - {:path}, line {:line}",
            "error": "{:error} ({:code}): {:description} in [{:file}, line {:line}]",
        ],
        "js": [
            "error": "",
            "info": "",
            "trace": "<pre class=\"stack-trace\">{:trace}</pre>",
            "code": "",
            "context": "",
            "links": [],
            "escapeContext": true.toJson,
        ],
        "html": [
            "trace": "<pre class=\"uim-error trace\"><b>Trace</b> <p>{:trace}</p></pre>",
            "context": "<pre class=\"uim-error context\"><b>Context</b> <p>{:context}</p></pre>",
            "escapeContext": true,
        ],
        "txt": [
            "error": "{:error}: {:code} . {:description} on line {:line} of {:path}\n{:info}",
            "code": "",
            "info": "",
        ],
        "base": [
            "traceLine": "{:reference} - {:path}, line {:line}",
            "trace": "Trace:\n{:trace}\n",
            "context": "Context:\n{:context}\n",
        ],
    ];

    /**
     * Mapping for error renderers.
     *
     * Error renderers are replacing output formatting with
     * an object based system. Having Debugger handle and render errors
     * will be deprecated and the new DErrorTrap system should be used instead.
     */
    protected STRINGAA renderers = [
        "txt": TextErrorRenderer.classname,
        // The html alias currently uses no JS and will be deprecated.
        "js": HtmlErrorRenderer.classname,
    ];

    // A map of editors to their link templates.
    protected STRINGAA editors = [
        "atom": "atom://core/open/file?filename={file}&line={line}",
        "emacs": "emacs://open?url=file://{file}&line={line}",
        "macvim": "mvim://open/?url=file://{file}&line={line}",
        "Dstorm": "Dstorm://open?file={file}&line={line}",
        "sublime": "subl://open?url=file://{file}&line={line}",
        "textmate": "txmt://open?url=file://{file}&line={line}",
        "vscode": "vscode://file/{file}:{line}",
    ];

    // Holds current output data when outputFormat is false.
    protected Json[string] _data = null;

    this() {
        docRef = ini_get("docref_root");
        if (docRef.isEMpty && function_exists("ini_set")) {
            ini_set("docref_root", "https://secure.D.net/");
        }
        if (!defined("E_RECOVERABLE_ERROR")) {
            define("E_RECOVERABLE_ERROR", 4096);
        }

        aConfig = array_intersectinternalKey(/* (array) */Configure.read("Debugger"), _defaultConfig);
        configuration.update(aConfig);

        e = `<pre class="uim-error">`;
        e ~= `<a href="javascript:void(0);" onclick="document.getElementById(\"{:id}-trace\")`;
        e ~= `.style.display = (document.getElementById(\"{:id}-trace\").style.display == `;
        e ~= `\"none\" ? \"\" : \"none\");"><b>{:error}</b> ({:code})</a>: {:description} `;
        e ~= `[<b>{:path}</b>, line <b>{:line}</b>]`;

        e ~= `<div id="{:id}-trace" class="uim-stack-trace" style="display: none;">`;
        e ~= `{:links}{:info}</div>`;
        e ~= `</pre>`;
        _stringContents["js.error"] = e;

        t = `<div id="{:id}-trace" class="uim-stack-trace" style="display: none;">`;
        t ~= `{:context}{:code}{:trace}</div>`;
        _stringContents["js.info"] = t;

        links = null;
        link = "<a href=\"javascript:void(0);\" onclick=\"document.getElementById(\"{:id}-code\")";
        link ~= ".style.display = (document.getElementById(\"{:id}-code\").style.display == ";
        link ~= "\"none\" ? \"\" : \"none\")\">Code</a>";
        links["code"] = link;

        link = "<a href=\"javascript:void(0);\" onclick=\"document.getElementById(\"{:id}-context\")";
        link ~= ".style.display = (document.getElementById(\"{:id}-context\").style.display == ";
        link ~= "\"none\" ? \"\" : \"none\")\">Context</a>";
        links["context"] = link;

        _stringContents["js.links"] = links;

        _stringContents["js.context"] = "<pre id=\"{:id}-context\" class=\"uim-context uim-debug\" ";
        _stringContents["js.context"] ~= "style=\"display: none;\">{:context}</pre>";

        _stringContents["js.code"] = "<pre id=\"{:id}-code\" class=\"uim-code-dump\" ";
        _stringContents["js.code"] ~= "style=\"display: none;\">{:code}</pre>";

        e = "<pre class=\"uim-error\"><b>{:error}</b> ({:code}) : {:description} ";
        e ~= "[<b>{:path}</b>, line <b>{:line}]</b></pre>";
        _stringContents["html.error"] = e;

        _stringContents["html.context"] = "<pre class=\"uim-context uim-debug\"><b>Context</b> ";
        _stringContents["html.context"] ~= "<p>{:context}</p></pre>";
    }

    // Returns a reference to the Debugger singleton object instance.
    static auto getInstance(string aClassName = null) {
        static instance = null;
        if (!aClassName.isEmpty) {
            if (!instance || strtolower(aClassName) != strtolower(get_class(instance[0]))) {
                instance[0] = new aClassName();
            }
        }
        if (!instance) {
            instance[0] = new Debugger();
        }

        return instance[0];
    }

    // Read or write configuration options for the Debugger instance.
    static Json configInstance(string key = null, Json valueToSet = null, bool shouldMerge = true) {
        if (key == null) {
            return getInstance().configuration.get(key);
        }

        if (key.isArray || func_num_args() >= 2) {
            return getInstance().setConfig(key, valueToSet, shouldMerge);
        }

        return getInstance().configuration.get(key);
    }

    // Reads the current output masking.
    static STRINGAA outputMask() {
        return configInstance("outputMask");
    }

    /**
     * Sets configurable masking of debugger output by property name and array key names.
     *
     * ### Example
     * Debugger.setOutputMask(["password": "[*************]");
     */
    static void setOutputMask(Json[string] keyvalues, bool shouldMerge = true) {
        configInstance("outputMask", value, shouldMerge);
    }

    /**
     * Add an editor link format
     *
     * Template strings can use the `{file}` and `{line}` placeholders.
     * Closures templates must return a string, and accept two parameters:
     * The file and line.
     */
    static void addEditor(string editorName, /* Closure */ string templateName) {
        auto instance = getInstance();
        if (!templatenName.isString && !(cast(Closure)templatenName)) {
            auto type = getTypeName(templatenName);
            throw new DRuntimeException("Invalid editor type of `{type}`. Expected string or Closure.");
        }
        instance.editors[editorName] = templatenName;
    }

    // Choose the editor link style you want to use.
    static void setEditor(string editorName) {
        auto instance = getInstance();
        if (!instance.editors.hasKey(editorName)) {
            known = instance.editors.keys.join(", ");
            throw new DRuntimeException("Unknown editor `{name}`. Known editors are {known}");
        }
        instance.configuration.set("editor", editorName);
    }

    /**
     * Get a formatted URL for the active editor.
     *
     * @param string file The file to create a link for.
     * @param int line The line number to create a link for.
     */
    static string editorUrl(string file, int line) {
        auto instance = getInstance();
        auto editor = instance.getConfig("editor");
        if (instance.editors.isNull(editor)) {
            throw new DRuntimeException("Cannot format editor URL `{editor}` is not a known editor.");
        }

        auto templateText = instance.editors[editor];
        return templateText.isString
            ? templateText.mustache(["file":file, "line": line])
            : templateText(file, line);
    }

    /**
     * Recursively formats and outputs the contents of the supplied variable.
     *
     * @param mixed var The variable to dump.
     * @param int maxDepth The depth to output to. Defaults to 3.
     */
    static void dump(var, int maxDepth = 3) {
        pr(exportVar(var, maxDepth));
    }

    /**
     * Creates an entry in the log file. The log entry will contain a stack trace from where it was called.
     * as well as export the variable using exportVar. By default, the log is written to the debug log.
     */
    static void log(Json varToLog, string logLevel = "debug", size_t maxOutputDepth = 3) {
        string source = trace(["start": 1]) ~ "\n";

        Log.write(
            logLevel,
            "\n" ~ source ~ exportVarAsPlainText(varToLog, maxOutputDepth)
       );
    }

    /**
     * Outputs a stack trace based on the supplied options.
     *
     * ### Options
     *
     * - `depth` - The number of stack frames to return. Defaults to 999
     * - `format` - The format you want the return. Defaults to the currently selected format. If
     *   format is "array" or "points" the return will be an array.
     * - `args` - Should arguments for functions be shown? If true, the arguments for each method call
     *  will be displayed.
     * - `start` - The stack frame to start generating a trace from. Defaults to 0
     */
    static auto trace(Json[string] formatOptions = null) {
        return Debugger.formatTrace(debug_backtrace(), formatOptions);
    }

    /**
     * Formats a stack trace based on the supplied options.
     *
     * ### Options
     *
     * - `depth` - The number of stack frames to return. Defaults to 999
     * - `format` - The format you want the return. Defaults to the currently selected format. If
     *   format is "array" or "points" the return will be an array.
     * - `args` - Should arguments for functions be shown? If true, the arguments for each method call
     *  will be displayed.
     * - `start` - The stack frame to start generating a trace from. Defaults to 0
     *
     * @param \Throwable|array backtrace Trace as array or an exception object.
     * @param Json[string] options Format for outputting stack trace.
     * @return array|string Formatted stack trace.
     */
    static function formatTrace(backtrace, Json[string] optionData = null) {
        if (cast(Throwable)backtrace ) {
            backtrace = backtrace.getTrace();
        }
        auto self = Debugger.getInstance();
        auto defaults = [
            "depth": 999,
            "format": _outputFormat,
            "args": false,
            "start": 0,
            "scope": null,
            "exclude": ["call_user_func_array", "trigger_error"],
        ];
        auto options = Hash.merge(defaults, options);

        auto count = count(backtrace);
        auto back = null;

        _trace = [
            "line": "??".toJson,
            "file": "[internal]".toJson,
            "class": Json(null),
            "function": "[main]".toJson,
        ];

        for (i = options["start"]; i < count && i < options["depth"]; i++) {
            trace = backtrace[i] + ["file": "[internal]", "line": "??"];
            string signature = "[main]";
            string reference = "[main]";

            if (isset(backtrace[i + 1])) {
                next = backtrace[i + 1] + _trace;
                signature = reference = next["function"];

                if (!next.isEmpty("class")) {
                    string signature = next.getString("class") ~ "." ~ next.getString("class")"function");
                    reference = signature ~ "(";
                    if (options.isNull("args") && next.hasKey("args")) {
                        auto args = next["args"].map!(arg => Debugger.exportVar(arg)).array;
                        reference ~= args.join(", ");
                    }
                    reference ~= ")";
                }
            }
            if (hasAllValues(signature, options["exclude"], true)) {
                continue;
            }

            auto formatValue = options.getString("format");
            if (formatValue == "points") {
                back ~= ["file": trace["file"], "line": trace["line"], "reference": reference];
            } elseif (formatValue == "array") {
                if (!options.hasKey("args")) {
                    trace.remove("args");
                }
                back ~= trace;
            } else {
                formatValue = options.getString("format");
                tpl = _stringContents.hasKey(formatValue ~ ".traceLine")
                    ? _stringContents[formatValue~".traceLine"];
                    : _stringContents["base.traceLine"];
                }
                trace["path"] = trimPath(trace["file"]);
                trace["reference"] = reference;
                remove(trace["object"], trace["args"]);
                back ~= Text.insert(tpl, trace, ["before": "{:", "after": "}"]);
            }
        }

        return ["array", "points"].has(options.getString("format"))
            ? back 
            : back.join("\n");
    }

    /**
     * Shortens file paths by replacing the application base path with "APP", and the UIM core
     * path with "CORE".
     */
    static string trimPath(string pathToShorten) {
        if (defined("APP") && indexOf(path, APP) == 0) {
            return replace(APP, "APP/", path);
        }
        if (defined("UIM_CORE_INCLUDE_PATH") && indexOf(path, UIM_CORE_INCLUDE_PATH) == 0) {
            return replace(uim_CORE_INCLUDE_PATH, "CORE", path);
        }
        if (defined("ROOT") && indexOf(path, ROOT) == 0) {
            return replace(ROOT, "ROOT", path);
        }

        return path;
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
     *
     * @param string file Absolute path to a D file.
     * @param int line Line number to highlight.
     * @param int context Number of lines of context to extract above and below line.
     */
    static string[] excerpt(string file, int lineNumber, int numberLinesContext = 2) {
        auto lines = null;
        if (!fileExists(file)) {
            return [];
        }
        auto data = file_get_contents(file);
        if (data.isEmpty) {
            return lines;
        }

        if (indexOf(data, "\n") == true) {
            data = explode("\n", data);
        }
        auto lineNumber--;
        if (data.isNull(lineNumber)) {
            return lines;
        }
        for (i = lineNumber - numberLinesContext; i < lineNumber + numberLinesContext + 1; i++) {
            if (data.isNull(i)) {
                continue;
            }
            string text = replace(["\r\n", "\n"], "", _highlight(data[i]));
            lines ~= i == lineNumber 
                ? "<span class="code-highlight">" ~ text ~ "</span>"
                : text;
        }

        return lines;
    }

    /**
     * Wraps the highlight_string function in case the server API does not
     * implement the function as it is the case of the HipHop interpreter
     *
     * @param string str The string to convert.
     */
    protected static string _highlight(string stringToConvert) {
        if (function_exists("hD_log") || function_exists("hD_gettid")) {
            return htmlentities(stringToConvert);
        }
        added = false;
        if (indexOf(str, "<?D") == false) {
            added = true;
            stringToConvert = "<?D \n" ~ stringToConvert;
        }
        highlight = highlight_string(stringToConvert, true);
        if (added) {
            highlight = replace(
                ["&lt;?D&nbsp;<br/>", "&lt;?D&nbsp;<br />"],
                "",
                highlight
           );
        }

        return highlight;
    }

    /**
     * Get the configured export formatter or infer one based on the environment.
     *
     * @return uim.errors.debugs.IErrorFormatter
     * @unstable This method is not stable and may change in the future.
     */
    IErrorFormatter getExportFormatter() {
        auto instance = getInstance();
        auto aClassName = instance.getConfig("exportFormatter");
        if (!aClassName) {
            if (ConsoleFormatter.environmentMatches()) {
                aClassName = ConsoleFormatter.class;
            } elseif (HtmlFormatter.environmentMatches()) {
                aClassName = HtmlFormatter.class;
            } else {
                aClassName = TextFormatter.class;
            }
        }
        auto instance = new aClassName();
        if (!cast(IErrorFormatter)instance) {
            throw new DRuntimeException(
                "The `{aClassName}` formatter does not implement " ~ IErrorFormatter.class
           );
        }
        return instance;
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
     *
     * @param mixed var Variable to convert.
     * @param int maxDepth The depth to output to. Defaults to 3.
     */
    static string exportVar(Json var, int maxDepth = 3) {
        auto context = new DebugContext(maxDepth);
        auto node = export_(var, context);

        return getInstance().getExportFormatter().dump(node);
    }

    /**
     * Converts a variable to a plain text string.
     *
     * @param mixed var Variable to convert.
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
     *
     * @param int maxDepth The depth to generate nodes to. Defaults to 3.
     */
    static IErrorNode exportVarAsNodes(Json varToConvert, int maxDepth = 3) {
        return export_(varToConvert, new DebugContext(maxDepth));
    }

    /**
     * Protected export function used to keep track of indentation and recursion.
     * @param uim.errors.debugs.DebugContext context Dump context
     */
    protected static IErrorNode export_(varToDump, DebugContext dumpContext) {
        type = getType(varToDump);
        switch (type) {
            case "float": 
            case "string": 
            case "resource": 
            case "resource (closed)": 
            case "null": 
                return new DScalarNode(type, varToDump);
            case "boolean": 
                return new DScalarNode("bool", varToDump);
            case "integer": 
                return new DScalarNode("int", varToDump);
            case "array": 
                return exportArray(varToDump, context.withAddedDepth());
            case "unknown": 
                return new DSpecialNode("(unknown)");
            default:
                return exportObject(varToDump, context.withAddedDepth());
        }
    }

    /**
     * Export an array type object. Filters out keys used in datasource configuration.
     *
     * The following keys are replaced with ***"s
     *
     * - password
     * - login
     * - host
     * - database
     * - port
     * - prefix
     * - schema
     *
     * @param Json[string] var The array to export.
     * @param uim.errors.debugs.DebugContext context The current dump context.
     * @return uim.errors.debugs.ArrayNode Exported array.
     */
    protected static function exportArray(Json[string] var, DebugContext context): ArrayNode
    {
        items = null;

        remaining = context.remainingDepth();
        if (remaining >= 0) {
            outputMask = outputMask();
            foreach (var as key: val) {
                if (array_key_exists(key, outputMask)) {
                    node = new DScalarNode("string", outputMask[key]);
                } elseif (val != var) {
                    // Dump all the items without increasing depth.
                    node = export_(val, context);
                } else {
                    // Likely recursion, so we increase depth.
                    node = export_(val, context.withAddedDepth());
                }
                items ~= new DArrayItemErrorNode(export_(key, context), node);
            }
        } else {
            items ~= new DArrayItemErrorNode(
                new DScalarNode("string", ""),
                new DSpecialNode("[maximum depth reached]")
           );
        }

        return new ArrayNode(items);
    }

    /**
     * Handles object to node conversion.
     *
     * @param object var Object to convert.
     * @param uim.errors.debugs.DebugContext context The dump context.
     * @return uim.errors.debugs.IErrorNode
     */
    protected static function exportObject(object var, DebugContext context): IErrorNode
    {
        isRef = context.hasReference(var);
        refNum = context.getReferenceId(var);

        aClassNameName = get_class(var);
        if (isRef) {
            return new DReferenceNode(aClassNameName, refNum);
        }
        node = new DClassNode(aClassNameName, refNum);

        remaining = context.remainingDepth();
        if (remaining > 0) {
            if (method_exists(var, "__debugInfo")) {
                try {
                    foreach (/* (array) */var.__debugInfo() as key: val) {
                        node.addProperty(new DPropertyNode(""{key}"", null, export_(val, context)));
                    }

                    return node;
                } catch (Exception e) {
                    return new DSpecialNode("(unable to export object: {e.getMessage()})");
                }
            }

            outputMask = outputMask();
            objectVars = get_object_vars(var);
            foreach (objectVars as key: value) {
                if (array_key_exists(key, outputMask)) {
                    value = outputMask[key];
                }
                /** @psalm-suppress RedundantCast */
                node.addProperty(
                    new DPropertyNode((string)key, "public", export_(value, context.withAddedDepth()))
               );
            }

            ref = new DReflectionObject(var);

            filters = [
                ReflectionProperty.IS_PROTECTED: "protected",
                ReflectionProperty.IS_PRIVATE: "private",
            ];
            foreach (filters as filter: visibility) {
                reflectionProperties = ref.getProperties(filter);
                foreach (reflectionProperties as reflectionProperty) {
                    reflectionProperty.setAccessible(true);

                    value = method_exists(reflectionProperty, "isInitialized") && !reflectionProperty.isInitialized(var) 
                        ? new DSpecialNode("[uninitialized]")
                        : export_(reflectionProperty.getValue(var), context.withAddedDepth());

                    node.addProperty(
                        new DPropertyNode(
                            reflectionProperty.getName(),
                            visibility,
                            value
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
     */
    static string getType(Json var) {
        type = getTypeName(var);

        if (type == "NULL") {
            return "null";
        }

        if (type == "double") {
            return "float";
        }

        if (type == "unknown type") {
            return "unknown";
        }

        return type;
    }

    /**
     * Prints out debug information about given variable.
     *
     * @param mixed var Variable to show debug information for.
     * @param Json[string] location If contains keys "file" and "line" their values will
     *   be used to show location info.
     */
    static void printVar(Json varToShow, Json[string] location = null, bool showHtml = false) {
        auto location += ["file": null, "line": null];
        if (location["file"]) {
            location["file"] = trimPath((string)location["file"]);
        }

        auto debugger = getInstance();
        restore = null;
        if (showHtml != null) {
            restore = debugger.getConfig("exportFormatter");
            debugger.configuration.set("exportFormatter", showHtml ? HtmlFormatter.class : TextFormatter.class);
        }
        contents = exportVar(varToShow, 25);
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
     * - Convert newlines into `<br />`
     */
    static string formatHtmlMessage(string messageToFormat) {
        messageToFormat = htmlAttributeEscape(messageToFormat);
        messageToFormat = preg_replace("/`([^`]+)`/", "<code>1</code>", messageToFormat);

        return nl2br(messageToFormat);
    }

    // Verifies that the application"s salt and cipher seed value has been changed from the default value.
    static void checkSecurityKeys() {
        salt = Security.getSalt();
        if (salt == "__SALT__" || strlen(salt) < 32) {
            trigger_error(
                "Please change the value of `Security.salt` in `ROOT/config/app_local.D` " .
                "to a random value of at least 32 characters.",
                E_USER_NOTICE
           );
        }
    }
}
