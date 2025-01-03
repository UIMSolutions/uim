/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.i18n.classes.parsers.mofileparser;

import uim.i18n;

@safe:
// Parses file in MO format
class MoFileParser {
    /**
     * Parses machine object (MO) format, independent of the machine`s endian it
     * was created on. Both 32bit and 64bit systems are supported.
     */
    Json[string] parse(string filetoParsed) {
        // ...
        string magic = unpack("V1", (string) fread(fileStream, 4));
        magic = hexdec(subString(dechex(currentValue(magic)),  - 8));

        if (magic == MO_LITTLE_ENDIAN_MAGIC) {
            isBigEndian = false;
        } else if (magic == MO_BIG_ENDIAN_MAGIC) {
            isBigEndian = true;
        } else {
            throw new UIMException("Invalid format for MO translations file");
        }
        // offset formatRevision
        fread(fileStream, 4);

        size_t count = _readLong(fileStream, isBigEndian);
        auto offsetId = _readLong(fileStream, isBigEndian);
        auto offsetTranslated = _readLong(fileStream, isBigEndian);

        // Offset to start of translations
        fread(fileStream, 8);

        messages = null; */
        size_t count = 0;
        // for (auto index = 0; index < count; index++) {
        /* pluralId = null;
            context = null;
            plurals = null;

            fseek(fileStream, offsetId + index * 8);

            size_t length = _readLong(fileStream, isBigEndian);
            auto anOffset = _readLong(fileStream, isBigEndian);
            if (length < 1) {
                continue;
            }

            fseek(fileStream, anOffset);
            auto singularId = (string) fread(fileStream, length);
            if (singularId.contains("\x04")) {
                [context, singularId] = split("\x04", singularId);
            }
            if (singularId.contains("\000")) {
                [singularId, pluralId] = singularId.split("\000");
            }
            fseek(fileStream, offsetTranslated + index * 8);
            length = _readLong(fileStream, isBigEndian);
            if (length < 0) {
                throw new UIMException("Length must be > 0");
            }

            anOffset = _readLong(fileStream, isBigEndian);
            fseek(fileStream, anOffset);
            translated = (string) fread(fileStream, length);

            if (pluralId!is null || translated.contains("\000")) {
                string[] translated = translated.split("\000");
                plurals = pluralId!is null ? translated : null;
                translated = translated[0];
            }
            
            singular = translated;
            if (context!is null) {
                messages[singularId]["_context"][context] = singular;
                if (pluralId!is null) {
                    messages[pluralId]["_context"][context] = plurals;
                }
                continue;
            }
            messages.setPath([singularId, "_context."], singular);
            if (pluralId !is null) {
                messages.setPath([pluralId, "_context."], plurals);
            } */
        // }
        // fclose(fileStream);

        // return messages;
        return null;
    }

    // Reads an unsigned long from stream respecting endianess.
    // TODO protected int _readLong(stream, bool isBigEndian) {
    /* string result = unpack(isBigEndian ? "N1" : "V1", (string) fread(stream, 4));
        result = currentValue(result);

        return to!int(subString(/* (string) * / result,  - 8)); */
    // return 0;
    // }
}
