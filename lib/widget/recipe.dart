import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _imageController = TextEditingController();
  final _ratingController = TextEditingController();
  final _calController = TextEditingController();
  final _timeController = TextEditingController();
  final _reviewController = TextEditingController();

  final List<TextEditingController> _ingredientNameControllers = [];
  final List<TextEditingController> _ingredientAmountControllers = [];
  final List<TextEditingController> _ingredientImageControllers = [];

  void _addIngredientRow() {
    setState(() {
      _ingredientNameControllers.add(TextEditingController());
      _ingredientAmountControllers.add(TextEditingController());
      _ingredientImageControllers.add(TextEditingController());
    });
  }

  void _removeIngredientRow(int index) {
    setState(() {
      _ingredientNameControllers[index].dispose();
      _ingredientAmountControllers[index].dispose();
      _ingredientImageControllers[index].dispose();

      _ingredientNameControllers.removeAt(index);
      _ingredientAmountControllers.removeAt(index);
      _ingredientImageControllers.removeAt(index);
    });
  }

  Future<void> _saveRecipe() async {
    final ingredientNames =
        _ingredientNameControllers.map((c) => c.text.trim()).toList();
    final ingredientAmounts =
        _ingredientAmountControllers.map((c) => c.text.trim()).toList();
    final ingredientImages =
        _ingredientImageControllers.map((c) => c.text.trim()).toList();

    final recipeData = {
      'name': _nameController.text.trim(),
      'category': _categoryController.text.trim(),
      'image': _imageController.text.trim(),
      'rating': _ratingController.text.trim(),
      'cal': int.tryParse(_calController.text.trim()) ?? 0,
      'time': int.tryParse(_timeController.text.trim()) ?? 0,
      'review': int.tryParse(_reviewController.text.trim()) ?? 0,
      'ingredientsNames': ingredientNames,
      'ingrediantAmount': ingredientAmounts,
      'ingredientsImages': ingredientImages,
    };

    await FirebaseFirestore.instance.collection('recipes').add(recipeData);

    _clearForm();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Recipe added successfully!')),
    );
  }

  void _clearForm() {
    _nameController.clear();
    _categoryController.clear();
    _imageController.clear();
    _ratingController.clear();
    _calController.clear();
    _timeController.clear();
    _reviewController.clear();

    for (var controller in _ingredientNameControllers) {
      controller.dispose();
    }
    for (var controller in _ingredientAmountControllers) {
      controller.dispose();
    }
    for (var controller in _ingredientImageControllers) {
      controller.dispose();
    }

    _ingredientNameControllers.clear();
    _ingredientAmountControllers.clear();
    _ingredientImageControllers.clear();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _imageController.dispose();
    _ratingController.dispose();
    _calController.dispose();
    _timeController.dispose();
    _reviewController.dispose();

    for (var controller in _ingredientNameControllers) {
      controller.dispose();
    }
    for (var controller in _ingredientAmountControllers) {
      controller.dispose();
    }
    for (var controller in _ingredientImageControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Recipe'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Recipe Name'),
            ),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: _imageController,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
            TextField(
              controller: _ratingController,
              decoration: const InputDecoration(labelText: 'Rating'),
            ),
            TextField(
              controller: _calController,
              decoration: const InputDecoration(labelText: 'Calories'),
            ),
            TextField(
              controller: _timeController,
              decoration: const InputDecoration(labelText: 'Time (in minutes)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _reviewController,
              decoration: const InputDecoration(labelText: 'Reviews'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            const Text(
              'Ingredients',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _ingredientNameControllers.length,
              itemBuilder: (context, index) {
                return Row(
                  key: ValueKey(index),
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _ingredientNameControllers[index],
                        decoration: const InputDecoration(labelText: 'Name'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _ingredientAmountControllers[index],
                        decoration: const InputDecoration(labelText: 'Amount'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _ingredientImageControllers[index],
                        decoration:
                            const InputDecoration(labelText: 'Image URL'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeIngredientRow(index),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: _addIngredientRow,
              child: const Text('Add Ingredient'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveRecipe,
              child: const Text('Save Recipe'),
            ),
          ],
        ),
      ),
    );
  }
}
