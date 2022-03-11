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

  void fetchGifs(String searchTerm) async {
    final response = await http.get(Uri.parse(
        'http://api.giphy.com/v1/gifs/search?api_key=klVrI5PS1PXLZ9E6uS8JGOctNnpu7BHd&q=' + searchTerm
      )
    );

    if (response.statusCode == 200) {
      List intermediateGif = [];
      intermediateGif.addAll(json.decode(response.body)['data']);
      setState(() {
        gifs = intermediateGif;
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
    Widget displayedWidget = const Center(
      child: Text('Loading...'),
    );

    if (gifs.length > 0) {
      displayedWidget = Expanded(
        // La documentation de ce plugin est infame
        child: WaterfallFlow.builder(
          padding: const EdgeInsets.all(5.0),
          gridDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 5.0,
          ),
          itemBuilder: (BuildContext c, int i) {
            return GestureDetector(
              onLongPress: () {
                Share.share(gifs[i]['images']['original']['url']);
              },
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
              child: Image.network(gifs[i]['images']['fixed_width']['url']),
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
