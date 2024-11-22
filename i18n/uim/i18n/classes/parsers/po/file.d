module uim.i18n.classes.parsers.po.file;

import uim.i18n;

@safe:

class DPoFile : UIMObject {
    this() {
        super();
    }

    protected Json[string] messages;

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

        Json[] messages = splitInMessageLines(content)
            .map!(region => regionToMessage(region))
            .array;

        writeln(messages);
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
            if (message.getString("id") == "" && message.getString("str") == "") {
                if (line.startsWith("Project-Id-Version: ")) {
                    projectIdVersion = deleteQuotes(line.strip);
                }
                if (line.startsWith("POT-Creation-Date: ")) {
                    potCreationDate = deleteQuotes(line.strip);
                }
                if (line.startsWith("PO-Revision-Date: ")) {
                    poRevisionDate = deleteQuotes(line.strip);
                }
                if (line.startsWith("Last-Translator: ")) {
                    lastTranslator = deleteQuotes(line.strip);
                }
                if (line.startsWith("Language-Team: ")) {
                    languageTeam = deleteQuotes(line.strip);
                }
                if (line.startsWith("Language: ")) {
                    language = deleteQuotes(line.strip);
                }
                if (line.startsWith("Plural-Forms: ")) {
                    pluralForms = deleteQuotes(line.strip);
                }
                if (line.startsWith("MIME-Version: ")) {
                    mimeVersion = deleteQuotes(line.strip);
                }
                if (line.startsWith("Content-Type: ")) {
                    contentType = deleteQuotes(line.strip);
                }
                if (line.startsWith("Content-Transfer-Encoding: ")) {
                    contentTransferEncoding = deleteQuotes(line.strip);
                }
                if (line.startsWith("X-Source-Language: ")) {
                    xSourceLanguage = deleteQuotes(line.strip);
                }
                if (line.startsWith("X-Generator: ")) {
                    xGenerator = deleteQuotes(line.strip);
                }
            }
        }
        return message;
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
        Json json = super.toJson;

        json.set("projectIdVersion", projectIdVersion);
        json.set("potCreationDate", potCreationDate);
        json.set("poRevisionDate", poRevisionDate);
        json.set("lastTranslator", lastTranslator);
        json.set("languageTeam", languageTeam);
        json.set("language", language);
        json.set("pluralForms", pluralForms);
        json.set("mimeVersion", mimeVersion);
        json.set("contentType", contentType);
        json.set("contentTransferEncoding", contentTransferEncoding);
        json.set("xSourceLanguage", xSourceLanguage);
        json.set("xGenerator", xGenerator);
        json.set("messages", messages);

        return json;
    }
    /// 
    unittest {
        auto file = new DPoFile;
        file.load("tests\\de.po");
        writeln(file.toJson);
    }

    void save() {

    }
    /// 
    unittest {
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
