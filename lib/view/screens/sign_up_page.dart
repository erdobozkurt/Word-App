import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:word_app/view/widgets/input_tile_widget.dart';
import '../../services/auth_methods.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  static const routeName = 'signUpPage';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordContoller = TextEditingController();
  final secPasswordController = TextEditingController();
  bool passwordVisible = true;
  PickedFile? pickedFile;
  final authMethods = AuthMethods();
  bool _isLoading = false;

  UploadTask? uploadTask;

  String? urlDownload;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordContoller.dispose();
    secPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        shrinkWrap: true,
        reverse: true,
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: pickedFile == null
                ? GestureDetector(
                    onTap: pickProfilePicture,
                    child: const SizedBox(
                      height: 120,
                      width: 120,
                      child: Card(
                        shape: CircleBorder(),
                        child: Center(child: Text('Pick an image')),
                      ),
                    ),
                  )
                : ClipOval(
                    child: Image.file(
                      width: 120,
                      height: 120,
                      fit: BoxFit.fill,
                      File(pickedFile!.path),
                    ),
                  ),
          ),
          //* Name input
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputTileWidget(
              child: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
            ),
          ),
          //* Email input
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputTileWidget(
              child: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  labelText: 'Enter email',
                  prefixIcon: Icon(Icons.mail),
                ),
              ),
            ),
          ),
          //* Password input
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputTileWidget(
              child: TextFormField(
                controller: passwordContoller,
                keyboardType: TextInputType.visiblePassword,
                obscureText: passwordVisible,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Enter password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      passwordVisible = !passwordVisible;
                      setState(() {});
                    },
                    icon: const Icon(Icons.remove_red_eye),
                  ),
                ),
              ),
            ),
          ),
          //* Confirm password input
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputTileWidget(
              child: TextFormField(
                controller: secPasswordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: passwordVisible,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Password again',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      passwordVisible = !passwordVisible;
                      setState(() {});
                    },
                    icon: const Icon(Icons.remove_red_eye),
                  ),
                ),
              ),
            ),
          ),
          //* Sign up button
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  await authMethods.signUpWithEmailAndPassword(
                      profileImage: pickedFile!,
                      email: emailController.text,
                      password: passwordContoller.text,
                      name: nameController.text,
                      context: context);
                  setState(() {
                    _isLoading = false;
                  });
                },
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text('Sign Up',
                        style: Theme.of(context).textTheme.headline6),
              ),
            ),
          ),
          const Spacer(),
        ].reversed.toList(),
      ),
    );
  }

  void pickProfilePicture() async {
    final result =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    if (result == null) {
      return;
    }

    setState(() {
      pickedFile = result;
    });
  }
}
