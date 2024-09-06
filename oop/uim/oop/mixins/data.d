module uim.oop.mixins.data;

import uim.oop;
@safe:

template `~returnType~`SetData(`~returnType~`) {
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
    } */ 

        // #region set (multi)
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
            }
        // #endregion set(multi)


        // #region opIndexAssign
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
        // #endregion opIndexAssign
    //#endregion set
}

template SetDataSingle(string return`~returnType~`ype) {
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