/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.classes.nodes.node;import uim.errors;@safe:class DErrorNode : DErrorNode {    mixin(ErrorNodeThis!());    private Json _value;    Json value() {        return _value;    }    // Get Item nodes    private IErrorNode[] _children;    IErrorNode[] children() {        return _children;    }}