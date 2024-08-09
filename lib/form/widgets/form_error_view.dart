import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reflective_forms/form/app_form_group.dart';

class FormErrorWidget extends StatefulWidget {
  final EdgeInsets? margin;
  const FormErrorWidget({
    super.key,
    this.margin,
  });

  @override
  State<FormErrorWidget> createState() => _FormErrorWidgetState();
}

class _FormErrorWidgetState extends State<FormErrorWidget> {
  late AppFormGroup form;

  @override
  void didChangeDependencies() {
    form = ReactiveForm.of(context) as AppFormGroup;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: form.errorStream,
      builder: (context, snapshot) {
        return Visibility(
          visible: snapshot.hasData && snapshot.data!.isNotEmpty,
          replacement: const SizedBox.shrink(),
          child: Container(
            alignment: Alignment.centerLeft,
            margin: widget.margin ?? const EdgeInsets.only(top: 8, left: 8, right: 8),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              snapshot.data!,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        );
      },
    );
  }
}
