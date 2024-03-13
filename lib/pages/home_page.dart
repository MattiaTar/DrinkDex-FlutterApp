import 'package:bartolinimauri/pages/search_tab.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'detail_page.dart';


//AGGiungere un bottone Random drink

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DrinkDex',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<String> favorites = [];
  Map<String, Map<String, dynamic>> _cocktailsById = {};
  bool hasFavorites = false;
  bool _dialogShown= false ;

  // allerta tipo Pop UP 
  void showDialogOnce(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Benvenuto e Attenzione'),
          content: Text('Grazie per aver scaricato DrinkDex. Se vuoi bere e completare tutto il DrinkDex ti raccomandiamo di salvare i drink! Buona bevuta dal team DrinkDex.'),
          actions: <Widget>[
            TextButton(
              child: Text('Grazie'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void getCocktailsById(String cocktailId) async {
    final url = Uri.parse(
      'https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=$cocktailId',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final cocktail = data['drinks'][0];
      setState(() {
        _cocktailsById[cocktailId] = cocktail;
      });
    } else {
      throw Exception('Errore durante il recupero dei dettagli del cocktail');
    }
  }



  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      _dialogShown = prefs.getBool('dialogShown') ?? false;
      if (!_dialogShown) {
        showDialogOnce(context);
        prefs.setBool('dialogShown', true);
      }
    });
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        favorites = prefs.getStringList('favorites') ?? [];
        hasFavorites = favorites.isNotEmpty;
      });
    });
  }
  void addToFavorites(String cocktailId) {
    setState(() {
      favorites.add(cocktailId);
      SharedPreferences.getInstance().then((prefs) {
        prefs.setStringList('favorites', favorites);
      });
    });
    getCocktailsById(cocktailId); // Aggiungi questa riga
  }

  void removeFromFavorites(String cocktailId) {
    setState(() {
      favorites.remove(cocktailId);
      SharedPreferences.getInstance().then((prefs) {
        prefs.setStringList('favorites', favorites);
      });
      _cocktailsById.remove(cocktailId);
    });
  }

  bool isFavorite(String cocktailId) {
    return favorites.contains(cocktailId);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('DrinkDex'),
        leading: Icon(Icons.local_gas_station),

      ),
      body: Center(
        child: IndexedStack(
          index: _selectedIndex,
          children: <Widget>[

            SearchTab(
              addToFavorites: addToFavorites,
              removeFromFavorites: removeFromFavorites,
              cocktailsById: _cocktailsById,
            ),
            FavoritesTab(
              favorites: favorites,
              removeFromFavorites: removeFromFavorites,
              cocktailsById: _cocktailsById,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Cerca',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Preferiti',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class FavoritesTab extends StatelessWidget {
  final List<String> favorites;
  final Function(String) removeFromFavorites;
  final Map<String, Map<String, dynamic>> cocktailsById;

  FavoritesTab({
    required this.favorites,
    required this.removeFromFavorites,
    required this.cocktailsById,
  });


  @override
  Widget build(BuildContext context) {
    return favorites.isEmpty
        ? Center(child: Text('Aggiungi un drink ai tuoi preferiti'))
        : ListView.builder(
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final cocktailId = favorites[index];
        final cocktail = cocktailsById[cocktailId];

        return Card(
          child: ListTile(
            leading: Image.network(cocktail?['strDrinkThumb'] ?? ''),
            title: Text(cocktail?['strDrink'] ?? ''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CocktailDetailPage(
                    cocktailId: cocktailId,
                  ),
                ),
              );
            },
            trailing: IconButton(
              icon: Icon(Icons.favorite),
              color: Colors.amber[800],
              onPressed: () {
                removeFromFavorites(cocktailId);
              },
            ),
          ),
        );
      },
    );
  }
}
