module uim.views.helpers.html;

import uim.views;

@safe:

/**
 * Html Helper class for easy use of HTML widgets.
 *
 * HtmlHelper encloses all methods needed while working with HTML pages.
 * @property \UIM\View\Helper\UrlHelper myUrl
 */
class DHtmlHelper : DHelper {
    mixin(HelperThis!("Html"));
    mixin TStringContents;

    // List of helpers used by this helper
    protected string[] myhelpers = ["Url"];

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    configuration
        .setDefault("templates", [
            "meta": "<meta{{attrs}}>",
            "metalink": "<link href=\"{{url}}\"{{attrs}}>",
            "link": "<a href=\"{{url}}\"{{attrs}}>{{content}}</a>",
            "mailto": "<a href=\"mailto:{{url}}\"{{attrs}}>{{content}}</a>",
            "image": "<img src=\"{{url}}\"{{attrs}}>",
            "tableheader": "<th{{attrs}}>{{content}}</th>",
            "tableheaderrow": "<tr{{attrs}}>{{content}}</tr>",
            "tablecell": "<td{{attrs}}>{{content}}</td>",
            "tablerow": "<tr{{attrs}}>{{content}}</tr>",
            "block": "<div{{attrs}}>{{content}}</div>",
            "blockstart": "<div{{attrs}}>",
            "blockend": "</div>",
            "tag": "<{{tag}}{{attrs}}>{{content}}</{{tag}}>",
            "tagstart": "<{{tag}}{{attrs}}>",
            "tagend": "</{{tag}}>",
            "tagselfclosing": "<{{tag}}{{attrs}}/>",
            "para": "<p{{attrs}}>{{content}}</p>",
            "parastart": "<p{{attrs}}>",
            "css": "<link rel=\"{{rel}}\" href=\"{{url}}\"{{attrs}}>",
            "style": "<style{{attrs}}>{{content}}</style>",
            "charset": "<meta charset=\"{{charset}}\">",
            "ul": "<ul{{attrs}}>{{content}}</ul>",
            "ol": "<ol{{attrs}}>{{content}}</ol>",
            "li": "<li{{attrs}}>{{content}}</li>",
            "javascriptblock": "<script{{attrs}}>{{content}}</script>",
            "javascriptstart": "<script>",
            "javascriptlink": "<script src=\"{{url}}\"{{attrs}}></script>",
            "javascriptend": "</script>",
            "confirmJs": "{{confirm}}",
        ].toJson
    ]);

    return true;
  }

    
    // Names of script & css files that have been included once
    // TODO protected array<string, array> _includedAssets = null;

    // Options for the currently opened script block buffer if any.
    protected Json[string] _scriptBlockOptions;

    /**
     * Creates a link to an external resource and handles basic meta tags
     *
     * Create a meta tag that is output inline:
     *
     * ```
     * this.Html.meta("icon", "favicon.ico");
     * ```
     *
     * Append the meta tag to custom view block "meta": 
     *
     * ```
     * this.Html.meta("description", "A great page", ["block": true.toJson]);
     * ```
     *
     * Append the meta tag to custom view block:
     *
     * ```
     * this.Html.meta("description", "A great page", ["block": "metaTags"]);
     * ```
     *
     * Create a custom meta tag:
     *
     * ```
     * this.Html.meta(["property": "og:site_name", "content": "UIM"]);
     * ```
     *
     * ### Options
     *
     * - `block` - Set to true to append output to view block "meta" or provide
     * custom block name.
     * Params:
     * Json[string]|string mytype The title of the external resource, Or an array of attributes for a
     * custom meta tag.
     */
    string meta(string[] mytype, string[] content = null, Json[string] htmlAttributes = null) {
        if (!mytype.isArray) {
            mytypes = [
                "rss": ["type": "application/rss+xml", "rel": "alternate", "title": mytype, "link": content],
                "atom": ["type": "application/atom+xml", "title": mytype, "link": content],
                "icon": ["type": "image/x-icon", "rel": "icon", "link": content],
                "keywords": ["name": "keywords", "content": content],
                "description": ["name": "description", "content": content],
                "robots": ["name": "robots", "content": content],
                "viewport": ["name": "viewport", "content": content],
                "canonical": ["rel": "canonical", "link": content],
                "next": ["rel": "next", "link": content],
                "prev": ["rel": "prev", "link": content],
                "first": ["rel": "first", "link": content],
                "last": ["rel": "last", "link": content],
            ];

            if (mytype == "icon" && content.isNull) {
                mytypes.set("icon.link", "favicon.ico");
            }
            if (mytypes.hasKey(mytype)) {
                mytype = mytypes[mytype];
            } else if (!htmlAttributes.hasKey("type") && content !is null) {
                mytype = isArray(content) && content.hasKey("_ext")
                    ? mytypes[content.getString("_ext")]
                    : ["name": mytype, "content": content];

            } else if (htmlAttributes.hasKey("type") && mytypes.hasKey(htmlAttributes.getString("type"))) {
                mytype = mytypes[htmlAttributes["type"]];
                htmlAttributes.remove("type");
            } else {
                mytype = null;
            }
        }
        htmlAttributes += mytype ~ ["block": Json(null)];
        string result = "";

        if (htmlAttributes.hasKey("link")) {
            htmlAttributes.set("link", htmlAttributes.isArray("link")
                ? _Url.build(htmlAttributes.get("link"))
                : _Url.assetUrl(htmlAttributes.get("link")));

            if (htmlAttributes.getString("rel") == "icon") {
                result = formatTemplate("metalink", [
                    "url": htmlAttributes["link"],
                    "attrs": templater().formatAttributes(htmlAttributes, ["block", "link"]),
                ]);
                htmlAttributes.set("rel", "shortcut icon");
            }
            result ~= formatTemplate("metalink", [
                "url": htmlAttributes["link"],
                "attrs": templater().formatAttributes(htmlAttributes, ["block", "link"]),
            ]);
        } else {
            result = formatTemplate("meta", [
                "attrs": templater().formatAttributes(htmlAttributes, ["block", "type"]),
            ]);
        }
        if (htmlAttributes.isEmpty("block")) {
            return result;
        }
        if (htmlAttributes["block"] == true) {
            htmlAttributes.set("block", __FUNCTION__);
        }
       _view.append(htmlAttributes["block"], result);

        return null;
    }
    
    /**
     * Returns a charset META-tag.
     * Params:
     * string mycharset The character set to be used in the meta tag. If empty,
     * The App.encoding value will be used. Example: "utf-8".
     */
    string charset(string metatagCharset = null) {
        string result; 
        if (metatagCharset.isEmpty) {
            result = to!string(configuration.get("App.encoding")).lower;
        }
        return _formatTemplate("charset", [
            "charset": !result.isEmpty ? result : "utf-8",
        ]);
    }
    
    /**
     * Creates an HTML link.
     *
     * If url starts with "http://" this is treated as an external link. Else,
     * it is treated as a path to controller/action and parsed with the
     * UrlHelper.build() method.
     *
     * If the url is empty, title is used instead.
     *
     * ### Options
     *
     * - `escape` Set to false to disable escaping of title and attributes.
     * - `escapeTitle` Set to false to disable escaping of title. Takes precedence
     * over value of `escape`)
     * - `confirm` JavaScript confirmation message.
      */
    string link(string[] title, string[] url = null, Json[string] htmlAttributes = null) {
        auto myescapeTitle = true;
        if (!url.isNull) {
            url = _Url.build(url, htmlAttributes);
            htmlAttributes.remove("fullBase");
        } else {
            url = _Url.build(title);
            title = htmlspecialchars_decode(url, ENT_QUOTES);
            title = htmlAttributeEscape(urldecode(title));
            myescapeTitle = false;
        }
        if (htmlAttributes.hasKey("escapeTitle")) {
            myescapeTitle = htmlAttributes["escapeTitle"];
            htmlAttributes.remove("escapeTitle");
        } else if (htmlAttributes.hasKey("escape")) {
            myescapeTitle = htmlAttributes["escape"];
        }
        if (myescapeTitle == true) {
            title = htmlAttributeEscape(title);
        } else if (isString(myescapeTitle)) {
            /** @psalm-suppress PossiblyInvalidArgument */
            title = htmlentities(title, ENT_QUOTES, myescapeTitle);
        }
        mytemplater = templater();
        myconfirmMessage = null;
        if (htmlAttributes.hasKey("confirm")) {
            myconfirmMessage = htmlAttributes["confirm"];
            htmlAttributes.remove("confirm");
        }
        if (myconfirmMessage) {
            myconfirm = _confirm("return true;", "return false;");
            htmlAttributes.set("data-confirm-message", myconfirmMessage);
            htmlAttributes.set("onclick", mytemplater.format("confirmJs", [
                "confirmMessage": htmlAttributeEscape(myconfirmMessage),
                "confirm": myconfirm,
            ]));
        }
        return mytemplater.format("link", [
            "url": url,
            "attrs": mytemplater.formatAttributes(htmlAttributes),
            "content": title,
        ]);
    }
    
    /**
     * Creates an HTML link from route path string.
     *
     * ### Options
     *
     * - `escape` Set to false to disable escaping of title and attributes.
     * - `escapeTitle` Set to false to disable escaping of title. Takes precedence
     * over value of `escape`)
     * - `confirm` JavaScript confirmation message.
     */
    string linkFromPath(string title, string routePath, Json[string] params = [], Json[string] htmlAttributes = null) {
        return _link(title, ["_path": routePath] + params, htmlAttributes);
    }
    
    /**
     * Creates a link element for CSS stylesheets.
     *
     * ### Usage
     *
     * Include one CSS file:
     *
     * ```
     * writeln(this.Html.css("styles.css");
     * ```
     *
     * Include multiple CSS files:
     *
     * ```
     * writeln(this.Html.css(["one.css", "two.css"]);
     * ```
     *
     * Add the stylesheet to view block "css": 
     *
     * ```
     * this.Html.css("styles.css", ["block": true.toJson]);
     * ```
     *
     * Add the stylesheet to a custom block:
     *
     * ```
     * this.Html.css("styles.css", ["block": "layoutCss"]);
     * ```
     *
     * ### Options
     *
     * - `block` Set to true to append output to view block "css" or provide
     * custom block name.
     * - `once` Whether the css file should be checked for uniqueness. If true css
     * files  will only be included once, use false to allow the same
     * css to be included more than once per request.
     * - `plugin` False value will prevent parsing path as a plugin
     * - `rel` Defaults to "stylesheet". If equal to "import" the stylesheet will be imported.
     * - `fullBase` If true the URL will get a full address for the css file.
     *
     * All other options will be treated as HTML attributes. If the request contains a
     * `cspStyleNonce` attribute, that value will be applied as the `nonce` attribute on the
     * generated HTML.
     * Params:
     * string[]|string mypath The name of a CSS style sheet or an array containing names of
     * CSS stylesheets. If `mypath` is prefixed with "/", the path will be relative to the webroot
     * of your application. Otherwise, the path will be relative to your CSS path, usually webroot/css.
     */
    string css(string[] mypath, Json[string] htmlAttributes = null) {
        string result = mypath.map!(path => "\n\t" ~ css(index, htmlAttributes)).join;
        return htmlAttributes.isEmpty("block")
            ? result ~ "\n"
            : null;
    }

    string css(string[] mypath, Json[string] htmlAttributes = null) {
        auto htmlAttributes = htmlAttributes.setPath([
            "once": true.toJson,
            "block": Json(null),
            "rel": "stylesheet".toJson,
            "nonce": _view.getRequest().getAttribute("cspStyleNonce").toJson,
        ]);

        auto url = _Url.css(mypath, htmlAttributes);
        auto htmlAttributes = array_diffinternalKey(htmlAttributes, ["fullBase": Json(null), "pathPrefix": Json(null)]);

        if (htmlAttributes["once"] && _includedAssets.hasKey([__METHOD__, mypath])) {
            return null;
        }
        htmlAttributes.remove("once");
       _includedAssets[__METHOD__][mypath] = true;

        auto mytemplater = templater();
        if (htmlAttributes.getString("rel") == "import") {
            result = mytemplater.format("style", [
                "attrs": mytemplater.formatAttributes(htmlAttributes, ["rel", "block"]),
                "content": "@import url(" ~ url ~ ");",
            ]);
        } else {
            result = mytemplater.format("css", [
                "rel": htmlAttributes["rel"],
                "url": url,
                "attrs": mytemplater.formatAttributes(htmlAttributes, ["rel", "block"]),
            ]);
        }
        if (htmlAttributes.isEmpty("block")) {
            return result;
        }
        if (htmlAttributes.hasKey("block")) {
            htmlAttributes.set("block", __FUNCTION__);
        }
       _view.append(htmlAttributes.get("block"), result);

        return null;
    }
    
    /**
     * Returns one or many `<script>` tags depending on the number of scripts given.
     *
     * If the filename is prefixed with "/", the path will be relative to the base path of your
     * application. Otherwise, the path will be relative to your JavaScript path, usually webroot/js.
     *
     * ### Usage
     *
     * Include one script file:
     *
     * ```
     * writeln(this.Html.script("styles.js");
     * ```
     *
     * Include multiple script files:
     *
     * ```
     * writeln(this.Html.script(["one.js", "two.js"]);
     * ```
     *
     * Add the script file to a custom block:
     *
     * ```
     * this.Html.script("styles.js", ["block": "bodyScript"]);
     * ```
     *
     * ### Options
     *
     * - `block` Set to true to append output to view block "script" or provide
     * custom block name.
     * - `once` Whether the script should be checked for uniqueness. If true scripts will only be
     * included once, use false to allow the same script to be included more than once per request.
     * - `plugin` False value will prevent parsing path as a plugin
     * - `fullBase` If true the url will get a full address for the script file.
     *
     * All other options will be added as attributes to the generated script tag.
     * If the current request has a `cspScriptNonce` attribute, that value will
     * be inserted as a `nonce` attribute on the script tag.
     */
    string script(string[] url, Json[string] htmlAttributes = null) {
        mydefaults = [
            "block": Json(null),
            "once": true.toJson,
            "nonce": _view.getRequest().getAttribute("cspScriptNonce"),
        ];
        htmlAttributes += mydefaults;

        if (url.isArray) {
            string result = url.map!(i => "\n\t" ~ /* (string) */this.script(index, htmlAttributes)).join;
            if (htmlAttributes.isEmpty("block")) {
                return result ~ "\n";
            }
            return null;
        }
        url = _Url.script(url, htmlAttributes);
        htmlAttributes = array_diffinternalKey(htmlAttributes, ["fullBase": Json(null), "pathPrefix": Json(null)]);

        if (htmlAttributes["once"] && _includedAssets.hasKey([__METHOD__, url])) {
            return null;
        }
       _includedAssets[__METHOD__][url] = true;

        result = this.formatTemplate("javascriptlink", [
            "url": url,
            "attrs": templater().formatAttributes(htmlAttributes, ["block", "once"]),
        ]);

        if (htmlAttributes.isEmpty("block")) {
            return result;
        }

        if (htmlAttributes["block"] == true) {
            htmlAttributes.set("block", __FUNCTION__);
        }
       _view.append(htmlAttributes["block"], result);

        return null;
    }
    
    /**
     * Wrap myscript in a script tag.
     *
     * ### Options
     *
     * - `block` Set to true to append output to view block "script" or provide
     * custom block name.
     */
    string scriptBlock(string script, Json[string] htmlAttributes = null) {
        htmlAttributes += ["block": Json(null), "nonce": _view.getRequest().getAttribute("cspScriptNonce")];

        auto result = this.formatTemplate("javascriptblock", [
            "attrs": templater().formatAttributes(htmlAttributes, ["block"]),
            "content": myscript,
        ]);

        if (isEmpty(htmlAttributes["block"])) {
            return result;
        }
        if (htmlAttributes["block"] == true) {
            htmlAttributes.set("block", "script");
        }
       _view.append(htmlAttributes["block"], result);

        return null;
    }
    
    /**
     * Begin a script block that captures output until HtmlHelper.scriptEnd()
     * is called. This capturing block will capture all output between the methods
     * and create a scriptBlock from it.
     *
     * ### Options
     *
     * - `block` Set to true to append output to view block "script" or provide
     * custom block name.
     */
    void scriptStart(Json[string] optionsForCodeblock  = null) {
       _scriptBlockOptions = optionsForCodeblock;
        ob_start();
    }
    
    /**
     * End a Buffered section of JavaScript capturing.
     * Generates a script tag inline or appends to specified view block depending on
     * the settings used when the scriptBlock was started
     */
    string scriptEnd() {
        mybuffer = /* (string) */ob_get_clean();
        options = _scriptBlockOptions;
       _scriptBlockOptions = null;

        return _scriptBlock(mybuffer, options);
    }
    
    /**
     * Builds CSS style data from an array of CSS properties
     *
     * ### Usage:
     *
     * ```
     * writeln(this.Html.style(["margin": "10px", "padding": "10px"], true);
     *
     * creates
     * "margin:10px;padding:10px;"
     * ```
     */
    string style(Json[string] data, bool shouldOneLine = true) {
        string[] result = data.byKeyValue.map!(kv => kv.key ~ ": " ~ kv.value ~ ";").array;
        return shouldOneLine
            ? result.join(" ")
            : result.join("\n");
    }
    
    /**
     * Creates a formatted IMG element.
     *
     * This method will set an empty alt attribute if one is not supplied.
     *
     * ### Usage:
     *
     * Create a regular image:
     *
     * ```
     * writeln(this.Html.image("uim_icon.png", ["alt": "UIM"]);
     * ```
     *
     * Create an image link:
     *
     * ```
     * writeln(this.Html.image("uim_icon.png", ["alt": "UIM", "url": "https://UIM.org"]);
     * ```
     *
     * ### Options:
     *
     * - `url` If provided an image link will be generated and the link will point at
     * `options.get("url")`.
     * - `fullBase` If true the src attribute will get a full address for the image file.
     * - `plugin` False value will prevent parsing path as a plugin
     * Params:
     * string[] mypath Path to the image file, relative to the webroot/img/ directory.
     */
    string image(string[] pathToImageFile, Json[string] htmlAttributes = null) {
        pathToImageFile = pathToImageFile.isString
            ? _Url.image(pathToImageFile, htmlAttributes)
            : _Url.build(pathToImageFile, htmlAttributes);

        htmlAttributes = array_diffinternalKey(htmlAttributes, ["fullBase": Json(null), "pathPrefix": Json(null)]);

        if (!htmlAttributes.hasKey("alt")) {
            htmlAttributes.set("alt", "");
        }
        
        auto url = false;
        if (!htmlAttributes.isEmpty("url"))) {
            url = htmlAttributes["url"];
            htmlAttributes.remove("url");
        }

        auto mytemplater = templater();
        auto myimage = mytemplater.format("image", [
            "url": pathToImageFile,
            "attrs": mytemplater.formatAttributes(htmlAttributes),
        ]);

        if (url) {
            return mytemplater.format("link", [
                "url": _Url.build(url),
                "attrs": Json(null),
                "content": myimage,
            ]);
        }
        return myimage;
    }
    
    /**
     * Returns a row of formatted and named TABLE headers.
     * Params:
     * array views Array of tablenames. Each tablename can be string, or array with name and an array with a set
     *   of attributes to its specific tag
     */
    string tableHeaders(Json[string] tableNames, Json[string] trOptions = null, Json[string] thOptions = null) {
        string attributes = null;
        string result = null;
        foreach (tableName; tableNames) {
            string content; 
            if (!isArray(tableName)) {
                content = tableName;
                attributes = thOptions;
            } else if (tableName.has(0) && tableName.has(1)) {
                content = tableName[0];
                attributes = tableName[1];
            } else {
                content = key(vitableNameew);
                attributes = currentValue(tableName);
            }
            result ~= this.formatTemplate("tableheader", [
                "attrs": templater().formatAttributes(attributes),
                "content": content,
            ]);
        }
        return _tableRow(result.join(" "), trOptions);
    }
    
    // Returns a formatted string of table rows (TR"s with TD"s in them).
    string tableCells(
        string[] tableData,
        Json oddTrOptions = null,
        Json evenTrOptions = null,
        bool useCount = false,
        bool continueOddEven = true
   ) {
        if (!tableData.isArray) {
            tableData = [[tableData]];
        } else if (tableData[0].isEmpty || !tableData[0].isArray) {
            tableData = [tableData];
        }
        if (oddTrOptions == true) {
            shouldUseCount = true;
            oddTrOptions = null;
        }
        if (evenTrOptions == false) {
            continueOddEven = false;
            evenTrOptions = null;
        }
        if (continueOddEven) {
            static mycount = 0;
        } else {
            mycount = 0;
        }
        auto result = null;
        tableData.each!((line) {
            mycount++;
            mycellsOut = _renderCells(line, shouldUseCount);
            myopts = mycount % 2 ? oddTrOptions : evenTrOptions;

            Json[string] htmlAttributes = (array)myopts;
            result ~= this.tableRow(mycellsOut.join(" "), htmlAttributes);
        });

        return result.join("\n");
    }
    
    /**
     * Renders cells for a row of a table.
     *
     * This is a helper method for tableCells(). Overload this method as you
     * need to change the behavior of the cell rendering.
     */
    protected string[] _renderCells(Json[string] linesToRender, bool shouldUseCount = false) {
        auto index = 0;
        auto mycellsOut = null;
        linesToRender.each!((cell) {
            auto cellOptions = null;

            if (isArray(cell)) {
                cellOptions = cell[1];
                cell = cell[0];
            }
            if (shouldUseCount) {
                index += 1;

                cellOptions.set("class", cellOptions.hasKey("class")
                    ? cellOptions.getString("class") ~ " column-" ~ index
                    : "column-" ~ index
                );
            }
            mycellsOut ~= tableCell(/* (string) */cell, cellOptions);
        });
        return mycellsOut;
    }
    
    // Renders a single table row (A TR with attributes).
    string tableRow(string content, Json[string] htmlAttributes = null) {
        return _formatTemplate("tablerow", [
            "attrs": templater().formatAttributes(htmlAttributes),
            "content": content,
        ]);
    }
    
    // Renders a single table cell (A TD with attributes).
    string tableCell(string content, Json[string] htmlAttributes = null) {
        return _formatTemplate("tablecell", [
            "attrs": templater().formatAttributes(htmlAttributes),
            "content": content,
        ]);
    }
    
    /**
     * Returns a formatted block tag, i.e DIV, SPAN, P.
     *
     * ### Options
     * - `escape` Whether the contents should be html_entity escaped.
     */
    string tag(string tagName, string content = null, Json[string] htmlAttributes = null) {
        if (htmlAttributes.hasKey("escape") && htmlAttributes["escape"]) {
            Json content = htmlAttributeEscape(content);
            remove(htmlAttributes["escape"]);
        }

        auto tag = content.isNull ? "tagstart" : "tag";
        return _formatTemplate(tag, [
            "attrs": templater().formatAttributes(htmlAttributes),
            "tag": tagName,
            "content": content,
        ]);
    }
    
    /**
     * Returns a formatted DIV tag for HTML FORMs.
     *
     * ### Options
     *
     * - `escape` Whether the contents should be html_entity escaped.
     */
    string div(string cssClass = null, string content = null, Json[string] htmlAttributes = null) {
        if (!cssClass.isEmpty) {
            htmlAttributes.set("class", cssClass);
        }
        return _tag("div", content, htmlAttributes);
    }
    
    /**
     * Returns a formatted P tag.
     *
     * ### Options
     *
     * - `escape` Whether the contents should be html_entity escaped.
     */
    string para(string cssClass, string content, Json[string] htmlAttributes = null) {
        if (!htmlAttributes.isEmpty("escape")) {
            content = htmlAttributeEscape(content);
        }
        if (cssClass) {
            htmlAttributes.set("class", cssClass);
        }
        
        auto tag = "para";
        if (content.isNull) {
            tag = "parastart";
        }
        return _formatTemplate(tag, [
            "attrs": templater().formatAttributes(htmlAttributes),
            "content": content,
        ]);
    }
    
    /**
     * Returns an audio/video element
     *
     * ### Usage
     *
     * Using an audio file:
     *
     * ```
     * writeln(this.Html.media("audio.mp3", ["fullBase": true.toJson]);
     * ```
     *
     * Outputs:
     *
     * ```
     * <video src="http://www.somehost.com/files/audio.mp3">Fallback text</video>
     * ```
     *
     * Using a video file:
     *
     * ```
     * writeln(this.Html.media("video.mp4", ["text": "Fallback text"]);
     * ```
     *
     * Outputs:
     *
     * ```
     * <video src="/files/video.mp4">Fallback text</video>
     * ```
     *
     * Using multiple video files:
     *
     * ```
     * writeln(this.Html.media(
     *    ["video.mp4", ["src": "video.ogv", "type": "video/ogg; codecs="theora, vorbis""]],
     *    ["tag": "video", "autoplay"]
     *);
     * ```
     *
     * Outputs:
     *
     * ```
     * <video autoplay="autoplay">
     *    <source src="/files/video.mp4" type="video/mp4">
     *    <source src="/files/video.ogv" type="video/ogv; codecs="theora, vorbis"">
     * </video>
     * ```
     *
     * ### Options
     *
     * - `tag` Type of media element to generate, either "audio" or "video".
     * If tag is not provided it"s guessed based on file"s mime type.
     * - `text` Text to include inside the audio/video tag
     * - `pathPrefix` Path prefix to use for relative URLs, defaults to "files/"
     * - `fullBase` If provided the src attribute will get a full address including domain name
     * Params:
     * string[] pathToImageFile Path to the video file, relative to the webroot/{htmlAttributes["pathPrefix"]} directory.
     * Or an array where each item itself can be a path string or an associate array containing keys `src` and `type`
     */
    string media(string[] pathToImageFile, Json[string] htmlAttributes = null) {
        htmlAttributes.merge([
            "tag": Json(null),
            "pathPrefix": "files/",
            "text": "",
        ]);

        auto mytag = !htmlAttributes.isEmpty("tag") 
            ? htmlAttributes["tag"]
            : null;

        if (pathToImageFile.isArray) {
            auto mysourceTags = "";
            foreach (&mysource; pathToImageFile) {
                if (isString(mysource)) {
                    mysource = [
                        "src": mysource,
                    ];
                }
                if (!mysource.hasKey("type")) {
                    myext = pathinfo(mysource["src"], PATHINFO_EXTENSION);
                    mysource["type"] = _view.getResponse().getMimeType(myext);
                }
                mysource["src"] = _Url.assetUrl(mysource["src"], htmlAttributes);
                mysourceTags ~= this.formatTemplate("tagselfclosing", [
                    "tag": "source",
                    "attrs": templater().formatAttributes(mysource),
                ]);
            }
            remove(mysource);
            htmlAttributes["text"] = mysourceTags ~ htmlAttributes["text"];
            remove(htmlAttributes["fullBase"]);
        } else {
            if (isEmpty(pathToImageFile) && !htmlAttributes.isEmpty("src"))) {
                pathToImageFile = htmlAttributes["src"];
            }
            /** @psalm-suppress PossiblyNullArgument */
            htmlAttributes.set("src", _Url.assetUrl(pathToImageFile, htmlAttributes));
        }
        if (mytag.isNull) {
            if (pathToImageFile.isArray) {
                mymimeType = pathToImageFile[0]["type"];
            } else {
                mymimeType = _view.getResponse().getMimeType(pathinfo(pathToImageFile, PATHINFO_EXTENSION));
                assert(isString(mymimeType));
            }

            mytag = mymimeType.startsWith("video/")
                ? "video"
                : "audio";
            }
        }
        if (htmlAttributes.hasKey("poster")) {
            htmlAttributes["poster"] = _Url.assetUrl(
                htmlAttributes["poster"],
                ["pathPrefix": configuration.get("App.imageBaseUrl")] + htmlAttributes
           );
        }
        content = htmlAttributes["text"];
        htmlAttributes = array_diffinternalKey(htmlAttributes, [
            "tag": Json(null),
            "fullBase": Json(null),
            "pathPrefix": Json(null),
            "text": Json(null),
        ]);

        return _tag(mytag, content, htmlAttributes);
    }
    
    /**
     * Build a nested list (UL/OL) out of an associative array.
     *
     * Options for htmlAttributes:
     *
     * - `tag` - Type of list tag to use (ol/ul)
     *
     * Options for myitemOptions:
     *
     * - `even` - Class to use for even rows.
     * - `odd` - Class to use for odd rows.
     * Params:
     * array mylist Set of elements to list
     */
    string|int|false nestedList(Json[string] mylist, Json[string] listAttributes = null, Json[string] liAttributes= null) {
        listAttributes += ["tag": "ul"];
        myitems = _nestedListItem(mylist, listAttributes, liAttributes);

        return _formatTemplate(listAttributes["tag"], [
            "attrs": templater().formatAttributes(listAttributes, ["tag"]),
            "content": myitems,
        ]);
    }
    
    /**
     * Internal auto to build a nested list (UL/OL) out of an associative array.
     * Params:
     * array myitems Set of elements to list.
     */
    protected string _nestedListItem(Json[string] myitems, Json[string] listAttributes, Json[string] liAttributes) {
        string result = "";

        auto myindex = 1;
        foreach (aKey: myitem; myitems) {
            if (isArray(myitem)) {
                myitem = aKey ~ this.nestedList(myitem, listAttributes, liAttributes);
            }
            if (liAttributes.hasKey("even") && myindex % 2 == 0) {
                liAttributes.set("class", liAttributes["even"]);
            } else if (liAttributes.hasKey("odd") && myindex % 2 != 0) {
                liAttributes.set("class", liAttributes["odd"]);
            }
            result ~= this.formatTemplate("li", [
                "attrs": templater().formatAttributes(liAttributes, ["even", "odd"]),
                "content": myitem,
            ]);
            myindex++;
        }
        return result;
    }
    
    /**
     * Event listeners.
     */
    IEvent[] implementedEvents() {
        return null;
    } 
}
