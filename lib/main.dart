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
        fontFamily: 'TitanOne-Regular',
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
      backgroundColor: const Color(0xFF4988C4),
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
                fontFamily: 'TitanOne-Regular',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============ FRONT PAGE SCREEN ============
class FrontPageScreen extends StatefulWidget {
  const FrontPageScreen({super.key});

  @override
  State<FrontPageScreen> createState() => _FrontPageScreenState();
}

class _FrontPageScreenState extends State<FrontPageScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    // Create slide animation (slides up from bottom)
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1.0), // Start from bottom (off-screen)
      end: Offset.zero, // End at normal position
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );
    
    // Create fade animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    
    // Delay the animation by 1 second (1000ms) then start
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isVerySmallScreen = screenHeight < 600;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xFF4988C4),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // TITLE SECTION - Moved lower
                Padding(
                  padding: EdgeInsets.only(
                    top: isVerySmallScreen 
                        ? screenHeight * 0.12 
                        : screenHeight * 0.15,
                  ),
                  child: Center(
                    child: Stack(
                      children: [
                        // BORDER/STROKE TEXT
                        Text(
                          'SenyaMatika',
                          style: TextStyle(
                            fontSize: isVerySmallScreen
                                ? 34
                                : isTablet
                                    ? 56
                                    : 44,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'TitanOne-Regular',
                            letterSpacing: 1.2,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 1.2
                              ..color = Colors.black,
                          ),
                        ),
                        // MAIN TEXT
                        Text(
                          'SenyaMatika',
                          style: TextStyle(
                            fontSize: isVerySmallScreen
                                ? 34
                                : isTablet
                                    ? 56
                                    : 44,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'TitanOne-Regular',
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // IMAGE SECTION - Increased size
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: isVerySmallScreen ? 30 : 60,
                        horizontal: screenWidth * 0.1,
                      ),
                      child: Image.asset(
                        'assets/assetsmyimage.png',
                        fit: BoxFit.contain,
                        width: isVerySmallScreen
                            ? screenWidth * 0.8
                            : isTablet
                                ? screenWidth * 0.6
                                : screenWidth * 0.9,
                        height: isVerySmallScreen
                            ? screenWidth * 0.6
                            : isTablet
                                ? screenWidth * 0.4
                                : screenWidth * 0.7,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: isVerySmallScreen
                                ? screenWidth * 0.8
                                : isTablet
                                    ? screenWidth * 0.6
                                    : screenWidth * 0.9,
                            height: isVerySmallScreen
                                ? screenWidth * 0.6
                                : isTablet
                                    ? screenWidth * 0.4
                                    : screenWidth * 0.7,
                            color: Colors.white,
                            child: Center(
                              child: Icon(
                                Icons.image,
                                size: isSmallScreen ? 60 : 90,
                                color: const Color(0xFF007AFF),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // SPACER for the animated buttons (takes up the space)
                SizedBox(
                  height: isVerySmallScreen ? 170 : 200,
                ),
              ],
            ),

            // ANIMATED BUTTONS SECTION (will slide up)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                      bottom: isVerySmallScreen ? 40 : 60,
                      left: screenWidth * 0.1,
                      right: screenWidth * 0.1,
                      top: 30,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5FBE6),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 25,
                          spreadRadius: 5,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // CREATE ACCOUNT BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: isVerySmallScreen
                              ? screenHeight * 0.07
                              : isTablet
                                  ? screenHeight * 0.09
                                  : screenHeight * 0.08,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFEDA5E),
                              foregroundColor: Colors.black,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                                side: const BorderSide(
                                  color: Colors.black,
                                  width: 2.5,
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CreateAccountScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: isVerySmallScreen
                                    ? 17
                                    : isTablet
                                        ? 24
                                        : 21,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'TitanOne-Regular',
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: isVerySmallScreen ? 18 : 25),

                        // LOG IN BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: isVerySmallScreen
                              ? screenHeight * 0.07
                              : isTablet
                                  ? screenHeight * 0.09
                                  : screenHeight * 0.08,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD4E8FF),
                              foregroundColor: Colors.black,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                                side: const BorderSide(
                                  color: Colors.black,
                                  width: 2.5,
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LogInScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Log In',
                              style: TextStyle(
                                fontSize: isVerySmallScreen
                                    ? 17
                                    : isTablet
                                        ? 24
                                        : 21,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'TitanOne-Regular',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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

    // DAGDAG: Validation para siguraduhing may @gmail.com ang email
    if (!email.endsWith('@gmail.com')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please use a valid Gmail address (@gmail.com)'),
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
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FBE6),
      body: SafeArea(
        child: Stack(
          children: [
            // Background decorative elements
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFF59D).withOpacity(0.3),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              left: -50,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFF59D).withOpacity(0.3),
                ),
              ),
            ),
            
            SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button at top left
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Welcome text - CENTERED
                  const Center(
                    child: Text(
                      'Welcome to SenyaMatika!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'TitanOne-Regular',
                        color: Colors.black,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Container para sa Create Account text at Image
                  SizedBox(
                    width: double.infinity,
                    child: Stack(
                      children: [
                        // "Create Account" title - NASA LEFT SIDE
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Create',
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'TitanOne-Regular',
                                color: Colors.black,
                                height: 0.9,
                              ),
                            ),
                            Text(
                              'Account',
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'TitanOne-Regular',
                                color: Colors.black,
                                height: 0.9,
                              ),
                            ),
                          ],
                        ),
                        
                        // Image na nasa RIGHT SIDE
                        Positioned(
                          top: -10,
                          right: 0,
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.asset(
                              'assets/images/child_hello.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.transparent,
                                  child: const Center(
                                    child: Icon(
                                      Icons.child_care,
                                      size: 40,
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30), // Space para sa box
                  
                  // Create Account card (BOX NA KULAY B0BDC1)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB0BDC1), // PINALITAN DITO
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Form fields - WALANG TITLE DITO SA LOOB
                        _buildTextField(
                          controller: _nameController,
                          label: 'Name:',
                          hintText: 'Enter your full name',
                          prefixIcon: Icons.person,
                        ),
                        const SizedBox(height: 20),
                        
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email:',
                          hintText: 'Enter your Gmail address (@gmail.com)',
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
                        const SizedBox(height: 35),
                        
                        // Create Button
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFEDA5E),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              elevation: 5,
                              shadowColor: Colors.black.withOpacity(0.2),
                            ),
                            onPressed: _createAccount,
                            child: const Text(
                              'Create',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'TitanOne-Regular',
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // TANGGAL: OR divider at Google Button
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                ],
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
            fontFamily: 'TitanOne-Regular',
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8F8F8),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              hintText: hintText,
              hintStyle: TextStyle(
                fontFamily: 'TitanOne-Regular',
                color: Colors.grey[600],
              ),
              border: InputBorder.none,
              prefixIcon: Icon(prefixIcon, color: Colors.black),
              filled: true,
              fillColor: Colors.transparent,
            ),
            style: const TextStyle(
              fontFamily: 'TitanOne-Regular',
              fontSize: 16,
              color: Colors.black,
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
            fontFamily: 'TitanOne-Regular',
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8F8F8),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: !isPasswordVisible,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              hintText: hintText,
              hintStyle: TextStyle(
                fontFamily: 'TitanOne-Regular',
                color: Colors.grey[600],
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
              filled: true,
              fillColor: Colors.transparent,
            ),
            style: const TextStyle(
              fontFamily: 'TitanOne-Regular',
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

// ============ UPDATED LOG IN SCREEN ============
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
          content: Text('Please enter your email'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // DAGDAG: Validation para siguraduhing may @gmail.com ang email
    if (!email.endsWith('@gmail.com')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please use a valid Gmail address (@gmail.com)'),
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
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FBE6),
      body: SafeArea(
        child: Stack(
          children: [
            // Background decorative elements (same as CreateAccountScreen)
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFF59D).withOpacity(0.3),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              left: -50,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFF59D).withOpacity(0.3),
                ),
              ),
            ),
            
            SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button at top left
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Welcome text - CENTERED
                  const Center(
                    child: Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'TitanOne-Regular',
                        color: Colors.black,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Sign in text - CENTERED
                  const Center(
                    child: Text(
                      'Sign In to continue',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'TitanOne-Regular',
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Container for Log In text at Image
                  SizedBox(
                    width: double.infinity,
                    child: Stack(
                      children: [
                        // "Log In" title - LEFT SIDE
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Log',
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'TitanOne-Regular',
                                color: Colors.black,
                                height: 0.9,
                              ),
                            ),
                            Text(
                              'In',
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'TitanOne-Regular',
                                color: Colors.black,
                                height: 0.9,
                              ),
                            ),
                          ],
                        ),
                        
                        // Image na nasa RIGHT SIDE (same child image)
                        Positioned(
                          top: -10,
                          right: 0,
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.asset(
                              'assets/images/child_hello.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.transparent,
                                  child: const Center(
                                    child: Icon(
                                      Icons.child_care,
                                      size: 40,
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Log In card (BOX NA KULAY B0BDC1)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB0BDC1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Form fields
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email:',
                          hintText: 'Enter your Gmail address (@gmail.com)',
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
                        
                        // Forgot Password
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
                                fontFamily: 'TitanOne-Regular',
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 35),
                        
                        // Log In Button
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFEDA5E),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              elevation: 5,
                              shadowColor: Colors.black.withOpacity(0.2),
                            ),
                            onPressed: _logIn,
                            child: const Text(
                              'Log In',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'TitanOne-Regular',
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // TANGGAL: OR divider at Google Button
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Don't have an account? Sign up
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'TitanOne-Regular',
                            color: Colors.black87,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const CreateAccountScreen()),
                            );
                          },
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'TitanOne-Regular',
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                ],
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
            fontFamily: 'TitanOne-Regular',
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8F8F8),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              hintText: hintText,
              hintStyle: TextStyle(
                fontFamily: 'TitanOne-Regular',
                color: Colors.grey[600],
              ),
              border: InputBorder.none,
              prefixIcon: Icon(prefixIcon, color: Colors.black),
              filled: true,
              fillColor: Colors.transparent,
            ),
            style: const TextStyle(
              fontFamily: 'TitanOne-Regular',
              fontSize: 16,
              color: Colors.black,
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
            fontFamily: 'TitanOne-Regular',
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8F8F8),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: !isPasswordVisible,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              hintText: hintText,
              hintStyle: TextStyle(
                fontFamily: 'TitanOne-Regular',
                color: Colors.grey[600],
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
              filled: true,
              fillColor: Colors.transparent,
            ),
            style: const TextStyle(
              fontFamily: 'TitanOne-Regular',
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

// ============ UPDATED FORGOT PASSWORD SCREEN ============
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

    // DAGDAG: Validation para siguraduhing may @gmail.com ang email
    if (!email.endsWith('@gmail.com')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please use a valid Gmail address (@gmail.com)'),
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
      backgroundColor: const Color(0xFFF5FBE6),
      body: SafeArea(
        child: Stack(
          children: [
            // Background decorative elements (same as CreateAccountScreen)
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFF59D).withOpacity(0.3),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              left: -50,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFF59D).withOpacity(0.3),
                ),
              ),
            ),
            
            SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button at top left
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Welcome text - CENTERED
                  const Center(
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'TitanOne-Regular',
                        color: Colors.black,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Instruction text - CENTERED
                  const Center(
                    child: Text(
                      'Enter your Gmail to reset your password',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'TitanOne-Regular',
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Container for Forgot Password text
                  SizedBox(
                    width: double.infinity,
                    child: Stack(
                      children: [
                        // "Forgot Password" title - LEFT SIDE
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Forgot',
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'TitanOne-Regular',
                                color: Colors.black,
                                height: 0.9,
                              ),
                            ),
                            Text(
                              'Password',
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'TitanOne-Regular',
                                color: Colors.black,
                                height: 0.9,
                              ),
                            ),
                          ],
                        ),
                        
                        // Image na nasa RIGHT SIDE (same child image)
                        Positioned(
                          top: -10,
                          right: 0,
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.asset(
                              'assets/images/child_hello.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.transparent,
                                  child: const Center(
                                    child: Icon(
                                      Icons.child_care,
                                      size: 40,
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Forgot Password card (BOX NA KULAY B0BDC1 - same as others)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB0BDC1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Form fields
                        _buildTextField(
                          controller: _emailController,
                          label: 'Gmail Address:',
                          hintText: 'Enter your Gmail address (@gmail.com)',
                          prefixIcon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 30),
                        
                        // Description text
                        const Text(
                          'We\'ll send you a link to reset your password.',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'TitanOne-Regular',
                            color: Colors.black87,
                          ),
                        ),
                        
                        const SizedBox(height: 35),
                        
                        // Send Reset Link Button
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFEDA5E),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              elevation: 5,
                              shadowColor: Colors.black.withOpacity(0.2),
                            ),
                            onPressed: _sendResetLink,
                            child: const Text(
                              'Send Reset Link',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'TitanOne-Regular',
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Back to Log In
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Back to Log In',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'TitanOne-Regular',
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                ],
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
            fontFamily: 'TitanOne-Regular',
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8F8F8),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              hintText: hintText,
              hintStyle: TextStyle(
                fontFamily: 'TitanOne-Regular',
                color: Colors.grey[600],
              ),
              border: InputBorder.none,
              prefixIcon: Icon(prefixIcon, color: Colors.black),
              filled: true,
              fillColor: Colors.transparent,
            ),
            style: const TextStyle(
              fontFamily: 'TitanOne-Regular',
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> 
    with TickerProviderStateMixin {
  late AnimationController _iconAnimationController;
  late AnimationController _featureAnimationController;
  late Animation<double> _waveAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  
  bool _isIconTapped = false;
  List<String> _funnyMessages = [
    "Hi there! 👋",
    "Hello again! ✨",
    "You're back! 😊",
    "Nice to see you! 🌟",
    "Wave wave! 👋👋",
    "Math time! 📚",
    "Ready to learn? 🎯",
    "Math is fun! 🧮",
    "Super learner! 🚀"
  ];
  String _currentMessage = "Hello";

  @override
  void initState() {
    super.initState();
    
    // Animation for features (existing)
    _featureAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    
    // Animation for hello icon (NEW)
    _iconAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    
    // Wave animation (hand waving)
    _waveAnimation = Tween<double>(begin: -0.2, end: 0.2).animate(
      CurvedAnimation(
        parent: _iconAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    
    // Scale animation for tap effect
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _iconAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    
    // Rotation animation for fun
    _rotationAnimation = Tween<double>(begin: -0.1, end: 0.1).animate(
      CurvedAnimation(
        parent: _iconAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    _featureAnimationController.dispose();
    super.dispose();
  }

  void _handleIconTap() {
    setState(() {
      _isIconTapped = true;
      
      // Pumili lang ng random message
      final randomIndex = Random().nextInt(_funnyMessages.length);
      _currentMessage = _funnyMessages[randomIndex];
    });
    
    // Reset tap state after animation
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isIconTapped = false;
        });
      }
    });
  }

  Widget _buildAnimatedHelloIcon() {
    return GestureDetector(
      onTap: _handleIconTap,
      onDoubleTap: () {
        setState(() {
          _currentMessage = "Double tap! 🎉";
        });
      },
      onLongPress: () {
        setState(() {
          _currentMessage = "Long press! ✨";
        });
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedBuilder(
          animation: _iconAnimationController,
          builder: (context, child) {
            return Transform(
              transform: Matrix4.identity()
                ..rotateZ(_waveAnimation.value)
                ..scale(_isIconTapped ? 1.3 : _scaleAnimation.value)
                ..rotateY(_rotationAnimation.value * 0.5),
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isIconTapped ? const Color(0xFFFFF59D) : const Color(0xFFFFF59D),
                  border: Border.all(
                    color: Colors.black,
                    width: _isIconTapped ? 3 : 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _isIconTapped 
                          ? const Color(0xFFFFD700).withOpacity(0.5)
                          : const Color(0xFFFFF59D).withOpacity(0.3),
                      blurRadius: _isIconTapped ? 20 : 10,
                      spreadRadius: _isIconTapped ? 5 : 2,
                      offset: Offset(0, _isIconTapped ? 8 : 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: child,
              ),
            );
          },
          child: Image.asset(
            'assets/images/hello.png',
            height: 60,
            width: 60,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return _buildFallbackIcon();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackIcon() {
    return const Icon(
      Icons.waving_hand,
      size: 40,
      color: Colors.black,
    );
  }

  Widget _buildAnimatedFeatureIcon({
    required String assetPath,
    required Color fallbackColor,
    required IconData fallbackIcon,
    double size = 60,
  }) {
    return AnimatedBuilder(
      animation: _featureAnimationController,
      builder: (context, child) {
        // Bounce effect (up and down)
        final bounceValue = (sin(_featureAnimationController.value * 2 * 3.14) * 8);
        
        return Transform.translate(
          offset: Offset(0, bounceValue),
          child: child,
        );
      },
      child: Image.asset(
        assetPath,
        height: size,
        width: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
              color: fallbackColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                fallbackIcon,
                size: size * 0.5,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenHeight < 700;
    final double verticalSpacing = isSmallScreen ? 10 : 15;

    return Scaffold(
      backgroundColor: const Color(0xFFF5FBE6),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section - UPDATED WITH ANIMATED HELLO ICON
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  
                  // Animated Hello section with icon
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ANIMATED HELLO ICON - hello.png with wave animation
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildAnimatedHelloIcon(),
                        ],
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Animated greeting text
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: Text(
                                _currentMessage,
                                key: ValueKey<String>(_currentMessage),
                                style: TextStyle(
                                  fontSize: _isIconTapped ? 32 : 28,
                                  fontFamily: 'TitanOne-Regular',
                                  color: Colors.black,
                                  shadows: _isIconTapped ? [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(2, 2),
                                    )
                                  ] : null,
                                ),
                              ),
                            ),
                            
                            // User name with special effects
                            Padding(
                              padding: EdgeInsets.only(top: _isIconTapped ? 10 : 5),
                              child: AnimatedScale(
                                duration: const Duration(milliseconds: 200),
                                scale: _isIconTapped ? 1.05 : 1.0,
                                child: Text(
                                  UserProvider.getUserName(),
                                  style: const TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'TitanOne-Regular',
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 30),
                  const Text(
                    'Features',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'TitanOne-Regular',
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),

            // Main Content with ALWAYS ANIMATED ICONS
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    // First Row - Topics and Progress
                    Row(
                      children: [
                        // TOPICS BUTTON - Bouncing Icon
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const TopicsScreen()),
                              );
                            },
                            child: Container(
                              height: 150,
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8E97FD),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.black, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildAnimatedFeatureIcon(
                                    assetPath: 'assets/images/topics.png',
                                    fallbackColor: const Color(0xFF3291B6),
                                    fallbackIcon: Icons.menu_book,
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Topics',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'TitanOne-Regular',
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // PROGRESS BUTTON - Bouncing Icon
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ProgressScreen()),
                              );
                            },
                            child: Container(
                              height: 150,
                              margin: const EdgeInsets.only(left: 10),
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4B342),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.black, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildAnimatedFeatureIcon(
                                    assetPath: 'assets/images/to-do-list.png',
                                    fallbackColor: const Color(0xFFA88BD4),
                                    fallbackIcon: Icons.trending_up,
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Progress',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'TitanOne-Regular',
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: verticalSpacing * 2),

                    // Second Row - Sign Dictionary and Sign Language Avatar
                    Row(
                      children: [
                        // SIGN DICTIONARY BUTTON - Bouncing Icon
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SignDictionaryScreen()),
                              );
                            },
                            child: Container(
                              height: 150,
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE0A8A8),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color.fromRGBO(0, 0, 0, 1), width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildAnimatedFeatureIcon(
                                    assetPath: 'assets/images/dictionary.png',
                                    fallbackColor: const Color(0xFFD4B054),
                                    fallbackIcon: Icons.sign_language,
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Sign Dictionary',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'TitanOne-Regular',
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // SIGN LANGUAGE AVATAR BUTTON - Bouncing Icon
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SignLanguageAvatarScreen()),
                              );
                            },
                            child: Container(
                              height: 150,
                              margin: const EdgeInsets.only(left: 10),
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8498C8),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.black, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildAnimatedFeatureIcon(
                                    assetPath: 'assets/images/sign-language.png',
                                    fallbackColor: const Color(0xFF8AD4B5),
                                    fallbackIcon: Icons.face,
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Sign Language Avatar',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'TitanOne-Regular',
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: verticalSpacing * 3),
                  ],
                ),
              ),
            ),

            // BOTTOM NAVIGATION BAR - SIMPLIFIED WITHOUT CONTAINER
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Home Button
                  GestureDetector(
                    onTap: () {
                      // Already on home screen
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF59D),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: Icon(
                            Icons.home,
                            size: isSmallScreen ? 24 : 28,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Home',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'TitanOne-Regular',
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Profile Button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfileScreen()),
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: Icon(
                            Icons.account_circle,
                            size: isSmallScreen ? 24 : 28,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'TitanOne-Regular',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? 0 : 10),
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
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
            fontFamily: 'TitanOne-Regular',
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
                        'assets/videos/avatar.mp4',
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
            fontFamily: 'TitanOne-Regular',
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
                  fontFamily: 'TitanOne-Regular',
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
                fontFamily: 'TitanOne-Regular',
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
            fontFamily: 'TitanOne-Regular',
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
                fontFamily: 'TitanOne-Regular',
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
            fontFamily: 'TitanOne-Regular',
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
                fontFamily: 'TitanOne-Regular',
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
            fontFamily: 'TitanOne-Regular',
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
                fontFamily: 'TitanOne-Regular',
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
            fontFamily: 'TitanOne-Regular',
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
                fontFamily: 'TitanOne-Regular',
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
            fontFamily: 'TitanOne-Regular',
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
                fontFamily: 'TitanOne-Regular',
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
            fontFamily: 'TitanOne-Regular',
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
                  fontFamily: 'TitanOne-Regular',
                ),
              ),
              const Text(
                'Progress',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'TitanOne-Regular',
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
                        fontFamily: 'TitanOne-Regular',
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
                                fontFamily: 'TitanOne-Regular',
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
                                fontFamily: 'TitanOne-Regular',
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'In Progress',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'TitanOne-Regular',
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
                                      fontFamily: 'TitanOne-Regular',
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
                                fontFamily: 'TitanOne-Regular',
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
                                      fontFamily: 'TitanOne-Regular',
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
            fontFamily: 'TitanOne-Regular',
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
                fontFamily: 'TitanOne-Regular',
              ),
            ),
            const Text(
              'Progress',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'TitanOne-Regular',
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
                  fontFamily: 'TitanOne-Regular',
                ),
              ),
              Text(
                '$percentage%',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'TitanOne-Regular',
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
            fontFamily: 'TitanOne-Regular',
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
                fontFamily: 'TitanOne-Regular',
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
              fontFamily: 'TitanOne-Regular',
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.black),
        ],
      ),
    );
  }
}

