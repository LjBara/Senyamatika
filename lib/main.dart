import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:async';
import 'dart:math';

// ============ USER DATA MANAGEMENT ============
class UserData {
  String name;
  String email;
  
  UserData({required this.name, required this.email});
  
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
    };
  }
  
  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
    );
  }
}

// Simple User Provider (for demo purposes)
class UserProvider {
  static UserData? _currentUser;
  
  static void setUser(UserData user) {
    _currentUser = user;
  }
  
  static UserData? getCurrentUser() {
    return _currentUser;
  }
  
  static String getUserName() {
    return _currentUser?.name.isNotEmpty == true ? _currentUser!.name : 'User';
  }
  
  static String getUserEmail() {
    return _currentUser?.email ?? '';
  }
}

void main() {
  runApp(const SenyaMatikaApp());
}

class SenyaMatikaApp extends StatelessWidget {
  const SenyaMatikaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SenyaMatika',
      theme: ThemeData(
        fontFamily: 'LondrinaSolid',
        primaryColor: Colors.yellow[600],
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const FrontPageScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2E9B8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: const AssetImage('assets/assetsmyimage.png'),
              height: 300,
            ),
            const SizedBox(height: 20),
            const Text(
              'SenyaMatika',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                fontFamily: 'LondrinaSolid',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============ FRONT PAGE SCREEN ============
class FrontPageScreen extends StatelessWidget {
  const FrontPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2E9B8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: const AssetImage('assets/assetsmyimage.png'),
              height: 250,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 30),
            const Text(
              'Senyamatika',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                fontFamily: 'LondrinaSolid',
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 80),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFF59D),
                  foregroundColor: Colors.black,
                  minimumSize: const Size(250, 60),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                    side: const BorderSide(
                      color: Colors.black,
                      width: 1,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateAccountScreen()),
                  );
                },
                child: const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'LondrinaSolid',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(250, 60),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                    side: const BorderSide(
                      color: Colors.black,
                      width: 1,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LogInScreen()),
                  );
                },
                child: const Text(
                  'Log In',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'LondrinaSolid',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============ CREATE ACCOUNT SCREEN ============
class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _createAccount() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a password'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Save user data
    UserProvider.setUser(UserData(name: name, email: email));

    // Simulate account creation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account created successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OptionSelectionScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2E9B8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2E9B8),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create Account',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'LondrinaSolid',
              ),
            ),
            const SizedBox(height: 40),
            
            _buildTextField(
              controller: _nameController,
              label: 'Name:',
              hintText: 'Enter your full name',
              prefixIcon: Icons.person,
            ),
            const SizedBox(height: 20),
            
            _buildTextField(
              controller: _emailController,
              label: 'Email/Username:',
              hintText: 'Enter your email or username',
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            
            _buildPasswordField(
              controller: _passwordController,
              label: 'Password:',
              hintText: 'Enter your password',
              isPasswordVisible: _isPasswordVisible,
              onToggleVisibility: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            const SizedBox(height: 20),
            
            _buildPasswordField(
              controller: _confirmPasswordController,
              label: 'Confirm Password:',
              hintText: 'Confirm your password',
              isPasswordVisible: _isConfirmPasswordVisible,
              onToggleVisibility: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
            ),
            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFF59D),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                    side: const BorderSide(
                      color: Colors.black,
                      width: 1,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                  ),
                ),
                onPressed: _createAccount,
                child: const Text(
                  'Create',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'LondrinaSolid',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'LondrinaSolid',
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              hintText: hintText,
              hintStyle: const TextStyle(
                fontFamily: 'LondrinaSolid',
              ),
              border: InputBorder.none,
              prefixIcon: Icon(prefixIcon, color: Colors.black),
            ),
            style: const TextStyle(
              fontFamily: 'LondrinaSolid',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required bool isPasswordVisible,
    required VoidCallback onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'LondrinaSolid',
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: !isPasswordVisible,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              hintText: hintText,
              hintStyle: const TextStyle(
                fontFamily: 'LondrinaSolid',
              ),
              border: InputBorder.none,
              prefixIcon: const Icon(Icons.lock, color: Colors.black),
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black,
                ),
                onPressed: onToggleVisibility,
              ),
            ),
            style: const TextStyle(
              fontFamily: 'LondrinaSolid',
            ),
          ),
        ),
      ],
    );
  }
}

// ============ LOG IN SCREEN ============
class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  void _logIn() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email/username'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your password'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // For demo purposes, create a dummy user
    UserProvider.setUser(UserData(
      name: email.split('@').first,
      email: email,
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged in successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OptionSelectionScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2E9B8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2E9B8),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Welcome Back!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'LondrinaSolid',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Sign In to Continue',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'LondrinaSolid',
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 40),
            
            _buildTextField(
              controller: _emailController,
              label: 'Email/Username:',
              hintText: 'Enter your email or username',
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            
            _buildPasswordField(
              controller: _passwordController,
              label: 'Password:',
              hintText: 'Enter your password',
              isPasswordVisible: _isPasswordVisible,
              onToggleVisibility: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            const SizedBox(height: 10),
            
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                  );
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'LondrinaSolid',
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFF59D),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                    side: const BorderSide(
                      color: Colors.black,
                      width: 1,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                  ),
                ),
                onPressed: _logIn,
                child: const Text(
                  'Log In',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'LondrinaSolid',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'LondrinaSolid',
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              hintText: hintText,
              hintStyle: const TextStyle(
                fontFamily: 'LondrinaSolid',
              ),
              border: InputBorder.none,
              prefixIcon: Icon(prefixIcon, color: Colors.black),
            ),
            style: const TextStyle(
              fontFamily: 'LondrinaSolid',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required bool isPasswordVisible,
    required VoidCallback onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'LondrinaSolid',
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: !isPasswordVisible,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              hintText: hintText,
              hintStyle: const TextStyle(
                fontFamily: 'LondrinaSolid',
              ),
              border: InputBorder.none,
              prefixIcon: const Icon(Icons.lock, color: Colors.black),
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black,
                ),
                onPressed: onToggleVisibility,
              ),
            ),
            style: const TextStyle(
              fontFamily: 'LondrinaSolid',
            ),
          ),
        ),
      ],
    );
  }
}

