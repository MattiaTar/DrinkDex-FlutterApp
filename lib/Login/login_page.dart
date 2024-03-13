import 'package:bartolinimauri/Login/SecureStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bartolinimauri/Login/SecureStorage.dart';


/* implementare Scure storage per salvaguaradare i dati sensibili utente */

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
final storage = SecureStorage();
bool isPasswordVisible = false;
bool areFieldsValid = false;
bool? isChecked = false;

void checkFieldsValidity() {
  if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
    setState(() {
      areFieldsValid = true;
    });
  } else {
    setState(() {
      areFieldsValid = false;
    });
  }
}

void attemptLogin() {
  checkFieldsValidity();
  if (areFieldsValid) {
    String username = emailController.text;
    String password = passwordController.text;
    // Salvare le credenziali
    storage.writeSecureData('username', username);
    storage.writeSecureData('password', password);
    print('Username: $username, Password: $password');
  } else {
    print("Hai Bevuto troppo");
  }
   shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15),
  );
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
                SecureStorage()
                .writeSecureData('name', emailController.text );
                //devo leggerli
                Navigator.pushReplacementNamed(context, 'HomePage');
              }
                  : null,
            ),
            Checkbox(
              value: isChecked,
              activeColor: Colors.green,
              tristate: true,
              onChanged: (newBool) {
                setState(() {
                  isChecked = newBool;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}