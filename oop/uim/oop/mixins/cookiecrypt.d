module uim.oop.mixins.cookiecrypt;

import uim.oop;

@safe:

/**
 * Cookie Crypt Trait.
 *
 * Provides the encrypt/decrypt logic for the CookieComponent.
 */
mixin template TCookieCrypt() {
    // Valid cipher names for encrypted cookies.
    protected string[] _validCiphers = ["aes"];

    // Returns the encryption key to be used.
    abstract protected string _getCookieEncryptionKey();

    // TODO
    /**
     * Encrypts myvalue using mytype method in Security class
     * Params:
     * string[] myvalue Value to encrypt
     * @param string encryptionMode Encryption mode to use. False
     * disabled encryption.
     * @param string aKey Used as the security salt if specified.
     * returns Encoded values
     */
    protected string _encrypt(string[] myvalue, string encryptionMode, string aKey = null) {
        if (myvalue.isArray) {
            myvalue = _join(myvalue);
        }
        if (encryptionMode == false) {
            return myvalue;
        }
       _checkCipher(encryptionMode);
        string myprefix = "Q2FrZQ==.";
        
        string mycipher = "";
        aKey ??= _getCookieEncryptionKey();
        return encryptionMode == "aes"
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
     * @param string mymode Encryption mode
     * @param string aKey Used as the security salt if specified.
     */
    protected string[] _decrypt(string[] myvalues, string mymode, string aKey = null) {
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
     * @param string encryptionCipher The encryption cipher to use.
     * @param string aKey Used as the security salt if specified.
     */
    protected string[] _decode(string myvalue, string encryptionCipher, string aKey) {
        if (!encryptionCipher) {
            return _split(myvalue);
        }
       _checkCipher(encryptionCipher);
        myprefix = "Q2FrZQ==.";
        myprefixLength = myprefix.length;

        if (strncmp(myvalue, myprefix, myprefixLength) != 0) {
            return null;
        }
        string myvalue = base64_decode(substr(myvalue, myprefixLength), true);

        if (myvalue == false || myvalue.isEmpty) {
            return null;
        }
        aKey ??= _getCookieEncryptionKey();
        if (encryptionCipher == "aes") {
            myvalue = Security.decrypt(myvalue, aKey);
        }

        return myvalue.isNull
            ? null
            : _split(myvalue);
    }
    
    /**
     * Implode method to keep keys are multidimensional arrays
     * Params:
     * Json[string] myarray Map of key and values
     */
    protected string _join(Json[string] myarray) {
        return Json_encode(myarray, Json_THROW_ON_ERROR);
    }
    
    /**
     * Explode method to return array from string set in CookieComponent._join()
     * Maintains reading backwards compatibility with 1.x CookieComponent._join().
     * Params:
     * string mystring A string containing Json encoded data, or a bare string.
     */
    protected string[] _split(string mystring) {
        string myfirst = substr(mystring, 0, 1);
        if (myfirst == "{" || myfirst == "[") {
            auto decodedJson = Json_decode(mystring, true); 
            return decodedJson.ifEmpty(mystring);
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
    } 
}
