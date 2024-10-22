/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.helpers.html;

import uim.views;

@safe:
unittest {
  writeln("-----  ", __MODULE__, "\t  -----");
}

/**
 * Html Helper class for easy use of HTML widgets.
 * HtmlHelper encloses all methods needed while working with HTML pages.
 */
class DHtmlHelper : DHelper {
  mixin(HelperThis!("Html"));
  mixin TStringContents;

  // List of helpers used by this helper
  protected string[] _helpers = ["Url"];

  protected Json[string] _templates;

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    writeln("initialize in DHtmlHelper");
    if (!super.initialize(initData)) {
      return false;
    }

    _templates
      .set("meta", "<meta{{attrs}}>")
      .set("metalink", "<link href=\"{{url}}\"{{attrs}}>")
      .set("link", "<a href=\"{{url}}\"{{attrs}}>{{content}}</a>")
      .set("mailto", "<a href=\"mailto:{{url}}\"{{attrs}}>{{content}}</a>")
      .set("image", "<img src=\"{{url}}\"{{attrs}}>")
      .set("tableheader", "<th{{attrs}}>{{content}}</th>")
      .set("tableheaderrow", "<tr{{attrs}}>{{content}}</tr>")
      .set("tablecell", "<td{{attrs}}>{{content}}</td>")
      .set("tablerow", "<tr{{attrs}}>{{content}}</tr>")
      .set("block", "<div{{attrs}}>{{content}}</div>")
      .set("blockstart", "<div{{attrs}}>")
      .set("blockend", "</div>")
      .set("tag", "<{{tag}}{{attrs}}>{{content}}</{{tag}}>")
      .set("tagstart", "<{{tag}}{{attrs}}>")
      .set("tagend", "</{{tag}}>")
      .set("tagselfclosing", "<{{tag}}{{attrs}}/>")
      .set("para", "<p{{attrs}}>{{content}}</p>")
      .set("parastart", "<p{{attrs}}>")
      .set("css", "<link rel=\"{{rel}}\" href=\"{{url}}\"{{attrs}}>")
      .set("style", "<style{{attrs}}>{{content}}</style>")
      .set("charset", "<meta charset=\"{{charset}}\">")
      .set("ul", "<ul{{attrs}}>{{content}}</ul>")
      .set("ol", "<ol{{attrs}}>{{content}}</ol>")
      .set("li", "<li{{attrs}}>{{content}}</li>")
      .set("javascriptblock", "<script{{attrs}}>{{content}}</script>")
      .set("javascriptstart", "<script>")
      .set("javascriptlink", "<script src=\"{{url}}\"{{attrs}}></script>")
      .set("javascriptend", "</script>")
      .set("confirmJs", "{{confirm}}");

    writeln(_templates);
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
     * this.Html.meta("description", "A great page", ["block": true]);
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
     */
  string meta(string type, string content = null, Json[string] htmlAttributes = null) {
    Json[string] types;
    if (type == "icon" && content.isNull) {
      types.set("icon.link", "favicon.ico");
    } else {
      types
        .set("rss", createMap!(string, Json)
            .set("type", "application/rss+xml")
            .set("rel", "alternate")
            .set("title", type)
            .set("link", content))
        .set("atom", createMap!(string, Json)
            .set("type", "application/atom+xml")
            .set("title", type)
            .set("link", content))
        .set("icon", createMap!(string, Json)
            .set("type", "image/x-icon")
            .set("rel", "icon")
            .set("link", content))
        .set("keywords", createMap!(string, Json)
            .set("name", "keywords")
            .set("content", content))
        .set("description", createMap!(string, Json)
            .set("name", "description")
            .set("content", content))
        .set("robots", createMap!(string, Json)
            .set("name", "robots")
            .set("content", content))
        .set("viewport", createMap!(string, Json)
            .set("name", "viewport")
            .set("content", content))
        .set("canonical", createMap!(string, Json)
            .set("rel", "canonical")
            .set("link", content))
        .set("next", createMap!(string, Json)
            .set("rel", "next")
            .set("link", content))
        .set("prev", createMap!(string, Json)
            .set("rel", "prev")
            .set("link", content))
        .set("first", createMap!(string, Json)
            .set("rel", "first")
            .set("link", content))
        .set("last", createMap!(string, Json)
            .set("rel", "last")
            .set("link", content));

      Json foundType = Json(null);
      if (types.hasKey(type)) {
        foundType = types[type];
      } else if (!htmlAttributes.hasKey("type") && content !is null) {
        /* type = content.isArray && content.hasKey("_ext")
                    ? types[content.getString("_ext")] : [
                        "name": type,
                        "content": content
                    ];
 */
      } else if (types.hasKey(htmlAttributes.getString("type"))) {
        foundType = types[htmlAttributes.getString("type")];
        htmlAttributes.removeKey("type");
      } else {
        foundType = Json(null);
      }
    }
    return null; // TODO
  }

