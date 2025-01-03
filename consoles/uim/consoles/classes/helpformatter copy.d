/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.consoles.classes.helpformatter;

import uim.consoles;

@safe:

/**
 * HelpFormatter formats help for console shells. Can format to either
 * text or XML formats. Uses DConsoleOptionParser buildOptionParser methods to generate help.
 *
 * Generally not directly used. Using myParser.help(command, "xml"); is usually
 * how you would access help. Or via the `--help=xml` option on the command line.
 *
 * Xml output is useful for integration with other tools like IDE`s or other build tools.
 */
class DHelpFormatter : UIMObject {
  this() {
    super();
  }

  this(Json[string] initData) {
    super(initData);
  }

  // The maximum number of arguments shown when generating usage.
  protected int _maxArgs = 6;

  // The maximum number of options shown when generating usage.
  protected int _maxOptions = 6;

  // Option parser.
  protected IConsoleOptionParser _parser;
  // Build the help formatter for an OptionParser
  this(IConsoleOptionParser newParser) {
    _parser = newParser;
  }

  // Alias to display in the output.
  protected string _aliasname = "uim";
  void aliasName(string name) {
    _aliasName = name;
  }

    // Get the help as formatted text suitable for output on the command line.
    string text(int withOfOutput = 72) {
  /*
        auto myParser = _parser;
        string[] result;
        auto myDescription = myParser.getDescription();
        if (!myDescription.isEmpty) {
            result ~= Text.wrap(myDescription, withOfOutput);
            result ~= "";
        }
        result ~= htmlDoubleTag("info", "Usage:");
        result ~= _generateUsage();
        result ~= "";

        auto parsedOptions = myParser.options();
        if (parsedOptions) {
            max = _getMaxLength(parsedOptions) + 8;
            result ~= "<info>Options:</info>";
            result ~= "";
            parsedOptions.each!(option => 
                result ~= Text.wrapBlock(option.help(max), [
                    "width": withOfOutput,
                    "indent": " ".repeatTxt(max),
                    "indentAt": 1,
                ]));
            result ~= "";
        }
        auto parserArguments = myParser.arguments();
        if (!parserArguments.isEmpty) {
            max = _getMaxLength(parserArguments) + 2;
            result ~= htmlDoubleTag("info", "Arguments");
            result ~= "";
            parserArguments.each!(argument => 
                result ~= Text.wrapBlock(argument.help(max), [
                    "width": withOfOutput,
                    "indent": repeat(" ", max),
                    "indentAt": 1,
                ]));
            }
            result ~= "";
        }
        
        auto epilog = myParser.getEpilog();
        if (!epilog.isEmpty) {
            result ~= Text.wrap(epilog, withOfOutput)
            result ~= "";
        }
        return result.join("\n"); */
        return null; 
    }
    
    /**
     * Generate the usage for a shell based on its arguments and options.
     * Usage strings favor short options over the long ones. and optional args will
     * be indicated with []
     */
  protected string _generateUsage() {
    string[] usage = [_aliasname ~ " " ~ _parser.getCommand()];
    /*     auto options = _parser.options()
            .map!(options => option.usage())
            .array;
        
        if (count(options) > _maxOptions) {
            options = ["[options]"];
        }

        auto usage = chain(usage, options);
        auto someArguments = _parser.arguments
            .map!(argument => argument.usage())
            .array;

        if (count(someArguments) > _maxArgs) {
            someArguments = ["[arguments]"];
        }
        
        return chain(usage, someArguments).join(" "); */
    return null;
  }

  /**
     * Iterate over a collection and find the longest named thing.
     * Params:
     * array<\UIM\Console\InputOptionConsole|\UIM\Console\> collection The collection to find a max length of.
     */
  protected int _getMaxLength(DInputArgument[] collection) {
    int result = 0;
    /*         collection
            .each!(item => result = max(anItem.name.length, result));
 */
    return result;
  }

  // Get the help as an XML string.
  /* DSimpleXMLElement| * /string xml(bool returnString = true) {
        /* auto myParser = _parser;
        auto xml = new DSimpleXMLElement("<shell></shell>");
         */ /* xml.addChild("command", myParser.getCommand());
        xml.addChild("description", myParser.getDescription());

        auto xmlOptions = xml.addChild("options");
        myParser.options.each!(option => option.xml(xmlOptions));
        
        auto xmlArguments = xml.addChild("arguments");
        myParser.arguments.each!(argument => argument.xml(xmlArguments));

        xml.addChild("epilog", myParser.getEpilog());

        return returnString ? to!string(xml.asXML()) : xml; */
  /*         return null; 
    } 
 */
}
