/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.consoles.classes.outputs.file;

import uim.consoles;
@safe:

version (test_uim_consoles) {
    unittest {
        writeln("-----  ", __MODULE__, "\t  -----");
    }
}

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
class DFileOutput : DOutput {
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

    style("emergency", ["text": "red"]);
    style("alert", ["text": "red"]);
    style("critical", ["text": "red"]);
    style("error", ["text": "red"]);
    style("warning", ["text": "yellow"]);
    style("info", ["text": "cyan"]);
    style("debug", ["text": "yellow"]);
    style("success", ["text": "green"]);
    style("comment", ["text": "blue"]);
    style("question", ["text": "magenta"]);
    style("notice", ["text": "cyan"]);

    return true;
  }

  // Raw output constant - no modification of output text.
  const int RAW = 0; // Plain output - tags will be stripped.
  const int PLAIN = 1; // Color output - Convert known tags in to ANSI color escape codes.
  const int COLOR = 2; // Constant for a newline.
  protected string filename = "output.txt";

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
  override IOutput write(string message, uint numberOfLines = 1) {
    append(filename, this.styleText(message ~ LF.repeatTxt(numberOfLines)));
    return this;
  }

  // Apply styling to text.
  override string styleText(string stylingText) {
    if (_outputAs == RAW) {
      return stylingText;
    }

    if (_outputAs != PLAIN) {
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

  // Clean up and close handles
  override IOutput close() {
    /* if (isResource(_output)) {
            fclose(_output);
        } */
    return this;
  }
}

mixin(OutputCalls!("File"));

unittest {
  auto output = FileOutput;
  assert(testOutput(output));
}
