module uim.errors.classes.formatters.formatter;

import uim.errors;

@safe:

unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
}

class DErrorFormatter : IErrorFormatter {
    mixin(ErrorFormatterThis!());

    // Convert a tree of IErrorNode objects into HTML
    protected string export_(IErrorNode nodeToDump, int indentLevel) {
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

    protected string exportArray(DArrayErrorNode tvar, int indentLevel) {
        return null; 
    }

    protected string exportReference(DReferenceErrorNode nodeToConvert, int indentLevel) {
        return null;
    }

    protected string exportClass(DClassErrorNode aNode, int indentLevel) {
        return null;
    }

    protected string exportProperty(DPropertyErrorNode node, int indentLevel) {
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