// TOPICS SCREEN

class TopicsScreen extends StatefulWidget {
  const TopicsScreen({super.key});

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> 
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  
  // Different animation properties for each topic
  final Map<String, Map<String, dynamic>> _topicAnimations = {
    'Number Values': {
      'type': 'bounce',
      'amplitude': 12.0,
      'color': Color(0xFFA8D5E3),
      'image': 'assets/images/number values logo.png',
    },
    'Fundamental Operations': {
      'type': 'float',
      'amplitude': 8.0,
      'rotation': 0.1,
      'color': Color(0xFFF5C6D6),
      'image': 'assets/images/fundamental operations.png',
    },
    'Fraction': {
      'type': 'rotate',
      'rotation': 0.3,
      'color': Color(0xFFC4B1E1),
      'image': 'assets/images/fraction.png',
    },
    'Decimal Numbers': {
      'type': 'pulse',
      'scale': 0.2,
      'color': Color(0xFFFFD8A8),
      'image': 'assets/images/decimal numbers.png',
    },
    'Percentage': {
      'type': 'wave',
      'amplitude': 15.0,
      'frequency': 4.0,
      'color': Color(0xFFA8E3B5),
      'image': 'assets/images/percentage.png',
    },
    'Mensuration': {
      'type': 'swing',
      'amplitude': 20.0,
      'rotation': 0.4,
      'color': Color(0xFFD8A8FF),
      'image': 'assets/images/mensuration.png',
    },
  };

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
          'Topics',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'TitanOne-Regular',
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
            children: _topicAnimations.keys.map((topic) {
              final config = _topicAnimations[topic]!;
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _buildTopicItem(
                  topic,
                  config['color'] as Color,
                  config['image'] as String,
                  config,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTopicItem(
    String topicName,
    Color boxColor,
    String imagePath,
    Map<String, dynamic> animationConfig,
  ) {
    return GestureDetector(
      onTap: () {
        _navigateToTopic(topicName, context);
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
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
                  fontFamily: 'TitanOne-Regular',
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Center(
                  child: _buildAnimatedIcon(
                    imagePath,
                    animationConfig,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon(
    String imagePath,
    Map<String, dynamic> animationConfig,
  ) {
    final animationType = animationConfig['type'] as String;
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final value = _animationController.value;
        
        switch (animationType) {
          case 'bounce':
            final amplitude = (animationConfig['amplitude'] as double?) ?? 12.0;
            final offset = sin(value * 2 * pi) * amplitude;
            return Transform.translate(
              offset: Offset(0, offset),
              child: child,
            );
            
          case 'float':
            final amplitude = (animationConfig['amplitude'] as double?) ?? 8.0;
            final rotation = (animationConfig['rotation'] as double?) ?? 0.05;
            final offset = sin(value * 2 * pi) * amplitude;
            final angle = sin(value * 2 * pi) * rotation;
            return Transform.translate(
              offset: Offset(0, offset),
              child: Transform.rotate(
                angle: angle,
                child: child,
              ),
            );
            
          case 'rotate':
            final rotation = (animationConfig['rotation'] as double?) ?? 0.2;
            final angle = sin(value * 2 * pi) * rotation;
            return Transform.rotate(
              angle: angle,
              child: child,
            );
            
          case 'pulse':
            final scaleAmount = (animationConfig['scale'] as double?) ?? 0.1;
            final scale = 1.0 + sin(value * 2 * pi) * scaleAmount;
            return Transform.scale(
              scale: scale,
              child: child,
            );
            
          case 'wave':
            final amplitude = (animationConfig['amplitude'] as double?) ?? 15.0;
            final frequency = (animationConfig['frequency'] as double?) ?? 4.0;
            final offset = sin(value * frequency * pi) * amplitude;
            return Transform.translate(
              offset: Offset(0, offset),
              child: child,
            );
            
          case 'swing':
            final amplitude = (animationConfig['amplitude'] as double?) ?? 20.0;
            final rotation = (animationConfig['rotation'] as double?) ?? 0.4;
            final offset = sin(value * 2 * pi) * (amplitude / 2);
            final angle = sin(value * 2 * pi) * rotation;
            return Transform.rotate(
              angle: angle,
              child: Transform.translate(
                offset: Offset(0, offset),
                child: child,
              ),
            );
            
          default:
            return child!;
        }
      },
      child: _buildLogoImage(imagePath),
    );
  }

  Widget _buildLogoImage(String imagePath) {
    return Image.asset(
      imagePath,
      height: 80,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return _buildFallbackIcon(imagePath);
      },
    );
  }

  Widget _buildFallbackIcon(String imagePath) {
    // Simple pulsing fallback animation
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final value = _animationController.value;
        final scale = 1.0 + sin(value * 2 * pi) * 0.1;
        
        return Transform.scale(
          scale: scale,
          child: Icon(
            _getIconForTopic(imagePath),
            size: 80,
            color: Colors.black.withOpacity(0.7),
          ),
        );
      },
    );
  }

  IconData _getIconForTopic(String imagePath) {
    if (imagePath.contains('number values')) return Icons.numbers;
    if (imagePath.contains('fundamental operations')) return Icons.calculate;
    if (imagePath.contains('fraction')) return Icons.pie_chart;
    if (imagePath.contains('decimal numbers')) return Icons.money;
    if (imagePath.contains('percentage')) return Icons.percent;
    if (imagePath.contains('mensuration')) return Icons.square_foot;
    return Icons.school;
  }

  void _navigateToTopic(String topicName, BuildContext context) {
    switch (topicName) {
      case 'Number Values':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NumberValuesLessonsScreen()),
        );
        break;
      case 'Fundamental Operations':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FundamentalOperationsLessonsScreen()),
        );
        break;
      case 'Fraction':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FractionLessonsScreen()),
        );
        break;
      case 'Decimal Numbers':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DecimalNumbersLessonsScreen()),
        );
        break;
      case 'Percentage':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PercentageLessonsScreen()),
        );
        break;
      case 'Mensuration':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MensurationLessonsScreen()),
        );
        break;
    }
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
            fontFamily: 'TitanOne-Regular',
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
                    fontFamily: 'TitanOne-Regular',
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
                        fontFamily: 'TitanOne-Regular',
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
                      fontFamily: 'TitanOne-Regular',
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
                                fontFamily: 'TitanOne-Regular',
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
                                    fontFamily: 'TitanOne-Regular',
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
            fontFamily: 'TitanOne-Regular',
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
                        fontFamily: 'TitanOne-Regular',
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
                            fontFamily: 'TitanOne-Regular',
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
                        fontFamily: 'TitanOne-Regular',
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
                          fontFamily: 'TitanOne-Regular',
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
            fontFamily: 'TitanOne-Regular',
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
                fontFamily: 'TitanOne-Regular',
              ),
            ),
            Text(
              UserProvider.getUserEmail(),
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'TitanOne-Regular',
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
                      fontWeight: FontWeight.bold,
                      fontFamily: 'TitanOne-Regular',
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
                  fontFamily: 'TitanOne-Regular',
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
              MaterialPageRoute(builder: (context) => const FrontPageScreen()),
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
                fontFamily: 'TitanOne-Regular',
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
            fontFamily: 'TitanOne-Regular',
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
                    fontWeight: FontWeight.bold,
                    fontFamily: 'TitanOne-Regular',
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
            fontFamily: 'TitanOne-Regular',
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
            fontFamily: 'TitanOne-Regular',
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
                fontFamily: 'TitanOne-Regular',
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
                          fontFamily: 'TitanOne-Regular',
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
                  fontWeight: FontWeight.bold,
                  fontFamily: 'TitanOne-Regular',
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
            fontFamily: 'TitanOne-Regular',
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
                      fontFamily: 'TitanOne-Regular',
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
                fontFamily: 'TitanOne-Regular',
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
                      fontFamily: 'TitanOne-Regular',
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Our support team is here to help you with any questions or issues you may have.',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'TitanOne-Regular',
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
                  fontFamily: 'TitanOne-Regular',
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
              fontFamily: 'TitanOne-Regular',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'TitanOne-Regular',
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
                  fontFamily: 'TitanOne-Regular',
                ),
              ),
              Text(
                details,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'TitanOne-Regular',
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
            fontFamily: 'TitanOne-Regular',
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
                      fontFamily: 'TitanOne-Regular',
                    ),
                  ),
                  const Text(
                    'Mathematics Learning App',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'TitanOne-Regular',
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
                fontFamily: 'TitanOne-Regular',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'SenyaMatika is an innovative educational app designed to make learning mathematics fun and engaging for students of all ages. Our app combines interactive lessons and progress tracking to help you master mathematical concepts.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'TitanOne-Regular',
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 25),
            
            const Text(
              'Key Features',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'TitanOne-Regular',
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
                      fontFamily: 'TitanOne-Regular',
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
                  fontFamily: 'TitanOne-Regular',
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
                    fontFamily: 'TitanOne-Regular',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'TitanOne-Regular',
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
              fontFamily: 'TitanOne-Regular',
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'TitanOne-Regular',
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
            fontFamily: 'TitanOne-Regular',
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
                fontFamily: 'TitanOne-Regular',
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
                      fontFamily: 'TitanOne-Regular',
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'We are committed to protecting your privacy and providing a safe learning environment.',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'TitanOne-Regular',
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
              fontFamily: 'TitanOne-Regular',
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'TitanOne-Regular',
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
            fontFamily: 'TitanOne-Regular',
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
                fontFamily: 'TitanOne-Regular',
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Terms of Use',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'TitanOne-Regular',
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'By using SenyaMatika, you agree to these terms and conditions. Please read them carefully.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'TitanOne-Regular',
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'User Responsibilities',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'TitanOne-Regular',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'You are responsible for maintaining the confidentiality of your account and password. You agree to accept responsibility for all activities that occur under your account.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'TitanOne-Regular',
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
            fontFamily: 'TitanOne-Regular',
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
                fontFamily: 'TitanOne-Regular',
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
                                      fontFamily: 'TitanOne-Regular',
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
                                    fontFamily: 'TitanOne-Regular',
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
                                        fontFamily: 'TitanOne-Regular',
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
                        fontFamily: 'TitanOne-Regular',
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
                fontFamily: 'TitanOne-Regular',
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
                    fontFamily: 'TitanOne-Regular',
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
            fontFamily: 'TitanOne-Regular',
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
                      fontFamily: 'TitanOne-Regular',
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
                    fontFamily: 'TitanOne-Regular',
                  ),
                ),
                if (_showResult)
                  Text(
                    'Score: $_score%',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'TitanOne-Regular',
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
                        fontFamily: 'TitanOne-Regular',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${_numbers[_currentQuestion]}',
                      style: const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'TitanOne-Regular',
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
                        fontFamily: 'TitanOne-Regular',
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
                          fontFamily: 'TitanOne-Regular',
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
                          fontFamily: 'TitanOne-Regular',
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
          fontFamily: 'TitanOne-Regular',
        ),
      ),
    );
  }
}

