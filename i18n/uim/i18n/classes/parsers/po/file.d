module uim.i18n.classes.parsers.po.file;

import uim.i18n;

@safe:

class DPoFile : UIMObject {
    this() {
        super();
    }

    protected Json[] messages;

    protected string projectIdVersion;
    protected string potCreationDate;
    protected string poRevisionDate;
    protected string lastTranslator;
    protected string languageTeam;
    protected string language;
    protected string pluralForms;
    protected string mimeVersion;
    protected string contentType;
    protected string contentTransferEncoding;
    protected string xSourceLanguage;
    protected string xGenerator;

    void load(string fileName) {
        if (!fileName.exists) {
            debug writeln(fileName, " not found");
            return;
        }

        string[] content = fileName.readText
            .split("\n")
            .map!(line => cast(string) line).array;

        messages = splitInMessageLines(content)
            .map!(region => regionToMessage(region))
            .array;
    }
    /// 
    unittest {
        auto file = new DPoFile;
        file.load("tests\\de.po");
    }

    string[][] splitInMessageLines(string[] content) {
        string[][] regions;
        string[] region;
        foreach (line; content) {
            line = line.strip;
            if (line.isEmpty) {
                regions ~= region;
                region = null;
            } else {
                region ~= line;
            }
        }
        regions ~= region;

        return regions;
    }

    Json regionToMessage(string[] region) {
        Json message = Json.emptyObject;
        foreach (line; region) {
            line = line.strip;
            if (line.startsWith("msgid ")) {
                message["id"] = deleteQuotes(line.subString("msgid ".length).strip);
                continue;
            }
            if (line.startsWith("msgid_plural ")) {
                message["id_plural"] = deleteQuotes(line.subString("msgid_plural ".length).strip);
                continue;
            }
            if (line.startsWith("msgstr ")) {
                message["str"] = deleteQuotes(line.subString("msgstr ".length).strip);
                continue;
            }
            if (line.startsWith("msgctxt ")) {
                message["ctxt"] = deleteQuotes(line.subString("msgctxt ".length).strip);
                continue;
            }
            if (isHeader(message)) {
                readHeader(region);
            }
        }
        return message;
    }

    bool isHeader(Json message) {
        return !message.isNull && message.hasKey("id") && message.hasKey("str")
            && message.getString("id") == "" && message.getString("str") == "";
    }

    void readHeader(string[] region) {
        foreach(line; region
            .map!strip
            .filter!(line => line.startsWith("\""))
            .map!(line => deleteQuotes(line)).array) {
                line = line.replace("\\n", "");
            if (line.startsWith("Project-Id-Version:")) {
                projectIdVersion = deleteQuotes(line.subString("Project-Id-Version:".length).strip);
            }
            if (line.startsWith("POT-Creation-Date:")) {
                potCreationDate = deleteQuotes(line.subString("POT-Creation-Date:".length).strip);
            }
            if (line.startsWith("PO-Revision-Date:")) {
                poRevisionDate = deleteQuotes(line.subString("PO-Revision-Date:".length).strip);
            }
            if (line.startsWith("Last-Translator:")) {
                lastTranslator = deleteQuotes(line.subString("Last-Translator:".length).strip);
            }
            if (line.startsWith("Language-Team:")) {
                languageTeam = deleteQuotes(line.subString("Language-Team:".length).strip);
            }
            if (line.startsWith("Language:")) {
                language = deleteQuotes(line.subString("Language:".length).strip);
            }
            if (line.startsWith("Plural-Forms:")) {
                pluralForms = deleteQuotes(line.subString("Plural-Forms:".length).strip);
            }
            if (line.startsWith("MIME-Version:")) {
                mimeVersion = deleteQuotes(line.subString("MIME-Version:".length).strip);
            }
            if (line.startsWith("Content-Type:")) {
                contentType = deleteQuotes(line.subString("Content-Type:".length).strip);
            }
            if (line.startsWith("Content-Transfer-Encoding:")) {
                contentTransferEncoding = deleteQuotes(line.subString("Content-Transfer-Encoding:".length).strip);
            }
            if (line.startsWith("X-Source-Language:")) {
                xSourceLanguage = deleteQuotes(line.subString("X-Source-Language:".length).strip);
            }
            if (line.startsWith("X-Generator:")) {
                xGenerator = deleteQuotes(line.subString("X-Generator:".length).strip);
            }
        }
    }

    string deleteQuotes(string line, string quote = `"`) {
        return (line.startsWith(quote) && line.endsWith(quote))
            ? line[quote.length .. $ - quote.length] : line;
    }
    /// 
    unittest {
        auto file = new DPoFile;
        writeln(file.deleteQuotes(`'Sensei'`));
        writeln(file.deleteQuotes(`'Sensei'`, "'"));
        writeln(file.deleteQuotes(`"Sensei"`));
    }

    override Json toJson(string[] showKeys = null, string[] hideKeys = null) {
        Json json = super.toJson
            .set("projectIdVersion", projectIdVersion)
            .set("potCreationDate", potCreationDate)
            .set("poRevisionDate", poRevisionDate)
            .set("lastTranslator", lastTranslator)
            .set("languageTeam", languageTeam)
            .set("language", language)
            .set("pluralForms", pluralForms)
            .set("mimeVersion", mimeVersion)
            .set("contentType", contentType)
            .set("contentTransferEncoding", contentTransferEncoding)
            .set("xSourceLanguage", xSourceLanguage)
            .set("xGenerator", xGenerator)
            .set("messages", messages);

        if (showKeys) json = json.filterKeys(showKeys);
        if (hideKeys) json = json.removeKeys(hideKeys);
        return json;
    }
    /// 
    unittest {
        writeln("\n-- test - toJson");
        auto file = new DPoFile;
        file.load("tests\\de.po");
        writeln(file.toJson);
        writeln;
        writeln(file.toJson(null, ["messages"]));
    }

    void save() {

    }
    /// 
    unittest {
        writeln("\n-- test - save");
        auto file = new DPoFile;
        file.load("tests\\de.po");
        // TODO
    }

    void saveTo(string fileName) {

    }
    /// 
    unittest {
        auto file = new DPoFile;
        file.load("tests\\de.po");
        // TODO
    }
}
