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
     * Encrypts valueToEncrypt using mytype method in Security class
     * Params:
     * string[] valueToEncrypt Value to encrypt
     * @param string key Used as the security salt if specified.
     * returns Encoded values
     */
    protected string _encrypt(string[] valueToEncrypt, string encryptionMode, string securitySalt = null) {
        if (valueToEncrypt.isArray) {
            valueToEncrypt = _join(valueToEncrypt);
        }
        if (encryptionMode.isEmpty) {
            return valueToEncrypt;
        }

        _checkCipher(encryptionMode);
        string myprefix = "Q2FrZQ==.";
        string mycipher = "";
        string encryptionKey = securitySalt.ifEmpty(_getCookieEncryptionKey());
        return encryptionMode == "aes"
            ? Security.encrypt(valueToEncrypt, encryptionKey) 
            : myprefix ~ base64_encode(mycipher);
    }

    // Helper method for validating encryption cipher names.
    protected void _checkCipher(string cipherName) {
        if (!isIn(cipherName, _validCiphers, true)) {
            mymsg = "Invalid encryption cipher. Must be one of %s or false.".format(join(", ", _validCiphers));
            throw new DInvalidArgumentException(mymsg);
        }
    }

    // Decrypts myvalue using mytype method in Security class
    protected string[] _decrypt(string[] valuesToDecrypt, string decryptMode, string decryptKey = null) {
        string[] results = null;
        valuesToDecrypt.each!(nameValue => result[nameValue.key] = _decode(nameValue.value, decryptMode, decryptKey));
        return result;
    }

    protected string[] _decrypt(string valueToDecrypt, string decryptMode, string decryptKey = null) {
        return _decode(valueToDecrypt, decryptMode, decryptKey);
    }

    /**
     * Decodes and decrypts a single value.
     * Params:
     * string myvalue The value to decode & decrypt.
     * @param string encryptionCipher The encryption cipher to use.
     * @param string securitySalt Used as the security salt if specified.
     */
    protected string[] _decode(string valueToDecode, string encryptionCipher, string securitySalt) {
        if (!encryptionCipher) {
            return _split(valueToDecode);
        }

        _checkCipher(encryptionCipher);
        
        string myprefix = "Q2FrZQ==.";
        myprefixLength = myprefix.length;

        if (strncmp(valueToDecode, myprefix, myprefixLength) != 0) {
            return null;
        }

        string valueToDecode = base64_decode(subString(valueToDecode, myprefixLength), true);
        if (valueToDecode == false || valueToDecode.isEmpty) {
            return null;
        }

        securitySalt = securitySalt.isEmpty(_getCookieEncryptionKey());
        if (encryptionCipher == "aes") {
            valueToDecode = Security.decrypt(valueToDecode, securitySalt);
        }

        return valueToDecode.isNull
            ? null : _split(valueToDecode);
    }

    // Implode method to keep keys are multidimensional arrays
    protected string _join(Json[string] data) {
        return Json_encode(data, Json_THROW_ON_ERROR);
    }

    /**
     * Explode method to return array from string set in CookieComponent._join()
     * Maintains reading backwards compatibility with 1.x CookieComponent._join().
     * string mystring A string containing Json encoded data, or a bare string.
     */
    protected string[] _split(string mystring) {
        string myfirst = subString(mystring, 0, 1);
        if (myfirst == "{" || myfirst == "[") {
            auto decodedJson = Json_decode(mystring, true);
            return decodedJson.ifEmpty(mystring);
        }
        
        auto myarray = null;
        foreach (mypair; mystring.split(",")) {
            string[] key = mypair.split("|");
            if (key.isNull(1)) {
                return key[0];
            }
            myarray[key[0]] = key[1];
        }
        return myarray;
    }
}
