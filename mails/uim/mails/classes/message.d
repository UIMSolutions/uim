module uim.mails.classes.message;

import uim.oop;

@safe:

/**
 * Email message class.
 *
 * This class is used for sending Internet Message Format based
 * on the standard outlined in https://www.rfc-editor.org/rfc/rfc2822.txt
 */
class DMessage { //: JsonSerializable {
    mixin TConfigurable;

    this() {
        initialize;
    }

    this(Json[string] initData) {
        initialize(initData);
    }

    this(string name) {
        this().name(name);
    }

    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        _emailFormatAvailable = [MESSAGE_TEXT, MESSAGE_HTML, MESSAGE_BOTH];
        _transferEncodingAvailable = [
            "7bit",
            "8bit",
            "base64",
            "binary",
            "quoted-printable",
        ];
        _charset = "utf-8";

        // TODO
        /*
        this.appCharset = Configuration.read("App.encoding");
        if (this.appCharset !isNull) {
            this.charset = this.appCharset;
        }
        this.domain = (string)preg_replace("/\:\d+/", "", (string)enviroment("HTTP_HOST"));
        if (isEmpty(this.domain)) {
            this.domain = D_uname("n");
        }
        if (configData) {
            configuration.update(configData);
        } */
        
        return true;
    }

    mixin(TProperty!("string", "name"));

    // Line length - no should more - RFC 2822 - 2.1.
    const int LINE_LENGTH_SHOULD = 78;

    // Line length - no must more - RFC 2822 - 2.1.1
    const int LINE_LENGTH_MUST = 998;

    // Type of message - HTML
    const string MESSAGE_HTML = "html";

    // Type of message - TEXT
    const string MESSAGE_TEXT = "text";

    // Type of message - BOTH
    const string MESSAGE_BOTH = "both";

    // Holds the regex pattern for email validation
    const string EMAIL_PATTERN = ""; //TODO  = "/^((?:[\p{L}0-9.!#%&\"*+\/=?^_`{|}~-]+)*@[\p{L}0-9-._]+)/ui";

    // Message ID
    protected string _messageId;

    /**
     * Domain for messageId generation.
     * Needs to be manually set for CLI mailing as enviroment("HTTP_HOST") is empty
     */
    protected string _domain;

    // The subject of the email
    protected string _subject;

    // Available formats to be sent.
    protected string[] _emailFormatAvailable = [
        MESSAGE_TEXT, MESSAGE_HTML, MESSAGE_BOTH
    ];

    // What format should the email be sent in
    protected string _emailFormat = MESSAGE_TEXT;

    // Charset the email body is sent in
    protected string _charset;

    /**
     * Charset the email header is sent in
     * If null, the charset property will be used as default
     */
    protected string _headerCharset;

    /**
     * The email transfer encoding used.
     * If null, the charset property is used for determined the transfer encoding.
     */
    protected string _transferEncoding;

    // Available encoding to be set for transfer.
    protected string[] _transferEncodingAvailable;

    // The application wide charset, used to encode headers and body
    protected string _appCharset;

    // If set, boundary to use for multipart mime messages
    protected string _boundary;

    /**
     * 8Bit character sets
     * /
    protected string[] charset8bit = ["UTF-8", "SHIFT_JIS"];

    // Define Content-Type charset name
    protected STRINGAA contentTypeCharset = [
        "ISO-2022-JP-MS": "ISO-2022-JP",
    ];

    /**
     * Regex for email validation
     *
     * If null, filter_var() will be used. Use the emailPattern() method
     * to set a custom pattern."
     */
    protected string aemailPattern = EMAIL_PATTERN;

    /* 
    // Recipient of the email
    // TODO protected Json[string] to = null;

    // The mail which the email is sent fro
    // TODO protected Json[string] from = null;

    // The sender email
    // TODO protected Json[string] sender = null;

    // List of email(s) that the recipient will reply to
    // TODO protected Json[string] replyTo = null;

    // The read receipt emai
    // TODO protected Json[string] readReceipt = null;

    /**
     * The mail that will be used in case of any errors like
     * - Remote mailserver down
     * - Remote user has exceeded his quota
     * - Unknown user
     * /
    // TODO protected Json[string] resultPath = null;

    /**
     * Carbon Copy
     *
     * List of email"s that should receive a copy of the email.
     * The Recipient WILL be able to see this list
      * /
    // TODO protected Json[string] cc = null;

    /**
     * Blind Carbon Copy
     *
     * List of email"s that should receive a copy of the email.
     * The Recipient WILL NOT be able to see this list
     * /
    // TODO protected Json[string] bcc = null;


    /**
     * Associative array of a user defined headers
     * Keys will be prefixed "X-" as per RFC2822 Section 4.7.5
     * /
    // TODO protected Json[string] aHeaders = null;

    // Text message
    protected string atextMessage = "";

    // Html message
    protected string ahtmlMessage = "";

    // Final message to send
    // TODO protected Json[string] message = null;

 

    /**
     * List of files that should be attached to the email.
     *
     * Only absolute paths
     *
     * @var array<string, array>
     * /
    // TODO protected Json[string] attachments;


    /**
     * Contains the optional priority of the email.
     *
     * @var int
     * /
    protected int priority = null;

    /**
     * Properties that could be serialized
     * /
    protected string[] serializableProperties = [
        "to", "from", "sender", "replyTo", "cc", "bcc", "subject",
        "returnPath", "readReceipt", "emailFormat", "emailPattern", "domain",
        "attachments", "messageId", "headers", "appCharset", "charset", "headerCharset",
        "textMessage", "htmlMessage",
    ];


    
    /**
     * Sets "from" address.
     * Params:
     * string[] aemail String with email,
     *  Array with email as key, name as value or email as value (without name)
     * @param string name Name
     * @return this
     * /
    auto setFrom(string[] aemail, string aName = null) {
        return _setEmailSingle("from", email, aName, "From requires only 1 email address.");
    }

    // Gets "from" address
    Json[string] getFrom() {
        return _from;
    }

    /**
     * Sets the "sender" address. See RFC link below for full explanation.
     * Params:
     * string[] aemail String with email,
     *  Array with email as key, name as value or email as value (without name)
     * @param string name Name
     * @return this
     * @throws \InvalidArgumentException
     * @link https://tools.ietf.org/html/rfc2822.html#section-3.6.2
     * /
    auto setSender(string[] aemail, string aName = null) {
        return _setEmailSingle("sender", email, name, "Sender requires only 1 email address.");
    }
    
    /**
     * Gets the "sender" address. See RFC link below for full explanation.
     * /
    Json[string] getSender() {
        return _sender;
    }
    
    /**
     * Sets "Reply-To" address.
     * Params:
     * string[] aemail String with email,
     *  Array with email as key, name as value or email as value (without name)
     * @param string name Name
     * @return this
     * @throws \InvalidArgumentException
    * /
    auto setReplyTo(string[] aemail, string aName = null) {
        return _setEmail("replyTo", email, name);
    }
    
    /**
     * Gets "Reply-To" address.
     *
      * /
    Json[string] getReplyTo() {
        return _replyTo;
    }
    
    /**
     * Add "Reply-To" address.
     * /
    auto addReplyTo(string[] email, string name = null) {
        return _addEmail("replyTo", email, name);
    }
    
    /**
     * Sets Read Receipt (Disposition-Notification-To header).
     * /
    void setReadReceipt(string[] email, string name = null) {
        return _setEmailSingle(
            "readReceipt",
            email,
            name,
            "Disposition-Notification-To requires only 1 email address."
        );
    }
    
    /**
     * Gets Read Receipt (Disposition-Notification-To header).
     * /
    Json[string] getReadReceipt() {
        return _readReceipt;
    }
    
    /**
     * Sets return path.
     * Params:
     * string[] aemail String with email,
     *  Array with email as key, name as value or email as value (without name)
     * @param string name Name
     * @return this
     * @throws \InvalidArgumentException
     * /
    auto setReturnPath(string[] aemail, string aName = null) {
        return _setEmailSingle("returnPath", email, name, "Return-Path requires only 1 email address.");
    }
    
    /**
     * Gets return path.
     * /
    Json[string] getReturnPath() {
        return _returnPath;
    }
    
    /**
     * Sets "to" address.
     * Params:
     * string[] aemail String with email,
     *  Array with email as key, name as value or email as value (without name)
     * @param string name Name
     * /
    auto setTo(string[] aemail, string aName = null) {
        return _setEmail("to", email, name);
    }
    
    /**
     * Gets "to" address
     * /
    Json[string] getTo() {
        return _to;
    }
    
    /**
     * Add "To" address.
     * Params:
     * string[] aemail String with email,
     *  Array with email as key, name as value or email as value (without name)
     * @param string name Name
     * /
    auto addTo(string[] aemail, string aName = null) {
        return _addEmail("to", email, name);
    }
    
    /**
     * Sets "cc" address.
     * Params:
     * string[] aemail String with email,
     *  Array with email as key, name as value or email as value (without name)
     * @param string name Name
     * /
    auto setCc(string[] aemail, string aName = null) {
        return _setEmail("cc", email, name);
    }
    
    /**
     * Gets "cc" address.
     *
     * /
    Json[string] getCc() {
        return _cc;
    }
    
    /**
     * Add "cc" address.
     * Params:
     * string[] aemail String with email,
     *  Array with email as key, name as value or email as value (without name)
     * @param string name Name
     * /
    auto addCc(string[] aemail, string aName = null) {
        return _addEmail("cc", email, name);
    }
    
    /**
     * Sets "bcc" address.
     * Params:
     * string[] aemail String with email,
     *  Array with email as key, name as value or email as value (without name)
     * @param string name Name
     * /
    auto setBcc(string[] aemail, string aName = null) {
        return _setEmail("bcc", email, name);
    }
    
    /**
     * Gets "bcc" address.
     *
     * /
    Json[string] getBcc() {
        return _bcc;
    }
    
    /**
     * Add "bcc" address.
     * Params:
     * string[] aemail String with email,
     *  Array with email as key, name as value or email as value (without name)
     * @param string name Name
     * /
    auto addBcc(string[] aemail, string aName = null) {
        return _addEmail("bcc", email, name);
    }
    
    mixin(TProperty!("string", "charset"));
    
    /**
     * HeaderCharset setter.
     * Params:
     * string charset Character set.
     * /
    void setHeaderCharset(string charset) {
        this.headerCharset = charset;
    }
    
    // HeaderCharset getter.
    string getHeaderCharset() {
        return _headerCharset ?: this.charset;
    }
    
    /**
     * TransferEncoding setter.
     * Params:
     * string encoding Encoding set.
     * @return this
     * @throws \InvalidArgumentException
     * /
    auto setTransferEncoding(string aencoding) {
        if (encoding !isNull) {
            encoding = encoding.toLower;
            if (!in_array(encoding, this.transferEncodingAvailable, true)) {
                throw new DInvalidArgumentException(
                    "Transfer encoding not available. Can be : %s."
                    .format(join(", ", this.transferEncodingAvailable))
                );
            }
        }
        this.transferEncoding = encoding;

        return this;
    }
    
    /**
     * TransferEncoding getter.
     * /
    string getTransferEncoding() {
        return _transferEncoding;
    }
    
    /**
     * EmailPattern setter/getter
     * Params:
     * string regex The pattern to use for email address validation,
     *  null to unset the pattern and make use of filter_var() instead.
     * /
    auto setEmailPattern(string aregex) {
        this.emailPattern = regex;

        return this;
    }
    
    /**
     * EmailPattern setter/getter
     * /
    string getEmailPattern() {
        return _emailPattern;
    }
    
    /**
     * Set email
     * Params:
     * string avarName Property name
     * @param string[] aemail String with email,
     *  Array with email as key, name as value or email as value (without name)
     * @param string name Name
     * /
    protected void setEmail(string avarName, string[] aemail, string aName) {
        if (!isArray(email)) {
            this.validateEmail(email, varName);
            this.{varName} = [email: name ?? email];

            return;
        }
        list = null;
        email.byKeyValue.each!((kv) {
            if (isInt(kv.key)) {
                kv.key = kv.value;
            }
            this.validateEmail(kv.key, varName);
            list[kv.key] = kv.value ? kv.value : kv.key;
        });
        this.{varName} = list;
    }
    
    /**
     * Validate email address
     * Params:
     * string aemail Email address to validate
     * @param string acontext Which property was set
     * /
    protected void validateEmail(string emailAddress, string acontext) {
        if (this.emailPattern.isNull) {
            if (filter_var(emailAddress, FILTER_VALIDATE_EMAIL)) {
                return;
            }
        } else if (preg_match(this.emailPattern, emailAddress)) {
            return;
        }
        context = stripLeft(context, "_");
        if (emailAddress.isEmpty) {
            throw new DInvalidArgumentException("The email set for `%s` is empty.".format(context));
        }
        throw new DInvalidArgumentException("Invalid email set for `%s`. You passed `%s`.".format(context, emailAddress));
    }
    
    /**
     * Set only 1 email
     * Params:
     * string avarName Property name
     * @param string[] aemail String with email,
     *  Array with email as key, name as value or email as value (without name)
     * @param string name Name
     * @param string athrowMessage Exception message
     * /
    protected void setEmailSingle(string avarName, string[] aemail, string aName, string exceptionMessage) {
        if (email == []) {
            this.{varName} = email;
            return;
        }

        auto current = this.{varName};
        this.setEmail(varName, email, name);
        if (count(this.{varName}) != 1) {
            this.{varName} = current;
            throw new DInvalidArgumentException(exceptionMessage);
        }
    }
    
    /**
     * Add email
     * Params:
     * string avarName Property name
     * @param string[] aemail String with email,
     *  Array with email as key, name as value or email as value (without name)
     * @param string name Name
     * /
    protected void addEmail(string avarName, STRINGAA emailValue, string aName) {
        if (!isArray(emailValue)) {
            this.validateEmail(emailValue, varName);
            name ??= emailValue;
            this.{varName}[emailValue] = name;

            return;
        }
        list = null;
        emailValue.byKeyValue
            .each!((kv) {
                if (isInt(aKey)) {
                    aKey = aValue;
                }
                this.validateEmail(aKey, varName);
                list[aKey] = aValue;
            });
        this.{varName} = chain(this.{varName}, list);
    }
    
    /**
     * Sets subject.
     * Params:
     * string asubject Subject string.
     * /
    auto setSubject(string asubject) {
        this.subject = this.encodeForHeader(subject);

        return this;
    }
    
    /**
     * Gets subject.
     * /
    string subject() {
        return _subject;
    }
    
    /**
     * Get original subject without encoding
     * /
    string getOriginalSubject() {
        return _decodeForHeader(this.subject);
    }
    
    /**
     * Sets headers for the message
     * Params:
     * Json[string] aHeaders Associative array containing headers to be set.
     * /
    auto setHeaders(Json[string] aHeaders) {
        this.headers = aHeaders;

        return this;
    }
    
    /**
     * Add header for the message
     * Params:
     * Json[string] aHeaders Headers to set.
     * /
    auto addHeaders(Json[string] aHeaders) {
        this.headers = Hash.merge(this.headers,  aHeaders);

        return this;
    }
    
    /**
     * Get list of headers
     *
     * ### Includes:
     *
     * - `from`
     * - `replyTo`
     * - `readReceipt`
     * - `returnPath`
     * - `to`
     * - `cc`
     * - `bcc`
     * - `subject`
     * Params:
     * string[] anInclude List of headers.
     * /
    string[] getHeaders(Json[string] anInclude = []) {
        this.createBoundary();

        if (anInclude == anInclude.values) {
             anInclude = array_fill_keys(anInclude, true);
        }
        defaults = array_fill_keys(
            [
                "from", "sender", "replyTo", "readReceipt", "returnPath",
                "to", "cc", "bcc", "subject",
            ],
            false
        );
         anInclude += defaults;

         aHeaders = null;
        relation = [
            "from": "From",
            "replyTo": "Reply-To",
            "readReceipt": "Disposition-Notification-To",
            "returnPath": "Return-Path",
            "to": "To",
            "cc": "Cc",
            "bcc": "Bcc",
        ];
         aHeadersMultipleEmails = ["to", "cc", "bcc", "replyTo"];
        foreach (relation as var:  aHeader) {
            if (anInclude[var]) {
                if (in_array(var,  aHeadersMultipleEmails)) {
                     aHeaders[aHeader] = join(", ", this.formatAddress(this.{var}));
                } else {
                     aHeaders[aHeader] = (string)current(this.formatAddress(this.{var}));
                }
            }
        }
        if (anInclude["sender"]) {
            if (key(this.sender) == key(this.from)) {
                 aHeaders["Sender"] = "";
            } else {
                 aHeaders["Sender"] = (string)current(this.formatAddress(this.sender));
            }
        }
         aHeaders += this.headers;
        if (!isSet(aHeaders["Date"])) {
             aHeaders["Date"] = date(DATE_RFC2822);
        }
        if (this.messageId != false) {
            if (this.messageId == true) {
                this.messageId = "<" ~ Text.uuid().replace("-", "") ~ "@" ~ this.domain ~ ">";
            }
             aHeaders["Message-ID"] = this.messageId;
        }
        if (this.priority) {
             aHeaders["X-Priority"] = (string)this.priority;
        }
        if (anInclude["subject"]) {
             aHeaders["Subject"] = this.subject;
        }
         aHeaders["MIME-Version"] = "1.0";
        if (this.attachments) {
             aHeaders["Content-Type"] = "multipart/mixed; boundary="" ~ (string)this.boundary ~ """;
        } else if (this.emailFormat == MESSAGE_BOTH) {
             aHeaders["Content-Type"] = "multipart/alternative; boundary="" ~ (string)this.boundary ~ """;
        } else if (this.emailFormat == MESSAGE_TEXT) {
             aHeaders["Content-Type"] = "text/plain; charset=" ~ this.getContentTypeCharset();
        } else if (this.emailFormat == MESSAGE_HTML) {
             aHeaders["Content-Type"] = "text/html; charset=" ~ this.getContentTypeCharset();
        }
         aHeaders["Content-Transfer-Encoding"] = this.getContentTransferEncoding();

        return aHeaders;
    }
    
    /**
     * Get headers as string.
     * Params:
     * string[] anInclude List of headers.
     * @param string aeol End of line string for concatenating headers.
     * @param \Closure|null aCallback Callback to run each header value through before stringifying.
     * /
    string getHeadersString(Json[string] anInclude = [], string aeol = "\r\n", ?Closure aCallback = null) {
        auto lines = this.getHeaders(anInclude);

        if (aCallback) {
            lines = array_map(aCallback, lines);
        }
        
        auto aHeaders = null;
        foreach (aKey: aValue; lines) {
            if (isEmpty(aValue) && aValue != "0") {
                continue;
            }
            foreach ((array)aValue as val) {
                 aHeaders ~= aKey ~ ": " ~ val;
            }
        }
        return join(eol,  aHeaders);
    }
    
    /**
     * Format addresses
     *
     * If the address contains non alphanumeric/whitespace characters, it will
     * be quoted as characters like `:` and `,` are known to cause issues
     * in address header fields.
     * Params:
     * Json[string] address Addresses to format.
     * /
    // TODO protected Json[string] formatAddress(Json[string] address) {
        auto result;
        foreach (address as email: alias) {
            if (email == alias) {
                result ~= email;
            } else {
                encoded = this.encodeForHeader(alias);
                if (preg_match("/[^a-z0-9+\-\\=? ]/i", encoded)) {
                    encoded = "\"" ~ addcslashes(encoded, ""\\") ~ "\"";
                }
                result ~= "%s <%s>".format(encoded, email);
            }
        }
        return result;
    }
    
    /**
     * Sets email format.
     * Params:
     * string aformat Formatting string.
     * /
    void setEmailFormat(string aformat) {
        if (!in_array(aformat, this.emailFormatAvailable, true)) {
            throw new DInvalidArgumentException("Format not available.");
        }
        this.emailFormat = format;
    }
    
    // Gets email format.
    string emailFormat() {
        return _emailFormat;
    }
    
    // Gets the body types that are in this email message
    Json[string] getBodyTypes() {
        string format = _emailFormat;

        if (format == MESSAGE_BOTH) {
            return [MESSAGE_HTML, MESSAGE_TEXT];
        }
        return [format];
    }
    
    /**
     * Sets message ID.
     * Params:
     * string message True to generate a new DMessage-ID, False to ignore (not send in email),
     *  String to set as Message-ID.
     * /
    void setMessageId(string message) {
        if (!preg_match("/^\<.+@.+\>/", message)) {
            throw new DInvalidArgumentException(
                "Invalid format to Message-ID. The text should be something like "<uuid@server.com>""
            );
        }
        this.messageId = message;
    }
    
    // Gets message ID.
    string getMessageId() {
        return _messageId;
    }
    
    /**
     * Sets domain.
     *
     * Domain as top level (the part after @).
     * Params:
     * string adomain Manually set the domain for CLI mailing.
     * /
    auto setDomain(string adomain) {
        this.domain = domain;

        return this;
    }
    
    // Gets domain.
    string getDomain() {
        return _domain;
    }
    
    /**
     * Add attachments to the email message
     *
     * Attachments can be defined in a few forms depending on how much control you need:
     *
     * Attach a single file:
     *
     * ```
     * this.setAttachments("path/to/file");
     * ```
     *
     * Attach a file with a different filename:
     *
     * ```
     * this.setAttachments(["custom_name.txt": "path/to/file.txt"]);
     * ```
     *
     * Attach a file and specify additional properties:
     *
     * ```
     * this.setAttachments(["custom_name.png": [
     *     "file": "path/to/file",
     *     "mimetype": "image/png",
     *     "contentId": "abc123",
     *     "contentDisposition": false.toJson
     *   ]
     * ]);
     * ```
     *
     * Attach a file from string and specify additional properties:
     *
     * ```
     * this.setAttachments(["custom_name.png": [
     *     "data": file_get_contents("path/to/file"),
     *     "mimetype": "image/png"
     *   ]
     * ]);
     * ```
     *
     * The `contentId` key allows you to specify an inline attachment. In your email text, you
     * can use `<img src="cid:abc123">` to display the image inline.
     *
     * The `contentDisposition` key allows you to disable the `Content-Disposition` header, this can improve
     * attachment compatibility with outlook email clients.
     * /
    void setAttachments(DirEntry[string] fileAttachments) {
        auto attach = null;
        foreach (attName; dirEntry; fileAttachments) {
            if (!isArray(dirEntry)) {
                dirEntry = ["file": dirEntry];
            }
            if (!dirEntry.isSet("file")) {
                if (!isSet(dirEntry["data"])) {
                    throw new DInvalidArgumentException("No file or data specified.");
                }
                if (isInt(attName)) {
                    throw new DInvalidArgumentException("No filename specified.");
                }
                dirEntry["data"] = chunk_split(base64_encode(dirEntry["data"]), 76, "\r\n");
            } else if (cast(IUploadedFile)dirEntry["file"]) {
                dirEntry["mimetype"] = dirEntry["file"].getClientMediaType();
                if (isInt(attName)) {
                    attName = dirEntry["file"].getClientFilename();
                    assert(isString(attName));
                }
            } else if (isString(dirEntry["file"])) {
                string fileName = dirEntry["file"];
                dirEntry["file"] = realpath(dirEntry["file"]);
                if (dirEntry["file"] == false || !fileExists(dirEntry["file"])) {
                    throw new DInvalidArgumentException("File not found: `%s`".format(fileName));
                }
                if (isInt(attName)) {
                    attName = basename(dirEntry["file"]);
                }
            } else {
                throw new DInvalidArgumentException(
                    "File must be a filepath or IUploadedFile instance. Found `%s` instead."
                    .format(dirEntry["file"].stringof)
                );
            }
            if (
                !isSet(dirEntry["mimetype"])
                && isSet(dirEntry["file"])
                && isString(dirEntry["file"])
                && function_exists("mime_content_type")
            ) {
                dirEntry["mimetype"] = mime_content_type(dirEntry["file"]);
            }
            if (!isSet(dirEntry["mimetype"])) {
                dirEntry["mimetype"] = "application/octet-stream";
            }
            attach[attName] = dirEntry;
        }
        this.attachments = attach;
    }
    
    // Gets attachments to the email message.
    array<string, array> getAttachments() {
        return _attachments;
    }
    
    /**
     * Add attachments
     * Params:
     * Json[string] attachments Array of filenames.
     * @throws \InvalidArgumentException
     * /
    void addAttachments(Json[string] attachments) {
        current = this.attachments;
        this.setAttachments(attachments);
        this.attachments = array_merge(current, this.attachments);
    }
    
    /**
     * Get generated message body as array.
     *
     * /
    Json[string] getBody() {
        if (isEmpty(this.message)) {
            this.message = this.generateMessage();
        }
        return _message;
    }
    
    // Get generated body as string.
    string getBodyString(string eol = "\r\n") {
        auto lines = this.getBody();

        return lines.join(eol, );
    }
    
    /**
     * Create unique boundary identifier
     * /
    protected void createBoundary() {
        if (
            this.boundary.isNull &&
            (
                this.attachments ||
                this.emailFormat == MESSAGE_BOTH
            )
        ) {
            this.boundary = md5(Security.randomBytes(16));
        }
    }
    
    // Generate full message.
    protected string[] generateMessage() {
        this.createBoundary();
        string[] message;

        contentIds = array_filter((array)Hash.extract(this.attachments, "{s}.contentId"));
        hasInlineAttachments = count(contentIds) > 0;
        hasAttachments = !empty(this.attachments);
        hasMultipleTypes = this.emailFormat == MESSAGE_BOTH;
        multiPart = (hasAttachments || hasMultipleTypes);

        string boundary = !_boundary.isEmpty ? _boundary : "";
        string textBoundary = boundary;
        string relBoundary = boundary;

        if (hasInlineAttachments) {
            message ~= "--" ~ boundary;
            message ~= "Content-Type: multipart/related; boundary="rel-" ~ boundary ~ """;
            message ~= "";
            relBoundary = textBoundary = "rel-" ~ boundary;
        }
        if (hasMultipleTypes && hasAttachments) {
            message ~= "--" ~ relBoundary;
            message ~= "Content-Type: multipart/alternative; boundary="alt-" ~ boundary ~ """;
            message ~= "";
            textBoundary = "alt-" ~ boundary;
        }
        if (
            this.emailFormat == MESSAGE_TEXT
            || this.emailFormat == MESSAGE_BOTH
        ) {
            if (multiPart) {
                message ~= "--" ~ textBoundary;
                message ~= "Content-Type: text/plain; charset=" ~ this.getContentTypeCharset();
                message ~= "Content-Transfer-Encoding: " ~ this.getContentTransferEncoding();
                message ~= "";
            }
            content = this.textMessage.split("\n");
            message = array_merge(message, content);
            message ~= "";
            message ~= "";
        }
        if (
            this.emailFormat == MESSAGE_HTML
            || this.emailFormat == MESSAGE_BOTH
        ) {
            if (multiPart) {
                message ~= "--" ~ textBoundary;
                message ~= "Content-Type: text/html; charset=" ~ this.getContentTypeCharset();
                message ~= "Content-Transfer-Encoding: " ~ this.getContentTransferEncoding();
                message ~= "";
            }
            string[] content = this.htmlMessage.split("\n")
            message = array_merge(message, content);
            message ~= "";
            message ~= "";
        }
        if (textBoundary != relBoundary) {
            message ~= "--" ~ textBoundary ~ "--";
            message ~= "";
        }
        if (hasInlineAttachments) {
            attachments = this.attachInlineFiles(relBoundary);
            message = array_merge(message, attachments);
            message ~= "";
            message ~= "--" ~ relBoundary ~ "--";
            message ~= "";
        }
        if (hasAttachments) {
            attachments = this.attachFiles(boundary);
            message = array_merge(message, attachments);
        }
        if (hasAttachments || hasMultipleTypes) {
            message ~= "";
            message ~= "--" ~ boundary ~ "--";
            message ~= "";
        }
        return message;
    }
    
    /**
     * Attach non-embedded files by adding file contents inside boundaries.
     * Params:
     * string boundary Boundary to use. If null, will default to this.boundary
     * /
    protected string[] attachFiles(string aboundary = null) {
        boundary ??= this.boundary;

        message = null;
        foreach (this.attachments as filename: dirEntry) {
            if (!empty(dirEntry["contentId"])) {
                continue;
            }
            someData = dirEntry.get("data", this.readFile(dirEntry["file"]));
            hasDisposition = (
                !isSet(dirEntry["contentDisposition"]) ||
                dirEntry["contentDisposition"]
            );
            part = new DFormDataPart("", someData, "", this.getHeaderCharset());

            if (hasDisposition) {
                part.disposition("attachment");
                part.filename(filename);
            }
            part.transferEncoding("base64");
            part.type(dirEntry["mimetype"]);

            message ~= "--" ~ boundary;
            message ~= (string)part;
            message ~= "";
        }
        return message;
    }
    
    /**
     * Attach inline/embedded files to the message.
     * Params:
     * string boundary Boundary to use. If null, will default to this.boundary
     * /
    protected string[] attachInlineFiles(string aboundary = null) {
        auto boundary = boundary ? baoundry :  this.boundary;

        auto message = null;
        foreach (this.getAttachments() as filename: dirEntry) {
            if (isEmpty(dirEntry["contentId"])) {
                continue;
            }
            someData = dirEntry["data"] ?? this.readFile(dirEntry["file"]);

            message ~= "--" ~ boundary;
            part = new DFormDataPart("", someData, "inline", this.getHeaderCharset());
            part.type(dirEntry["mimetype"]);
            part.transferEncoding("base64");
            part.contentId(dirEntry["contentId"]);
            part.filename(filename);
            message ~= (string)part;
            message ~= "";
        }
        return message;
    }
    
    /**
     * Sets priority.
     * Params:
     * int priority 1 (highest) to 5 (lowest)
     * /
    auto setPriority(int priority) {
        this.priority = priority;

        return this;
    }
    
    // Gets priority.
    int getPriority() {
        return _priority;
    }
    
    /**
     * Sets the configuration for this instance.
     *
     * configData - Config array.
     * /
    auto setConfig(Json[string] configData = null) {
        string[] simpleMethods = [
            "from", "sender", "to", "replyTo", "readReceipt", "returnPath",
            "cc", "bcc", "messageId", "domain", "subject", "attachments",
            "emailFormat", "emailPattern", "charset", "headerCharset",
        ];
        simpleMethods.each!((method) {
            if (configuration.hasKey(method))) {
                this.{"set" ~ ucfirst(method)}(configData[method]);
            }
        });
        if (configuration.hasKey("headers")) {
            this.setHeaders(configData("headers"));
        }
        return this;
    }
    
    /**
     * Set message body.
     * Params:
     * STRINGAA content Content array with keys "text" and/or "html" with
     *  content string of respective type.
     * /
    auto setBody(Json[string] content) {
        foreach (content as type: text) {
            if (!in_array(type, this.emailFormatAvailable, true)) {
                throw new DInvalidArgumentException(
                    "Invalid message type: `%s`. Valid types are: `text`, `html`.".format(
                    type
                ));
            }
            text = text.replace(["\r\n", "\r"], "\n");
            text = this.encodeString(text, this.getCharset());
            text = this.wrap(text);
            text = text.join("\n").rstrip("\n");

             aProperty = "{type}Message";
            this. aProperty = text;
        }
        this.boundary = null;
        this.message = null;

        return this;
    }
    
    /**
     * Set text body for message.
     * Params:
     * string acontent Content string
     * /
    auto setBodyText(string acontent) {
        this.setBody([MESSAGE_TEXT: content]);

        return this;
    }
    
    /**
     * Set HTML body for message.
     * Params:
     * string acontent Content string
     * /
    auto setBodyHtml(string acontent) {
        this.setBody([MESSAGE_HTML: content]);

        return this;
    }
    
    /**
     * Get text body of message.
     * /
    string getBodyText() {
        return _textMessage;
    }
    
    /**
     * Get HTML body of message.
     * /
    string getBodyHtml() {
        return _htmlMessage;
    }
    
    /**
     * Translates a string for one charset to another if the App.encoding value
     * differs and the mb_convert_encoding auto exists
     * Params:
     * string atext The text to be converted
     * @param string acharset the target encoding
     * /
    protected string encodeString(string atext, string acharset) {
        if (this.appCharset == charset) {
            return text;
        }
        if (this.appCharset.isNull) {
            return mb_convert_encoding(text, charset);
        }
        return mb_convert_encoding(text, charset, this.appCharset);
    }
    
    /**
     * Wrap the message to follow the RFC 2822 - 2.1.1
     * Params:
     * string message Message to wrap
     * @param int wrapLength The line length
     * /
    protected string[] wrap(string amessage = null, int wrapLength = self.LINE_LENGTH_MUST) {
        if (message.isNull || message.isEmpty) {
            return [""];
        }
        message = message.replace(["\r\n", "\r"], "\n");
        string[] lines = message.split("\n");
        formatted = null;
        cut = (wrapLength == LINE_LENGTH_MUST);

        foreach (lines as line) {
            if (isEmpty(line) && line != "0") {
                formatted ~= "";
                continue;
            }
            if (line.length < wrapLength) {
                formatted ~= line;
                continue;
            }
            if (!preg_match("/<[a-z]+.*>/i", line)) {
                formatted = array_merge(
                    formatted,
                    Text.wordWrap(line, wrapLength, "\n", cut).split("\n")
                );
                continue;
            }
            tagOpen = false;
            string tmpLine;
            string tag;
            tmpLineLength = 0;
            for (anI = 0, count = line.length;  anI < count;  anI++) {
                char = line[anI];
                if (tagOpen) {
                    tag ~= char;
                    if (char == ">") {
                        tagLength = tag.length;
                        if (tagLength + tmpLineLength < wrapLength) {
                            tmpLine ~= tag;
                            tmpLineLength += tagLength;
                        } else {
                            if (tmpLineLength > 0) {
                                formatted = chain(
                                    formatted,
                                    Text.wordWrap(trim(tmpLine), wrapLength, "\n", cut).split("\n")
                                );
                                tmpLine = "";
                                tmpLineLength = 0;
                            }
                            if (tagLength > wrapLength) {
                                formatted ~= tag;
                            } else {
                                tmpLine = tag;
                                tmpLineLength = tagLength;
                            }
                        }
                        
                        tag = null;
                        tagOpen = false;
                    }
                    continue;
                }
                if (char == "<") {
                    tagOpen = true;
                    tag = "<";
                    continue;
                }
                if (char == " " && tmpLineLength >= wrapLength) {
                    formatted ~= tmpLine;
                    tmpLineLength = 0;
                    continue;
                }
                tmpLine ~= char;
                tmpLineLength++;
                if (tmpLineLength == wrapLength) {
                    nextChar = line[anI + 1] ?? "";
                    if (nextChar == " " || nextChar == "<") {
                        formatted ~= strip(tmpLine);
                        tmpLine = "";
                        tmpLineLength = 0;
                        if (nextChar == " ") {
                             anI++;
                        }
                    } else {
                        lastSpace = strrpos(tmpLine, " ");
                        if (lastSpace == false) {
                            continue;
                        }
                        formatted ~= strip(substr(tmpLine, 0, lastSpace));
                        tmpLine = substr(tmpLine, lastSpace + 1);

                        tmpLineLength = tmpLine.length;
                    }
                }
            }
            if (!tmpLine.isEmpty) {
                formatted ~= tmpLine;
            }
        }
        formatted ~= "";

        return formatted;
    }
    
    // Reset all the internal variables to be able to send out a new email.
    auto reset() {
        _to = null;
        _from = null;
        _sender = null;
        _replyTo = null;
        _readReceipt = null;
        _returnPath = null;
        _cc = null;
        _bcc = null;
        _messageId = true;
        _subject = "";
        _headers = null;
        _textMessage = "";
        _htmlMessage = "";
        _message = null;
        _emailFormat = MESSAGE_TEXT;
        _priority = null;
        _charset = "utf-8";
        _headerCharset = null;
        _transferEncoding = null;
        _attachments = null;
        _emailPattern = EMAIL_PATTERN;

        return this;
    }
    
    /**
     * Encode the specified string using the current charset
     * Params:
     * string atext String to encode
     * /
    protected string encodeForHeader(string textToEncode) {
        if (this.appCharset.isNull) {
            return textToEncode;
        }
        restore = mb_internal_encoding();
        mb_internal_encoding(this.appCharset);
        auto result = mb_encode_mimeheader(textToEncode, this.getHeaderCharset(), "B");
        mb_internal_encoding(restore);

        return result;
    }
    
    /**
     * Decode the specified string
     * Params:
     * string atext String to decode
     * /
    protected string decodeForHeader(string textToEncode) {
        if (this.appCharset.isNull) {
            return textToEncode;
        }
        restore = mb_internal_encoding();
        mb_internal_encoding(this.appCharset);
        result = mb_decode_mimeheader(textToEncode);
        mb_internal_encoding(restore);

        return result;
    }
    
    /**
     * Read the file contents and return a base64 version of the file contents.
     * Params:
     * \Psr\Http\Message\IUploadedFile|string afile The absolute path to the file to read
     *  or IUploadedFile instance.
     * /
    protected string readFile(IUploadedFile|string afile) {
        if (isString(file)) {
            content = (string)file_get_contents(file);
        } else {
            content = (string)file.getStream();
        }
        return chunk_split(base64_encode(content));
    }
    
    /**
     * Return the Content-Transfer Encoding value based
     * on the set transferEncoding or set charset.
     * /
    string getContentTransferEncoding() {
        if (this.transferEncoding) {
            return _transferEncoding;
        }
        
        string charset = this.charset.toUpper;
        if (in_array(charset, this.charset8bit, true)) {
            return "8bit";
        }
        return "7bit";
    }
    
    /**
     * Return charset value for Content-Type.
     *
     * Checks fallback/compatibility types which include workarounds
     * for legacy japanese character sets.
     * /
    string getContentTypeCharset() {
        string charset = this.charset.toUpper;
        return array_key_exists(charset, this.contentTypeCharset))
            ? this.contentTypeCharset[charset].toUpper
            : this.charset.toUpper;
    }
    
    /**
     * Serializes the email object to a value that can be natively serialized and re-used
     * to clone this email instance.
     *
     * @return Json[string] Serializable array of configuration properties.
     * @throws \Exception When a view var object can not be properly serialized.
     * /
    Json[string] JsonSerialize() {
        Json[string] = null;
        foreach (this.serializableProperties as  aProperty) {
            array[aProperty] = this.{ aProperty};
        }
         array_walk(array["attachments"], auto (& anItem, aKey) {
            if (!empty(anItem["file"])) {
                 anItem["data"] = this.readFile(anItem["file"]);
                unset(anItem["file"]);
            }
        });

        return array_filter(array, auto (anI) {
            return anI !isNull && !isArray(anI) && !isBool(anI) && anI.length || !empty(anI);
        });
    }
    
    /**
     * Configures an email instance object from serialized config.
     *
     * configData - Email configuration array.
     * /
    void createFromArray(Json[string] configData = null) {
        foreach (configData as  aProperty: aValue) {
            this.{ aProperty} = aValue;
        }
    }
    
    /**
     * Magic method used for serializing the Message object.
     *
     * /
    Json[string] __serialize() {
        Json[string] = this.JsonSerialize();
        array_walk_recursive(array, void (& anItem, aKey) {
            if (cast(DSimpleXMLElement)anItem ) {
                 anItem = Json_decode((string)Json_encode((array) anItem), true);
            }
        });

        return array;
    }
    
    /**
     * Magic method used to rebuild the Message object.
     * Params:
     * Json[string] data Data array.
     * /
    void __unserialize(Json[string] data) {
        this.createFromArray(someData);
    } */
}
