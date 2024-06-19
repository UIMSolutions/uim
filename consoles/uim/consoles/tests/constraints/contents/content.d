module uim.consoles.tests.constraints.contents.content;

import uim.consoles;

@safe:

// Base constraint for content constraints
abstract class DContentsBase : DConstraint {
    protected string _content;
    protected string _output;

    // TODO 
    this(string[] contents, string outputType) {
        _content = contents.join(D_EOL);
        _output = outputType;
    }
}
