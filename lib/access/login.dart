import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spring_ud4_grupo1_app/access/register.dart';
import 'package:spring_ud4_grupo1_app/admin/adminView.dart';
import 'package:spring_ud4_grupo1_app/business/businessView.dart';

import '../services/userService.dart';
import '../student/studentView.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
  final email = _emailController.text;
  final password = _passwordController.text;
  final studentModel = await UserService().login(email, password);

  if (studentModel != null) {
    // if (studentModel.enabled == 1 || studentModel.deleted == 0) {
      switch (studentModel.role) {
        case "ROLE_STUDENT":
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StudentView(token: studentModel.token!)),
          );
          break;
        case "ROLE_BUSINESS":
          Navigator.push(
            context, MaterialPageRoute(builder: (context) => BusinessView(token: studentModel.token!)));
          break;
        case "ROLE_ADMIN":
          Navigator.push(context, MaterialPageRoute(builder: (context) => AdminView()));
          break;
        default:
          _showSnackBar("Rol not found", Icons.error, Colors.red);
          break;
      }
    } else {
      _showSnackBar("User not enabled or is deleted", Icons.error, Colors.red);
    }
  // } else {
  //   _showSnackBar("Error validating credentials", Icons.error, Colors.red);
  // }
}


  void _showSnackBar(String message, IconData icon, Color color) {
    final snackBar = SnackBar(
      content: Row(
        children: <Widget>[
          Icon(icon, color: color),
          const SizedBox(width: 20),
          Expanded(child: Text(message)),
        ],
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    // Establecer el estilo general de la barra de estado
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.blue.shade100,
              Colors.blue.shade300,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const FlutterLogo(size: 100),
                  // Image.asset('assets/imgs/Logo1.jpeg', width: 100, height: 100),
                  const SizedBox(height: 50),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                    ),
                    onPressed: _login,
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: const Text('Register'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
}
