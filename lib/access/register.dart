import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                const SizedBox(height: 20),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                  ),
                ),
                const SizedBox(height: 20),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(height: 20),
                const TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                ),
                const SizedBox(height: 20),
                const TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Verify Password',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Implementar la funcionalidad de registro
                  },
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