  string meta(string[] type, string[] content = null, Json[string] htmlAttributes = null) {
    // htmlAttributes += type ~ ["block": Json(null)];
    string result = "";

    if (htmlAttributes.hasKey("link")) {
      /* htmlAttributes.set("link", htmlAttributes.isArray("link")
                    ? _url.build(htmlAttributes.get("link")) : _url.assetUrl(
                        htmlAttributes.get("link"))); */

      if (htmlAttributes.getString("rel") == "icon") {
        result = _templates.getString("metalink").doubleMustache(
          createMap!(string, Json)
            .set("url", htmlAttributes.getString("link")) /* .set("attrs", templater()
                            .formatAttributes(htmlAttributes, [
                                "block", "link"
                            ])) */
            
        );
        htmlAttributes.set("rel", "shortcut icon");
      }
      result ~= _templates.getString("metalink").doubleMustache(createMap!(string, Json)
          .set("url", htmlAttributes.getString("link") /*                 "attrs": templater().formatAttributes(htmlAttributes, [
                        "block", "link"
                    ]), */

          

      ));
    } else {
      /* result = _templates.getString("meta").doubleMustache([
                "attrs": templater().formatAttributes(htmlAttributes, [
                        "block", "type"
                    ])
            ]); */
    }

    if (htmlAttributes.isEmpty("block")) {
      return result;
    }

    if (htmlAttributes.hasKey("block")) {
      htmlAttributes.set("block", __FUNCTION__);
    }
    //  _view.append(htmlAttributes.get("block"), result);
    return null;
  }

  // Returns a charset META-tag.
  string charset(string value = null) {
    string result;
    if (value.isEmpty) {
      result = configuration.getString("App.encoding").lower;
    }
    return _templates.getString("charset")
      .doubleMustache([
          "charset": result.isEmpty ? "utf-8": result,
        ]);
  }

