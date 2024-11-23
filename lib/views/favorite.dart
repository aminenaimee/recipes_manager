import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/Provider/favorite_provider.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    final favoriteList = provider.favoriteList;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 233, 235),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Favorite",
          style: TextStyle(
            fontWeight: FontWeight.bold,

          ),
        ),
      ),
      body: favoriteList.isEmpty?Center(
        child: Text("No Favorite Added",
         style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
        ),
      ):ListView.builder(
        itemCount: favoriteList.length,
        itemBuilder: (context,index){
          return  FutureBuilder<DocumentSnapshot>(future: FirebaseFirestore.instance.collection("recipes").doc(favoriteList[index]).get(), builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) {
              return Center(child: Text("No Data"));
            }
            var recipe = snapshot.data!;
            return ListTile(
              title: Text(recipe['name']),
              subtitle: Text(recipe['description']),
            );
          });
        })
    );
  }
}
