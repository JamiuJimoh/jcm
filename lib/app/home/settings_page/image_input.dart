import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'pick_image_container.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({
    Key? key,
    required this.pickedImageFn,
    required this.initialImage,
  }) : super(key: key);
  final void Function(File pickedImage) pickedImageFn;
  final String initialImage;

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;
  // File? _image;

  final _imgPicker = ImagePicker();

  Future<void> _chooseImageSource() async {
    await showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _bottomSheetOption(
                icon: Icons.camera,
                text: 'Take a picture',
                select: () {
                  _takePicture(ImageSource.camera);
                },
              ),
              _bottomSheetOption(
                icon: Icons.photo,
                text: 'Choose from gallery',
                select: () {
                  _takePicture(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _takePicture(ImageSource imageSource) async {
    final imageFile = await _imgPicker.pickImage(
      source: imageSource,
      imageQuality: 80,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (imageFile != null) {
      setState(() {
        _storedImage = File(imageFile.path);
      });
      // final appDir = await syspaths.getApplicationDocumentsDirectory();
      // final fileName = path.basename(imageFile.path);
      // final savedImage = await _storedImage?.copy('${appDir.path}/$fileName');
      widget.pickedImageFn(File(imageFile.path));
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: PickImageContainer(
        context,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Stack(
            children: [
              Container(
                color: Theme.of(context).primaryColor.withAlpha(100),
                height: 50.0,
                width: double.infinity,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Change Profile Picture',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(width: 10.0),
                    const Icon(Icons.camera, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
        decorationImage: DecorationImage(
          image: _storedImage == null
              ? (widget.initialImage.isEmpty
                  ? const AssetImage('assets/images/blank-profile-picture.png')
                  : NetworkImage(widget.initialImage) as ImageProvider)
              : FileImage(_storedImage!),
          fit: BoxFit.cover,
        ),
      ),
      onTap: _chooseImageSource,
    );
  }

  Widget _bottomSheetOption({
    required IconData icon,
    required String text,
    required void Function() select,
  }) {
    return GestureDetector(
      onTap: select,
      child: SizedBox(
        height: 120.0,
        child: Column(
          children: [
            Icon(
              icon,
              size: 35.0,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 10.0),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
