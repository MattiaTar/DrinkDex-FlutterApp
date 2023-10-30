import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detail_page.dart';

class SearchTab extends StatefulWidget {
// posso anche togliere questi
  void addToFavorites(String cocktailId) {}

  void removeFromFavorites(String cocktailId) {}

  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  List<dynamic> _cocktails = [];
  bool _isLoading = false;
  TextEditingController _searchController = TextEditingController();

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

    final url = Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/search.php?s=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _cocktails = data['drinks'];
        _isLoading = false;
      });
    } else {
      throw Exception('Errore durante la ricerca dei cocktail');
    }
  }
  Widget _buildCocktailList() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (_cocktails.isEmpty) {
      return Center(child: Text('scrivi BENE maledizzione'));
    } else {
      return ListView.builder(
        itemCount: _cocktails.length,
        itemBuilder: (context, index) {
          final cocktail = _cocktails[index];
          bool isFavorite = false;

          return Card(
            child: ListTile(
              leading: Image.network(cocktail['strDrinkThumb']),
              title: Text(cocktail['strDrink']),
              trailing: IconButton(
                icon: Icon(
                 // provare ad utilizzare i setState
                  isFavorite == true ? Icons.favorite : Icons.favorite_border,
                ),
                color: isFavorite ? Colors.amber[800] : null,
                onPressed: () {
                  setState(() {
                    isFavorite = !isFavorite ;
                  });
                  // Aggiunta/rimozione del cocktail dai preferiti
                  if (isFavorite) {
                    widget.addToFavorites(cocktail['idDrink']);
                  } else {
                    widget.removeFromFavorites(cocktail['idDrink']);
                  }
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CocktailDetailPage(cocktailId: cocktail['idDrink']),
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
              labelText: 'Alcolizzato',
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
