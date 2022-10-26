import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
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
  final ref = FirebaseDatabase.instance.ref('Post');
  final searchFilter =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
      body: Column(
        children: [
          //pure stream which return the database events & used everywhere
          // Expanded(
          //     child: StreamBuilder(
          //       stream: ref.onValue,
          //         builder: (context,AsyncSnapshot<DatabaseEvent> snapshot) {
          //         if(!snapshot.hasData){
          //          return const Center(child: CircularProgressIndicator(),);
          //         }else{
          //           Map<dynamic,dynamic> map= snapshot.data!.snapshot.value as dynamic;
          //           List<dynamic> list =[];
          //           list.clear();
          //           list = map.values.toList();
          //           return ListView.builder(
          //             itemCount: snapshot.data!.snapshot.children.length,
          //             itemBuilder: (context, index) {
          //               return ListTile(
          //                 title:  Text(list[index]['title']),
          //               );
          //             },);
          //         }
          //         },)),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: searchFilter,
              decoration: const InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {

                });
              },
            ),
          ),
          //has its own listview builder & it is a widget and used at the run time in widget tree (disadvantage)
          Expanded(
            child: FirebaseAnimatedList(
                query: ref,
                defaultChild: const Center(child: Text('Loading...')),
                itemBuilder: (context, snapshot, animation, index) {
                  final title = snapshot.child('title').value.toString();
                  if(searchFilter.text.isEmpty){
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                    );
                  }else if(title.toLowerCase().contains(searchFilter.text.toLowerCase())){
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                    );
                  }else{
                    return Container();
                  }

                },),
          ),
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
