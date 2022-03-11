import 'package:app_tp/routeArguments.dart';
import 'package:flutter/material.dart';

// TODO transformer en widget stateless
class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: const EdgeInsets.all(30),
        child: MainSearch(),
      ),
    );
  }
}


// Search form
class MainSearch extends StatefulWidget {
  @override
  _MainSearchState createState() => _MainSearchState();
}

class _MainSearchState extends State<MainSearch> {
  final _formKey = GlobalKey<FormState>();
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network('https://www.1ere-position.fr/wp-content/uploads/2018/02/google-logo-2013-1.png'),
          Form(
            key: _formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: searchController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please write some text';
                      }
                      return null;
                    },
                  ),

                  ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        // Navigate
                        Navigator.pushNamed(context, '/gifs', arguments: ScreenArguments(searchController.text));
                        return;
                      }
                    },
                    child: const Text('Rechercher'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    /*
    return Form(
      key: _formKey,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: searchController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please write some text';
                }
                return null;
              },
            ),

            ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // Navigate
                  Navigator.pushNamed(context, '/gifs', arguments: ScreenArguments(searchController.text));
                  return;
                }
              },
              child: const Text('Rechercher'),
            ),
          ],
        ),
      ),
    );
     */
  }
}
