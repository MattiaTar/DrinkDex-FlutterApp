import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detail_page.dart';

class SearchTab extends StatefulWidget {
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
                icon: Icon(Icons.favorite),
                color: Colors.red,
                onPressed: () {
                  //qui Mettere le istruzione per fare in modo chge quando il cuore vienne cliccato venga aggiunto alla schermata dei preferiti

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
              labelText: 'Inserisci il nome del cocktail',
            ),
            onChanged: (query) => _fetchCocktails(query),
          ),
          Expanded(child: _buildCocktailList()),
        ],
      ),
    );
  }
}