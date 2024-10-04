module uim.errors.classes.nodes.node;

import uim.errors;

@safe:

class DErrorNode : DErrorNode {
    mixin(ErrorNodeThis!());

    // Get Item nodes
    IErrorNode[] children() {
        return _items;
    }
}
