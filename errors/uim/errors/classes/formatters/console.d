module uim.errors.classes.formatters.console;

import uim.errors;

@safe:

/**
 * A Debugger formatter for generating output with ANSI escape codes
 *
 * @internal
 */
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
     * /
    static bool environmentMatches() {
        if (UIM_SAPI != "cli") {
            return false;
        }
        // NO_COLOR in environment means no color.
        if (enviroment("NO_COLOR")) {
            return false;
        }
        // Windows environment checks
        if (
            DIRECTORY_SEPARATOR == "\\" &&
            !php_uname("v").toLower.has("windows 10") &&
            !strtolower((string)enviroment("SHELL")).has("bash.exe") &&
            !(bool)enviroment("ANSICON") &&
            enviroment("ConEmuANSI") != "ON"
        ) {
            return false;
        }
        return true;
    }
 
    string formatWrapper(string acontents, array location) {
        string alineInfo = "";
        if (isSet(location["file"], location["file"])) {
            lineInfo = "%s (line %s)".format(location["file"], location["line"]);
        }
        someParts = [
            this.style("const", lineInfo),
            this.style("special", "########## DEBUG ##########"),
            contents,
            this.style("special", "###########################"),
            "",
        ];

        return join("\n", someParts);
    }
    
    /**
     * Convert a tree of INode objects into a plain text string.
     * Params:
     * \UIM\Error\Debug\INode node The node tree to dump.
     * /
    string dump(INode nodeToDump) {
        size_t myIndent = 0;

        return this.export(node, myIndent);
    }
    
    /**
     * Convert a tree of INode objects into a plain text string.
     * Params:
     * \UIM\Error\Debug\INode var The node tree to dump.
     * @param int  anIndent The current indentation level.
     * /
    protected string export(INode var, int  anIndent) {
        if (cast(DScalarNode)var) {
            return match (var.getType()) {
                "bool": this.style("const", var.getValue() ? "true" : "false"),
                "null": this.style("const", "null"),
                "string": this.style("string", "'" ~ (string)var.getValue() ~ "'"),
                "int", "float": this.style("visibility", "({var.getType()})") ~
                        " " ~ this.style("number", "{var.getValue()}"),
                default: "({var.getType()}) {var.getValue()}",
            };
        }
        if (cast(ArrayNode)var) {
            return this.exportArray(var,  anIndent + 1);
        }
        if (cast(ClassNode)var || cast(ReferenceNode)var) {
            return this.exportObject(var,  anIndent + 1);
        }
        if (cast(DSpecialNode)var) {
            return this.style("special", var.getValue());
        }
        throw new DInvalidArgumentException("Unknown node received " ~ var.classname);
    }
    
    /**
     * Export an array type object
     * Params:
     * \UIM\Error\Debug\ArrayNode var The array to export.
     * @param int  anIndent The current indentation level.
     * /
    protected string exportArray(ArrayNode arrayToExport, int  anIndent) {
         result = this.style("punct", "[");
        break = "\n" ~ str_repeat("  ",  anIndent);
        end = "\n" ~ str_repeat("  ",  anIndent - 1);
        vars = [];

        auto arrow = this.style("punct", ": ");
        arrayToExport.getChildren().each!((item) {
            auto val =  item.getValue();
            vars ~= break ~ this.export(item.getKey(),  anIndent) ~ arrow ~ this.export(val,  anIndent);
        });

        auto close = this.style("punct", "]");
        if (count(vars)) {
            return result ~ join(this.style("punct", ","), vars) ~ end ~ close;
        }
        return result ~ close;
    }
    
    /**
     * Handles object to string conversion.
     * Params:
     * \UIM\Error\Debug\ClassNode|\UIM\Error\Debug\ReferenceNode var Object to convert.
     * @param int  anIndent Current indentation level.
     * /
    protected string exportObject(ClassNode|ReferenceNode var, int  anIndent) {
        props = [];

        if (cast(ReferenceNode)var) {
            return this.style("punct", "object(") ~
                this.style("class", var.getValue()) ~
                this.style("punct", ") id:") ~
                this.style("number", to!string(var.getId())) ~
                this.style("punct", " {}");
        }
         result = this.style("punct", "object(") ~
            this.style("class", var.getValue()) ~
            this.style("punct", ") id:") ~
            this.style("number", (string)var.getId()) ~
            this.style("punct", " {");

        break = "\n" ~ str_repeat("  ",  anIndent);
        end = "\n" ~ str_repeat("  ",  anIndent - 1) ~ this.style("punct", "}");

        arrow = this.style("punct", ": ");
        foreach (aProperty; var.getChildren()) {
            auto visibility =  aProperty.getVisibility();
            auto name =  aProperty.name;

            props ~= visibility && visibility != "public" 
                ? this.style("visibility", visibility) ~ " " ~
                this.style("property", name) ~ arrow ~
                this.export(aProperty.getValue(),  anIndent)
                : this.style("property", name) ~  arrow ~
                this.export(aProperty.getValue(),  anIndent);
        }
        if (count(props)) {
            return result ~ break ~ join(break, props) ~ end;
        }
        return result ~ this.style("punct", "}");
    }
    
    /**
     * Style text with ANSI escape codes.
     * Params:
     * string astyle The style name to use.
     * @param string atext The text to style.
     * /
    protected string style(string astyle, string atext) {
        code = this.styles[style];

        return "\033[{code}m{text}\033[0m";
    } */
}
