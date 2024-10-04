/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.classes.formatters.text;

import uim.errors;

@safe:

unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
}

/**
 * A Debugger formatter for generating unstyled plain text output.
 *
 * Provides backwards compatible output with the historical output of
 * `Debugger.exportVar()`
 *
 * @internal
 */
class DTextErrorFormatter : DErrorFormatter {
    mixin(ErrorFormatterThis!("Text"));

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
        indentlevel = 0;

        return _export_(node, indentlevel);
    }

    // Convert a tree of IErrorNode objects into a plain text string.
    protected string export_(IErrorNode nodeToDump, int indentlevel) {
        if (cast(DScalarErrorNode) nodeToDump) {
            /*             return match (nodeToDump.getType()) {
                "bool": nodeToDump.getValue() ? "true" : "false",
                "null": "null",
                "string": "'" ~ (string)nodeToDump.getValue() ~ "'",
                default: "({nodeToDump.getType()}) {nodeToDump.getValue()}",
            };
 */
        }
        if (cast(DArrayErrorNode) nodeToDump) {
            // return _exportArray(nodeToDump, indentlevel + 1);
        }
        if (cast(DClassErrorNode) nodeToDump || cast(DReferenceErrorNode) nodeToDump) {
            // return _exportObject(nodeToDump, indentlevel + 1);
        }
        if (cast(DSpecialErrorNode) nodeToDump) {
            // return nodeToDump.getValue();
        }
        throw new DInvalidArgumentException("Unknown node received " ~ nodeToDump.classname);

        return null;
    }

    protected string exportArray(DArrayErrorNode tvar, int indentLevel) {
        auto result = "[";
        auto breakText = "\n" ~ repeat("  ", indentlevel);
        auto myend = "\n" ~ repeat("  ", indentlevel - 1);
        auto myvars = null;

        foreach (anItem; nodeToExport.getChildren()) {
            auto val = anItem.getValue();
            aNodes ~= breakText ~ this.export_(anItem.getKey(), indentlevel) ~ ": " ~ this.export_(val, indentlevel);
        }
        if (count(aNodes)) {
            return result ~ join(",", aNodes) ~ end ~ "]";
        }
        return result ~ "]";
    }

    protected string exportReference(DReferenceErrorNode nodeToConvert, int indentLevel) {
        return "object({nodeToConvert.getValue()}) id:{nodeToConvert.id()} {}";
    }

    protected string exportClass(DClassErrorNode aNode, int indentLevel) {
        string result = "object({aNode.getValue()}) id:{aNode.id()} {";
        auto breakText = "\n" ~ repeat("  ", indentlevel);
        auto myEnd = "\n" ~ repeat("  ", indentlevel - 1) ~ "}";

        auto props = aNode.getChildren()
            .map!(property => exportProperty(property, indentlevel))
            .array;

        if (count(props)) {
            return result ~ breakText ~ props.join(breakText) ~ myEnd;
        }
        return result ~ "}";
    }

    protected string exportProperty(DPropertyErrorNode node, int indentLevel) {
        /* auto propVisibility = property.getVisibility();
        auto propName = property.name;

        return propVisibility && propVisibility != "public" 
            ? "[{propVisibility}] {propName}: " ~ this.export_(property.getValue(), indentlevel);
            : "{propName}: " ~ this.export_(property.getValue(), indentlevel); */
        return null;
    }

    protected string exportScalar(DScalarErrorNode node, int indentLevel) {
        return null;
    }

    protected string exportSpecial(DSpecialErrorNode node, int indentLevel) {
        return null;
    }
    // #endregion export
}
