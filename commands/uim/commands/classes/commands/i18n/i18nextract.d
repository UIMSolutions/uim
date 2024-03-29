module uim.commands.classes.commands.i18n.i18nextract;

import uim.commands;

@safe:

// Language string extractor
class DI18nExtractCommand : DCommand {
  mixin(CommandThis!("I18nExtract"));

  	override bool initialize(IData[string] initData = null) {
		if (!super.initialize(initData)) { return false; }
		
		return true;
	}
 
    static string defaultName() {
        return "i18n-extract";
    }
    
    // Paths to use when looking for strings
    protected string[] _paths = [];

    // Files from where to extract
    protected string[] _files = [];

    // Merge all domain strings into the default.pot file
    protected bool _merge = false;

    // Current file being processed
    protected string _file = "";

    // Contains all content waiting to be written
    // TODO protected IData _storage = [];

    /* 
    // Extracted tokens
    protected array _tokens = [];

    //  Extracted strings indexed by domain.
    protected IData[string] _translations = [];

    // Destination path
    protected string _output = "";

    // An array of directories to exclude.
    protected string[] _exclude = [];

    // Holds whether this call should extract the UIM Lib messages
    protected bool _extractCore = false;

    // Displays marker error(s) if true
    protected bool _markerError = false;

    // Count number of marker errors found
    protected size_t _countMarkerError = 0;
/* 
    // Method to interact with the user and get path selections.
    protected void _getPaths(IConsoleIo aConsoleIo) {
        /** @psalm-suppress UndefinedConstant * /
        defaultPaths = chain(
            [APP],
            App.path("templates"),
            ["D"] // This is required to break the loop below
        );
        int defaultPathIndex = 0;
        while (true) {
            currentPaths = count(_paths) > 0 ? _paths : ["None"];
            string message = 
                "Current paths: %s\nWhat is the path you would like to extract?\n[Q]uit [D]one"
                .format( currentPaths.join(", "));

            string response = aConsoleIo.ask(message, defaultPaths[defaultPathIndex] ?? "D");
            if (strtoupper(response) == "Q") {
                 aConsoleIo.writeErrorMessages("Extract Aborted");
                this.abort();
            }
            if (strtoupper(response) == "D" && count(_paths)) {
                 aConsoleIo.writeln();

                return;
            }
            if (strtoupper(response) == "D") {
                 aConsoleIo.warning("No directories selected. Please choose a directory.");
            } else if (isDir(response)) {
               _paths ~= response;
                defaultPathIndex++;
            } else {
                 aConsoleIo.writeErrorMessages("The directory path you supplied was not found. Please try again.");
            }
             aConsoleIo.writeln();
        }
    }

    // Execute the command
  int execute(IData[string] arguments, IConsoleIo aConsoleIo) {
        string myPlugin = "";
        if (commandArguments.getOption("exclude")) {
           _exclude = split(",", to!string(commandArguments.getOption("exclude")));
        }
        if (commandArguments.getOption("files")) {
           _files = split(",", to!string(commandArguments.getOption("files")));
        }
        if (commandArguments.getOption("paths")) {
           _paths = split(",", to!string(commandArguments.getOption("paths")));
        } else if (commandArguments.getOption("plugin")) {
            myPlugin = Inflector.camelize(to!string(commandArguments.getOption("plugin")));
           _paths = [Plugin.classPath(myPlugin), Plugin.templatePath(myPlugin)];
        } else {
           _getPaths(aConsoleIo);
        }
        string _extractCore; 
        if (commandArguments.hasOption("extract-core")) {
           _extractCore = !(to!string(commandArguments.getOption("extract-core")).toLower == "no");
        } else {
            response = aConsoleIo.askChoice(
                "Would you like to extract the messages from the UIM core?",
                ["y", "n"],
                "n"
            );
           _extractCore = response.toLowe == "y";
        }
        if (commandArguments.hasOption("exclude-plugins") && _isExtractingApp()) {
           _exclude = chain(_exclude, App.path("plugins"));
        }
        if (_extractCore) {
           _paths ~= CAKE;
        }
        if (commandArguments.hasOption("output")) {
           _output = to!string(commandArguments.getOption("output"));
        } else if (commandArguments.hasOption("plugin")) {
           _output = Plugin.path(plugin)
                ~ "resources" ~ DIRECTORY_SEPARATOR
                ~ "locales" ~ DIRECTORY_SEPARATOR;
        } else {
            message = "What is the path you would like to output?\n[Q]uit";
            localePaths = App.path("locales");
            if (! localePaths) {
                localePaths ~= ROOT ~ "resources" ~ DIRECTORY_SEPARATOR ~ "locales";
            }
            while (true) {
                response = aConsoleIo.ask(
                    message,
                    localePaths[0]
                );
                if (strtoupper(response) == "Q") {
                     aConsoleIo.writeErrorMessages("Extract Aborted");

                    return CODE_ERROR;
                }
                if (_isPathUsable(response)) {
                   _output = response ~ DIRECTORY_SEPARATOR;
                    break;
                }
                 aConsoleIo.writeErrorMessages("");
                 aConsoleIo.writeErrorMessages(
                    "<error>The directory path you supplied was " ~
                    "not found. Please try again.</error>"
                );
                 aConsoleIo.writeErrorMessages("");
            }
        }
        if (commandArguments.hasOption("merge")) {
           _merge = !(strtolower(to!string(commandArguments.getOption("merge")) == "no"));
        } else {
             aConsoleIo.writeln();
            response = aConsoleIo.askChoice(
                "Would you like to merge all domain strings into the default.pot file?",
                ["y", "n"],
                "n"
            );
           _merge = strtolower(response) == "y";
        }
       _markerError = (bool)commandArguments.getOption("marker-error");

        if (isEmpty(_files)) {
           _searchFiles();
        }
       _output = rtrim(_output, DIRECTORY_SEPARATOR) ~ DIRECTORY_SEPARATOR;
        if (!_isPathUsable(_output)) {
             aConsoleIo.writeErrorMessages("The output directory `%s` was not found or writable.".format(_output));

            return CODE_ERROR;
        }
       _extract(commandArguments,  aConsoleIo);

        return CODE_SUCCESS;
    }
    
    /**
     * Add a translation to the internal translations property
     *
     * Takes care of duplicate translations
     * Params:
     * string adomain The domain
     * @param string amsgid The message string
     * @param array details DContext and plural form if any, file and line references
     * /
    protected void _addTranslation(string adomain, string amsgid, array details = []) {
        context = details.get("msgctxt", "");

        if (isEmpty(_translations[ domain][ msgid][context])) {
           _translations[ domain][ msgid][context] = [
                "msgid_plural": BooleanData(false),
            ];
        }
        if (isSet(details["msgid_plural"])) {
           _translations[ domain][ msgid][context]["msgid_plural"] = details["msgid_plural"];
        }
        if (isSet(details["file"])) {
            line = details["line"] ?? 0;
           _translations[ domain][ msgid][context]["references"][details["file"]] ~= line;
        }
    }
    
    // Extract text
    protected void _extract(IData [string] arguments, IConsoleIo aConsoleIo) {
         aConsoleIo.writeln();
         aConsoleIo.writeln();
         aConsoleIo.writeln("Extracting...");
         aConsoleIo.hr();
         aConsoleIo.writeln("Paths:");
        _paths.each!(path => aConsoleIo.writeln("   " ~ path));

         aConsoleIo.writeln("Output Directory: " ~ _output);
         aConsoleIo.hr();
       _extractTokens(commandArguments,  aConsoleIo);
       _buildFiles(commandArguments);
       _writeFiles(commandArguments,  aConsoleIo);
       _paths = _files = _storage = [];
       _translations = _tokens = [];
         aConsoleIo.writeln();
        if (_countMarkerError) {
             aConsoleIo.writeErrorMessages("{_countMarkerError} marker error(s) detected.");
             aConsoleIo.writeErrorMessages(": Use the --marker-error option to display errors.");
        }
         aConsoleIo.writeln("Done.");
    }
    
    /**
     * Gets the option parser instance and configures it.
     * Params:
     * \UIM\Console\ConsoleOptionParser  aParser The parser to configure
     * /
    ConsoleOptionParser buildOptionParser(ConsoleOptionParser  aParser) {
         aParser.description(
            "Extract i18n POT files from application source files. " ~
            "source files are parsed and string literal format strings " ~
            "provided to the <info>__</info> family of functions are extracted."
        );
        aParser.addOption("app", [
            "help": StringData("Directory where your application is located."),
        ]);
        aParser.addOption("paths", [
            "help": StringData("2'Comma separated list of paths that are searched for source files."),
        ]);
        aParser.addOption("merge", [
            "help": StringData("Merge all domain strings into a single default.po file."),
            "default": StringData("no"),
            "choices": ["yes", "no"],
        ]);
        aParser.addOption("output", [
            "help": StringData("Full path to output directory.")
        ]);
        aParser.addOption("files", [
            "help": StringData("Comma separated list of files to parse.")
        ]);
        aParser.addOption("exclude-plugins", [
            "boolean": BooleanData(true),
            "default": BooleanData(true),
            "help": StringData("Ignores all files in plugins if this command is run inside from the same app directory."),
        ]);
        aParser.addOption("plugin", [
            "help": StringData("Extracts tokens only from the plugin specified and " ~ 
                "puts the result in the plugin\`s `locales` directory."),
            "short": StringData("p"),
        ]);
        aParser.addOption("exclude", [
            "help": StringData("Comma separated list of directories to exclude." ~
                " Any path containing a path segment with the provided values will be skipped. E.g. test,vendors")
        ]);
        aParser.addOption("overwrite", [
            "boolean": BooleanData(true),
            "default": BooleanData(false),
            "help": StringData("Always overwrite existing .pot files.")
        ]);
        aParser.addOption("extract-core", [
            "help": "Extract messages from the UIM core libraries.",
            "choices": ["yes", "no"],
        ]);
        aParser.addOption("no-location", [
            "boolean": BooleanData(true),
            "default": BooleanData(false),
            "help": StringData("Do not write file locations for each extracted message.",
        ]);
        aParser.addOption("marker-error", [
            "boolean": BooleanData(true),
            "default": BooleanData(false),
            "help": StringData("Do not display marker error.",
        ]);

        return aParser;
    }
    
    /**
     * Extract tokens out of all files to be processed
     * Params:
     * \UIM\Console\IData [string] arguments The io instance
     * @param \UIM\Console\IConsoleIo aConsoleIo The io instance
     * /
    protected void _extractTokens(IData [string] arguments, IConsoleIo aConsoleIo) {
        progress = aConsoleIo.helper("progress");
        assert(cast(ProgressHelper)progress);
        progress.initialize(["total": count(_files)]);
         isVerbose = commandArguments.getOption("verbose");

        functions = [
            "__": ["singular"],
            "__n": ["singular", "plural"],
            "__d": ["domain", "singular"],
            "__dn": ["domain", "singular", "plural"],
            "__x": ["context", "singular"],
            "__xn": ["context", "singular", "plural"],
            "__dx": ["domain", "context", "singular"],
            "__dxn": ["domain", "context", "singular", "plural"],
        ];
         somePattern = "/(" ~ functions.keys.join("|") ~ ")\s*\(/";

        foreach (file; _files) {
            auto _file = file;
            if (isVerbose) {
                 aConsoleIo.verbose("Processing %s...".format(file));
            }
            auto code = to!string(file_get_contents(file));

            if (preg_match(somePattern, code) == 1) {
                auto allTokens = token_get_all(code);

                auto _tokens = 
                    allTokens
                        .filter!(token => !token.isArray || (token[0] != T_WHITESPACE && token[0] != T_INLINE_HTML))
                        .map!(token => token).array;

                }
                unset(allTokens);

                foreach (functionName: map; functions) {
                   _parse(aConsoleIo, functionName, map);
                }
            }
            if (!isVerbose) {
                progress.increment(1);
                progress.draw();
            }
        }
    }
    
    /**
     * Parse tokens
     * Params:
     * \UIM\Console\IConsoleIo aConsoleIo The io instance
     * @param string afunctionName auto name that indicates translatable string (e.g: '__")
     * @param array map Array containing what variables it will find (e.g: domain, singular, plural)
     * /
    protected void _parse(IConsoleIo aConsoleIo, string afunctionName, array map) {
        count = 0;
        tokenCount = count(_tokens);

        while (tokenCount - count > 1) {
            countToken = _tokens[count];
            firstParenthesis = _tokens[count + 1];
            if (!isArray(countToken)) {
                count++;
                continue;
            }
            [type, string, line] = countToken;
            if ((type == T_STRING) && (string == functionName) && (firstParenthesis == "(")) {
                position = count;
                depth = 0;

                while (! depth) {
                    if (_tokens[position] == "(") {
                        depth++;
                    } else if (_tokens[position] == ")") {
                        depth--;
                    }
                    position++;
                }
                mapCount = count(map);
                strings = _getStrings(position, mapCount);

                if (mapCount == count(strings)) {
                    string singular = "";
                    vars = array_combine(map, strings);
                    extract( vars);
                    domain = domain.ifEmpty("default");
                    details = [
                        "file": _file,
                        "line": line,
                    ];
                    details["file"] = "." ~ details["file"].replace(ROOT, "");
                    if (isSet(plural)) {
                        details["msgid_plural"] = plural;
                    }
                    if (isSet(context)) {
                        details["msgctxt"] = context;
                    }
                   _addTranslation( domain, singular, details);
                } else {
                   _markerError(aConsoleIo, _file, line, functionName, count);
                }
            }
            count++;
        }
    }
    
    /**
     * Build the translate template file contents out of obtained strings
     * Params:
     * \UIM\Console\IData [string] arguments Console arguments
     * /
    protected void _buildFiles(IData [string] arguments) {
        somePaths = _paths;
        /** @psalm-suppress UndefinedConstant  /
        somePaths ~= realpath(APP) ~ DIRECTORY_SEPARATOR;

        usort(somePaths, auto (string aa, string ab) {
            return a.length - b.length;
        });

        foreach ( domain: translations; _translations) {
            foreach ( msgid: contexts; translations) {
                contexts.byKeyValue
                    .each!((contextDetails) {
                    auto plural = contextDetails.value["msgid_plural"];
                    auto files =  contextDetails.value["references"];
                    
                    string aHeader = "";
                    if (!commandArguments.getOption("no-location")) {
                        auto occurrences = [];
                        foreach (file: lines; files) {
                            array_unique( lines)
                                .each!(line => occurrences ~= file ~ ":" ~ line);
                        }
                        occurrences = join("\n#: ", occurrences);

                        aHeader = "#: " ~ 
                            occurrences.replace(DIRECTORY_SEPARATOR, "/") ~ 
                            "\n";
                    }
                    
                    string sentence = "";
                    if (!context.isEmpty) {
                        sentence ~= "msgctxt \"{context}\"\n";
                    }

                    sentence ~= plural == false 
                        ? "msgid \"{ msgid}\"\n" ~
                        "msgstr \"\"\n\n"
                        : "msgid \"{ msgid}\"\n" ~ 
                        "msgid_plural \"{plural}\"\n"~
                        "msgstr[0] \"\"\n" ~
                        "msgstr[1] \"\"\n\n";

                    domain != "default" && _merge 
                        ? _store("default",  aHeader, sentence)
                        : _store( domain,  aHeader, sentence);
                }
            }
        });
    }
    
    /**
     * Prepare a file to be stored
     * Params:
     * string adomain The domain
     * @param string aheader The header content.
     * @param string asentence The sentence to store.
     *  /
    protected void _store(string adomain, string aheader, string asentence) {
       _storage[ domain] ??= [];

        if (!isSet(_storage[ domain][sentence])) {
           _storage[ domain][sentence] =  aHeader;
        } else {
           _storage[ domain][sentence] ~=  aHeader;
        }
    }
    
    /**
     * Write the files that need to be stored
     * Params:
     * \UIM\Console\IData [string] arguments The command arguments.
     * @param \UIM\Console\IConsoleIo aConsoleIo The console io
     * /
    protected void _writeFiles(IData [string] arguments, IConsoleIo aConsoleIo) {
         aConsoleIo.writeln();
        bool overwriteAll = false;
        if (commandArguments.getOption("overwrite")) {
            overwriteAll = true;
        }
        foreach (_storage as domain: sentences) {
            auto outputHeader = _writeHeader( domain);
             aHeaderLength = outputHeader.length;
            sentences.byKeyValue
                .ech!(sentenceHeader => outputHeader ~=  sentenceHeader.value ~ sentenceHeader.key);
            filename = domain.replace("/", "_") ~ ".pot";
            outputPath = _output ~ filename;

            if (this.checkUnchanged( outputPath,  aHeaderLength, outputHeader) == true) {
                 aConsoleIo.writeln(filename ~ " is unchanged. Skipping.");
                continue;
            }
            
            string response = "";
            while (overwriteAll == false && file_exists( outputPath) && strtoupper(response) != "Y") {
                 aConsoleIo.writeln();
                response = aConsoleIo.askChoice(
                    "Error: %s already exists in this location. Overwrite? [Y]es, [N]o, [A]ll".format(filename),
                    ["y", "n", "a"],
                    'y'
                );
                if (strtoupper(response) == "N") {
                    response = "";
                    while (!response) {
                        response = aConsoleIo.ask("What would you like to name this file?", "new_" ~ filename);
                        filename = response;
                    }
                } else if (strtoupper(response) == "A") {
                    overwriteAll = true;
                }
            }
            fs = new DFilesystem();
            fs.dumpFile(_output ~ filename, outputHeader);
        }
    }
    
    /**
     * Build the translation template header
     * Params:
     * string adomain Domain
     * /
    protected string _writeHeader(string adomain) {
        projectIdVersion = domain == "cake' ? "UIM " ~ Configure.currentVersion(): 'PROJECT VERSION";

        string result = "# LANGUAGE translation of UIM Application\n";
        result ~= "# Copyright YEAR NAME <EMAIL@ADDRESS>\n";
        result ~= "#\n";
        result ~= "#, fuzzy\n";
        result ~= "msgid \"\"\n";
        result ~= "msgstr \"\"\n";
        result ~= "Project-Id-Version: " ~ projectIdVersion ~ "\\n\"\n";
        result ~= "POT-Creation-Date: " ~ date("Y-m-d H:iO") ~ "\\n\"\n";
        result ~= "\"PO-Revision-Date: YYYY-mm-DD HH:MM+ZZZZ\\n\"\n";
        result ~= "\"Last-Translator: NAME <EMAIL@ADDRESS>\\n\"\n";
        result ~= "\"Language-Team: LANGUAGE <EMAIL@ADDRESS>\\n\"\n";
        result ~= "\"MIME-Version: 1.0\\n\"\n";
        result ~= "\"Content-Type: text/plain; charset=utf-8\\n\"\n";
        result ~= "\"Content-Transfer-Encoding: 8bit\\n\"\n";
        result ~= "\"Plural-Forms: nplurals=INTEGER; plural=EXPRESSION;\\n\"\n\n";

        return result;
    }
    
    /**
     * Check whether the old and new output are the same, thus unchanged
     *
     * Compares the sha1 hashes of the old and new file without header.
     * Params:
     * string aoldFile The existing file.
     * @param int  aHeaderLength The length of the file header in bytes.
     * @param string anewFileContent The content of the new file.
     * /
    protected bool checkUnchanged(string aoldFile, int  aHeaderLength, string anewFileContent) {
        if (!file_exists( oldFile)) {
            return false;
        }
        oldFileContent = file_get_contents( oldFile);
        if ( oldFileContent == false) {
            throw new UimException("Cannot read file content of `%s`".format( oldFile));
        }
        oldChecksum = sha1(substr( oldFileContent,  aHeaderLength));
        newChecksum = sha1(substr(newFileContent,  aHeaderLength));

        return oldChecksum == newChecksum;
    }
    
    /**
     * Get the strings from the position forward
     * Params:
     * int position Actual position on tokens array
     * @param int target Number of strings to extract
     * /
    protected string[] _getStrings(int &position, int target) {
        string[] strings = [];
        count = 0;
        while (
            count < target
            && (_tokens[position] == ","
                || _tokens[position][0] == T_CONSTANT_ENCAPSED_STRING
                || _tokens[position][0] == T_LNUMBER
            )
        ) {
            count = count(strings);
            if (_tokens[position][0] == T_CONSTANT_ENCAPSED_STRING && _tokens[position + 1] == ".") {
                string = "";
                while (
                   _tokens[position][0] == T_CONSTANT_ENCAPSED_STRING
                    || _tokens[position] == "."
                ) {
                    if (_tokens[position][0] == T_CONSTANT_ENCAPSED_STRING) {
                        string ~= _formatString(_tokens[position][1]);
                    }
                    position++;
                }
                strings ~= string;
            } else if (_tokens[position][0] == T_CONSTANT_ENCAPSED_STRING) {
                strings ~= _formatString(_tokens[position][1]);
            } else if (_tokens[position][0] == T_LNUMBER) {
                strings ~= _tokens[position][1];
            }
            position++;
        }
        return strings;
    }
    
    // Format a string to be added as a translatable string
    protected string _formatString(string textToFormat) {
        string quote = substr(textToFormat, 0, 1);
        textToFormat = substr(textToFormat, 1, -1);
        
        textToFormat = quote == "\""
            ? stripcslashes(textToFormat) 
            : strtr(textToFormat, ["\\'": "'", "\\\\": "\\"]);
        
        textToFormat = textToFormat.replace("\r\n", "\n");

        return addcslashes(string, "\0..\37\\\"");
    }
    
    /**
     * Indicate an invalid marker on a processed file
     * Params:
     * \UIM\Console\IConsoleIo aConsoleIo The io instance.
     * @param string afile File where invalid marker resides
     * @param string amarker Marker found
     * @param int count Count
     * /
    protected void _markerError(IConsoleIo aConsoleIo, string afile, int lineNumber, string amarker, int count) {
        if (!_file.has(CAKE_CORE_INCLUDE_PATH)) {
           _countMarkerError++;
        }
        if (!_markerError) {
            return;
        }
         aConsoleIo.writeErrorMessages("Invalid marker content in %s:%s\n* %s(".format(file, lineNumber, marker));
        count += 2;
        tokenCount = _tokens.length;
        parenthesis = 1;

        while ((tokenCount - count > 0) && parenthesis) {
            if (_tokens[count].isArray) {
                 aConsoleIo.writeErrorMessages(_tokens[count][1], 0);
            } else {
                 aConsoleIo.writeErrorMessages(_tokens[count], 0);
                if (_tokens[count] == "(") {
                    parenthesis++;
                }
                if (_tokens[count] == ")") {
                    parenthesis--;
                }
            }
            count++;
        }
         aConsoleIo.writeErrorMessages("\n");
    }
    
    // Search files that may contain translatable strings
    protected void _searchFiles() {
         somePattern = false;
        if (!empty(_exclude)) {
            exclude = [];
            foreach (anException; _exclude) {
                if (DIRECTORY_SEPARATOR != "\\" &&  anException[0] != DIRECTORY_SEPARATOR) {
                     anException = DIRECTORY_SEPARATOR ~  anException;
                }
                exclude ~= preg_quote(anException, "/");
            }
             somePattern = "/" ~ join("|", exclude) ~ "/";
        }
        _paths.each!((path) {
            somePath = realpath(path);
            if (somePath == false) {
                continue;
            }
            somePath ~= DIRECTORY_SEPARATOR;
            fs = new DFilesystem();
            files = fs.findRecursive(somePath, "/\.d$/");
            files = iterator_to_array(files).keys;
            sort(files);
            if (somePattern) {
                files = preg_grep(somePattern, files, PREG_GREP_INVERT) ?: [];
                files = files.values;
            }
           _files = chain(_files, files);
        });
       _files = array_unique(_files);
    }
    
    /**
     * Returns whether this execution is meant to extract string only from directories in folder represented by the
     * APP constant, i.e. this task is extracting strings from same application.
     * /
    protected bool _isExtractingApp() {
        /** @psalm-suppress UndefinedConstant * /
        return _paths == [APP];
    }
    
    /**
     * Checks whether a given path is usable for writing.
     * Params:
     * string aPath Path to folder
     * /
    protected bool _isPathUsable(string aPath) {
        if (!isDir(somePath)) {
            mkdir(somePath, 0770, true);
        }
        return isDir(somePath) && is_writable(somePath);
    } */
}
