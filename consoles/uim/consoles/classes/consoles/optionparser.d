module uim.consoles.classes.consoles.optionparser;

import uim.consoles;

@safe:

/**
 * Handles parsing the ARGV in the command line and provides support
 * for GetOpt compatible option definition. Provides a builder pattern implementation
 * for creating shell option parsers.
 *
 * ### Options
 *
 * Named arguments come in two forms, long and short. Long arguments are preceded
 * by two - and give a more verbose option name. i.e. `--version`. Short arguments are
 * preceded by one - and are only one character long. They usually match with a long option,
 * and provide a more terse alternative.
 *
 * ### Using Options
 *
 * Options can be defined with both long and short forms. By using ` aParser.addOption()`
 * you can define new options. The name of the option is used as its long form, and you
 * can supply an additional short form, with the `short` option. Short options should
 * only be one letter long. Using more than one letter for a short option will raise an exception.
 *
 * Calling options can be done using syntax similar to most *nix command line tools. Long options
 * cane either include an `=` or leave it out.
 *
 * `uim _command --connection default --name=something`
 *
 * Short options can be defined singly or in groups.
 *
 * `uim _command -cn`
 *
 * Short options can be combined into groups as seen above. Each letter in a group
 * will be treated as a separate option. The previous example is equivalent to:
 *
 * `uim _command -c -n`
 *
 * Short options can also accept values:
 *
 * `uim _command -c default`
 *
 * ### Positional arguments
 *
 * If no positional arguments are defined, all of them will be parsed. If you define positional
 * arguments any arguments greater than those defined will cause exceptions. Additionally you can
 * declare arguments as optional, by setting the required param to false.
 *
 * ```
 *  aParser.addArgument("model", ["required": Json(false)]);
 * ```
 *
 * ### Providing Help text
 *
 * By providing help text for your positional arguments and named arguments, the DConsoleOptionParser buildOptionParser
 * can generate a help display for you. You can view the help for shells by using the `--help` or `-h` switch.
 */
class DConsoleOptionParser {
    mixin TConfigurable;

    this() {
        initialize;
    }

