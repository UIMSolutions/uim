/****************************************************************************************************************
* Copyright: © 2018-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.mixins.data;

import uim.oop;
@safe:

/* template `~returnType~`SetData(`~returnType~`) {
    //#region set
/*     `~returnType~` set(S`~returnType~`RINGAA data, string[] keys) {
        Json[string] map;
        keys
            .filter!(key => key in data)
            .each!(key => map[key] = Json(data[key]));

        return set(map);
    }

    `~returnType~` set(Json[string] data, string[] keys = null) {
        keys.isNull
            ? keys.each!(key => set(key, newData[key])) 
            : keys.filter!(key => key in newData)
            .each!(key => set(key, newData[key]));

        return this;
    }  

           //#endregion set
}*/

template ISetDataMulti(string returnType) {
    const char[] ISetDataMulti = `
        `~returnType~` set(string[] keys, bool value);
        `~returnType~` set(string[] keys, long value);
        `~returnType~` set(string[] keys, double value);
        `~returnType~` set(string[] keys, string value);
        `~returnType~` set(string[] keys, Json value);
        `~returnType~` set(string[] keys, Json[] value);
        `~returnType~` set(string[] keys, Json[string] value);`;
}
template ISetDataSingle(string returnType) {
    const char[] ISetDataSingle = `
        `~returnType~` set(string key, bool value);
        `~returnType~` set(string key, long value);
        `~returnType~` set(string key, double value);
        `~returnType~` set(string key, string value);
        `~returnType~` set(string key, Json value);
        `~returnType~` set(string key, Json[] value);
        `~returnType~` set(string key, Json[string] value);`;
}

template DataIndexAssign() {
    const char[] DataIndexAssign = `
        void opIndexAssign(bool value, string key) {
            set(key, value);
        }

        void opIndexAssign(long value, string key) {
            set(key, value);
        }

        void opIndexAssign(double value, string key) {
            set(key, value);
        }

        void opIndexAssign(string value, string key) {
            set(key, value);
        }

        void opIndexAssign(Json value, string key) {
            set(key, value);
        }

        void opIndexAssign(Json[] value, string key) {
            set(key, value);
        }

        void opIndexAssign(Json[string] value, string key) {
            set(key, value);
        }
    `; 
}
template SetDataMulti(string returnType) {
    const char[] SetDataMulti = `
            `~returnType~` set(string[] keys, bool value) {
            keys.each!(key => set(key, value));
            return this;
        }

        `~returnType~` set(string[] keys, long value) {
            keys.each!(key => set(key, value));
            return this;
        }

        `~returnType~` set(string[] keys, double value) {
            keys.each!(key => set(key, value));
            return this;
        }

        `~returnType~` set(string[] keys, string value) {
            keys.each!(key => set(key, value));
            return this;
        }

        `~returnType~` set(string[] keys, Json value) {
            keys.each!(key => set(key, value));
            return this;
        }

        `~returnType~` set(string[] keys, Json[] value) {
            keys.each!(key => set(key, value));
            return this;
        }

        `~returnType~` set(string[] keys, Json[string] value) {
            keys.each!(key => set(key, value));
            return this;
        }`;
}
template SetDataSingle(string returnType) {
    const char[] SetDataSingle = `
        `~returnType~` set(string key, bool value) {
            return set(key, Json(value));
        }

        `~returnType~` set(string key, long value) {
            return set(key, Json(value));
        }

        `~returnType~` set(string key, double value) {
            return set(key, Json(value));
        }

        `~returnType~` set(string key, string value) {
            return set(key, Json(value));
        }
    `;
}