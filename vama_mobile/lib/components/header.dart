import 'package:flutter/material.dart';
import 'package:vama_mobile/theme/app_colors.dart';

class  Myheader  extends StatelessWidget {
  const  Myheader ({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.symmetric(horizontal: 5 , vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/login');
                },
                style: TextButton.styleFrom(
                  foregroundColor:AppColors.lightTextBlack,
                  backgroundColor: AppColors.buttonGrey,
                  padding: EdgeInsets.symmetric(horizontal: 10 , vertical: 5),
                ),
                child: Text("Zaloguj się"),
              ),

              SizedBox(width: 5),

              
              ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/signup');
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.lightTextWhite,
                  backgroundColor: AppColors.lightPrimary,
                  padding: EdgeInsets.symmetric(horizontal: 10 , vertical: 5),
                  
                ),
                child: Text("Zarejestruj się"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
