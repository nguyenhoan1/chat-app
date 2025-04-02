import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/blocs/upload_post/post_upload_bloc.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/blocs/upload_post/post_upload_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_clean_architecture_bloc_template/core/constants/constants.dart';
import 'package:flutter_clean_architecture_bloc_template/core/theme/app_color.dart';
import 'package:flutter_clean_architecture_bloc_template/core/theme/app_theme.dart';
import 'package:flutter_clean_architecture_bloc_template/core/utility/utility.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/widgets/custom_button.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/widgets/custom_spacing.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/widgets/custom_textfield.dart';

class UploadPostView extends StatefulWidget {
  const UploadPostView({super.key});

  @override
  State<UploadPostView> createState() => _UploadPostViewState();
}

class _UploadPostViewState extends State<UploadPostView> {
  final _captionController = TextEditingController();
  final _locationController = TextEditingController();
  final _imagePicker = ImagePicker();
  List<MediaItem> _selectedMedia = [];
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  String _visibility = 'Public';

  VideoPlayerController? _videoController;
  int _currentMediaIndex = 0;
  
  // Added for story upload functionality
  bool _isStoryMode = false;
  bool _isAddingTextToStory = false;
  String _storyText = '';
  Color _storyTextColor = Colors.white;
  double _storyTextSize = 20.0;

