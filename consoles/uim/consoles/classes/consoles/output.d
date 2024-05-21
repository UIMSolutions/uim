module uim.consoles.classes.consoles.output;

import uim.consoles;

@safe:

/**
 * Object wrapper for outputting information from a shell application.
 * Can be connected to any stream resource that can be used with fopen()
 *
 * Can generate colorized output on consoles that support it. There are a few
 * built in styles
 *
 * - `error` Error messages.
 * - `warning` Warning messages.
 * - `info` Informational messages.
 * - `comment` Additional text.
 * - `question` Magenta text used for user prompts
 *
 * By defining styles with addStyle() you can create custom console styles.
 *
 * ### Using styles in output
 *
 * You can format console output using tags with the name of the style to apply. From inside a shell object
 *
 * ```
 * this.writeln("<warning>Overwrite:</warning> foo.d was overwritten.");
 * ```
 *
 * This would create orange 'Overwrite:' text, while the rest of the text would remain the normal color.
 * See ConsoleOutput.styles() to learn more about defining your own styles. Nested styles are not supported
 * at this time.
 */
class DConsoleOutput {
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

        _foregroundColors = [
            "black":  30,
            "red":  31,
            "green":  32,
            "yellow":  33,
            "blue":  34,
            "magenta":  35,
            "cyan":  36,
            "white":  37,
        ];

        _backgroundColors = [
            "black":  40,
            "red":  41,
            "green":  42,
            "yellow":  43,
            "blue":  44,
            "magenta":  45,
            "cyan":  46,
            "white":  47,
        ];

        _options = [
            "bold":  1,
            "underline":  4,
            "blink":  5,
            "reverse":  7,
        ];

