import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bartolinimauri/pages/home_page.dart';
import 'package:bartolinimauri/pages/detail_page.dart';

class DetailPage extends StatefulWidget {
  final Cocktail cocktail;

  DetailPage({required this.cocktail});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<String> _ingredients = [];
  String _instructions = '';

  @override
  void initState() {
    super.initState();
    getDrinkDetails(widget.cocktail.strDrink);
  }
  bool _isFavorite = false;
  Future<void> getDrinkDetails(String drinkName) async {
    String url =
        'https://www.thecocktaildb.com/api/json/v1/1/search.php?s=$drinkName';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final drinks = data['drinks'];

        if (drinks != null) {
          final drink = drinks[0];

          for (int i = 1; i <= 15; i++) {
            if (drink['strIngredient$i'] != null) {
              _ingredients.add(drink['strIngredient$i']);
            }
          }

          _instructions = drink['strInstructionsIT'] ?? drink['strInstructions'];
        }
      }
    } catch (e) {
      print('Non trovato: $e');
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cocktail.strDrink),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(widget.cocktail.strDrinkThumb),
            SizedBox(height: 16.0),
            Text(
              widget.cocktail.strDrink,
              style: TextStyle(
                fontSize: 22.0,
                color: _isFavorite ? Colors.red : null,
                fontWeight: FontWeight.bold,
              ),    //agiunto is favorite
            ),
            SizedBox(height: 16.0),
            Text(
              'Ingredienti:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              children: _ingredients
                  .map(
                    (ingredient) => Text(
                  '- $ingredient',
                  style: TextStyle(fontSize: 16.0),
                ),
              )
                  .toList(),
            ),
            SizedBox(height: 16.0),
            Text(
              'Istruzioni:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _instructions,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}

class Cocktail {
  final String strDrink;
  final String strDrinkThumb;

  Cocktail({
    required this.strDrink,
    required this.strDrinkThumb,
  });

  factory Cocktail.fromJson(Map<String, dynamic> json) {
    return Cocktail(
      strDrink: json['strDrink'],
      strDrinkThumb: json['strDrinkThumb'],
    );
  }
}