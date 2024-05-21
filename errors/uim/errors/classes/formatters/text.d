module uim.errors.classes.formatters.text;

import uim.errors;

@safe:

/**
 * A Debugger formatter for generating unstyled plain text output.
 *
 * Provides backwards compatible output with the historical output of
 * `Debugger.exportVar()`
 *
 * @internal
 */
class DTextErrorFormatter : IErrorFormatter {
/*
    string formatWrapper(string acontents, Json[string] location) {
        template = <<<TEXT
%s
########## DEBUG ##########
%s
###########################

TEXT;
        lineInfo = "";
        if (isSet(location["file"], location["file"])) {
            lineInfo = "%s (line %s)".format(location["file"], location["line"]);
        }
        return template.format(lineInfo, contents);
    }
    
    /**
     * Convert a tree of IErrorNode objects into a plain text string.
     * Params:
     * \UIM\Error\Debug\IErrorNode node The node tree to dump.
     */
    string dump(IErrorNode nodeToDump) {
        indentSize = 0;

        return _export_(node, indentSize);
    }
    
    // Convert a tree of IErrorNode objects into a plain text string.
    protected string export_(IErrorNode nodeToDump, int indentSize) {
        if (cast(DScalarNode)nodeToDump) {
            return match (nodeToDump.getType()) {
                "bool": nodeToDump.getValue() ? "true" : "false",
                "null": "null",
                "string": "'" ~ (string)nodeToDump.getValue() ~ "'",
                default: "({nodeToDump.getType()}) {nodeToDump.getValue()}",
            };
        }
        if (cast(DArrayNode)nodeToDump) {
            return _exportArray(nodeToDump, indentSize + 1);
        }
        if (cast(DClassNode)nodeToDump || cast(ReferenceNode)nodeToDump) {
            return _exportObject(nodeToDump, indentSize + 1);
        }
        if (cast(DSpecialNode)nodeToDump ) {
            return nodeToDump.getValue();
        }
        throw new DInvalidArgumentException("Unknown node received " ~ nodeToDump.classname);
    }
    
    // Export an array type object
    protected string exportArray(ArrayNode nodeToExport, int indentSize) {
        auto result = "[";
        auto mybreak = "\n" ~ str_repeat("  ", indentSize);
        auto myend = "\n" ~ str_repeat("  ", indentSize - 1);
        auto myvars = null;

        foreach (anItem; nodeToExport.getChildren()) {
            auto val = anItem.getValue();
            aNodes ~= break ~ this.export_(anItem.getKey(), indentSize) ~ ": " ~ this.export_(val, indentSize);
        }
        if (count(aNodes)) {
            return result ~ join(",", aNodes) ~ end ~ "]";
        }
        return result ~ "]";
    }
    
    /**
     * Handles object to string conversion.
     * Params:
     * \UIM\Error\Debug\ClassNode|\UIM\Error\Debug\ReferenceNode nodeToConvert Object to convert.
     * @param int indentSize Current indentation level.
     */
    protected string exportObject(ClassNode|ReferenceNode nodeToConvert, int indentSize) {
        return "object({nodeToConvert.getValue()}) id:{nodeToConvert.getId()} {}";
    }
    protected string exportObject(ClassNode aNode, int indentSize) {
        auto result = "";

        result ~= "object({aNode.getValue()}) id:{aNode.getId()} {";
        auto myBreak = "\n" ~ str_repeat("  ", indentSize);
        auto myEnd = "\n" ~ str_repeat("  ", indentSize - 1) ~ "}";

        auto props = aNode.getChildren()
            .map!(property => exportProperty(property, indentSize))
            .array;

        if (count(props)) {
            return result ~ myBreak ~ join(myBreak, props) ~ myEnd;
        }
        return result ~ "}";
    }
    protected string exportProperty(auto property, int indentSize) {
        auto propVisibility = property.getVisibility();
        auto propName = property.name;

        return propVisibility && propVisibility != "public" 
            ? "[{propVisibility}] {propName}: " ~ this.export_(property.getValue(), indentSize);
            : "{propName}: " ~ this.export_(property.getValue(), indentSize);
    } */
}
