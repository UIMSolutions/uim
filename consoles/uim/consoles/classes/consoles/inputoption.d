module uim.consoles.classes.consoles.inputoption;

import uim.consoles;

@safe:

/**
 * An object to represent a single option used in the command line.
 * DConsoleOptionParser buildOptionParser creates these when you use addOption()
 *
 * @see \UIM\Console\DConsoleOptionParser buildOptionParser.addOption()
 */
class DConsoleInputOption {
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

    // Name of the option
    mixin(TProperty!("string", "name"));

    // Short (1 character) alias for the option.
    protected string _shortAlias;
    //  Get the value of the short attribute.
    string shortAlias() {
        return _shortAlias;
    }

    // Help text for the option.
    protected string _help;

    // Default value for the option
    // TODO protected string|bool|null _default = null;

    // An array of choices for the option.
    protected string[] _choices;

    // The prompt string
    protected string aprompt = null;

    // Is the option required.
    protected bool _isRequired;
    // Check if this option is required
    bool isRequired() {
        return _isRequired;
    }
    
    // Check if this option is a boolean option
    // Is the option a boolean option. Boolean options do not consume a parameter.
    protected bool _isBooleanOption;
    bool isBoolean() {
        return _isBooleanOption;
    }
    
    // Check if this option accepts multiple values.
    // Can the option accept multiple value definition.
    protected bool _acceptsMultiple;
    bool acceptsMultiple() {
        return _acceptsMultiple;
    }

    /**
     * Make a new DInput Option
     * Params:
     * string aName The long name of the option, or an array with all the properties.
     * @param string ashort The shortAlias for this option
     * @param string ahelp The help text for this option
     * @param bool isBooleanOption Whether this option is a boolean option. Boolean options don`t consume extra tokens
     * @param string|bool|null default The default value for this option.
     * @param bool multiple Whether this option can accept multiple value definition.
     * @param string prompt The prompt string.
     * @throws \UIM\Console\Exception\ConsoleException
     * /
    this(
        string aName,
        string newShortAlias = "",
        string ahelp = "",
        bool isBooleanOption = false,
        string|bool|null default = null,
        string[] validChoices = [],
        bool acceptsMultiple = false,
        bool isRequiredOption = false,
        string promptText = null
    ) {
       _name = name;
       _shortAlias = newShortAlias;
       _help = help;
       _isBooleanOption = isBooleanOption;
       _choices = validChoices;
       this.acceptsMultiple(acceptsMultiple);
        _isRequired = isRequiredOption;
        _prompt = promptText;

        if (isBooleanOption) {
           _default = (bool) default;
        } else if (! default.isNull) {
           _default = to!string(default);
        }
        if (_short.length > 1) {
            throw new DConsoleException(
                "Short option `%s` is invalid, short options must be one letter.".format(_shortalias)
            );
        }
        if (isSet(_default) && this.prompt) {
            throw new DConsoleException(
                "You cannot set both `prompt` and `default` options. " ~
                "Use either a static `default` or interactive `prompt`"
            );
        }
    }
    

    
    /**
     * Generate the help for this this option.
     * Params:
     * int width The width to make the name of the option.
     * /
    string help(int width = 0) {
        string default;
        if (_default && _default != true) {
            default = " <comment>(default: %s)</comment>".format(_default);
        }
        if (_choices) {
            default ~= " <comment>(choices: %s)</comment>".format(join("|", _choices));
        }

        string short;
        if (!_shortalias.isEmpty) {
            short = ", -" ~ _shortalias;
        }
        
        string name = "--%s%s".format(_name, short);
        if (name.length < width) {
            name = str_pad(name, width, " ");
        }
        
        string required = _required 
            ? " <comment>(%s)</comment>".format(_required)
            : "";

        return "%s%s%s%s".format(name, _help, default, required);
    }
    
    // Get the usage value for this option
    string usage() {
        name = _shortalias == "" ? "--" ~ _name : "-" ~ _shortalias;
        default = "";
        if (!_default.isNull && !isBool(_default) && !_default.isEmpty) {
            default = " " ~ _default;
        }
        if (_choices) {
            default = " " ~ join("|", _choices);
        }
        template = "[%s%s]";
        if (this.isRequired()) {
            template = "%s%s";
        }
        return template.format(name, default);
    }
    
    // Get the default value for this option
    string|bool|null defaultValue() {
        return _default;
    }
    

    
    /**
     * Check that a value is a valid choice for this option.
     * Params:
     * string|bool aValue The choice to validate.
     * /
    bool validChoice(string|bool aValue) {
        if (_choices.isEmpty) {
            return true;
        }
        if (!in_array(aValue, _choices, true)) {
            throw new DConsoleException(
                "`%s` is not a valid value for `--%s`. Please use one of `%s`"
                .format(to!string(aValue), _name, join(", ", _choices))
            );
        }
        return true;
    }
    
    // Get the list of choices this option has.
    array choices() {
        return _choices;
    }
    
    // Get the prompt string
    string prompt() {
        return to!string(this.prompt);
    }
    
    // Append the option`s XML into the parent.
    SimpleXMLElement xml(SimpleXMLElement parent) {
        option = parent.addChild("option");
        option.addAttribute("name", "--" ~ _name);
        
        string short = !_shortalias.isEmpty
            ? "-" ~ _shortalias
            : "";

        auto default = _default;
        if (default == true) {
            default = "true";
        } else if (default == false) {
            default = "false";
        }
        option.addAttribute("short", short);
        option.addAttribute("help", _help);
        option.addAttribute("boolean", to!string(to!int(_isBooleanOption)));
        option.addAttribute("required", to!string((int)this.required));
        option.addChild("default", to!string(default));
        choices = option.addChild("choices");
        _choices.each!(valid => choices.addChild("choice", valid));
        return parent;
    } */
}
