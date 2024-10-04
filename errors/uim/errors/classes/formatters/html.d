/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.classes.formatters.html;

import uim.errors;

@safe:

unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
}

/**
 * A Debugger formatter for generating interactive styled HTML output.
 *
 * @internal
 */
class DHtmlErrorFormatter : IErrorFormatter {
    mixin(ErrorFormatterThis!("Html"));

    protected static bool outputHeader = false;

    // Random id so that HTML ids are not shared between dump outputs.
    protected string _id;

    this() {
        // TODO _id = uniqid("", true);
    }

    // Check if the current environment is not a CLI context
    static bool environmentMatches() {
        return UIM_SAPI == "cli" || UIM_SAPI == "Ddbg"
            ? false : true;
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
        /* ob_start();
        include __DIR__~ DIRECTORY_SEPARATOR ~ "dumpHeader.html";

        return to!string(ob_get_clean()); */
        return null;
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

    // Convert a tree of IErrorNode objects into HTML
    protected string export_(IErrorNode nodeToDump, int indentLevel) {
        if (cast(DScalarErrorNode)nodeToDump) {
/*             return match (nodeToDump.getType()) {
                "bool":style("const", nodeToDump.getValue() ? "true" : "false"),
                "null":style("const", "null"),
                "string":style("string", "'" ~ (string)nodeToDump.getValue() ~ "'"),
                "int", "float":style("visibility", "({nodeToDump.getType()})") ~
                        " " ~style("number", "{nodeToDump.getValue()}"),
                default: "({nodeToDump.getType()}) {nodeToDump.getValue()}",
            };
 */        
        }
        if (cast(DArrayErrorNode)nodeToDump) {
            // return _exportArray(nodeToDump,  indentLevel + 1);
        }
        if (cast(DClassErrorNode)nodeToDump || cast(DReferenceErrorNode)nodeToDump) {
            // return _exportObject(nodeToDump,  indentLevel + 1);
        }
        if (cast(DSpecialErrorNode)nodeToDump) {
            // return _style("special", nodeToDump.getValue());
        }
        throw new DInvalidArgumentException("Unknown node received " ~ nodeToDump.classname); */
        return null;
    }

    // Export an array type object
    protected string exportArray(DArrayErrorNode tvar, int indentLevel) {
        /* auto open = "<span class="uim-debug-array">" ~
           style("punct", "[") ~
            "<samp class="uim-debug-array-items">";
        auto vars = null;
        auto breakText = "\n" ~ str_repeat("  ",  indentLevel);
        auto endBreak = "\n" ~ str_repeat("  ",  indentLevel - 1);

        auto arrow = style("punct", ": ");
        nodeToExport.getChildren().each!((item) {
            val = anItem.getValue();
            vars ~= breakText ~ htmlDoubleTag("span", ["uim-debug-array-item"], 
                export_(item.getKey(),  indentLevel) ~ arrow ~ export_(val,  indentLevel) ~
                style("punct", ","));
        });

        auto close = "</samp>" ~
            endBreak ~
           style("punct", "]") ~
            "</span>";

        return open ~ vars.join("") ~ close; */
        return null;
    }

    // Handles object to string conversion.
    protected string exportObject( /* ClassErrorNode| */ DReferenceErrorNode nodeToConvert, int indentLevel) {
        /* auto objectId = "uim-db-object-{this.id}-{nodeToConvert.id()}";
        auto result = "<span class=\"uim-debug-object\" id=\"%s\">".format(objectId);
        auto breakText = "\n" ~ str_repeat("  ",  indentLevel);
        auto endBreak = "\n" ~ str_repeat("  ",  indentLevel - 1);

        if (cast(DReferenceErrorNode)nodeToConvert) {
            auto link = "<a class="uim-debug-ref" href="#%s">id: %s</a>"
                .format(objectId, nodeToConvert.id());

            return htmlDoubleTag("span", ["uim-debug-ref"], 
               style("punct", "object(") ~
               style("class", nodeToConvert.getValue()) ~
               style("punct", ") ") ~
                link ~
               style("punct", " {}"));
        }
         result ~= style("punct", "object(") ~
           style("class", nodeToConvert.getValue()) ~
           style("punct", ") id:") ~
           style("number", (string)nodeToConvert.id()) ~
           style("punct", " {") ~
            "<samp class=\"uim-debug-object-props\">";

        string[] props = null;
        foreach (aProperty; nodeToConvert.getChildren()) {
            auto arrow = style("punct", ": ");
            auto visibility = aProperty.getVisibility();
            auto name = aProperty.name;
            props ~= visibility && visibility != "public"
                ? breakText ~
                    htmlDoubleTag("span", ["uim-debug-prop"], 
                    style("visibility", visibility) ~ ' ' ~ style("property", name) ~ arrow ~ export_(aProperty.getValue(),  indentLevel))
                : breakText ~
                    htmlDoubleTag("span", ["uim-debug-prop"], 
                    style("property", name) ~ arrow ~ export_(aProperty.getValue(),  indentLevel));
        }
        end = "</samp>" ~
            endBreak ~
            style("punct", "}") ~
            "</span>";

        return count(props)
            ? result ~ props.join("") ~ end
            : result ~ end; */
        return null;
    }

    // Style text with HTML class names
    protected string style(string styleToUse, string testToStyle) {
        return htmlDoubletag("span", ["uim-debug-%s"], "%s")
            .format(styleToUse, htmlAttributeEscape(testToStyle));
    }
}
