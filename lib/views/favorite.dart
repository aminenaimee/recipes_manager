import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
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
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Favorites",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body:
         favoriteList.isEmpty
            ? Center(
                child: Text(
                  "No Favorite Added",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )
            : ListView.builder(
                itemCount: favoriteList.length,
                itemBuilder: (context, index) {
                  String favorite = favoriteList[index];
                  return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection("recipes")
                          .doc(favorite)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data == null) {
                          return Center(
                            child: Text("No Data Found"),
                          );
                        }
                        var favotiteItem = snapshot.data!;

                        return Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(15),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey[200],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 120,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              favotiteItem['image']),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          favotiteItem['name'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Icon(Iconsax.flash_1,
                                                size: 16, color: Colors.grey),

                                            Text(
                                              "${favotiteItem['cal']} Cal",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),

                                              
                                            ),

                                            SizedBox(
                                              width: 10,
                                            ),

                                            Icon(Iconsax.timer_1 ,
                                                size: 16, color: Colors.grey),
                                            Text(
                                              
                                              " ${favotiteItem['time']} Min",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),

                                            

                                          ],
                                        )
                                      ],
                                      
                                    )
                                  ],
                                  
                                ),
                                
                              ),
                            ),
                            Positioned(
                              top: 45,
                              right: 35,
                              child: GestureDetector(
                                onTap: () {
                                  provider.toggleFavorite(favotiteItem);
                                 
                                },
                                child: CircleAvatar(
                             
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      });
                }));
  }
}