// ============ FORGOT PASSWORD SCREEN ============
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  void _sendResetLink() {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email address'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password reset link sent to your email!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2E9B8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2E9B8),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text(
              'Forgot Password?',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'LondrinaSolid',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Enter your email address and we\'ll send you a link to reset your password.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'LondrinaSolid',
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 40),
            
            Text(
              'Enter your email address:',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'LondrinaSolid',
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  hintText: 'Your Email',
                  hintStyle: const TextStyle(
                    fontFamily: 'LondrinaSolid',
                  ),
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.email, color: Colors.black),
                ),
                style: const TextStyle(
                  fontFamily: 'LondrinaSolid',
                ),
              ),
            ),
            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFF59D),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                    side: const BorderSide(
                      color: Colors.black,
                      width: 1,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                  ),
                ),
                onPressed: _sendResetLink,
                child: const Text(
                  'Send',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'LondrinaSolid',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============ OPTION SELECTION SCREEN ============
class OptionSelectionScreen extends StatelessWidget {
  const OptionSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2E9B8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('assets/assetsmyimage.png'),
              height: 300,
            ),
            const SizedBox(height: 20),
            const Text(
              'SenyaMatika',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                fontFamily: 'LondrinaSolid',
              ),
            ),
            const SizedBox(height: 40),
            
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFF59D),
                foregroundColor: Colors.black,
                minimumSize: const Size(250, 60),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                  side: const BorderSide(
                    color: Colors.black,
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DashboardScreen()),
                );
              },
              child: const Text(
                'Learning Space',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'LondrinaThin',
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: const Size(250, 60),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                  side: const BorderSide(
                    color: Colors.black,
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignLanguageAvatarScreen()),
                );
              },
              child: const Text(
                'Avatar Translator',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'LondrinaThin',
                  color: Color(0xCC000000),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// DASHBOARD SCREEN - UPDATED
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    final bool isSmallScreen = screenHeight < 700;
    final double buttonHeight = isSmallScreen ? 100 : 120;
    final double iconSize = isSmallScreen ? 32 : 40;
    final double buttonTextSize = isSmallScreen ? 16 : 18;
    final double verticalSpacing = isSmallScreen ? 10 : 15;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF0EAD6),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Hello',
                      style: TextStyle(
                        fontSize: 28,
                        fontFamily: 'LondrinaSolid',
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      UserProvider.getUserName(),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'LondrinaSolid',
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Features',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'LondrinaSolid',
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
            
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double availableWidth = constraints.maxWidth - 40;
                  final double buttonSpacing = 15;
                  final double buttonWidth = (availableWidth - buttonSpacing) / 2;
                  
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: buttonWidth,
                                  height: buttonHeight,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF8E97FD),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.black, width: 1),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(12),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const TopicsScreen()),
                                          );
                                        },
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.menu_book, size: iconSize, color: Colors.black),
                                              SizedBox(height: verticalSpacing / 2),
                                              Text(
                                                'Topics',
                                                style: TextStyle(
                                                  fontSize: buttonTextSize,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'LondrinaSolid',
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: buttonSpacing),
                                
                                SizedBox(
                                  width: buttonWidth,
                                  height: buttonHeight,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFC4B1E1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.black, width: 1),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(12),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const ProgressScreen()),
                                          );
                                        },
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.trending_up, size: iconSize, color: Colors.black),
                                              SizedBox(height: verticalSpacing / 2),
                                              Text(
                                                'Progress',
                                                style: TextStyle(
                                                  fontSize: buttonTextSize,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'LondrinaSolid',
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: verticalSpacing),
                            
                            Row(
                              children: [
                                SizedBox(
                                  width: buttonWidth,
                                  height: buttonHeight,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE9C46A),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.black, width: 1),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(12),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const SignDictionaryScreen()),
                                          );
                                        },
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.sign_language, size: iconSize, color: Colors.black),
                                              SizedBox(height: verticalSpacing / 2),
                                              Text(
                                                'Sign\nDictionary',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: buttonTextSize,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'LondrinaSolid',
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: buttonSpacing),
                                
                                SizedBox(
                                  width: buttonWidth,
                                  height: buttonHeight,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFA8E6CF),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.black, width: 1),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(12),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const SignLanguageAvatarScreen()),
                                          );
                                        },
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.face, size: iconSize, color: Colors.black),
                                              SizedBox(height: verticalSpacing / 2),
                                              Text(
                                                'Sign Language\nAvatar',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: buttonTextSize,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'LondrinaSolid',
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: verticalSpacing * 2),
                      ],
                    ),
                  );
                },
              ),
            ),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.black, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      blurRadius: 6,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF59D),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      child: Icon(Icons.home, size: isSmallScreen ? 24 : 28, color: Colors.black),
                    ),
                    
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ProfileScreen()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: Icon(Icons.account_circle, size: isSmallScreen ? 24 : 28, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignLanguageAvatarScreen extends StatefulWidget {
  const SignLanguageAvatarScreen({super.key});

  @override
  State<SignLanguageAvatarScreen> createState() => _SignLanguageAvatarScreenState();
}

class _SignLanguageAvatarScreenState extends State<SignLanguageAvatarScreen> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _recognizedText = '';
  final TextEditingController _textController = TextEditingController();
  bool _speechAvailable = false;
  bool _isInitializing = true;
  Timer? _listeningTimer;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      _initSpeech();
    });
  }

  Future<void> _initSpeech() async {
    try {
      _speechAvailable = await _speech.initialize(
        onStatus: (status) {
          setState(() {
            _isListening = _speech.isListening;
          });
          
          if (status == 'done' || status == 'notListening') {
            setState(() {
              _isListening = false;
            });
            _cancelTimer();
          }
        },
        onError: (errorNotification) {
          setState(() {
            _isListening = false;
          });
          _cancelTimer();
        },
        debugLogging: true,
      );
      
      setState(() {
        _isInitializing = false;
      });
      
    } catch (e) {
      setState(() {
        _speechAvailable = false;
        _isInitializing = false;
      });
    }
  }

  void _startListeningTimer() {
    _cancelTimer();
    
    _listeningTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (timer.tick == 1) {
        _showReminderSnackBar('Still listening...');
      } else if (timer.tick == 2) {
        _showReminderSnackBar('Still listening...');
      } else if (timer.tick == 5) {
        _showReminderSnackBar('Still listening...');
      } else if (timer.tick == 9) {
        _showReminderSnackBar('Speaking will auto-stop soon');
      }
    });
    
    Future.delayed(const Duration(minutes: 5), () {
      if (_isListening) {
        _showReminderSnackBar('Stopping speech recognition.');
        _stopListening();
      }
    });
  }

  void _cancelTimer() {
    if (_listeningTimer != null) {
      _listeningTimer!.cancel();
      _listeningTimer = null;
    }
  }

  Future<void> _stopListening() async {
    if (_isListening) {
      await _speech.stop();
      setState(() {
        _isListening = false;
      });
      _cancelTimer();
    }
  }

  Future<void> _toggleListening() async {
    if (!_speechAvailable) {
      setState(() {
        _isInitializing = true;
      });
      
      await _initSpeech();
      
      if (!_speechAvailable) {
        _showErrorSnackBar('Speech recognition is not available');
        return;
      }
    }
    
    if (_isListening) {
      await _stopListening();
    } else {
      if (!_speech.isAvailable) {
        bool initialized = await _speech.initialize();
        if (!initialized) {
          _showErrorSnackBar('Failed to initialize speech recognition');
          return;
        }
      }
      
      try {
        setState(() {
          _recognizedText = '';
          _textController.clear();
        });
        
        final options = stt.SpeechListenOptions(
          cancelOnError: true,
          partialResults: true,
          onDevice: false,
          listenMode: stt.ListenMode.confirmation,
        );
        
        await _speech.listen(
          onResult: (result) {
            if (result.recognizedWords.isNotEmpty) {
              setState(() {
                _recognizedText = result.recognizedWords;
                _textController.text = _recognizedText;
              });
              
              if (result.confidence > 0.7) {
                _playAvatarAnimation(result.recognizedWords);
              }
            }
          },
          listenFor: const Duration(minutes: 5),
          pauseFor: const Duration(seconds: 10),
          localeId: 'en-US',
          listenOptions: options,
        );
        
        setState(() {
          _isListening = true;
        });
        
        _startListeningTimer();
        
        _showReminderSnackBar('Listening started.');
        
      } catch (e) {
        setState(() {
          _isListening = false;
        });
        _cancelTimer();
      }
    }
  }

  void _sendText() {
    if (_textController.text.trim().isNotEmpty) {
      _playAvatarAnimation(_textController.text.trim());
    } else {
      _showErrorSnackBar('Please enter or speak some text first');
    }
  }

  void _playAvatarAnimation(String text) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Translating to sign language: "$text"'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showReminderSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.blue,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EAD6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF0EAD6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Sign Language Avatar',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'LondrinaSolid',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            Expanded(
              child: Center(
                child: Stack(
                  children: [
                    SizedBox(
                      width: 250,
                      height: 250,
                      child: Image.asset(
                        'assets/images/avatar.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(
                                Icons.person,
                                size: 80,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    
                    if (_isInitializing)
                      Positioned.fill(
                        child: Container(
                          color: Color.fromRGBO(0, 0, 0, 0.3),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: Colors.yellow,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Initializing speech...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    
                    if (_isListening)
                      Positioned.fill(
                        child: Container(
                          color: Color.fromRGBO(0, 0, 0, 0.3),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                  color: Colors.red.withAlpha((0.8 * 255).round()),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.mic,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Listening...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                
                                if (_recognizedText.isNotEmpty)
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(0, 0, 0, 0.5),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '"$_recognizedText"',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            if (_isInitializing || _isListening)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: _isInitializing ? Colors.orange : Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(
                      _isInitializing 
                        ? 'Initializing speech...' 
                        : 'Listening...',
                      style: TextStyle(
                        color: _isInitializing ? Colors.orange : Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.black12),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: _speechAvailable 
                              ? 'Type or speak...' 
                              : 'Speech not available. Type here...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: _speechAvailable ? Colors.grey : Colors.grey[400],
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _recognizedText = value;
                          });
                        },
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            _sendText();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    
                    if (_textController.text.trim().isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.blue),
                        onPressed: _sendText,
                        tooltip: 'Translate text',
                      ),
                    
                    IconButton(
                      icon: Icon(
                        _isListening ? Icons.mic_off : Icons.mic,
                        color: _isListening ? Colors.red : 
                               _speechAvailable ? Colors.blue : Colors.grey,
                        size: 28,
                      ),
                      onPressed: _speechAvailable ? _toggleListening : null,
                      tooltip: _isListening 
                        ? 'Stop listening' 
                        : 'Start speaking',
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
              child: Text(
                _speechAvailable 
                    ? 'Tap the microphone and speak'
                    : 'Speech recognition is not available. Please type your text.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _speechAvailable ? Colors.green : Colors.orange,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_isListening) {
      _speech.stop();
    }
    _cancelTimer();
    _textController.dispose();
    super.dispose();
  }
}

// NUMBER VALUES LESSONS SCREEN
class NumberValuesLessonsScreen extends StatelessWidget {
  const NumberValuesLessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EAD6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0EAD6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Number Values Lessons',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'LondrinaSolid',
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildClickableLessonItem(
              'Whole Numbers', 
              const Color(0xFFA8D5E3),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VideoLessonScreen(
                    lessonName: 'Whole Numbers',
                    language: 'English',
                    subLessonIndex: 0,
                  )),
                );
              },
            ),
            const SizedBox(height: 15),
            
            _buildLockedLessonItem('Comparison', const Color(0xFFF5C6D6)),
            const SizedBox(height: 15),
            
            _buildLockedLessonItem('Ordinal Numbers', const Color(0xFFC4B1E1)),
            const SizedBox(height: 15),
            
            _buildLockedLessonItem('Money Value', const Color(0xFFA8D5BA)),
          ],
        ),
      ),
    );
  }

  Widget _buildClickableLessonItem(String lessonName, Color boxColor, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                lessonName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'LondrinaSolid',
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.black),
          ],
        ),
      ),
    );
  }

  Widget _buildLockedLessonItem(String lessonName, Color boxColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              lessonName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'LondrinaSolid',
                color: Colors.black54,
              ),
            ),
          ),
          const Icon(Icons.lock, size: 20, color: Colors.black54),
        ],
      ),
    );
  }
}

