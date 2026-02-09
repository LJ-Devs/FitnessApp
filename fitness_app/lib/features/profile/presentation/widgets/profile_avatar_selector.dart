import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileAvatarSelector extends StatelessWidget {
  final File? selectedImage;
  final String? photoUrl;
  final VoidCallback onTap;
  final bool isLoading;

  const ProfileAvatarSelector({
    super.key,
    this.selectedImage,
    this.photoUrl,
    required this.onTap,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: theme.colorScheme.primaryContainer,
            backgroundImage: selectedImage != null
                ? FileImage(selectedImage!) as ImageProvider
                : (photoUrl != null ? CachedNetworkImageProvider(photoUrl!) : null),
            child: (selectedImage == null && photoUrl == null)
                ? Icon(Icons.person, size: 60, color: theme.colorScheme.primary)
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: isLoading ? null : onTap,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: theme.colorScheme.primary,
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}