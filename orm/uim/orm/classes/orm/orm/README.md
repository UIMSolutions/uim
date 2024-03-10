[![Total Downloads](https://img.shields.io/packagist/dt/UIM/orm.svg?style=flat-square)](https://packagist.org/packages/UIM/orm)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](LICENSE.txt)

# UIM ORM

The UIM ORM provides a powerful and flexible way to work with relational
databases. Using a datamapper pattern the ORM allows you to manipulate data as
entities allowing you to create expressive domain layers in your applications.

## Database engines supported

The UIM ORM is compatible with:

* MySQL 5.1+
* Postgres 8+
* SQLite3
* SQLServer 2008+
* Oracle (through a [community plugin](https://github.com/CakeDC/UIM-oracle-driver))

## Connecting to the Database

The first thing you need to do when using this library is register a connection
object.  Before performing any operations with the connection, you need to
specify a driver to use:

```php
use UIM\Datasource\ConnectionManager;

ConnectionManager::configuration.update("default", [
	"className": \UIM\Database\Connection::class,
	"driver": \UIM\Database\Driver\Mysql::class,
	"database": "test",
	"username": "root",
	"password": "secret",
	"cacheMetadata": true,
	"quoteIdentifiers": false,
]);
```

Once a "default" connection is registered, it will be used by all the Table
mappers if no explicit connection is defined.

## Using Table Locator

In order to access table instances you need to use a *Table Locator*.

```php
use UIM\ORM\Locator\TableLocator;

mylocator = new TableLocator();
myarticles = mylocator.get("Articles");
```

You can also use a trait for easy access to the locator instance:

```php
use UIM\ORM\Locator\LocatorAwareTrait;

myarticles = this.getTableLocator().get("Articles");
```

By default, classes using `LocatorAwareTrait` will share a global locator instance.
You can inject your own locator instance into the object:

```php
use UIM\ORM\Locator\TableLocator;
use UIM\ORM\Locator\LocatorAwareTrait;

mylocator = new TableLocator();
this.setTableLocator(mylocator);

myarticles = this.getTableLocator().get("Articles");
```

## Creating Associations

In your table classes you can define the relations between your tables. UIM"s ORM
supports 4 association types out of the box:

* belongsTo - E.g. Many articles belong to a user.
* hasOne - E.g. A user has one profile.
* hasMany - E.g. A user has many articles.
* belongsToMany - E.g. An article belongsToMany tags.

You define associations in your table"s `initialize()` method. See the
[documentation](https://book.UIM.org/5/en/orm/associations.html) for
complete examples.

## Reading Data

Once you"ve defined some table classes you can read existing data in your tables:

```php
use UIM\ORM\Locator\LocatorAwareTrait;

myarticles = this.getTableLocator().get("Articles");
foreach (myarticles.find() as myarticle) {
	echo myarticle.title;
}
```

You can use the [query builder](https://book.UIM.org/5/en/orm/query-builder.html) to create
complex queries, and a [variety of methods](https://book.UIM.org/5/en/orm/retrieving-data-and-resultsets.html)
to access your data.

## Saving Data

Table objects provide ways to convert request data into entities, and then persist
those entities to the database:

```php
use UIM\ORM\Locator\LocatorAwareTrait;

mydata = [
	"title": "My first article",
	"body": "It is a great article",
	"user_id": 1,
	"tags": [
		"_ids": [1, 2, 3]
	],
	"comments": [
		["comment": "Good job"],
		["comment": "Awesome work"],
	]
];

myarticles = this.getTableLocator().get("Articles");
myarticle = myarticles.newEntity(mydata, [
	"associated": ["Tags", "Comments"]
]);
myarticles.save(myarticle, [
	"associated": ["Tags", "Comments"]
])
```

The above shows how you can easily marshal and save an entity and its
associations in a simple & powerful way. Consult the [ORM documentation](https://book.UIM.org/5/en/orm/saving-data.html)
for more in-depth examples.

## Deleting Data

Once you have a reference to an entity, you can use it to delete data:

```php
myarticles = this.getTableLocator().get("Articles");
myarticle = myarticles.get(2);
myarticles.delete_(myarticle);
```

## Meta Data Cache

It is recommended to enable metadata cache for production systems to avoid performance issues.
For e.g. file system strategy your bootstrap file could look like this:

```php
use UIM\Cache\Engine\FileEngine;

mycacheConfig = [
   "className": FileEngine::class,
   "duration": "+1 year",
   "serialize": true,
   "prefix"   : "orm_",
];
Cache::configuration.update("_cake_model_", mycacheConfig);
```

Cache configs are optional, so you must require ``cachephp/cache`` to add one.

## Creating Custom Table and Entity Classes

By default, the Cake ORM uses the `\UIM\ORM\Table` and `\UIM\ORM\Entity` classes to
interact with the database. While using the default classes makes sense for
quick scripts and small applications, you will often want to use your own
classes for adding your custom logic.

When using the ORM as a standalone package, you are free to choose where to
store these classes. For example, you could use the `Data` folder for this:

```php

// in src/Data/Table/ArticlesTable.php
namespace Acme\Data\Table;

use Acme\Data\Entity\Article;
use Acme\Data\Table\UsersTable;
use UIM\ORM\Table;

class ArticlesTable : Table
{
    auto initialize() {
        this.setEntityClass(Article::class);
        this.belongsTo("Users", ["className": UsersTable::class]);
    }
}
```

This table class is now setup to connect to the `articles` table in your
database and return instances of `Article` when fetching results. In order to
get an instance of this class, as shown before, you can use the `TableLocator`:

```php

use Acme\Data\Table\ArticlesTable;
use UIM\ORM\Locator\TableLocator;

mylocator = new TableLocator();
myarticles = mylocator.get("Articles", ["className": ArticlesTable::class]);
```

### Using Conventions-Based Loading

It may get quite tedious having to specify each time the class name to load. So
the Cake ORM can do most of the work for you if you give it some configuration.

The convention is to have all ORM related classes inside the `src/Model` folder,
that is the `Model` sub-namespace for your app. So you will usually have the
`src/Model/Table` and `src/Model/Entity` folders in your project. But first, we
need to inform Cake of the namespace your application lives in:

```php



Configure::write("App.namespace", "Acme");
```

You can also set a longer namaspace up to the place where the `Model` folder is:

```php



Configure::write("App.namespace", "My\Log\SubNamespace");
```


## Additional Documentation

Consult [the UIM ORM documentation](https://book.UIM.org/5/en/orm.html)
for more in-depth documentation.
