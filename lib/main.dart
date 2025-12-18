import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';



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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
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

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2E9B8),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Center(
                child: Column(
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
                        minimumSize: const Size(200, 50),
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
                      child: const Text('Create Account'),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: const Size(200, 50),
                        elevation: 3,
                        shadowColor: Colors.black.withOpacity(0.25),
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
                          MaterialPageRoute(builder: (context) => const SignInScreen()),
                        );
                      },
                      child: const Text('Log In'),
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

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool _passwordsMatch = true;

  void _checkMatch() {
    setState(() {
      _passwordsMatch = _passwordController.text == _confirmController.text;
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2E9B8),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'LondrinaSolid',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const _InputField(label: 'Name:'),
              const _InputField(label: 'Username:'),
              const _InputField(label: 'Email:'),
              _InputField(
                label: 'Password:',
                obscure: true,
                controller: _passwordController,
                onChanged: (_) => _checkMatch(),
              ),
              _InputField(
                label: 'Confirm Password:',
                obscure: true,
                controller: _confirmController,
                onChanged: (_) => _checkMatch(),
                showError: !_passwordsMatch,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFF59D),
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                    side: const BorderSide(color: Colors.black, width: 1),
                  ),
                ),
                onPressed: () {
                  if (_passwordsMatch) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const SignInScreen()),
                    );
                  }
                },
                child: const Text(
                  'Create',
                  style: TextStyle(fontFamily: 'LondrinaSolid', fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                    side: const BorderSide(color: Colors.black, width: 1),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'Google',
                  style: TextStyle(fontFamily: 'LondrinaSolid', fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatefulWidget {
  final String label;
  final bool obscure;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final bool showError;

  const _InputField({
    required this.label,
    this.obscure = false,
    this.controller,
    this.onChanged,
    this.showError = false,
  });

  @override
  State<_InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<_InputField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'LondrinaSolid',
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: widget.controller,
          obscureText: _isObscured,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF2F2F2),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: widget.showError ? Colors.red : Colors.black,
                width: 1,
              ),
            ),
            suffixIcon: widget.obscure
                ? IconButton(
                    icon: Icon(
                      _isObscured ? Icons.visibility_off : Icons.visibility,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                  )
                : null,
          ),
        ),
        if (widget.showError)
          const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              'Passwords do not match',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        const SizedBox(height: 15),
      ],
    );
  }
}

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2E9B8),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 10),
              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'LondrinaSolid',
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Sign In to Continue',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'LondrinaSolid',
                ),
              ),
              const SizedBox(height: 30),
              const _InputField(label: 'Email:'),
              const _InputField(label: 'Password:', obscure: true),
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
                      fontFamily: 'LondrinaSolid',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFF59D),
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                    side: const BorderSide(color: Colors.black, width: 1),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const DashboardScreen()),
                  );
                },
                child: const Text('Log In', style: TextStyle(fontFamily: 'LondrinaSolid', fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                    side: const BorderSide(color: Colors.black, width: 1),
                  ),
                ),
                onPressed: () {
                  // Add Google login logic here
                },
                child: const Text('Log In with Google', style: TextStyle(fontFamily: 'LondrinaSolid', fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// FORGOT PASSWORD SCREEN
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  void _sendResetLink() async {
    if (_emailController.text.isEmpty) {
      _showErrorSnackBar('Please enter your email address');
      return;
    }

    // Simple email validation
    if (!_emailController.text.contains('@')) {
      _showErrorSnackBar('Please enter a valid email address');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // Show success message
    _showSuccessSnackBar();

    // Navigate back to sign in screen after a short delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.pop(context);
    });
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Password reset link sent to your email',
          style: TextStyle(
            fontFamily: 'LondrinaSolid',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: 'LondrinaSolid',
          ),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2E9B8),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 20),
              
              // Title
              const Text(
                'Forgot Password?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'LondrinaSolid',
                ),
              ),
              const SizedBox(height: 10),
              
              // Instruction Text
              const Text(
                'Enter your email address:',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'LondrinaSolid',
                ),
              ),
              const SizedBox(height: 30),
              
              // Email Input Field
              const Text(
                'Your Email',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'LondrinaSolid',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black, width: 1),
                  ),
                  hintText: 'Enter your email address',
                  hintStyle: const TextStyle(
                    fontFamily: 'LondrinaSolid',
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              // Send Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFF59D),
                    foregroundColor: Colors.black,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                      side: const BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                  onPressed: _isLoading ? null : _sendResetLink,
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
                          'Send',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'LondrinaSolid',
                          ),
                        ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Additional Help Text
              const Center(
                child: Text(
                  'We will send a password reset link to your email',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'LondrinaSolid',
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// DASHBOARD SCREEN
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EAD6),
      body: SafeArea(
        child: Column(
          children: [
            // TOP SECTION - FIXED
           Container(
  padding: const EdgeInsets.all(20.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start, // ITO NA ANG NAKA-LEFT ALIGN
    children: [
      const SizedBox(height: 20),
      const Align(
        alignment: Alignment.centerLeft, // EXPLICIT LEFT ALIGN
        child: Text(
          'Hello',
          style: TextStyle(
            fontSize: 28,
            fontFamily: 'LondrinaSolid',
          ),
        ),
      ),
      const Align(
        alignment: Alignment.centerLeft, // EXPLICIT LEFT ALIGN
        child: Text(
          'Jake',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            fontFamily: 'LondrinaSolid',
          ),
        ),
      ),
      const SizedBox(height: 30),
                  // Grid Title
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
            
            // MIDDLE SECTION - SCROLLABLE GRID (TAKES ALL AVAILABLE SPACE)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    // Grid Buttons
                    Column(
                      children: [
                        // First Row
                        Row(
                          children: [
                            // Topics Button
                            Expanded(
                              child: Container(
                                height: 120,
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
                                          Icon(Icons.menu_book, size: 40, color: Colors.black),
                                          const SizedBox(height: 8),
                                          const Text(
                                            'Topics',
                                            style: TextStyle(
                                              fontSize: 18,
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
                            const SizedBox(width: 15),
                            
                            // Quizzes Button
                            Expanded(
                              child: Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFCE1E4),
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
                                        MaterialPageRoute(builder: (context) => const QuizzesScreen()),
                                      );
                                    },
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.quiz, size: 40, color: Colors.black),
                                          const SizedBox(height: 8),
                                          const Text(
                                            'Quizzes',
                                            style: TextStyle(
                                              fontSize: 18,
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
                        const SizedBox(height: 15),
                        
                        // Second Row
                        Row(
                          children: [
                            // Progress Button
                            Expanded(
                              child: Container(
                                height: 120,
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
                                          Icon(Icons.trending_up, size: 40, color: Colors.black),
                                          const SizedBox(height: 8),
                                          const Text(
                                            'Progress',
                                            style: TextStyle(
                                              fontSize: 18,
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
                            const SizedBox(width: 15),
                            
                            // Sign Dictionary Button
                            Expanded(
                              child: Container(
                                height: 120,
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
                                          Icon(Icons.sign_language, size: 40, color: Colors.black),
                                          const SizedBox(height: 8),
                                          const Text(
                                            'Sign\nDictionary',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 18,
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
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            
            // BOTTOM SECTION - FIXED AT THE BOTTOM
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
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Home Icon
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF59D),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      child: const Icon(Icons.home, size: 28, color: Colors.black),
                    ),
                    
                    // Profile Icon - CLICKABLE!
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
                        child: const Icon(Icons.account_circle, size: 28, color: Colors.black),
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
            // Whole Numbers - GAYA NG SA LANGUAGE SELECTION
            _buildClickableLessonItem(
              'Whole Numbers', 
              const Color(0xFFA8D5E3),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LanguageSelectionScreen(lessonName: 'Whole Numbers')),
                );
              },
            ),
            const SizedBox(height: 15),
            
            // Comparison - LOCKED
            _buildLockedLessonItem('Comparison', const Color(0xFFF5C6D6)),
            const SizedBox(height: 15),
            
            // Ordinal Numbers - LOCKED
            _buildLockedLessonItem('Ordinal Numbers', const Color(0xFFC4B1E1)),
            const SizedBox(height: 15),
            
            // Money Value - LOCKED
            _buildLockedLessonItem('Money Value', const Color(0xFFA8D5BA)),
          ],
        ),
      ),
    );
  }

  // GAYA NG GINAMIT SA LANGUAGE SELECTION SCREEN
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
      ),
    );
  }
}


// PROGRESS SCREEN - FIXED NO OVERFLOW
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
              // Title Section
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
              
              // Overall Progress Section
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
                    
                    // Progress Bar with percentage
                    Stack(
                      children: [
                        // Progress Bar Background
                        Container(
                          width: double.infinity,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                        ),
                        
                        // Progress Fill
                        Container(
                          width: (75 / 100) * (MediaQuery.of(context).size.width - 80), // Adjusted for padding
                          height: 20,
                          decoration: BoxDecoration(
                            color: const Color(0xFF6B8E6B),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        
                        // Percentage Text
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
              
              // Lessons and Quizzes Row
              Row(
                children: [
                  // Lessons In Progress - Light Pink (CLICKABLE)
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
                            
                            // Number 4 in a circle
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
                  
                  // Quizzes - Light Purple (CLICKABLE)
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
                            
                            // Number 7 in a circle
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
              const SizedBox(height: 20),
              
              // Additional Progress Sections (if needed)
              // Add more content here if necessary, but make sure it fits within the scrollable area
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
            // Title
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
            
            // Progress Items
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
          // Progress Bar
          Stack(
            children: [
              // Progress Bar Background
              Container(
                width: double.infinity,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black, width: 1),
                ),
              ),
              // Progress Fill
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
            // Title
            const Text(
              'Scores',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'LondrinaSolid',
              ),
            ),
            const SizedBox(height: 30),
            
            // Quiz Score Items
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
// TOPICS SCREEN - DEBUG VERSION
// TOPICS SCREEN - WITH YOUR IMAGES
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
              // Number Values - Light Blue box (CLICKABLE)
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
                  // Image for Number Values - WITH SPACE IN FILENAME
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
              
              // Fundamental Operations - Light Pink box  
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
              
              // Fraction - Light Purple box (NOW CLICKABLE)
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
                  // Image for Fraction
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

              // DECIMAL NUMBERS - BAGONG DAGDAG (NOW CLICKABLE)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DecimalNumbersLessonsScreen()),
                  );
                },
                child: _buildTopicItem(
                  'Decimal Numbers', 
                  const Color(0xFFFFD8A8), // Light Orange
                  // Icon for Decimal Numbers
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

              // PERCENTAGE - BAGONG DAGDAG (NOW CLICKABLE)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PercentageLessonsScreen()),
                  );
                },
                child: _buildTopicItem(
                  'Percentage', 
                  const Color(0xFFA8E3B5), // Light Green
                  // Icon for Percentage
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

              // MENSURATION - BAGONG DAGDAG (NOW CLICKABLE)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MensurationLessonsScreen()),
                  );
                },
                child: _buildTopicItem(
                  'Mensuration', 
                  const Color(0xFFD8A8FF), // Light Purple
                  // Icon for Mensuration
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

// QUIZZES SCREEN - UPDATED WITH NAVIGATION TO LANGUAGE SELECTION
class QuizzesScreen extends StatelessWidget {
  const QuizzesScreen({super.key});

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
          'Quizzes',
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
              // Number Values - NOW CLICKABLE
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QuizLanguageSelectionScreen(quizName: 'Number Values')),
                  );
                },
                child: _buildQuizItem(
                  'Number Values', 
                  const Color(0xFFA8D5E3),
                  Center(
                    child: Image.asset(
                      'assets/images/number values logo.png',
                      height: 80,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.numbers, size: 60, color: Colors.black);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Fundamental Operations - NOW CLICKABLE
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QuizLanguageSelectionScreen(quizName: 'Fundamental Operations')),
                  );
                },
                child: _buildQuizItem(
                  'Fundamental Operations', 
                  const Color(0xFFF5C6D6),
                  Center(
                    child: Image.asset(
                      'assets/images/fundamental operations.png',
                      height: 80,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.calculate, size: 60, color: Colors.black);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Fraction - NOW CLICKABLE
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QuizLanguageSelectionScreen(quizName: 'Fraction')),
                  );
                },
                child: _buildQuizItem(
                  'Fraction', 
                  const Color(0xFFC4B1E1),
                  Center(
                    child: Image.asset(
                      'assets/images/fraction.png',
                      height: 80,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.pie_chart, size: 60, color: Colors.black);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Decimal Numbers - NOW CLICKABLE
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QuizLanguageSelectionScreen(quizName: 'Decimal Numbers')),
                  );
                },
                child: _buildQuizItem(
                  'Decimal Numbers', 
                  const Color(0xFFFFD8A8),
                  Center(
                    child: Image.asset(
                      'assets/images/decimal numbers.png',
                      height: 80,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.money, size: 60, color: Colors.black);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Percentage - NOW CLICKABLE
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QuizLanguageSelectionScreen(quizName: 'Percentage')),
                  );
                },
                child: _buildQuizItem(
                  'Percentage', 
                  const Color(0xFFA8E3B5),
                  Center(
                    child: Image.asset(
                      'assets/images/percentage.png',
                      height: 80,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.percent, size: 60, color: Colors.black);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Mensuration - NOW CLICKABLE
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QuizLanguageSelectionScreen(quizName: 'Mensuration')),
                  );
                },
                child: _buildQuizItem(
                  'Mensuration', 
                  const Color(0xFFD8A8FF),
                  Center(
                    child: Image.asset(
                      'assets/images/mensuration.png',
                      height: 80,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.straighten, size: 60, color: Colors.black);
                      },
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

  Widget _buildQuizItem(String title, Color boxColor, Widget content) {
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
            title,
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

// SIGN LANGUAGE IDENTIFICATION QUIZ LANGUAGE SELECTION
class SignLanguageIDQuizLanguageScreen extends StatelessWidget {
  const SignLanguageIDQuizLanguageScreen({super.key});

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
          'Sign Language ID Quiz',
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Choose Sign Language\nfor Quiz Instructions',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'LondrinaSolid',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Identify FSL signs for numbers 1-20',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'LondrinaSolid',
              ),
            ),
            const SizedBox(height: 50),
            
            // ASL Button
            _buildLanguageButton(
              context,
              'ASL',
              'American Sign Language',
              const Color(0xFFA8D5E3),
              Icons.language,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignLanguageIDQuizInstructionScreen(language: 'ASL')),
                );
              },
            ),
            const SizedBox(height: 25),
            
            // FSL Button
            _buildLanguageButton(
              context,
              'FSL',
              'Filipino Sign Language',
              const Color(0xFFF5C6D6),
              Icons.flag,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignLanguageIDQuizInstructionScreen(language: 'FSL')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageButton(BuildContext context, String shortName, String fullName, Color color, IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 280,
          height: 100,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.black),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shortName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'LondrinaSolid',
                      ),
                    ),
                    Text(
                      fullName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'LondrinaSolid',
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}

