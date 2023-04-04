import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../models/photo_model.dart';

class PhotoItem extends StatelessWidget {
  const PhotoItem({
    super.key,
    required this.photo,
    required this.onTap,
    required this.isSelected,
  });

  final Photo photo;
  final bool isSelected;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SlideInDown(
        duration: const Duration(milliseconds: 750),
        child: AnimatedContainer(
          width: 150,
          margin: EdgeInsets.only(bottom: isSelected ? 16 : 0),
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: CachedNetworkImage(
              imageUrl: photo.url,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[300],
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  }
}
