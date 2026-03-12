import 'package:flutter/material.dart';

class ForumPage extends StatelessWidget {
  const ForumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Community Forum"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel("Categories"),
            _buildCategories(),
            _sectionLabel("Recent Discussions"),
            _buildPostList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.teal,
        child: const Icon(Icons.edit_note, color: Colors.white),
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        label,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCategories() {
    final categories = ["General", "Anxiety", "Sleep", "Success Stories", "Tips"];
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Chip(
              label: Text(categories[index]),
              backgroundColor: Colors.teal.withOpacity(0.1),
              side: BorderSide.none,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPostList() {
    final posts = [
      {
        "user": "Anonymous User",
        "title": "How do you handle morning anxiety?",
        "likes": "24",
        "comments": "12"
      },
      {
        "user": "QuietSoul",
        "title": "Just finished my first AI session. Feeling much better!",
        "likes": "45",
        "comments": "5"
      },
      {
        "user": "PeaceSeeker",
        "title": "Recommendations for deep sleep music?",
        "likes": "10",
        "comments": "18"
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(radius: 12, child: Icon(Icons.person, size: 15)),
                    const SizedBox(width: 8),
                    Text(post['user']!, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  post['title']!,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Icon(Icons.thumb_up_outlined, size: 18, color: Colors.teal[700]),
                    const SizedBox(width: 5),
                    Text(post['likes']!),
                    const SizedBox(width: 20),
                    Icon(Icons.chat_bubble_outline, size: 18, color: Colors.teal[700]),
                    const SizedBox(width: 5),
                    Text(post['comments']!),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}