        return true;
    }

    mixin(TProperty!("string", "name"));

    // Raw output constant - no modification of output text.
    const int RAW = 0;

    // Plain output - tags will be stripped.
    const int PLAIN = 1;

    // Color output - Convert known tags in to ANSI color escape codes.
    const int COLOR = 2;

    // Constant for a newline.
    const string LF = ""; // TODO = D_EOL;

    // File handle for output.
    // TODO protected resource _output;

    // The current output type.
    protected int _outputAs = COLOR;

    // text colors used in colored output.
    protected static int[string] _foregroundColors;

    // background colors used in colored output.
    protected static int[string] _backgroundColors;

    // Formatting options for colored output.
    protected static int[string] _options;

    /**
     * Styles that are available as tags in console output.
     * You can modify these styles with ConsoleOutput.styles()
     */
    protected static STRINGAA[string] _styles = [
        "emergency":  ["text":  "red"],
        "alert":  ["text":  "red"],
        "critical":  ["text":  "red"],
        "error":  ["text":  "red"],
        "warning":  ["text":  "yellow"],
        "info":  ["text":  "cyan"],
        "debug":  ["text":  "yellow"],
        "success":  ["text":  "green"],
        "comment":  ["text":  "blue"],
        "question":  ["text":  "magenta"],
        "notice":  ["text":  "cyan"],
    ];

    /**
     * Construct the output object.
     *
     * Checks for a pretty console environment. Ansicon and ConEmu allows
     * pretty consoles on Windows, and is supported.
     * Params:
     * resource|string astream The identifier of the stream to write output to.
     */
    this(string streamIdentifier = "uim://stdout") {
        auto fileStream = fopen(streamIdentifier, "wb");
        if (!isResource(fileStream)) {
            throw new DConsoleException("Invalid stream in constructor. It is not a valid resource.");
        }
       _output = fileStream;

        if (
            (
                DIRECTORY_SEPARATOR == "\\" &&
                !uim_uname("v").lower.has("windows 10") &&
                !to!string(enviroment("SHELL")).lower.has("bash.exe") &&
                !(bool)enviroment("ANSICON") &&
                enviroment("ConEmuANSI") != "ON"
            ) ||
            (
                function_exists("posix_isatty") &&
                !posix_isatty(_output)
            ) ||
            (
                enviroment("NO_COLOR") !isNull
            )
        ) {
           _outputAs = self.PLAIN;
        }
    }
    
    /**
     * Outputs a single or multiple messages to stdout or stderr. If no parameters
     * are passed, outputs just a newline.
     * Params:
     * string[]|string amessage A string or an array of strings to output
     */
    int write(string[] amessage, int numberOfLines = 1) {
        if (isArray(message)) {
            message = join(LF, message);
        }
        return _write(this.styleText(message ~ str_repeat(LF, numberOfLines)));
    }
    
    // Apply styling to text.
    string styleText(string stylingText) {
        if (_outputAs == RAW) {
            return stylingText;
        }
        if (_outputAs != PLAIN) {
            /** @var \Closure replaceTags */
            replaceTags = _replaceTags(...);

            output = preg_replace_callback(
                "/<(?P<tag>[a-z0-9-_]+)>(?P<text>.*?)<\/(\1)>/ims",
                replaceTags,
                stylingText
            );
            if (output !isNull) {
                return output;
            }
        }
        tags = join("|", _styles.keys);
        output = preg_replace("#</?(?:" ~ tags ~ ")>#", "", stylingText);

        return output ? output : stylingText;
    }
    
    /**
     * Replace tags with color codes.
     *
     * matchesToReplace - Array of matches to replace.
     */
    protected string _replaceTags(STRINGAA matchesToReplace) {
        style = getStyle(matchesToReplace["tag"]);
        if (style.isEmpty) {
            return "<" ~ matchesToReplace["tag"] ~ ">" ~ matchesToReplace["text"] ~ "</" ~ matchesToReplace["tag"] ~ ">";
        }
        styleInfo = null;
        if (!style["text"].isEmpty) && isSet(_foregroundColors[style["text"]])) {
            styleInfo ~= _foregroundColors[style["text"]];
        }
        if (!style.isEmpty("background")) && isSet(_backgroundColors[style["background"]])) {
            styleInfo ~= _backgroundColors[style["background"]];
        }
        unset(style["text"], style["background"]);
        style.byKeyValue
            .filter!(optionValue => optionValue.value)
            .each!(optionValue => styleInfo ~= _options[optionValue.option]);

        return "\033[" ~ join(";", styleInfo) ~ "m" ~ matchesToReplace["text"] ~ "\033[0m";
    }
    
    // Writes a message to the output stream.
    protected int _write(string messageToWrite) {
        return to!int(fwrite(_output, messageToWrite));
    }
    
    /**
     * Gets the current styles offered
     */
    Json[string] getStyle(string styleName) {
        return _styles.get(styleName, null);
    }
    
    /**
     * Sets style.
     *
     * ### Creates or modifies an existing style.
     *
     * ```
     * output.setStyle("annoy", ["text":  "purple", "background":  "yellow", "blink":  true.toJson]);
     * ```
     *
     * ### Remove a style
     *
     * ```
     * this.output.setStyle("annoy", []);
     * ```
     */
    void setStyle(string styleToSet, Json[string] styleDefinition) {
        if (!styleDefinition) {
            _styles.remove(styleToSet);
            return;
        }
        _styles[styleToSet] = styleDefinition;
    }
    
    // Gets all the style definitions.
    Json[string] styles() {
        return _styles;
    }
    
    // Get the output type on how formatting tags are treated.
    int getOutputAs() {
        return _outputAs;
    }
    
    // Set the output type on how formatting tags are treated.
    void setOutputAs(int outputType) {
        if (!in_array(outputType, [self.RAW, self.PLAIN, self.COLOR], true)) {
            throw new DInvalidArgumentException("Invalid output type `%s`.".format(outputType));
        }
       _outputAs = outputType;
    }
    
    // Clean up and close handles
    auto __destruct() {
        /** @psalm-suppress RedundantCondition */
        if (isResource(_output)) {
            fclose(_output);
        }
    } 
}
