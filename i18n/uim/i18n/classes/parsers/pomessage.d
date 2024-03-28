module uim.i18n.classes.parsers.pomessage;

import uim.i18n;

@safe:
// Message in PO format
class DPoMessage {
    mixin TConfigurable!();

    this() {
        initialize;
    }

    bool initialize(IData[string] initData = null) {
        configuration(MemoryConfiguration);
        setConfigurationData(initData);
        
        return true;
    }

    protected bool _isFinished;
    @property void isFinished(bool mode) {
        _isFinished = mode;
    }

    string[] _translatorComments;
    auto addTranslatorComment(string comment) {
        // TODO _comments ~= comment;
        return this;
    }

    string[] _extractedComments;
    string[] _references;

    protected bool _isMultiIdMode;
    @property void isMultiIdMode(bool mode) {
        _isMultiIdMode = mode;
    }

    protected string[] _id;
    auto addId(string newId) {
        string prefix = `msgid "`;
        newId = strip(newId);
       // TODO 
       /* if (newId.startsWith(prefix)) {
            newId = newId[prefix.length .. $];
            if (newId.endsWith(`"`)) {
                newId = newId[prefix ..  - 1];
                _id = strip(newId);
                return this;
            }
        } */
    }

    string[] id() {
        return _id;
    }

    protected bool _isMultiTextMode;
    @property void isMultiTextMode(bool mode) {
        _isMultiTextMode = mode;
    }

    protected string[] _text;
    /* void addId(string newId) {

    } */

    void add(string line) {
        line = line.strip;

        if (line.startsWith("#")) {
            _isMultiIdMode = false;
            _isMultiTextMode = false;
        }

        if (line.startsWith("# ")) {
            _translatorComments ~= line["# ".length .. $].strip;
            return;
        }

        if (line.startsWith("#. ")) {
            _extractedComments ~= line["#. ".length .. $].strip;
            return;
        }

        if (line.startsWith("#: ")) {
            _references ~= line["#: ".length .. $].strip;
            return;
        }

        if (line.startsWith("msgid ")) {
            string msgId = line["msgid ".length .. $].strip;
            if (removeQuotes(msgId).isEmpty) {
                _isMultiIdMode = true;
            } else {
                _id ~= msgId;
            }
            return;
        }

        if (line.startsWith("msgstr ")) {
            _isMultiIdMode = false;

            string msgstr = line["msgid ".length .. $].strip;
            if (removeQuotes(msgstr).isEmpty) {
                _isMultiTextMode = true;
            } else {
                _text ~= msgstr;
            }
            return;
        }

    }

    string removeQuotes(string line) {
        string result = line.strip;
        if (result.startsWith("\"")) {
            result = result[1 .. $];
        }
        if (result.endsWith("\"")) {
            result = result[0 ..  - 1];
        }
        return result;
    }
}
