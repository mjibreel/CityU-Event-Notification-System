import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({super.key});

  Future<void> _refreshData() async {
    // Simulate a data refresh
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Blog")),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _refreshData, // Enables pull-to-refresh functionality
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Events')
                .orderBy('date', descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Error loading articles.'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No articles available.'));
              }

              final articles = snapshot.data!.docs;

              return ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    color: Colors.blue.shade50,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (article['imageUrl'] != null)
                            Image.network(article['imageUrl'],
                                height: 150, fit: BoxFit.cover),
                          const SizedBox(height: 10),
                          Text(
                            article['title'] ?? 'No Title',
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            (article['date'] as Timestamp).toDate().toString(),
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 12),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            article['content'] ?? 'No Content',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
