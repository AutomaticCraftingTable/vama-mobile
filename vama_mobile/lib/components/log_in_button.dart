import 'package:flutter/material.dart';
import 'package:vama_mobile/theme/app_colors.dart';

class Mybutton extends StatelessWidget {

  final Function()? onTap;

  const Mybutton({super.key,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin:  const EdgeInsets.symmetric(horizontal: 25) ,
        decoration: BoxDecoration(
            color: AppColors.lightPrimary,
                borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
              "Zaloguj się",
               style: TextStyle(
                   color: AppColors.lightTextWhite,
                       fontWeight: FontWeight.bold,
                        fontSize: 16,
               ),
          ),
        ),
      ),
    );
  }
}
