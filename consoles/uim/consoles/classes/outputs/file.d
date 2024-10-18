/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module consoles.uim.consoles.classes.outputs.standard copy;

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
 * See OutputConsole.styles() to learn more about defining your own styles. Nested styles are not supported
 * at this time.
 */
class DStandardOutput : DOutput {
  mixin(OutputThis!("File"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    _foregroundColors = [
      "black": 30,
      "red": 31,
      "green": 32,
      "yellow": 33,
      "blue": 34,
      "magenta": 35,
      "cyan": 36,
      "white": 37,
    ];
    _backgroundColors = [
      "black": 40,
      "red": 41,
      "green": 42,
      "yellow": 43,
      "blue": 44,
      "magenta": 45,
      "cyan": 46,
      "white": 47,
    ];

    _options = [
      "bold": 1,
      "underline": 4,
      "blink": 5,
      "reverse": 7,
    ];

    _styles
      .set("emergency", ["text": "red"])
      .set("alert", ["text": "red"])
      .set("critical", ["text": "red"])
      .set("error", ["text": "red"])
      .set("warning", ["text": "yellow"])
      .set("info", ["text": "cyan"])
      .set("debug", ["text": "yellow"])
      .set("success", ["text": "green"])
      .set("comment", ["text": "blue"])
      .set("question", ["text": "magenta"])
      .set("notice", ["text": "cyan"]);

    return true;
  }

  // Raw output constant - no modification of output text.
  const int RAW = 0; // Plain output - tags will be stripped.
  const int PLAIN = 1; // Color output - Convert known tags in to ANSI color escape codes.
  const int COLOR = 2; // Constant for a newline.
  const string LF = ""; // TODO = D_EOL;

  // File handle for output.
  // TODO protected resource _output;

  // The current output type.
  protected int _outputAs = COLOR; // text colors used in colored output.
  protected static int[string] _foregroundColors; // background colors used in colored output.
  protected static int[string] _backgroundColors; // Formatting options for colored output.
  protected static int[string] _options;

/**
     * Construct the output object.
     *
     * Checks for a pretty console environment. Ansicon and ConEmu allows
     * pretty consoles on Windows, and is supported.
     * Params:
     * resource|string astream The identifier of the stream to write output to.
     */
  this(string streamIdentifier = "uim://stdout") {
    /* auto fileStream = fopen(streamIdentifier, "wb");
        if (!isResource(fileStream)) {
            throw new DConsoleException("Invalid stream in constructor. It is not a valid resource.");
        }
       _output = fileStream; */
    /* 
        if (
            (
                DIRECTORY_SEPARATOR == "\\" &&
                !uim_uname("v").lower.contains("windows 10") &&
                !to!string(enviroment("SHELL")).lower.contains("bash.exe") &&
                !(bool)enviroment("ANSICON") &&
                enviroment("ConEmuANSI") != "ON"
           ) ||
            (
                function_hasKey("posix_isatty") &&
                !posix_isatty(_output)
           ) ||
            (
                enviroment("NO_COLOR") !is null
           )
       ) {
           _outputAs = PLAIN;
        } */
  }

  /**
     * Outputs a single or multiple messages to stdout or stderr. If no parameters
     * are passed, outputs just a newline.
     */
  override void write(string[] messages, int numberOfLines = 1) {
    write(messages.join(LF), numberOfLines); 
  }

  override void write(string message, int numberOfLines = 1) {
    std.stdio.write(this.styleText(message ~ repeat(LF, numberOfLines)));
  }

  // Apply styling to text.
  override string styleText(string stylingText) {
    if (_outputAs == RAW) {
      return stylingText;
    }

    if (_outputAs != PLAIN) {
      /** @var \Closure replaceTags */
      /* replaceTags = _replaceTags(...);

            output = preg_replace_callback(
                "/<(?P<tag>[a-z0-9-_]+)>(?P<text>.*?)<\/(\1)>/ims",
                replaceTags,
                stylingText
           );
            if (output !is null) {
                return output;
            } */
    }
    /* auto tags = _styles.keys.join("|");
        auto output = preg_replace("#</?(?:" ~ tags ~ ")>#", "", stylingText);
 */
    /* return output ? output : stylingText; */
    return null;
  }

  // Replace tags with color codes.
  override protected string _replaceTags(Json[string] matches) {
    string tag = matches.getString("tag");
    Json style = _styles.get(tag);

    if (style.isNull) {
      return "<" ~ tag ~ ">" ~ matches.getString("text") ~ "</" ~ tag ~ ">";
    }

    string[] styleInfo;
    string text = style.getString("text");
    if (_foregroundColors.hasKey(text)) {
      styleInfo ~= _foregroundColors.getString(text);
    }

    string background = style.getString("background");
    if (_backgroundColors.hasKey(style.getString("background"))) {
      styleInfo ~= _backgroundColors.getString(background);
    }
    style.removeKeys("text", "background");

    styleInfo ~= style.byKeyValue
      .filter!(kv => !kv.value.isEmpty)
      .map!(kv => _options.get(kv.key))
      .array;

    return "\033[" ~ styleInfo.join(";") ~ "m" ~ matches.getString("text") ~ "\033[0m";
  }

  // Writes a message to the output stream.
  override  protected int _write(string messageToWrite) {
    /*  return to!int(fwrite(_output, messageToWrite)); */
    return 0;
  }

  // Get the output type on how formatting tags are treated.
  override int getOutputAs() {
    return _outputAs;
  }

  // Set the output type on how formatting tags are treated.
  override void setOutputAs(int outputType) {
    /* if (!isIn(outputType, [RAW, PLAIN, COLOR], true)) {
            throw new DInvalidArgumentException("Invalid output type `%s`.".format(outputType));
        } */
    _outputAs = outputType;
  }

  // Clean up and close handles
  override void __destruct() {
    /* if (isResource(_output)) {
            fclose(_output);
        } */
  }
}
