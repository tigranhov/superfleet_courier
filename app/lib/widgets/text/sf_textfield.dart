import 'package:flutter/material.dart';
import 'package:superfleet_courier/theme/colors.dart';
import 'package:superfleet_courier/theme/sf_theme.dart';

class SFTextfield extends StatefulWidget {
  const SFTextfield(
      {super.key,
      this.hint,
      this.obscure = false,
      this.autoCorrect = true,
      this.enableSuggestions = true,
      this.focusNode});
  final String? hint;
  final bool obscure;
  final bool autoCorrect;
  final bool enableSuggestions;
  final FocusNode? focusNode;

  @override
  State<SFTextfield> createState() => _SFTextfieldState();
}

class _SFTextfieldState extends State<SFTextfield> {
  late final FocusNode focusNode;

  @override
  void initState() {
    focusNode = widget.focusNode ?? FocusNode();
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
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: superfleetBlue, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8),
        ),
        filled: focusNode.hasFocus ? false : true,
        fillColor: const Color(0xffF0F0F0),
      ),
    );
  }
}
