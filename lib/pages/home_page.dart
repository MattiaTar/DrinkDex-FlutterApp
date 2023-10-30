import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'search_page.dart';


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
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<String> favorites = [];

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  final List<Widget> _widgetOptions = <Widget>[
    SearchTab(),
    FavoritesTab(),
  ];

  SharedPreferences? _sharedPreferences;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      _sharedPreferences = prefs;
      setState(() {
        favorites = prefs.getStringList('favorites') ?? [];
      });
    });
  }

  Future<void> _saveFavorites(List<String> favorites) async {
    if (_sharedPreferences != null) {
      await _sharedPreferences!.setStringList('favorites', favorites);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void addToFavorites(String cocktailId) {
    setState(() {
      favorites.add(cocktailId);
      _saveFavorites(favorites);
    });
  }

  void removeFromFavorites(String cocktailId) {
    setState(() {
      favorites.remove(cocktailId);
      _saveFavorites(favorites);
    });
  }

  bool isFavorite(String cocktailId) {
    return favorites.contains(cocktailId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DrinkDex'),
        leading: Icon(Icons.local_gas_station),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
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
        onTap: _onItemTapped,
      ),
    );
  }
}

class FavoritesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _homeState = context.findAncestorStateOfType<_HomePageState>();
    final favorites = _homeState?.favorites ?? [];

    return ListView.builder(
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final cocktailId = favorites[index];

        return ListTile(
          title: Text('Cocktail ID: $cocktailId'),
          trailing: IconButton(
            icon: Icon(Icons.favorite),
            color: Colors.amber[800],
            onPressed: () {
              _homeState?.removeFromFavorites(cocktailId);
            },
          ),
        );
      },
    );
  }
}
