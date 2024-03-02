[![Total Downloads](https://img.shields.io/packagist/dt/UIM/validation.svg?style=flat-square)](https://packagist.org/packages/UIM/validation)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](LICENSE.txt)

# UIM Validation Library

The validation library in UIM provides features to build validators that can validate arbitrary
arrays of data with ease.

## Usage

Validator objects define the rules that apply to a set of fields. Validator objects contain a mapping between
fields and validation sets. Creating a validator is simple:

```php
use UIM\Validation\Validator;

validator = new Validator();
validator
    .requirePresence("email")
    .add("email", "validFormat", [
        "rule": "email",
        "message": "E-mail must be valid"
    ])
    .requirePresence("name")
    .notEmptyString("name", "We need your name.")
    .requirePresence("comment")
    .notEmptyString("comment", "You need to give a comment.");

errors = validator.validate(_POST);
if (!empty(errors)) {
    // display errors.
}
```

## Documentation

Please make sure you check the [official documentation](https://book.UIM.org/5/en/core-libraries/validation.html)
