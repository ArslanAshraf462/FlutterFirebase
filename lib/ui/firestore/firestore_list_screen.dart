import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/ui/firestore/add_firestore_data.dart';
import '../../utils/utilities.dart';

import '../auth/login_screen.dart';

class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({Key? key}) : super(key: key);

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> {
  final auth = FirebaseAuth.instance;
  //final searchFilter =TextEditingController();
  final editController =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FireStore'),
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
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 10),
          //   child: TextFormField(
          //     controller: searchFilter,
          //     decoration: const InputDecoration(
          //       hintText: 'Search',
          //       border: OutlineInputBorder(),
          //     ),
          //     onChanged: (value) {
          //       setState(() {
          //
          //       });
          //     },
          //   ),
          // ),
          //has its own listview builder & it is a widget and used at the run time in widget tree (disadvantage)
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
              return ListTile(
                title: Text('data'),
              );
            },),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(
              builder: (context) => const AddFireStoreDataScreen(),));
      },
        child: const Icon(Icons.add),
      ),
    );
  }
  Future<void> showMyDialog(String title, String id) async {
    editController.text=title;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update'),
          content: Container(
            child: TextField(
              controller: editController,
              decoration: const InputDecoration(
                hintText: 'Edit',
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.pop(context);

                },
                child: const Text('Update')),
            TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: const Text('Cancel')),
          ],
        );
      },
    );
  }
}
