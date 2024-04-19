import 'package:flutter/material.dart';

import 'LoginPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  Color buttonColor = const Color(0xFFE0D9CB);

  //Controllers for accessing the email and password Textfields
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  var _name = TextEditingController();

  //TODO Backend Register Function
  void register(){

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: buttonColor,
      body: Stack(
        children: [
          // Background Image at the top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: 50, // Adjust height as needed
              color: Colors.blue,
              child: Image.asset(
                'assets/cocktailHomePage.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Background Image at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Image.asset(
                'assets/cocktailHomePage.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),

          //Floating Login Text
          const Positioned(
            top: 150.0, // 25 padding below the top of the page
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Register',
                style: TextStyle(
                  fontSize: 50.0, // Adjust font size as needed
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),

          // Email and Password TextFields
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  controller: _emailController,
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Name',
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  controller: _name,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                const SizedBox(height: 20),

                //Login Button and Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: const Text(
                        'Have an account? Click here',
                        style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            fontSize: 16
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {register();},
                      child: const Text('Register'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
