module uim.oop.helpers.textx;

import uim.oop;

@safe:

// Text handling methods.
class DText {
    /**
     * Default transliterator.
     * /
    protected static Transliterator _defaultTransliterator = null;

    /**
     * Default transliterator id string.
     * /
    protected static string _defaultTransliteratorId = "Any-Latin; Latin-ASCII; [\u0080-\u7fff] remove";

    /**
     * Default HTML tags which must not be counted for truncating text.
     * /
    protected static string[] _defaultHtmlNoCount = [
        "style",
        "script",
    ];

    /**
     * Generate a random UUID version 4
     *
     * Warning: This method should not be used as a random seed for any cryptographic operations.
     * Instead, you should use `Security.randomBytes()` or `Security.randomString()` instead.
     *
     * It should also not be used to create identifiers that have security implications, such as
     * "unguessable" URL identifiers. Instead, you should use {@link \UIM\Utility\Security.randomBytes()}` for that.
     *
     * @see https://www.ietf.org/rfc/rfc4122.txt
     * /
    static string uuid() {
        return 
            "%04x%04x-%04x-%04x-%04x-%04x%04x%04x".format(
            // 32 bits for "time_low"
            random_int(0, 65535),
            random_int(0, 65535),
            // 16 bits for "time_mid"
            random_int(0, 65535),
            // 12 bits before the 0100 of (version) 4 for "time_hi_and_version"
            random_int(0, 4095) | 0x4000,
            // 16 bits, 8 bits for "clk_seq_hi_res",
            // 8 bits for "clk_seq_low",
            // two most significant bits holds zero and one for variant DCE1.1
            random_int(0, 0x3fff) | 0x8000,
            // 48 bits for "node"
            random_int(0, 65535),
            random_int(0, 65535),
            random_int(0, 65535)
        );
    }
    
    /**
     * Tokenizes a string using myseparator, ignoring any instance of myseparator that appears between
     * myleftBound and myrightBound.
     * Params:
     * string mydata The data to tokenize.
     * @param string myseparator The token to split the data on.
     * @param string myleftBound The left boundary to ignore separators in.
     * @param string myrightBound The right boundary to ignore separators in.
     * /
    static string[] tokenize(string data, string separator = ",", string leftBound = "(", string rightBound = ")") {
        if (data.isEmpty) {
            return null;
        }

        auto depth = 0;
        auto offset = 0;
        string mybuffer;
        results = null;
        mylength = mydata.length;
        myopen = false;

        while (myoffset <= mylength) {
            size_t tmpOffset = -1;
            size_T[] offsets = [
                mydata.indexOf(separator, offset),
                mydata.indexOf(leftBound, offset),
                mydata.indexOf(rightBound, offset),
            ];
            for (i = 0; i < 3; i++) {
                if (offsets[i] != -1 && (offsets[i] < mytmpOffset || tmpOffset == -1)) {
                    tmpOffset = offsets[i];
                }
            }

            if (mytmpOffset != -1) {
                string mybuffer ~= mydata[myoffset..mytmpOffset - myoffset];
                string mychar = mb_substr(mydata, mytmpOffset, 1);
                if (!mydepth && mychar == myseparator) {
                    results ~= mybuffer;
                    mybuffer = "";
                } else {
                    mybuffer ~= mychar;
                }
                if (myleftBound != myrightBound) {
                    if (mychar == myleftBound) {
                        mydepth++;
                    }
                    if (mychar == myrightBound) {
                        mydepth--;
                    }
                } else {
                    if (mychar == myleftBound) {
                        if (!myopen) {
                            mydepth++;
                            myopen = true;
                        } else {
                            mydepth--;
                            myopen = false;
                        }
                    }
                }
                mytmpOffset += 1;
                myoffset = mytmpOffset;
            } else {
                results ~= mybuffer ~ mb_substr(mydata, myoffset);
                myoffset = mylength + 1;
            }
        }
        if (results.isEmpty && !mybuffer.isEmpty) {
            results ~= mybuffer;
        }
        if (!results.isEmpty) {
            return array_map("trim", results);
        }
        return null;
    }
    
    /**
     * Replaces variable placeholders inside a mystr with any given mydata. Each key in the mydata array
     * corresponds to a variable placeholder name in mystr.
     * Example:
     * ```
     * Text.insert(":name is :age years old.", ["name": "Bob", "age": "65"]);
     * ```
     * Returns: Bob is 65 years old.
     *
     * Available options are:
     *
     * - before: The character or string in front of the name of the variable placeholder (Defaults to `:`)
     * - after: The character or string after the name of the variable placeholder (Defaults to null)
     * - escape: The character or string used to escape the before character / string (Defaults to `\`)
     * - format: A regex to use for matching variable placeholders. Default is: `/(?<!\\)\:%s/`
     *  (Overwrites before, after, breaks escape / clean)
     * - clean: A boolean or array with instructions for Text.cleanInsert
     * Params:
     * string mystr A string containing variable placeholders
     * @param Json[string] data A key: val array where each key stands for a placeholder variable name
     *    to be replaced with val
     * @param IData[string] options An array of options, see description above
     * /
    static string insert(string mystr, Json[string] data, IData[string] optionData = null) {
        IData[string] defaultData = [
            "before": ":", 
            "after": "", 
            "escape": "\\", 
            "format": null, 
            "clean": Json(false)
        ];
        optionData = optionData.add(defaultData);
        if (isEmpty(mydata)) {
            return options["clean"] ? cleanInsert(mystr, options): mystr;
        }
        myformat = options["format"];
        if (myformat.isNull) {
            myformat = 
                "/(?<!%s)%s%%s%s/"
                .format(
                    preg_quote(options["escape"], "/"),
                    preg_quote(options["before"], "/").replace("%", "%%"),
                    preg_quote(options["after"], "/").replace("%", "%%")
                );
        }
        mydataKeys = mydata.keys;
        myhashKeys = array_map("md5", mydataKeys);
        /** @var STRINGAA mytempData * /
        mytempData = array_combine(mydataKeys, myhashKeys);
        krsort(mytempData);

        foreach (mytempData as aKey: myhashVal) {
            aKey = myformat.format(preg_quote(aKey, "/"));
            mystr = (string)preg_replace(aKey, myhashVal, mystr));
        }
        /** @var IData[string] mydataReplacements * /
        mydataReplacements = array_combine(myhashKeys, array_values(mydata));
        foreach (mytmpHash, mytmpValue; mydataReplacements) {
            mytmpValue = mytmpValue.isArray ? "" : mytmpValue.toString;
            mystr = (string)mystr.replace(mytmpHash, mytmpValue);
        }
        if (!options.isSet("format") && isSet(options["before"])) {
            mystr = (string)mystr.replace(options["escape"] ~ options["before"], options["before"]);
        }
        return options["clean"] ? cleanInsert(mystr, options): mystr;
    }
    
    /**
     * Cleans up a Text.insert() formatted string with given options depending on the "clean" key in
     * options. The default method used is text but html is also available. The goal of this function
     * is to replace all whitespace and unneeded markup around placeholders that did not get replaced
     * by Text.insert().
     * Params:
     * string mystr String to clean.
     * @param IData[string] options Options list.
     * /
    static string cleanInsert(string mystr, IData[string] options) {
        myclean = options["clean"];
        if (!myclean) {
            return mystr;
        }
        if (myclean == true) {
            myclean = ["method": "text"];
        }
        if (!isArray(myclean)) {
            myclean = ["method": options["clean"]];
        }
        switch (myclean["method"]) {
            case "html":
                myclean += [
                    "word": "[\w,.]+",
                    "andText": Json(true),
                    "replacement": "",
                ];
                mykleenex = "/[\s]*[a-z]+=(\")(%s%s%s[\s]*)+\\1/i"
                    .format(
                        preg_quote(options["before"], "/"),
                        myclean["word"],
                        preg_quote(options["after"], "/")
                    );
                mystr = (string)preg_replace(mykleenex, myclean["replacement"], mystr);
                if (myclean["andText"]) {
                    options["clean"] = ["method": "text"];
                    mystr = cleanInsert(mystr, options);
                }
                break;
            case "text":
                myclean += [
                    "word": "[\w,.]+",
                    "gap": "[\s]*(?:(?:and|or)[\s]*)?",
                    "replacement": "",
                ];

                mykleenex = 
                    "/(%s%s%s%s|%s%s%s%s)/"
                    .format(
                    preg_quote(options["before"], "/"),
                    myclean["word"],
                    preg_quote(options["after"], "/"),
                    myclean["gap"],
                    myclean["gap"],
                    preg_quote(options["before"], "/"),
                    myclean["word"],
                    preg_quote(options["after"], "/")
                );
                mystr = (string)preg_replace(mykleenex, myclean["replacement"], mystr);
                break;
        }
        return mystr;
    }
    
    /**
     * Wraps text to a specific width, can optionally wrap at word breaks.
     *
     * ### Options
     *
     * - `width` The width to wrap to. Defaults to 72.
     * - `wordWrap` Only wrap on words breaks (spaces) Defaults to true.
     * - `indent` String to indent with. Defaults to null.
     * - `indentAt` 0 based index to start indenting at. Defaults to 0.
     * Params:
     * string textToFormat The text to format.
     * @param IData[string]|int options Array of options to use, or an integer to wrap the text to.
     * /
    static string wrap(string textToFormat, array|int options = []) {
        if (isNumeric(options)) {
            options = ["width": options];
        }
        options = options.update["width": 72, "wordWrap": Json(true), "indent": null, "indentAt": 0];
        if (options["wordWrap"]) {
            mywrapped = wordWrap(textToFormat, options["width"], "\n");
        } else {
            mylength = options["width"] - 1;
            if (mylength < 1) {
                throw new DInvalidArgumentException("Length must be `int<1, max>`.");
            }
            mywrapped = strip(chunk_split(textToFormat, mylength, "\n"));
        }
        if (!empty(options["indent"])) {
            string[] mychunks = mywrapped.split("\n");
            for (myi = options["indentAt"], mylen = count(mychunks); myi < mylen; myi++) {
                mychunks[myi] = options["indent"] ~ mychunks[myi];
            }
            mywrapped = mychunks.join("\n");
        }
        return mywrapped;
    }
    
    /**
     * Wraps a complete block of text to a specific width, can optionally wrap
     * at word breaks.
     *
     * ### Options
     *
     * - `width` The width to wrap to. Defaults to 72.
     * - `wordWrap` Only wrap on words breaks (spaces) Defaults to true.
     * - `indent` String to indent with. Defaults to null.
     * - `indentAt` 0 based index to start indenting at. Defaults to 0.
     * Params:
     * string textToFormat The text to format.
     * @param IData[string]|int options Array of options to use, or an integer to wrap the text to.
     * /
    static string wrapBlock(string textToFormat, array|int options = []) {
        if (isNumeric(options)) {
            options = ["width": options];
        }
        options = options.update["width": 72, "wordWrap": Json(true), "indent": null, "indentAt": 0];

        auto mywrapped = wrap(textToFormat, options);

        if (!empty(options["indent"])) {
            myindentationLength = mb_strlen(options["indent"]);
            string[] mychunks = mywrapped.split("\n");
            mycount = count(mychunks);
            if (mycount < 2) {
                return mywrapped;
            }
            string mytoRewrap;
            for (myi = options["indentAt"]; myi < mycount; myi++) {
                mytoRewrap ~= mb_substr(mychunks[myi], myindentationLength) ~ " ";
                unset(mychunks[myi]);
            }
            options["width"] -= myindentationLength;
            options["indentAt"] = 0;
            myrewrapped = wrap(mytoRewrap, options);
            
            string[] mynewChunks = myrewrapped.split("\n");
            string mywrapped = chain(mychunks, mynewChunks).join("\n");
        }
        return mywrapped;
    }
    
    /**
     * Unicode and newline aware version of wordwrap.
     *
     * @Dstan-param non-empty-string mybreak
     * @param string textToFormat The text to format.
     * @param bool mycut If the cut is set to true, the string is always wrapped at the specified width.
     * /
    static string wordWrap(string textToFormat, int widthToWrap = 72, string breakText = "\n", bool mycut = false) {
        return 
            textToFormat
                .split(breakText)
                .map(paragraph => _wordWrap(paragraph, widthToWrap, breakText, mycut))
                .join(breakText);
    }
    
    /**
     * Unicode aware version of wordwrap as helper method.
     * Params:
     * string textToFormat The text to format.
     * @param int mywidth The width to wrap to. Defaults to 72.
     * @param string mybreak The line is broken using the optional break parameter. Defaults to "\n".
     * @param bool mycut If the cut is set to true, the string is always wrapped at the specified width.
     * /
    protected static string _wordWrap(string textToFormat, int mywidth = 72, string mybreak = "\n", bool mycut = false) {
        myparts = null;
        if (mycut) {
            while (mb_strlen(textToFormat) > 0) {
                mypart = mb_substr(textToFormat, 0, mywidth);
                myparts ~= strip(mypart);
                textToFormat = strip(mb_substr(textToFormat, mb_strlen(mypart)));
            }
            return join(mybreak, myparts);
        }
        while (mb_strlen(textToFormat) > 0) {
            if (mywidth >= mb_strlen(textToFormat)) {
                myparts ~= strip(textToFormat);
                break;
            }
            mypart = mb_substr(textToFormat, 0, mywidth);
            mynextChar = mb_substr(textToFormat, mywidth, 1);
            if (mynextChar != " ") {
                mybreakAt = mb_strrpos(mypart, " ");
                if (mybreakAt == false) {
                    mybreakAt = mb_indexOf(textToFormat, " ", mywidth);
                }
                if (mybreakAt == false) {
                    myparts ~= strip(textToFormat);
                    break;
                }
                mypart = mb_substr(textToFormat, 0, mybreakAt);
            }
            mypart = strip(mypart);
            myparts ~= mypart;
            textToFormat = strip(mb_substr(textToFormat, mb_strlen(mypart)));
        }
        return join(mybreak, myparts);
    }
    
    /**
     * Highlights a given phrase in a text. You can specify any expression in highlighter that
     * may include the \1 expression to include the myphrase found.
     *
     * ### Options:
     *
     * - `format` The piece of HTML with that the phrase will be highlighted
     * - `html` If true, will ignore any HTML tags, ensuring that only the correct text is highlighted
     * - `regex` A custom regex rule that is used to match words, default is "|mytag|iu"
     * - `limit` A limit, optional, defaults to -1 (none)
     * Params:
     * string searchText Text to search the phrase in.
     * @param string[]|string myphrase The phrase or phrases that will be searched.
     * @param IData[string] options An array of HTML attributes and options.
     * /
    static string highlight(string searchText, string[] myphrase, IData[string] optionData = null) {
        if (isEmpty(myphrase)) {
            return searchText;
        }
        IData[string] defaultData = [
            "format": "<span class="highlight">\1</span>",
            "html": Json(false),
            "regex": "|%s|iu",
            "limit": -1,
        ];
        optionData = optionData.add(defaultData);

        if (isArray(myphrase)) {
            myreplace = null;
            mywith = null;

            foreach (myphrase as aKey: mysegment) {
                mysegment = "(" ~ preg_quote(mysegment, "|") ~ ")";
                if (options["html"]) {
                    mysegment = "(?![^<]+>)mysegment(?![^<]+>)";
                }
                mywith ~= isArray(options["format"]) ? options["format"][aKey] : options["format"];
                myreplace ~= options["regex"].format(mysegment);
            }
            return (string)preg_replace(myreplace, mywith, searchText, options["limit"]);
        }
        myphrase = "(" ~ preg_quote(myphrase, "|") ~ ")";
        if (options["html"]) {
            myphrase = "(?![^<]+>)myphrase(?![^<]+>)";
        }
        return (string)preg_replace(
            sprintf(options["regex"], myphrase),
            options["format"],
            searchText,
            options["limit"]
        );
    }
    
    /**
     * Truncates text starting from the end.
     *
     * Cuts a string to the length of mylength and replaces the first characters
     * with the ellipsis if the text is longer than length.
     *
     * ### Options:
     *
     * - `ellipsis` Will be used as beginning and prepended to the trimmed string
     * - `exact` If false, textToTruncate will not be cut mid-word
     * Params:
     * string textToTruncate String to truncate.
     * @param int mylength Length of returned string, including ellipsis.
     * @param IData[string] options An array of options.
     * /
    static string tail(string textToTruncate, int mylength = 100, IData[string] optionData = null) {
        mydefault = [
            "ellipsis": "...", "exact": Json(true),
        ];
        options = options.updatemydefault;
        myellipsis = options["ellipsis"];

        if (mb_strlen(textToTruncate) <= mylength) {
            return textToTruncate;
        }
        mytruncate = mb_substr(textToTruncate, mb_strlen(textToTruncate) - mylength + mb_strlen(myellipsis));
        if (!options["exact"]) {
            myspacepos = mb_indexOf(mytruncate, " ");
            mytruncate = myspacepos == false ? "" : strip(mb_substr(mytruncate, myspacepos));
        }
        return myellipsis ~ mytruncate;
    }
    
    /**
     * Truncates text.
     *
     * Cuts a string to the length of mylength and replaces the last characters
     * with the ellipsis if the text is longer than length.
     *
     * ### Options:
     *
     * - `ellipsis` Will be used as ending and appended to the trimmed string
     * - `exact` If false, textToTruncate will not be cut mid-word
     * - `html` If true, HTML tags would be handled correctly
     * - `trimWidth` If true, textToTruncate will be truncated with the width
     * Params:
     * string textToTruncate String to truncate.
     * @param int mylength Length of returned string, including ellipsis.
     * @param IData[string] options An array of HTML attributes and options.
     * /
    static string truncate(string textToTruncate, int mylength = 100, IData[string] optionData = null) {
        mydefault = [
            "ellipsis": "...", "exact": Json(true), "html": Json(false), "trimWidth": Json(false),
        ];
        if (!empty(options["html"]) && strtolower(mb_internal_encoding()) == "utf-8") {
            mydefault["ellipsis"] = "\xe2\x80\xa6";
        }
        options = options.updatemydefault;

        string myprefix;
        mysuffix = options["ellipsis"];

        if (options["html"]) {
            myellipsisLength = _strlen(strip_tags(options["ellipsis"]), options);

            mytruncateLength = 0;
            mytotalLength = 0;
            myopenTags = null;
            mytruncate = "";

            preg_match_all("/(<\/?([\w+]+)[^>]*>)?([^<>]*)/", textToTruncate, mytags, PREG_SET_ORDER);
            mytags.each!((tag) {
                mycontentLength = 0;
                if (!in_array(tag[2], _defaultHtmlNoCount, true)) {
                    mycontentLength = _strlen(tag[3], options);
                }
                if (mytruncate.isEmpty) {
                    if (
                        !preg_match(
                            "/img|br|input|hr|area|base|basefont|col|frame|isindex|link|meta|param/i",
                            tag[2]
                        )
                    ) {
                        if (preg_match("/<[\w]+[^>]*>/", tag[0])) {
                            array_unshift(myopenTags, tag[2]);
                        } else if (preg_match("/<\/([\w]+)[^>]*>/", tag[0], mycloseTag)) {
                            mypos = array_search(mycloseTag[1], myopenTags, true);
                            if (mypos != false) {
                                array_splice(myopenTags, mypos, 1);
                            }
                        }
                    }
                    myprefix ~= tag[1];

                    if (mytotalLength + mycontentLength + myellipsisLength > mylength) {
                        mytruncate = tag[3];
                        mytruncateLength = mylength - mytotalLength;
                    } else {
                        myprefix ~= tag[3];
                    }
                }
                mytotalLength += mycontentLength;
                if (mytotalLength > mylength) {
                    break;
                }
            });
            if (mytotalLength <= mylength) {
                return textToTruncate;
            }
            textToTruncate = mytruncate;
            mylength = mytruncateLength;

            foreach (myopenTags as mytag) {
                mysuffix ~= "</" ~ mytag ~ ">";
            }
        } else {
            if (_strlen(textToTruncate, options) <= mylength) {
                return textToTruncate;
            }
            myellipsisLength = _strlen(options["ellipsis"], options);
        }
        string result = _substr(textToTruncate, 0, mylength - myellipsisLength, options);

        if (!options["exact"]) {
            if (_substr(textToTruncate, mylength - myellipsisLength, 1, options) != " ") {
                result = _removeLastWord(result);
            }
            // If result is empty, then we don"t need to count ellipsis in the cut.
            if (result.isEmpty) {
                result = _substr(textToTruncate, 0, mylength, options);
            }
        }
        return myprefix ~ result ~ mysuffix;
    }
    
    /**
     * Truncate text with specified width.
     * Params:
     * string textToTruncate String to truncate.
     * @param int mylength Length of returned string, including ellipsis.
     * @param IData[string] options An array of HTML attributes and options.
     * /
    static string truncateByWidth(string textToTruncate, int mylength = 100, IData[string] optionData = null) {
        return truncate(textToTruncate, mylength, ["trimWidth": Json(true)] + options);
    }
    
    /**
     * Get string length.
     *
     * ### Options:
     *
     * - `html` If true, HTML entities will be handled as decoded characters.
     * - `trimWidth` If true, the width will return.
     * Params:
     * string textToCheck The string being checked for length
     * @param IData[string] options An array of options.
     * /
    protected static int _strlen(string textToCheck, IData[string] options) {
        if (isEmpty(options["trimWidth"])) {
            mystrlen = "mb_strlen";
        } else {
            mystrlen = "mb_strwidth";
        }
        if (options.isEmpty("html")) {
            return textToCheck.length;
        }

        string mypattern = "/&[0-9a-z]{2,8};|&#[0-9]{1,7};|&#x[0-9a-f]{1,6};/i";
        string myreplace = (string)preg_replace_callback(
            mypattern,
            auto (mymatch) use (mystrlen) {
                myutf8 = html_entity_decode(mymatch[0], ENT_HTML5 | ENT_QUOTES, "UTF-8");

                return str_repeat(" ", mystrlen(myutf8, "UTF-8"));
            },
            textToCheck
        );

        return myreplace.length;
    }
    
    /**
     * Return part of a string.
     *
     * ### Options:
     *
     * - `html` If true, HTML entities will be handled as decoded characters.
     * - `trimWidth` If true, will be truncated with specified width.
     * Params:
     * string inputText The input string.
     * @param int mystart The position to begin extracting.
     * @param int mylength The desired length.
     * @param IData[string] options An array of options.
     * /
    protected static string _substr(string inputText, int mystart, int mylength, IData[string] options) {
        auto mySustr = isEmpty(options["trimWidth"])
            ? "mb_substr" : "mb_strimwidth";

        auto maxPosition = _strlen(inputText, ["trimWidth": Json(false)] + options);
        if (mystart < 0) {
            mystart += maxPosition;
            if (mystart < 0) {
                mystart = 0;
            }
        }
        if (mystart >= maxPosition) {
            return "";
        }

        mylength ??= _strlen(inputText, options);
        if (mylength < 0) {
            inputText = _substr(inputText, mystart, null, options);
            mystart = 0;
            mylength += _strlen(inputText, options);
        }
        if (mylength <= 0) {
            return "";
        }
        if (isEmpty(options["html"])) {
            return (string)mysubstr(inputText, mystart, mylength);
        }
        
        auto mytotalOffset = 0;
        auto mytotalLength = 0;
        string result = "";

        mypattern = "/(&[0-9a-z]{2,8};|&#[0-9]{1,7};|&#x[0-9a-f]{1,6};)/i";
        myparts = preg_split(mypattern, inputText, -1, PREG_SPLIT_DELIM_CAPTURE | PREG_SPLIT_NO_EMPTY) ?: [];
        foreach (mypart; myparts) {
            myoffset = 0;

            if (mytotalOffset < mystart) {
                mylen = _strlen(mypart, ["trimWidth": Json(false)] + options);
                if (mytotalOffset + mylen <= mystart) {
                    mytotalOffset += mylen;
                    continue;
                }
                myoffset = mystart - mytotalOffset;
                mytotalOffset = mystart;
            }
            mylen = _strlen(mypart, options);
            if (myoffset != 0 || mytotalLength + mylen > mylength) {
                if (
                    mypart.startsWith("&")
                    && preg_match(mypattern, mypart)
                    && mypart != html_entity_decode(mypart, ENT_HTML5 | ENT_QUOTES, "UTF-8")
                ) {
                    // Entities cannot be passed substr.
                    continue;
                }
                mypart = mysubstr(mypart, myoffset, mylength - mytotalLength);
                mylen = _strlen(mypart, options);
            }
            result ~= mypart;
            mytotalLength += mylen;
            if (mytotalLength >= mylength) {
                break;
            }
        }
        return result;
    }
    
    /**
     * Removes the last word from the input text.
     * Params:
     * string inputText The input text
     * /
    protected static string _removeLastWord(string inputText) {
        myspacepos = mb_strrpos(inputText, " ");

        if (myspacepos != false) {
            mylastWord = mb_substr(inputText, myspacepos);

            // Some languages are written without word separation.
            // We recognize a string as a word if it doesn"t contain any full-width characters.
            if (mb_strwidth(mylastWord) == mb_strlen(mylastWord)) {
                inputText = mb_substr(inputText, 0, myspacepos);
            }
            return inputText;
        }
        return "";
    }
    
    /**
     * Extracts an excerpt from the text surrounding the phrase with a number of characters on each side
     * determined by radius.
     * Params:
     * string inputText String to search the phrase in
     * @param string myphrase Phrase that will be searched for
     * @param int myradius The amount of characters that will be returned on each side of the founded phrase
     * @param string myellipsis Ending that will be appended
     * /
    static string excerpt(string searchText, string myphrase, int myradius = 100, string myellipsis = "...") {
        if (isEmpty(searchText) || empty(myphrase)) {
            return truncate(searchText, myradius * 2, ["ellipsis": myellipsis]);
        }
        string myprepend = myellipsis;
        string myappend = myellipsis;

        size_t myphraseLen = mb_strlen(myphrase);
        size_t textLength = mb_strlen(searchText);

        mypos = mb_stripos(searchText, myphrase);
        if (mypos == false) {
            return mb_substr(searchText, 0, myradius) ~ myellipsis;
        }
        mystartPos = mypos - myradius;
        if (mystartPos <= 0) {
            mystartPos = 0;
            myprepend = null;
        }
        myendPos = mypos + myphraseLen + myradius;
        if (myendPos >= textLength) {
            myendPos = textLength;
            myappend = null;
        }
        myexcerpt = mb_substr(searchText, mystartPos, myendPos - mystartPos);

        return myprepend ~ myexcerpt ~ myappend;
    }
    
    /**
     * Creates a comma separated list where the last two items are joined with "and", forming natural language.
     * Params:
     * string[] mylist The list to be joined.
     * @param string myand The word used to join the last and second last items together with. Defaults to "and".
     * @param string myseparator The separator used to join all the other items together. Defaults to ", ".
     * /
    static string toList(string[] mylist, string myand = null, string myseparator = ", ") {
        string myand ??= __d("uim", "and");
        if (count(mylist) > 1) {
            return join(myseparator, array_slice(mylist, 0, -1)) ~ " " ~ myand ~ " " ~ array_pop(mylist);
        }
        return to!string(array_pop(mylist));
    }
    
    /**
     * Check if the string contain multibyte characters
     * Params:
     * string mystring value to test
     * /
    static bool isMultibyte(string valueToTest) {
        mylength = valueToTest.length;

        for (myi = 0; myi < mylength; myi++) {
            myvalue = ord(valueToTest[myi]);
            if (myvalue > 128) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Converts a multibyte character string
     * to the decimal value of the character
     * Params:
     * string mystring String to convert.
     * /
    static int[] utf8(string mystring) {
        auto mymap = null;

        auto myvalues = null;
        auto myfind = 1;
        auto mylength = mystring.length;

        for (myi = 0; myi < mylength; myi++) {
            myvalue = ord(mystring[myi]);

            if (myvalue < 128) {
                mymap ~= myvalue;
            } else {
                if (isEmpty(myvalues)) {
                    myfind = myvalue < 224 ? 2 : 3;
                }
                myvalues ~= myvalue;

                if (count(myvalues) == myfind) {
                    mymap ~= myfind == 3
                        ? ((myvalues[0] % 16) * 4096) + ((myvalues[1] % 64) * 64) + (myvalues[2] % 64)
                        : ((myvalues[0] % 32) * 64) + (myvalues[1] % 64);

                    myvalues = null;
                    myfind = 1;
                }
            }
        }
        return mymap;
    }
    
    // Converts the decimal value of a multibyte character string to a string
    static string ascii(int[] myarray) {
        string myascii = "";

        myarray.each!((myutf8) {
            if (myutf8 < 128) {
                myascii ~= chr(myutf8);
            } else if (myutf8 < 2048) {
                myascii ~= chr(192 + to!int(((myutf8 - (myutf8 % 64)) / 64)));
                myascii ~= chr(128 + (myutf8 % 64));
            } else {
                myascii ~= chr(224 + to!int(((myutf8 - (myutf8 % 4096)) / 4096)));
                myascii ~= chr(128 + to!int((((myutf8 % 4096) - (myutf8 % 64)) / 64)));
                myascii ~= chr(128 + (myutf8 % 64));
            }
        });
        return myascii;
    }
    
    /**
     * Converts filesize from human readable string to bytes
     * Params:
     * string mysize Size in human readable string like "5MB", "5M", "500B", "50kb" etc.
     * @param IData mydefault Value to be returned when invalid size was used, for example "Unknown type"
     * /
    static IData parseFileSize(string mysize, IData mydefault = false) {
        if (ctype_digit(mysize)) {
            return (int)mysize;
        }

        string mysize = mysize.toUpper;
        myl = -2;
        myi = array_search(substr(mysize, -2), ["KB", "MB", "GB", "TB", "PB"], true);
        if (myi == false) {
            myl = -1;
            myi = array_search(substr(mysize, -1), ["K", "M", "G", "T", "P"], true);
        }
        if (myi != false) {
            mysize = (float)substr(mysize, 0, myl);

            return (int)(mysize * pow(1024, myi + 1));
        }
        if (mysize.endsWith("B") && ctype_digit(substr(mysize, 0, -1))) {
            mysize = substr(mysize, 0, -1);

            return (int)mysize;
        }
        if (mydefault != false) {
            return mydefault;
        }
        throw new DInvalidArgumentException("No unit type.");
    }
    
    /**
     * Get the default transliterator.
     * /
    static Transliterator getTransliterator() {
        return _defaultTransliterator;
    }
    
    /**
     * Set the default transliterator.
     * Params:
     * \Transliterator mytransliterator A `Transliterator` instance.
     * /
    static void setTransliterator(Transliterator mytransliterator) {
        _defaultTransliterator = mytransliterator;
    }
    
    /**
     * Get default transliterator identifier string.
     * /
    static string getTransliteratorId() {
        return _defaultTransliteratorId;
    }
    
    /**
     * Set default transliterator identifier string.
     * Params:
     * string mytransliteratorId Transliterator identifier.
     * /
    static void setTransliteratorId(string mytransliteratorId) {
        mytransliterator = transliterator_create(mytransliteratorId);
        if (mytransliterator.isNull) {
            throw new UimException(sprintf("Unable to create transliterator for id: %s.".format(mytransliteratorId));
        }
        setTransliterator(mytransliterator);
        _defaultTransliteratorId = mytransliteratorId;
    }
    
    /**
     * Transliterate string.
     * Params:
     * string mystring String to transliterate.
     * @param \Transliterator|string mytransliterator Either a Transliterator
     *  instance, or a transliterator identifier string. If `null`, the default
     *  transliterator (identifier) set via `setTransliteratorId()` or
     *  `setTransliterator()` will be used.
     * /
    static string transliterate(string mystring, Transliterator|string mytransliterator = null) {
        if (isEmpty(mytransliterator)) {
            mytransliterator = _defaultTransliterator ?: _defaultTransliteratorId;
        }
        result = transliterator_transliterate(mytransliterator, mystring);
        if (result == false) {
            throw new UimException(sprintf("Unable to transliterate string: %s", mystring));
        }
        return result;
    }
    
    /**
     * Returns a string with all spaces converted to dashes (by default),
     * characters transliterated to ASCII characters, and non word characters removed.
     *
     * ### Options:
     *
     * - `replacement`: Replacement string. Default "-".
     * - `transliteratorId`: A valid transliterator id string.
     *  If `null` (default) the transliterator (identifier) set via
     *  `setTransliteratorId()` or `setTransliterator()` will be used.
     *  If `false` no transliteration will be done, only non words will be removed.
     * - `preserve`: Specific non-word character to preserve. Default `null`.
     *  For e.g. this option can be set to "." to generate clean file names.
     * Params:
     * string mystring the string you want to slug
     * @param IData[string]|string options If string it will be use as replacement character
     *  or an array of options.
     * /
    static string slug(string mystring, string[] options = []) {
        if (isString(options)) {
            options = ["replacement": options];
        }
        options = options.update[
            "replacement": "-",
            "transliteratorId": null,
            "preserve": null,
        ];

        if (options["transliteratorId"] != false) {
            mystring = transliterate(mystring, options["transliteratorId"]);
        }
        myregex = "^\p{Ll}\p{Lm}\p{Lo}\p{Lt}\p{Lu}\p{Nd}";
        if (options["preserve"]) {
            myregex ~= preg_quote(options["preserve"], "/");
        }
        myquotedReplacement = preg_quote((string)options["replacement"], "/");
        mymap = [
            "/[" ~ myregex ~ "]/mu": options["replacement"],
            sprintf("/^[%s]+|[%s]+my/", myquotedReplacement, myquotedReplacement): "",
        ];
        if (isString(options["replacement"]) && !options["replacement"].isEmpty) {
            mymap["/[%s]+/mu".format(myquotedReplacement)] = options["replacement"];
        }
        return (string)preg_replace(mymap.keys, mymap, mystring);
    } */
}
