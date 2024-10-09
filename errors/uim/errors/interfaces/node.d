/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.interfaces.node;

import uim.errors;

@safe:

// Interface for Error Nodes
// Provides methods to look at the contained value and iterate on child nodes in the error tree.
interface IErrorNode {
    // Get the contained value.
    Json value();

    // Get the child nodes of this node.
    IErrorNode[] children();
}
