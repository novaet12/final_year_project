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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
                  decoration: InputDecoration(
                    hintText: "Search discussions...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              TabBar(
                controller: _tabController,
                tabs: const [Tab(text: "Global Feed"), Tab(text: "Support Groups")],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildGlobalFeed(), _buildGroupsGrid()],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreatePostBottomSheet(context),
        label: const Text("New Post"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.teal[700],
      ),
    );
  }

  
  Widget _buildGlobalFeed() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _supabase.from('forum_posts').stream(primaryKey: ['id']).order('created_at', ascending: false),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Center(child: Text("Error loading posts"));
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        
        final posts = snapshot.data!
            .where((p) => p['title'].toString().toLowerCase().contains(_searchQuery))
            .toList();

        if (posts.isEmpty) return const Center(child: Text("No discussions found."));

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
                    Text(post['category'] ?? "General", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(post['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(post['content'] ?? "", style: const TextStyle(color: Colors.black87)),
            const SizedBox(height: 16),
            Row(
              children: [
                
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.thumb_up_outlined, size: 20, color: Colors.teal),
                      onPressed: () async {
                        await _supabase.from('forum_posts').update({
                          'likes': (post['likes'] ?? 0) + 1
                        }).eq('id', post['id']);
                      },
                    ),
                    Text("${post['likes'] ?? 0}"),
                  ],
                ),
                const SizedBox(width: 20),
               
                TextButton.icon(
                  icon: const Icon(Icons.chat_bubble_outline, size: 20, color: Colors.teal),
                  label: const Text("Comments", style: TextStyle(color: Colors.teal)),
                  onPressed: () => _showCommentsModal(context, post['id']),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showCommentsModal(BuildContext context, String postId) {
    final commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            children: [
              const Text("Discussion", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _supabase
                      .from('comments')
                      .stream(primaryKey: ['id'])
                      .eq('post_id', postId)
                      .order('created_at', ascending: true),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                    final comments = snapshot.data!;
                    if (comments.isEmpty) return const Center(child: Text("No comments yet. Be the first!"));
                    
                    return ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) => ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person, size: 16)),
                        title: Text(comments[index]['alias'] ?? "Anonymous", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        subtitle: Text(comments[index]['content']),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        decoration: InputDecoration(
                          hintText: "Write a comment...",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.teal),
                      onPressed: () async {
                        if (commentController.text.isNotEmpty) {
                          await _supabase.from('comments').insert({
                            'post_id': postId,
                            'content': commentController.text,
                            'alias': 'Anonymous',
                          });
                          commentController.clear();
                        }
                      },
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

  void _showCreatePostBottomSheet(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final aliasController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Start a Discussion", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(controller: aliasController, decoration: const InputDecoration(labelText: "Display Alias (e.g. Hopeful123)")),
            TextField(controller: titleController, decoration: const InputDecoration(labelText: "Topic Title")),
            TextField(controller: contentController, decoration: const InputDecoration(labelText: "Details"), maxLines: 3),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, minimumSize: const Size(double.infinity, 50)),
              onPressed: () async {
                if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                  await _supabase.from('forum_posts').insert({
                    'title': titleController.text,
                    'content': contentController.text,
                    'alias': aliasController.text.isEmpty ? 'Anonymous' : aliasController.text,
                    'category': 'General',
                  });
                  if (mounted) Navigator.pop(context);
                }
              },
              child: const Text("Post to Community", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupsGrid() {
    return const Center(child: Text("Support Groups Coming Soon"));
  }
}