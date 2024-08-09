import 'package:intl/intl.dart';

abstract class FieldTransformer {
  dynamic viewToModel(dynamic value) {
    throw UnimplementedError();
  }

  dynamic modelToView(dynamic value) {
    throw UnimplementedError();
  }
}

class IntTransformer implements FieldTransformer {
  IntTransformer._();
  static final transfomer = IntTransformer._();

  @override
  int? viewToModel(dynamic value) {
    if (value is String) {
      return value.isEmpty ? null : int.tryParse(value);
    }
    return value;
  }

  @override
  modelToView(value) {
    throw UnimplementedError();
  }
}

class DoubleTransformer implements FieldTransformer {
  DoubleTransformer._();
  static final transfomer = DoubleTransformer._();

  @override
  double? viewToModel(dynamic value) {
    if (value is String) {
      return value.isEmpty ? null : double.tryParse(value);
    }
    return value;
  }

  @override
  modelToView(value) {
    throw UnimplementedError();
  }
}

class DateTransaformer implements FieldTransformer {
  DateTransaformer._();
  static final transfomer = DateTransaformer._();

  @override
  DateTime? modelToView(value) {
    try {
      DateTime dateTime = DateFormat("dd/MM/yy").parse(value);
      return dateTime;
    } catch (e) {
      return null;
    }
  }

  @override
  String? viewToModel(value) {
    if (value != null && value is DateTime) {
      return DateFormat('dd/MM/yy').format(value);
    }
    return value;
  }
}

class MultiSelectTransformer implements FieldTransformer {
  MultiSelectTransformer._();
  static final transfomer = MultiSelectTransformer._();

  @override
  modelToView(value) {
    final values = value as List<dynamic>;
    return values.map((e) => e as String).toList();
  }

  @override
  viewToModel(value) {
    return value as List<String?>;
  }
}
