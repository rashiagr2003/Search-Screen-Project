import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import google_fonts
import '../searchScreen/models/search_model.dart' as search_model;

class DetailScreen extends StatelessWidget {
  final search_model.Show show;

  const DetailScreen({Key? key, required this.show}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          show.name ?? "Movie Details",
          style: GoogleFonts.roboto(), // Applying Google Font
        ),
        backgroundColor: Colors.black12,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Image
            show.image?.original != null
                ? Image.network(
                    show.image!.original!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 300,
                  )
                : Container(
                    height: 300,
                    color: Colors.grey,
                    child: const Center(
                      child: Text(
                        'No Image Available',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
            const SizedBox(height: 16),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                show.name ?? "Unknown Title",
                style: GoogleFonts.robotoCondensed(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ), // Apply Google Font for Title
              ),
            ),
            const SizedBox(height: 8),

            // Genres
            if (show.genres != null && show.genres!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Genres: ${show.genres!.join(', ')}",
                  style: GoogleFonts.roboto(
                    color: Colors.white70,
                  ), // Apply Google Font to Genres
                ),
              ),
            const SizedBox(height: 8),

            // Summary
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                show.summary != null
                    ? show.summary!.replaceAll(RegExp(r'<[^>]*>'), '')
                    : "No summary available",
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: Colors.white70,
                ), // Apply Google Font to Summary
              ),
            ),
            const SizedBox(height: 16),

            // Additional Information
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (show.language != null)
                    Text(
                      "Language: ${show.language}",
                      style: GoogleFonts.roboto(
                        color: Colors.white70,
                      ), // Apply Google Font to Language
                    ),
                  if (show.premiered != null)
                    Text(
                      "Premiered: ${show.premiered}",
                      style: GoogleFonts.roboto(
                        color: Colors.white70,
                      ), // Apply Google Font to Premiered
                    ),
                  if (show.status != null)
                    Text(
                      "Status: ${show.status}",
                      style: GoogleFonts.roboto(
                        color: Colors.white70,
                      ), // Apply Google Font to Status
                    ),
                  if (show.runtime != null)
                    Text(
                      "Runtime: ${show.runtime} minutes",
                      style: GoogleFonts.roboto(
                        color: Colors.white70,
                      ), // Apply Google Font to Runtime
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
