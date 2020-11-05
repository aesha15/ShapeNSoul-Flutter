import 'package:flutter/material.dart';

class AddRecipe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Recipe'),
      ),
      body: Center(
        child: Text(
          'Add New Recipe',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