// FRACTION LESSONS SCREEN
class FractionLessonsScreen extends StatelessWidget {
  const FractionLessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EAD6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0EAD6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Fraction Lessons',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'LondrinaSolid',
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLessonItem('Concepts of Fractions', const Color(0xFFA8D5E3), isClickable: true),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonItem(String lessonName, Color boxColor, {bool isClickable = true}) {
    return GestureDetector(
      onTap: isClickable ? () {
        // Add navigation here if needed
      } : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              lessonName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'LondrinaSolid',
                color: isClickable ? Colors.black : Colors.black54,
              ),
            ),
            if (!isClickable)
              const Icon(Icons.lock, size: 20, color: Colors.black54)
            else
              const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.black),
          ],
        ),
      ),
    );
  }
}

// FUNDAMENTAL OPERATIONS LESSONS SCREEN
class FundamentalOperationsLessonsScreen extends StatelessWidget {
  const FundamentalOperationsLessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EAD6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0EAD6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Fundamental Operations Lessons',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'LondrinaSolid',
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLessonItem('Addition', const Color(0xFFA8D5E3), isClickable: true),
            const SizedBox(height: 15),
            _buildLessonItem('Subtraction', const Color(0xFFF5C6D6), isClickable: false),
            const SizedBox(height: 15),
            _buildLessonItem('Multiplication', const Color(0xFFC4B1E1), isClickable: false),
            const SizedBox(height: 15),
            _buildLessonItem('Division', const Color(0xFFA8D5BA), isClickable: false),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonItem(String lessonName, Color boxColor, {bool isClickable = true}) {
    return GestureDetector(
      onTap: isClickable ? () {
        // Add navigation here if needed
      } : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              lessonName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'LondrinaSolid',
                color: isClickable ? Colors.black : Colors.black54,
              ),
            ),
            if (!isClickable)
              const Icon(Icons.lock, size: 20, color: Colors.black54)
            else
              const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.black),
          ],
        ),
      ),
    );
  }
}

// DECIMAL NUMBERS LESSONS SCREEN
class DecimalNumbersLessonsScreen extends StatelessWidget {
  const DecimalNumbersLessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EAD6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0EAD6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Decimal Numbers Lessons',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'LondrinaSolid',
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLessonItem('Basic Concepts of Decimal Numbers', const Color(0xFFA8D5E3), isClickable: true),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonItem(String lessonName, Color boxColor, {bool isClickable = true}) {
    return GestureDetector(
      onTap: isClickable ? () {
        // Add navigation here if needed
      } : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              lessonName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'LondrinaSolid',
                color: isClickable ? Colors.black : Colors.black54,
              ),
            ),
            if (!isClickable)
              const Icon(Icons.lock, size: 20, color: Colors.black54)
            else
              const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.black),
          ],
        ),
      ),
    );
  }
}

// PERCENTAGE LESSONS SCREEN
class PercentageLessonsScreen extends StatelessWidget {
  const PercentageLessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EAD6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0EAD6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Percentage Lessons',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'LondrinaSolid',
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLessonItem('Concepts of Percentage', const Color(0xFFA8D5E3), isClickable: true),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonItem(String lessonName, Color boxColor, {bool isClickable = true}) {
    return GestureDetector(
      onTap: isClickable ? () {
        // Add navigation here if needed
      } : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              lessonName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'LondrinaSolid',
                color: isClickable ? Colors.black : Colors.black54,
              ),
            ),
            if (!isClickable)
              const Icon(Icons.lock, size: 20, color: Colors.black54)
            else
              const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.black),
          ],
        ),
      ),
    );
  }
}

// MENSURATION LESSONS SCREEN
class MensurationLessonsScreen extends StatelessWidget {
  const MensurationLessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EAD6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0EAD6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Mensuration Lessons',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'LondrinaSolid',
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLessonItem('Time', const Color(0xFFA8D5E3), isClickable: true),
            const SizedBox(height: 15),
            _buildLessonItem('Days, Weeks, and Months', const Color(0xFFF5C6D6), isClickable: false),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonItem(String lessonName, Color boxColor, {bool isClickable = true}) {
    return GestureDetector(
      onTap: isClickable ? () {
        // Add navigation here if needed
      } : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              lessonName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'LondrinaSolid',
                color: isClickable ? Colors.black : Colors.black54,
              ),
            ),
            if (!isClickable)
              const Icon(Icons.lock, size: 20, color: Colors.black54)
            else
              const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.black),
          ],
        ),
      )
    );
  }
}

