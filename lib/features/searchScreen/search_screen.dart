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
        context.read<SearchProvider>().fetchSearchResults('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width and height for responsiveness
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05, // 5% of screen width
          vertical: screenHeight * 0.02, // 2% of screen height
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
                          setState(() {}); // Ensure UI refreshes
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
              onSubmitted: (query) {
                if (query.isNotEmpty) {
                  context
                      .read<SearchProvider>()
                      .fetchSearchResults(query.trim());
                } else {
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
                    final resultsToShow = searchProvider.searchResults.isEmpty
                        ? searchProvider.searchResults
                        : searchProvider.searchResults;

                    return ListView.separated(
                      controller: scrollController,
                      itemCount: resultsToShow.length,
                      separatorBuilder: (_, __) =>
                          const Divider(color: Colors.grey),
                      itemBuilder: (context, index) {
                        final movie = resultsToShow[index];
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              movie['show']['image']?['medium'] ?? '',
                              width: screenWidth * 0.15, // 15% of screen width
                              height: screenWidth * 0.15, // 15% of screen width
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.movie, size: 50),
                            ),
                          ),
                          title: Text(
                            movie['show']['name'] ?? 'Unknown Title',
                            style: TextStyle(
                                fontSize:
                                    screenWidth * 0.05), // Responsive font size
                          ),
                          subtitle: Text(
                            movie['show']['genres'] != null
                                ? _stripHtml(
                                    _getGenresString(movie['show']['genres']))
                                : 'No description available',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Container(
                            height: screenHeight * 0.035, // 5% of screen height
                            width: screenWidth * 0.2, // 25% of screen width
                            decoration: BoxDecoration(
                              color: _getRatingColor(
                                  movie['show']['rating'] ?? {}),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _extractRating(movie['show']['rating']),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenWidth *
                                          0.03, // Responsive font size
                                    ),
                                  ),
                                  Text(
                                    ' IMDB',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenWidth *
                                          0.03, // Responsive font size
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
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
    return genres.join('| ');
  } else if (genres is String) {
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
  return Colors.blue;
}

String _extractRating(dynamic rating) {
  if (rating != null && rating['average'] != null) {
    final averageRating = rating['average'];
    return averageRating?.toString() ?? '0';
  }
  return '0';
}
