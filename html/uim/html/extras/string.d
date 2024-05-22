module uim.html.extras.string;

@safe:
import uim.html;

// Additional element to handle string in DOM
class DH5String : DH5Obj {
	private string _content;
    this(string aContent) { _content = aContent; }
    override string toString() { return _content; }

    override string toPretty(int intendSpace = 0, int step = 2) {
		return _content.indent(intendSpace);
	}
}
auto H5String(string text) { return new DH5String(text); }
auto H5String(T)(T value) { return new DH5String(to!string(value)); }
