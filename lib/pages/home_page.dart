import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Bar',
      theme: ThemeData(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    SearchPage(),
    FavoritePage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DRINKDEX'),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.lightGreen,
        unselectedItemColor: Colors.black,
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Cerca",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Preferiti",
          ),
        ],
        selectedItemColor: Colors.white,
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<Cocktail> _cocktails = [];
  bool _isLoading = false;

  Future<void> _searchCocktails(String query) async {
    setState(() {
      _isLoading = true;
    });

    String url =
        'https://www.thecocktaildb.com/api/json/v1/1/search.php?s=$query';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final drinks = data['drinks'];

        if (drinks != null) {
          _cocktails = List<Cocktail>.from(
            drinks.map((drink) => Cocktail.fromJson(drink)),
          );
        } else {
          _cocktails = [];
        }
      } else {
        _cocktails = [];
      }
    } catch (e) {
      _cocktails = [];
      print('Error: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              if (value.length > 0) {
                _searchCocktails(value);
              }
            },
            decoration: InputDecoration(
              labelText: 'Cerca un cocktail',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        _isLoading
            ? CircularProgressIndicator()
            : _cocktails.isNotEmpty
            ? Expanded(
          child: ListView.builder(
            itemCount: _cocktails.length,
            itemBuilder: (context, index) {
              Cocktail cocktail = _cocktails[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(cocktail: cocktail),
                    ),
                  );
                },
                child: Card(
                  child: ListTile(
                    leading: Image.network(cocktail.strDrinkThumb),
                    title: Text(cocktail.strDrink),
                  ),
                ),
              );
            },
          ),
        )
            : Text('Nessun Coctail trovato'),
      ],
    );
  }
}

class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Pagina dei preferiti'),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Cocktail cocktail;

  DetailPage({required this.cocktail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cocktail.strDrink),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(cocktail.strDrinkThumb),
            SizedBox(height: 16.0),
            Text(
              cocktail.strDrink,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
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