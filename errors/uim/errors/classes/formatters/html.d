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

    // Random id so that HTML ids are not shared between dump outputs.
    protected string _id;

    this() {
        // TODO _id = uniqid("", true);
    }
    
    // Check if the current environment is not a CLI context
    static bool environmentMatches() {
        return UIM_SAPI == "cli" || UIM_SAPI == "Ddbg"  
            ? false
            : true;
    }
 
    string formatWrapper(string acontents, Json[string] location) {
        string lineInfo = "";
        if (location.hasAllKeys("file", "line")) {
            lineInfo = htmlDoubleTag("span", "<strong>{file}</strong> (line <strong>{line}</strong>)")
                .moustache(location, ["file", "line"]);
        }
        
        return [
            `<div class="uim-debug-output uim-debug" style="direction:ltr">`,
            lineInfo,
            contents,
            "</div>",
        ].join("\n");
    }
    
    /**
     * Generate the CSS and Javascript for dumps
     *
     * Only output once per process as we don`t need it more than once.
     */
    protected string dumpHeader() {
        ob_start();
        include __DIR__~ DIRECTORY_SEPARATOR ~ "dumpHeader.html";

        return to!string(ob_get_clean());
    }
    
    // Convert a tree of IErrorNode objects into HTML
    string dump(IErrorNode nodeToDump) {
        auto content = export_(nodeToDump, 0);
        string head = "";
        if (!outputHeader) {
            outputHeader = true;
            head = this.dumpHeader();
        }
        return head ~ htmlDoubleTag("div", ["uim-debug"], content);
    }
    
    /**
     * Convert a tree of IErrorNode objects into HTML
     * Params:
     * \UIM\Error\Debug\IErrorNode var The node tree to dump.
     * @param int indentLevel The current indentation level.
     */
    protected string export_(IErrorNode var, int indentLevel) {
        if (cast(DScalarNode)var) {
            return match (var.getType()) {
                "bool":style("const", var.getValue() ? "true" : "false"),
                "null":style("const", "null"),
                "string":style("string", "'" ~ (string)var.getValue() ~ "'"),
                "int", "float":style("visibility", "({var.getType()})") ~
                        " " ~style("number", "{var.getValue()}"),
                default: "({var.getType()}) {var.getValue()}",
            };
        }
        if (cast(DArrayNode)var) {
            return _exportArray(var,  indentLevel + 1);
        }
        if (cast(DClassNode)var || cast(ReferenceNode)var) {
            return _exportObject(var,  indentLevel + 1);
        }
        if (cast(DSpecialNode)var) {
            return _style("special", var.getValue());
        }
        throw new DInvalidArgumentException("Unknown node received " ~ var.classname);
    }
    
    /**
     * Export an array type object
     * Params:
     * \UIM\Error\Debug\ArrayNode var The array to export.
     */
    protected string exportArray(ArrayNode tvar, int indentLevel) {
        auto open = "<span class="uim-debug-array">" ~
           style("punct", "[") ~
            "<samp class="uim-debug-array-items">";
        auto vars = null;
        auto breakText = "\n" ~ str_repeat("  ",  indentLevel);
        auto endBreak = "\n" ~ str_repeat("  ",  indentLevel - 1);

        auto arrow = style("punct", ": ");
        var.getChildren().each!((item) {
            val = anItem.getValue();
            vars ~= breakText ~ htmlDoubleTag("span", ["uim-debug-array-item"], 
                export_(item.getKey(),  indentLevel) ~ arrow ~ export_(val,  indentLevel) ~
                style("punct", ","));
        });

        auto close = "</samp>" ~
            endBreak ~
           style("punct", "]") ~
            "</span>";

        return open ~ vars.join("") ~ close;
    }
    
    /**
     * Handles object to string conversion.
     * Params:
     * \UIM\Error\Debug\ClassNode|\UIM\Error\Debug\ReferenceNode var Object to convert.
     */
    protected string exportObject(ClassNode|ReferenceNode objToConvert, int indentLevel) {
        auto objectId = "uim-db-object-{this.id}-{var.getId()}";
        auto result = "<span class=\"uim-debug-object\" id=\"%s\">".format(objectId);
        auto breakText = "\n" ~ str_repeat("  ",  indentLevel);
        auto endBreak = "\n" ~ str_repeat("  ",  indentLevel - 1);

        if (cast(ReferenceNode)var) {
            auto link = "<a class="uim-debug-ref" href="#%s">id: %s</a>"
                .format(objectId, var.getId());

            return htmlDoubleTag("span", ["uim-debug-ref"], 
               style("punct", "object(") ~
               style("class", var.getValue()) ~
               style("punct", ") ") ~
                link ~
               style("punct", " {}"));
        }
         result ~= style("punct", "object(") ~
           style("class", var.getValue()) ~
           style("punct", ") id:") ~
           style("number", (string)var.getId()) ~
           style("punct", " {") ~
            "<samp class=\"uim-debug-object-props\">";

        auto props = null;
        foreach (aProperty; var.getChildren()) {
            arrow = style("punct", ": ");
            visibility = aProperty.getVisibility();
            name = aProperty.name;
            if (visibility && visibility != "public") {
                props ~= breakText ~
                    htmlDoubleTag("span", ["uim-debug-prop"], 
                    style("visibility", visibility) ~ ' ' ~ style("property", name) ~ arrow ~ export_(aProperty.getValue(),  indentLevel));
            } else {
                props ~= breakText ~
                    htmlDoubleTag("span", ["uim-debug-prop"], 
                    style("property", name) ~ arrow ~ export_(aProperty.getValue(),  indentLevel));
            }
        }
        end = "</samp>" ~
            endBreak ~
            style("punct", "}") ~
            "</span>";

        return count(props)
            ? result ~ props.join("") ~ end
            : result ~ end;
    }
    
    // Style text with HTML class names
    protected string style(string styleToUse, string testToStyle) {
        return htmlDoubletag("span", ["uim-debug-%s"], "%s")
            .format(styleToUse, htmlAttributeEscape(testToStyle));
    }
}
