import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OMDBMovieAPI extends StatefulWidget {
  const OMDBMovieAPI({super.key});

  @override
  State<OMDBMovieAPI> createState() => _OMDBMovieAPIState();
}

class _OMDBMovieAPIState extends State<OMDBMovieAPI> {
  Map<String, dynamic>? movie;
  final TextEditingController _searchMovie = TextEditingController();

  @override
  void initState() {
    super.initState();
    movie = null;
  }

  void updateMessage(Map<String, dynamic> newMovie) {
    setState(() {
      movie = newMovie;
    });
  }

  Future<void> fetchMovies(String query) async {
    const String apiUrl = "https://omdbapi.com/";

    final Map<String, String> params = {'apiKey': '81d12d27', 't': query};

    final Uri uri = Uri.parse(apiUrl).replace(queryParameters: params);
    print("URI: $uri");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['Response'] == 'True') {
        setState(() {
          movie = data;
        });
      } else {
        setState(() {
          movie = null;
        });
      }
    } else {
      throw Exception('Failed to fetch movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OMDB Movie Application'),
        centerTitle: true,
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black87,
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      body: Container(
        color: const Color.fromARGB(255, 250, 245, 232),
        child: Padding(
          padding: EdgeInsets.all(9),
          child: Column(
            children: [
              TextField(
                controller: _searchMovie,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.movie_outlined),
                  label: Text("Search for a movie"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      if (_searchMovie.text.isNotEmpty) {
                        fetchMovies(_searchMovie.text);
                      }
                    },
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (movie == null) ...[
                Center(
                  heightFactor: 15,
                  child: Text(
                    "Search for movies !",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ] else ...[
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return MovieDetails(
                                movie: movie,
                                onmessageUpdated: updateMessage,
                              );
                            },
                          ),
                        );
                      },
                      child: Card(
                        elevation: 10,
                        color: const Color.fromARGB(255, 241, 213, 128),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Image.network(
                                movie!['Poster'],
                                width: double.infinity,
                                height: 300,
                              ),
                              SizedBox(height: 10),
                              Text(
                                movie!['Title'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class MovieDetails extends StatelessWidget {
  const MovieDetails({
    super.key,
    required this.movie,
    required this.onmessageUpdated,
  });

  final Map<String, dynamic>? movie;
  final Function(Map<String, dynamic>) onmessageUpdated;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 241, 213, 128),
        title: Text(movie!['Title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color.fromARGB(255, 250, 245, 232),
          padding: EdgeInsets.all(12),
          width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.network(movie!['Poster'], height: 250,width: double.infinity-50),
            SizedBox(height: 7,),
            Text(movie!['Released'],style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 15,),
            Text("Genre: "+movie!['Genre'],style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 6,),
            Text("Movie: "+movie!['Director'],style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 6,),
            Text("Actors: "+movie!['Actors'],style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Center(child: Text("Plot: "+movie!['Plot'],style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
            )
          ],
        ),),
      ),
    );
  }
}
