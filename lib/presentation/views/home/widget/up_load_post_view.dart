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
      maxDuration: const Duration(minutes: 1),
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
      maxDuration: const Duration(minutes: 1),
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
        message: "Post uploaded successfully!",
        typeInfo: Constants.SUCCESS,
        context: context,
      );

      // Navigate back or to home feed
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'New Post',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed:
                _selectedMedia.isEmpty || _isUploading ? null : _uploadPost,
            child: Text(
              'Share',
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
        child: _isUploading ? _buildUploadingState() : _buildUploadForm(),
      ),
    );
  }

  Widget _buildUploadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Uploading Post...',
            style: TextStyle(
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

  Widget _buildUploadForm() {
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

