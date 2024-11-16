import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async'; // For debounce functionality
import 'search_screen_provider.dart';

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
    // Fetch all movies when the screen is first opened
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
      if (query.isNotEmpty) {
        context.read<SearchProvider>().fetchSearchResults(query.trim());
      } else {
        // If query is empty, fetch all movies
        context.read<SearchProvider>().fetchSearchResults('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                          setState(() {}); // Ensure UI refreshes
                          context.read<SearchProvider>().clearResults();
                          // Fetch all movies when search is cleared
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
              onSubmitted: (query) {
                if (query.isNotEmpty) {
                  context
                      .read<SearchProvider>()
                      .fetchSearchResults(query.trim());
                } else {
                  // If query is empty, fetch all movies
                  context.read<SearchProvider>().fetchSearchResults('');
                }
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Consumer<SearchProvider>(
                builder: (context, searchProvider, child) {
                  if (searchProvider.isLoading) {
                    return const Center(
                      child: Text(
                        'Searching...',
                        style: TextStyle(fontSize: 16.0, color: Colors.grey),
                      ),
                    );
                  } else {
                    // Always show results based on the query or show all results if no search
                    final resultsToShow = searchProvider.searchResults.isEmpty
                        ? searchProvider
                            .searchResults // Show all results if no search query
                        : searchProvider.searchResults;

                    return ListView.separated(
                      controller: scrollController,
                      itemCount: resultsToShow.length,
                      separatorBuilder: (_, __) => const Divider(
                        color: Colors.grey,
                      ),
                      itemBuilder: (context, index) {
                        final movie = resultsToShow[index];
                        return ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                movie['show']['image']?['medium'] ?? '',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.movie,
                                  size: 50,
                                ),
                              ),
                            ),
                            title:
                                Text(movie['show']['name'] ?? 'Unknown Title'),
                            subtitle: Text(
                              movie['show']['genres'] != null
                                  ? _stripHtml(
                                      _getGenresString(movie['show']['genres']))
                                  : 'No description available',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Container(
                                height: 40,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: _getRatingColor(movie['show']
                                          ['rating'] ??
                                      {}), // Pass empty map if 'rating' is null
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Show IMDb rating text

                                      // Show actual numeric rating value
                                      Text(
                                        _extractRating(movie['show']['rating']),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                      Text(
                                        ' IMDb',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                )));
                      },
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

  String _stripHtml(String htmlText) {
    final regex = RegExp(r'<[^>]*>');
    return htmlText.replaceAll(regex, '');
  }
}

String _getGenresString(dynamic genres) {
  if (genres is List) {
    // If it's a list, join the items into a single string
    return genres.join('| ');
  } else if (genres is String) {
    // If it's already a string, return it
    return genres;
  } else {
    return '';
  }
}

Color _getRatingColor(dynamic rating) {
  if (rating != null && rating['average'] != null) {
    final averageRating = rating['average'];
    final numRating = double.tryParse(averageRating.toString());
    if (numRating != null) {
      return numRating > 6.5 ? Colors.green : Colors.blue;
    }
  }
  return Colors.blue; // Default color when no valid rating exists
}

// Function to extract numeric rating value from map
String _extractRating(dynamic rating) {
  if (rating != null && rating['average'] != null) {
    final averageRating = rating['average'];
    return averageRating?.toString() ?? '0'; // Return 'No Rating' if null
  }
  return '0'; // Return 'No Rating' if rating is null
}
