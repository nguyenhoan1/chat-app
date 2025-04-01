import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/blocs/home/home_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _stories = [
    {
      'username': 'Your Story',
      'imageUrl': 'assets/images/avatar1.png',
      'isViewed': false,
      'isYourStory': true,
    },
    {
      'username': 'john_doe',
      'imageUrl': 'assets/images/avatar2.png',
      'isViewed': false,
      'isYourStory': false,
    },
    {
      'username': 'jane_smith',
      'imageUrl': 'assets/images/avatar3.png',
      'isViewed': false,
      'isYourStory': false,
    },
    {
      'username': 'robert_j',
      'imageUrl': 'assets/images/avatar4.png',
      'isViewed': true,
      'isYourStory': false,
    },
    {
      'username': 'emma_w',
      'imageUrl': 'assets/images/avatar5.png',
      'isViewed': true,
      'isYourStory': false,
    },
    {
      'username': 'michael_b',
      'imageUrl': 'assets/images/avatar6.png',
      'isViewed': false,
      'isYourStory': false,
    },
  ];

  final List<Map<String, dynamic>> _posts = [
    {
      'username': 'john_doe',
      'userImageUrl': 'assets/images/avatar2.png',
      'location': 'Tokyo, Japan',
      'postImageUrl': 'assets/images/post1.jpg',
      'caption': 'Enjoying the beautiful view of Tokyo! #travel #japan',
      'likesCount': 1234,
      'commentsCount': 42,
      'timeAgo': '2 hours ago',
      'comments': [
        {'username': 'emma_w', 'text': 'Looks amazing! 😍'},
        {'username': 'robert_j', 'text': 'Wish I was there!'},
      ],
      'isLiked': true,
      'isSaved': false,
    },
    {
      'username': 'jane_smith',
      'userImageUrl': 'assets/images/avatar3.png',
      'location': 'Paris, France',
      'postImageUrl': 'assets/images/post2.jpg',
      'caption': 'Coffee and croissants in Paris ☕ #paris #foodie',
      'likesCount': 856,
      'commentsCount': 23,
      'timeAgo': '5 hours ago',
      'comments': [
        {'username': 'michael_b', 'text': 'That looks delicious!'},
      ],
      'isLiked': false,
      'isSaved': true,
    },
    {
      'username': 'emma_w',
      'userImageUrl': 'assets/images/avatar5.png',
      'location': 'New York, USA',
      'postImageUrl': 'assets/images/post3.jpg',
      'caption':
          'Just finished my morning run in Central Park 🏃‍♀️ #fitness #nyc',
      'likesCount': 2345,
      'commentsCount': 78,
      'timeAgo': '1 day ago',
      'comments': [
        {
          'username': 'john_doe',
          'text': "You're inspiring me to get back to running!"
        },
        {
          'username': 'jane_smith',
          'text': 'Central Park is beautiful this time of year!'
        },
      ],
      'isLiked': true,
      'isSaved': false,
    },
  ];

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
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _buildStories(),
        ),
        SliverToBoxAdapter(
          child: Divider(
            height: 1,
            thickness: 0.5,
            color: Colors.grey.shade300,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return _buildPostItem(_posts[index]);
            },
            childCount: _posts.length,
          ),
        ),
      ],
    );
  }

  Widget _buildStories() {
    return Container(
      height: 115,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _stories.length,
        itemBuilder: (context, index) {
          final story = _stories[index];
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
                        gradient: story['isViewed']
                            ? null
                            : const LinearGradient(
                                colors: [
                                  Colors.purple,
                                  Colors.orange,
                                  Colors.red,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                        color: story['isViewed'] ? Colors.grey.shade300 : null,
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
                          backgroundImage: AssetImage(
                            story['imageUrl'] != null &&
                                    story['imageUrl'].toString().isNotEmpty
                                ? story['imageUrl']
                                : 'assets/images/default_avatar.png',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: Text(
                    story['username'],
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
      ),
    );
  }

  Widget _buildPostItem(Map<String, dynamic> post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage(
                  post['userImageUrl'] != null &&
                          post['userImageUrl'].toString().isNotEmpty
                      ? post['userImageUrl']
                      : 'assets/images/default_avatar.png',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post['username'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    if (post['location'] != null)
                      Text(
                        post['location'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ],
          ),
        ),
        AspectRatio(
          aspectRatio: 1.0,
          child: Image.asset(
            post['postImageUrl'] != null &&
                    post['postImageUrl'].toString().isNotEmpty
                ? post['postImageUrl']
                : 'assets/images/default_post.png',
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  post['isLiked'] ? Icons.favorite : Icons.favorite_border,
                  color: post['isLiked'] ? Colors.red : Colors.black,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {},
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {},
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.send_outlined),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {},
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  post['isSaved'] ? Icons.bookmark : Icons.bookmark_border,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {},
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '${post['likesCount'].toString()} likes',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text: post['username'] + ' ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: post['caption'],
                ),
              ],
            ),
          ),
        ),
        if (post['commentsCount'] > 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'View all ${post['commentsCount']} comments',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),
        if (post['comments'] != null && post['comments'].length > 0)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              post['comments'].length > 2 ? 2 : post['comments'].length,
              (index) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: post['comments'][index]['username'] + ' ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: post['comments'][index]['text'],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text(
            post['timeAgo'],
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Divider(
          height: 1,
          thickness: 0.5,
          color: Colors.grey.shade200,
        ),
      ],
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
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Add',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.video_collection_outlined),
            label: 'Reels',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 14,
              backgroundImage: AssetImage('assets/images/avatar1.png'),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