// COUNTING QUIZ LANGUAGE SELECTION
class CountingQuizLanguageScreen extends StatelessWidget {
  const CountingQuizLanguageScreen({super.key});

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
          'Counting 1-20 Quiz',
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Choose Sign Language\nfor Quiz Instructions',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'LondrinaSolid',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Practice counting from 1 to 20',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'LondrinaSolid',
              ),
            ),
            const SizedBox(height: 50),
            
            // ASL Button
            _buildLanguageButton(
              context,
              'ASL',
              'American Sign Language',
              const Color(0xFFA8D5E3),
              Icons.language,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CountingQuizInstructionScreen(language: 'ASL')),
                );
              },
            ),
            const SizedBox(height: 25),
            
            // FSL Button
            _buildLanguageButton(
              context,
              'FSL',
              'Filipino Sign Language',
              const Color(0xFFF5C6D6),
              Icons.flag,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CountingQuizInstructionScreen(language: 'FSL')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageButton(BuildContext context, String shortName, String fullName, Color color, IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 280,
          height: 100,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.black),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shortName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'LondrinaSolid',
                      ),
                    ),
                    Text(
                      fullName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'LondrinaSolid',
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}

// SIGN LANGUAGE IDENTIFICATION QUIZ INSTRUCTION SCREEN
class SignLanguageIDQuizInstructionScreen extends StatelessWidget {
  final String language;

