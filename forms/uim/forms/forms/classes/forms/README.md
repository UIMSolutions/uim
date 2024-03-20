[![Total Downloads](https://img.shields.io/packagist/dt/UIM/form.svg?style=flat-square)](https://packagist.org/packages/UIM/form)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](LICENSE.txt)

# UIM Form Library

Form abstraction used to create forms not tied to ORM backed models,
or to other permanent datastores. Ideal for implementing forms on top of
API services, or contact forms.

## Usage


```php
use UIM\Form\Form;
use UIM\Form\Schema;
use UIM\Validation\Validator;

class ContactForm : Form
{

    protected auto _buildSchema(Schema schema) {
        return schema.addField("name", "string")
            .addField("email", ["type": `string"])
            .addField("body", ["type": 'text"]);
    }

    auto validationDefault(Validator validator) {
        return validator.add("name", "length", [
                'rule": ["minLength", 10],
                'message": 'A name is required'
            ]).add("email", "format", [
                'rule": 'email",
                'message": 'A valid email address is required",
            ]);
    }

    protected auto _execute(array data) {
        // Send an email.
        return true;
    }
}
```

In the above example we see the 3 hook methods that forms provide:

- `_buildSchema()` is used to define the schema data. You can define field type, length, and precision.
- `validationDefault()` Gets a `UIM\Validation\Validator` instance that you can attach validators to.
- `_execute()` lets you define the behavior you want to happen when `execute()` is called and the data is valid.

You can always define additional methods as you need as well.

```php
contact = new ContactForm();
success = contact.execute(someData);
errors = contact.getErrors();
```

## Documentation

Please make sure you check the [official documentation](https://book.UIM.org/5/en/core-libraries/form.html)
