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

    configuration.updateDefaults([
        "templates": [
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
     *  custom block name.
     * Params:
     * Json[string]|string mytype The title of the external resource, Or an array of attributes for a
     *  custom meta tag.
     * @param string[] mycontent The address of the external resource or string for content attribute
     * @param Json[string] htmlAttributes Other attributes for the generated tag. If the type attribute is html,
     *   rss, atom, or icon, the mime-type is returned.
     * /
    string meta(string[] mytype, string[] mycontent = null, Json[string] htmlAttributes = null) {
        if (!mytype.isArray) {
            mytypes = [
                "rss": ["type": "application/rss+xml", "rel": "alternate", "title": mytype, "link": mycontent],
                "atom": ["type": "application/atom+xml", "title": mytype, "link": mycontent],
                "icon": ["type": "image/x-icon", "rel": "icon", "link": mycontent],
                "keywords": ["name": "keywords", "content": mycontent],
                "description": ["name": "description", "content": mycontent],
                "robots": ["name": "robots", "content": mycontent],
                "viewport": ["name": "viewport", "content": mycontent],
                "canonical": ["rel": "canonical", "link": mycontent],
                "next": ["rel": "next", "link": mycontent],
                "prev": ["rel": "prev", "link": mycontent],
                "first": ["rel": "first", "link": mycontent],
                "last": ["rel": "last", "link": mycontent],
            ];

            if (mytype == "icon" && mycontent.isNull) {
                mytypes["icon"]["link"] = "favicon.ico";
            }
            if (isSet(mytypes[mytype])) {
                mytype = mytypes[mytype];
            } elseif (!htmlAttributes.isSet("type") && mycontent !isNull) {
                mytype = isArray(mycontent) && isSet(mycontent["_ext"])
                    ? mytypes[mycontent["_ext"]]
                    : ["name": mytype, "content": mycontent];

            } elseif (isSet(htmlAttributes["type"], mytypes[htmlAttributes["type"]])) {
                mytype = mytypes[htmlAttributes["type"]];
                unset(htmlAttributes["type"]);
            } else {
                mytype = null;
            }
        }
        htmlAttributes += mytype ~ ["block": null];
        string result = "";

        if (isSet(htmlAttributes["link"])) {
            htmlAttributes["link"] = isArray(htmlAttributes["link"]) 
                ? this.Url.build(htmlAttributes["link"])
                this.Url.assetUrl(htmlAttributes["link"]);

            if (isSet(htmlAttributes["rel"]) && htmlAttributes["rel"] == "icon") {
                result = this.formatTemplate("metalink", [
                    "url": htmlAttributes["link"],
                    "attrs": this.templater().formatAttributes(htmlAttributes, ["block", "link"]),
                ]);
                htmlAttributes["rel"] = "shortcut icon";
            }
            result ~= this.formatTemplate("metalink", [
                "url": htmlAttributes["link"],
                "attrs": this.templater().formatAttributes(htmlAttributes, ["block", "link"]),
            ]);
        } else {
            result = this.formatTemplate("meta", [
                "attrs": this.templater().formatAttributes(htmlAttributes, ["block", "type"]),
            ]);
        }
        if (htmlAttributes..isEmpty("block")) {
            return result;
        }
        if (htmlAttributes["block"] == true) {
            htmlAttributes["block"] = __FUNCTION__;
        }
       _View.append(htmlAttributes["block"], result);

        return null;
    }
    
    /**
     * Returns a charset META-tag.
     * Params:
     * string|null mycharset The character set to be used in the meta tag. If empty,
     * The App.encoding value will be used. Example: "utf-8".
     * /
    string charset(string metatagCharset = null) {
        string result; 
        if (metatagCharset.isEmpty) {
            result = to!string(Configuration.read("App.encoding")).toLower;
        }
        return _formatTemplate("charset", [
            "charset": !result.isEmpty ? result : "utf-8",
        ]);
    }
    
    /**
     * Creates an HTML link.
     *
     * If myurl starts with "http://" this is treated as an external link. Else,
     * it is treated as a path to controller/action and parsed with the
     * UrlHelper.build() method.
     *
     * If the myurl is empty, mytitle is used instead.
     *
     * ### Options
     *
     * - `escape` Set to false to disable escaping of title and attributes.
     * - `escapeTitle` Set to false to disable escaping of title. Takes precedence
     *  over value of `escape`)
     * - `confirm` JavaScript confirmation message.
     * Params:
     * string[] mytitle The content to be wrapped by `<a>` tags.
     *  Can be an array if myurl.isNull. If myurl.isNull, mytitle will be used as both the URL and title.
     * @param string[] myurl uim-relative URL or array of URL parameters, or
     *  external URL (starts with http://)
     * @param Json[string] htmlAttributes Array of options and HTML attributes.
      * /
    string link(string[] mytitle, string[] myurl = null, Json[string] htmlAttributes = null) {
        myescapeTitle = true;
        if (myurl !isNull) {
            myurl = this.Url.build(myurl, htmlAttributes);
            htmlAttributes.remove("fullBase");
        } else {
            myurl = this.Url.build(mytitle);
            mytitle = htmlspecialchars_decode(myurl, ENT_QUOTES);
            mytitle = htmlAttribEscape(urldecode(mytitle));
            myescapeTitle = false;
        }
        if (isSet(htmlAttributes["escapeTitle"])) {
            myescapeTitle = htmlAttributes["escapeTitle"];
            unset(htmlAttributes["escapeTitle"]);
        } elseif (isSet(htmlAttributes["escape"])) {
            myescapeTitle = htmlAttributes["escape"];
        }
        if (myescapeTitle == true) {
            mytitle = htmlAttribEscape(mytitle);
        } elseif (isString(myescapeTitle)) {
            /** @psalm-suppress PossiblyInvalidArgument * /
            mytitle = htmlentities(mytitle, ENT_QUOTES, myescapeTitle);
        }
        mytemplater = this.templater();
        myconfirmMessage = null;
        if (isSet(htmlAttributes["confirm"])) {
            myconfirmMessage = htmlAttributes["confirm"];
            htmlAttributes.remove("confirm");
        }
        if (myconfirmMessage) {
            myconfirm = _confirm("return true;", "return false;");
            htmlAttributes["data-confirm-message"] = myconfirmMessage;
            htmlAttributes["onclick"] = mytemplater.format("confirmJs", [
                "confirmMessage": htmlAttribEscape(myconfirmMessage),
                "confirm": myconfirm,
            ]);
        }
        return mytemplater.format("link", [
            "url": myurl,
            "attrs": mytemplater.formatAttributes(htmlAttributes),
            "content": mytitle,
        ]);
    }
    
    /**
     * Creates an HTML link from route path string.
     *
     * ### Options
     *
     * - `escape` Set to false to disable escaping of title and attributes.
     * - `escapeTitle` Set to false to disable escaping of title. Takes precedence
     *  over value of `escape`)
     * - `confirm` JavaScript confirmation message.
     * Params:
     * string mytitle The content to be wrapped by `<a>` tags.
     * @param string mypath uim-relative route path.
     * @param array myparams An array specifying any additional parameters.
     *  Can be also any special parameters supported by `Router.url()`.
     * @param Json[string] htmlAttributes Array of options and HTML attributes.
     * /
    string linkFromPath(string mytitle, string mypath, Json[string] myparams = [], Json[string] htmlAttributes = null) {
        return _link(mytitle, ["_path": mypath] + myparams, htmlAttributes);
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
     *  custom block name.
     * - `once` Whether the css file should be checked for uniqueness. If true css
     *  files  will only be included once, use false to allow the same
     *  css to be included more than once per request.
     * - `plugin` False value will prevent parsing path as a plugin
     * - `rel` Defaults to "stylesheet". If equal to "import" the stylesheet will be imported.
     * - `fullBase` If true the URL will get a full address for the css file.
     *
     * All other options will be treated as HTML attributes. If the request contains a
     * `cspStyleNonce` attribute, that value will be applied as the `nonce` attribute on the
     * generated HTML.
     * Params:
     * string[]|string mypath The name of a CSS style sheet or an array containing names of
     *  CSS stylesheets. If `mypath` is prefixed with "/", the path will be relative to the webroot
     *  of your application. Otherwise, the path will be relative to your CSS path, usually webroot/css.
     * @param Json[string] htmlAttributes Array of options and HTML arguments.
     * /
    string css(string[] mypath, Json[string] htmlAttributes = null) {
        htmlAttributes = htmlAttributes.update([
            "once": true.toJson,
            "block": null,
            "rel": Json("stylesheet"),
            "nonce": _View.getRequest().getAttribute("cspStyleNonce"),
        ]);

        if (mypath.isArray) {
            string result = "";
            foreach (mypath as myi) {
                result ~= "\n\t" ~ to!string(this.css(myi, htmlAttributes));
            }
            if (isEmpty(htmlAttributes["block"])) {
                return result ~ "\n";
            }
            return null;
        }
        myurl = this.Url.css(mypath, htmlAttributes);
        htmlAttributes = array_diff_key(htmlAttributes, ["fullBase": null, "pathPrefix": null]);

        if (htmlAttributes["once"] && isSet(_includedAssets[__METHOD__][mypath])) {
            return null;
        }
        htmlAttributes.remove("once");
       _includedAssets[__METHOD__][mypath] = true;

        mytemplater = this.templater();
        if (htmlAttributes["rel"] == "import") {
            result = mytemplater.format("style", [
                "attrs": mytemplater.formatAttributes(htmlAttributes, ["rel", "block"]),
                "content": "@import url(" ~ myurl ~ ");",
            ]);
        } else {
            result = mytemplater.format("css", [
                "rel": htmlAttributes["rel"],
                "url": myurl,
                "attrs": mytemplater.formatAttributes(htmlAttributes, ["rel", "block"]),
            ]);
        }
        if (htmlAttributes.isEmpty("block")) {
            return result;
        }
        if (htmlAttributes["block"] == true) {
            htmlAttributes["block"] = __FUNCTION__;
        }
       _View.append(htmlAttributes["block"], result);

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
     *  custom block name.
     * - `once` Whether the script should be checked for uniqueness. If true scripts will only be
     *  included once, use false to allow the same script to be included more than once per request.
     * - `plugin` False value will prevent parsing path as a plugin
     * - `fullBase` If true the url will get a full address for the script file.
     *
     * All other options will be added as attributes to the generated script tag.
     * If the current request has a `cspScriptNonce` attribute, that value will
     * be inserted as a `nonce` attribute on the script tag.
     * Params:
     * string[]|string myurl String or array of javascript files to include
     * @param Json[string] htmlAttributes Array of options, and html attributes see above.
     * /
    string script(string[] myurl, Json[string] htmlAttributes = null) {
        mydefaults = [
            "block": null,
            "once": true.toJson,
            "nonce": _View.getRequest().getAttribute("cspScriptNonce"),
        ];
        htmlAttributes += mydefaults;

        if (myurl.isArray) {
            string result = myurl.map!(i => "\n\t" ~ (string)this.script(myi, htmlAttributes)).join;
            if (htmlAttributes.isEmpty("block")) {
                return result ~ "\n";
            }
            return null;
        }
        myurl = this.Url.script(myurl, htmlAttributes);
        htmlAttributes = array_diff_key(htmlAttributes, ["fullBase": null, "pathPrefix": null]);

        if (htmlAttributes["once"] && isSet(_includedAssets[__METHOD__][myurl])) {
            return null;
        }
       _includedAssets[__METHOD__][myurl] = true;

        result = this.formatTemplate("javascriptlink", [
            "url": myurl,
            "attrs": this.templater().formatAttributes(htmlAttributes, ["block", "once"]),
        ]);

        if (htmlAttributes.isEmpty("block")) {
            return result;
        }

        if (htmlAttributes["block"] == true) {
            htmlAttributes["block"] = __FUNCTION__;
        }
       _View.append(htmlAttributes["block"], result);

        return null;
    }
    
    /**
     * Wrap myscript in a script tag.
     *
     * ### Options
     *
     * - `block` Set to true to append output to view block "script" or provide
     *  custom block name.
     * Params:
     * string myscript The script to wrap
     * @param Json[string] htmlAttributes The options to use. Options not listed above will be
     *   treated as HTML attributes.
     * /
    string scriptBlock(string myscript, Json[string] htmlAttributes = null) {
        htmlAttributes += ["block": null, "nonce": _View.getRequest().getAttribute("cspScriptNonce")];

        auto result = this.formatTemplate("javascriptblock", [
            "attrs": this.templater().formatAttributes(htmlAttributes, ["block"]),
            "content": myscript,
        ]);

        if (isEmpty(htmlAttributes["block"])) {
            return result;
        }
        if (htmlAttributes["block"] == true) {
            htmlAttributes["block"] = "script";
        }
       _View.append(htmlAttributes["block"], result);

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
     *  custom block name.
     * /
    void scriptStart(Json[string] optionsForCodeblock  = null) {
       _scriptBlockOptions = optionsForCodeblock;
        ob_start();
    }
    
    /**
     * End a Buffered section of JavaScript capturing.
     * Generates a script tag inline or appends to specified view block depending on
     * the settings used when the scriptBlock was started
     * /
    string scriptEnd() {
        mybuffer = (string)ob_get_clean();
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
     * // creates
     * "margin:10px;padding:10px;"
     * ```
     * Params:
     * STRINGAA mydata Style data array, keys will be used as property names, values as property values.
     * @param bool myoneLine Whether the style block should be displayed on one line.
     * /
    string style(Json[string] data, bool myoneLine = true) {
        string[] result;
        foreach (mydata as aKey: myvalue) {
            result ~= aKey ~ ":" ~ myvalue ~ ";";
        }
        if (myoneLine) {
            return result.join(" ");
        }
        return result.join("\n");
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
     *  `options["url"]`.
     * - `fullBase` If true the src attribute will get a full address for the image file.
     * - `plugin` False value will prevent parsing path as a plugin
     * Params:
     * string[] mypath Path to the image file, relative to the webroot/img/ directory.
     * @param Json[string] options Array of HTML attributes. See above for special options.
     * /
    string image(string[] mypath, Json[string] htmlAttributes = null) {
        if (isString(mypath)) {
            mypath = this.Url.image(mypath, htmlAttributes);
        } else {
            mypath = this.Url.build(mypath, htmlAttributes);
        }
        htmlAttributes = array_diff_key(htmlAttributes, ["fullBase": null, "pathPrefix": null]);

        if (!htmlAttributes.isSet("alt")) {
            htmlAttributes["alt"] = "";
        }
        myurl = false;
        if (!htmlAttributes.isEmpty("url"))) {
            myurl = htmlAttributes["url"];
            unset(htmlAttributes["url"]);
        }
        mytemplater = this.templater();
        myimage = mytemplater.format("image", [
            "url": mypath,
            "attrs": mytemplater.formatAttributes(htmlAttributes),
        ]);

        if (myurl) {
            return mytemplater.format("link", [
                "url": this.Url.build(myurl),
                "attrs": null,
                "content": myimage,
            ]);
        }
        return myimage;
    }
    
    /**
     * Returns a row of formatted and named TABLE headers.
     * Params:
     * array viewss Array of tablenames. Each tablename can be string, or array with name and an array with a set
     *    of attributes to its specific tag
     * @param Json[string]|null mytrOptions HTML options for TR elements.
     * @param Json[string]|null mythOptions HTML options for TH elements.
     * /
    string tableHeaders(Json[string] viewss, Json[string] mytrOptions = null, Json[string] mythOptions = null) {
        auto result = null;
        foreach (viewss as myarg) {
            if (!isArray(myarg)) {
                mycontent = myarg;
                myattrs = mythOptions;
            } elseif (isSet(myarg[0], myarg[1])) {
                mycontent = myarg[0];
                myattrs = myarg[1];
            } else {
                mycontent = key(myarg);
                myattrs = current(myarg);
            }
            result ~= this.formatTemplate("tableheader", [
                "attrs": this.templater().formatAttributes(myattrs),
                "content": mycontent,
            ]);
        }
        return _tableRow(join(" ", result), (array)mytrOptions);
    }
    
    /**
     * Returns a formatted string of table rows (TR"s with TD"s in them).
     * Params:
     * string[] mydata Array of table data
     * @param Json[string]|bool|null myoddTrOptions HTML options for odd TR elements if true useCount is used
     * @param Json[string]|bool|null myevenTrOptions HTML options for even TR elements
     * @param bool myuseCount adds class "column-myi"
     * @param bool mycontinueOddEven If false, will use a non-static mycount variable,
     * /
    string tableCells(
        string[] mydata,
        Json|null myoddTrOptions = null,
        Json|null myevenTrOptions = null,
        bool myuseCount = false,
        bool mycontinueOddEven = true
    ) {
        if (!isArray(mydata)) {
            mydata = [[mydata]];
        } elseif (isEmpty(mydata[0]) || !isArray(mydata[0])) {
            mydata = [mydata];
        }
        if (myoddTrOptions == true) {
            myuseCount = true;
            myoddTrOptions = null;
        }
        if (myevenTrOptions == false) {
            mycontinueOddEven = false;
            myevenTrOptions = null;
        }
        if (mycontinueOddEven) {
            static mycount = 0;
        } else {
            mycount = 0;
        }
        auto result = null;
        mydata.each!((line) {
            mycount++;
            mycellsOut = _renderCells(line, myuseCount);
            myopts = mycount % 2 ? myoddTrOptions : myevenTrOptions;

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
     * Params:
     * Json[string] myline Line data to render.
     * @param bool myuseCount Renders the count into the row. Default is false.
     * /
    protected string[] _renderCells(Json[string] myline, bool myuseCount = false) {
        myi = 0;
        mycellsOut = null;
        myline.each!((cell) {
            mycellOptions = null;

            if (isArray(cell)) {
                mycellOptions = cell[1];
                cell = cell[0];
            }
            if (myuseCount) {
                myi += 1;


                mycellOptions["class"] = isSet(mycellOptions["class"])
                    ? mycellOptions["class"] ~ " column-" ~ myi
                    : "column-" ~ myi;
            }
            mycellsOut ~= this.tableCell((string)cell, mycellOptions);
        });
        return mycellsOut;
    }
    
    /**
     * Renders a single table row (A TR with attributes).
     * Params:
     * string mycontent The content of the row.
     * @param Json[string] htmlAttributes HTML attributes.
     * /
    string tableRow(string mycontent, Json[string] htmlAttributes = null) {
        return _formatTemplate("tablerow", [
            "attrs": this.templater().formatAttributes(htmlAttributes),
            "content": mycontent,
        ]);
    }
    
    /**
     * Renders a single table cell (A TD with attributes).
     * Params:
     * string mycontent The content of the cell.
     * @param Json[string] htmlAttributes HTML attributes.
     * /
    string tableCell(string mycontent, Json[string] htmlAttributes = null) {
        return _formatTemplate("tablecell", [
            "attrs": this.templater().formatAttributes(htmlAttributes),
            "content": mycontent,
        ]);
    }
    
    /**
     * Returns a formatted block tag, i.e DIV, SPAN, P.
     *
     * ### Options
     *
     * - `escape` Whether the contents should be html_entity escaped.
     * Params:
     * string views Tag name.
     * @param string|null mytext String content that will appear inside the HTML element.
     *  If null, only a start tag will be printed
     * @param Json[string] htmlAttributes Additional HTML attributes of the HTML tag, see above.
     * /
    string tag(string views, string mytext = null, Json[string] htmlAttributes = null) {
        if (isSet(htmlAttributes["escape"]) && htmlAttributes["escape"]) {
            mytext = htmlAttribEscape(mytext);
            unset(htmlAttributes["escape"]);
        }

        auto tag = mytext.isNull ? "tagstart" : "tag";

        return _formatTemplate(mytag, [
            "attrs": this.templater().formatAttributes(htmlAttributes),
            "tag": views,
            "content": mytext,
        ]);
    }
    
    /**
     * Returns a formatted DIV tag for HTML FORMs.
     *
     * ### Options
     *
     * - `escape` Whether the contents should be html_entity escaped.
     * Params:
     * string|null myclass DCSS class name of the div element.
     * @param string|null mytext String content that will appear inside the div element.
     *  If null, only a start tag will be printed
     * @param Json[string] htmlAttributes Additional HTML attributes of the DIV tag
     * /
    string div(string myclass = null, string mytext = null, Json[string] htmlAttributes = null) {
        if (!myclass.isEmpty) {
            htmlAttributes["class"] = myclass;
        }
        return _tag("div", mytext, htmlAttributes);
    }
    
    /**
     * Returns a formatted P tag.
     *
     * ### Options
     *
     * - `escape` Whether the contents should be html_entity escaped.
     * Params:
     * string|null myclass DCSS class name of the p element.
     * @param string|null mytext String content that will appear inside the p element.
     * @param Json[string] htmlAttributes Additional HTML attributes of the P tag
     * /
    string para(string myclass, string mytext, Json[string] htmlAttributes = null) {
        if (!htmlAttributes.isEmpty("escape"))) {
            mytext = htmlAttribEscape(mytext);
        }
        if (myclass) {
            htmlAttributes["class"] = myclass;
        }
        mytag = "para";
        if (mytext.isNull) {
            mytag = "parastart";
        }
        return _formatTemplate(mytag, [
            "attrs": this.templater().formatAttributes(htmlAttributes),
            "content": mytext,
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
     *     ["video.mp4", ["src": "video.ogv", "type": "video/ogg; codecs="theora, vorbis""]],
     *     ["tag": "video", "autoplay"]
     * );
     * ```
     *
     * Outputs:
     *
     * ```
     * <video autoplay="autoplay">
     *     <source src="/files/video.mp4" type="video/mp4">
     *     <source src="/files/video.ogv" type="video/ogv; codecs="theora, vorbis"">
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
     * string[] mypath Path to the video file, relative to the webroot/{htmlAttributes["pathPrefix"]} directory.
     * Or an array where each item itself can be a path string or an associate array containing keys `src` and `type`
     * @param Json[string] htmlAttributes Array of HTML attributes, and special options above.
     * /
    string media(string[] mypath, Json[string] htmlAttributes = null) {
        htmlAttributes += [
            "tag": null,
            "pathPrefix": "files/",
            "text": "",
        ];

        auto mytag = !htmlAttributes.isEmpty("tag") 
            ? htmlAttributes["tag"]
            : null;

        if (mypath.isArray) {
            mysourceTags = "";
            foreach (mypath as &mysource) {
                if (isString(mysource)) {
                    mysource = [
                        "src": mysource,
                    ];
                }
                if (!mysource.isSet("type")) {
                    myext = pathinfo(mysource["src"], PATHINFO_EXTENSION);
                    mysource["type"] = _View.getResponse().getMimeType(myext);
                }
                mysource["src"] = this.Url.assetUrl(mysource["src"], htmlAttributes);
                mysourceTags ~= this.formatTemplate("tagselfclosing", [
                    "tag": "source",
                    "attrs": this.templater().formatAttributes(mysource),
                ]);
            }
            unset(mysource);
            htmlAttributes["text"] = mysourceTags ~ htmlAttributes["text"];
            unset(htmlAttributes["fullBase"]);
        } else {
            if (isEmpty(mypath) && !htmlAttributes.isEmpty("src"))) {
                mypath = htmlAttributes["src"];
            }
            /** @psalm-suppress PossiblyNullArgument * /
            htmlAttributes["src"] = this.Url.assetUrl(mypath, htmlAttributes);
        }
        if (mytag.isNull) {
            if (mypath.isArray) {
                mymimeType = mypath[0]["type"];
            } else {
                mymimeType = _View.getResponse().getMimeType(pathinfo(mypath, PATHINFO_EXTENSION));
                assert(isString(mymimeType));
            }
            if (mymimeType.startsWith("video/")) {
                mytag = "video";
            } else {
                mytag = "audio";
            }
        }
        if (isSet(htmlAttributes["poster"])) {
            htmlAttributes["poster"] = this.Url.assetUrl(
                htmlAttributes["poster"],
                ["pathPrefix": Configuration.read("App.imageBaseUrl")] + htmlAttributes
            );
        }
        mytext = htmlAttributes["text"];

        htmlAttributes = array_diff_key(htmlAttributes, [
            "tag": null,
            "fullBase": null,
            "pathPrefix": null,
            "text": null,
        ]);

        return _tag(mytag, mytext, htmlAttributes);
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
     * @param Json[string] htmlAttributes Options and additional HTML attributes of the list (ol/ul) tag.
     * @param Json[string] myitemOptions Options and additional HTML attributes of the list item (LI) tag.
     * /
    string|int|false nestedList(Json[string] mylist, Json[string] htmlAttributes = null, Json[string] myitemOptions = []) {
        htmlAttributes += ["tag": "ul"];
        myitems = _nestedListItem(mylist, htmlAttributes, myitemOptions);

        return _formatTemplate(htmlAttributes["tag"], [
            "attrs": this.templater().formatAttributes(htmlAttributes, ["tag"]),
            "content": myitems,
        ]);
    }
    
    /**
     * Internal auto to build a nested list (UL/OL) out of an associative array.
     * Params:
     * array myitems Set of elements to list.
     * @param Json[string] htmlAttributes Additional HTML attributes of the list (ol/ul) tag.
     * @param Json[string] myitemOptions Options and additional HTML attributes of the list item (LI) tag.
     * /
    protected string _nestedListItem(Json[string] myitems, Json[string] htmlAttributes, Json[string] myitemOptions) {
        string result = "";

        auto myindex = 1;
        foreach (aKey: myitem; myitems) {
            if (isArray(myitem)) {
                myitem = aKey ~ this.nestedList(myitem, htmlAttributes, myitemOptions);
            }
            if (isSet(myitemOptions["even"]) && myindex % 2 == 0) {
                myitemOptions["class"] = myitemOptions["even"];
            } elseif (isSet(myitemOptions["odd"]) && myindex % 2 != 0) {
                myitemOptions["class"] = myitemOptions["odd"];
            }
            result ~= this.formatTemplate("li", [
                "attrs": this.templater().formatAttributes(myitemOptions, ["even", "odd"]),
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
