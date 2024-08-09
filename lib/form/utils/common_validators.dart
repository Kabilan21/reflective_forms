abstract class FieldValidator {
  bool validate(Object? value) {
    throw UnimplementedError();
  }
}

class Required implements FieldValidator {
  Required._();
  static final validator = Required._();

  @override
  bool validate(Object? value) {
    if (value != null) {
      if (value is List) {
        return value.isNotEmpty;
      } else {
        return value.toString().isNotEmpty;
      }
    }
    return false;
  }
}

class IntValue implements FieldValidator {
  final int minValue;

  IntValue({required this.minValue});
  static final cannotBeZeroValidator = IntValue(minValue: 0);

  @override
  bool validate(Object? value) {
    if (value != null && value is int && value > minValue) {
      return true;
    }
    return false;
  }
}

class DoubleValue implements FieldValidator {
  final double minValue;

  DoubleValue({required this.minValue});
  static final cannotBeZeroValidator = DoubleValue(minValue: 0);

  @override
  bool validate(Object? value) {
    if (value != null && value is double && value > minValue) {
      return true;
    }
    return false;
  }
}
