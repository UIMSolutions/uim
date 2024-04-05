module uim.errors.classes.formatters.html;

import uim.errors;

@safe:
/**
 * A Debugger formatter for generating interactive styled HTML output.
 *
 * @internal
 */
class DHtmlErrorFormatter : IErrorFormatter {
    protected static bool outputHeader = false;

    /**
     * Random id so that HTML ids are not shared between dump outputs.
     * /
    protected string aid;

    /**
     * Constructor.
     * /
    this() {
        this.id = uniqid("", true);
    }
    
    /**
     * Check if the current environment is not a CLI context
     * /
    static bool environmentMatches() {
        if (UIM_SAPI == "cli" || UIM_SAPI == "phpdbg") {
            return false;
        }
        return true;
    }
 
    auto formatWrapper(string acontents, array location) {
        string alineInfo = "";
        if (isSet(location["file"], location["file"])) {
            lineInfo = "<span><strong>%s</strong> (line <strong>%s</strong>)</span>"
                .format(location["file"], location["line"]);
        }
        someParts = [
            "<div class="cake-debug-output cake-debug" style="direction:ltr">",
            lineInfo,
            contents,
            "</div>",
        ];

        return join("\n", someParts);
    }
    
    /**
     * Generate the CSS and Javascript for dumps
     *
     * Only output once per process as we don`t need it more than once.
     * /
    protected string dumpHeader() {
        ob_start();
        include __DIR__~ DIRECTORY_SEPARATOR ~ "dumpHeader.html";

        return to!string(ob_get_clean());
    }
    
    /**
     * Convert a tree of INode objects into HTML
     * Params:
     * \UIM\Error\Debug\INode node The node tree to dump.
     * /
    string dump(INode nodeToDump) {
        html = this.export(node, 0);
        head = "";
        if (!outputHeader) {
            outputHeader = true;
            head = this.dumpHeader();
        }
        return head ~ "<div class="cake-debug">" ~ html ~ "</div>";
    }
    
    /**
     * Convert a tree of INode objects into HTML
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
        if (cast(DSpecialNode)var ) {
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
    protected string exportArray(ArrayNode var, int  anIndent) {
        open = "<span class="cake-debug-array">' .
            this.style("punct", "[") .
            '<samp class="cake-debug-array-items">";
        vars = [];
        break = "\n" ~ str_repeat("  ",  anIndent);
        endBreak = "\n" ~ str_repeat("  ",  anIndent - 1);

        arrow = this.style("punct", ": ");
        var.getChildren().each!((item) {
            val =  anItem.getValue();
            vars ~= break ~ "<span class=\"cake-debug-array-item\">" ~
                this.export(item.getKey(),  anIndent) ~ arrow ~ this.export(val,  anIndent) ~
                this.style("punct", ",") ~ "</span>";
        });

        close = "</samp>" ~
            endBreak ~
            this.style("punct", "]") ~
            "</span>";

        return open ~ join("", vars) ~ close;
    }
    
    /**
     * Handles object to string conversion.
     * Params:
     * \UIM\Error\Debug\ClassNode|\UIM\Error\Debug\ReferenceNode var Object to convert.
     * @param int  anIndent The current indentation level.
     * /
    protected string exportObject(ClassNode|ReferenceNode var, int  anIndent) {
        objectId = "cake-db-object-{this.id}-{var.getId()}";
        result = "<span class="cake-debug-object" id="%s">".format(objectId);
        break = "\n" ~ str_repeat("  ",  anIndent);
        endBreak = "\n" ~ str_repeat("  ",  anIndent - 1);

        if (cast(ReferenceNode)var) {
            link = "<a class="cake-debug-ref" href="#%s">id: %s</a>"
                .format(objectId, var.getId());

            return "<span class="cake-debug-ref">' .
                this.style("punct", "object(") .
                this.style("class", var.getValue()) .
                this.style("punct", ") ") .
                link .
                this.style("punct", " {}") .
                '</span>";
        }
         result ~= this.style("punct", "object(") .
            this.style("class", var.getValue()) .
            this.style("punct", ") id:") .
            this.style("number", (string)var.getId()) .
            this.style("punct", " {") .
            '<samp class="cake-debug-object-props">";

        props = [];
        foreach (var.getChildren() as  aProperty) {
            arrow = this.style("punct", ": ");
            visibility =  aProperty.getVisibility();
            name =  aProperty.name;
            if (visibility && visibility != "public") {
                props ~= break .
                    '<span class="cake-debug-prop">' .
                    this.style("visibility", visibility) .
                    ' ' .
                    this.style("property", name) .
                    arrow .
                    this.export(aProperty.getValue(),  anIndent) .
                '</span>";
            } else {
                props ~= break .
                    '<span class="cake-debug-prop">' .
                    this.style("property", name) .
                    arrow .
                    this.export(aProperty.getValue(),  anIndent) .
                    '</span>";
            }
        }
        end = "</samp>' .
            endBreak .
            this.style("punct", "}") .
            '</span>";

        if (count(props)) {
            return result ~ join("", props) ~ end;
        }
        return result ~ end;
    }
    
    /**
     * Style text with HTML class names
     * Params:
     * string astyle The style name to use.
     * @param string atext The text to style.
     * /
    protected string style(string astyle, string atext) {
        return "<span class="cake-debug-%s">%s</span>"
            .format(style, htmlAttribEscape(text));
    } */
}
