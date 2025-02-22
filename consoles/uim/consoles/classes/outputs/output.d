/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.consoles.classes.outputs.output;

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
class DOutput : UIMObject, IOutput {
  mixin(OutputThis!());

  // Raw output constant - no modification of output text.
  static const string LF = "\n";  // TODO = D_EOL;

  // The current output type.
  protected string _outputType = "COLOR"; // text colors used in colored output.
  protected static int[string] _foregroundColors; // background colors used in colored output.
  protected static int[string] _backgroundColors; // Formatting options for colored output.
  protected static int[string] _options;

  // #region write
    // Outputs a single or multiple messages or newlines to stdout / stderr.
    IOutput write(uint numberOfLines = 1) {
      write("", numberOfLines);
      return this;
    }

    IOutput write(string[] messages, uint numberOfLines = 1) {
      write(messages.join(LF), numberOfLines); 
      return this;
    }  

    IOutput write(string message, uint numberOfLines = 1) {
      return this;
    }
  // #endregion write

  // #region styleText
  // Apply styling to text.
  string styleText(string text) {
    string styledTxt = text;
    if (outputType == "RAW") {
      return text;
    }

    if (outputType == "PLAIN") {
      styledTxt = text;
      styles.keys
        .each!(key => styledTxt = styledTxt.replace("<"~key~">", "").replace("</"~key~">", ""));

      if (!styledTxt.isNull) {
        return styledTxt;
      }
    }

    foreach(tag; styles.keys) {
      if (styledTxt.contains("<"~tag~">")) {
        styledTxt = styledTxt.replace("<"~tag~">", "").replace("</"~tag~">", "");
        Json match = Json.emptyObject;
        match["tag"] = tag;
        match["text"] = styledTxt;
        return replaceTags(match);
      }
    }
   
    return text;
  }
  // #endregion styleText

  // #region replaceTags
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
  // #region replaceTags

  // #region styles
  // Styles that are available as tags in console output.
  protected static Json[string] _styles;
  
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
  IOutput style(string name, STRINGAA definition) {
    Json[string] map;
    definition.each!((key, value) => map[key] = Json(value));

    return style(name, map);
  }

  IOutput style(string name, Json[string] definition) {
    Json json = Json.emptyObject;
    definition.each!((key, value) => json[key] = value);

    return style(name, json);
  }

  IOutput style(string name, Json definition) {
    _styles[name] = definition;
    return this;
  }

  IOutput removeStyle(string name) {
    _styles.remove(name);
    return this;
  }

  // Gets all the style definitions.
  Json[string] styles() {
    return _styles;
  }
  // #endregion styles

  // #region outputType
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
  // #endregion outputType

  // Clean up and close handles
  IOutput close() {
    return this; 
  }
}

unittest {
  auto output = new DOutput();
  assert(output !is null, "Output object is null.");
}