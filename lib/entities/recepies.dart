class Recepie {
  String id;
  String name;
  String category;
  String image;
  String rating;
  int cal;
  int time;
  int review;
  List<String> ingredientsNames;
  List<String> ingredientsImages;
  List<String> ingredientAmount; 

  Recepie({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.rating,
    required this.cal,
    required this.time,
    required this.review,
    required this.ingredientsNames,
    required this.ingredientsImages,
    required this.ingredientAmount,
  });

  factory Recepie.fromMap(Map<String, dynamic> data, String id) {
    return Recepie(
      id: id,
      name: data['name'],
      category: data['category'],
      image: data['image'],
      rating: data['rating'],
      cal: data['cal'],
      time: data['time'],
      review: data['review'],
      ingredientsNames: List<String>.from(data['ingredientsNames']),
      ingredientsImages: List<String>.from(data['ingredientsImages']),
      ingredientAmount: List<String>.from(data['ingredientAmount']), // Corrected spelling
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'image': image,
      'rating': rating,
      'cal': cal,
      'time': time,
      'review': review,
      'ingredientsNames': ingredientsNames,
      'ingredientsImages': ingredientsImages,
      'ingredientAmount': ingredientAmount, 
    };
  }
}