// PROGRESS SCREEN
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EAD6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0EAD6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Your Progress',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'LondrinaSolid',
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'LondrinaSolid',
                ),
              ),
              const Text(
                'Progress',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'LondrinaSolid',
                ),
              ),
              const SizedBox(height: 20),
              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFA8D5BA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Overall Progress',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'LondrinaSolid',
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                        ),
                        
                        Container(
                          width: (75 / 100) * (MediaQuery.of(context).size.width - 80),
                          height: 20,
                          decoration: BoxDecoration(
                            color: const Color(0xFF6B8E6B),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        
                        Positioned(
                          right: 10,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: Text(
                              '75%',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'LondrinaSolid',
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LessonsProgressScreen()),
                        );
                      },
                      child: Container(
                        height: 140,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5C6D6),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Lessons',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'LondrinaSolid',
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'In Progress',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'LondrinaSolid',
                              ),
                            ),
                            const SizedBox(height: 8),
                            
                            Center(
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black, width: 2),
                                ),
                                child: const Center(
                                  child: Text(
                                    '4',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'LondrinaSolid',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const QuizzesProgressScreen()),
                        );
                      },
                      child: Container(
                        height: 140,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC4B1E1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Quizzes',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'LondrinaSolid',
                              ),
                            ),
                            const SizedBox(height: 8),
                            
                            Center(
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black, width: 2),
                                ),
                                child: const Center(
                                  child: Text(
                                    '7',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'LondrinaSolid',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// LESSONS PROGRESS DETAILS SCREEN
class LessonsProgressScreen extends StatelessWidget {
  const LessonsProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EAD6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0EAD6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Lessons Progress',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'LondrinaSolid',
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Lessons',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'LondrinaSolid',
              ),
            ),
            const Text(
              'Progress',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'LondrinaSolid',
              ),
            ),
            const SizedBox(height: 30),
            
            _buildProgressItem(context, 'Whole Numbers', 90, const Color(0xFFA8D5E3)),
            const SizedBox(height: 15),
            _buildProgressItem(context, 'Comparison', 0, const Color(0xFFF5C6D6)),
            const SizedBox(height: 15),
            _buildProgressItem(context, 'Ordinal Numbers', 0, const Color(0xFFC4B1E1)),
            const SizedBox(height: 15),
            _buildProgressItem(context, 'Money Value', 0, const Color(0xFFA8D5BA)),
            const SizedBox(height: 15),
            _buildProgressItem(context, 'Addition', 0, const Color(0xFFFFD8A8)),
            const SizedBox(height: 15),
            _buildProgressItem(context, 'Subtraction', 0, const Color(0xFFD8A8FF)),
            const SizedBox(height: 15),
            _buildProgressItem(context, 'Multiplication', 0, const Color(0xFFA8E3B5)),
            const SizedBox(height: 15),
            _buildProgressItem(context, 'Division', 0, const Color(0xFFF5A8A8)),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressItem(BuildContext context, String title, int percentage, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'LondrinaSolid',
                ),
              ),
              Text(
                '$percentage%',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'LondrinaSolid',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black, width: 1),
                ),
              ),
              Container(
                width: (percentage / 100) * (MediaQuery.of(context).size.width - 80),
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFF6B8E6B),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// QUIZZES PROGRESS DETAILS SCREEN
class QuizzesProgressScreen extends StatelessWidget {
  const QuizzesProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EAD6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0EAD6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Quizzes Scores',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'LondrinaSolid',
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Scores',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'LondrinaSolid',
              ),
            ),
            const SizedBox(height: 30),
            
            _buildQuizScoreItem('Number Values', const Color(0xFFA8D5E3)),
            const SizedBox(height: 15),
            _buildQuizScoreItem('Fundamental Operations', const Color(0xFFF5C6D6)),
            const SizedBox(height: 15),
            _buildQuizScoreItem('Fraction', const Color(0xFFC4B1E1)),
            const SizedBox(height: 15),
            _buildQuizScoreItem('Decimal Numbers', const Color(0xFFFFD8A8)),
            const SizedBox(height: 15),
            _buildQuizScoreItem('Percentage', const Color(0xFFA8E3B5)),
            const SizedBox(height: 15),
            _buildQuizScoreItem('Mensuration', const Color(0xFFD8A8FF)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizScoreItem(String title, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'LondrinaSolid',
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.black),
        ],
      ),
    );
  }
}

// TOPICS SCREEN
class TopicsScreen extends StatelessWidget {
  const TopicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EAD6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0EAD6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Topics',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'LondrinaSolid',
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NumberValuesLessonsScreen()),
                  );
                },
                child: _buildTopicItem(
                  'Number Values', 
                  const Color(0xFFA8D5E3),
                  Center(
                    child: Image.asset(
                      'assets/images/number values logo.png',
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FundamentalOperationsLessonsScreen()),
                  );
                },
                child: _buildTopicItem(
                  'Fundamental Operations', 
                  const Color(0xFFF5C6D6),
                  Center(
                    child: Image.asset(
                      'assets/images/fundamental operations.png',
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FractionLessonsScreen()),
                  );
                },
                child: _buildTopicItem(
                  'Fraction', 
                  const Color(0xFFC4B1E1),
                  Center(
                    child: Image.asset(
                      'assets/images/fraction.png',
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DecimalNumbersLessonsScreen()),
                  );
                },
                child: _buildTopicItem(
                  'Decimal Numbers', 
                  const Color(0xFFFFD8A8),
                  Center(
                    child: Image.asset(
                      'assets/images/decimal numbers.png',
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PercentageLessonsScreen()),
                  );
                },
                child: _buildTopicItem(
                  'Percentage', 
                  const Color(0xFFA8E3B5),
                  Center(
                    child: Image.asset(
                      'assets/images/percentage.png',
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MensurationLessonsScreen()),
                  );
                },
                child: _buildTopicItem(
                  'Mensuration', 
                  const Color(0xFFD8A8FF),
                  Center(
                    child: Image.asset(
                      'assets/images/mensuration.png',
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopicItem(String topicName, Color boxColor, Widget content) {
    return Container(
      width: 330,
      height: 187,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            topicName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'LondrinaSolid',
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: content,
          ),
        ],
      ),
    );
  }
}



// ENHANCED NUMBER VALUES QUIZ SCREEN - 20 ITEMS
class NumberValuesQuizScreen extends StatefulWidget {
  const NumberValuesQuizScreen({super.key});

  @override
  State<NumberValuesQuizScreen> createState() => _NumberValuesQuizScreenState();
}

