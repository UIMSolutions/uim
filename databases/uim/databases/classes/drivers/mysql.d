module uim.databases.classes.drivers.mysql;

import uim.databases;

@safe:

class DMysqlDriver : DDriver {
    mixin(DriverThis!("Mysql"));

    protected const MAX_ALIAS_LENGTH = 256;

    // Server type MySQL
    protected const string SERVER_TYPE_MYSQL = "mysql";

    // Server type MariaDB
    protected const string SERVER_TYPE_MARIADB = "mariadb";

    override bool initialize(IData[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        // Base configuration settings for MySQL driver
        configuration.merge([
            "persistent": BooleanData(true),
            "host": StringData("localhost"),
            "username": StringData("root"),
            "password": StringData(""),
            "database": StringData("uim"),
            "port": StringData("3306"),
            "flags": Json.emptyArray,
            "encoding": StringData("utf8mb4"),
            "timezone": NullData(null),
            "init": Json.emptyArray,
        ]);

        startQuote("`");
        endQuote("`");

        return true;
    }

    /**
     * Server type.
     *
     * If the underlying server is MariaDB, its value will get set to `'mariadb'`
     * after `currentVersion()` method is called.
     * /
    protected string serverType = SERVER_TYPE_MYSQL;

    // Mapping of feature to db server version for feature availability checks.
    protected IData _featureVersions = [
        "mysql": [
            "IData": "5.7.0",
            "cte": "8.0.0",
            "window": "8.0.0",
        ],
        "mariadb": [
            "IData": "10.2.7",
            "cte": "10.2.1",
            "window": "10.2.0",
        ],
    ];

 
    void connect() {
        if (this.pdo.isSet) {
            return;
        }
        auto configData = configuration;

        if (configuration.get("timezone"] == "UTC") {
            configuration.get("timezone"] = "+0:00";
        }
        if (!(configuration.get("timezone"].isEmpty) {
            configuration.get("init"] ~= "SET time_zone = '%s'".format(configuration.get("timezone"]);
        }
        configuration.get("flags"] += [
            PDO.ATTR_PERSISTENT: configuration.get("persistent"],
            PDO.MYSQL_ATTR_USE_BUFFERED_QUERY: true,
            PDO.ATTR_ERRMODE: PDO.ERRMODE_EXCEPTION,
        ];

        if (!configuration.get("ssl_key"].isEmpty && !empty(configuration.get("ssl_cert"])) {
            configuration.get("flags"][PDO.MYSQL_ATTR_SSL_KEY] = configuration.get("ssl_key"];
            configuration.get("flags"][PDO.MYSQL_ATTR_SSL_CERT] = configuration.get("ssl_cert"];
        }
        if (!configuration.get("ssl_ca"].isEmpty) {
            configuration.get("flags"][PDO.MYSQL_ATTR_SSL_CA] = configuration.get("ssl_ca"];
        }

        auto dsn = configuration.get("unix_socket"].isEmpty
            ? "mysql:host={configuration.get("host"]};port={configuration.get("port"]};dbname={configuration.get("database"]}"
            : "mysql:unix_socket={configuration.get("unix_socket"]};dbname={configuration.get("database"]}";
        }
        if (!empty(configuration.get("encoding"])) {
            dsn ~= ";charset={configuration.get("encoding"]}";
        }
        this.pdo = this.createPdo(dsn, configData);

        if (!configuration.get("init"].isEmpty) {
            (array)configuration.get("init"]
                .each!(command => this.pdo.exec(command));
        }
    }
    
    // Returns whether D is able to use this driver for connecting to database
    override bool enabled() {
        return PDO.getAvailableDrivers().has("mysql");
    }
 
    SchemaDialect schemaDialect() {
        if (isSet(_schemaDialect)) {
            return _schemaDialect;
        }
        return _schemaDialect = new DMysqlSchemaDialect(this);
    }
 
    string schema() {
        return configuration.get("database"];
    }
    
    /**
     * Get the SQL for disabling foreign keys.
     * /
    string disableForeignKeySQL() {
        return "SET foreign_key_checks = 0";
    }
 
    string enableForeignKeySQL() {
        return "SET foreign_key_checks = 1";
    }
 
    bool supports(DriverFeatures feature) {
        return match (feature) {
            DriverFeatures.DISABLE_CONSTRAINT_WITHOUT_TRANSACTION,
            DriverFeatures.SAVEPOINT: true,

            DriverFeatures.TRUNCATE_WITH_CONSTRAINTS: false,

            DriverFeatures.CTE,
            DriverFeatures.IData,
            DriverFeatures.WINDOW: version_compare(
                this.currentVersion(),
                this.featureVersions[this.serverType][feature.value],
                '>='
            ),
        };
    }

   bool isMariadb() {
        this.currentVersion();

        return _serverType == SERVER_TYPE_MARIADB;
    }
    
    // Returns connected server version.
    string currentVersion() {
        if (_version is null) {
           _version = (string)this.getPdo().getAttribute(PDO.ATTR_SERVER_VERSION);

            if (_version.has("MariaDB")) {
                this.serverType = SERVER_TYPE_MARIADB;
                preg_match("/^(?:5\.5\.5-)?(\d+\.\d+\.\d+.*-MariaDB[^:]*)/", _version,  matches);
               _version = matches[1];
            }
        }
        return _version;
    } */
}
