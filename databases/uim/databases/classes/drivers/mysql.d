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
		if (!super.initialize(initData)) { return false; }
		
            // Base configuration settings for MySQL driver
        /* _baseConfig.data([
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
            ]); */
    
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

        if (configuration["timezone"] == "UTC") {
            configuration["timezone"] = "+0:00";
        }
        if (!(configuration["timezone"].isEmpty) {
            configuration["init"] ~= "SET time_zone = '%s'".format(configuration["timezone"]);
        }
        configuration["flags"] += [
            PDO.ATTR_PERSISTENT: configuration["persistent"],
            PDO.MYSQL_ATTR_USE_BUFFERED_QUERY: true,
            PDO.ATTR_ERRMODE: PDO.ERRMODE_EXCEPTION,
        ];

        if (!configuration["ssl_key"].isEmpty && !empty(configuration["ssl_cert"])) {
            configuration["flags"][PDO.MYSQL_ATTR_SSL_KEY] = configuration["ssl_key"];
            configuration["flags"][PDO.MYSQL_ATTR_SSL_CERT] = configuration["ssl_cert"];
        }
        if (!configuration["ssl_ca"].isEmpty) {
            configuration["flags"][PDO.MYSQL_ATTR_SSL_CA] = configuration["ssl_ca"];
        }

        auto dsn = configuration["unix_socket"].isEmpty
            ? "mysql:host={configuration["host"]};port={configuration["port"]};dbname={configuration["database"]}"
            : "mysql:unix_socket={configuration["unix_socket"]};dbname={configuration["database"]}";
        }
        if (!empty(configuration["encoding"])) {
            dsn ~= ";charset={configuration["encoding"]}";
        }
        this.pdo = this.createPdo(dsn, configData);

        if (!configuration["init"].isEmpty) {
            (array)configuration["init"]
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
        return _schemaDialect = new MysqlSchemaDialect(this);
    }
 
    string schema() {
        return configuration["database"];
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

        return this.serverType == SERVER_TYPE_MARIADB;
    }
    
    // Returns connected server version.
    string currentVersion() {
        if (_version.isNull) {
           _version = (string)this.getPdo().getAttribute(PDO.ATTR_SERVER_VERSION);

            if (_version.has("MariaDB")) {
                this.serverType = SERVER_TYPE_MARIADB;
                preg_match("/^(?:5\.5\.5-)?(\d+\.\d+\.\d+.*-MariaDB[^:]*)/", _version,  matches);
               _version =  matches[1];
            }
        }
        return _version;
    } */
}