  @override
  void dispose() {
    _captionController.dispose();
    _locationController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedMedia.add(MediaItem(
          file: File(pickedFile.path),
          type: MediaType.image,
        ));
      });
    }
  }

  Future<void> _takePhoto() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedMedia.add(MediaItem(
          file: File(pickedFile.path),
          type: MediaType.image,
        ));
      });
    }
  }

  Future<void> _pickVideo() async {
    final pickedFile = await _imagePicker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: _isStoryMode 
          ? const Duration(seconds: 15) // 15 seconds for stories
          : const Duration(minutes: 1), // 1 minute for posts
    );
    if (pickedFile != null) {
      final videoFile = File(pickedFile.path);
      final controller = VideoPlayerController.file(videoFile);
      await controller.initialize();

      setState(() {
        _selectedMedia.add(MediaItem(
          file: videoFile,
          type: MediaType.video,
          duration: controller.value.duration,
        ));

        if (_selectedMedia.length == 1) {
          _videoController = controller;
          _videoController?.play();
          _videoController?.setLooping(true);
        } else {
          controller.dispose();
        }
      });
    }
  }

  Future<void> _recordVideo() async {
    final pickedFile = await _imagePicker.pickVideo(
      source: ImageSource.camera,
      maxDuration: _isStoryMode 
          ? const Duration(seconds: 15) // 15 seconds for stories
          : const Duration(minutes: 1), // 1 minute for posts
    );
    if (pickedFile != null) {
      final videoFile = File(pickedFile.path);
      final controller = VideoPlayerController.file(videoFile);
      await controller.initialize();

      setState(() {
        _selectedMedia.add(MediaItem(
          file: videoFile,
          type: MediaType.video,
          duration: controller.value.duration,
        ));

        if (_selectedMedia.length == 1) {
          _videoController = controller;
          _videoController?.play();
          _videoController?.setLooping(true);
        } else {
          controller.dispose();
        }
      });
    }
  }

  void _removeMedia(int index) {
    setState(() {
      if (_selectedMedia[index].type == MediaType.video &&
          _videoController != null &&
          index == _currentMediaIndex) {
        _videoController!.dispose();
        _videoController = null;
      }

      _selectedMedia.removeAt(index);

      if (_currentMediaIndex >= _selectedMedia.length) {
        _currentMediaIndex =
            _selectedMedia.isEmpty ? 0 : _selectedMedia.length - 1;
      }

      if (_selectedMedia.isNotEmpty &&
          _currentMediaIndex < _selectedMedia.length &&
          _selectedMedia[_currentMediaIndex].type == MediaType.video) {
        _initializeVideoController(_currentMediaIndex);
      }
    });
  }

  Future<void> _initializeVideoController(int index) async {
    if (_videoController != null) {
      await _videoController!.dispose();
    }

    if (_selectedMedia[index].type == MediaType.video) {
      _videoController = VideoPlayerController.file(_selectedMedia[index].file);
      await _videoController!.initialize();
      _videoController!.play();
      _videoController!.setLooping(true);
      setState(() {});
    } else {
      _videoController = null;
    }
  }

  void _changeMedia(int index) async {
    if (index == _currentMediaIndex) return;

    setState(() {
      _currentMediaIndex = index;
    });

    if (_selectedMedia[index].type == MediaType.video) {
      await _initializeVideoController(index);
    } else if (_videoController != null) {
      await _videoController!.dispose();
      _videoController = null;
      setState(() {});
    }
  }

  void _uploadPost() async {
    if (_selectedMedia.isEmpty) {
      Utility.customSnackbar(
        message: "Please select at least one image or video",
        typeInfo: Constants.ERROR,
        context: context,
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Utility.customSnackbar(
        message: "User not logged in",
        typeInfo: Constants.ERROR,
        context: context,
      );
      return;
    }

    final userId = user.uid;

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    if (_isStoryMode) {
      // Upload as story
      _uploadStory(userId);
    } else {
      // Upload as post
      context.read<PostUploadBloc>().add(
            PostUploadStartedEvent(
              media: _selectedMedia,
              userId: userId,
              caption: _captionController.text.trim(),
              location: _locationController.text.trim(),
              visibility: _visibility,
            ),
          );
    }
  }
  
  void _uploadStory(String userId) async {
    // Simulate story upload
    _simulateUploadProgress();
    
    // In a real app, you would use a StoryUploadBloc or similar
    // For this example, we'll just simulate the upload
    
    // After upload completes, show success message and navigate back
    // This is handled in _simulateUploadProgress()
  }

  void _simulateUploadProgress() {
    if (_uploadProgress < 1.0) {
      setState(() {
        _uploadProgress += 0.01;
      });
      Future.delayed(const Duration(milliseconds: 50), () {
        _simulateUploadProgress();
      });
    } else {
      setState(() {
        _isUploading = false;
      });

      // Show success message
      Utility.customSnackbar(
        message: _isStoryMode ? "Story uploaded successfully!" : "Post uploaded successfully!",
        typeInfo: Constants.SUCCESS,
        context: context,
      );

      // Navigate back or to home feed
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    }
  }
  
  void _toggleStoryMode() {
    setState(() {
      _isStoryMode = !_isStoryMode;
      
      // Clear selected media when switching modes
      if (_selectedMedia.isNotEmpty) {
        if (_videoController != null) {
          _videoController!.dispose();
          _videoController = null;
        }
        _selectedMedia.clear();
      }
      
      // Reset story text when switching to post mode
      if (!_isStoryMode) {
        _storyText = '';
        _isAddingTextToStory = false;
      }
    });
  }
  
  void _showStoryTextEditor() {
    setState(() {
      _isAddingTextToStory = true;
    });
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black87,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 20,
                left: 20,
                right: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      setModalState(() {
                        _storyText = value;
                      });
                      setState(() {});
                    },
                    style: TextStyle(
                      color: _storyTextColor,
                      fontSize: _storyTextSize,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Type something...',
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    cursorColor: Colors.white,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    autofocus: true,
                    controller: TextEditingController(text: _storyText),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Colors.white,
                        Colors.black,
                        Colors.red,
                        Colors.blue,
                        Colors.green,
                        Colors.yellow,
                        Colors.purple,
                        Colors.orange,
                      ].map((color) {
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              _storyTextColor = color;
                            });
                            setState(() {});
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _storyTextColor == color ? Colors.white : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Slider(
                    value: _storyTextSize,
                    min: 14.0,
                    max: 40.0,
                    activeColor: Colors.white,
                    inactiveColor: Colors.white30,
                    onChanged: (value) {
                      setModalState(() {
                        _storyTextSize = value;
                      });
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _storyText = '';
                            _isAddingTextToStory = false;
                          });
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Clear',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isAddingTextToStory = false;
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                        child: const Text('Done'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: _buildModeToggle(),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed:
                _selectedMedia.isEmpty || _isUploading ? null : _uploadPost,
            child: Text(
              _isStoryMode ? 'Share to Story' : 'Share',
              style: TextStyle(
                color: _selectedMedia.isEmpty || _isUploading
                    ? Colors.blue.shade200
                    : Colors.blue.shade600,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: BlocListener<PostUploadBloc, PostUploadState>(
        listener: (context, state) {
          if (state is PostUploadSuccessState) {
            Utility.customSnackbar(
              message: "Post uploaded successfully!",
              typeInfo: Constants.SUCCESS,
              context: context,
            );
            Navigator.pop(context);
          }
          if (state is PostUploadFailureState) {
            Utility.customSnackbar(
              message: state.errorMessage,
              typeInfo: Constants.ERROR,
              context: context,
            );
            setState(() {
              _isUploading = false;
            });
          }
          if (state is PostUploadProgressState) {
            setState(() {
              _uploadProgress = state.progress;
            });
          }
        },
        child: _isUploading ? _buildUploadingState() : 
                _isStoryMode ? _buildStoryUploadForm() : _buildPostUploadForm(),
      ),
    );
  }
  
  Widget _buildModeToggle() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: _isStoryMode ? _toggleStoryMode : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _isStoryMode ? Colors.transparent : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: _isStoryMode ? null : [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'Post',
                style: TextStyle(
                  color: _isStoryMode ? Colors.grey.shade700 : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: _isStoryMode ? null : _toggleStoryMode,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _isStoryMode ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                boxShadow: _isStoryMode ? [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ] : null,
              ),
              child: Text(
                'Story',
                style: TextStyle(
                  color: _isStoryMode ? Colors.black : Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _isStoryMode ? 'Uploading Story...' : 'Uploading Post...',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 200,
            child: LinearProgressIndicator(
              value: _uploadProgress,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
              minHeight: 10,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${(_uploadProgress * 100).toInt()}%',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostUploadForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Media preview section
          if (_selectedMedia.isEmpty)
            _buildEmptyMediaState()
          else
            _buildMediaPreview(),

          // Media selection buttons
          _buildMediaSelectionButtons(),

          const Divider(height: 1),

          // Caption and details section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Caption field
                CustomTextfield(
                  controller: _captionController,
                  title: "Caption",
                  hintText: "Write a caption...",
                  validator: (value) {},
                  keyboardType: TextInputType.text,
                ),

                const VerticalSpacing(height: 20),
                CustomTextfield(
                  controller: _locationController,
                  title: "Location",
                  hintText: "Add location",
                  prefixIcon: const Icon(Icons.location_on_outlined,
                      color: Colors.blue),
                  validator: (value) {},
                  keyboardType: TextInputType.text,
                ),

                const VerticalSpacing(height: 20),

                // Tag people button
                _buildOptionButton(
                  icon: Icons.person_add_outlined,
                  label: "Tag People",
                  onTap: () {
                    // Show tag people dialog/screen
                  },
                ),

                const VerticalSpacing(height: 16),

                // Visibility options
                const Text(
                  "Visibility",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 8),

                // Visibility radio buttons
                _buildVisibilityOptions(),

                const VerticalSpacing(height: 30),

                // Advanced settings section
                const Text(
                  "Advanced Settings",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 16),

                // Turn off comments option
                _buildSwitchOption(
                  icon: Icons.chat_bubble_outline,
                  label: "Turn Off Comments",
                  value: false,
                  onChanged: (value) {
                    // Handle turn off comments
                  },
                ),

                const SizedBox(height: 12),

                // Hide like count option
                _buildSwitchOption(
                  icon: Icons.favorite_border,
                  label: "Hide Like Count",
                  value: false,
                  onChanged: (value) {
                    // Handle hide like count
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStoryUploadForm() {
    return Column(
      children: [
        // Story media preview with text overlay
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Media preview
              if (_selectedMedia.isEmpty)
                Container(
                  color: Colors.black,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_camera_outlined,
                          size: 80,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Tap to add to your story",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (_selectedMedia[_currentMediaIndex].type == MediaType.image)
                Image.file(
                  _selectedMedia[_currentMediaIndex].file,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                )
              else if (_videoController != null && _videoController!.value.isInitialized)
                FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _videoController!.value.size.width,
                    height: _videoController!.value.size.height,
                    child: VideoPlayer(_videoController!),
                  ),
                ),
              
              // Text overlay
              if (_storyText.isNotEmpty)
                Center(
                  child: Text(
                    _storyText,
                    style: TextStyle(
                      color: _storyTextColor,
                      fontSize: _storyTextSize,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 3.0,
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              
              // Story editing tools
              Positioned(
                top: 16,
                right: 16,
                child: Column(
                  children: [
                    _buildStoryToolButton(
                      icon: Icons.text_fields,
                      onTap: _showStoryTextEditor,
                    ),
                    const SizedBox(height: 16),
                    _buildStoryToolButton(
                      icon: Icons.emoji_emotions_outlined,
                      onTap: () {
                        // Show emoji picker
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildStoryToolButton(
                      icon: Icons.brush_outlined,
                      onTap: () {
                        // Show drawing tools
                      },
                    ),
                  ],
                ),
              ),
              
              // Tap to add media if empty
              if (_selectedMedia.isEmpty)
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _showStoryMediaOptions,
                      splashColor: Colors.white24,
                      highlightColor: Colors.white10,
                    ),
                  ),
                ),
            ],
          ),
        ),
        
        // Bottom controls for story
        if (_selectedMedia.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    // Show story settings
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.settings_outlined,
                        color: Colors.grey.shade700,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Story Settings',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: _showStoryMediaOptions,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          color: Colors.blue.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Change Media',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
  
  void _showStoryMediaOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add to Your Story',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStoryMediaOption(
                      icon: Icons.photo_library_outlined,
                      label: 'Gallery',
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage();
                      },
                    ),
                    _buildStoryMediaOption(
                      icon: Icons.camera_alt_outlined,
                      label: 'Camera',
                      onTap: () {
                        Navigator.pop(context);
                        _takePhoto();
                      },
                    ),
                    _buildStoryMediaOption(
                      icon: Icons.videocam_outlined,
                      label: 'Video',
                      onTap: () {
                        Navigator.pop(context);
                        _pickVideo();
                      },
                    ),
                    _buildStoryMediaOption(
                      icon: Icons.video_camera_back_outlined,
                      label: 'Record',
                      onTap: () {
                        Navigator.pop(context);
                        _recordVideo();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildStoryMediaOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.blue.shade600,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStoryToolButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildEmptyMediaState() {
    return Container(
      height: 300,
      width: double.infinity,
      color: Colors.grey.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            "Select images or videos to share",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaPreview() {
    return Column(
      children: [
        // Main media preview
        Container(
          height: 350,
          width: double.infinity,
          color: Colors.black,
          child: _selectedMedia[_currentMediaIndex].type == MediaType.image
              ? Image.file(
                  _selectedMedia[_currentMediaIndex].file,
                  fit: BoxFit.contain,
                )
              : _videoController != null &&
                      _videoController!.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    )
                  : const Center(child: CircularProgressIndicator()),
        ),

        // Media thumbnails for multiple selections
        if (_selectedMedia.length > 1)
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _selectedMedia.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _changeMedia(index),
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _currentMediaIndex == index
                            ? Colors.blue.shade600
                            : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Thumbnail
                        _selectedMedia[index].type == MediaType.image
                            ? Image.file(
                                _selectedMedia[index].file,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color: Colors.black,
                                child: const Icon(
                                  Icons.play_circle_outline,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),

                        // Remove button
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => _removeMedia(index),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildMediaSelectionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildMediaButton(
            icon: Icons.photo_library_outlined,
            label: "Gallery",
            onTap: _pickImage,
          ),
          _buildMediaButton(
            icon: Icons.camera_alt_outlined,
            label: "Camera",
            onTap: _takePhoto,
          ),
          _buildMediaButton(
            icon: Icons.videocam_outlined,
            label: "Video",
            onTap: _pickVideo,
          ),
          _buildMediaButton(
            icon: Icons.video_camera_back_outlined,
            label: "Record",
            onTap: _recordVideo,
          ),
        ],
      ),
    );
  }

  Widget _buildMediaButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.blue.shade600,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.blue.shade600,
              size: 22,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisibilityOptions() {
    return Column(
      children: [
        _buildRadioOption(
          label: "Public",
          subtitle: "Anyone can see this post",
          value: "Public",
          groupValue: _visibility,
          onChanged: (value) {
            setState(() {
              _visibility = value!;
            });
          },
        ),
        _buildRadioOption(
          label: "Followers Only",
          subtitle: "Only your followers can see this post",
          value: "Followers",
          groupValue: _visibility,
          onChanged: (value) {
            setState(() {
              _visibility = value!;
            });
          },
        ),
        _buildRadioOption(
          label: "Close Friends",
          subtitle: "Only your close friends can see this post",
          value: "Close Friends",
          groupValue: _visibility,
          onChanged: (value) {
            setState(() {
              _visibility = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildRadioOption({
    required String label,
    required String subtitle,
    required String value,
    required String groupValue,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Radio<String>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            activeColor: Colors.blue.shade600,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchOption({
    required IconData icon,
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.blue.shade600,
          size: 22,
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        const Spacer(),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.blue.shade600,
        ),
      ],
    );
  }
}
