import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';

class SFTextfield extends StatefulWidget {
  const SFTextfield(
      {super.key,
      this.hint,
      this.obscure = false,
      this.autoCorrect = true,
      this.enableSuggestions = true});
  final String? hint;
  final bool obscure;
  final bool autoCorrect;
  final bool enableSuggestions;

  @override
  State<SFTextfield> createState() => _SFTextfieldState();
}

class _SFTextfieldState extends State<SFTextfield> {
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    focusNode.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      obscureText: widget.obscure,
      autocorrect: widget.autoCorrect,
      enableSuggestions: widget.enableSuggestions,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: context.text16grey88,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8.r),
        ),
        filled: focusNode.hasFocus ? false : true,
        fillColor: const Color(0xffF0F0F0),
      ),
    );
  }
}