// SIGN DICTIONARY SCREEN - UPDATED WITH INDIVIDUAL MATHEMATICAL TERMS
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
            fontFamily: 'TitanOne-Regular',
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
                fontFamily: 'TitanOne-Regular',
              ),
            ),
            const Text(
              'Category',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'TitanOne-Regular',
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
                const SizedBox(height: 15),

                // NEW MATHEMATICAL TERMS - ADDING EACH AS INDIVIDUAL CATEGORIES
                Row(
                  children: [
                    Expanded(
                      child: _buildCategoryItem(
                        'Algebra',
                        const Color(0xFF9C89B8),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AlgebraDictionaryScreen()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    
                    Expanded(
                      child: _buildCategoryItem(
                        'Analog Clock',
                        const Color(0xFFF9A1BC),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AnalogClockDictionaryScreen()),
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
                        'Arithmetic Operations',
                        const Color(0xFF90BE6D),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ArithmeticOperationsDictionaryScreen()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    
                    Expanded(
                      child: _buildCategoryItem(
                        'Calculator',
                        const Color(0xFF43AA8B),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CalculatorDictionaryScreen()),
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
                        'Compose Number',
                        const Color(0xFF4D908E),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ComposeNumberDictionaryScreen()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    
                    Expanded(
                      child: _buildCategoryItem(
                        'Convert',
                        const Color(0xFF277DA1),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ConvertDictionaryScreen()),
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
                        'Decompose Number',
                        const Color(0xFF577590),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const DecomposeNumberDictionaryScreen()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    
                    Expanded(
                      child: _buildCategoryItem(
                        'Digital Clock',
                        const Color(0xFFF9844A),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const DigitalClockDictionaryScreen()),
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
                        'Geometry',
                        const Color(0xFFF8961E),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const GeometryDictionaryScreen()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    
                    Expanded(
                      child: _buildCategoryItem(
                        'Inverse operation',
                        const Color(0xFFF3722C),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const InverseOperationDictionaryScreen()),
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
                        'Learner',
                        const Color(0xFFF94144),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LearnerDictionaryScreen()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    
                    Expanded(
                      child: _buildCategoryItem(
                        'Non-Standard Measurement',
                        const Color(0xFF90BE6D),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const NonStandardMeasurementDictionaryScreen()),
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
                        'Pattern',
                        const Color(0xFF43AA8B),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PatternDictionaryScreen()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    
                    Expanded(
                      child: _buildCategoryItem(
                        'Pictograph',
                        const Color(0xFF4D908E),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PictographDictionaryScreen()),
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
                        'Probability',
                        const Color(0xFF277DA1),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ProbabilityDictionaryScreen()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    
                    Expanded(
                      child: _buildCategoryItem(
                        'Problem Solving',
                        const Color(0xFF577590),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ProblemSolvingDictionaryScreen()),
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
                        'Ratio and Proportion',
                        const Color(0xFFF9844A),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RatioProportionDictionaryScreen()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    
                    Expanded(
                      child: _buildCategoryItem(
                        'Square Grid',
                        const Color(0xFFF8961E),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SquareGridDictionaryScreen()),
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
                        'Standard of Units',
                        const Color(0xFFF3722C),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const StandardUnitsDictionaryScreen()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    
                    Expanded(
                      child: _buildCategoryItem(
                        'Table',
                        const Color(0xFFF94144),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TableDictionaryScreen()),
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
                        'Time',
                        const Color(0xFF90BE6D),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TimeDictionaryScreen()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    
                    Expanded(
                      child: _buildCategoryItem(
                        '3-Dimensional Object',
                        const Color(0xFF43AA8B),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ThreeDObjectDictionaryScreen()),
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
                        '2-Dimensional Object',
                        const Color(0xFF4D908E),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TwoDObjectDictionaryScreen()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    
                    Expanded(
                      child: _buildCategoryItem(
                        'Sequences',
                        const Color(0xFF277DA1),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SequencesDictionaryScreen()),
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
              fontSize: 14, // Slightly smaller for longer terms
              fontWeight: FontWeight.bold,
              fontFamily: 'TitanOne-Regular',
            ),
          ),
        ),
      ),
    );
  }
}

// INDIVIDUAL DICTIONARY SCREENS FOR EACH MATHEMATICAL TERM
class AlgebraDictionaryScreen extends StatelessWidget {
  const AlgebraDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      'Algebra', 
      const Color(0xFF9C89B8),
      videoAsset: 'assets/videos/algebra_asl.mp4',
    );
  }
}

class AnalogClockDictionaryScreen extends StatelessWidget {
  const AnalogClockDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      'Analog Clock', 
      const Color(0xFFF9A1BC),
      videoAsset: 'assets/videos/analog_clock_asl.mp4',
    );
  }
}

class ArithmeticOperationsDictionaryScreen extends StatelessWidget {
  const ArithmeticOperationsDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      'Arithmetic Operations', 
      const Color(0xFF90BE6D),
      videoAsset: 'assets/videos/arithmetic_operations_asl.mp4',
    );
  }
}

class CalculatorDictionaryScreen extends StatelessWidget {
  const CalculatorDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      'Calculator', 
      const Color(0xFF43AA8B),
      videoAsset: 'assets/videos/calculator_asl.mp4',
    );
  }
}

class ComposeNumberDictionaryScreen extends StatelessWidget {
  const ComposeNumberDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      'Compose Number', 
      const Color(0xFF4D908E),
      videoAsset: 'assets/videos/compose_number_asl.mp4',
    );
  }
}

