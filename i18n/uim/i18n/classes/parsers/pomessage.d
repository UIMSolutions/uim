/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.i18n.classes.parsers.pomessage;

import uim.i18n;

@safe:
// Message in PO format
class DPoMessage : UIMObject {
    this() {
        initialize;
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

    protected string[] _ids;
    auto addId(string newId) {
        string prefix = `msgid "`;
        newId = newId.strip;
        if (newId.startsWith(prefix)) {
            // TODO 
            /*
            newId = newId[prefix.length .. $];
            if (newId.endsWith(`"`)) {
                newId = newId[prefix ..  - 1];
                _ids = newId.strip;
                return this;
            }
        */
        }
    }

    string[] ids() {
        return _ids;
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
                _ids ~= msgId;
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
            result = result[0 .. -1];
        }
        return result;
    }
}
