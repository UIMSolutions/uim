module uim.errors.classes.nodes.interface_;

import uim.errors;

@safe:

/*
 * Interface for Debugs
 * Provides methods to look at contained value and iterate child nodes in the tree.
 */
interface INode {
    // Get the child nodes of this node.
    INode[] getChildren();

    // Get the contained value.
    IData getValue();
}
