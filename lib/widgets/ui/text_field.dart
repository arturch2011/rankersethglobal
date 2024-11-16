import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  final IconData? icon;
  final int? minLines;
  final int? maxLines;
  const TextFieldInput({
    super.key,
    required this.textEditingController,
    this.isPass = false,
    this.icon,
    this.minLines,
    this.maxLines = 1,
    required this.hintText,
    required this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.0), // Borda arredondada
      borderSide: const BorderSide(color: Colors.grey), // Cor da borda padrão
    );

    final focusBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.0), // Borda arredondada
      borderSide: BorderSide(
          color: Theme.of(context)
              .colorScheme
              .primary), // Cor da borda quando em foco
    );

    return TextFormField(
      controller: textEditingController,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText, // Placeholder
        prefixIcon: icon == null ? null : Icon(icon), // Icone
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 6), // Espaçamento interno
        border: inputBorder,
        focusedBorder: focusBorder,
      ),
      keyboardType: textInputType,
      obscureText: isPass,
      style: TextStyle(color: Colors.black),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Informe os dados!';
        }
        return null;
      },
    );
  }
}
