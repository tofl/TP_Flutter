import 'dart:convert';
import 'package:app_tp/routeArguments.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:waterfall_flow/waterfall_flow.dart';
import 'package:share_plus/share_plus.dart';

class Gif {
  final String imageUrl;

  Gif(this.imageUrl);
}

class GifsPage extends StatefulWidget {
  @override
  _GifsPageState createState() => _GifsPageState();
}

class _GifsPageState extends State<GifsPage> {
  List gifs = [];
  String gifsFetchStatus = 'loading';
  final _formKey = GlobalKey<FormState>();
  ScreenArguments args = ScreenArguments('');
  final searchController = TextEditingController();

  // Récupération des gifs
  void fetchGifs(String searchTerm) async {
    String url = 'http://api.giphy.com/v1/gifs/search?api_key=klVrI5PS1PXLZ9E6uS8JGOctNnpu7BHd';
    url += '&q=$searchTerm';
    url += '&limit=100';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List intermediateGifList = [];
      intermediateGifList.addAll(json.decode(response.body)['data']);
      setState(() {
        gifs = intermediateGifList;
        gifsFetchStatus = 'loaded';
      });
    } else {
      setState(() {
        gifsFetchStatus = 'error';
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    searchController.text = args.searchTerm;
    fetchGifs(args.searchTerm);
  }

  @override
  Widget build(BuildContext context) {
    // Par défaut, on affiche un message de chargement
    Widget displayedWidget = const Center(
      child: Text('Loading...'),
    );

    // Lorsque les données ont été retournées par le serveur, on affiche la liste des gifs.
    if (gifs.length > 0) {
      displayedWidget = Expanded(
        // La documentation de ce plugin est infame
        child: WaterfallFlow.builder(
          padding: const EdgeInsets.all(5.0),
          gridDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 5.0,
            closeToTrailing: true,
          ),
          itemBuilder: (BuildContext c, int i) {
            return GestureDetector(
              // Permettre de télécharger ou partager l'image lorsque l'utilisateur maintient son doigt dessus
              onLongPress: () {
                Share.share(gifs[i]['images']['original']['url']);
              },
              // Afficher l'image dans une boite de dialogue lorsque l'utilisateur appuie dessus
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          image: DecorationImage(
                            image: NetworkImage(gifs[i]['images']['original']['url']),
                            fit: BoxFit.cover
                          )
                        ),
                      ),
                    );
                  },
                );
              },

              child: Image.network(
                gifs[i]['images']['fixed_width']['url'],
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: SizedBox(
                      height: 100,
                      child: Text('Loading...'),
                    ),
                  );
                },
              ),
            );
          },
          itemCount: gifs.length,
        ),
      );
    } else if (gifsFetchStatus == 'error') {
      displayedWidget = const Center(
          child: Text('There was an error. Try again later.')
      );
    }

    return Material(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: searchController,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        fetchGifs(searchController.text);
                      },
                      child: const Text('🔎'),
                    ),
                  ],
                ),
              ),
            ),
            displayedWidget,
          ],
        ),
      ),
    );
  }
}
