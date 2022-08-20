import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);
  static const routeName = 'listPage';

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Page'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(_auth.currentUser!.email.toString())
            .orderBy('word')
            .snapshots(),
        builder:
            ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            shrinkWrap: true,
            //itemExtent: 80,
            children: snapshot.data!.docs.map((document) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(document['word'].toString()),
                  subtitle: Text(document['definition'].toString()),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection(_auth.currentUser!.email.toString())
                          .doc(document.id)
                          .delete();
                    },
                  ),
                ),
              );
            }).toList(),
          );
        }),
      ),
    );
  }
}
