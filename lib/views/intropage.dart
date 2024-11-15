import 'package:apartment_manager_user/views/login.dart';
import 'package:flutter/material.dart';


class Intro extends StatelessWidget {
  const Intro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height, 
        child: const Image(
          image: AssetImage('assets/intro.jpeg'),
          fit: BoxFit.cover, 
        ),
      ),
      // floatingActionButton to navigate to the next screen
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(
          side: BorderSide(
            color: Colors.white,
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  const LoginPage()),
          );
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
