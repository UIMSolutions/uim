/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.classes.formatters.text;

import uim.errors;

@safe:

unittest {
  writeln("-----  ", __MODULE__ , "\t  -----");
}

/**
 * A Debugger formatter for generating unstyled plain text output.
 *
 * Provides backwards compatible output with the historical output of
 * `Debugger.exportVar()`
 *
 * @internal
 */
class DTextErrorFormatter : IErrorFormatter {

    string formatWrapper(string content, Json[string] location) {
        /* templateText = <<<TEXT
%s
########## DEBUG ##########
%s
###########################

TEXT;
        lineInfo = "";
        if (location.hasAllKeys("file", "line")) {
            lineInfo = "%s (line %s)".format(location.getString("file"), location.getString("line"));
        }
        return template.format(lineInfo, content); */
        return null; 
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
        /* if (cast(DScalarNode)nodeToDump) {
            return match (nodeToDump.getType()) {
                "bool": nodeToDump.getValue() ? "true" : "false",
                "null": "null",
                "string": "'" ~ (string)nodeToDump.getValue() ~ "'",
                default: "({nodeToDump.getType()}) {nodeToDump.getValue()}",
            };
        }
        if (cast(DArrayErrorNode)nodeToDump) {
            return _exportArray(nodeToDump, indentSize + 1);
        }
        if (cast(DClassNode)nodeToDump || cast(DReferenceNode)nodeToDump) {
            return _exportObject(nodeToDump, indentSize + 1);
        }
        if (cast(DSpecialNode)nodeToDump) {
            return nodeToDump.getValue();
        }
        throw new DInvalidArgumentException("Unknown node received " ~ nodeToDump.classname); */
        return null; 
    }
    
    // Export an array type object
    protected string exportArray(IArrayNode nodeToExport, int indentSize) {
        auto result = "[";
        auto breakText = "\n" ~ str_repeat("  ", indentSize);
        auto myend = "\n" ~ str_repeat("  ", indentSize - 1);
        auto myvars = null;

        foreach (anItem; nodeToExport.getChildren()) {
            auto val = anItem.getValue();
            aNodes ~= breakText ~ this.export_(anItem.getKey(), indentSize) ~ ": " ~ this.export_(val, indentSize);
        }
        if (count(aNodes)) {
            return result ~ join(",", aNodes) ~ end ~ "]";
        }
        return result ~ "]";
    }
    
    // Handles object to string conversion.
    protected string exportObject(IReferenceNode nodeToConvert, int indentSize) {
        return "object({nodeToConvert.getValue()}) id:{nodeToConvert.id()} {}";
    }

    protected string exportObject(IClassNode aNode, int indentSize) {
        string result = "";

        result ~= "object({aNode.getValue()}) id:{aNode.id()} {";
        auto breakText = "\n" ~ str_repeat("  ", indentSize);
        auto myEnd = "\n" ~ str_repeat("  ", indentSize - 1) ~ "}";

        auto props = aNode.getChildren()
            .map!(property => exportProperty(property, indentSize))
            .array;

        if (count(props)) {
            return result ~ breakText ~ props.join(breakText) ~ myEnd;
        }
        return result ~ "}";
    }
    protected string exportProperty(auto property, int indentSize) {
        /* auto propVisibility = property.getVisibility();
        auto propName = property.name;

        return propVisibility && propVisibility != "public" 
            ? "[{propVisibility}] {propName}: " ~ this.export_(property.getValue(), indentSize);
            : "{propName}: " ~ this.export_(property.getValue(), indentSize); */
        return null; 
    } 
}
