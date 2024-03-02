module uim.consoles\TestSuite\Constraint;

import uim.consoles;

@safe:

/**
 * Base constraint for content constraints
 *
 * @internal
 */
abstract class ContentsBase : Constraint {
    protected string _content;
    protected string _output;

    this(string[] contents, string outputType) {
        _content = join(D_EOL, contents);
        _output = outputType;
    }
}