  const SignLanguageIDQuizInstructionScreen({super.key, required this.language});

  void _startQuiz(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignLanguageIDQuizScreen()),
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
        title: Text(
          'Instructions - $language',
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Title
            Text(
              'Sign Language ID Quiz',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'LondrinaSolid',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Identify the correct number for each FSL sign',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'LondrinaSolid',
              ),
            ),
            const SizedBox(height: 30),

            // Instruction Content
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.help_outline, size: 60, color: Colors.blue),
                    const SizedBox(height: 20),
                    const Text(
                      'How to Play:',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'LondrinaSolid',
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      '• Look at the FSL sign image\n'
                      '• Choose the correct number it represents\n'
                      '• Numbers range from 1 to 20\n'
                      '• 20 questions total\n'
                      '• Get instant feedback after each answer',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'LondrinaSolid',
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Icon(Icons.emoji_events, size: 40, color: Colors.amber),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Start Quiz Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFF59D),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                    side: const BorderSide(color: Colors.black, width: 1),
                  ),
                ),
                onPressed: () => _startQuiz(context),
                child: const Text(
                  'Start Sign Language ID Quiz',
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

// COUNTING QUIZ INSTRUCTION SCREEN
class CountingQuizInstructionScreen extends StatelessWidget {
  final String language;

  const CountingQuizInstructionScreen({super.key, required this.language});

  void _startQuiz(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const CountingQuizScreen()),
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
        title: Text(
          'Instructions - $language',
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Title
            Text(
              'Counting 1-20 Quiz',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'LondrinaSolid',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Practice counting and number sequences',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'LondrinaSolid',
              ),
            ),
            const SizedBox(height: 30),

            // Instruction Content
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.format_list_numbered, size: 60, color: Colors.green),
                    const SizedBox(height: 20),
                    const Text(
                      'How to Play:',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'LondrinaSolid',
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      '• Answer questions about counting\n'
                      '• Fill in missing numbers in sequences\n'
                      '• Identify what comes before/after\n'
                      '• Numbers from 1 to 20 only\n'
                      '• 20 questions total',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'LondrinaSolid',
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Icon(Icons.trending_up, size: 40, color: Colors.green),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Start Quiz Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFF59D),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                    side: const BorderSide(color: Colors.black, width: 1),
                  ),
                ),
                onPressed: () => _startQuiz(context),
                child: const Text(
                  'Start Counting Quiz',
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

// SIGN LANGUAGE IDENTIFICATION QUIZ SCREEN
class SignLanguageIDQuizScreen extends StatefulWidget {
  const SignLanguageIDQuizScreen({super.key});

  @override
  State<SignLanguageIDQuizScreen> createState() => _SignLanguageIDQuizScreenState();
}

class _SignLanguageIDQuizScreenState extends State<SignLanguageIDQuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _quizCompleted = false;
  List<bool> _answeredQuestions = List.generate(20, (index) => false);
  List<int?> _selectedAnswers = List.generate(20, (index) => null);

  final List<SignLanguageQuestion> _questions = [
    // FSL Sign Identification Questions (1-20)
    SignLanguageQuestion(
      question: "What number is this FSL sign?",
      options: ["1", "2", "3", "4"],
      correctAnswer: 0,
      imageAsset: "assets/images/fsl_1.png",
    ),
    SignLanguageQuestion(
      question: "Identify this FSL number:",
      options: ["1", "2", "3", "4"],
      correctAnswer: 1,
      imageAsset: "assets/images/fsl_2.png",
    ),
    SignLanguageQuestion(
      question: "What number does this sign represent?",
      options: ["2", "3", "4", "5"],
      correctAnswer: 1,
      imageAsset: "assets/images/fsl_3.png",
    ),
    SignLanguageQuestion(
      question: "Which number is shown in FSL?",
      options: ["3", "4", "5", "6"],
      correctAnswer: 1,
      imageAsset: "assets/images/fsl_4.png",
    ),
    SignLanguageQuestion(
      question: "Identify the FSL number:",
      options: ["4", "5", "6", "7"],
      correctAnswer: 1,
      imageAsset: "assets/images/fsl_5.png",
    ),
    SignLanguageQuestion(
      question: "What number is this?",
      options: ["5", "6", "7", "8"],
      correctAnswer: 1,
      imageAsset: "assets/images/fsl_6.png",
    ),
    SignLanguageQuestion(
      question: "Which number is displayed?",
      options: ["6", "7", "8", "9"],
      correctAnswer: 1,
      imageAsset: "assets/images/fsl_7.png",
    ),
    SignLanguageQuestion(
      question: "Identify this FSL sign:",
      options: ["7", "8", "9", "10"],
      correctAnswer: 1,
      imageAsset: "assets/images/fsl_8.png",
    ),
    SignLanguageQuestion(
      question: "What number does this represent?",
      options: ["8", "9", "10", "11"],
      correctAnswer: 1,
      imageAsset: "assets/images/fsl_9.png",
    ),
    SignLanguageQuestion(
      question: "Which number is shown?",
      options: ["9", "10", "11", "12"],
      correctAnswer: 1,
      imageAsset: "assets/images/fsl_10.png",
    ),
    SignLanguageQuestion(
      question: "Identify the FSL number:",
      options: ["10", "11", "12", "13"],
      correctAnswer: 1,
      imageAsset: "assets/images/fsl_11.png",
    ),
    SignLanguageQuestion(
      question: "What number is this sign?",
      options: ["11", "12", "13", "14"],
      correctAnswer: 1,
      imageAsset: "assets/images/fsl_12.png",
    ),
    SignLanguageQuestion(
      question: "Which number is displayed in FSL?",
      options: ["12", "13", "14", "15"],
      correctAnswer: 1,
      imageAsset: "assets/images/fsl_13.png",
    ),
    SignLanguageQuestion(
      question: "Identify this number:",
      options: ["13", "14", "15", "16"],
      correctAnswer: 1,
      imageAsset: "assets/images/fsl_14.png",
    ),
    SignLanguageQuestion(
      question: "What number does this FSL sign show?",
      options: ["14", "15", "16", "17"],
      correctAnswer: 1,
      imageAsset: "assets/images/fsl_15.png",
    ),
    SignLanguageQuestion(
      question: "Which number is this?",
      options: ["15", "16", "17", "18"],
      correctAnswer: 1,
      imageAsset: "assets/images/fsl_16.png",
    ),
    SignLanguageQuestion(
      question: "Identify the FSL number:",
      options: ["16", "17", "18", "19"],
      correctAnswer: 1,
      imageAsset: "assets/images/fsl_17.png",
    ),
    SignLanguageQuestion(
      question: "What number is shown?",
      options: ["17", "18", "19", "20"],
      correctAnswer: 1,
      imageAsset: "assets/images/fsl_18.png",
    ),
    SignLanguageQuestion(
      question: "Which number does this represent?",
      options: ["18", "19", "20", "21"],
      correctAnswer: 1,
      imageAsset: "assets/images/fsl_19.png",
    ),
    SignLanguageQuestion(
      question: "Identify this FSL sign:",
      options: ["19", "20", "21", "22"],
      correctAnswer: 1,
      imageAsset: "assets/images/fsl_20.png",
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
          'Sign Language ID Quiz',
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
            // Progress and Score
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
                    const Icon(Icons.emoji_events, color: Colors.amber, size: 24),
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
            
            // Progress Bar
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / 20,
              backgroundColor: Colors.grey[300],
              color: const Color(0xFF6B8E6B),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 30),

            // Question Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(3, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Question Text
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

                  // FSL Sign Image
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: Image.asset(
                      currentQuestion.imageAsset,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.sign_language, size: 60, color: Colors.grey),
                              SizedBox(height: 10),
                              Text(
                                'FSL Sign',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'LondrinaSolid',
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Options
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

            const SizedBox(height: 30),

            // Navigation Buttons
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
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back),
                        SizedBox(width: 5),
                        Text('Previous'),
                      ],
                    ),
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
                        ? const Text('Finish Quiz')
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Next'),
                              SizedBox(width: 5),
                              Icon(Icons.arrow_forward),
                            ],
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

  Widget _buildResultsScreen() {
    final percentage = (_score / 20 * 100).toInt();
    
    String resultText = '';
    String emoji = '';
    Color color = Colors.green;

    if (percentage >= 90) {
      resultText = 'Sign Language Expert!';
      emoji = '🏆';
      color = Colors.green;
    } else if (percentage >= 70) {
      resultText = 'Great Job!';
      emoji = '🎉';
      color = Colors.blue;
    } else if (percentage >= 50) {
      resultText = 'Good Start!';
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
                      color: Colors.black.withOpacity(0.2),
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
                        const Icon(Icons.sign_language, color: Colors.amber, size: 40),
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
                    const SizedBox(height: 10),
                    
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: const Size(200, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: const BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Back to Quizzes',
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

// COUNTING QUIZ SCREEN
class CountingQuizScreen extends StatefulWidget {
  const CountingQuizScreen({super.key});

  @override
  State<CountingQuizScreen> createState() => _CountingQuizScreenState();
}

class _CountingQuizScreenState extends State<CountingQuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _quizCompleted = false;
  List<bool> _answeredQuestions = List.generate(20, (index) => false);
  List<int?> _selectedAnswers = List.generate(20, (index) => null);

  final List<CountingQuestion> _questions = [
    // Counting Questions (1-20 only)
    CountingQuestion(
      question: "What number comes AFTER 5?",
      options: ["4", "5", "6", "7"],
      correctAnswer: 2,
    ),
    CountingQuestion(
      question: "What number comes BEFORE 8?",
      options: ["6", "7", "8", "9"],
      correctAnswer: 1,
    ),
    CountingQuestion(
      question: "What is 3 + 2?",
      options: ["4", "5", "6", "7"],
      correctAnswer: 1,
    ),
    CountingQuestion(
      question: "What is 7 - 3?",
      options: ["3", "4", "5", "6"],
      correctAnswer: 1,
    ),
    CountingQuestion(
      question: "Count: 10, 11, 12, ?",
      options: ["13", "14", "15", "16"],
      correctAnswer: 0,
    ),
    CountingQuestion(
      question: "What is missing: 15, 16, ?, 18",
      options: ["17", "16", "15", "19"],
      correctAnswer: 0,
    ),
    CountingQuestion(
      question: "What is 4 + 4?",
      options: ["7", "8", "9", "10"],
      correctAnswer: 1,
    ),
    CountingQuestion(
      question: "What is 9 - 2?",
      options: ["6", "7", "8", "9"],
      correctAnswer: 1,
    ),
    CountingQuestion(
      question: "Count backwards: 20, 19, 18, ?",
      options: ["17", "16", "15", "14"],
      correctAnswer: 0,
    ),
    CountingQuestion(
      question: "What number is between 14 and 16?",
      options: ["13", "14", "15", "16"],
      correctAnswer: 2,
    ),
    CountingQuestion(
      question: "What is 6 + 3?",
      options: ["8", "9", "10", "11"],
      correctAnswer: 1,
    ),
    CountingQuestion(
      question: "What is 12 - 5?",
      options: ["6", "7", "8", "9"],
      correctAnswer: 1,
    ),
    CountingQuestion(
      question: "What comes AFTER 17?",
      options: ["16", "17", "18", "19"],
      correctAnswer: 2,
    ),
    CountingQuestion(
      question: "What comes BEFORE 13?",
      options: ["11", "12", "13", "14"],
      correctAnswer: 1,
    ),
    CountingQuestion(
      question: "What is 8 + 2?",
      options: ["9", "10", "11", "12"],
      correctAnswer: 1,
    ),
    CountingQuestion(
      question: "What is 15 - 8?",
      options: ["6", "7", "8", "9"],
      correctAnswer: 1,
    ),
    CountingQuestion(
      question: "Count: 1, 2, 3, 4, ?",
      options: ["4", "5", "6", "7"],
      correctAnswer: 1,
    ),
    CountingQuestion(
      question: "What is missing: 10, ?, 12, 13",
      options: ["9", "10", "11", "12"],
      correctAnswer: 2,
    ),
    CountingQuestion(
      question: "What is 5 + 6?",
      options: ["10", "11", "12", "13"],
      correctAnswer: 1,
    ),
    CountingQuestion(
      question: "What is 20 - 10?",
      options: ["8", "9", "10", "11"],
      correctAnswer: 2,
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
          'Counting 1-20 Quiz',
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
            // Progress and Score
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
                    const Icon(Icons.emoji_events, color: Colors.amber, size: 24),
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
            
            // Progress Bar
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / 20,
              backgroundColor: Colors.grey[300],
              color: const Color(0xFF6B8E6B),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 30),

            // Question Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(3, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Question Text
                  Text(
                    currentQuestion.question,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'LondrinaSolid',
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Options
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

            const SizedBox(height: 30),

            // Navigation Buttons
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
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back),
                        SizedBox(width: 5),
                        Text('Previous'),
                      ],
                    ),
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
                        ? const Text('Finish Quiz')
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Next'),
                              SizedBox(width: 5),
                              Icon(Icons.arrow_forward),
                            ],
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

  Widget _buildResultsScreen() {
    final percentage = (_score / 20 * 100).toInt();
    
    String resultText = '';
    String emoji = '';
    Color color = Colors.green;

    if (percentage >= 90) {
      resultText = 'Counting Master!';
      emoji = '🏆';
      color = Colors.green;
    } else if (percentage >= 70) {
      resultText = 'Great Job!';
      emoji = '🎉';
      color = Colors.blue;
    } else if (percentage >= 50) {
      resultText = 'Good Work!';
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
                      color: Colors.black.withOpacity(0.2),
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
                        const Icon(Icons.format_list_numbered, color: Colors.amber, size: 40),
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
                    const SizedBox(height: 10),
                    
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: const Size(200, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: const BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Back to Quizzes',
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

// DATA MODELS
class SignLanguageQuestion {
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String imageAsset;

  SignLanguageQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.imageAsset,
  });
}

class CountingQuestion {
  final String question;
  final List<String> options;
  final int correctAnswer;

  CountingQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });
}
// PROFILE SCREEN
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
            // Profile Header
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
            const Text(
              'Jake Baraquiel',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'LondrinaSolid',
              ),
            ),
            const SizedBox(height: 40),
            
            // Profile Options List
            Expanded(
              child: ListView(
                children: [
                  _buildProfileItem('Edit Profile', Icons.arrow_forward_ios, context),
                  _buildProfileItem('Change Password', Icons.arrow_forward_ios, context),
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
            if (title == 'Edit Profile') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfileScreen()),
              );
            } else if (title == 'Change Password') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
              );
            } else if (title == 'Settings') {
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
          // Show success notification before navigating
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

          // Navigate to LoginScreen after a short delay
          Future.delayed(const Duration(milliseconds: 1500), () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
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

// EDIT PROFILE SCREEN - WITH SIMPLE WORKING GENDER DROPDOWN
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  
  // Simple gender dropdown
  String _selectedGender = 'Male';
  final List<String> _genders = ['Male', 'Female'];

  @override
  void initState() {
    super.initState();
    _nameController.text = 'Jake Baraquiel';
    _emailController.text = 'jakepogi@gmail.com';
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
          'Edit Profile',
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
            
            // Edit Name Field
            const Text(
              'Edit Name:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'LondrinaSolid',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black, width: 1),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Email/Username Field
            const Text(
              'Email/Username:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'LondrinaSolid',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black, width: 1),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Gender Field - SIMPLE DROPDOWN
            const Text(
              'Gender:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'LondrinaSolid',
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: DropdownButton<String>(
                value: _selectedGender,
                isExpanded: true,
                underline: const SizedBox(), // Remove default underline
                items: _genders.map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(
                      gender,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'LondrinaSolid',
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue!;
                  });
                },
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Save Button
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
                onPressed: () {
                  _saveProfileChanges();
                },
                child: const Text(
                  'Save',
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

  void _saveProfileChanges() {
    print('Name: ${_nameController.text}');
    print('Email: ${_emailController.text}');
    print('Gender: $_selectedGender');
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    
    Navigator.pop(context);
  }
}

// CHANGE PASSWORD SCREEN - WITH PASSWORD VALIDATION, EYE ICONS, AND SUCCESS NOTIFICATION
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _passwordsMatch = false;
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _showConfirmPasswordValidation = false;
  bool _isLoading = false;

  void _checkPasswordMatch() {
    setState(() {
      _passwordsMatch = _newPasswordController.text == _confirmPasswordController.text;
      _showConfirmPasswordValidation = _confirmPasswordController.text.isNotEmpty;
    });
  }

  void _changePassword() async {
    if (!_passwordsMatch) {
      _showErrorSnackBar('Passwords do not match');
      return;
    }

    if (_currentPasswordController.text.isEmpty) {
      _showErrorSnackBar('Please enter your current password');
      return;
    }

    if (_newPasswordController.text.isEmpty) {
      _showErrorSnackBar('Please enter a new password');
      return;
    }

    // Simulate password change process
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // Show success notification
    _showSuccessSnackBar();

    // Navigate back to profile screen after a short delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.pop(context);
    });
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Change password successfully',
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
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: 'LondrinaSolid',
          ),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
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
          'Change Password',
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              
              // Current Password Field
              _buildPasswordField('Current Password', _currentPasswordController, isCurrentPassword: true),
              const SizedBox(height: 20),
              
              // New Password Field
              _buildPasswordField('New Password', _newPasswordController, isNewPassword: true),
              const SizedBox(height: 20),
              
              // Confirm Password Field
              _buildPasswordField(
                'Confirm Password', 
                _confirmPasswordController, 
                isConfirmPassword: true,
              ),
              
              // Password Match Validation
              if (_showConfirmPasswordValidation && !_passwordsMatch)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 16),
                      const SizedBox(width: 5),
                      Text(
                        'Passwords do not match',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              
              if (_showConfirmPasswordValidation && _passwordsMatch)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 16),
                      const SizedBox(width: 5),
                      Text(
                        'Passwords match',
                        style: TextStyle(color: Colors.green, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              
              const SizedBox(height: 40),
              
              // Change Password Button
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
                onPressed: _isLoading ? null : _changePassword,
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
                        'Change Password',
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
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, {
    bool isCurrentPassword = false,
    bool isNewPassword = false,
    bool isConfirmPassword = false,
  }) {
    bool hasText = controller.text.isNotEmpty;
    
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
        TextField(
          controller: controller,
          obscureText: isCurrentPassword ? !_isCurrentPasswordVisible : 
                      isNewPassword ? !_isNewPasswordVisible : 
                      !_isConfirmPasswordVisible,
          onChanged: (_) {
            if (isNewPassword || isConfirmPassword) {
              _checkPasswordMatch();
            }
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isConfirmPassword && hasText && !_passwordsMatch ? Colors.red : Colors.black,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isConfirmPassword && hasText && !_passwordsMatch ? Colors.red : Colors.black,
                width: 1,
              ),
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Check icon for password match (only for confirm password field)
                  if (isConfirmPassword && hasText)
                    Icon(
                      _passwordsMatch ? Icons.check_circle : Icons.error,
                      color: _passwordsMatch ? Colors.green : Colors.red,
                      size: 20,
                    ),
                  
                  if (isConfirmPassword && hasText) const SizedBox(width: 8),
                  
                  // Eye icon for password visibility
                  IconButton(
                    icon: Icon(
                      isCurrentPassword 
                        ? (_isCurrentPasswordVisible ? Icons.visibility_off : Icons.visibility)
                        : isNewPassword
                          ? (_isNewPasswordVisible ? Icons.visibility_off : Icons.visibility)
                          : (_isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility),
                      color: Colors.black,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isCurrentPassword) {
                          _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                        } else if (isNewPassword) {
                          _isNewPasswordVisible = !_isNewPasswordVisible;
                        } else {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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
            
            // Languages Option
            _buildSettingsItem(
              'Languages',
              Icons.language,
              () {
                // Navigate to Languages Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LanguagesScreen()),
                );
              },
            ),
            const SizedBox(height: 15),
            
            // Privacy Policy Option
            _buildSettingsItem(
              'Privacy Policy',
              Icons.privacy_tip,
              () {
                // Navigate to Privacy Policy Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                );
              },
            ),
            const SizedBox(height: 15),
            
            // Terms of Use Option
            _buildSettingsItem(
              'Terms of use',
              Icons.description,
              () {
                // Navigate to Terms of Use Screen
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

// LANGUAGES SCREEN - UPDATED WITH SAVE FUNCTIONALITY
class LanguagesScreen extends StatefulWidget {
  const LanguagesScreen({super.key});

  @override
  State<LanguagesScreen> createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  String _selectedLanguage = 'English';
  final List<String> _languages = ['English', 'Filipino',];
  bool _isLoading = false;

  void _saveLanguage() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // Show success message
    _showSuccessSnackBar();

    // Navigate back after a short delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.pop(context);
    });
  }

  void _showSuccessSnackBar() {
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
            
            // Instruction Text
            const Text(
              'Select your preferred language:',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'LondrinaSolid',
              ),
            ),
            const SizedBox(height: 30),
            
            // Language Options
            Expanded(
              child: ListView(
                children: _languages.map((language) {
                  return _buildLanguageOption(language, _selectedLanguage == language);
                }).toList(),
              ),
            ),
            
            // Save Changes Button
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
            const SizedBox(height: 20),
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
            
            // App Icon and Title
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
            
            // Frequently Asked Questions
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
              'How do I reset my password?',
              'Go to the Login screen and tap "Forgot Password". Enter your email address and we will send you a password reset link.'
            ),
            
            _buildFAQItem(
              'How can I track my learning progress?',
              'Visit the "Progress" section in your dashboard to see your overall progress, completed lessons, and quiz scores.'
            ),
            
            _buildFAQItem(
              'Can I change the app language?',
              'Yes! Go to Settings > Languages and select your preferred language from the available options.'
            ),
            
            _buildFAQItem(
              'How do I contact support?',
              'You can reach our support team by emailing senyamatikasupport@gmail.com.'
            ),
            
            const SizedBox(height: 30),
            
            // Contact Support Section
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
                  
                  // Contact Methods
                  _buildContactMethod('Email', 'support@senyamatika.com', Icons.email),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // App Version
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
            
            // App Icon and Title
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
            
            // App Description
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
              'SenyaMatika is an innovative educational app designed to make learning mathematics fun and engaging for students of all ages. Our app combines interactive lessons, quizzes, and progress tracking to help you master mathematical concepts.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'LondrinaSolid',
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 25),
            
            // Features Section
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
            _buildFeatureItem('Quiz Assessments', 'Test your knowledge with various quiz formats and difficulty levels'),
            _buildFeatureItem('Sign Language Support', 'Includes sign language dictionary for inclusive learning'),
            
            const SizedBox(height: 25),
            
            // Version Information
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
                  _buildInfoRow('Compatibility', 'iOS 13.0+ & Android 8.0+'),
                ],
              ),
            ),
            
            const SizedBox(height: 25),
        
            // Copyright
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
            
            // Privacy Policy Content
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
              'SenyaMatika is an educational app that may be used by children under 18. We collect only minimal information needed for learning purposes and do not share it with third parties. Parents or guardians can delete their child’s account and all related data anytime by contacting us at senyamatikasupport.com.'
            ),
            
            _buildPolicySection(
              '5. Third-Party Services',
              'This app may use third-party services that collect data to help us understand how users interact with the app. These services follow their own privacy policies.'
            ),
            
            _buildPolicySection(
              '6. Your Rights',
              'You can view, update, or delete your personal information anytime through the app’s settings.'
            ),
            
            _buildPolicySection(
              '9. Contact Us',
              'If you have any questions about this Privacy Policy:\n\n'
              'Email: senyamatikasupport@gmail.com\n'
            ),
            
            const SizedBox(height: 30),
            
            // Acceptance Note
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
            // Add more terms of use content as needed
          ],
        ),
      ),
    );
  }
}

