/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.interfaces.node;

import uim.errors;

@safe:

/*
 * Interface for Debug Nodes
 * Provides methods to look at contained value and iterate child nodes in the tree.
 */
interface IErrorNode {
    // Get the child nodes of this node.
    // TODO IErrorNode[] getChildren();

    // Get the contained value.
    // TODO Json getValue();
}
/*  */