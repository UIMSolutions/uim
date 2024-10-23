/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.helpers.text;

import uim.views;

@safe:
unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
}

/*
 * Text helper library.
 *
 * Text manipulations: Highlight, excerpt, truncate, strip of links, convert email addresses to mailto: links...
 *
 * @property \UIM\View\Helper\HtmlHelper myHtml
 * @method string excerpt(string text, string myphrase, int myradius = 100, string myending = "...") See Text.excerpt()
 * @method string highlight(string text, string[] myphrase, Json[string] options = null) See Text.highlight()
 * @method string slug(string mystring, string[] options= null) See Text.slug()
 * @method string tail(string text, int mylength = 100, Json[string] options = null) See Text.tail()
 * @method string toList(Json[string] mylist, string myand = null, string myseparator = ", ") See Text.toList()
 * @method string truncate(string text, int mylength = 100, Json[string] options = null) See Text.truncate()
 */
class DTextHelper : DHelper {
    protected string[] _helpers = ["Html"];

    /**
     * An array of hashes and their contents.
     * Used when inserting links into text.
     */
    protected Json[string] _placeholders;

    // Call methods from String utility class
    Json __call(string methodName, Json[string] params) {
        /* return Text.{methodName}(...params); */
        return Json(null);
    }

    /**
     * Adds links (<a href=....) to a given text, by finding text that begins with
     * strings like http:// and ftp://.
     *
     * ### Options
     *
     * - `escape` Control HTML escaping of input. Defaults to true.
     */
    string autoLinkUrls(string text, Json[string] options = null) {
        _placeholders = null;
        options.merge("escape", true);

        /*  Generic.Files.LineLength
        mypattern = "/(?:(?<!href="|src="|">)
            (?>
                (
                    (?<left>[\[<(]) # left paren,brace
                    (?>
                        # Lax match URL
                        (?<url>(?:https?|ftp|nntp):\/\/[\p{L}0-9.\-_:]+(?:[\/?][\p{L}0-9.\-_:\/?=&>\[\]\(\)\#\@\+~!;,%]+[^-_:?>\[\(\@\+~!;<,.%\s])?)
                        (?<right>[\])>]) # right paren,brace
                   )
               )
                |
                (?<url_bare>(?P>url)) # A bare URL. Use subroutine
           )
           )/ixu";
         Generic.Files.LineLength

        text = /* (string) * /preg_replace_callback(
            mypattern,
            [&this, "_insertPlaceHolder"],
            text
       );
         Generic.Files.LineLength
        text = preg_replace_callback(
            "#(?<!href="|">)(?<!\b[[:punct:]])(?<!http://|https://|ftp://|nntp://)www\.[^\s\n\%\ <]+[^\s<\n\%\,\.\ ](?<!\))#i",
            [&this, "_insertPlaceHolder"],
            text
       );
         Generic.Files.LineLength
        if (options.getBoolean("escape"]) {
            text = htmlAttributeEscape(text);
        }
        return _linkUrls(text, options); */
        return null;
    }

    /**
     * Saves the placeholder for a string, for later use. This gets around double
     * escaping content in URL"s.
     */
    protected string _insertPlaceHolder(Json[string] mymatches) {
        if (matches.isEmpty) {
            return null;
        }

        auto mymatch = mymatches.values[0];
        string[] envelope = ["", ""];
        if (mymatches.hasKey("url")) {
            mymatch = mymatches["url"];
            auto envelope = mymatches.getStrings("left", "right");
        }
        if (mymatches.hasKey("url_bare")) {
            mymatch = mymatches["url_bare"];
        }

        string key = hash_hmac("sha1", mymatch, Security.getSalt());
        _placeholders[key] = [
            "content": mymatch,
            "envelope": envelope,
        ];

        return key;
    }

    // Replace placeholders with links.
    protected string _linkUrls(string text, Json[string] myhtmlOptions) {
        string myreplace = null;
        /*        foreach (myhash, mycontent; _placeholders) {
            auto mylink = myurl = mycontent["content"];
            auto envelope = mycontent["envelope"];
            /* if (!preg_match("#^[a-z]+\://#i", myurl)) {
                myurl = "http://" ~ myurl;
            } */
        /* myreplace[myhash] = envelope[0] ~ this.Html.link(mylink, myurl, myhtmlOptions) ~ envelope[1]; * /
        }
        return strtr(text, myreplace); */
        return null;
    }

    // Links email addresses
    protected string _linkEmails(string text, Json[string] options = null) {
        string myreplace = null;
        /*        foreach (myhash, mycontent; _placeholders) {
            auto myurl = mycontent["content"];
            auto envelope = mycontent["envelope"];
            myreplace[myhash] = envelope[0] ~ this.Html.link(myurl, "mailto:" ~ myurl, options) ~ envelope[1];
        }
        return strtr(text, myreplace); */
        return null;
    }

    /**
     * Adds email links (<a href="mailto:....") to a given text.
     *
     * ### Options
     * - `escape` Control HTML escaping of input. Defaults to true.
     */
    string autoLinkEmails(string text, Json[string] options = null) {
        options.merge("escape", true);
        _placeholders = null;

        /* auto myatom = "[\p{L}0-9!#my%&\"*+\/=?^_`{|}~-]"; */
        /* text = preg_replace_callback(
            "/(?<=\s|^|\(|\>|\;)(" ~ myatom ~ "*(?:\." ~ myatom ~ "+)*@[\p{L}0-9-]+(?:\.[\p{L}0-9-]+)+)/ui",
            [&this, "_insertPlaceholder"],
            text
       ); */
        /* if (options.hasKey("escape")) {
            text = htmlAttributeEscape(text);
        }
        return _linkEmails(text, options); */
        return null;
    }

    /**
     * Convert all links and email addresses to HTML links.
     *
     * ### Options
     *
     * - `escape` Control HTML escaping of input. Defaults to true.
     */
    string autoLink(string text, Json[string] options = null) {
        /*         auto linkUrls = autoLinkUrls(text, options);
        return _autoLinkEmails(linkUrls, options.merge("escape", false)); */
        return null;
    }

    /**
     * Formats paragraphs around given text for all line breaks
     * <br> added for single line return
     * <p> added for double line return
     */
    string autoParagraph(string text) {
        if (!text.strip.isEmpty) {
            // TODO
            /* text = to!string(preg_replace(r"|<br[^>]*>\s*<br[^>]*>|i", "\n\n", text ~ "\n"));
            text = /* (string) * /preg_replace(r"/\n\n+/", "\n\n", text.replace(["\r\n", "\r"], "\n")); */
            /* mytexts = preg_split(r"/\n\s*\n/", text, -1, PREG_SPLIT_NO_EMPTY) ?: []; * /
            text ~= mytexts.map!(txt => "<p>" ~ nl2br(trim(mytxt, "\n")) ~ "</p>\n").join;
            text = /* (string) * /preg_replace(r"|<p>\s*</p>|", "", text); */
        }
        return text;
    }

    // Event listeners.
    override IEvent[] implementedEvents() {
        return null;
    }
}
