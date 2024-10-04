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

    // Convert a tree of IErrorNode objects into a plain text string.
    override string dump(IErrorNode nodeToDump) {
        auto indentlevel = 0;

        return _export_(node, indentlevel);
    }

    // #region export
    protected string exportArray(DArrayErrorNode tvar, uint indentLevel) {
        auto result = "[";
        auto breakTxt = "\n" ~ repeat("  ", indentlevel);
        auto myend = "\n" ~ repeat("  ", indentlevel - 1);
        auto myvars = null;

        foreach (anItem; nodeToExport.getChildren()) {
            auto val = anItem.getValue();
            aNodes ~= breakTxt ~ this.export_(anItem.getKey(), indentlevel) ~ ": " ~ this.export_(val, indentlevel);
        }
        if (count(aNodes)) {
            return result ~ join(",", aNodes) ~ end ~ "]";
        }
        return result ~ "]";
    }

    protected string exportReference(DReferenceErrorNode nodeToConvert, uint indentLevel) {
        return "object({nodeToConvert.getValue()}) id:{nodeToConvert.id()} {}";
    }

    protected string exportClass(DClassErrorNode aNode, uint indentLevel) {
        string result = "object({aNode.getValue()}) id:{aNode.id()} {";
        auto breakTxt = "\n" ~ repeat("  ", indentlevel);
        auto myEnd = "\n" ~ repeat("  ", indentlevel - 1) ~ "}";

        auto props = aNode.getChildren()
            .map!(property => exportProperty(property, indentlevel))
            .array;

        if (count(props)) {
            return result ~ breakTxt ~ props.join(breakTxt) ~ myEnd;
        }
        return result ~ "}";
    }

    protected string exportProperty(DPropertyErrorNode node, uint indentLevel) {
        /* auto propVisibility = property.getVisibility();
        auto propName = property.name;

        return propVisibility && propVisibility != "public" 
            ? "[{propVisibility}] {propName}: " ~ this.export_(property.getValue(), indentlevel);
            : "{propName}: " ~ this.export_(property.getValue(), indentlevel); */
        return null;
    }

    protected string exportScalar(DScalarErrorNode node, uint indentLevel) {
        /* return match (nodeToDump.getType()) {
                "bool": nodeToDump.getValue() ? "true" : "false",
                "null": "null",
                "string": "'" ~ (string)nodeToDump.getValue() ~ "'",
                default: "({nodeToDump.getType()}) {nodeToDump.getValue()}",
            }; */
        return null;
    }

    protected string exportSpecial(DSpecialErrorNode node, uint indentLevel) {
        return null;
    }
    // #endregion export
}
