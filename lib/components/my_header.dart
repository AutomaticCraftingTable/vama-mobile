import 'package:flutter/material.dart';

class  Myheader  extends StatelessWidget {
  const  Myheader ({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.symmetric(horizontal: 5 , vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          //Button for return to home
          IconButton(
            onPressed: () {
              throw UnimplementedError();
            },
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          ),

          Row(
            children: [

              //button login
              ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/login');
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.grey[300],
                  padding: EdgeInsets.symmetric(horizontal: 20 , vertical: 10),
                ),
                child: Text("Log in"),
              ),

              SizedBox(width: 10),

              //button signup
              ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/signUp');
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 20 , vertical: 10),
                ),
                child: Text("Sign up"),
              ),

              SizedBox(width: 10),
            ],
          ),
        ],
      ),
    );
  }
}