// LANGUAGE SELECTION SCREEN
class LanguageSelectionScreen extends StatelessWidget {
  final String lessonName;
  
  const LanguageSelectionScreen({super.key, required this.lessonName});

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
        title: Text(
          'Choose Sign Language',
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select your preferred sign language:',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'LondrinaSolid',
              ),
            ),
            const SizedBox(height: 40),
            
            // ASL Button
            _buildLanguageButton(
              context,
              'ASL (American Sign Language)',
              const Color(0xFFA8D5E3),
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VideoLessonScreen(
                    lessonName: lessonName,
                    language: 'ASL',
                    subLessonIndex: 0,
                  )),
                );
              },
            ),
            const SizedBox(height: 20),
            
            // FSL Button
            _buildLanguageButton(
              context,
              'FSL (Filipino Sign Language)',
              const Color(0xFFF5C6D6),
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VideoLessonScreen(
                    lessonName: lessonName,
                    language: 'FSL',
                    subLessonIndex: 0,
                  )),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageButton(BuildContext context, String text, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        height: 100,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'LondrinaSolid',
            ),
          ),
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
      'description': 'Learn how to count from 1 to 20 in sign language',
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
      
      // Listen for video completion
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
      print('Error initializing video: $e');
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
            
            // Video Player with Enhanced Controls
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: Column(
                children: [
                  // Video Display
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
                  
                  // Enhanced Video Controls
                  if (_isVideoInitialized)
                    Container(
                      color: Colors.black87,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          // Speed Control Row
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
                          
                          // Main Controls Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Play/Pause Button
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
                              
                              // Rewind 10 seconds
                              IconButton(
                                icon: const Icon(Icons.replay_10, color: Colors.white),
                                onPressed: () {
                                  final newPosition = _videoPlayerController.value.position - 
                                      const Duration(seconds: 10);
                                  _videoPlayerController.seekTo(newPosition);
                                },
                              ),
                              
                              // Current Time
                              Text(
                                _formatDuration(_videoPlayerController.value.position),
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                              
                              // Progress Bar
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
                              
                              // Total Time
                              Text(
                                _formatDuration(_videoPlayerController.value.duration),
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                              
                              // Forward 10 seconds
                              IconButton(
                                icon: const Icon(Icons.forward_10, color: Colors.white),
                                onPressed: () {
                                  final newPosition = _videoPlayerController.value.position + 
                                      const Duration(seconds: 10);
                                  _videoPlayerController.seekTo(newPosition);
                                },
                              ),

                              // Replay Button
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
            
            // Video Completion Status
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
            
            // Sub-lesson Description
            Text(
              currentSubLesson['description']!,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'LondrinaSolid',
              ),
            ),

            const SizedBox(height: 30),
            
            // Take Exercise Button
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

// EXERCISE SCREEN - DRAG AND DROP COUNTING 1 TO 20 WITH FSL
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
  List<DraggableFSLItem> _draggableItems = [];
  List<FSLSlot> _fslSlots = [];
  int _score = 0;
  int _totalQuestions = 0;
  bool _showResult = false;
  bool _isCompleted = false;

  // Map of FSL assets for numbers 1-20
  final Map<int, String> _fslAssets = {
    1: 'assets/images/fsl_1.png',
    2: 'assets/images/fsl_2.png',
    3: 'assets/images/fsl_3.png',
    4: 'assets/images/fsl_4.png',
    5: 'assets/images/fsl_5.png',
    6: 'assets/images/fsl_6.png',
    7: 'assets/images/fsl_7.png',
    8: 'assets/images/fsl_8.png',
    9: 'assets/images/fsl_9.png',
    10: 'assets/videos/fsl_10.mp4',
    11: 'assets/videos/fsl_11.mp4',
    12: 'assets/videos/fsl_12.mp4',
    13: 'assets/videos/fsl_13.mp4',
    14: 'assets/videos/fsl_14.mp4',
    15: 'assets/videos/fsl_15.mp4',
    16: 'assets/videos/fsl_16.mp4',
    17: 'assets/videos/fsl_17.mp4',
    18: 'assets/videos/fsl_18.mp4',
    19: 'assets/videos/fsl_19.mp4',
    20: 'assets/videos/fsl_20.mp4',
  };

  @override
  void initState() {
    super.initState();
    _initializeExercise();
  }

  void _initializeExercise() {
    // Initialize numbers 1-20
    List<int> numbers = List.generate(20, (index) => index + 1);
    numbers.shuffle(); // Shuffle for random order

    // Create draggable FSL items
    _draggableItems = numbers.map((number) {
      return DraggableFSLItem(
        number: number,
        assetPath: _fslAssets[number]!,
        isCorrect: false,
      );
    }).toList();

    // Create FSL slots (empty at first)
    _fslSlots = List.generate(20, (index) {
      return FSLSlot(
        expectedNumber: index + 1,
        currentItem: null,
        isCorrect: false,
      );
    });

    _totalQuestions = 20;
  }

  void _checkAnswer() {
    int correctCount = 0;

    for (var slot in _fslSlots) {
      if (slot.currentItem?.number == slot.expectedNumber) {
        slot.isCorrect = true;
        correctCount++;
      } else {
        slot.isCorrect = false;
      }
    }

    setState(() {
      _score = correctCount;
      _showResult = true;
      _isCompleted = correctCount == _totalQuestions;
    });
  }

  void _resetExercise() {
    setState(() {
      _initializeExercise();
      _score = 0;
      _showResult = false;
      _isCompleted = false;
    });
  }

  void _handleItemDrop(DraggableFSLItem item, int slotIndex) {
    setState(() {
      // Remove the item from draggables
      _draggableItems.removeWhere((draggable) => draggable.number == item.number);
      
      // Place the item in the slot
      _fslSlots[slotIndex].currentItem = item;
    });
  }

  void _removeItemFromSlot(int slotIndex) {
    final item = _fslSlots[slotIndex].currentItem;
    if (item != null) {
      setState(() {
        _fslSlots[slotIndex].currentItem = null;
        _draggableItems.add(DraggableFSLItem(
          number: item.number,
          assetPath: item.assetPath,
          isCorrect: false,
        ));
      });
    }
  }

  bool _isVideoAsset(String assetPath) {
    return assetPath.endsWith('.mp4');
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
          'Exercise - FSL Counting 1 to 20',
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
            // Instructions
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
                  Icon(Icons.touch_app, size: 40, color: Colors.black),
                  SizedBox(height: 10),
                  Text(
                    'Drag and drop the FSL signs to arrange them in order from 1 to 20',
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

            // Progress and Score
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress: $_score/$_totalQuestions',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'LondrinaSolid',
                  ),
                ),
                if (_showResult)
                  Text(
                    'Score: ${(_score / _totalQuestions * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'LondrinaSolid',
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 20),

            // FSL Slots Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.0,
              ),
              itemCount: _fslSlots.length,
              itemBuilder: (context, index) {
                return _buildFSLSlot(_fslSlots[index], index);
              },
            ),

            const SizedBox(height: 30),

            // Draggable FSL Items Area
            Container(
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
                    'Drag these FSL signs:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'LondrinaSolid',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _draggableItems.map((item) {
                      return _buildDraggableFSLItem(item);
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Control Buttons
            Row(
              children: [
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
                    onPressed: _checkAnswer,
                    child: const Text(
                      'Check Answers',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'LondrinaSolid',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
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
                    onPressed: _resetExercise,
                    child: const Text(
                      'Reset',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'LondrinaSolid',
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Result Message
            if (_showResult)
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: _isCompleted ? Colors.green[100] : Colors.orange[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isCompleted ? Colors.green : Colors.orange,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      _isCompleted ? Icons.celebration : Icons.emoji_objects,
                      size: 40,
                      color: _isCompleted ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _isCompleted 
                          ? 'Excellent! You arranged all FSL signs correctly! 🎉'
                          : 'You got $_score out of $_totalQuestions correct. Keep practicing!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'LondrinaSolid',
                      ),
                    ),
                    if (_isCompleted)
                      const SizedBox(height: 10),
                    if (_isCompleted)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFF59D),
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Continue Learning',
                          style: TextStyle(
                            fontFamily: 'LondrinaSolid',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFSLSlot(FSLSlot slot, int slotIndex) {
    return DragTarget<DraggableFSLItem>(
     onAcceptWithDetails: (details) {
  _handleItemDrop(details.data, slotIndex);
},
      builder: (context, candidateData, rejectedData) {
        return Container(
          decoration: BoxDecoration(
            color: _showResult
                ? (slot.isCorrect ? Colors.green[100] : Colors.red[100])
                : Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _showResult
                  ? (slot.isCorrect ? Colors.green : Colors.red)
                  : Colors.black,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 2,
                offset: const Offset(1, 1),
              ),
            ],
          ),
          child: slot.currentItem != null
              ? Stack(
                  children: [
                    Center(
                      child: _buildFSLContent(slot.currentItem!),
                    ),
                    // Remove button
                    Positioned(
                      top: 2,
                      right: 2,
                      child: GestureDetector(
                        onTap: () => _removeItemFromSlot(slotIndex),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Text(
                    '${slotIndex + 1}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontFamily: 'LondrinaSolid',
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildDraggableFSLItem(DraggableFSLItem item) {
    return Draggable<DraggableFSLItem>(
      data: item,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: _buildFSLContent(item),
        ),
      ),
      childWhenDragging: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey, width: 2),
        ),
        child: Opacity(
          opacity: 0.5,
          child: _buildFSLContent(item),
        ),
      ),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: _buildFSLContent(item),
      ),
    );
  }

  Widget _buildFSLContent(DraggableFSLItem item) {
    if (_isVideoAsset(item.assetPath)) {
      // For videos, show a thumbnail with play icon
      return Stack(
        children: [
          Container(
            color: Colors.black12,
            child: const Center(
              child: Icon(Icons.play_circle_fill, color: Colors.black54, size: 24),
            ),
          ),
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${item.number}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'LondrinaSolid',
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      // For images, display the image
      return Stack(
        children: [
          Image.asset(
            item.assetPath,
            width: 50,
            height: 50,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Text(
                  '${item.number}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'LondrinaSolid',
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${item.number}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'LondrinaSolid',
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}

// Data Models for FSL Items
class DraggableFSLItem {
  final int number;
  final String assetPath;
  final bool isCorrect;

  DraggableFSLItem({
    required this.number,
    required this.assetPath,
    required this.isCorrect,
  });
}

class FSLSlot {
  final int expectedNumber;
  DraggableFSLItem? currentItem;
  bool isCorrect;

  FSLSlot({
    required this.expectedNumber,
    required this.currentItem,
    required this.isCorrect,
  });
}

// ==================== SIGN DICTIONARY - COMPLETE WORKING VERSION ====================

// SIGN DICTIONARY MAIN SCREEN - WITHOUT 1000 AND 500
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
            // Title Section
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
            
            // Categories Grid - WITHOUT 1000 AND 500
            Column(
              children: [
                // First Row - Fraction and Length only
                Row(
                  children: [
                    // Fraction
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
                    
                    // Length
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
                
                // Second Row - Sizes and Mass
                Row(
                  children: [
                    // Sizes
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
                    
                    // Mass
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
                
                // Third Row - Height and Big
                Row(
                  children: [
                    // Height
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
                    
                    // Big
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

                // Fourth Row - Long and Heavy
                Row(
                  children: [
                    // Long
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
                    
                    // Heavy
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

                // Fifth Row - Bigger and Longer
                Row(
                  children: [
                    // Bigger
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
                    
                    // Longer
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

// I-DELETE ANG MGA SUMUSUNOD NA CLASSES:

// DELETE THIS CLASS:
/*
class Number1000DictionaryScreen extends StatelessWidget {
  const Number1000DictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      '1000', 
      const Color(0xFFF5C6D6),
    );
  }
}
*/

// DELETE THIS CLASS:
/*
class Number500DictionaryScreen extends StatelessWidget {
  const Number500DictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      '500', 
      const Color(0xFFC4B1E1),
    );
  }
}
*/

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
      print('🔄 Initializing video: ${widget.videoAsset}');
      
      _videoController = VideoPlayerController.asset(widget.videoAsset);
      
      await _videoController.initialize();
      
      setState(() {
        _isVideoInitialized = true;
        _hasError = false;
      });
      
      _videoController.setLooping(true);
      _videoController.play();
      
      print('✅ Video initialized successfully: ${widget.videoAsset}');
      
    } catch (e) {
      print('❌ Error loading video: $e');
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
      color: Colors.black.withOpacity(0.1),
      child: Column(
        children: [
          // Speed Control
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
          
          // Playback Controls
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

// UPDATED DICTIONARY SCREEN BUILDER WITH VIDEO SUPPORT
Widget _buildDictionaryScreen(BuildContext context, String title, Color color, 
    {String? aslVideoAsset, String? fslVideoAsset}) {
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
          // Language Selection Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA8D5E3),
                    foregroundColor: Colors.black,
                    minimumSize: const Size(0, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                  onPressed: aslVideoAsset != null ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DictionaryVideoScreen(
                        title: '$title - ASL',
                        videoAsset: aslVideoAsset,
                        backgroundColor: const Color(0xFFA8D5E3),
                      )),
                    );
                  } : null,
                  child: Text(
                    'ASL ${aslVideoAsset == null ? '(No Video)' : ''}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'LondrinaSolid',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF5C6D6),
                    foregroundColor: Colors.black,
                    minimumSize: const Size(0, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                  onPressed: fslVideoAsset != null ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DictionaryVideoScreen(
                        title: '$title - FSL',
                        videoAsset: fslVideoAsset,
                        backgroundColor: const Color(0xFFF5C6D6),
                      )),
                    );
                  } : null,
                  child: Text(
                    'FSL ${fslVideoAsset == null ? '(No Video)' : ''}',
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
          const SizedBox(height: 30),
          
          // Content Area
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
                    'Select ASL or FSL to view\nthe sign language video for "$title"',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'LondrinaSolid',
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (aslVideoAsset == null && fslVideoAsset == null)
                    const Text(
                      '(Videos coming soon)',
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

// INDIVIDUAL DICTIONARY SCREENS WITH ACTUAL VIDEOS
class FractionDictionaryScreen extends StatelessWidget {
  const FractionDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDictionaryScreen(
      context, 
      'Fraction', 
      const Color(0xFFA8D5E3),
      aslVideoAsset: 'assets/videos/fraction_asl.mp4',
      fslVideoAsset: 'assets/videos/fraction_fsl.mp4',
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
      aslVideoAsset: 'assets/videos/heavy_asl.mp4',
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
      aslVideoAsset: 'assets/videos/height_asl.mp4',
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
      aslVideoAsset: 'assets/videos/length_asl.mp4',
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
      aslVideoAsset: 'assets/videos/sizes_asl.mp4',
    );
  }
}

// PLACEHOLDER SCREENS FOR CATEGORIES WITHOUT VIDEOS
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
    // COUNTING QUESTIONS (1-5)
    QuizQuestion(
      question: "What number comes AFTER 7?",
      options: ["6", "7", "8", "9"],
      correctAnswer: 2,
      imageAsset: "assets/images/number_7.png",
    ),
    QuizQuestion(
      question: "How many fingers are showing in this FSL sign?",
      options: ["3", "4", "5", "6"],
      correctAnswer: 2,
      imageAsset: "assets/images/fsl_5.png",
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

    // NUMBER RECOGNITION (6-10)
    QuizQuestion(
      question: "What number is this FSL sign?",
      options: ["10", "12", "15", "20"],
      correctAnswer: 0,
      imageAsset: "assets/images/fsl_10.png",
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

    // NUMBER OPERATIONS (11-15)
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

    // ADVANCED CONCEPTS (16-20)
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
            // Progress and Score
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
            
            // Simple Progress Dots
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

            // MAIN QUESTION AREA - VISUAL FOCUSED
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(3, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Question Text (Minimal)
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

                  // MAIN VISUAL - LARGE AND CENTERED
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

                  // OPTIONS - VISUAL IF POSSIBLE
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

            // SIMPLE NAVIGATION
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
                      color: Colors.black.withOpacity(0.2),
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


// QUIZ LANGUAGE SELECTION SCREEN
class QuizLanguageSelectionScreen extends StatelessWidget {
  final String quizName;
  
  const QuizLanguageSelectionScreen({super.key, required this.quizName});

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
        title: Text(
          'Choose Sign Language',
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select your preferred sign language\nfor the quiz instructions:',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'LondrinaSolid',
              ),
            ),
            const SizedBox(height: 40),
            
            // ASL Button
            _buildLanguageButton(
              context,
              'ASL (American Sign Language)',
              const Color(0xFFA8D5E3),
              () {
                _showInstructionVideo(context, quizName, 'ASL');
              },
            ),
            const SizedBox(height: 20),
            
            // FSL Button
            _buildLanguageButton(
              context,
              'FSL (Filipino Sign Language)',
              const Color(0xFFF5C6D6),
              () {
                _showInstructionVideo(context, quizName, 'FSL');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageButton(BuildContext context, String text, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        height: 100,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'LondrinaSolid',
            ),
          ),
        ),
      ),
    );
  }

  void _showInstructionVideo(BuildContext context, String quizName, String language) {
    // Map of instruction videos for each quiz
    final instructionVideos = {
      'Number Values': {
        'ASL': 'assets/videos/quiz_instructions_number_values_asl.mp4',
        'FSL': 'assets/videos/quiz_instructions_number_values_fsl.mp4',
      },
      // Add other quizzes here when available
    };

    String videoAsset = instructionVideos[quizName]?[language] ?? 
        'assets/videos/default_quiz_instructions.mp4';

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QuizInstructionScreen(
        quizName: quizName,
        language: language,
        instructionVideo: videoAsset,
      )),
    );
  }
}

// QUIZ INSTRUCTION SCREEN - WITH VIDEO PLAYER
class QuizInstructionScreen extends StatefulWidget {
  final String quizName;
  final String language;
  final String instructionVideo;

  const QuizInstructionScreen({
    super.key,
    required this.quizName,
    required this.language,
    required this.instructionVideo,
  });

  @override
  State<QuizInstructionScreen> createState() => _QuizInstructionScreenState();
}

class _QuizInstructionScreenState extends State<QuizInstructionScreen> {
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;
  bool _hasError = false;
  bool _videoCompleted = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() async {
    try {
      print('🔄 Initializing video: ${widget.instructionVideo}');
      
      _videoController = VideoPlayerController.asset(widget.instructionVideo);
      
      await _videoController.initialize();
      
      setState(() {
        _isVideoInitialized = true;
        _hasError = false;
      });
      
      // Listen for video completion
      _videoController.addListener(() {
        if (_videoController.value.position >= _videoController.value.duration && 
            _videoController.value.duration > Duration.zero) {
          setState(() {
            _videoCompleted = true;
          });
        }
      });

      _videoController.play();
      
      print('✅ Video initialized successfully: ${widget.instructionVideo}');
      
    } catch (e) {
      print('❌ Error loading video: $e');
      setState(() {
        _hasError = true;
      });
    }
  }

  void _startQuiz() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const NumberValuesQuizScreen()),
    );
  }

  @override
  void dispose() {
    _videoController.dispose();
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
        title: Text(
          '${widget.quizName} - ${widget.language}',
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
          children: [
            // Title
            Text(
              'Quiz Instructions',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'LondrinaSolid',
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Watch the instructions in ${widget.language}',
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'LondrinaSolid',
              ),
            ),
            const SizedBox(height: 30),

            // Video Player
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 16/9,
                    child: _hasError
                        ? _buildErrorWidget()
                        : _isVideoInitialized
                            ? VideoPlayer(_videoController)
                            : _buildLoadingWidget(),
                  ),
                  
                  // Video Controls
                  if (_isVideoInitialized && !_hasError)
                    Container(
                      color: Colors.black87,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              _videoController.value.isPlaying 
                                  ? Icons.pause 
                                  : Icons.play_arrow,
                              color: Colors.white,
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
                          IconButton(
                            icon: const Icon(Icons.replay, color: Colors.white),
                            onPressed: () {
                              _videoController.seekTo(Duration.zero);
                              _videoController.play();
                              setState(() {
                                _videoCompleted = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Completion Status
            if (_videoCompleted)
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Instructions completed! You can now start the quiz.',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'LondrinaSolid',
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else if (!_hasError)
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange, width: 2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info, color: Colors.orange),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Please watch the complete instructions before starting the quiz.',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'LondrinaSolid',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 30),

            // Start Quiz Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _videoCompleted ? const Color(0xFFFFF59D) : Colors.grey,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                    side: const BorderSide(color: Colors.black, width: 1),
                  ),
                ),
                onPressed: _videoCompleted ? _startQuiz : null,
                child: Text(
                  _videoCompleted ? 'Start Quiz' : 'Complete Instructions First',
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

  Widget _buildLoadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.yellow),
          SizedBox(height: 10),
          Text(
            'Loading instructions...',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'LondrinaSolid',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 50, color: Colors.red),
          const SizedBox(height: 10),
          const Text(
            'Instruction video not available',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'LondrinaSolid',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFF59D),
              foregroundColor: Colors.black,
            ),
            onPressed: _startQuiz, // Allow starting quiz even without video
            child: const Text(
              'Start Quiz Anyway',
              style: TextStyle(
                fontFamily: 'LondrinaSolid',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}