class _NumberValuesQuizScreenState extends State<NumberValuesQuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _quizCompleted = false;
  List<bool> _answeredQuestions = List.generate(20, (index) => false);
  List<int?> _selectedAnswers = List.generate(20, (index) => null);

  final List<QuizQuestion> _questions = [
    QuizQuestion(
      question: "What number comes AFTER 7?",
      options: ["6", "7", "8", "9"],
      correctAnswer: 2,
      imageAsset: "assets/images/number_7.png",
    ),
    QuizQuestion(
      question: "How many fingers are showing?",
      options: ["3", "4", "5", "6"],
      correctAnswer: 2,
      imageAsset: "assets/images/fingers_5.png",
    ),
    QuizQuestion(
      question: "What is 2 + 3?",
      options: ["4", "5", "6", "7"],
      correctAnswer: 1,
      imageAsset: "assets/images/addition_2_3.png",
    ),
    QuizQuestion(
      question: "Count the stars. How many are there?",
      options: ["4", "5", "6", "7"],
      correctAnswer: 1,
      imageAsset: "assets/images/stars_5.png",
    ),
    QuizQuestion(
      question: "Which number is BIGGER?",
      options: ["9", "12", "7", "10"],
      correctAnswer: 1,
      imageAsset: "assets/images/number_comparison.png",
    ),
    QuizQuestion(
      question: "What number is this?",
      options: ["10", "12", "15", "20"],
      correctAnswer: 0,
      imageAsset: "assets/images/number_10.png",
    ),
    QuizQuestion(
      question: "Which number represents this amount?",
      options: ["8", "9", "10", "11"],
      correctAnswer: 0,
      imageAsset: "assets/images/count_8.png",
    ),
    QuizQuestion(
      question: "What is 15 - 6?",
      options: ["7", "8", "9", "10"],
      correctAnswer: 2,
      imageAsset: "assets/images/subtraction_15_6.png",
    ),
    QuizQuestion(
      question: "Which set has MORE items?",
      options: ["LEFT", "RIGHT", "EQUAL", "CAN'T TELL"],
      correctAnswer: 1,
      imageAsset: "assets/images/more_items.png",
    ),
    QuizQuestion(
      question: "What number is MISSING: 4, 8, 12, ?",
      options: ["14", "16", "18", "20"],
      correctAnswer: 1,
      imageAsset: "assets/images/number_pattern.png",
    ),
    QuizQuestion(
      question: "If you have 5 apples and get 3 more, how many total?",
      options: ["6", "7", "8", "9"],
      correctAnswer: 2,
      imageAsset: "assets/images/apples_addition.png",
    ),
    QuizQuestion(
      question: "What is 3 × 4?",
      options: ["10", "12", "14", "16"],
      correctAnswer: 1,
      imageAsset: "assets/images/multiplication_3_4.png",
    ),
    QuizQuestion(
      question: "Share 10 candies equally between 2 friends. How many each?",
      options: ["3", "4", "5", "6"],
      correctAnswer: 2,
      imageAsset: "assets/images/sharing_candies.png",
    ),
    QuizQuestion(
      question: "What is 20 ÷ 4?",
      options: ["3", "4", "5", "6"],
      correctAnswer: 2,
      imageAsset: "assets/images/division_20_4.png",
    ),
    QuizQuestion(
      question: "Which number is SMALLER: 25 or 52?",
      options: ["25", "52", "EQUAL", "CAN'T TELL"],
      correctAnswer: 0,
      imageAsset: "assets/images/number_comparison_25_52.png",
    ),
    QuizQuestion(
      question: "What is the next EVEN number after 14?",
      options: ["15", "16", "17", "18"],
      correctAnswer: 1,
      imageAsset: "assets/images/even_numbers.png",
    ),
    QuizQuestion(
      question: "How many TENS in 35?",
      options: ["2", "3", "4", "5"],
      correctAnswer: 1,
      imageAsset: "assets/images/tens_ones.png",
    ),
    QuizQuestion(
      question: "What number is 10 MORE than 27?",
      options: ["35", "36", "37", "38"],
      correctAnswer: 2,
      imageAsset: "assets/images/10_more.png",
    ),
    QuizQuestion(
      question: "Arrange from SMALLEST to LARGEST: 19, 7, 32",
      options: ["7,19,32", "19,7,32", "32,19,7", "7,32,19"],
      correctAnswer: 0,
      imageAsset: "assets/images/ordering_numbers.png",
    ),
    QuizQuestion(
      question: "What is DOUBLE 8?",
      options: ["14", "16", "18", "20"],
      correctAnswer: 1,
      imageAsset: "assets/images/double_8.png",
    ),
  ];

  void _answerQuestion(int selectedIndex) {
    if (!_answeredQuestions[_currentQuestionIndex]) {
      setState(() {
        _answeredQuestions[_currentQuestionIndex] = true;
        _selectedAnswers[_currentQuestionIndex] = selectedIndex;
        
        if (selectedIndex == _questions[_currentQuestionIndex].correctAnswer) {
          _score++;
        }
      });
    }
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      setState(() {
        _quizCompleted = true;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _quizCompleted = false;
      _answeredQuestions = List.generate(20, (index) => false);
      _selectedAnswers = List.generate(20, (index) => null);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_quizCompleted) {
      return _buildResultsScreen();
    }

    final currentQuestion = _questions[_currentQuestionIndex];
    final isAnswered = _answeredQuestions[_currentQuestionIndex];
    final selectedAnswer = _selectedAnswers[_currentQuestionIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF0EAD6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0EAD6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Number Values Quiz',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'LondrinaSolid',
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${_currentQuestionIndex + 1}/20',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'LondrinaSolid',
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 24),
                    const SizedBox(width: 5),
                    Text(
                      '$_score',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'LondrinaSolid',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(20, (index) {
                return Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: index <= _currentQuestionIndex 
                        ? const Color(0xFF6B8E6B) 
                        : Colors.grey[300],
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                    blurRadius: 6,
                    offset: const Offset(3, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    currentQuestion.question,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'LondrinaSolid',
                    ),
                  ),
                  const SizedBox(height: 20),

                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: currentQuestion.imageAsset != null 
                        ? Image.asset(
                            currentQuestion.imageAsset!,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(Icons.help_outline, size: 60, color: Colors.grey),
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              currentQuestion.question,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'LondrinaSolid',
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 25),

                  Column(
                    children: currentQuestion.options.asMap().entries.map((entry) {
                      final index = entry.key;
                      final option = entry.value;
                      final isCorrect = index == currentQuestion.correctAnswer;
                      final isSelected = selectedAnswer == index;
                      
                      Color backgroundColor = Colors.white;
                      Color borderColor = Colors.black;
                      
                      if (isAnswered) {
                        if (isSelected && isCorrect) {
                          backgroundColor = Colors.green[100]!;
                          borderColor = Colors.green;
                        } else if (isSelected && !isCorrect) {
                          backgroundColor = Colors.red[100]!;
                          borderColor = Colors.red;
                        } else if (isCorrect) {
                          backgroundColor = Colors.green[100]!;
                          borderColor = Colors.green;
                        }
                      }

                      return GestureDetector(
                        onTap: () => _answerQuestion(index),
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: borderColor,
                              width: isSelected ? 3 : 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: isSelected ? borderColor : Colors.transparent,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: borderColor, width: 2),
                                ),
                                child: isSelected
                                    ? const Icon(Icons.check, size: 18, color: Colors.white)
                                    : null,
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Text(
                                  option,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'LondrinaSolid',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(0, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: const BorderSide(color: Colors.black, width: 1),
                      ),
                    ),
                    onPressed: _currentQuestionIndex > 0 ? _previousQuestion : null,
                    child: const Icon(Icons.arrow_back),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFF59D),
                      foregroundColor: Colors.black,
                      minimumSize: const Size(0, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: const BorderSide(color: Colors.black, width: 1),
                      ),
                    ),
                    onPressed: isAnswered ? _nextQuestion : null,
                    child: _currentQuestionIndex == 19 
                        ? const Icon(Icons.flag)
                        : const Icon(Icons.arrow_forward),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsScreen() {
    final percentage = (_score / 20 * 100).toInt();
    
    String resultText = '';
    String emoji = '';
    Color color = Colors.green;

    if (percentage >= 90) {
      resultText = 'Excellent!';
      emoji = '🏆';
      color = Colors.green;
    } else if (percentage >= 70) {
      resultText = 'Great Job!';
      emoji = '🎉';
      color = Colors.blue;
    } else if (percentage >= 50) {
      resultText = 'Good Try!';
      emoji = '👍';
      color = Colors.orange;
    } else {
      resultText = 'Keep Practicing!';
      emoji = '💪';
      color = Colors.red;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0EAD6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0EAD6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Quiz Results',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'LondrinaSolid',
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 20),
              
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.2),
                      blurRadius: 8,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      resultText,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'LondrinaSolid',
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.quiz, color: Colors.amber, size: 40),
                        const SizedBox(width: 10),
                        Text(
                          '$_score/20',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'LondrinaSolid',
                            color: Color(0xFF6B8E6B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    
                    Text(
                      '$percentage% Correct',
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'LondrinaSolid',
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF59D),
                        foregroundColor: Colors.black,
                        minimumSize: const Size(200, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: const BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      onPressed: _restartQuiz,
                      child: const Text(
                        'Try Again',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'LondrinaSolid',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// QUIZ QUESTION MODEL
class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String? imageAsset;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.imageAsset,
  });
}

// PROFILE SCREEN - UPDATED
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EAD6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0EAD6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'LondrinaSolid',
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[300],
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: const Center(
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              UserProvider.getUserName(),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'LondrinaSolid',
              ),
            ),
            Text(
              UserProvider.getUserEmail(),
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'LondrinaSolid',
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 40),
            
            Expanded(
              child: ListView(
                children: [
                  _buildProfileItem('Settings', Icons.arrow_forward_ios, context),
                  _buildProfileItem('Help', Icons.arrow_forward_ios, context),
                  _buildProfileItem('About', Icons.arrow_forward_ios, context),
                  const SizedBox(height: 30),
                  _buildSignOutButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(String title, IconData icon, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (title == 'Settings') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            } else if (title == 'Help') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpScreen()),
              );
            } else if (title == 'About') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'LondrinaSolid',
                    ),
                  ),
                ),
                Icon(icon, size: 18, color: Colors.black),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignOutButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Clear user data on sign out
          UserProvider.setUser(UserData(name: '', email: ''));
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Sign out successfully',
                style: TextStyle(
                  fontFamily: 'LondrinaSolid',
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );

          Future.delayed(const Duration(milliseconds: 1500), () {
             if (!context.mounted) return;
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const OptionSelectionScreen()),
              (route) => false,
            );
          });
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF59D),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: const Center(
            child: Text(
              'Sign Out',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'LondrinaSolid',
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// SETTINGS SCREEN
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EAD6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0EAD6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'LondrinaSolid',
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            
            _buildSettingsItem(
              'Privacy Policy',
              Icons.privacy_tip,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                );
              },
            ),
            const SizedBox(height: 15),
            
            _buildSettingsItem(
              'Terms of use',
              Icons.description,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TermsOfUseScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(String title, IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.black, size: 24),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'LondrinaSolid',
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}

// LANGUAGES SCREEN
class LanguagesScreen extends StatefulWidget {
  const LanguagesScreen({super.key});

  @override
  State<LanguagesScreen> createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  String _selectedLanguage = 'English';
  final List<String> _languages = ['English', 'Filipino'];
  bool _isLoading = false;

