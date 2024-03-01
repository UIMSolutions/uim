module uim.databases.classes.drivers.mysql;

import uim.databases;

@safe:

class DMysqlDriver : DDriver {
    mixin(DriverThis!("Mysql"));

    override bool initialize(IConfigData[string] configData = null) {
		if (!super.initialize(configData)) { return false; }
		
            // Base configuration settings for MySQL driver
        _baseConfig.data([
                "persistent": BoolData(true),
                "host": StringData("localhost"),
                "username": StringData("root"),
                "password": StringData(""),
                "database": StringData("uim"),
                "port": StringData("3306"),
                "flags": ArrayData,
                "encoding": StringData("utf8mb4"),
                "timezone": NullData(null),
                "init": ArrayData,
            ]);
    
        _startQuote = "`";
        _endQuote = "`";

		return true;
	}
 

    protected const MAX_ALIAS_LENGTH = 256;

    // Server type MySQL
    protected const string SERVER_TYPE_MYSQL = "mysql";

    // Server type MariaDB
    protected const string SERVER_TYPE_MARIADB = "mariadb";



    /**
     * Server type.
     *
     * If the underlying server is MariaDB, its value will get set to `'mariadb'`
     * after `currentVersion()` method is called.
     */
    protected string serverType = SERVER_TYPE_MYSQL;

    // Mapping of feature to db server version for feature availability checks.
    protected Json _featureVersions = [
        "mysql": [
            "json": "5.7.0",
            "cte": "8.0.0",
            "window": "8.0.0",
        ],
        "mariadb": [
            "json": "10.2.7",
            "cte": "10.2.1",
            "window": "10.2.0",
        ],
    ];

 
    void connect() {
        if (this.pdo.isSet) {
            return;
        }
        auto configData = _config;

        if (configData["timezone"] == "UTC") {
            configData["timezone"] = "+0:00";
        }
        if (!(configData["timezone"].isEmpty) {
            configData["init"] ~= "SET time_zone = '%s'".format(configData["timezone"]);
        }
        configData["flags"] += [
            PDO.ATTR_PERSISTENT: configData["persistent"],
            PDO.MYSQL_ATTR_USE_BUFFERED_QUERY: true,
            PDO.ATTR_ERRMODE: PDO.ERRMODE_EXCEPTION,
        ];

        if (!empty(configData["ssl_key"]) && !empty(configData["ssl_cert"])) {
            configData["flags"][PDO.MYSQL_ATTR_SSL_KEY] = configData["ssl_key"];
            configData["flags"][PDO.MYSQL_ATTR_SSL_CERT] = configData["ssl_cert"];
        }
        if (!empty(configData["ssl_ca"])) {
            configData["flags"][PDO.MYSQL_ATTR_SSL_CA] = configData["ssl_ca"];
        }

        auto dsn = configData["unix_socket"].isEmpty
            ? "mysql:host={configData["host"]};port={configData["port"]};dbname={configData["database"]}"
            : "mysql:unix_socket={configData["unix_socket"]};dbname={configData["database"]}";
        }
        if (!empty(configData["encoding"])) {
            dsn ~= ";charset={configData["encoding"]}";
        }
        this.pdo = this.createPdo(dsn, configData);

        if (!configData["init"].isEmpty) {
            (array)configData["init"]
                .each!($command => this.pdo.exec($command));
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
        return _schemaDialect = new MysqlSchemaDialect(this);
    }
 
    string schema() {
        return _config["database"];
    }
    
    /**
     * Get the SQL for disabling foreign keys.
     */
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
            DriverFeatures.JSON,
            DriverFeatures.WINDOW: version_compare(
                this.currentVersion(),
                this.featureVersions[this.serverType][feature.value],
                '>='
            ),
        };
    }

   bool isMariadb() {
        this.currentVersion();

        return this.serverType == SERVER_TYPE_MARIADB;
    }
    
    // Returns connected server version.
    string currentVersion() {
        if (_version.isNull) {
           _version = (string)this.getPdo().getAttribute(PDO.ATTR_SERVER_VERSION);

            if (_version.has("MariaDB")) {
                this.serverType = SERVER_TYPE_MARIADB;
                preg_match("/^(?:5\.5\.5-)?(\d+\.\d+\.\d+.*-MariaDB[^:]*)/", _version, $matches);
               _version = $matches[1];
            }
        }
        return _version;
    }
}
