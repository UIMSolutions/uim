/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.classes.formatters.console;

import uim.errors;

@safe:

unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
}

// Debugger formatter for generating output with ANSI escape codes
class DConsoleFormatter : IErrorFormatter {
    // text colors used in colored output.
    protected STRINGAA styles = [
        // bold yellow
        "const": "1;33",
        // green
        "string": "0;32",
        // bold blue
        "number": "1;34",
        // cyan
        "class": "0;36",
        // grey
        "punct": "0;90",
        // default foreground
        "property": "0;39",
        // magenta
        "visibility": "0;35",
        // red
        "special": "0;31",
    ];

    /**
     * Check if the current environment supports ANSI output.
     */
    static bool environmentMatches() {
        /* if (UIM_SAPI != "cli") {
            return false;
        }
        // NO_COLOR in environment means no color.
        if (enviroment("NO_COLOR")) {
            return false;
        }
        // Windows environment checks
        if (
            DIRECTORY_SEPARATOR == "\\" &&
            !D_uname("v").lower.contains("windows 10") &&
            !strtolower((string)enviroment("SHELL")).contains("bash.exe") &&
            !(bool)enviroment("ANSICON") &&
            enviroment("ConEmuANSI") != "ON"
       ) {
            return false;
        }
        return true; */
        return false;
    }

    string formatWrapper(stringcontents, Json[string] location) {
        string lineInfo = "";
        if (location.hasAllKeys(["file", "line"])) {
            lineInfo = "%s (line %s)".format(location["file"], location["line"]);
        }

        return [
            style("const", lineInfo),
            style("special", "########## DEBUG ##########"),
            contents,
            style("special", "###########################"),
            "",
        ].join("\n");
    }

    // Convert a tree of IErrorNode objects into a plain text string.
    string dump(IErrorNode nodeToDump) {
        size_t myIndent = 0;

        return _export_(nodeToDump, myIndent);
    }

    // Convert a tree of IErrorNode objects into a plain text string.
    protected string export_(IErrorNode nodeTreeToDump, int indentLevel) {
        /* if (cast(DScalarNode)nodeTreeToDump) {
            return match (nodeTreeToDump.getType()) {
                "bool": style("const", nodeTreeToDump.getValue() ? "true" : "false"),
                "null": style("const", "null"),
                "string": style("string", "'" ~ (string)nodeTreeToDump.getValue() ~ "'"),
                "int", "float": style("visibility", "({nodeTreeToDump.getType()})") ~
                        " " ~ style("number", "{nodeTreeToDump.getValue()}"),
                default: "({nodeTreeToDump.getType()}) {nodeTreeToDump.getValue()}",
            };
        }
        if (cast(DArrayNode)nodeTreeToDump) {
            return _exportArray(nodeTreeToDump,  indentLevel + 1);
        }
        if (cast(DClassNode)nodeTreeToDump || cast(ReferenceNode)nodeTreeToDump) {
            return _exportObject(nodeTreeToDump,  indentLevel + 1);
        }
        if (cast(DSpecialNode)nodeTreeToDump) {
            return _style("special", nodeTreeToDump.getValue());
        }
        throw new DInvalidArgumentException("Unknown node received " ~ nodeTreeToDump.classname); */
        return null;
    }

    /**
     * Export an array type object
     * Params:
     * \UIM\Error\Debug\ArrayNode var The array to export.
     */
    protected string exportArray(ArrayNode arrayToExport, int indentLevel) {
        /*  result = style("punct", "[");
        break = "\n" ~ str_repeat("  ",  indentLevel);
        end = "\n" ~ str_repeat("  ",  indentLevel - 1);
        vars = null;

        auto arrow = style("punct", ": ");
        arrayToExport.getChildren().each!((item) {
            auto val = item.getValue();
            vars ~= break ~ export_(item.getKey(),  indentLevel) ~ arrow ~ export_(val,  indentLevel);
        });

        auto close = style("punct", "]");
        return count(vars) > 0
            ? result ~ vars.join(style("punct", ",")) ~ end ~ close
            : result ~ close; */
        return null;
    }

    /**
     * Handles object to string conversion.
     * Params:
     * \UIM\Error\Debug\ClassNode|\UIM\Error\Debug\ReferenceNode var Object to convert.
     */
    protected string exportObject( /* ClassNode| */ DReferenceNode nodeToConvert, int indentLevel) {
        /* string[] props;

        if (cast(ReferenceNode)nodeToConvert) {
            return _style("punct", "object(") ~
                style("class", nodeToConvert.getValue()) ~
                style("punct", ") id:") ~
                style("number", to!string(nodeToConvert.id())) ~
                style("punct", " {}");
        }
         result = style("punct", "object(") ~
            style("class", nodeToConvert.getValue()) ~
            style("punct", ") id:") ~
            style("number", (string)nodeToConvert.id()) ~
            style("punct", " {");

        string breakText = "\n" ~ str_repeat("  ",  indentLevel);
        string endText = "\n" ~ str_repeat("  ",  indentLevel - 1) ~ style("punct", "}");

        arrow = style("punct", ": ");
        foreach (aProperty; nodeToConvert.getChildren()) {
            auto visibility = aProperty.getVisibility();
            auto name = aProperty.name;

            props ~= visibility && visibility != "public" 
                ? style("visibility", visibility) ~ " " ~
                style("property", name) ~ arrow ~
                export_(aProperty.getValue(),  indentLevel)
                : style("property", name) ~  arrow ~
                export_(aProperty.getValue(),  indentLevel);
        }
        if (count(props)) {
            return result ~ breakText ~ props.join(breakText) ~ endText;
        }
        return result ~ style("punct", "}"); */
        return null;
    }

    // Style text with ANSI escape codes.
    protected string style(string styleToUse, string textToStyle) {
        auto code = _styles[styleToUse];

        return "\033[{code}m{textToStyle}\033[0m";
    }
}