  void _saveLanguage() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    _showSuccessSnackBar();

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  void _showSuccessSnackBar() {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Language changed to $_selectedLanguage successfully!',
          style: const TextStyle(
            fontFamily: 'LondrinaSolid',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EAD6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0EAD6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Languages',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'LondrinaSolid',
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            const Text(
              'Select your preferred language:',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'LondrinaSolid',
              ),
            ),
            const SizedBox(height: 30),
            
            Expanded(
              child: ListView(
                children: _languages.map((language) {
                  return _buildLanguageOption(language, _selectedLanguage == language);
                }).toList(),
              ),
            ),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFF59D),
                  foregroundColor: Colors.black,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                    side: const BorderSide(color: Colors.black, width: 1),
                  ),
                ),
                onPressed: _isLoading ? null : _saveLanguage,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      )
                    : const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'LondrinaSolid',
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String language, bool isSelected) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedLanguage = language;
          });
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.black,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                language,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'LondrinaSolid',
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: Colors.blue, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// HELP SCREEN
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EAD6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0EAD6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Help & Support',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'LondrinaSolid',
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF59D),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.help_outline,
                        size: 40,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'SenyaMatika Help Center',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'LondrinaSolid',
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'LondrinaSolid',
              ),
            ),
            const SizedBox(height: 15),
            
            _buildFAQItem(
              'How can I track my learning progress?',
              'Visit the "Progress" section in your dashboard to see your overall progress, completed lessons, and quiz scores.'
            ),
            
            _buildFAQItem(
              'How do I contact support?',
              'You can reach our support team by emailing senyamatikasupport@gmail.com.'
            ),
            
            const SizedBox(height: 30),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFA8D5E3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Need More Help?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'LondrinaSolid',
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Our support team is here to help you with any questions or issues you may have.',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'LondrinaSolid',
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  _buildContactMethod('Email', 'support@senyamatika.com', Icons.email),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            const Center(
              child: Text(
                'App Version: 1.0.0',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'LondrinaSolid',
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'LondrinaSolid',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'LondrinaSolid',
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactMethod(String method, String details, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.black),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                method,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'LondrinaSolid',
                ),
              ),
              Text(
                details,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'LondrinaSolid',
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ABOUT SCREEN
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EAD6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0EAD6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'About SenyaMatika',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'LondrinaSolid',
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF59D),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.school,
                        size: 50,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'SenyaMatika',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'LondrinaSolid',
                    ),
                  ),
                  const Text(
                    'Mathematics Learning App',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'LondrinaSolid',
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            const Text(
              'About Our App',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'LondrinaSolid',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'SenyaMatika is an innovative educational app designed to make learning mathematics fun and engaging for students of all ages. Our app combines interactive lessons and progress tracking to help you master mathematical concepts.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'LondrinaSolid',
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 25),
            
            const Text(
              'Key Features',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'LondrinaSolid',
              ),
            ),
            const SizedBox(height: 15),
            
            _buildFeatureItem('Interactive Lessons', 'Learn with engaging visual content and step-by-step explanations'),
            _buildFeatureItem('Progress Tracking', 'Monitor your learning journey with detailed progress reports'),
    
            _buildFeatureItem('Sign Language Support', 'Includes sign language dictionary for inclusive learning'),
            
            const SizedBox(height: 25),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF5C6D6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'App Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'LondrinaSolid',
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildInfoRow('Version', '1.0.0'),
                  _buildInfoRow('Last Updated', 'January 2024'),
                  _buildInfoRow('Developer', 'SenyaMatika Team'),
                  _buildInfoRow('Compatibility', 'Android 8.0+'),
                ],
              ),
            ),
            
            const SizedBox(height: 25),
        
            const Center(
              child: Text(
                '© 2025 SenyaMatika. All rights reserved.',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'LondrinaSolid',
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'LondrinaSolid',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'LondrinaSolid',
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'LondrinaSolid',
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'LondrinaSolid',
            ),
          ),
        ],
      ),
    );
  }
}

// PRIVACY POLICY SCREEN
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EAD6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0EAD6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'LondrinaSolid',
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Last Updated: January 2024',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'LondrinaSolid',
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            
            _buildPolicySection(
              '1. Information We Collect',
              'We collect only the information necessary to improve your learning experience. This may include your name, email address, and usage data (such as topics completed or time spent in the app). We do not collect sensitive personal information without your consent.'
            ),
            
            _buildPolicySection(
              '2. How We Use Your Information',
              'We use the information we collect to provide and improve our educational content, track learning progress, and ensure the app functions properly. We do not sell or share your information with third parties for marketing purposes.'
            ),
            
            _buildPolicySection(
              '3. Data Security',
              'All personal data is stored securely and accessible only to authorized personnel. We take reasonable measures to protect your information from unauthorized access, alteration, or deletion.'
            ),
            
            _buildPolicySection(
              '4. Children\'s Privacy',
              'SenyaMatika is an educational app that may be used by children under 18. We collect only minimal information needed for learning purposes and do not share it with third parties. Parents or guardians can delete their child\'s account and all related data anytime by contacting us at senyamatikasupport.com.'
            ),
            
            _buildPolicySection(
              '5. Third-Party Services',
              'This app may use third-party services that collect data to help us understand how users interact with the app. These services follow their own privacy policies.'
            ),
            
            _buildPolicySection(
              '6. Your Rights',
              'You can view, update, or delete your personal information anytime through the app\'s settings.'
            ),
            
            _buildPolicySection(
              '9. Contact Us',
              'If you have any questions about this Privacy Policy:\n\n'
              'Email: senyamatikasupport@gmail.com\n'
            ),
            
            const SizedBox(height: 30),
            
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFA8D5E3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'By using SenyaMatika, you agree to the collection and use of information in accordance with this policy.',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'LondrinaSolid',
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'We are committed to protecting your privacy and providing a safe learning environment.',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'LondrinaSolid',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicySection(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'LondrinaSolid',
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'LondrinaSolid',
              color: Colors.black87,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 15),
          const Divider(color: Colors.black54),
        ],
      ),
    );
  }
}

// TERMS OF USE SCREEN
class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EAD6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0EAD6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Terms of Use',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'LondrinaSolid',
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Last Updated: January 2024',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'LondrinaSolid',
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Terms of Use',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'LondrinaSolid',
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'By using SenyaMatika, you agree to these terms and conditions. Please read them carefully.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'LondrinaSolid',
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'User Responsibilities',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'LondrinaSolid',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'You are responsible for maintaining the confidentiality of your account and password. You agree to accept responsibility for all activities that occur under your account.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'LondrinaSolid',
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ENHANCED VIDEO LESSON SCREEN WITH SPEED CONTROL
class VideoLessonScreen extends StatefulWidget {
  final String lessonName;
  final String language;
  final int subLessonIndex;
  
  const VideoLessonScreen({
    super.key,
    required this.lessonName,
    required this.language,
    required this.subLessonIndex,
  });

  @override
  State<VideoLessonScreen> createState() => _VideoLessonScreenState();
}

class _VideoLessonScreenState extends State<VideoLessonScreen> {
  late VideoPlayerController _videoPlayerController;
  bool _isVideoCompleted = false;
  bool _isVideoInitialized = false;
  double _playbackSpeed = 1.0;
  final List<double> _speedOptions = [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];

