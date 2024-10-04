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
            return exportArray(cast(DArrayErrorNode)nodeToDump);
        }
        if (cast(DClassErrorNode)nodeToDump) {
            return exportClass(cast(DClassErrorNode)nodeToDump);
        }
        if (cast(DReferenceErrorNode)nodeToDump) {
            return exportReference(cast(DReferenceErrorNode)nodeToDump);
        }
        if (cast(DPropertyErrorNode)nodeToDump) {
            return exportProperty(cast(DPropertyErrorNode)nodeToDump);
        }
        if (cast(DScalarErrorNode)nodeToDump) {
            return exportScalar(cast(DScalarErrorNode)nodeToDump);
        }
        if (cast(DSpecialErrorNode)nodeToDump) {
            return exportSpecial(cast(DSpecialErrorNode)nodeToDump);
        }
        throw new DInvalidArgumentException("Unknown node received " ~ nodeToDump.classname);
    }

    protected string exportArray(DArrayErrorNode tvar, int indentLevel) {
        return null; 
    }

    protected string exportReference(DReferenceErrorNode nodeToConvert, int indentSize) {
        return null;
    }

    protected string exportClass(DClassErrorNode aNode, int indentSize) {
        return null;
    }

    protected string exportProperty(DPropertyErrorNode node, int indentSize) {
        return null;
    }

    protected string exportScalar(DScalarErrorNode node, int indentSize) {
        return null;
    }

    protected string exportSpecial(DSpecialErrorNode node, int indentSize) {
        return null;
    }
}