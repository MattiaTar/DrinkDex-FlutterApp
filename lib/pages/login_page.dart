import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  bool areFieldsValid = false;
  String defaultEmail = 'prof';
  String defaultPassword = '1234';

  void checkFieldsValidity() {
    if (emailController.text == defaultEmail &&
        passwordController.text == defaultPassword) {
      setState(() {
        areFieldsValid = true;
      });
    } else {
      setState(() {
        areFieldsValid = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_gas_station),
            Text(
              "DrinkDex",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.0),
            TextField(
              controller: emailController,
              onChanged: (value) {
                checkFieldsValidity();
              },
              decoration: InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        emailController.clear();
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30.0),
            TextField(
              controller: passwordController,
              onChanged: (value) {
                checkFieldsValidity();
              },
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              child: Text('Login'),
              onPressed: areFieldsValid
                  ? () {
                // Perform login logic here
                Navigator.pushReplacementNamed(context, '/HomePage');
              }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}