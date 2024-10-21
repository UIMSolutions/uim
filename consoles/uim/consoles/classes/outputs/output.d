/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.consoles.classes.outputs.output;

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
class DOutput : UIMObject, IOutput {
  mixin(OutputThis!());

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    return true;
  }

  // Raw output constant - no modification of output text.
  const string LF = "\n";

  // The current output type.
  protected string _outputType = "COLOR"; // text colors used in colored output.
  protected static int[string] _foregroundColors; // background colors used in colored output.
  protected static int[string] _backgroundColors; // Formatting options for colored output.
  protected static int[string] _options;

  // Styles that are available as tags in console output.
  protected static Json[string] _styles;

  /**
     * Outputs a single or multiple messages to stdout or stderr. If no parameters
     * are passed, outputs just a newline.
     */
  void write(string[] messages, int numberOfLines = 1) {
    write(messages.join(LF), numberOfLines); 
  }  

  void write(string message, int numberOfLines = 1) {
  }

  // Apply styling to text.
  string styleText(string stylingText) {
    if (_outputType == "RAW") {
      return stylingText;
    }

    if (_outputType != "PLAIN") {
      /** @var \Closure replaceTags */
      /* replaceTags = replaceTags(...);

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
  protected string replaceTags(Json matches) {
    string tag = matches.getString("tag"); // matches = {"tag": ..., "text": ... }
    Json style = _styles.get(tag, Json(null)); // _styles["tag"] -> Json 

    if (style.isNull) { // style not found
      return htmlDoubleTag(tag, matches.getString("text"));
    }

    string[] styleInfo;
    string text = style.getString("text"); // "red"
    if (_foregroundColors.hasKey(text)) {
      styleInfo ~= to!string(_foregroundColors[text]); // "31"
    }
    style.remove("text");

    string background = style.getString("background"); // "white"
    if (_backgroundColors.hasKey(background)) {
      styleInfo ~= to!string(_backgroundColors[background]); // "47"
    }
    style.remove("background");

    styleInfo ~= style.byKeyValue
      .filter!(kv => kv.key in _options && !kv.value.isNull)
      .map!(kv => to!string(_options[kv.key]))
      .array;

    return "\033[" ~ styleInfo.join(";") ~ "m" ~ matches.getString("text") ~ "\033[0m";
  }


  // Gets the current styles offered
  Json style(string name) {
    return name in _styles ? _styles[name] : Json(null);
  }

  /**
     * Sets style.
     *
     * ### Creates or modifies an existing style.
     *
     * ```
     * output.setStyle("annoy", ["text": "purple", "background": "yellow", "blink": true.toJson]);
     * ```
     *
     * ### Remove a style
     *
     * ```
     * this.output.setStyle("annoy", []);
     * ```
     */
  IOutput style(string style, STRINGAA definition) {
    _styles.set(style, definition);
    return this;
  }

  IOutput style(string style, Json definition) {
    _styles.set(style, definition);
    return this;
  }

  IOutput removeStyle(string style) {
    _styles.removeKey(style);
    return this;
  }

  // Gets all the style definitions.
  Json[string] styles() {
    return _styles;
  }

  // Get the output type on how formatting tags are treated.
  string outputType() {
    return _outputType;
  }

  // Set the output type on how formatting tags are treated.
  IOutput outputType(string type) {
    /* if (!type.isIn(["RAW", "PLAIN", "COLOR"])) {
      // throw new DInvalidArgumentException("Invalid output type `%s`.".format(type));
    } */
    _outputType = type;
    return this;
  }

  // Clean up and close handles
  void __destruct() {
  }
}
