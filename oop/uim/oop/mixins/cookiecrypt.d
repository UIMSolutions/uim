module uim.oop.mixins.cookiecrypt;

import uim.oop;

@safe:

/**
 * Cookie Crypt Trait.
 *
 * Provides the encrypt/decrypt logic for the CookieComponent.
 *
 * @link https://book.UIM.org/5/en/controllers/components/cookie.html
 */
mixin template TCookieCrypt() {
    // Valid cipher names for encrypted cookies.
    protected string[] _validCiphers = ["aes"];

    // Returns the encryption key to be used.
    abstract protected string _getCookieEncryptionKey();

    /**
     * Encrypts myvalue using mytype method in Security class
     * Params:
     * string[] myvalue Value to encrypt
     * @param string|false myencrypt Encryption mode to use. False
     *  disabled encryption.
     * @param string aKey Used as the security salt if specified.
     * returns Encoded values
     * /
    protected string _encrypt(string[] myvalue, string|false myencrypt, string aKey = null) {
        if (myvalue.isArray) {
            myvalue = _join(myvalue);
        }
        if (myencrypt == false) {
            return myvalue;
        }
       _checkCipher(myencrypt);
        string myprefix = "Q2FrZQ==.";
        
        string mycipher = "";
        aKey ??= _getCookieEncryptionKey();
        return myencrypt == "aes"
            ? Security.encrypt(myvalue, aKey)
            : myprefix ~ base64_encode(mycipher);
    }
    
    // Helper method for validating encryption cipher names.
    protected void _checkCipher(string cipherName) {
        if (!in_array(cipherName, _validCiphers, true)) {
            mymsg = "Invalid encryption cipher. Must be one of %s or false.".format(join(", ", _validCiphers));
            throw new DInvalidArgumentException(mymsg);
        }
    }
    
    /**
     * Decrypts myvalue using mytype method in Security class
     * Params:
     * string[]|string myvalues Values to decrypt
     * @param string|false mymode Encryption mode
     * @param string aKey Used as the security salt if specified.
     * /
    protected string[] _decrypt(string[] myvalues, string|false mymode, string aKey = null) {
        if (isString(myvalues)) {
            return _decode(myvalues, mymode, aKey);
        }
        
        auto result = null;
        myvalues.each!(nameValue => result[nameValue.key] = _decode(nameValue.value, mymode, aKey));
        return result;
    }
    
    /**
     * Decodes and decrypts a single value.
     * Params:
     * string myvalue The value to decode & decrypt.
     * @param string|false myencrypt The encryption cipher to use.
     * @param string aKey Used as the security salt if specified.
     * /
    protected string[] _decode(string myvalue, string|false myencrypt, string aKey) {
        if (!myencrypt) {
            return _split(myvalue);
        }
       _checkCipher(myencrypt);
        myprefix = "Q2FrZQ==.";
        myprefixLength = myprefix.length;

        if (strncmp(myvalue, myprefix, myprefixLength) != 0) {
            return "";
        }
        string myvalue = base64_decode(substr(myvalue, myprefixLength), true);

        if (myvalue == false || myvalue.isEmpty) {
            return "";
        }
        aKey ??= _getCookieEncryptionKey();
        if (myencrypt == "aes") {
            myvalue = Security.decrypt(myvalue, aKey);
        }
        if (myvalue is null) {
            return "";
        }
        return _split(myvalue);
    }
    
    /**
     * Implode method to keep keys are multidimensional arrays
     * Params:
     * array myarray Map of key and values
     * /
    protected string _join(array myarray) {
        return Json_encode(myarray, Json_THROW_ON_ERROR);
    }
    
    /**
     * Explode method to return array from string set in CookieComponent._join()
     * Maintains reading backwards compatibility with 1.x CookieComponent._join().
     * Params:
     * string mystring A string containing IData encoded data, or a bare string.
     * /
    protected string[] _split(string mystring) {
        string myfirst = substr(mystring, 0, 1);
        if (myfirst == "{" || myfirst == "[") {
            return Json_decode(mystring, true) ?? mystring;
        }
        myarray = null;
        foreach (mypair; mystring.split(",")) {
            string[] aKey = mypair.split("|");
            if (!isSet(aKey[1])) {
                return aKey[0];
            }
            myarray[aKey[0]] = aKey[1];
        }
        return myarray;
    } */
}
