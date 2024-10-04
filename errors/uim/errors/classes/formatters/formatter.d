module uim.errors.classes.formatters.formatter;

import uim.errors;

@safe:

unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
}

class DErrorFormatter : IErrorFormatter {
    mixin(ErrorFormatterThis!());

    // Convert a tree of IErrorNode objects into a plain text string.
    string dump(IErrorNode node) {
        return null; 
    }

    // Convert a tree of IErrorNode objects into HTML
    protected string export_(IErrorNode nodeToDump, uint indentLevel) {
        if (cast(DArrayErrorNode)nodeToDump) {
            return exportArray(cast(DArrayErrorNode)nodeToDump, indentLevel + 1);
        }
        if (cast(DClassErrorNode)nodeToDump) {
            return exportClass(cast(DClassErrorNode)nodeToDump, indentLevel + 1);
        }
        if (cast(DReferenceErrorNode)nodeToDump) {
            return exportReference(cast(DReferenceErrorNode)nodeToDump, indentLevel + 1);
        }
        if (cast(DPropertyErrorNode)nodeToDump) {
            return exportProperty(cast(DPropertyErrorNode)nodeToDump, indentLevel + 1);
        }
        if (cast(DScalarErrorNode)nodeToDump) {
            return exportScalar(cast(DScalarErrorNode)nodeToDump, indentLevel + 1);
        }
        if (cast(DSpecialErrorNode)nodeToDump) {
            return exportSpecial(cast(DSpecialErrorNode)nodeToDump, indentLevel + 1);
        }
        throw new DInvalidArgumentException("Unknown node received " ~ nodeToDump.classname);
    }

    protected string exportArray(DArrayErrorNode tvar, uint indentLevel) {
        return null; 
    }

    protected string exportReference(DReferenceErrorNode nodeToConvert, uint indentLevel) {
        return null;
    }

    protected string exportClass(DClassErrorNode aNode, uint indentLevel) {
        return null;
    }

    protected string exportProperty(DPropertyErrorNode node, uint indentLevel) {
        return null;
    }

    protected string exportScalar(DScalarErrorNode node, uint indentLevel) {
        return null;
    }

    protected string exportSpecial(DSpecialErrorNode node, uint indentLevel) {
        return null;
    }
    // #endregion export
}