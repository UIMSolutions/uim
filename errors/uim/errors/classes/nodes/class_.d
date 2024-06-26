module uim.errors.classes.nodes.class_;

import uim.errors;

@safe:

// Dump node for objects/class instances.
class DClassNode : IErrorNode {
    this(string classname, int anId) {
        _classname = classname;
        _id = anId;
    }

    private DPropertyNode[] properties = null;
    /**
     * Add a property
     * Params:
     * \UIM\Error\Debug\PropertyNode node The property to add.
     */
    void addProperty(DPropertyNode node) {
        this.properties ~= node;
    }

    // Get property nodes
    DPropertyNode[] getChildren() {
        return this.properties;
    }

    private string _classname;
    // Get the class name
    string getValue() {
        return _classname;
    }

    private int _id;
    // Get the reference id
    int getId() {
        return _id;
    }
}
