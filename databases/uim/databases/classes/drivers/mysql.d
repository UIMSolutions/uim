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

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        // Base configuration settings for MySQL driver
        configuration.merge([
            "persistent": true.toJson,
            "host": Json("localhost"),
            "username": Json("root"),
            "password": "".toJson,
            "database": Json("uim"),
            "port": Json("3306"),
            "flags": Json.emptyArray,
            "encoding": Json("utf8mb4"),
            "timezone": Json(null),
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
     */
    protected string _serverType = SERVER_TYPE_MYSQL;

    // Mapping of feature to db server version for feature availability checks.
    protected Json _featureVersions = [
        "mysql": [
            "Json": "5.7.0",
            "cte": "8.0.0",
            "window": "8.0.0",
        ],
        "mariadb": [
            "Json": "10.2.7",
            "cte": "10.2.1",
            "window": "10.2.0",
        ],
    ];

 
    void connect() {
        if (_pdo.isSet) {
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

        if (!configuration.get("ssl_key"].isEmpty && !configuration.isEmpty("ssl_cert"])) {
            configuration.get("flags"][PDO.MYSQL_ATTR_SSL_KEY] = configuration.get("ssl_key"];
            configuration.get("flags"][PDO.MYSQL_ATTR_SSL_CERT] = configuration.get("ssl_cert"];
        }
        if (!configuration.isEmpty("ssl_ca")) {
            configuration.get("flags"][PDO.MYSQL_ATTR_SSL_CA] = configuration.get("ssl_ca"];
        }

        auto dsn = configuration.isEmpty("unix_socket")
            ? "mysql:host={configuration.get("host"]};port={configuration.get("port"]};dbname={configuration.get("database"]}"
            : "mysql:unix_socket={configuration.get("unix_socket"]};dbname={configuration.get("database"]}";
        }
        if (!configuration.isEmpty("encoding")) {
            dsn ~= ";charset={configuration.get("encoding"]}";
        }
        this.pdo = this.createPdo(dsn, configData);

        if (!configuration.isEmpty("init")) {
            /* (array) */configuration.get("init")
              .each!(command => _pdo.exec(command));
        }
    }
    
    // Returns whether D is able to use this driver for connecting to database
    override bool enabled() {
        return PDO.availableDrivers().has("mysql");
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
    
    // Get the SQL for disabling foreign keys.
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
            DriverFeatures.Json,
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
        if (_version.isNull) {
           _version = (string)getPdo().getAttribute(PDO.ATTR_SERVER_VERSION);

            if (_version.has("MariaDB")) {
                _serverType = SERVER_TYPE_MARIADB;
                preg_match("/^(?:5\.5\.5-)?(\d+\.\d+\.\d+.*-MariaDB[^:]*)/", _version,  matches);
               _version = matches[1];
            }
        }
        return _version;
    } 
}
