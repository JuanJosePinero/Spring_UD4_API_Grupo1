import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spring_ud4_grupo1_app/access/login.dart';
import 'package:spring_ud4_grupo1_app/models/ProFamilyModel.dart';
import 'package:spring_ud4_grupo1_app/models/StudentModel.dart';
import 'package:spring_ud4_grupo1_app/services/proFamilyService.dart';
import 'package:spring_ud4_grupo1_app/services/userService.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _verifyPasswordController =
      TextEditingController();
  final UserService _userService = UserService();
  final ProFamilyService _proFamilyService = ProFamilyService();

  String _selectedProfession = '';
  List<ProFamilyModel> _professionalFamilies = [];
  ProFamilyModel? _registerWithProfession;

  @override
  void initState() {
    super.initState();
    _loadProfessionalFamilies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _verifyPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadProfessionalFamilies() async {
    try {
      final families =
          await _proFamilyService.getProfesionalFamiliesWithoutToken();
      setState(() {
        _professionalFamilies = families;
        _selectedProfession = _professionalFamilies.isNotEmpty
            ? _professionalFamilies.first.name ?? ''
            : '';
      });
    } catch (e) {
      print('Error loading professional families: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.blue.shade300,
        elevation: 0,
      ),
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildTextField(
                    controller: _nameController,
                    labelText: 'Name',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _usernameController,
                    labelText: 'Username',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<ProFamilyModel>(
                    value: _professionalFamilies.isNotEmpty
                        ? _professionalFamilies.first
                        : null,
                    decoration: InputDecoration(
                      labelText: 'Professional Family',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    onChanged: (ProFamilyModel? newValue) {
                      setState(() {
                        _selectedProfession = newValue?.name ?? '';
                      });
                    },
                    items: _professionalFamilies
                        .map<DropdownMenuItem<ProFamilyModel>>(
                            (ProFamilyModel value) {
                      return DropdownMenuItem<ProFamilyModel>(
                        value: value,
                        child: Text(value.name ?? ''),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    icon: Icons.lock,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _verifyPasswordController,
                    labelText: 'Verify Password',
                    icon: Icons.lock_outline,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                    ),
                    onPressed: _validateFields,
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

  Future<void> _validateFields() async {
    if (_nameController.text.isEmpty ||
        _nameController.text.length > 30 ||
        _usernameController.text.isEmpty ||
        _usernameController.text.length > 30 ||
        _selectedProfession.isEmpty ||
        _emailController.text.isEmpty ||
        _emailController.text.length > 30 ||
        _passwordController.text.isEmpty ||
        _passwordController.text.length > 30 ||
        _verifyPasswordController.text.isEmpty ||
        _verifyPasswordController.text.length > 30 ||
        _passwordController.text != _verifyPasswordController.text) {
      _showSnackBar(
          "Invalid credentials or empty fields", Icons.error, Colors.red);
    } else {
      try {
        final studentModel = StudentModel(
          name: _nameController.text,
          surname: _usernameController.text,
          username: _usernameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          profesionalFamily: getSelectedProfFamily(),
        );

        final registeredUser = await _userService.register(studentModel);

        if (registeredUser != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User created successfully'),
              duration: Duration(seconds: 4),
            ),
          );

          Future.delayed(const Duration(seconds: 4), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          });
        } else {
          _showSnackBar("User can't be created", Icons.error, Colors.red);
        }
      } catch (e) {
        _showSnackBar("Error registering: $e", Icons.error, Colors.red);
      }
    }
  }

  ProFamilyModel? getSelectedProfFamily() {
    return _professionalFamilies.firstWhere(
      (proFamily) => proFamily.name == _selectedProfession,
    );
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}
