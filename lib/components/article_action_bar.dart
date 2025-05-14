import 'package:flutter/material.dart';
import 'package:vama_mobile/theme/app_colors.dart';

class ArticleActionBar extends StatelessWidget {
  final bool isLiked;
  final int likeCount;
  final VoidCallback onLike;
  final VoidCallback onComment;

  const ArticleActionBar({
    super.key,
    required this.isLiked,
    required this.likeCount,
    required this.onLike,
    required this.onComment,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24), 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
        children: [
  
          Padding(
            padding: const EdgeInsets.only(left: 32), 
            child: FloatingActionButton(
              heroTag: "comment_button",
              onPressed: onComment,
              elevation: 2, 
              backgroundColor: AppColors.textPrimary,
              splashColor: AppColors.primary,
              highlightElevation: 0,
              child: Icon(Icons.comment, color: AppColors.text),
            ),
          ),
          Row(
            children: [
              
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7), 
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  "$likeCount",
                  style: const TextStyle(fontSize: 14, color: AppColors.text),
                ),
              ),
              const SizedBox(width: 8),
             
              FloatingActionButton(
                heroTag: "like_button",
                onPressed: onLike,
                elevation: 2,
                backgroundColor: AppColors.textPrimary,
                splashColor: AppColors.primary,
                highlightElevation: 0,
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? AppColors.like : AppColors.text,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
