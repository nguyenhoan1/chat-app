import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/blocs/home/home_bloc.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/blocs/upload_post/post_upload_bloc.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/views/home/widget/up_load_post_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/views/home/widget/video_player_widget.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';
import '../../../core/router/app_router.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;
  VideoPlayerController? _videoController;

  Future<void> _initializeVideoController(String videoUrl) async {
  _videoController?.dispose();
  _videoController = VideoPlayerController.network(videoUrl);
  await _videoController!.initialize();
  _videoController!.setLooping(true);
  _videoController!.play();
}
  void _onItemTapped(int index) async {
    if (index == 2) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => PostUploadBloc(),
            child: const UploadPostView(),
          ),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }
  @override
void dispose() {
  _videoController?.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return _buildBody();
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Chat App',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_border, color: Colors.black),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.chat_outlined, color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: () async {
        // Implement refresh logic
        await Future.delayed(const Duration(seconds: 1));
      },
      child: CustomScrollView(
        slivers: [
          // Stories section
          SliverToBoxAdapter(
            child: _buildStories(),
          ),

          // Divider
          SliverToBoxAdapter(
            child: Divider(
              height: 1,
              thickness: 0.5,
              color: Colors.grey.shade300,
            ),
          ),

          // posts
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .orderBy('created_at', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_camera_outlined,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No posts yet",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Be the first to share a moment",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final posts = snapshot.data!.docs;

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final post = posts[index].data() as Map<String, dynamic>;
                    return _buildpostItem(post);
                  },
                  childCount: posts.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

 Widget _buildStories() {
  return SizedBox(
    height: 115,
    child: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('stories')
          .where('expireAt', isGreaterThan: Timestamp.now()) 
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final storiesDocs = snapshot.data!.docs;

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: storiesDocs.length,
          itemBuilder: (context, index) {
            final storyData = storiesDocs[index].data() as Map<String, dynamic>;
            final userId = storyData['userId'] ?? '';

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) {
                  return const SizedBox.shrink();
                }

                final userData = userSnapshot.data!.data() as Map<String, dynamic>?;
                final username = userData?['displayName'] ?? 'Unknown';
                final photoUrl = userData?['photoUrl'] ?? '';

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [
                                  Colors.purple,
                                  Colors.orange,
                                  Colors.red,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),
                          Container(
                            width: 64,
                            height: 64,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: CircleAvatar(
                                backgroundImage: photoUrl.isNotEmpty
                                    ? NetworkImage(photoUrl)
                                    : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 70,
                        child: Text(
                          username,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    ),
  );
}

  Widget _buildpostItem(Map<String, dynamic> post) {
    final String userId = post['userId'];
    final List<dynamic> mediaUrls = post['mediaUrls'] ?? [];
    final caption = post['caption'] ?? '';
    final location = post['location'] ?? '';
    final likesCount = post['likes_count'] ?? 0;
    final commentsCount = post['comments_count'] ?? 0;
    final timestamp = post['created_at'] != null
        ? (post['created_at'] as Timestamp).toDate()
        : DateTime.now();
    final timeAgo = timeago.format(timestamp);
    final mediaType = post['media_type'] ?? 'image';
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final userData = snapshot.data?.data() as Map<String, dynamic>?;

        final username = userData?['displayName'] ?? 'Unknown';
        final userImageUrl = userData?['photoUrl'] ?? '';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post header with user info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  // User avatar
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: Colors.grey.shade200, width: 0.5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: userImageUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: userImageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Container(color: Colors.grey.shade200),
                              errorWidget: (context, url, error) => Image.asset(
                                  'assets/images/default_avatar.png'),
                            )
                          : Image.asset('assets/images/default_avatar.png'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Username and location
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        if (location.isNotEmpty)
                          Text(
                            location,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                      ],
                    ),
                  ),
                  // More options
                  IconButton(
                    icon: const Icon(Icons.more_horiz),
                    onPressed: () => _showpostOptions(context, post),
                  ),
                ],
              ),
            ),

            // Media (PageView for multiple images)
            if (mediaUrls.isNotEmpty)
              AspectRatio(
                aspectRatio: 1.0,
                child: mediaType == 'video'
                    ? VideoPlayerWidget(
                        videoUrl: mediaUrls[0]) // chỉ play 1 video
                    : PageView.builder(
                        itemCount: mediaUrls.length,
                        itemBuilder: (context, index) {
                          final url = mediaUrls[index];
                          return CachedNetworkImage(
                            imageUrl: url,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey.shade200,
                              child: const Center(
                                  child: CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey.shade200,
                              child: const Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                                size: 50,
                              ),
                            ),
                          );
                        },
                      ),
              )
            else
              Container(
                height: 300,
                color: Colors.grey.shade100,
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                    size: 50,
                  ),
                ),
              ),

            // Actions (like, comment, bookmark)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.favorite_border, size: 28),
                  const SizedBox(width: 8),
                  Icon(Icons.chat_bubble_outline, size: 24),
                  const SizedBox(width: 8),
                  Icon(Icons.send_outlined, size: 24),
                  const Spacer(),
                  Icon(Icons.bookmark_border, size: 28),
                ],
              ),
            ),

            // Likes
            if (likesCount > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '$likesCount ${likesCount == 1 ? 'like' : 'likes'}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),

            // Caption
            if (caption.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: '$username ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: caption),
                    ],
                  ),
                ),
              ),

            // Comments
            if (commentsCount > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'View all $commentsCount comments',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ),

            // Time ago
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                timeAgo,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ),

            const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  void _showpostOptions(BuildContext context, Map<String, dynamic> post) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              _buildOptionTile(
                icon: Icons.report_outlined,
                label: 'Report',
                color: Colors.red,
                onTap: () {
                  Navigator.pop(context);
                  // Show report dialog
                },
              ),
              _buildOptionTile(
                icon: Icons.share_outlined,
                label: 'Share',
                onTap: () {
                  Navigator.pop(context);
                  // Share post
                },
              ),
              _buildOptionTile(
                icon: Icons.link_outlined,
                label: 'Copy link',
                onTap: () {
                  Navigator.pop(context);
                  // Copy post link
                },
              ),
              _buildOptionTile(
                icon: Icons.bookmark_border,
                label: 'Save',
                onTap: () {
                  Navigator.pop(context);
                  // Save post
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String label,
    Color? color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade300,
            width: 0.5,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_filled, size: 28),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 28),
            label: 'Search',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined, size: 28),
            label: 'Add',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.video_collection_outlined, size: 28),
            label: 'Reels',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      _selectedIndex == 4 ? Colors.black : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: const CircleAvatar(
                radius: 12,
                backgroundImage: AssetImage('assets/images/avatar1.png'),
              ),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
