module uim.i18n.classes.parsers.mofileparser;

import uim.i18n;

@safe:
// Parses file in MO format
class MoFileParser {
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

    /**
     * Parses machine object (MO) format, independent of the machine`s endian it
     * was created on. Both 32bit and 64bit systems are supported.
     */
    array parse(string filetoParsed) {
        auto stream = fopen(filetoParsed, "rb");
        if (stream.isNull) {
            throw new UimException("Cannot open resource `%s`".format(filetoParsed));
        }
        
        auto stat = fstat(stream);
        if (stat == false || stat["size"] < MO_HEADER_SIZE) {
            throw new UimException("Invalid format for MO translations file");
        }
        string magic = unpack("V1", (string) fread(stream, 4));
        magic = hexdec(substr(dechex(current(magic)),  - 8));

        if (magic == self.MO_LITTLE_ENDIAN_MAGIC) {
            isBigEndian = false;
        } else if (magic == self.MO_BIG_ENDIAN_MAGIC) {
            isBigEndian = true;
        } else {
            throw new UimException("Invalid format for MO translations file");
        }
        // offset formatRevision
        fread(stream, 4);

        size_t count = _readLong(stream, isBigEndian);
        auto offsetId = _readLong(stream, isBigEndian);
        auto offsetTranslated = _readLong(stream, isBigEndian);

        // Offset to start of translations
        fread(stream, 8);

        messages = [];
        for (anI = 0; anI < count; anI++) {
            pluralId = null;
            context = null;
            plurals = null;

            fseek(stream, offsetId + anI * 8);

            size_t length = _readLong(stream, isBigEndian);
            auto anOffset = _readLong(stream, isBigEndian);
            if (length < 1) {
                continue;
            }

            fseek(stream, anOffset);
            auto singularId = (string) fread(stream, length);
            if (singularId.has("\x04")) {
                [context, singularId] = split("\x04", singularId);
            }
            if (singularId.has("\000")) {
                [singularId, pluralId] = split("\000", singularId);
            }
            fseek(stream, offsetTranslated + anI * 8);
            length = _readLong(stream, isBigEndian);
            if (length < 0) {
                throw new UimException("Length must be > 0");
            }

            anOffset = _readLong(stream, isBigEndian);
            fseek(stream, anOffset);
            translated = (string) fread(stream, length);

            if (pluralId!isNull || translated.has("\000")) {
                string[] translated = split("\000", translated);
                plurals = pluralId!isNull ? translated : null;
                translated = translated[0];
            }
            
            singular = translated;
            if (context!isNull) {
                messages[singularId]["_context"][context] = singular;
                if (pluralId!isNull) {
                    messages[pluralId]["_context"][context] = plurals;
                }
                continue;
            }
            messages[singularId]["_context"][""] = singular;
            if (pluralId!isNull) {
                messages[pluralId]["_context"][""] = plurals;
            }
        }
        fclose(stream);

        return messages;
    }

    /**
     * Reads an unsigned long from stream respecting endianess.
     * Params:
     * resource stream The File being read.
     * @param bool  isBigEndian Whether the current platform is Big Endian
     */
    protected int _readLong(stream, bool isBigEndian) {
        string result = unpack(isBigEndian ? "N1" : "V1", (string) fread(stream, 4));
        result = current(result);

        return to!int(substr((string) result,  - 8));
    }
}