class ConvertDictionaryScreen extends StatelessWidget {
  const ConvertDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      'Convert', 
      const Color(0xFF277DA1),
      videoAsset: 'assets/videos/convert_asl.mp4',
    );
  }
}

class DecomposeNumberDictionaryScreen extends StatelessWidget {
  const DecomposeNumberDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      'Decompose Number', 
      const Color(0xFF577590),
      videoAsset: 'assets/videos/decompose_number_asl.mp4',
    );
  }
}

class DigitalClockDictionaryScreen extends StatelessWidget {
  const DigitalClockDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      'Digital Clock', 
      const Color(0xFFF9844A),
      videoAsset: 'assets/videos/digital_clock_asl.mp4',
    );
  }
}

class GeometryDictionaryScreen extends StatelessWidget {
  const GeometryDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      'Geometry', 
      const Color(0xFFF8961E),
      videoAsset: 'assets/videos/geometry_asl.mp4',
    );
  }
}

class InverseOperationDictionaryScreen extends StatelessWidget {
  const InverseOperationDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      'Inverse operation', 
      const Color(0xFFF3722C),
      videoAsset: 'assets/videos/inverse_operation_asl.mp4',
    );
  }
}

class LearnerDictionaryScreen extends StatelessWidget {
  const LearnerDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      'Learner', 
      const Color(0xFFF94144),
      videoAsset: 'assets/videos/learner_asl.mp4',
    );
  }
}

