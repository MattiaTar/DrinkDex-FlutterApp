import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detail_page.dart';

class SearchTab extends StatefulWidget {
  final Function(String) addToFavorites;
  final Function(String) removeFromFavorites;
  final Map<String, Map<String, dynamic>> cocktailsById;

  SearchTab({
    required this.addToFavorites,
    required this.removeFromFavorites,
    required this.cocktailsById,
  });

  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  List<dynamic> _cocktails = [];
  bool _isLoading = false;
  List<bool> isFavorite = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isFavorite = List.generate(_cocktails.length, (index) {
      final cocktailId = _cocktails[index]['idDrink'];
      return widget.cocktailsById.containsKey(cocktailId);
    });
  }

  void _fetchCocktails(String query) async {
    if (query.isEmpty) {
      setState(() {
        _cocktails = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
      'https://www.thecocktaildb.com/api/json/v1/1/search.php?s=$query',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final cocktails = data['drinks'];
      setState(() {
        _cocktails = cocktails;
        isFavorite = List.generate(_cocktails.length, (index) {
          final cocktailId = _cocktails[index]['idDrink'];
          return widget.cocktailsById.containsKey(cocktailId);
        });
      });
    } else {
      throw Exception('Errore durante il recupero dei cocktail');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void addToFavorites(String cocktailId) {
    widget.addToFavorites(cocktailId);
    setState(() {
      final index = _cocktails.indexWhere((cocktail) =>
      cocktail['idDrink'] == cocktailId);
      if (index >= 0) {
        isFavorite[index] = true;
      }
    });
  }

  Widget _buildCocktailList() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (_cocktails.isEmpty) {
      return Center(child: Text('Nessun cocktail trovato'));
    } else {
      return ListView.builder(
        itemCount: _cocktails.length,
        itemBuilder: (context, index) {
          final cocktail = _cocktails[index];
          return Card(
            child: ListTile(
              leading: Image.network(cocktail['strDrinkThumb']),
              title: Text(cocktail['strDrink']),
              trailing: IconButton(
                icon: Icon(
                  isFavorite[index] ? Icons.favorite : Icons.favorite_border,
                ),
                color: isFavorite[index] ? Colors.amber[800] : null,
                onPressed: () {
                  setState(() {
                    isFavorite[index] = !isFavorite[index];
                  });
                  if (isFavorite[index]) {
                    addToFavorites(cocktail['idDrink']);
                  } else {
                    widget.removeFromFavorites(cocktail['idDrink']);
                  }
                },
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => CocktailDetailPage(
                  cocktailId: cocktail['idDrink'],
                ),
                    ),
                );
              },
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              labelText: 'Cerca cocktail',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
            onChanged: (query) => _fetchCocktails(query),
          ),
          Expanded(child: _buildCocktailList()),
        ],
      ),
    );
  }
}