    this(Json[string] initData) {
        initialize(initData);
    }

    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));

    // #region description
    // Description text - displays before options when help is generated
    mixin(TProperty!("string", "_description"));

    /* 
    // Sets the description text for shell/task.
    void description(string[] descriptionTexts...) {
        description(descriptionTexts.dup);
    }

    @property void description(string[] descriptionTexts) {
        description(descriptionTexts.join("\n"));
    }
    // #endregion description

    void addArgument(string argName, Json[string] params = null) {
        Json[string] defaultOptions = [
            "name": StringData(argName),
            "help": Json(""),
            "index": LongData(count(_args)),
            "required": Json(false),
            "choices": Json.emptyArray,
        ];

        auto newParams = params.merge(defaultOptions);
        auto anIndex = newParams["index"];
        newParams.remove("index");
        auto inputArgument = new DConsoleInputArgument(newParams);

        _args.each!((a) {
            if (a.isEqualTo(inputArgument)) {
                return;
            }
            if (!options.isEmpty("required") && !a.isRequired()) {
                throw new DLogicException("A required argument cannot follow an optional one");
            }
        });

        _args[anIndex] = arg;
        ksort(_args);
    }

    // Option definitions.
    protected DConsoleInputOption[string] _options;

    // Map of short ~ long options, generated when using addOption()
    protected STRINGAA _shortOptions;

    //  Positional argument definitions.
    protected DConsoleInputArgument[] _args;

    // Array of args (argv).
    // TODO // TODO protected Json[string] _token;
    */
    
    // #region rootName
        // Root alias used in help output
        protected string _rootName = "uim";
        // Set the root name used in the HelpFormatter
        @property rootName(string aName) {
            _rootName = name;
        }
    // #endregion rootName

    // #region epilog
        /**
        * Sets an epilog to the parser. The epilog is added to the end of
        * the options and arguments listing when help is generated. */
        mixin(TProperty!("string", "epilog")); 

        @property void epilog(string[] texts) {
            epilog(texts.join("\n"));
        }        
    // #endregion epilog

    // #region command
        // Command name.
        protected string _command = "";

        // Sets the command name for shell/task.
        void setCommand(string newCommandName) {
            // TODO _command = Inflector.underscore(newCommandName);
        }

        // Gets the command name for shell/task.
        string getCommand() {
            return _command;
        }
    // #endregion command

    /**
     * Construct an OptionParser so you can define its behavior
     * Params:
     * string acommand The command name this parser is for. The command name is used for generating help.
     * @param bool defaultOptions Whether you want the verbose and quiet options set. Setting
     * this to false will prevent the addition of `--verbose` & `--quiet` options.
     * /
    this(string newCommand = "", bool defaultOptions = true) {
        this.setCommand(command);

        this.addOption("help", [
            "short": "h",
            "help": "Display this help.",
            "boolean": Json(true),
        ]);

        if (defaultOptions) {
            this.addOption("verbose", [
                "short": "v",
                "help": "Enable verbose output.",
                "boolean": Json(true),
            ]).addOption("quiet", [
                "short": "q",
                "help": "Enable quiet output.",
                "boolean": Json(true),
            ]);
        }
    }
    
    // Static factory method for creating new DOptionParsers so you can chain methods off of them.
    static auto create(string commandName, bool useDefaultOptions = true) {
        return new static(commandName, useDefaultOptions);
    }
    
    /**
     * Build a parser from an array. Uses an array like
     *
     * ```
     * spec = [
     *     "description": "text",
     *     "epilog": "text",
     *     "arguments": [
     *         // list of arguments compatible with addArguments.
     *     ],
     *     "options": [
     *         // list of options compatible with addOptions
     *     ]
     * ];
     * ```
     * Params:
     * Json[string] spec The spec to build the OptionParser with.
     * @param bool defaultOptions Whether you want the verbose and quiet options set.
     * /
    static auto buildFromArray(Json[string] spec, bool defaultOptions = true) {
        auto aParser = new static(spec["command"], defaultOptions);
        if (!spec["arguments"].isEmpty) {
             aParser.addArguments(spec["arguments"]);
        }
        if (!spec["options"].isEmpty) {
             aParser.addOptions(spec["options"]);
        }
        if (!spec["description"].isEmpty) {
             aParser.description(spec["description"]);
        }
        if (!spec["epilog"].isEmpty) {
             aParser.setEpilog(spec["epilog"]);
        }
        return aParser;
    }
    
    // Returns an array representation of this parser.
    Json[string] toArray() {
        return [
            "command": Json(_command),
            "arguments": Json(_args),
            "options": Json(_options),
            "description": Json(_description),
            "epilog": Json(_epilog),
        ];
    }
    
    /**
     * Get or set the command name for shell/task.
     * Params:
     * \UIM\Console\DConsoleOptionParser buildOptionParser|array spec DConsoleOptionParser buildOptionParser or spec to merge with.
     * /
    void merge(DConsoleOptionParser buildOptionParser|array spec) {
        if (cast(DConsoleOptionParser buildOptionParser)spec) {
            spec = spec.toArray();
        }
        if (!spec["arguments"].isEmpty) {
            this.addArguments(spec["arguments"]);
        }
        if (!spec["options"].isEmpty)) {
            this.addOptions(spec["options"]);
        }
        if (!spec["description"].isEmpty)) {
            this.description(spec["description"]);
        }
        if (!spec["epilog"].isEmpty)) {
            this.setEpilog(spec["epilog"]);
        }
    }


        
    /**
     * Add an option to the option parser. Options allow you to define optional or required
     * parameters for your console application. Options are defined by the parameters they use.
     *
     * ### Options
     *
     * - `short` - The single letter variant for this option, leave undefined for none.
     * - `help` - Help text for this option. Used when generating help for the option.
     * - `default` - The default value for this option. Defaults are added into the parsed params when the
     *   attached option is not provided or has no value. Using default and boolean together will not work.
     *   are added into the parsed parameters when the option is undefined. Defaults to null.
     * - `boolean` - The option uses no value, it`s just a boolean switch. Defaults to false.
     *   If an option is defined as boolean, it will always be added to the parsed params. If no present
     *   it will be false, if present it will be true.
     * - `multiple` - The option can be provided multiple times. The parsed option
     *  will be an array of values when this option is enabled.
     * - `choices` A list of valid choices for this option. If left empty all values are valid..
     *  An exception will be raised when parse() encounters an invalid value.
     * Params:
     * \UIM\Console\ConsoleInputOption|string aName The long name you want to the value to be parsed out
     *  as when options are parsed. Will also accept an instance of ConsoleInputOption.
     *  options An array of parameters that define the behavior of the option
     * /
    void addOption(string optionName, Json[string] behaviorOptions = null) {
            defaultValues = [
                "short": Json(""),
                "help": Json(""),
                "default": null,
                "boolean": Json(false),
                "multiple": Json(false),
                "choices": Json.emptyArray,
                "required": Json(false),
                "prompt": null,
            ];
            behaviorOptions = behaviorOptions.update(defaultValues);
            
            auto inputOption = new DConsoleInputOption(
                name,
                behaviorOptions["short"],
                behaviorOptions["help"],
                behaviorOptions["boolean"],
                behaviorOptions["default"],
                behaviorOptions["choices"],
                behaviorOptions["multiple"],
                behaviorOptions["required"],
                behaviorOptions["prompt"]
            );
        }
        addOption(inputOption, behaviorOptions) {
    }

    void addOption(ConsoleInputOption inputOption, Json[string] behaviorOptions = null) {
            string optionName = inputOption.name();

       _options[optionName] = inputOption;
        asort(_options);
        if (inputOption.short()) {
           _shortOptions[inputOption.short()] = optionName;
            asort(_shortOptions);
        }
    }
    
    // Remove an option from the option parser.
    void removeOption(string optionName) {
        _options.remove(optionName);
    }
    
    /**
     * Add a positional argument to the option parser.
     *
     * ### Params
     *
     * - `help` The help text to display for this argument.
     * - `required` Whether this parameter is required.
     * - `index` The index for the arg, if left undefined the argument will be put
     *  onto the end of the arguments. If you define the same index twice the first
     *  option will be overwritten.
     * - `choices` A list of valid choices for this argument. If left empty all values are valid..
     *  An exception will be raised when parse() encounters an invalid value.
     * Params:
     * \UIM\Console\ConsoleInputArgument|string aName The name of the argument.
     *  Will also accept an instance of ConsoleInputArgument.
     * @param Json[string] params Parameters for the argument, see above.
     * /
    void addArgument(ConsoleInputArgument|string aName, Json[string] params = []) {
    }
    
    void addArgument(ConsoleInputArgument|string aName, Json[string] params = []) {

    
    /**
     * Add multiple arguments at once. Take an array of argument definitions.
     * The keys are used as the argument names, and the values as params for the argument.
     * Params:
     * array<string, Json[string]|\UIM\Console\ConsoleInputArgument> someArguments Array of arguments to add.
     * @see \UIM\Console\DConsoleOptionParser buildOptionParser.addArgument()
     * /
    void addArguments(Json[string] someArguments) {
        foreach (name: params; someArguments) {
            if (cast(DConsoleInputArgument)params) {
                name = params;
                params = null;
            }
            this.addArgument(name, params);
        }
    }
    
    /**
     * Add multiple options at once. Takes an array of option definitions.
     * The keys are used as option names, and the values as params for the option.
     * Params:
     * Json[string] optionsToAdd Array of options to add.
     * @see \UIM\Console\DConsoleOptionParser buildOptionParser.addOption()
     * /
    void addOptions(Json[string] optionsToAdd = null) {
        foreach (name: params; optionsToAdd) {
            if (cast(DConsoleInputOption)params) {
                name = params;
                params = null;
            }
            this.addOption(name, params);
        }
    }
    
    // Gets the arguments defined in the parser.
    ConsoleInputArgument[] arguments() {
        return _args;
    }
    
    // Get the list of argument names.
    string[] argumentNames() {
        auto results = _args.map(arg => arg.name()).array;
        return results;
    }
    
    // Get the defined options in the parser.
    ConsoleInputOption[string] options() {
        return _options;
    }
    
    /**
     * Parse the argv array into a set of params and args.
     * Params:
     * array argv Array of args (argv) to parse.
     * @param \UIM\Console\ConsoleIo|null  aConsoleIo A ConsoleIo instance or null. If null prompt options will error.
     * /
    array parse(Json[string] argv, IConsoleIo aConsoleIo = null) {
        params = someArguments = null;
       _tokens = argv;

        afterDoubleDash = false;
        while ((token = array_shift(_tokens)) !isNull) {
            token = to!string(token);
            if (token == "--") {
                afterDoubleDash = true;
                continue;
            }
            if (afterDoubleDash) {
                // only positional arguments after --
                someArguments = _parseArg(token, someArguments);
                continue;
            }
            if (token.startsWith("--")) {
                params = _parseLongOption(token, params);
            } else if (str_starts_with(token, "-")) {
                params = _parseShortOption(token, params);
            } else {
                someArguments = _parseArg(token, someArguments);
            }
        }
        if (isSet(params["help"])) {
            return [params, someArguments];
        }
        foreach (anI: arg; _args) {
            if (arg.isRequired() && !isSet(someArguments[anI])) {
                throw new DConsoleException(
                    "Missing required argument. The `%s` argument is required.".format(arg.name())
                );
            }
        }
        _options.each!((option) {
            name = option.name();
             isBoolean = option.isBoolean();
            default = option.defaultValue();

            useDefault = !isSet(params[name]);
            if (default !isNull && useDefault && !isBoolean) {
                params[name] = default;
            }
            if (isBoolean && useDefault) {
                params[name] = false;
            }
            prompt = option.prompt();
            if (!isSet(params[name]) && prompt) {
                if (!aConsoleIo) {
                    throw new DConsoleException(
                        "Cannot use interactive option prompts without a ConsoleIo instance. ' .
                        "Please provide a ` aConsoleIo` parameter to `parse()`.'
                    );
                }
                choices = option.choices();

                aValue = choices
                    ? aConsoleIo.askChoice(prompt, choices)
                    : aConsoleIo.ask(prompt);

                params[name] = aValue;
            }
            if (option.isRequired() && !isSet(params[name])) {
                throw new DConsoleException(
                    "Missing required option. The `%s` option is required and has no default value.".format(name)
                );
            }
        });
        return [params, someArguments];
    }
    
    /**
     * Gets formatted help for this parser object.
     *
     * Generates help text based on the description, options, arguments and epilog
     * in the parser.
     * Params:
     * string aformat Define the output format, can be text or XML
     * @param int width The width to format user content to. Defaults to 72
     * /
    string help(string aformat = "text", int width = 72) {
        formatter = new DHelpFormatter(this);
        formatter.aliasName(_rootName);

        if (format == "text") {
            return formatter.text(width);
        }
        if (format == "xml") {
            return to!string(formatter.xml());
        }
        throw new DConsoleException("Invalid format. Output format can be text or xml.");
    }
    

    
    /**
     * Parse the value for a long option out of _tokens. Will handle
     * options with an `=` in them.
     * Params:
     * string optionToParse The option to parse.
     * @param  params The params to append the parsed value into
     * /
    // TODO protected Json[string] _parseLongOption(string optionToParse, Json[string] params) {
        name = substr(optionToParse, 2);
        if (name.has("=")) {
            [name, aValue] = split("=", name, 2);
            array_unshift(_tokens, aValue);
        }
        return _parseOption(name, params);
    }
    
    /**
     * Parse the value for a short option out of _tokens
     * If the option is a combination of multiple shortcuts like -otf
     * they will be shifted onto the token stack and parsed individually.
     * Params:
     * string optionToParse The option to parse.
     * @param  params The params to append the parsed value into
     * params with option added in.
     * @throws \UIM\Console\Exception\ConsoleException When unknown short options are encountered.
     * /
    // TODO protected Json[string] _parseShortOption(string optionToParse, Json[string] params) {
        string aKey = substr(optionToParse, 1);
        if (aKey.length > 1) {
            flags = str_split(aKey);
            aKey = flags[0];
            for (anI = 1, len = count(flags);  anI < len;  anI++) {
                array_unshift(_tokens, "-" ~ flags[anI]);
            }
        }
        if (!_shortOptions.isSet(aKey)) {
            auto options = _shortOptions.byKeyValue
                .map!(shortLong => shortLong.key ~ " (short for `--"~shortLong.value~"`)");

            throw new DMissingOptionException(
                "Unknown short option `%s`.".format(aKey),
                aKey, options
            );
        }
        name = _shortOptions[aKey];

        return _parseOption(name, params);
    }
    
    /**
     * Parse an option by its name index.
     * Params:
     * params The params to append the parsed value into
     * returns Params with option added in.
     * @throws \UIM\Console\Exception\ConsoleException
     * /
    protected Json[string] _parseOption(string nameToParse, Json[string] params) {
        if (!_options.isSet(nameToParse)) {
            throw new DMissingOptionException(
                "Unknown option `%s`.".format(nameToParse),
                nameToParse, _options.keys
            );
        }
        option = _options[nameToParse];
         isBoolean = option.isBoolean();
        nextValue = _nextToken();
        emptyNextValue = (isEmpty(nextValue) && nextValue != "0");
        if (!isBoolean && !emptyNextValue && !_optionExists(nextValue)) {
            array_shift(_tokens);
            aValue = nextValue;
        } else if (isBoolean) {
            aValue = true;
        } else {
            aValue = to!string(option.defaultValue());
        }
        option.validChoice(aValue);
        if (option.acceptsMultiple()) {
            params[nameToParse] ~= aValue;
        } else {
            params[nameToParse] = aValue;
        }
        return params;
    }
    
    // Check to see if name has an option (short/long) defined for it.
    protected bool _optionExists(string optionName) {
        if (optionName.startsWith("--")) {
            return isSet(_options[substr(optionName, 2)]);
        }
        if (optionName[0] == "-" && optionName[1] != "-") {
            return isSet(_shortOptions[optionName[1]]);
        }
        return false;
    }
    
    /**
     * Parse an argument, and ensure that the argument doesn`t exceed the number of arguments
     * and that the argument is a valid choice.
     * Params:
     * string aargument The argument to append
     * @param array someArguments The array of parsed args to append to.
     * /
    protected string[] _parseArg(string argumentToAppend, Json[string] someArguments) {
        if (_args.isEmpty) {
            someArguments ~= argumentToAppend;
            return someArguments;
        }

        auto next = count(someArguments);
        if (!isSet(_args[next])) {
            expected = count(_args);
            throw new DConsoleException(
                "Received too many arguments. Got `%s` but only `%s` arguments are defined."
                .format(next, expected)
            );
        }
       _args[next].validChoice(argument);
        someArguments ~= argument;

        return someArguments;
    }
    
    // Find the next token in the argv set.
    protected string _nextToken() {
        return _tokens[0] ?? "";
    } */
}
