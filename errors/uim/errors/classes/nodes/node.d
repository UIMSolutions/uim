module uim.errors.classes.nodes.node;

import uim.errors;

@safe:

class DErrorNode : DErrorNode {
    mixin(ErrorNodeThis!());

    private Json _value;
    Json value() {
        return _value;
    }

    // Get Item nodes
    private IErrorNode[] _children;
    IErrorNode[] children() {
        return _children;
    }
}
