module uim.core.classes.general;

T ifNull(T:Object)(T value, T defaultValue = null) {
  return value !is null ? value : defaultValue;
}
