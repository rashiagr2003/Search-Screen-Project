import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:async'; // For debounce functionality
import '../Home Screen/detail_screen.dart';
import 'search_screen_provider.dart';
import '../searchScreen/models/search_model.dart' as search_model;

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  Timer? debounce;

  @override
  void initState() {
    super.initState();
    // Initial empty search
    context.read<SearchProvider>().fetchSearchResults('');
  }

  @override
  void dispose() {
    searchController.dispose();
    debounce?.cancel();
    scrollController.dispose();
    super.dispose();
  }

  void onSearchChanged(String query) {
    if (debounce?.isActive ?? false) debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<SearchProvider>().fetchSearchResults(query.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width and height for responsiveness
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Movies'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search for movies...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          setState(() {});
                          context.read<SearchProvider>().clearResults();
                          context.read<SearchProvider>().fetchSearchResults('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (query) {
                setState(() {});
                onSearchChanged(query);
              },
              onSubmitted: onSearchChanged,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Consumer<SearchProvider>(
                builder: (context, searchProvider, child) {
                  if (searchProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    final results = searchProvider.searchResults;

                    return results.isNotEmpty
                        ? ListView.separated(
                            controller: scrollController,
                            itemCount: results.length,
                            separatorBuilder: (_, __) =>
                                const Divider(color: Colors.grey),
                            itemBuilder: (context, index) {
                              final movie = results[index];
                              return ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    movie['show']['image']?['medium'] ?? '',
                                    width: screenWidth * 0.15,
                                    height: screenWidth * 0.15,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(Icons.movie, size: 50),
                                  ),
                                ),
                                title: Text(
                                  movie['show']['name'] ?? 'Unknown Title',
                                  style: GoogleFonts.roboto(
                                    fontSize: screenWidth * 0.045,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  movie['show']['genres'] != null
                                      ? _getGenresString(
                                          movie['show']['genres'])
                                      : 'No genres available',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: Container(
                                  height: screenHeight * 0.035,
                                  width: screenWidth * 0.2,
                                  decoration: BoxDecoration(
                                    color: _getRatingColor(
                                        movie['show']['rating'] ?? {}),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          _extractRating(
                                              movie['show']['rating']),
                                          style: GoogleFonts.roboto(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: screenWidth * 0.03,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'IMDB',
                                          style: GoogleFonts.roboto(
                                            color: Colors.white,
                                            fontSize: screenWidth * 0.03,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  // Navigate to DetailScreen
                                  final show =
                                      search_model.Show.fromJson(movie['show']);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailScreen(show: show),
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              'No results found.',
                              style: GoogleFonts.roboto(fontSize: 16.0),
                            ),
                          );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _getGenresString(dynamic genres) {
  if (genres is List) {
    return genres.join(', ');
  }
  return 'Unknown';
}

Color _getRatingColor(dynamic rating) {
  if (rating != null && rating['average'] != null) {
    final average = double.tryParse(rating['average'].toString());
    if (average != null) {
      return average > 6.5 ? Colors.green : Colors.blue;
    }
  }
  return Colors.grey;
}

String _extractRating(dynamic rating) {
  return rating?['average']?.toString() ?? 'N/A';
}
