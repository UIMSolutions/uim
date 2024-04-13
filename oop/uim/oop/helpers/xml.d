module uim.oop.helpers.xml;

import uim.oop;

@safe:

/**
 * XML handling for UIM.
 * The methods in these classes enable the datasources that use XML to work.
 */
class Xml {
    /**
     * Initialize SimpleXMLElement or DOMDocument from a given XML string, file path, URL or array.
     *
     * ### Usage:
     *
     * Building XML from a string:
     *
     * ```
     * myxml = Xml.build("<example>text</example>");
     * ```
     *
     * Building XML from string (output DOMDocument):
     *
     * ```
     * myxml = Xml.build("<example>text</example>", ["return": "domdocument"]);
     * ```
     *
     * Building XML from a file path:
     *
     * ```
     * myxml = Xml.build("/path/to/an/xml/file.xml", ["readFile": BooleanData(true)]);
     * ```
     *
     * Building XML from a remote URL:
     *
     * ```
     * use UIM\Http\Client;
     *
     * myhttp = new DClient();
     * myresponse = myhttp.get("http://example.com/example.xml");
     * myxml = Xml.build(myresponse.body());
     * ```
     *
     * Building from an array:
     *
     * ```
     * myValue = [
     *     "tags": [
     *         "tag": [
     *             [
     *                 "id": "1",
     *                 "name": "defect"
     *             ],
     *             [
     *                 "id": "2",
     *                 "name": "enhancement"
     *             ]
     *         ]
     *     ]
     * ];
     * myxml = Xml.build(myValue);
     * ```
     *
     * When building XML from an array ensure that there is only one top level element.
     *
     * ### Options
     *
     * - `return` Can be "simplexml" to return object of SimpleXMLElement or "domdocument" to return DOMDocument.
     * - `loadEntities` Defaults to false. Set to true to enable loading of `<!ENTITY` definitions. This
     *  is disabled by default for security reasons.
     * - `readFile` Set to true to enable file reading. This is disabled by default to prevent
     *  local filesystem access. Only enable this setting when the input is safe.
     * - `parseHuge` Enable the `LIBXML_PARSEHUGE` flag.
     *
     * If using array as input, you can pass `options` from Xml.fromArray.
     * Params:
     * object|string[] myinput XML string, a path to a file, a URL or an array
     * @param IData[string] options The options to use
     * /
    static SimpleXMLElement | DOMDocument build(object | string[] myinput, IData[string] optionData = null) {
        IData[string] defaultOptions = [
            "return": StringData("simplexml"),
            "loadEntities": BoolData(false),
            "readFile": BoolData(false),
            "parseHuge": BoolData(false)
        ];                
        auto optionData = optionData.update(defaultOptions);

        if (isArray(myinput) || isObject(myinput)) {
            return fromArray(myinput, options);
        }

        if (options["readFile"] && file_exists(myinput)) {
            mycontent = file_get_contents(myinput);
            if (mycontent == false) {
                throw new UimException(
                    "Cannot read file content of `%s`".format(myinput));
            }
            return _loadXml(mycontent, options);
        }
        if (myinput.has("<")) {
            return _loadXml(myinput, options);
        }
        throw new XmlException("XML cannot be read.");
    }

    /**
     * Parse the input data and create either a SimpleXmlElement object or a DOMDocument.
     * Params:
     * string myinput The input to load.
     * @param IData[string] options The options to use. See Xml.build()
     * /
    protected static SimpleXMLElement | DOMDocument _loadXml(string myinput, IData[string] options) {
        return load(
            myinput,
            options,
            auto(myinput, options, myflags) {
            if (options["return"] == "simplexml" || options["return"] == "simplexmlelement") {
                myflags |= LIBXML_NOCDATA; myxml = new DSimpleXMLElement(myinput, myflags);
            } else {
                myxml = new DOMDocument(); myxml.loadXML(myinput, myflags);}
                return myxml;}
                );
            }

            /**
     * Parse the input html string and create either a SimpleXmlElement object or a DOMDocument.
     * Params:
     * string myinput The input html string to load.
     * @param IData[string] options The options to use. See Xml.build()
     * /
            static SimpleXMLElement | DOMDocument loadHtml(string myinput, IData[string] optionData = null) {
                IData[string] defaultData = [
                    "return": "simplexml",
                    "loadEntities": BooleanData(false),
                ];
                optionData = optionData.add(defaultData);

                return load(
                    myinput,
                    options,
                    auto(myinput, options, myflags) {
                    myxml = new DOMDocument(); myxml.loadHTML(myinput, myflags); if (
                        options["return"] == "simplexml" || options["return"] == "simplexmlelement") {
                        myxml = simplexml_import_dom(myxml);}
                        return myxml;}
                        );
                    }

                    /**
     * Parse the input data and create either a SimpleXmlElement object or a DOMDocument.
     * Params:
     * string myinput The input to load.
     * @param IData[string] options The options to use. See Xml.build()
     * @param \Closure mycallable Closure that should return SimpleXMLElement or DOMDocument instance.
     * /
                    protected static SimpleXMLElement | DOMDocument load(string myinput, IData[string] options, Closure mycallable) {
                        myflags = 0;
                        if (!empty(options["parseHuge"])) {
                            myflags |= LIBXML_PARSEHUGE;
                        }
                        myinternalErrors = libxml_use_internal_errors(true);
                        if (options["loadEntities"]) {
                            myflags |= LIBXML_NOENT;
                        }
                        try {
                            return mycallable(myinput, options, myflags);
                        } catch (Exception mye) {
                            throw new XmlException("Xml cannot be read. " ~ mye.getMessage(), null, mye);
                        } finally {
                            libxml_use_internal_errors(myinternalErrors);
                        }
                    }

                    /**
     * Transform an array into a SimpleXMLElement
     *
     * ### Options
     *
     * - `format` If create children ("tags") or attributes ("attributes").
     * - `pretty` Returns formatted Xml when set to `true`. Defaults to `false`
     * - `version` Version of XML document. Default is 1.0.
     * - `encoding` Encoding of XML document. If null remove from XML header.
     *   Defaults to the application"s encoding
     * - `return` If return object of SimpleXMLElement ("simplexml")
     *  or DOMDocument ("domdocument"). Default is SimpleXMLElement.
     *
     * Using the following data:
     *
     * ```
     * myValue = [
     *   "root": [
     *       "tag": [
     *           "id": 1,
     *           "value": "defect",
     *           "@": "description"
     *        ]
     *    ]
     * ];
     * ```
     *
     * Calling `Xml.fromArray(myValue, "tags");` Will generate:
     *
     * `<root><tag><id>1</id><value>defect</value>description</tag></root>`
     *
     * And calling `Xml.fromArray(myValue, "attributes");` Will generate:
     *
     * `<root><tag id="1" value="defect">description</tag></root>`
     * Params:
     * object|array myinput Array with data or a collection instance.
     * @param IData[string] options The options to use.
     * /
                    static SimpleXMLElement | DOMDocument fromArray(object | array myinput, IData[string] optionData = null) {
                        if (isObject(myinput) && method_exists(myinput, "toArray") && isCallable([myinput, "toArray"])) {
                            myinput = myinput.toArray();
                        }
                        if (!isArray(myinput) || count(myinput) != 1) {
                            throw new XmlException("Invalid input.");
                        }
                        aKey = key(myinput);
                        if (isInt(aKey)) {
                            throw new XmlException("The key of input must be alphanumeric");
                        }
                        IData[string] defaultData = [
                            "format": StringData("tags"),
                            "version": StringData("1.0"),
                            "encoding": mb_internal_encoding(),
                            "return": StringData("simplexml"),
                            "pretty": BoolData(false)
                        ];
                        optionData = optionData.add(defaultData);

                        auto domDocument = new DOMDocument(options["version"], options["encoding"]);
                        if (options["pretty"]) {
                            domDocument.formatOutput = true;
                        }
                        self._fromArray(domDocument, domDocument, myinput, options["format"]);

                        options["return"] = options["return"].toLower;
                        if (optionData["return"] == "simplexml" || optionData["return"] == "simplexmlelement") {
                            return new DSimpleXMLElement(to!string(domDocument.saveXML()));
                        }
                        return domDocument;
                    }

                    /**
     * Recursive method to create children from array
     * Params:
     * \DOMDocument domDocument Handler to DOMDocument
     * @param \DOMDocument|\DOMElement mynode Handler to DOMElement (child)
     * @param IData mydata Array of data to append to the mynode.
     * @param string myformat Either "attributes" or "tags". This determines where nested keys go.
     * /
                    protected static void _fromArray(
                    DOMDocument domDocument,
                    DOMDocument | DOMElement mynode,
                    IData mydata,
                    string myformat
                    ) {
                        if (mydata.isEmpty || !isArray(mydata)) {
                            return;
                        }
                        foreach (aKey : myValue; mydata) {
                            string myValue;
                            if (isString(aKey)) {
                                if (isObject(myValue) && method_exists(myValue, "toArray") && isCallable([myValue, "toArray"])) {
                                    myValue = myValue.toArray();
                                }
                                if (!isArray(myValue)) {
                                    if (isBool(myValue)) {
                                        myValue = to!int(myValue);
                                    }
                                    else if(myValue is null) {
                                        myValue = "";
                                    }
                                    if (aKey.has("xmlns:")) {
                                        assert(cast(DOMElement) mynode);
                                        mynode.setAttributeNS("http://www.w3.org/2000/xmlns/", aKey, (
                                        string) myValue);
                                        continue;
                                    }
                                    if (aKey[0] != "@" && myformat == "tags") {
                                        if (!isNumeric(myValue)) {
                                            // Escape special characters
                                            // https://www.w3.org/TR/REC-xml/#syntax
                                            // https://bugs.d.net/bug.d?id=36795
                                            mychild = domDocument.createElement(aKey, "");
                                            mychild.appendChild(new DOMText(to!string( myValue)));
                                        } else {
                                            mychild = domDocument.createElement(aKey, (string) myValue);
                                        }
                                        mynode.appendChild(mychild);
                                    } else {
                                        if (aKey[0] == "@") {
                                            aKey = substr(aKey, 1);
                                        }
                                        myattribute = domDocument.createAttribute(aKey);
                                        myattribute.appendChild(
                                        domDocument.createTextNode(to!string( myValue)));
                                        mynode.appendChild(myattribute);
                                    }
                                } else {
                                    if (aKey[0] == "@") {
                                        throw new XmlException("Invalid array");
                                    }
                                    if (isNumeric(myValue.keys.join(""))) {
                                        // List
                                        myValue.each!((item) {
                                            auto itemData = compact("dom", "node", "key", "format");
                                            itemData["value"] = item; _createChild(itemData);
                                        });
                                    } else {
                                        // Struct
                                        _createChild(compact("dom", "node", "key", "value", "format"));
                                    }
                                }
                            } else {
                                throw new XmlException("Invalid array");
                            }
                        }
                    }

                    /**
     * Helper to _fromArray(). It will create children of arrays
     * Params:
     * IData[string] mydata Array with information to create children
     * @psalm-param {dom: \DOMDocument, node: \DOMDocument|\DOMElement, key: string, format: string, ?value: IData } mydata
     * /
                    protected static void _createChild(array data) {
                        mydata += [
                            "value": null,
                        ];

                        auto dataKey = mydata.get("key", null);
                        if (dataKey is null) {
                            return;
                        }

                        auto dataFormat = mydata.get("format", null);
                        auto dataValue = mydata.get("value", null);
                        auto dataDom = mydata.get("dom", null);
                        auto dataNode = mydata.get("node");

                        auto mychildNS = null;
                        auto mychildValue = null;
                        if (isObject(dataValue) && method_exists(dataValue, "toArray") && isCallable([
                                dataValue, "toArray"
                            ])) {
                            dataValue = dataValue.toArray();
                        }
                        if (isArray(dataValue)) {
                            if (isSet(dataValue["@"])) {
                                mychildValue = to!string(dataValue["@"]);
                                unset(dataValue["@"]);
                            }
                            if (isSet(dataValue["xmlns:"])) {
                                mychildNS = dataValue["xmlns:"];
                                unset(dataValue["xmlns:"]);
                            }
                        }
                        else if(!empty(dataValue) || dataValue == 0 || dataValue == "0") {
                            mychildValue = (string) dataValue;
                        }

                        auto mychild = dataDom.createElement(dataKey);
                        if (mychildValue!isNull) {
                            mychild.appendChild(dataDom.createTextNode(mychildValue));
                        }
                        if (mychildNS) {
                            mychild.setAttribute("xmlns", mychildNS);
                        }
                        _fromArray(dataDom, mychild, dataValue, dataFormat);
                        dataNode.appendChild(mychild);
                    }

                    /**
     * Returns this XML structure as an array.
     * Params:
     * \SimpleXMLElement|\DOMNode myobj SimpleXMLElement, DOMNode instance
     * /
                    static array toArray(SimpleXMLElement | DOMNode myobj) {
                        if (cast(DOMNode) myobj) {
                            myobj = simplexml_import_dom(myobj);
                        }
                        if (myobj is null) {
                            throw new XmlException("Failed converting DOMNode to SimpleXMLElement");
                        }
                        auto result;
                        mynamespaces = array_merge(["": ""], myobj.getNamespaces(true));
                        _toArray(myobj, result, "", mynamespaces.keys);

                        return result;
                    }

                    /**
     * Recursive method to toArray
     * Params:
     * \SimpleXMLElement myxml SimpleXMLElement object
     * @param IData[string] myparentData Parent array with data
     * @param string myns Namespace of current child
     * /
                    protected static void _toArray(SimpleXMLElement myxml, array & myparentData, string myns, string[] namespacesInXML) {
                        auto mydata = null;

                        foreach (mynamespace; namespacesInXML) {
                            SimpleXMLElement myattributes = myxml.attributes(mynamespace, true);

                            // string aKey
                            myattributes.byKeyValue
                                .each!((kv) {
                                    string atKey = kv.key;
                                    if (!mynamespace.isEmpty) {
                                        atKey = mynamespace ~ ":" ~ kv.key;
                                    }
                                    mydata["@" ~ atKey] = (string) kv.value;
                                });
                            myxml.children(mynamespace, true)
                                .each!(child => _toArray(child, mydata, mynamespace, mynamespaces));
                        }
                        myasString = trim((string) myxml);
                        if (isEmpty(mydata)) {
                            mydata = myasString;
                        }
                        else if(!myasString.isEmpty) {
                            mydata["@"] = myasString;
                        }
                        if (!empty(myns)) {
                            myns ~= ":";
                        }
                        myname = myns ~ myxml.name;
                        if (isSet(myparentData[myname])) {
                            if (!isArray(myparentData[myname]) || !isSet(myparentData[myname][0])) {
                                myparentData[myname] = [myparentData[myname]];
                            }
                            myparentData[myname] ~= mydata;
                        } else {
                            myparentData[myname] = mydata;
                        }
                    } */
}
