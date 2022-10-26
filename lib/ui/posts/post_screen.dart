import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/ui/posts/add_post.dart';
import '../../utils/utilities.dart';

import '../auth/login_screen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            auth.signOut().then((value){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen(),));
            }).onError((error, stackTrace) {
              Utils().toastMessage(error.toString());
            });
          },
              icon: const Icon(Icons.login_outlined)),
          const SizedBox(width: 10,),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(
          builder: (context) => const AddPostScreen(),));
      },
      child: const Icon(Icons.add),
      ),
    );
  }
}
