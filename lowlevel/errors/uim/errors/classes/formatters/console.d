/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.classes.formatters.console;

import uim.errors;
@safe:

version (test_uim_errors) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

// Debugger formatter for generating output with ANSI escape codes
class DConsoleErrorFormatter : DErrorFormatter {
    mixin(ErrorFormatterThis!("Console"));

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

    string formatWrapper(string contents, Json[string] location) {
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
    override string dump(IErrorNode node) {
        size_t indentLevel = 0;
        return export_(node, indentLevel);
    }

    // #region export 
    // Export an array type object
    override protected string exportArray(DArrayErrorNode node, size_t indentLevel) {
        auto result = style("punct", "[");
        auto breakTxt = "\n" ~" ".repeatTxt(indentLevel);
        auto endTxt = "\n" ~" ".repeatTxt(indentLevel - 1);

/*         auto arrowTxt = style("punct", ": ");
        auto vars = node.getChildren()
            .map!(item => breakTxt ~ export_(item.getKey(), indentLevel) ~ arrowTxt ~ export_(item.value(), indentLevel))
            .array;

        auto closeTxt = style("punct", "]");
        return !vars.isEmpty
            ? result ~ vars.join(style("punct", ",")) ~ endTxt ~ closeTxt : result ~ closeTxt; */
        return null;
    }

    override protected string exportReference(DReferenceErrorNode node, size_t indentLevel) {
        // object(xxx) id: xxx{}
        /* return _style("punct", "object(") ~
            style("class", node.value()) ~
            style("punct", ") id:") ~
            style("number", to!string(node.id())) ~
            style("punct", " {}"); */
        return null;
    }

    override protected string exportClass(DClassErrorNode node, size_t indentLevel) {
        string[] props;

/*         result = style("punct", "object(") ~
            style("class", node.value()) ~
            style("punct", ") id:") ~
            style("number", to!string(node.id())) ~ style("punct", " {");
        string breakTxt = "\n" ~" ".repeatTxt(indentLevel);
        string endTxt = "\n" ~" ".repeatTxt(indentLevel - 1) ~ style("punct", "}");

        arrow = style("punct", ": ");
        foreach (prop; node.getChildren()) {
            auto visibility = prop.getVisibility();
            auto name = prop.name;

            props ~= visibility && visibility != "public"
                ? style("visibility", visibility) ~ " " ~
                style("property", name) ~ arrow ~
                export_(prop.value(), indentLevel) : style("property", name) ~ arrow ~
                export_(
                    prop.value(), indentLevel);
        }
        
        return props.count > 0
            ? result ~ breakTxt ~ props.join(breakTxt) ~ endTxt
            : result ~ style("punct", "}"); */
        
        return null;
    }

    override protected string exportProperty(DPropertyErrorNode node, size_t indentLevel) {
        return null;
    }

    override protected string exportScalar(DScalarErrorNode node, size_t indentLevel) {
       /*  switch (node.getType()) {
        case "bool":
            return style("const", node.getBoolean() ? "true" : "false");
        case "null":
            return style("const", "null");
        case "string":
            return style("string", "'" ~ node.getString() ~ "'");
        case "int", "float":
            return style("visibility", "({node.getType()})") ~ " " ~ style("number", "{node.value()}");
        default:
            return "({node.getType()}) {node.value()}";
        }; */
        return null; 
    }

    override protected string exportSpecial(
        DSpecialErrorNode node, size_t indentLevel) {
        return null;
    }
    // #endregion export 

    // Style text with ANSI escape codes.
    protected string style(string styleToUse, string textToStyle) {
        /* auto code = _styles[styleToUse];
        return "\033[{code}m{textToStyle}\033[0m"; */
        return null; 
    }
}
