import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageSelector extends StatefulWidget {
  final XFile? pickedImage;
  final Function(XFile) onImageSelected;

  const ImageSelector({
    super.key,
    required this.pickedImage,
    required this.onImageSelected,
  });

  @override
  State<ImageSelector> createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final pickedImage = widget.pickedImage;
    return Column(
      children: [
        TextButton(
          onPressed: () async {
            final pickedFile =
                await picker.pickImage(source: ImageSource.gallery);

            if (pickedFile != null) {
              widget.onImageSelected(pickedFile);
            }
          },
          style: ButtonStyle(
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0), // Raio dos cantos
              ),
            ),
            backgroundColor: WidgetStateProperty.all(
              Theme.of(context).primaryColor,
            ),
            padding: WidgetStateProperty.all(
              const EdgeInsets.all(16),
            ),
          ),
          child: const Text('Pick from gallery',
              style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 6),
        pickedImage != null
            ? Container(
                width: double.infinity,
                height: 400, // Ocupa toda a largura da tela
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(20.0), // Borda arredondada
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.file(
                    File(pickedImage!.path),
                    fit: BoxFit.cover, // Preencher toda a área
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