class NonStandardMeasurementDictionaryScreen extends StatelessWidget {
  const NonStandardMeasurementDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      'Non-Standard Measurement', 
      const Color(0xFF90BE6D),
      videoAsset: 'assets/videos/non_standard_measurement_asl.mp4',
    );
  }
}

class PatternDictionaryScreen extends StatelessWidget {
  const PatternDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      'Pattern', 
      const Color(0xFF43AA8B),
      videoAsset: 'assets/videos/pattern_asl.mp4',
    );
  }
}

class PictographDictionaryScreen extends StatelessWidget {
  const PictographDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      'Pictograph', 
      const Color(0xFF4D908E),
      videoAsset: 'assets/videos/pictograph_asl.mp4',
    );
  }
}

class ProbabilityDictionaryScreen extends StatelessWidget {
  const ProbabilityDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      'Probability', 
      const Color(0xFF277DA1),
      videoAsset: 'assets/videos/probability_asl.mp4',
    );
  }
}

class ProblemSolvingDictionaryScreen extends StatelessWidget {
  const ProblemSolvingDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      'Problem Solving', 
      const Color(0xFF577590),
      videoAsset: 'assets/videos/problem_solving_asl.mp4',
    );
  }
}

class RatioProportionDictionaryScreen extends StatelessWidget {
  const RatioProportionDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      'Ratio and Proportion', 
      const Color(0xFFF9844A),
      videoAsset: 'assets/videos/ratio_proportion_asl.mp4',
    );
  }
}

