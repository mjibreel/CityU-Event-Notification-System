import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationsPage extends StatelessWidget {
  const LocationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/university_logo.png', height: 30),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Campus Locations',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: const [
                    LocationCard(
                      label: "Cyberjaya Campus",
                      url:
                          "https://maps.google.com/?q=3500+Jalan+Teknokrat+3+Cyber+4+63000+Cyberjaya+Selangor",
                    ),
                    LocationCard(
                      label: "Johor Bahru Campus",
                      url:
                          "https://maps.google.com/?q=G-01+Ground+Floor+Menara+Selia+Persiaran+Southkey+1+Kota+Southkey+80150+Johor+Bahru+Johor",
                    ),
                    LocationCard(
                      label: "Petaling Jaya Campus",
                      url:
                          "https://maps.google.com/?q=8+Jalan+51a/223+Seksyen+51a+46100+Petaling+Jaya+Selangor",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LocationCard extends StatelessWidget {
  final String label;
  final String url;

  const LocationCard({super.key, required this.label, required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          throw 'Could not open $url';
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.location_on, size: 40, color: Colors.blue),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
