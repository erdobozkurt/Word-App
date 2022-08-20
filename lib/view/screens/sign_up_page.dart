import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:word_app/view/widgets/input_tile_widget.dart';
import 'main_page.dart';
import 'package:firebase_core/firebase_core.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  static const routeName = 'signUpPage';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordContoller = TextEditingController();
  final secPasswordController = TextEditingController();
  bool passwordVisible = true;

  PickedFile? pickedFile;

  UploadTask? uploadTask;

  String? urlDownload;

  @override
  void dispose() {
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputTileWidget(
              child: TextFormField(
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
                onPressed: signUp,
                child: Text('Sign Up',
                    style: Theme.of(context).textTheme.headline6),
              ),
            ),
          ),
          const Spacer(),
        ].reversed.toList(),
      ),
    );
  }

  signUp() async {
    try {
      if (passwordContoller.text.trim() == secPasswordController.text.trim()) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordContoller.text.trim(),
        );

        final name = 'files/$pickedFile';
        final file = File(pickedFile!.path);

        final ref = FirebaseStorage.instance.ref().child(name);

        uploadTask = ref.putFile(file);

        final snapshot = await uploadTask!.whenComplete(
          () {},
        );

        urlDownload = await snapshot.ref.getDownloadURL();

        
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('check the password'),
          ),
        );
        return;
      }

      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null) {
          Navigator.pushReplacementNamed(context, MainPage.routeName);
        }
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.code.toString()),
        ),
      );
    } catch (e) {
      throw Exception('fail on sign up');
    }
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
