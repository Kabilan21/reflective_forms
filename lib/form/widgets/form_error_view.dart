import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reflective_forms/form/app_form_group.dart';

class FormErrorText extends StatefulWidget {
  final EdgeInsets? margin;
  const FormErrorText({
    super.key,
    this.margin,
  });

  @override
  State<FormErrorText> createState() => _FormErrorTextState();
}

class _FormErrorTextState extends State<FormErrorText> {
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
          visible: snapshot.hasData,
          replacement: const SizedBox.shrink(),
          child: Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 228, 199, 199),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              snapshot.data ?? "",
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        );
      },
    );
  }
}
