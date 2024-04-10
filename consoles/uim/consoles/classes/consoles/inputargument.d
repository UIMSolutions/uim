module uim.consoles.classes.consoles.inputargument;

import uim.consoles;

@safe:

/**
 * An object to represent a single argument used in the command line.
 * DConsoleOptionParser buildOptionParser creates these when you use addArgument()
 *
 * @see \UIM\Console\DConsoleOptionParser buildOptionParser.addArgument()
 */
class DConsoleInputArgument {
    mixin TConfigurable!();

    this() {
        initialize;
    }

    this(IData[string] initData) {
        initialize(initData);
    }

    bool initialize(IData[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    // Name of the argument.
    mixin(TProperty!("string", "name"));

    // Help string
    protected string _help;

    // Is this option required?
    protected bool _required;
    // Check if this argument is a required argument
    bool isRequired() {
        return _required;
    }

    // An array of valid choices for this argument.
    protected string[] _choices;

    /**
     * Make a new DInput Argument
     * Params:
     * IData[string]|string aName The long name of the option, or an array with all the properties.
     * @param string ahelp The help text for this option
     * @param bool required Whether this argument is required. Missing required args will trigger exceptions
     * @param string[] choices Valid choices for this option.
     * /
    this(string[] aName, string ahelp = "", bool required = false, string[] optionChoices = []) {
        if (isArray(name) && isSet(name["name"])) {
            foreach (aKey: aValue; name) {
                this.{"_" ~ aKey} = aValue;
            }
        } else {
            /** @var string aName * /
           _name = name;
           _help = help;
           _required = required;
           _choices = optionChoices;
        }
    }
    
    /**
     * Checks if this argument is equal to another argument.
     * Params:
     * \UIM\Console\ConsoleInputArgument argument ConsoleInputArgument to compare to.
     * /
    bool isEqualTo(ConsoleInputArgument argument) {
        return this.name() == argument.name() &&
            this.usage() == argument.usage();
    }
    
    /**
     * Generate the help for this argument.
     * Params:
     * int width The width to make the name of the option.
     * /
    string help(int width = 0) {
        auto helpName = _name;
        if (helpName.length < width) {
            helpName = str_pad(helpName, width, " ");
        }
        optional = "";
        if (!isRequired()) {
            optional = " <comment>(optional)</comment>";
        }
        if (_choices) {
            optional ~= " <comment>(choices: %s)</comment>".format(join("|", _choices));
        }
        return "%s%s%s".format(helpName, _help, optional);
    }
    
    // Get the usage value for this argument
    string usage() {
        string usageName = _name;
        if (_choices) {
            usageName = _choices.join("|");
        }
        usageName = "<" ~ usageName ~ ">";
        if (!isRequired()) {
            usageName = "[" ~ usageName ~ "]";
        }
        return usageName;
    }
    
    
    // Check that aValue is a valid choice for this argument.
    bool validChoice(string choiceToValidate) {
        if (_choices.isEmpty) {
            return true;
        }
        if (!in_array(choiceToValidate, _choices, true)) {
            throw new DConsoleException(                
                "`%s` is not a valid value for `%s`. Please use one of `%s`"
                .format(aValue, _name, _choices.join(", ", ))
            );
        }
        return true;
    }
    
    // Append this arguments XML representation to the passed in SimpleXml object.
    SimpleXMLElement xml(SimpleXMLElement parentElement) {
        auto option = parentElement.addChild("argument");
        option.addAttribute("name", _name);
        option.addAttribute("help", _help);
        option.addAttribute("required", to!string(to!int(this.isRequired())));
        
        auto choices = option.addChild("choices");
        choices.each!(valid => choices.addChild("choice", valid));
        return parentElement;
    } */
}
