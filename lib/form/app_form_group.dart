import 'dart:async';

import 'package:reactive_forms/reactive_forms.dart';
import 'package:reflective_forms/form/utils/common_transformers.dart';
import 'package:reflective_forms/form/utils/common_validators.dart';

class AppFormGroup extends FormGroup {
  AppFormGroup(super.controls);

  Map<String, Map<FieldValidator, String>>? _validationMap;
  Map<String, Map<FieldValidator, String>> getValidationMap() {
    return {};
  }

  Map<String, FieldTransformer>? _transfomerMap;
  Map<String, FieldTransformer> getTransformerMap() {
    return {};
  }

  final StreamController<String> _controller = StreamController.broadcast();

  Stream<String> get errorStream => _controller.stream;

  void pushError(String message) {
    _controller.add(message);
  }

  bool isRequired(String field) => true;
  bool has(String field) => contains(field);

  dynamic getValue(String field) => control(field).value;
  int? getInt(String field) => getValue(field) as int?;
  String? getString(String field) => getValue(field) as String?;
  bool? getBool(String field) => getValue(field) as bool?;
  double? getDouble(String field) => getValue(field) as double?;

  void setInitialValues(Map<String, dynamic> values) {
    controls.forEach((key, value) {
      final mapValue = values[key];
      final hasValue = mapValue != null && mapValue != "";
      if (value is AppFormGroup) {
        if (hasValue) {
          value.setInitialValues(values[key]);
        }
      } else {
        if (hasValue) {
          final transformer = getTransformer(key);
          final transformedValue = transformer == null ? mapValue : transformer.modelToView(mapValue);
          values[key] = transformedValue;
        } else {
          values[key] = value.value;
        }
      }
    });
    value = values;
  }

  Map<String, dynamic> getJson() {
    final map = <String, dynamic>{};
    controls.forEach((key, value) {
      if (isRequired(key)) {
        if (value is AppFormGroup) {
          map[key] = value.getJson();
        } else {
          final keyValue = getValue(key);
          final transformer = getTransformer(key);
          if (keyValue != null) {
            final transformedValue = transformer == null ? keyValue : transformer.viewToModel(keyValue);
            map[key] = transformedValue;
          } else {
            map[key] = "";
          }
        }
      }
    });
    return map;
  }

  FieldTransformer? getTransformer(String field) {
    _transfomerMap ??= getTransformerMap();
    final map = _transfomerMap;
    if (map != null) {
      return map[field];
    }
    return null;
  }

  void setValue(String field, dynamic value) {
    control(field).value = value;
  }

  bool isValid() {
    final error = formErrorMessage();
    pushError(error ?? "");
    return error == null;
  }

  String? formErrorMessage() {
    _validationMap ??= getValidationMap();
    final map = _validationMap;
    if (map != null) {
      for (var fieldVsValidationMap in map.entries) {
        final field = fieldVsValidationMap.key;
        final validators = fieldVsValidationMap.value;
        if (isRequired(field)) {
          final fieldValue = getValue(field);
          for (var validator in validators.entries) {
            final rule = validator.key;
            if (!rule.validate(fieldValue)) {
              return validator.value;
            }
          }
        }
      }
    }
    return null;
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
