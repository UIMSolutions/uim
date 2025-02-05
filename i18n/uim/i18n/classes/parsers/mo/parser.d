module uim.i18n.classes.parsers.mo.parser;

import uim.i18n;
@safe:

class DMoI18NParser : DI18NParser {
    mixin(I18NParserThis!("Mo"));

    /**
     * Magic used for validating the format of a MO file as well as
     * detecting if the machine used to create that file was little endian.
     */
    const int MO_LITTLE_ENDIAN_MAGIC = 0x950412de;

    /**
     * Magic used for validating the format of a MO file as well as
     * detecting if the machine used to create that file was big endian.
     */
    const int MO_BIG_ENDIAN_MAGIC = 0xde120495;

    // The size of the header of a MO file in bytes.
    const int MO_HEADER_SIZE = 28;

    Json[string] parse(string fileName) {
        if (!fileName.exists) {
            // throw new DException("`%s` not found".format(fileName));
        }

        if (!fileName.isFile) {
            // throw new DException("`%s` not a file".format(fileName));
        }

        auto fileStream = File(fileName, "rb");
        if (fileStream.error) {
            // throw new DException("Cannot open resource `%s`".format(fileName));
        }
        
        if (fileStream.size < MO_HEADER_SIZE) {
            // throw new DException("Invalid format for MO translations file");
        }

        string first = (() @trusted => cast(string)fileStream.rawRead(new char[4]))();

        // TODO 
        
        fileStream.close;
        return null; 
    }
}
mixin(I18NParserCalls!("Mo"));