  final List<Map<String, dynamic>> _subLessons = [
    {
      'title': 'Count Up To 20',
      'videoUrl': 'assets/videos/CountUpTo20.mp4',
      'description': 'Learn how to count from 1 to 20',
    },
    {
      'title': 'Numbers 21-50',
      'videoUrl': 'assets/videos/numbers_21_50.mp4',
      'description': 'Learn numbers from 21 to 50',
    },
    {
      'title': 'Advanced Counting',
      'videoUrl': 'assets/videos/advanced_counting.mp4',
      'description': 'Learn counting patterns and larger numbers',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() async {
    final currentSubLesson = _subLessons[widget.subLessonIndex];
    
    try {
      _videoPlayerController = VideoPlayerController.asset(currentSubLesson['videoUrl']);
      
      await _videoPlayerController.initialize();
      
      _videoPlayerController.addListener(() {
        if (_videoPlayerController.value.position >= _videoPlayerController.value.duration && 
            _videoPlayerController.value.duration > Duration.zero) {
          setState(() {
            _isVideoCompleted = true;
          });
        }
      });

      setState(() {
        _isVideoInitialized = true;
      });
    } catch (e) {
      debugPrint('Error initializing video: $e');
    }
  }

  void _changePlaybackSpeed(double speed) {
    setState(() {
      _playbackSpeed = speed;
    });
    _videoPlayerController.setPlaybackSpeed(speed);
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentSubLesson = _subLessons[widget.subLessonIndex];
    
    return Scaffold(
      backgroundColor: const Color(0xFFF0EAD6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0EAD6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${widget.lessonName} - ${widget.language}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'LondrinaSolid',
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sub-lesson ${widget.subLessonIndex + 1}: ${currentSubLesson['title']}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'LondrinaSolid',
              ),
            ),
            const SizedBox(height: 10),
            
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: _isVideoInitialized ? 
                        _videoPlayerController.value.aspectRatio : 16/9,
                    child: _isVideoInitialized
                        ? VideoPlayer(_videoPlayerController)
                        : Container(
                            color: Colors.black,
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(color: Colors.yellow),
                                  SizedBox(height: 10),
                                  Text(
                                    'Loading video...',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'LondrinaSolid',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                  
                  if (_isVideoInitialized)
                    Container(
                      color: Colors.black87,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Playback Speed:',
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${_playbackSpeed}x',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'LondrinaSolid',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              PopupMenuButton<double>(
                                icon: const Icon(Icons.speed, size: 16, color: Colors.white),
                                onSelected: _changePlaybackSpeed,
                                itemBuilder: (context) => _speedOptions.map((speed) {
                                  return PopupMenuItem<double>(
                                    value: speed,
                                    child: Text(
                                      '${speed}x Speed',
                                      style: const TextStyle(
                                        fontFamily: 'LondrinaSolid',
                                        fontSize: 12,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  _videoPlayerController.value.isPlaying 
                                      ? Icons.pause 
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (_videoPlayerController.value.isPlaying) {
                                      _videoPlayerController.pause();
                                    } else {
                                      _videoPlayerController.play();
                                    }
                                  });
                                },
                              ),
                              
                              IconButton(
                                icon: const Icon(Icons.replay_10, color: Colors.white),
                                onPressed: () {
                                  final newPosition = _videoPlayerController.value.position - 
                                      const Duration(seconds: 10);
                                  _videoPlayerController.seekTo(newPosition);
                                },
                              ),
                              
                              Text(
                                _formatDuration(_videoPlayerController.value.position),
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                              
                              Expanded(
                                child: VideoProgressIndicator(
                                  _videoPlayerController,
                                  allowScrubbing: true,
                                  colors: const VideoProgressColors(
                                    playedColor: Colors.yellow,
                                    bufferedColor: Colors.grey,
                                    backgroundColor: Colors.white24,
                                  ),
                                ),
                              ),
                              
                              Text(
                                _formatDuration(_videoPlayerController.value.duration),
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                              
                              IconButton(
                                icon: const Icon(Icons.forward_10, color: Colors.white),
                                onPressed: () {
                                  final newPosition = _videoPlayerController.value.position + 
                                      const Duration(seconds: 10);
                                  _videoPlayerController.seekTo(newPosition);
                                },
                              ),

                              IconButton(
                                icon: const Icon(Icons.replay, color: Colors.white),
                                onPressed: () {
                                  _videoPlayerController.seekTo(Duration.zero);
                                  _videoPlayerController.play();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _isVideoCompleted ? Colors.green[100] : Colors.yellow[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: Row(
                children: [
                  Icon(
                    _isVideoCompleted ? Icons.check_circle : Icons.info,
                    color: _isVideoCompleted ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _isVideoCompleted 
                          ? 'Video completed! You can now take the exercise.'
                          : 'Watch the video completely to unlock the exercise.',
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'LondrinaSolid',
                      ),
                    ),
                  ),
                  if (!_isVideoCompleted)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isVideoCompleted = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF59D),
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('Mark Complete'),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            
            Text(
              currentSubLesson['description']!,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'LondrinaSolid',
              ),
            ),

            const SizedBox(height: 30),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isVideoCompleted ? const Color(0xFFFFF59D) : Colors.grey,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                    side: const BorderSide(color: Colors.black, width: 1),
                  ),
                ),
                onPressed: _isVideoCompleted ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExerciseScreen(
                      lessonName: widget.lessonName,
                      language: widget.language,
                      subLessonIndex: widget.subLessonIndex,
                    )),
                  );
                } : null,
                child: Text(
                  _isVideoCompleted ? 'Take Exercise' : 'Complete Video First',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'LondrinaSolid',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}

// EXERCISE SCREEN - SIMPLIFIED VERSION
class ExerciseScreen extends StatefulWidget {
  final String lessonName;
  final String language;
  final int subLessonIndex;

  const ExerciseScreen({
    super.key,
    required this.lessonName,
    required this.language,
    required this.subLessonIndex,
  });

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  List<int> _numbers = [];
  List<int?> _answers = [];
  int _score = 0;
  int _currentQuestion = 0;
  final int _totalQuestions = 10;
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    _initializeExercise();
  }

  void _initializeExercise() {
    // Generate random numbers for the exercise
    final random = Random();
    _numbers = List.generate(_totalQuestions, (index) => random.nextInt(20) + 1);
    _answers = List.filled(_totalQuestions, null);
  }

  void _answerQuestion(int answer) {
    if (!_showResult) {
      setState(() {
        _answers[_currentQuestion] = answer;
        
        if (_currentQuestion < _totalQuestions - 1) {
          _currentQuestion++;
        } else {
          _calculateScore();
          _showResult = true;
        }
      });
    }
  }

  void _calculateScore() {
    int correct = 0;
    for (int i = 0; i < _totalQuestions; i++) {
      if (_answers[i] == _numbers[i] + 1) {
        correct++;
      }
    }
    _score = (correct / _totalQuestions * 100).toInt();
  }

  void _restartExercise() {
    setState(() {
      _initializeExercise();
      _currentQuestion = 0;
      _score = 0;
      _showResult = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EAD6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0EAD6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Exercise - Counting',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'LondrinaSolid',
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFA8D5E3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: const Column(
                children: [
                  Icon(Icons.question_answer, size: 40, color: Colors.black),
                  SizedBox(height: 10),
                  Text(
                    'What number comes AFTER the given number?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'LondrinaSolid',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${_currentQuestion + 1}/$_totalQuestions',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'LondrinaSolid',
                  ),
                ),
                if (_showResult)
                  Text(
                    'Score: $_score%',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'LondrinaSolid',
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 20),

            if (!_showResult)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      blurRadius: 6,
                      offset: const Offset(3, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'What comes AFTER:',
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'LondrinaSolid',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${_numbers[_currentQuestion]}',
                      style: const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'LondrinaSolid',
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    Row(
                      children: [
                        Expanded(
                          child: _buildNumberButton(_numbers[_currentQuestion] + 1),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildNumberButton(_numbers[_currentQuestion] + 2),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildNumberButton(_numbers[_currentQuestion] + 3),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildNumberButton(_numbers[_currentQuestion] + 4),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            if (_showResult)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: _score >= 70 ? Colors.green[100] : Colors.orange[100],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _score >= 70 ? Colors.green : Colors.orange,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      _score >= 70 ? Icons.celebration : Icons.emoji_objects,
                      size: 50,
                      color: _score >= 70 ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _score >= 70 
                          ? 'Great Job! You scored $_score%' 
                          : 'You scored $_score%. Keep practicing!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'LondrinaSolid',
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF59D),
                        foregroundColor: Colors.black,
                      ),
                      onPressed: _restartExercise,
                      child: const Text(
                        'Try Again',
                        style: TextStyle(
                          fontFamily: 'LondrinaSolid',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 30),

            if (!_showResult)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: const Size(0, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: const BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      onPressed: _currentQuestion > 0 ? () {
                        setState(() {
                          _currentQuestion--;
                        });
                      } : null,
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF59D),
                        foregroundColor: Colors.black,
                        minimumSize: const Size(0, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: const BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      onPressed: () {
                        if (_currentQuestion < _totalQuestions - 1) {
                          setState(() {
                            _currentQuestion++;
                          });
                        } else {
                          _calculateScore();
                          setState(() {
                            _showResult = true;
                          });
                        }
                      },
                      child: Text(
                        _currentQuestion == _totalQuestions - 1 ? 'Finish' : 'Next',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'LondrinaSolid',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberButton(int number) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        minimumSize: const Size(0, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.black, width: 1),
        ),
      ),
      onPressed: () => _answerQuestion(number),
      child: Text(
        '$number',
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'LondrinaSolid',
        ),
      ),
    );
  }
}

// SIGN DICTIONARY SCREEN
class SignDictionaryScreen extends StatelessWidget {
  const SignDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EAD6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0EAD6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Sign Dictionary',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'LondrinaSolid',
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose a',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'LondrinaSolid',
              ),
            ),
            const Text(
              'Category',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'LondrinaSolid',
              ),
            ),
            const SizedBox(height: 30),
            
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildCategoryItem(
                        'Fraction',
                        const Color(0xFFA8D5E3),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const FractionDictionaryScreen()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    
                    Expanded(
                      child: _buildCategoryItem(
                        'Length',
                        const Color(0xFFA8D5BA),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LengthDictionaryScreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildCategoryItem(
                        'Sizes',
                        const Color(0xFFFFD8A8),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SizesDictionaryScreen()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    
                    Expanded(
                      child: _buildCategoryItem(
                        'Mass',
                        const Color(0xFFD8A8FF),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MassDictionaryScreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildCategoryItem(
                        'Height',
                        const Color(0xFFA8E3B5),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HeightDictionaryScreen()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    
                    Expanded(
                      child: _buildCategoryItem(
                        'Big',
                        const Color(0xFFF5A8A8),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const BigDictionaryScreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: _buildCategoryItem(
                        'Long',
                        const Color(0xFFA8D5E3),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LongDictionaryScreen()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    
                    Expanded(
                      child: _buildCategoryItem(
                        'Heavy',
                        const Color(0xFFF5C6D6),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HeavyDictionaryScreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: _buildCategoryItem(
                        'Bigger',
                        const Color(0xFFC4B1E1),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const BiggerDictionaryScreen()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    
                    Expanded(
                      child: _buildCategoryItem(
                        'Longer',
                        const Color(0xFFA8D5BA),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LongerDictionaryScreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String title, Color color, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'LondrinaSolid',
            ),
          ),
        ),
      ),
    );
  }
}

// ENHANCED VIDEO PLAYER SCREEN WITH SPEED CONTROL
class DictionaryVideoScreen extends StatefulWidget {
  final String title;
  final String videoAsset;
  final Color backgroundColor;

  const DictionaryVideoScreen({
    super.key,
    required this.title,
    required this.videoAsset,
    required this.backgroundColor,
  });

  @override
  State<DictionaryVideoScreen> createState() => _DictionaryVideoScreenState();
}

class _DictionaryVideoScreenState extends State<DictionaryVideoScreen> {
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;
  bool _hasError = false;
  double _playbackSpeed = 1.0;
  final List<double> _speedOptions = [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() async {
    try {
      _videoController = VideoPlayerController.asset(widget.videoAsset);
      
      await _videoController.initialize();
      
      setState(() {
        _isVideoInitialized = true;
        _hasError = false;
      });
      
      _videoController.setLooping(true);
      _videoController.play();
      
    } catch (e) {
      setState(() {
        _hasError = true;
      });
    }
  }

  void _changePlaybackSpeed(double speed) {
    setState(() {
      _playbackSpeed = speed;
    });
    _videoController.setPlaybackSpeed(speed);
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        backgroundColor: widget.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'LondrinaSolid',
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _hasError
                  ? _buildErrorWidget()
                  : _isVideoInitialized
                      ? _buildVideoPlayer()
                      : _buildLoadingWidget(),
            ),
          ),
          if (_isVideoInitialized && !_hasError)
            _buildVideoControls(),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return AspectRatio(
      aspectRatio: _videoController.value.aspectRatio,
      child: VideoPlayer(_videoController),
    );
  }

  Widget _buildLoadingWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(color: Colors.black),
        const SizedBox(height: 20),
        Text(
          'Loading video...',
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'LondrinaSolid',
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, size: 60, color: Colors.red),
        const SizedBox(height: 20),
        const Text(
          'Video not found',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'LondrinaSolid',
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFF59D),
            foregroundColor: Colors.black,
          ),
          onPressed: _initializeVideo,
          child: const Text(
            'Try Again',
            style: TextStyle(
              fontFamily: 'LondrinaSolid',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Color.fromRGBO(0, 0, 0, 0.1),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Speed:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'LondrinaSolid',
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: Text(
                  '${_playbackSpeed}x',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'LondrinaSolid',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              PopupMenuButton<double>(
                icon: const Icon(Icons.speed, color: Colors.black),
                onSelected: _changePlaybackSpeed,
                itemBuilder: (context) => _speedOptions.map((speed) {
                  return PopupMenuItem<double>(
                    value: speed,
                    child: Text(
                      '${speed}x',
                      style: const TextStyle(
                        fontFamily: 'LondrinaSolid',
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous, size: 30, color: Colors.black),
                onPressed: () {
                  final newPosition = _videoController.value.position - const Duration(seconds: 10);
                  _videoController.seekTo(newPosition);
                },
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: Icon(
                  _videoController.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 40,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    if (_videoController.value.isPlaying) {
                      _videoController.pause();
                    } else {
                      _videoController.play();
                    }
                  });
                },
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.skip_next, size: 30, color: Colors.black),
                onPressed: () {
                  final newPosition = _videoController.value.position + const Duration(seconds: 10);
                  _videoController.seekTo(newPosition);
                },
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.replay, size: 30, color: Colors.black),
                onPressed: () {
                  _videoController.seekTo(Duration.zero);
                  _videoController.play();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// DICTIONARY SCREEN BUILDER
Widget _buildDictionaryScreen(BuildContext context, String title, Color color, 
    {String? videoAsset}) {
  return Scaffold(
    backgroundColor: const Color(0xFFF0EAD6),
    appBar: AppBar(
      backgroundColor: const Color(0xFFF0EAD6),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'LondrinaSolid',
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      elevation: 0,
    ),
    body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA8D5E3),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.black, width: 1),
                ),
              ),
              onPressed: videoAsset != null ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DictionaryVideoScreen(
                    title: title,
                    videoAsset: videoAsset,
                    backgroundColor: const Color(0xFFA8D5E3),
                  )),
                );
              } : null,
              child: Text(
                'View Video ${videoAsset == null ? '(Coming Soon)' : ''}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'LondrinaSolid',
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.video_library,
                    size: 60,
                    color: color,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'View the sign language video for "$title"',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'LondrinaSolid',
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (videoAsset == null)
                    const Text(
                      '(Video coming soon)',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'LondrinaSolid',
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// INDIVIDUAL DICTIONARY SCREENS
class FractionDictionaryScreen extends StatelessWidget {
  const FractionDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      'Fraction', 
      const Color(0xFFA8D5E3),
      videoAsset: 'assets/videos/fraction_asl.mp4',
    );
  }
}

class HeavyDictionaryScreen extends StatelessWidget {
  const HeavyDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      'Heavy', 
      const Color(0xFFF5C6D6),
    );
  }
}

class HeightDictionaryScreen extends StatelessWidget {
  const HeightDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      'Height', 
      const Color(0xFFA8E3B5),
    );
  }
}

class LengthDictionaryScreen extends StatelessWidget {
  const LengthDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      'Length', 
      const Color(0xFFA8D5BA),
    );
  }
}

class SizesDictionaryScreen extends StatelessWidget {
  const SizesDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      'Sizes', 
      const Color(0xFFFFD8A8),
    );
  }
}

class MassDictionaryScreen extends StatelessWidget {
  const MassDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      'Mass', 
      const Color(0xFFD8A8FF),
    );
  }
}

class BigDictionaryScreen extends StatelessWidget {
  const BigDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      'Big', 
      const Color(0xFFF5A8A8),
    );
  }
}

class LongDictionaryScreen extends StatelessWidget {
  const LongDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      'Long', 
      const Color(0xFFA8D5E3),
    );
  }
}

class BiggerDictionaryScreen extends StatelessWidget {
  const BiggerDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      'Bigger', 
      const Color(0xFFC4B1E1),
    );
  }
}

class LongerDictionaryScreen extends StatelessWidget {
  const LongerDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      'Longer', 
      const Color(0xFFA8D5BA),
    );
  }
}