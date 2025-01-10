import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import '../searchScreen/models/search_model.dart'
    as search_model; // Import search_model
import '../searchScreen/search_screen.dart';
import 'detail_screen.dart'; // Import the details screen

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  late Future<List<search_model.Show>> shows;

  @override
  void initState() {
    super.initState();
    shows = fetchMovies();
  }

  Future<List<search_model.Show>> fetchMovies() async {
    final response =
        await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=all'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((json) => search_model.Show.fromJson(json['show']))
          .toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            );
          },
          child: TextField(
            enabled: false,
            decoration: InputDecoration(
              hintText: 'Search Movies',
              hintStyle: GoogleFonts.roboto(
                color: Colors.white54, // Light color for the hint text
                fontSize: 16, // Font size for the hint text
                fontWeight: FontWeight.w400, // Adjust font weight as needed
              ),
              border: InputBorder.none,
              prefixIcon: const Icon(Icons.search, color: Colors.white),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<search_model.Show>>(
        future: shows,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(child: Text('No movies found.'));
          } else {
            final shows = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: shows.length,
              itemBuilder: (context, index) {
                final show = shows[index];
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: show.image?.medium != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              show.image!.medium!,
                              width: 50,
                              height: 75,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.movie),
                            ),
                          )
                        : const Icon(
                            Icons.movie,
                            size: 50,
                          ),
                    title: Text(
                      show.name ?? 'Unknown Title',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      show.summary != null
                          ? show.summary!.replaceAll(RegExp(r'<[^>]*>'), '')
                          : 'No summary available',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                          fontSize: 14, color: Colors.grey[700]),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(show: show),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
