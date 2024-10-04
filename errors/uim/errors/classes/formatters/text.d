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
        string templateTxt = "<<<TEXT
%s
########## DEBUG ##########
%s
###########################

TEXT";
        string lineInfo = "";
        if (location.hasAllKeys("file", "line")) {
            lineInfo = "%s (line %s)".format(location.getString("file"), location.getString("line"));
        }
        return templateTxt.format(lineInfo, content); 
    }

    // Convert a tree of IErrorNode objects into a plain text string.
    override string dump(IErrorNode node) {
        auto indentlevel = 0;

        return export_(node, indentlevel);
    }

    // #region export
    protected string exportArray(DArrayErrorNode node, size_t indentLevel) {
        auto result = "[";
        auto breakTxt = "\n" ~ repeat("  ", indentlevel);
        auto endtxt = "\n" ~ repeat("  ", indentlevel - 1);
        
        auto vars = node.getChildren()
            .map!(item => breakTxt ~ export_(item.getKey(), indentlevel) ~ ": " ~ export_(item.getValue, indentlevel))
            .array;
        
        return !nodes.isEmpty
            ? result ~ join(",", nodes) ~ end ~ "]"
            : result ~ "]";
    }

    protected string exportReference(DReferenceErrorNode node, size_t indentLevel) {
        return "object({node.getValue()}) id:{node.id()} {}";
    }

    protected string exportClass(DClassErrorNode node, size_t indentLevel) {
        string result = "object({"~node.getValue()~"}) id:{"~node.id()~"} {";
        auto breakTxt = "\n" ~ repeat("  ", indentlevel);
        auto endTxt = "\n" ~ repeat("  ", indentlevel - 1) ~ "}";

        auto props = node.getChildren()
            .map!(property => exportProperty(property, indentlevel))
            .array;

        return !props.isEmpty
            ? result ~ breakTxt ~ props.join(breakTxt) ~ endTxt
            : result ~ "}";
    }

    protected string exportProperty(DPropertyErrorNode node, size_t indentLevel) {
        /* auto propVisibility = property.getVisibility();
        auto propName = property.name;

        return propVisibility && propVisibility != "public" 
            ? "[{propVisibility}] {propName}: " ~ export_(property.getValue(), indentlevel);
            : "{propName}: " ~ export_(property.getValue(), indentlevel); */
        return null;
    }

    protected string exportScalar(DScalarErrorNode node, size_t indentLevel) {
        switch (node.getType()) {
            case "bool": 
                return node.getValue() ? "true" : "false";
            case "null": 
                return "null";
            case "string": 
                return "'" ~ (string)node.getValue() ~ "'";
            default: 
                return "({node.getType()}) {node.getValue()}";
        }
    }

    protected string exportSpecial(DSpecialErrorNode node, size_t indentLevel) {
        return null;
    }
    // #endregion export
}
