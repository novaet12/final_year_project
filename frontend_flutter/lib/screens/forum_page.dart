import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> with SingleTickerProviderStateMixin {
  final _supabase = Supabase.instance.client;
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Community Hub", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              // 1. Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
                  decoration: InputDecoration(
                    hintText: "Search discussions or groups...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              // 2. Tabs: Feed vs Groups
              TabBar(
                controller: _tabController,
                labelColor: Colors.teal[800],
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.teal[800],
                indicatorWeight: 3,
                tabs: const [
                  Tab(text: "Global Feed"),
                  Tab(text: "Support Groups"),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGlobalFeed(),
          _buildGroupsGrid(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreatePostBottomSheet(context),
        label: const Text("New Post"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.teal[700],
      ),
    );
  }

  // --- TAB 1: GLOBAL FEED ---
  Widget _buildGlobalFeed() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _supabase.from('forum_posts').stream(primaryKey: ['id']).order('created_at'),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        
        final posts = snapshot.data!
            .where((p) => p['title'].toString().toLowerCase().contains(_searchQuery))
            .toList();

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: posts.length,
          itemBuilder: (context, index) => _postCard(posts[index]),
        );
      },
    );
  }

  Widget _postCard(Map<String, dynamic> post) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundColor: Colors.teal[50], child: const Icon(Icons.person, size: 20)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post['alias'] ?? "Anonymous", style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text("2h ago • ${post['category']}", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.more_vert, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 12),
            Text(post['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(post['content'] ?? "", maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black87)),
            const SizedBox(height: 16),
            Row(
              children: [
                _interactionBtn(Icons.thumb_up_outlined, "${post['likes'] ?? 0}"),
                const SizedBox(width: 20),
                _interactionBtn(Icons.chat_bubble_outline, "12"),
                const Spacer(),
                const Icon(Icons.share_outlined, size: 20, color: Colors.grey),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _interactionBtn(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.teal[700]),
        const SizedBox(width: 6),
        Text(count, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  // --- TAB 2: GROUPS GRID ---
  Widget _buildGroupsGrid() {
    final groups = [
      {"name": "Anxiety Warriors", "members": "1.2k", "icon": Icons.shield_moon},
      {"name": "Midnight Sleepers", "members": "800", "icon": Icons.dark_mode},
      {"name": "Student Life", "members": "2.5k", "icon": Icons.school},
      {"name": "Daily Gratitude", "members": "5k", "icon": Icons.favorite},
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(group['icon'] as IconData, size: 40, color: Colors.teal),
              const SizedBox(height: 12),
              Text(group['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text("${group['members']} members", style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[50],
                  foregroundColor: Colors.teal[900],
                  elevation: 0,
                  shape: StadiumBorder(),
                ),
                child: const Text("Join"),
              )
            ],
          ),
        );
      },
    );
  }

  void _showCreatePostBottomSheet(BuildContext context) {
    // ... logic for bottom sheet ...
  }
}