module uim.errors.interfaces.node;

import uim.errors;

@safe:

/*
 * Interface for Debug Nodes
 * Provides methods to look at contained value and iterate child nodes in the tree.
 */
interface IErrorNode {
    // Get the child nodes of this node.
    IErrorNode[] getChildren();

    // Get the contained value.
    IData getValue();
}