  unittest {
    auto helper = new DHtmlHelper;
    writeln("charset => ", helper.charset);
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
    /* auto myescapeTitle = true;
        if (!url.isNull) {
            url = _url.build(url, htmlAttributes);
            htmlAttributes.removeKey("fullBase");
        } else {
            url = _url.build(title);
            title = htmlspecialchars_decode(url, ENT_QUOTES);
            title = htmlAttributeEscape(urldecode(title));
            myescapeTitle = false;
        }
        if (htmlAttributes.hasKey("escapeTitle")) {
            myescapeTitle = htmlAttributes["escapeTitle"];
            htmlAttributes.removeKey("escapeTitle");
        } else if (htmlAttributes.hasKey("escape")) {
            myescapeTitle = htmlAttributes["escape"];
        }
        if (myescapeTitle == true) {
            title = htmlAttributeEscape(title);
        } else if (isString(myescapeTitle)) {
            /** @psalm-suppress PossiblyInvalidArgument * /
            title = htmlentities(title, ENT_QUOTES, myescapeTitle);
        }
        mytemplater = templater();
        myconfirmMessage = null;
        if (htmlAttributes.hasKey("confirm")) {
            myconfirmMessage = htmlAttributes.shift("confirm");
        }
        if (myconfirmMessage) {
            myconfirm = _confirm("return true;", "return false;");
            htmlAttributes
                .set("data-confirm-message", myconfirmMessage);
                .set("onclick", _templates["confirmJs"].doubleMoustache([
                        "confirmMessage": htmlAttributeEscape(myconfirmMessage),
                        "confirm": myconfirm,
                    ]));
        }
        return _templates["link"].doubleMoustache(createMap!(string, Json)
                .set("url": url)
                .set("attrs": mytemplater.formatAttributes(htmlAttributes),
                .set("content": title)
            ]); */
    return null;
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
  string linkFromPath(string title, string routePath, Json[string] params = null, Json[string] htmlAttributes = null) {
    // return _link(title, ["_path": routePath] + params, htmlAttributes);
    return null;
  }

  string css(string[] mypath, Json[string] htmlAttributes = null) {
    htmlAttributes
      .merge("once", true)
      .merge("block", Json(null))
      .merge("rel", "stylesheet");
    // .merge("nonce", _view.getRequest().getAttribute("cspStyleNonce"));

    /*         auto url = _url.css(mypath, htmlAttributes);
        auto htmlAttributes = array_diffinternalKey(htmlAttributes, createMap!(string, Json)
                .set(["fullBase", "pathPrefix"], Json(null)));

        if (htmlAttributes["once"] && _includedAssets.hasKey([
                __METHOD__, mypath
            ])) {
            return null;
        }
        htmlAttributes.removeKey("once");
        _includedAssets[__METHOD__][mypath] = true;

        auto mytemplater = templater();
        if (htmlAttributes.getString("rel") == "import") {
            result = _templates["style", [
                    "attrs": mytemplater.formatAttributes(htmlAttributes, [
                            "rel", "block"
                        ]),
                    "content": "@import url(" ~ url ~ ");",
                ]);
        } else {
            result = _templates["css", [
                    "rel": htmlAttributes["rel"],
                    "url": url,
                    "attrs": mytemplater.formatAttributes(htmlAttributes, [
                            "rel", "block"
                        ]),
                ]);
        } */
    /* if (htmlAttributes.isEmpty("block")) {
            return result;
        } */
    if (htmlAttributes.hasKey("block")) {
      htmlAttributes.set("block", __FUNCTION__);
    }
    /*
        _view.append(htmlAttributes.get("block"), result);
 */
    return null;
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
     * this.Html.css("styles.css", ["block": true]);
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
  /*     string css(string[] mypath, Json[string] htmlAttributes = null) {
        string result = mypath.map!(path => "\n\t" ~ css(index, htmlAttributes)).join;
        return htmlAttributes.isEmpty("block")
            ? result ~ "\n" : null;
    } */

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
    htmlAttributes
      .merge("block", Json(null))
      .merge("once", true);
    // .merge("nonce", _view.getRequest().getAttribute("cspScriptNonce"));

    /* if (url.isArray) {
            string result = url.map!(i => "\n\t" ~  /* (string) * / this.script(index, htmlAttributes))
                .join;
            if (htmlAttributes.isEmpty("block")) {
                return result ~ "\n";
            }
            return null;
        } */
    /* url = _url.script(url, htmlAttributes);
        htmlAttributes = array_diffinternalKey(htmlAttributes, [
                "fullBase": Json(null),
                "pathPrefix": Json(null)
            ]);

        if (htmlAttributes["once"] && _includedAssets.hasKey([__METHOD__, url])) {
            return null;
        }
        _includedAssets[__METHOD__][url] = true;

        result = _templates["javascriptlink", [
                "url": url,
                "attrs": templater().formatAttributes(htmlAttributes, [
                        "block", "once"
                    ]),
            ]);

        if (htmlAttributes.isEmpty("block")) {
            return result;
        }

        if (htmlAttributes["block"] == true) {
            htmlAttributes.set("block", __FUNCTION__);
        }
        _view.append(htmlAttributes["block"], result);
 */
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
    htmlAttributes
      .merge("block", Json(null));
    // .merge("nonce", _view.getRequest().getAttribute("cspScriptNonce"));

    /*         auto result = _templates["javascriptblock", [
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
 */
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
  void scriptStart(Json[string] optionsForCodeblock = null) {
    /*         _scriptBlockOptions = optionsForCodeblock;
        ob_start();
 */
  }

  /**
     * End a Buffered section of JavaScript capturing.
     * Generates a script tag inline or appends to specified view block depending on
     * the settings used when the scriptBlock was started
     */
  string scriptEnd() {
    /* mybuffer =  /* (string) * / ob_get_clean();
        options = _scriptBlockOptions;
        _scriptBlockOptions = null;

        return _scriptBlock(mybuffer, options); */
    return null;
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
    /*         string[] result = data.byKeyValue.map!(kv => kv.key ~ ": " ~ kv.value ~ ";").array;
        return shouldOneLine
            ? result.join(" ") : result.join("\n"); */
    return null;
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
    /* pathToImageFile = pathToImageFile.isString
            ? _url.image(pathToImageFile, htmlAttributes) : _url.build(pathToImageFile, htmlAttributes);

        htmlAttributes = array_diffinternalKey(htmlAttributes, [
                "fullBase": Json(null),
                "pathPrefix": Json(null)
            ]);

        if (!htmlAttributes.hasKey("alt")) {
            htmlAttributes.set("alt", "");
        }

        auto url = false;
        if (htmlAttributes.gasKey("url")) {
            url = htmlAttributes.shift("url");
        }

        auto mytemplater = templater();
        auto myimage = _templates["image", createMap!(string, Json)
                .set("url", pathToImageFile)
                .set("attrs", mytemplater.formatAttributes(htmlAttributes)));

        if (url) {
            return _templates["link", [
                    "url": _url.build(url),
                    "attrs": Json(null),
                    "content": myimage,
                ]);
        }
        return myimage; */
    return null;
  }

  // Returns a row of formatted and named TABLE headers.
  string tableHeaders(Json[string] tableNames, Json[string] trOptions = null, Json[string] thOptions = null) {
    /* string attributes = null;
        string result = null;
        foreach (tableName; tableNames) {
            string content;
            if (!tableName.isArray) {
                content = tableName;
                attributes = thOptions;
            } else if (tableName.has(0) && tableName.has(1)) {
                content = tableName[0];
                attributes = tableName[1];
            } else {
                content = key(vitableNameew);
                attributes = currentValue(tableName);
            }
            result ~= _templates["tableheader", [
                    "attrs": templater().formatAttributes(attributes),
                    "content": content,
                ]);
        }
        return _tableRow(result.join(" "), trOptions); */
    return null;
  }

  // Returns a formatted string of table rows (TR"s with TD"s in them).
  string tableCells(
    string[] tableData,
    Json oddTrOptions = null,
    Json evenTrOptions = null,
    bool useCount = false,
    bool continueOddEven = true
  ) {
    /*        if (!tableData.isArray) {
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

            Json[string] htmlAttributes =  /*  (array) * / myopts;
            result ~= this.tableRow(mycellsOut.join(" "), htmlAttributes);
        });

        return result.join("\n"); */
    return null;
  }

  /**
     * Renders cells for a row of a table.
     *
     * This is a helper method for tableCells(). Overload this method as you
     * need to change the behavior of the cell rendering.
     */
  protected string[] _renderCells(Json[string] linesToRender, bool shouldUseCount = false) {
    /* auto index = 0;
        auto mycellsOut = null;
        linesToRender.each!((cell) {
            auto cellOptions = null;

            if (cell.isArray) {
                cellOptions = cell[1];
                cell = cell[0];
            }
            if (shouldUseCount) {
                index += 1;

                cellOptions.set("class", cellOptions.hasKey("class")
                    ? cellOptions.getString("class") ~ " column-" ~ index : "column-" ~ index
                );
            }
            mycellsOut ~= tableCell( /* (string)  * / cell, cellOptions);
        });
        return mycellsOut; */
    return null;

  }

  // Renders a single table row (A TR with attributes).
  string tableRow(string content, Json[string] htmlAttributes = null) {
    /* return _templates["tablerow"].doubleMustache([
                "attrs": templater().formatAttributes(htmlAttributes),
                "content": content,
            ]); */
    return null;
  }

  // Renders a single table cell (A TD with attributes).
  string tableCell(string content, Json[string] htmlAttributes = null) {
    /*         return _templates["tablecell"].doubleMustache([
                "attrs": templater().formatAttributes(htmlAttributes),
                "content": content,
            ]); */
    return null;
  }

  /**
     * Returns a formatted block tag, i.e DIV, SPAN, P.
     *
     * ### Options
     * - `escape` Whether the contents should be html_entity escaped.
     */
  string tag(string tagName, string content = null, Json[string] htmlAttributes = null) {
    if (htmlAttributes.getBoolean("escape")) {
      content = htmlAttributeEscape(content);
      htmlAttributes.removeKey("escape");
    }

    string tag = content.isNull ? "tagstart" : "tag";
    return _templates.getString(tag).doubleMustache([
      "tag": tagName,
      // "attrs": templater().formatAttributes(htmlAttributes),
      "content": content
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
    return htmlDoubleTag("div", htmlAttributes, content);
  }

  /**
     * Returns a formatted P tag.
     *
     * ### Options
     *
     * - `escape` Whether the contents should be html_entity escaped.
     */
  string para(string cssClass, string content, Json[string] htmlAttributes = null) {
    if (htmlAttributes.getBoolean("escape")) {
      content = htmlAttributeEscape(content);
    }
    if (cssClass) {
      htmlAttributes.set("class", cssClass);
    }

    string tag = content.isEmpty
      ? "parastart" : "para";

    return _templates.getString(tag).doubleMustache(createMap!(string, Json) // .set("attrs", templater().formatAttributes(htmlAttributes))
      .set("content", content));
  }

  /**
     * Returns an audio/video element
     *
     * ### Usage
     *
     * Using an audio file:
     *
     * ```
     * writeln(this.Html.media("audio.mp3", ["fullBase": true]);
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
    htmlAttributes
      .merge("tag", Json(null))
      .merge("pathPrefix", "files/")
      .merge("text", "");

    string tag = htmlAttributes.getString("tag");
    if (pathToImageFile /* .isArray */ ) {
      auto sourceTags = "";
      /*             
        foreach (mysource; pathToImageFile) {
                if (isString(mysource)) {
                    mysource = [
                        "src": mysource,
                    ];
                }
                if (!mysource.hasKey("type")) {
                    myext = pathinfo(mysource["src"], PATHINFO_EXTENSION);
                    mysource["type"] = _view.getResponse().getMimeType(myext);
                }
                mysource.set("src", _url.assetUrl(mysource["src"], htmlAttributes));
                sourceTags ~= _templates["tagselfclosing"].doubleMoustache([
                        "tag": "source",
                        "attrs": templater().formatAttributes(mysource),
                    ]);
            }
            removeKey(mysource);
            htmlAttributes.set("text", sourceTags ~ htmlAttributes.getString("text"));
            removeKey(htmlAttributes["fullBase"]);
 */
    } else {
      /*             if (isEmpty(pathToImageFile) && htmlAttributes.getBoolean("src")) {
                pathToImageFile = htmlAttributes["src"];
            }
 */ /** @psalm-suppress PossiblyNullArgument */
      //            htmlAttributes.set("src", _url.assetUrl(pathToImageFile, htmlAttributes));
    }
    if (tag.isNull) {
      /*             if (pathToImageFile.isArray) {
                mymimeType = pathToImageFile[0]["type"];
            } else {
                mymimeType = _view.getResponse()
                    .getMimeType(pathinfo(pathToImageFile, PATHINFO_EXTENSION));
                assert(isString(mymimeType));
            }

            tag = mymimeType.startsWith("video/")
                ? "video" : "audio";
 */
    }

    /* if (htmlAttributes.hasKey("poster")) {
        htmlAttributes["poster"] = _url.assetUrl(
            htmlAttributes["poster"],
            ["pathPrefix": configuration.get("App.imageBaseUrl")] + htmlAttributes
        );
    } */

    /* auto content = htmlAttributes["text"];
    auto htmlAttributes = array_diffinternalKey(htmlAttributes, [
            "tag": Json(null),
            "fullBase": Json(null),
            "pathPrefix": Json(null),
            "text": Json(null),
        ]);

        return htmlDoubleTag(tag, htmlAttributes, content);m*/

    return null;

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
  string nestedList(Json[string] mylist, Json[string] listAttributes = null, Json[string] liAttributes = null) {
    /* listAttributes += ["tag": "ul"];
    myitems = _nestedListItem(mylist, listAttributes, liAttributes);

    return _templates[listAttributes["tag"], [
            "attrs": templater()
            .formatAttributes(listAttributes, ["tag"]),
            "content": myitems,
        ]); */
    return null;
  }

  /**
     * Internal auto to build a nested list (UL/OL) out of an associative array.
     * Params:
     * array myitems Set of elements to list.
     */
  protected string _nestedListItem(Json[string] myitems, Json[string] listAttributes, Json[string] liAttributes) {
    string result = "";

    auto myindex = 1;
    foreach (aKey, myitem; myitems) {
      if (myitem.isArray) {
        // myitem = aKey ~ this.nestedList(myitem, listAttributes, liAttributes);
      }
      if (liAttributes.hasKey("even") && myindex % 2 == 0) {
        liAttributes.set("class", liAttributes["even"]);
      } else if (liAttributes.hasKey("odd") && myindex % 2 != 0) {
        liAttributes.set("class", liAttributes["odd"]);
      }
      /*             result ~= _templates["li", [
                    "attrs": templater().formatAttributes(liAttributes, [
                            "even", "odd"
                        ]),
                    "content": myitem,
                ]);
            myindex++;
 */
    }
    return result;
  }

  // Event listeners.
  override IEvent[] implementedEvents() {
    return null;
  }
}
