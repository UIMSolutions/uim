[![Total Downloads](https://img.shields.io/packagist/dt/UIM/collection.svg?style=flat-square)](https://packagist.org/packages/UIM/collection)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](LICENSE.txt)

# UIM Collection Library

The collection classes provide a set of tools to manipulate arrays or Traversable objects.
If you have ever used underscore.js, you have an idea of what you can expect from the collection classes.

## Usage

Collections can be created using an array or Traversable object.  A simple use of a Collection would be:

```php


 someItems = ["a": 1, "b": 2, "c": 3];
$collection = new Collection(someItems);

// Create a new collection containing elements
// with a value greater than one.
$overOne = $collection.filter(function (aValue, aKey,  anIterator) {
    return aValue > 1;
});
```

The `Collection\CollectionTrait` allows you to integrate collection-like features into any Traversable object
you have in your application as well.

## Documentation

Please make sure you check the [official documentation](https://book.UIM.org/5/en/core-libraries/collections.html)