class SquareGridDictionaryScreen extends StatelessWidget {
  const SquareGridDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      'Square Grid', 
      const Color(0xFFF8961E),
      videoAsset: 'assets/videos/square_grid_asl.mp4',
    );
  }
}

class StandardUnitsDictionaryScreen extends StatelessWidget {
  const StandardUnitsDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      'Standard of Units', 
      const Color(0xFFF3722C),
      videoAsset: 'assets/videos/standard_units_asl.mp4',
    );
  }
}

class TableDictionaryScreen extends StatelessWidget {
  const TableDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      'Table', 
      const Color(0xFFF94144),
      videoAsset: 'assets/videos/table_asl.mp4',
    );
  }
}

class TimeDictionaryScreen extends StatelessWidget {
  const TimeDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      'Time', 
      const Color(0xFF90BE6D),
      videoAsset: 'assets/videos/time_asl.mp4',
    );
  }
}

class ThreeDObjectDictionaryScreen extends StatelessWidget {
  const ThreeDObjectDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      '3-Dimensional Object', 
      const Color(0xFF43AA8B),
      videoAsset: 'assets/videos/3d_object_asl.mp4',
    );
  }
}

class TwoDObjectDictionaryScreen extends StatelessWidget {
  const TwoDObjectDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      '2-Dimensional Object', 
      const Color(0xFF4D908E),
      videoAsset: 'assets/videos/2d_object_asl.mp4',
    );
  }
}

class SequencesDictionaryScreen extends StatelessWidget {
  const SequencesDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      'Sequences', 
      const Color(0xFF277DA1),
      videoAsset: 'assets/videos/sequences_asl.mp4',
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
            fontFamily: 'TitanOne-Regular',
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
            fontFamily: 'TitanOne-Regular',
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
            fontFamily: 'TitanOne-Regular',
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
              fontFamily: 'TitanOne-Regular',
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
                  fontFamily: 'TitanOne-Regular',
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
                    fontFamily: 'TitanOne-Regular',
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
                        fontFamily: 'TitanOne-Regular',
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
          fontFamily: 'TitanOne-Regular',
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
                  fontFamily: 'TitanOne-Regular',
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
                      fontFamily: 'TitanOne-Regular',
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (videoAsset == null)
                    const Text(
                      '(Video coming soon)',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'TitanOne-Regular',
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