module uim.i18n.classes.parsers.pofileparser;

import uim.i18n;

@safe:

// Parses file in PO format
class DPoFileParser {
    mixin TConfigurable;

    this() {
        initialize;
    }

    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);
        
        return true;
    }
    /**
     * Parses portable object (PO) format.
     *
     * From https://www.gnu.org/software/gettext/manual/gettext.html#PO-Files
     * we should be able to parse files having:
     *
     * white-space
     * #  translator-comments
     * #. extracted-comments
     * #: reference...
     * #, flag...
     * #| msgid previous-untranslated-string
     * msgid untranslated-string
     * msgstr translated-string
     *
     * extra or different lines are:
     *
     * #| msgctxt previous-context
     * #| msgid previous-untranslated-string
     * msgctxt context
     *
     * #| msgid previous-untranslated-string-singular
     * #| msgid_plural previous-untranslated-string-plural
     * msgid untranslated-string-singular
     * msgid_plural untranslated-string-plural
     * msgstr[0] translated-string-case-0
     * ...
     * msgstr[N] translated-string-case-n
     *
     * The definition states:
     * - white-space and comments are optional.
     * - msgid "" that an empty singleline defines a header.
     *
     * This parser sacrifices some features of the reference implementation the
     * differences to that implementation are as follows.
     * - Translator and extracted comments are treated as being the same type.
     * - Message IDs are allowed to have other encodings as just US-ASCII.
     *
     * Items with an empty id are ignored.
     */
    Json[string] parse(string resourceFilepath) {
        if (!exists(resourceFilepath)){
            throw new DException("Not found file `%s`".format(resourceFilepath));
        }

        auto fileStream = fopen(resourceFilepath, "rb");
        if (fileStream == false) {
            throw new DException("Cannot open resource `%s`".format(resourceFilepath));
        }

        Json defaultItem = Json.emptyObject;
        defaultItem["ids"] = ArrayData;
        defaultItem["translated"] = false;

        anItem = defaultItem.clone;

        string[int] stage = null;
        
        PoMessage message;
        PoMessage[] messages = file.byLine.each!((line) {
            message = parseByLine(line, message);
            if (!message.isNull && message.isFinished) {
                messages ~= message;
                message = null;
            }
        }

        // save last item
        addMessage(messages, anItem);
        fclose(fileStream);

        return messages;
    }

    PoMessage parseByLine(string line, Json[] messages, PoMessage message) {
        string line = strip(line);

        if (line.isEmpty && message.isNull) {
            return null;
        }

        if (!line.isEmpty && message.isNull) {
            message = new DPoMessage;
        }

        if (line.startsWith("#")) {
            message.addComments(line);
            return message; 
        }

        if (line.startsWith(`msgid "`)) {
            message.id(line);
            return message; 

            /* addMessage(messages, anItem);
            anItem["ids.singular"] = subString(line, 7,  - 1);
            stage = ["ids", "singular"];
            return; */ 
        }

        if (line.startsWith("msgstr \" ")) {
            anItem["translated"] = subString(line, 8,  - 1);
            stage = ["translated"];
        }

        if (line.startsWith(" msgctxt\"")) {
            anItem["context"] = subString(line, 9, -1);
            stage = ["context"];
        }

        /* if (line[0] == "\" ") {
            switch (stage.length) {
            case 2:
                assert(isSet(stage[0]));
                assert(isSet(stage[1]));

                anItem[stage[0]][stage[1]] ~= subString(line, 1, -1);
                break;

            case 1:
                assert(isSet(stage[0]));
                anItem[stage[0]] ~= subString(line, 1, -1);
                break;
            }
        } else if (line.startsWith(" msgid_plural\"")
           ) {
            anItem["ids.plural"] = subString(line, 14, -1);
            stage = ["ids", "plural"];
        } else if (line.startsWith("msgstr[")) {
            size = indexOf(line, "]");
            assert(isInteger(size));

            row = to!int(subString(line, 7, 1));
            anItem["translated"][row] = subString(line, size + 3,  - 1);
            stage = ["translated", row];
        } */
    }

    /**
     * Saves a translation item to the messages.
     * Params:
     * Json[string] messages The messages array being collected from the file
     */
    protected void addMessage(Json[string] messages, Json itemToInspect) {
        auto ids = itemToInspect["ids"];
        if (ids["singular"].isEmpty && ids["plural"].isEmpty) {
            return;
        }

        auto singular = stripcslashes(ids["singular"]);
        auto context = itemToInspect.get("context", null);
        auto translation = itemToInspect["translated"];

        if (isArray(translation)) {
            translation = translation[0];
        }
        translation = stripcslashes(to!string(translation));

        if (context!is null && messages.isNull([singular, "_context", context])) {
            messages[singular]["_context"][context] = translation;
        } else if (messages.isNull([singular, "_context."])) {
            messages.set([singular, "_context."], translation);
        }

        if (ids.hasKey("plural")) {
            plurals = itemToInspect["translated"];
            // PO are by definition indexed so sort by index.
            ksort(plurals);

            // Make sure every index is filled.
            end(plurals);
            count = to!int(key(plurals));

            // Fill missing spots with an empty string.
            empties = array_fill(0, count + 1, "");
            plurals += empties;
            ksort(plurals);

            plurals = array_map("stripcslashes", plurals);
            aKey = stripcslashes(ids["plural"]);

            if (!context.isNull) {
                messages[Translator.PLURAL_PREFIX ~ aKey]["_context"][context] = plurals;
            } else {
                messages[Translator.PLURAL_PREFIX ~ aKey]["_context."] = plurals;
            }
        }
    } 
}
