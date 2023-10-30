import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class CocktailDetailPage extends StatelessWidget {
  final String cocktailId;

  CocktailDetailPage({required this.cocktailId});

  Future<dynamic> _fetchCocktailDetail() async {
    final response = await http.get(
      Uri.parse(
          'https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=$cocktailId'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['drinks'][0];
    } else {
      throw Exception('Errore durante il recupero dei dettagli del cocktail');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dettaglio del cocktail'),
      ),
      body: FutureBuilder(
        future: _fetchCocktailDetail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
                    'Errore durante il recupero dei dettagli del cocktail'));
          } else {
            final cocktail = snapshot.data;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.network(cocktail['strDrinkThumb']),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      cocktail['strDrink'],
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Ingredienti:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(cocktail['strIngredient1']),
                  Text(cocktail['strIngredient2']),
                  // Aggiungi più ingredienti qui se necessario
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Istruzioni:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    cocktail['strInstructionsIT'] ??
                        cocktail['strInstructions'],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}