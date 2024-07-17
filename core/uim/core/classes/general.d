module uim.core.classes.general;

@safe:

V Null(V:Object)(){
	return null; 
}

T ifNull(T:Object)(T value, T defaultValue = null) {
  return value !is null ? value : defaultValue;
}

unittest {
  @safe class Test {
    this() {}
    this(int aValue) {
      _value = aValue;
    }
    int _value;
    int value() { return _value; }
  }

  Test withObject = new Test(1);
  Test nullObject;

  assert(withObject.ifNull(new Test(2)).value == 1);
  assert(nullObject.ifNull(new Test(3)).value == 3);
}