/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.consoles.classes.outputs.standard;

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
  mixin(OutputThis!("Standard"));

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
      .set("emergency", ["text": "red"].toJson)
      .set("alert", ["text": "red"].toJson)
      .set("critical", ["text": "red"].toJson)
      .set("error", ["text": "red"].toJson)
      .set("warning", ["text": "yellow"].toJson)
      .set("info", ["text": "cyan"].toJson)
      .set("debug", ["text": "yellow"].toJson)
      .set("success", ["text": "green"].toJson)
      .set("comment", ["text": "blue"].toJson)
      .set("question", ["text": "magenta"].toJson)
      .set("notice", ["text": "cyan", "background": "white"].toJson);

    return true;
  }
  unittest {
      auto output = StandardOutput;
      auto matches = Json.emptyObject;
      matches["tag"] = "notice";
      matches["text"] = "Hallo World";
      writeln("replaceTags == ", output.replaceTags(matches));
  }

  // #region write
  override void write(string message, int numberOfLines = 1) {
    std.stdio.write(message ~ LF.repeatTxt(numberOfLines));
  }
  // #endregion write

  // Apply styling to text.
  override string styleText(string text) {
    string styledTxt;
    if (_outputType == "RAW") {
      return text;
    }

    if (_outputType != "PLAIN") {
      // Clear text
      /* replaceTags = _replaceTags(...);

            outputTxt = preg_replace_callback(
                "/<(?P<tag>[a-z0-9-_]+)>(?P<text>.*?)<\/(\1)>/ims",
                replaceTags,
                text
           ); */
      if (!styledTxt.isNull) {
        return styledTxt;
      }
    }

    auto tags = _styles.keys.join("|");
    // TODO    auto outputTxt = preg_replace("#</?(?:" ~ tags ~ ")>#", "", styledTxt);
    return styledTxt.isNull ? text : styledTxt;
  }

  unittest {
    auto output = StandardOutput;

    output.outputType("RAW");
    assert(output.outputType == "RAW");
    output.write("RAW: Hallo, world");

    output.outputType("PLAIN");
    assert(output.outputType == "PLAIN");
    // output.write("PLAIN: Hallo, world");

    output.outputType("COLOR");
    assert(output.outputType == "COLOR");
    // output.write("COLOR: Hallo, world");
  }

  // Clean up and close handles
  override void __destruct() {
    /* if (isResource(_output)) {
            fclose(_output);
        } */
  }
}

mixin(OutputCalls!("Standard"));

unittest {
  // TODO
}
