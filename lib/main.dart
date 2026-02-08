import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:async';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';

// ============ ENHANCED USER DATA MANAGEMENT ============
class UserData {
  String name;
  String email;
  String? school;
  String? section;
  
  UserData({
    required this.name,
    required this.email,
    this.school,
    this.section,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'school': school,
      'section': section,
    };
  }
  
  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      school: map['school'],
      section: map['section'],
    );
  }
}

class UserProvider {
  static UserData? _currentUser;
  static Map<String, Map<String, dynamic>> _userCredentials = {};
  
  static void setUser(UserData user) {
    _currentUser = user;
  }
  
  static void saveCredentials(String email, Map<String, dynamic> credentials) {
    _userCredentials[email] = credentials;
  }
  
  static Map<String, dynamic>? getCredentials(String email) {
    return _userCredentials[email];
  }
  
  static bool validateLogin(String email, String password) {
    final credentials = _userCredentials[email];
    // For demo purposes, accept any login if no credentials stored
    if (_userCredentials.isEmpty) return true;
    return credentials != null && credentials['password'] == password;
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
  
  static String? getUserSchool() {
    return _currentUser?.school;
  }
  
  static String? getUserSection() {
    return _currentUser?.section;
  }
  
  // Update user information
  static void updateUserInfo({
    String? name,
    String? email,
    String? school,
    String? section,
  }) {
    if (_currentUser != null) {
      _currentUser = UserData(
        name: name ?? _currentUser!.name,
        email: email ?? _currentUser!.email,
        school: school ?? _currentUser!.school,
        section: section ?? _currentUser!.section,
      );
      
      // Also update in credentials if email changed
      if (email != null && email != _currentUser!.email) {
        final oldCredentials = _userCredentials[_currentUser!.email];
        if (oldCredentials != null) {
          _userCredentials[email] = oldCredentials;
          _userCredentials.remove(_currentUser!.email);
        }
      }
    }
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
        primaryColor: Colors.yellow[600],
        scaffoldBackgroundColor: Colors.white,
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
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: const AssetImage('assets/images/applogo.png'),
              height: 300,
            ),
            const SizedBox(height: 20),
            const Text(
              'SenyaMatika',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lora-Regular',
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// Responsive Helper Class
class ResponsiveHelper {
  static double getResponsiveValue(
    BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < 600) {
      return mobile;
    } else if (width < 1200) {
      return tablet;
    } else {
      return desktop;
    }
  }

  static bool isMobile(BuildContext context) => 
      MediaQuery.of(context).size.width < 600;
  
  static bool isTablet(BuildContext context) => 
      MediaQuery.of(context).size.width >= 600 && 
      MediaQuery.of(context).size.width < 1200;
  
  static bool isDesktop(BuildContext context) => 
      MediaQuery.of(context).size.width >= 1200;
  
  static double screenWidth(BuildContext context) => 
      MediaQuery.of(context).size.width;
  
  static double screenHeight(BuildContext context) => 
      MediaQuery.of(context).size.height;
}

// ============ DASHBOARD SCREEN ============
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> 
    with TickerProviderStateMixin {
  late AnimationController _featureAnimationController;
  late PageController _storyPageController;
  int _currentStoryIndex = 0;
  bool _isProfileDrawerOpen = false;

  List<Map<String, dynamic>> _getStories(BuildContext context) {
    return [
      {
        'title': 'Welcome to SenyaMatika!',
        'subtitle': 'Interactive Math Learning',
        'color': const Color(0xFFFEDA5F),
        'icon': Icons.school,
        'description': 'Discover a new way to learn mathematics',
        'image': 'assets/images/myimage.png',
        'onTap': () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Welcome to SenyaMatika!'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        'type': 'app_intro'
      },
      {
        'title': 'Meet Our Avatar',
        'subtitle': 'Sign Language Instructor',
        'color': const Color(0xFFA7D5E4),
        'icon': Icons.face,
        'description': 'Learn mathematics through sign language',
        'image': 'assets/videos/Avatar.mp4',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SignLanguageAvatarScreen()),
          );
        },
        'type': 'avatar'
      },
      {
        'title': 'Explore Our Topics',
        'subtitle': 'Learn Different Math Concepts',
        'color': const Color(0xFFA8D4B9),
        'icon': Icons.menu_book,
        'description': 'Click to explore all math topics',
        'image': 'assets/images/topics.png',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TopicsScreen()),
          );
        },
        'type': 'topics'
      },
    ];
  }

  @override
  void initState() {
    super.initState();
    _featureAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    
    _storyPageController = PageController(viewportFraction: 0.88);
    _startAutoRotation();
  }
  
  void _startAutoRotation() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        if (_currentStoryIndex < _getStories(context).length - 1) {
          _storyPageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          _storyPageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
        _startAutoRotation();
      }
    });
  }

  @override
  void dispose() {
    _featureAnimationController.dispose();
    _storyPageController.dispose();
    super.dispose();
  }

  void _toggleProfileDrawer() {
    setState(() {
      _isProfileDrawerOpen = !_isProfileDrawerOpen;
    });
  }

  Widget _buildAnimatedFeatureIcon({
    required String assetPath,
    required Color fallbackColor,
    required IconData fallbackIcon,
    required BuildContext context,
  }) {
    final size = ResponsiveHelper.screenWidth(context) < 600 ? 60.0 : 70.0;
    
    return AnimatedBuilder(
      animation: _featureAnimationController,
      builder: (context, child) {
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  spreadRadius: 1,
                  offset: const Offset(0, 3),
                ),
              ],
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
  
  Widget _buildStoryCard(Map<String, dynamic> story, int index, BuildContext context) {
    return GestureDetector(
      onTap: () {
        story['onTap']();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: story['color'],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: story['image'] != null
                        ? ClipOval(
                            child: Image.asset(
                              story['image'],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  story['icon'],
                                  color: Colors.black,
                                  size: 30,
                                );
                              },
                            ),
                          )
                        : Icon(
                            story['icon'],
                            color: Colors.black,
                            size: 30,
                          ),
                  ),
                  
                  if (index == 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      child: const Text(
                        'NEW',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.white,
                              blurRadius: 2,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              
              const Spacer(),
              
              Text(
                story['title'],
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 6),
              
              Text(
                story['subtitle'],
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 8),
              
              Text(
                story['description'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withOpacity(0.6),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stories = _getStories(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Text(
                                'Senyamatika',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            
                            GestureDetector(
                              onTap: _toggleProfileDrawer,
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/menu.png',
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.menu,
                                        color: Colors.black,
                                        size: 30,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 28),
                        
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: const Text(
                                    'Discover',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: Color.fromARGB(255, 221, 223, 83), width: 2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    '${_currentStoryIndex + 1}/${stories.length}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 221, 223, 83),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            
                            SizedBox(
                              height: isSmallScreen ? 200 : 220,
                              child: PageView.builder(
                                controller: _storyPageController,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentStoryIndex = index;
                                  });
                                },
                                itemCount: stories.length,
                                itemBuilder: (context, index) {
                                  return _buildStoryCard(stories[index], index, context);
                                },
                              ),
                            ),
                            
                            const SizedBox(height: 12),
                            
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(stories.length, (index) {
                                  return Container(
                                    width: 8,
                                    height: 8,
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _currentStoryIndex == index 
                                          ? Colors.black 
                                          : Colors.grey[300],
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 2,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 32),
                        
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Text(
                            'Features',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),

                  // APAT NA FEATURES BOXES LANG
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 20 : screenWidth * 0.05,
                    ),
                    child: Column(
                      children: [
                        // First Row - 2 boxes (Topics & Progress)
                        Row(
                          children: [
                            // Topics Box
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const TopicsScreen()),
                                  );
                                },
                                child: Container(
                                  height: isSmallScreen ? 160 : 180,
                                  margin: const EdgeInsets.only(right: 12),
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF8E97FD),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.black, width: 2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.25),
                                        blurRadius: 15,
                                        spreadRadius: 1,
                                        offset: const Offset(0, 8),
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
                                        context: context,
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        'Topics',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          shadows: [
                                            Shadow(
                                              color: Colors.white,
                                              blurRadius: 3,
                                              offset: Offset(1, 1),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Progress Box
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const StudentProgressScreen()),
                                  );
                                },
                                child: Container(
                                  height: isSmallScreen ? 160 : 180,
                                  margin: const EdgeInsets.only(left: 12),
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF4B342),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.black, width: 2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.25),
                                        blurRadius: 15,
                                        spreadRadius: 1,
                                        offset: const Offset(0, 8),
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
                                        context: context,
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        'Progress',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          shadows: [
                                            Shadow(
                                              color: Colors.white,
                                              blurRadius: 3,
                                              offset: Offset(1, 1),
                                            ),
                                          ],
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

                        // Second Row - 2 boxes (Sign Dictionary & Sign Language Avatar)
                        Row(
                          children: [
                            // Sign Dictionary Box
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SignDictionaryScreen()),
                                  );
                                },
                                child: Container(
                                  height: isSmallScreen ? 160 : 180,
                                  margin: const EdgeInsets.only(right: 12),
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFA8E3B5),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.black, width: 2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.25),
                                        blurRadius: 15,
                                        spreadRadius: 1,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _buildAnimatedFeatureIcon(
                                        assetPath: 'assets/images/dictionary.png',
                                        fallbackColor: const Color(0xFF4CAF50),
                                        fallbackIcon: Icons.library_books,
                                        context: context,
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        'Sign Dictionary',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          shadows: [
                                            Shadow(
                                              color: Colors.white,
                                              blurRadius: 3,
                                              offset: Offset(1, 1),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Sign Language Avatar Box
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SignLanguageAvatarScreen()),
                                  );
                                },
                                child: Container(
                                  height: isSmallScreen ? 160 : 180,
                                  margin: const EdgeInsets.only(left: 12),
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF8498C8),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.black, width: 2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.25),
                                        blurRadius: 15,
                                        spreadRadius: 1,
                                        offset: const Offset(0, 8),
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
                                        context: context,
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        'Sign Avatar',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          shadows: [
                                            Shadow(
                                              color: Colors.white,
                                              blurRadius: 3,
                                              offset: Offset(1, 1),
                                            ),
                                          ],
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

                  // REDUCED SPACER
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          if (_isProfileDrawerOpen)
            GestureDetector(
              onTap: _toggleProfileDrawer,
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            right: _isProfileDrawerOpen ? 0 : -MediaQuery.of(context).size.width,
            top: 0,
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.75,
              constraints: const BoxConstraints(maxWidth: 300),
              color: Colors.white,
              child: _buildProfileDrawerContent(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDrawerContent(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 120,
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Text(
                  'User Name',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'user@email.com',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Profile Option
              _buildDrawerMenuItem(
                title: 'Profile',
                icon: Icons.person,
                onTap: () {
                  _toggleProfileDrawer();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
                context: context,
              ),
              const SizedBox(height: 12),
              
              _buildDrawerMenuItem(
                title: 'Settings',
                icon: Icons.settings,
                onTap: () {
                  _toggleProfileDrawer();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsScreen()),
                  );
                },
                context: context,
              ),
              const SizedBox(height: 12),
              _buildDrawerMenuItem(
                title: 'Help',
                icon: Icons.help_outline,
                onTap: () {
                  _toggleProfileDrawer();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HelpScreen()),
                  );
                },
                context: context,
              ),
              const SizedBox(height: 12),
              _buildDrawerMenuItem(
                title: 'About',
                icon: Icons.info_outline,
                onTap: () {
                  _toggleProfileDrawer();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutScreen()),
                  );
                },
                context: context,
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Divider(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              
              _buildLogOutButton(context),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(
                Icons.close, 
                size: 30, 
                color: Colors.black,
              ),
              onPressed: _toggleProfileDrawer,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDrawerMenuItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                spreadRadius: 0.5,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: Colors.black,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogOutButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _toggleProfileDrawer();
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sign out successfully'),
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
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.25),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.logout,
                  color: Colors.red.shade700,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




// ============ TOPICS SCREEN ============
class TopicsScreen extends StatefulWidget {
  const TopicsScreen({super.key});

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> 
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  
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
      duration: const Duration(seconds: 3),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Topics',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
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
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
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
    // Navigate to respective lesson screens
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

// ============ NUMBER VALUES LESSONS SCREEN ============
class NumberValuesLessonsScreen extends StatelessWidget {
  const NumberValuesLessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Number Values Lessons',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
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
                progressManager.markVideoCompleted('Whole Numbers', 'English', 0, 'Introduction');
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
            
            _buildClickableLessonItem(
              'Comparison', 
              const Color(0xFFF5C6D6),
              onTap: () {
                progressManager.markVideoCompleted('Comparison', 'English', 0, 'Introduction');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VideoLessonScreen(
                    lessonName: 'Comparison',
                    language: 'English',
                    subLessonIndex: 0,
                  )),
                );
              },
            ),
            const SizedBox(height: 15),
            
            _buildClickableLessonItem(
              'Ordinal Numbers', 
              const Color(0xFFC4B1E1),
              onTap: () {
                progressManager.markVideoCompleted('Ordinal Numbers', 'English', 0, 'Introduction');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VideoLessonScreen(
                    lessonName: 'Ordinal Numbers',
                    language: 'English',
                    subLessonIndex: 0,
                  )),
                );
              },
            ),
            const SizedBox(height: 15),
            
            _buildClickableLessonItem(
              'Money Value', 
              const Color(0xFFA8D5BA),
              onTap: () {
                progressManager.markVideoCompleted('Money Value', 'English', 0, 'Introduction');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VideoLessonScreen(
                    lessonName: 'Money Value',
                    language: 'English',
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
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.black),
          ],
        ),
      ),
    );
  }
}

// ============ FUNDAMENTAL OPERATIONS LESSONS SCREEN ============
class FundamentalOperationsLessonsScreen extends StatelessWidget {
  const FundamentalOperationsLessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Fundamental Operations Lessons',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
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
              'Addition',
              const Color(0xFFA8D5E3),
              onTap: () {
                progressManager.markVideoCompleted('Addition', 'English', 0, 'Introduction');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VideoLessonScreen(
                    lessonName: 'Addition',
                    language: 'English',
                    subLessonIndex: 0,
                  )),
                );
              },
            ),
            const SizedBox(height: 15),
            
            _buildClickableLessonItem(
              'Subtraction',
              const Color(0xFFF5C6D6),
              onTap: () {
                progressManager.markVideoCompleted('Subtraction', 'English', 0, 'Introduction');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VideoLessonScreen(
                    lessonName: 'Subtraction',
                    language: 'English',
                    subLessonIndex: 0,
                  )),
                );
              },
            ),
            const SizedBox(height: 15),
            
            _buildClickableLessonItem(
              'Multiplication',
              const Color(0xFFC4B1E1),
              onTap: () {
                progressManager.markVideoCompleted('Multiplication', 'English', 0, 'Introduction');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VideoLessonScreen(
                    lessonName: 'Multiplication',
                    language: 'English',
                    subLessonIndex: 0,
                  )),
                );
              },
            ),
            const SizedBox(height: 15),
            
            _buildClickableLessonItem(
              'Division',
              const Color(0xFFA8D5BA),
              onTap: () {
                progressManager.markVideoCompleted('Division', 'English', 0, 'Introduction');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VideoLessonScreen(
                    lessonName: 'Division',
                    language: 'English',
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
            Text(
              lessonName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.black),
          ],
        ),
      ),
    );
  }
}

// ============ FRACTION LESSONS SCREEN ============
class FractionLessonsScreen extends StatelessWidget {
  const FractionLessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Fraction Lessons',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
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
              'Concepts of Fractions',
              const Color(0xFFA8D5E3),
              onTap: () {
                progressManager.markVideoCompleted('Fraction', 'English', 0, 'Introduction');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VideoLessonScreen(
                    lessonName: 'Fraction',
                    language: 'English',
                    subLessonIndex: 0,
                  )),
                );
              },
            ),
            const SizedBox(height: 15),
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
            Text(
              lessonName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.black),
          ],
        ),
      ),
    );
  }
}

// ============ DECIMAL NUMBERS LESSONS SCREEN ============
class DecimalNumbersLessonsScreen extends StatelessWidget {
  const DecimalNumbersLessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Decimal Numbers Lessons',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
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
              'Basic Concepts of Decimal Numbers',
              const Color(0xFFA8D5E3),
              onTap: () {
                progressManager.markVideoCompleted('Decimal Numbers', 'English', 0, 'Introduction');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VideoLessonScreen(
                    lessonName: 'Decimal Numbers',
                    language: 'English',
                    subLessonIndex: 0,
                  )),
                );
              },
            ),
            const SizedBox(height: 15),
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
            Text(
              lessonName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.black),
          ],
        ),
      ),
    );
  }
}

// ============ PERCENTAGE LESSONS SCREEN ============
class PercentageLessonsScreen extends StatelessWidget {
  const PercentageLessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Percentage Lessons',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
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
              'Concepts of Percentage',
              const Color(0xFFA8D5E3),
              onTap: () {
                progressManager.markVideoCompleted('Percentage', 'English', 0, 'Introduction');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VideoLessonScreen(
                    lessonName: 'Percentage',
                    language: 'English',
                    subLessonIndex: 0,
                  )),
                );
              },
            ),
            const SizedBox(height: 15),
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
            Text(
              lessonName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.black),
          ],
        ),
      ),
    );
  }
}

// ============ MENSURATION LESSONS SCREEN ============
class MensurationLessonsScreen extends StatelessWidget {
  const MensurationLessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Mensuration Lessons',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
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
              'Time',
              const Color(0xFFA8D5E3),
              onTap: () {
                progressManager.markVideoCompleted('Time', 'English', 0, 'Introduction');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VideoLessonScreen(
                    lessonName: 'Time',
                    language: 'English',
                    subLessonIndex: 0,
                  )),
                );
              },
            ),
            const SizedBox(height: 15),
            
            _buildLockedLessonItem(
              'Days, Weeks, and Months',
              const Color(0xFFF5C6D6)
            ),
            const SizedBox(height: 15),
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
            Text(
              lessonName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
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
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
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

// ============ VIDEO LESSON SCREEN ============
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

  final Map<String, List<Map<String, dynamic>>> _lessonVideos = {
    'Whole Numbers': [
      {
        'title': 'Count Up To 20',
        'videoUrl': 'assets/videos/Counting.mp4',
        'description': 'Learn how to count from 1 to 20',
      },
    ],
    'Comparison': [
      {
        'title': 'Basic Comparison',
        'videoUrl': 'assets/videos/Compariso.mp4',
        'description': 'Learn how to compare numbers and quantities',
      },
    ],
  };

  List<Map<String, dynamic>> get _subLessons {
    return _lessonVideos[widget.lessonName] ?? [
      {
        'title': 'Introduction',
        'videoUrl': 'assets/videos/default_lesson.mp4',
        'description': 'Learn about ${widget.lessonName}',
      },
    ];
  }

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    
    // Mark video as watched when screen loads
    final currentSubLesson = _subLessons[widget.subLessonIndex];
    progressManager.markVideoCompleted(
      widget.lessonName,
      widget.language,
      widget.subLessonIndex,
      currentSubLesson['title'],
    );
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
      _initializeFallbackVideo();
    }
  }

  void _initializeFallbackVideo() async {
    try {
      _videoPlayerController = VideoPlayerController.asset('assets/videos/default_lesson.mp4');
      await _videoPlayerController.initialize();
      setState(() {
        _isVideoInitialized = true;
      });
    } catch (e) {}
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${widget.lessonName} - ${widget.language}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
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
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
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
                                    style: TextStyle(color: Colors.white),
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
                              const Text('Playback Speed:', style: TextStyle(color: Colors.white, fontSize: 12)),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${_playbackSpeed}x',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 8),
                              PopupMenuButton<double>(
                                icon: const Icon(Icons.speed, size: 16, color: Colors.white),
                                onSelected: _changePlaybackSpeed,
                                itemBuilder: (context) => _speedOptions.map((speed) {
                                  return PopupMenuItem<double>(
                                    value: speed,
                                    child: Text('${speed}x Speed', style: const TextStyle(fontSize: 12)),
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
                      style: const TextStyle(fontSize: 14),
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
                      child: const Text(
                        'Mark Complete',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            
            Text(
              currentSubLesson['description']!,
              style: const TextStyle(fontSize: 16),
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
                  if (widget.lessonName == 'Whole Numbers') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CountingExerciseScreen(
                        lessonName: widget.lessonName,
                        language: widget.language,
                        subLessonIndex: widget.subLessonIndex,
                      )),
                    );
                  } else if (widget.lessonName == 'Comparison') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ComparisonExerciseScreen(
                        lessonName: widget.lessonName,
                        language: widget.language,
                        subLessonIndex: widget.subLessonIndex,
                      )),
                    );
                  } 
                  else if (widget.lessonName == 'Ordinal Numbers') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OrdinalExerciseScreen(
                        lessonName: widget.lessonName,
                        language: widget.language,
                        subLessonIndex: widget.subLessonIndex,
                      )),
                    );
                  }
                  else if (widget.lessonName == 'Money Value') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MoneyValueExerciseScreen(
                        lessonName: widget.lessonName,
                        language: widget.language,
                        subLessonIndex: widget.subLessonIndex,
                      )),
                    );
                  }

                  else if (widget.lessonName == 'Addition') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdditionExerciseScreen(
                        lessonName: widget.lessonName,
                        language: widget.language,
                        subLessonIndex: widget.subLessonIndex,
                      )),
                    );
                  }
                  else if (widget.lessonName == 'Subtraction') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SubtractionExerciseScreen(
                        lessonName: widget.lessonName,
                        language: widget.language,
                        subLessonIndex: widget.subLessonIndex,
                      )),
                    );
                  }
                  else if (widget.lessonName == 'Multiplication') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MultiplicationExerciseScreen(
                        lessonName: widget.lessonName,
                        language: widget.language,
                        subLessonIndex: widget.subLessonIndex,
                      )),
                    );
                  }
                  else if (widget.lessonName == 'Division') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DivisionExerciseScreen(
                        lessonName: widget.lessonName,
                        language: widget.language,
                        subLessonIndex: widget.subLessonIndex,
                      )),
                    );
                  }
                  else if (widget.lessonName == 'Fraction') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FractionExerciseScreen(
                        lessonName: widget.lessonName,
                        language: widget.language,
                        subLessonIndex: widget.subLessonIndex,
                      )),
                    );
                  }
      
                  else if (widget.lessonName == 'Decimal') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DecimalExerciseScreen(
                        lessonName: widget.lessonName,
                        language: widget.language,
                        subLessonIndex: widget.subLessonIndex,
                      )),
                    );
                  }
                 else if (widget.lessonName == 'Percentage') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PercentageExerciseScreen(
                        lessonName: widget.lessonName,
                        language: widget.language,
                        subLessonIndex: widget.subLessonIndex,
                      )),
                    );
                  }
                 else if (widget.lessonName == 'Time') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TimeExerciseScreen(
                        lessonName: widget.lessonName,
                        language: widget.language,
                        subLessonIndex: widget.subLessonIndex,
                      )),
                    );
                  }
                  else if (widget.lessonName == 'Days, Weeks, and Months') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DaysWeeksMonthsExerciseScreen(
                        lessonName: widget.lessonName,
                        language: widget.language,
                        subLessonIndex: widget.subLessonIndex,
                      )),
                    );
                  }
                   else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ExerciseScreen(
                        lessonName: widget.lessonName,
                        language: widget.language,
                        subLessonIndex: widget.subLessonIndex,
                      )),
                    );
                  }
                } : null,
                child: Text(
                  _isVideoCompleted ? 'Take Exercise' : 'Complete Video First',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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





// ============ PROGRESS MANAGER ============
class ProgressManager {
  static final ProgressManager _instance = ProgressManager._internal();
  factory ProgressManager() => _instance;
  ProgressManager._internal();

  Map<String, Map<String, dynamic>> _progressData = {};

  void initialize() {
    if (_progressData.isEmpty) {
      _progressData = {
        'video_lessons': {},
        'exercises': {},
        'overall_stats': {
          'total_videos_watched': 0,
          'total_exercises_completed': 0,
          'total_score': 0,
          'average_score': 0.0,
          'total_questions_answered': 0,
          'correct_answers': 0,
          'progress_percentage': 0,
        }
      };
    }
  }

  void markVideoCompleted(String lessonName, String language, int subLessonIndex, String videoTitle) {
    initialize();
    
    final key = '$lessonName|$language|$subLessonIndex|$videoTitle';
    final now = DateTime.now();
    
    _progressData['video_lessons']![key] = {
      'lesson_name': lessonName,
      'language': language,
      'sub_lesson_index': subLessonIndex,
      'video_title': videoTitle,
      'completed_at': now.toIso8601String(),
      'watched_duration': '100%',
      'status': 'completed',
    };
    
    _progressData['overall_stats']!['total_videos_watched'] = 
        (_progressData['overall_stats']!['total_videos_watched'] as int) + 1;
    
    _updateProgressPercentage();
  }

  void recordExerciseScore(String lessonName, String language, int subLessonIndex, 
                          String exerciseType, int score, int totalQuestions, 
                          int correctAnswers, double percentage) {
    initialize();
    
    final key = '$lessonName|$language|$subLessonIndex|$exerciseType|${DateTime.now().millisecondsSinceEpoch}';
    final now = DateTime.now();
    
    _progressData['exercises']![key] = {
      'lesson_name': lessonName,
      'language': language,
      'sub_lesson_index': subLessonIndex,
      'exercise_type': exerciseType,
      'score': score,
      'total_questions': totalQuestions,
      'correct_answers': correctAnswers,
      'percentage': percentage,
      'completed_at': now.toIso8601String(),
      'passed': percentage >= 70,
    };
    
    _progressData['overall_stats']!['total_exercises_completed'] = 
        (_progressData['overall_stats']!['total_exercises_completed'] as int) + 1;
    _progressData['overall_stats']!['total_score'] = 
        (_progressData['overall_stats']!['total_score'] as int) + score;
    _progressData['overall_stats']!['total_questions_answered'] = 
        (_progressData['overall_stats']!['total_questions_answered'] as int) + totalQuestions;
    _progressData['overall_stats']!['correct_answers'] = 
        (_progressData['overall_stats']!['correct_answers'] as int) + correctAnswers;
    
    final totalExercises = _progressData['overall_stats']!['total_exercises_completed'] as int;
    final totalScore = _progressData['overall_stats']!['total_score'] as int;
    _progressData['overall_stats']!['average_score'] = 
        totalExercises > 0 ? (totalScore / totalExercises).toDouble() : 0.0;
    
    _updateProgressPercentage();
  }

  List<Map<String, dynamic>> getExerciseScoresByLesson(String lessonName) {
    initialize();
    
    final exercises = _progressData['exercises']!.values.where((exercise) {
      return exercise['lesson_name'] == lessonName;
    }).toList();
    
    exercises.sort((a, b) => b['completed_at'].compareTo(a['completed_at']));
    
    return exercises.cast<Map<String, dynamic>>();
  }

  double getAverageScoreForLesson(String lessonName) {
    final exercises = getExerciseScoresByLesson(lessonName);
    if (exercises.isEmpty) return 0.0;
    
    final totalScore = exercises.fold(0.0, (sum, exercise) => sum + (exercise['percentage'] as double));
    return totalScore / exercises.length;
  }

  int getCompletedVideosCount() {
    initialize();
    return _progressData['overall_stats']!['total_videos_watched'] as int;
  }

  int getCompletedExercisesCount() {
    initialize();
    return _progressData['overall_stats']!['total_exercises_completed'] as int;
  }

  double getOverallProgressPercentage() {
    initialize();
    return (_progressData['overall_stats']!['progress_percentage'] as int).toDouble();
  }

  Map<String, dynamic> getOverallStats() {
    initialize();
    return Map<String, dynamic>.from(_progressData['overall_stats']!);
  }

  Map<String, dynamic> getProgressSummary() {
    initialize();
    
    final totalVideoKeys = 30;
    final totalExerciseKeys = 50;
    
    final videoCompletionRate = totalVideoKeys > 0 
        ? (getCompletedVideosCount() / totalVideoKeys * 100).toInt() 
        : 0;
    
    final exerciseCompletionRate = totalExerciseKeys > 0 
        ? (getCompletedExercisesCount() / totalExerciseKeys * 100).toInt() 
        : 0;
    
    return {
      'videos_watched': getCompletedVideosCount(),
      'videos_total': totalVideoKeys,
      'video_completion_rate': videoCompletionRate,
      'exercises_completed': getCompletedExercisesCount(),
      'exercises_total': totalExerciseKeys,
      'exercise_completion_rate': exerciseCompletionRate,
      'overall_progress': getOverallProgressPercentage(),
      'average_score': _progressData['overall_stats']!['average_score'],
      'accuracy_rate': _progressData['overall_stats']!['total_questions_answered'] > 0
          ? ((_progressData['overall_stats']!['correct_answers'] as int) / 
             (_progressData['overall_stats']!['total_questions_answered'] as int) * 100).toInt()
          : 0,
    };
  }

  Map<String, dynamic> getLessonProgress(String lessonName) {
    final videoKeys = _progressData['video_lessons']!.keys.where((key) {
      return key.startsWith('$lessonName|');
    }).toList();
    
    final exerciseKeys = _progressData['exercises']!.keys.where((key) {
      return key.startsWith('$lessonName|');
    }).toList();
    
    final videosCompleted = videoKeys.length;
    final exercisesCompleted = exerciseKeys.length;
    
    final lessonExercises = getExerciseScoresByLesson(lessonName);
    final averageScore = lessonExercises.isNotEmpty
        ? lessonExercises.fold(0.0, (sum, ex) => sum + (ex['percentage'] as double)) / lessonExercises.length
        : 0.0;
    
    return {
      'lesson_name': lessonName,
      'videos_completed': videosCompleted,
      'exercises_completed': exercisesCompleted,
      'average_score': averageScore,
      'total_attempts': lessonExercises.length,
      'best_score': lessonExercises.isNotEmpty
          ? lessonExercises.map((e) => e['percentage'] as double).reduce((a, b) => a > b ? a : b)
          : 0.0,
    };
  }

  void clearAllProgress() {
    _progressData = {
      'video_lessons': {},
      'exercises': {},
      'overall_stats': {
        'total_videos_watched': 0,
        'total_exercises_completed': 0,
        'total_score': 0,
        'average_score': 0.0,
        'total_questions_answered': 0,
        'correct_answers': 0,
        'progress_percentage': 0,
      }
    };
  }

  void _updateProgressPercentage() {
    final videosWatched = getCompletedVideosCount();
    final exercisesCompleted = getCompletedExercisesCount();
    
    final videoWeight = 0.4;
    final exerciseWeight = 0.6;
    
    const totalVideos = 30;
    const totalExercises = 50;
    
    final videoProgress = totalVideos > 0 ? (videosWatched / totalVideos) : 0;
    final exerciseProgress = totalExercises > 0 ? (exercisesCompleted / totalExercises) : 0;
    
    final overallProgress = (videoProgress * videoWeight + exerciseProgress * exerciseWeight) * 100;
    
    _progressData['overall_stats']!['progress_percentage'] = overallProgress.toInt();
  }
}

final progressManager = ProgressManager();

// ============ TOPICS AND LESSONS DATA ============
class Topic {
  final String id;
  final String title;
  final List<Lesson> lessons;
  bool isExpanded;

  Topic({
    required this.id,
    required this.title,
    required this.lessons,
    this.isExpanded = false,
  });
}

class Lesson {
  final String id;
  final String title;
  final String topicId;
  final List<String> subtopics;
  final int videoCount;
  final int exerciseCount;

  Lesson({
    required this.id,
    required this.title,
    required this.topicId,
    required this.subtopics,
    this.videoCount = 2,
    this.exerciseCount = 3,
  });
}

// ============ STUDENT PROGRESS SCREEN (FULLY INTEGRATED WITH DROPDOWN) ============
class StudentProgressScreen extends StatefulWidget {
  const StudentProgressScreen({Key? key}) : super(key: key);

  @override
  State<StudentProgressScreen> createState() => _StudentProgressScreenState();
}

class _StudentProgressScreenState extends State<StudentProgressScreen> {
  List<String> expandedLessons = [];
  String searchTerm = '';
  String filterType = 'all';
  
  // Define topics and lessons based on your format
  final List<Topic> _topics = [
    Topic(
      id: 'topic1',
      title: '1. Number Values',
      lessons: [
        Lesson(
          id: 'lesson1_1',
          title: 'Whole Numbers',
          topicId: 'topic1',
          subtopics: ['Counting', 'Place Value', 'Number Patterns'],
        ),
        Lesson(
          id: 'lesson1_2',
          title: 'Comparison',
          topicId: 'topic1',
          subtopics: ['Greater Than', 'Less Than', 'Equal To'],
        ),
        Lesson(
          id: 'lesson1_3',
          title: 'Ordinal Numbers',
          topicId: 'topic1',
          subtopics: ['First to Tenth', 'Position and Order'],
        ),
        Lesson(
          id: 'lesson1_4',
          title: 'Money Value',
          topicId: 'topic1',
          subtopics: ['Coins and Bills', 'Counting Money', 'Making Change'],
        ),
      ],
    ),
    Topic(
      id: 'topic2',
      title: '2. Fundamental Operations',
      lessons: [
        Lesson(
          id: 'lesson2_1',
          title: 'Addition',
          topicId: 'topic2',
          subtopics: ['Basic Addition', 'Carrying Over', 'Word Problems'],
        ),
        Lesson(
          id: 'lesson2_2',
          title: 'Subtraction',
          topicId: 'topic2',
          subtopics: ['Basic Subtraction', 'Borrowing', 'Word Problems'],
        ),
        Lesson(
          id: 'lesson2_3',
          title: 'Multiplication',
          topicId: 'topic2',
          subtopics: ['Times Tables', 'Multiplying Larger Numbers'],
        ),
        Lesson(
          id: 'lesson2_4',
          title: 'Division',
          topicId: 'topic2',
          subtopics: ['Dividing Numbers', 'Remainders', 'Word Problems'],
        ),
      ],
    ),
    Topic(
      id: 'topic3',
      title: '3. Fraction',
      lessons: [
        Lesson(
          id: 'lesson3_1',
          title: 'Understanding Fractions',
          topicId: 'topic3',
          subtopics: ['Parts of a Whole', 'Numerator and Denominator', 'Types of Fractions'],
        ),
      ],
    ),
    Topic(
      id: 'topic4',
      title: '4. Decimal Numbers',
      lessons: [
        Lesson(
          id: 'lesson4_1',
          title: 'Decimal Basics',
          topicId: 'topic4',
          subtopics: ['Place Value', 'Comparing Decimals', 'Decimal Operations'],
        ),
      ],
    ),
    Topic(
      id: 'topic5',
      title: '5. Percentage',
      lessons: [
        Lesson(
          id: 'lesson5_1',
          title: 'Percentage Concepts',
          topicId: 'topic5',
          subtopics: ['What is Percentage?', 'Converting to Fractions', 'Percentage Problems'],
        ),
      ],
    ),
    Topic(
      id: 'topic6',
      title: '6. Mensuration',
      lessons: [
        Lesson(
          id: 'lesson6_1',
          title: 'Time',
          topicId: 'topic6',
          subtopics: ['Reading Clocks', 'AM and PM', 'Time Calculations'],
        ),
        Lesson(
          id: 'lesson6_2',
          title: 'Days, Weeks and Months',
          topicId: 'topic6',
          subtopics: ['Calendar Reading', 'Converting Units', 'Date Calculations'],
        ),
      ],
    ),
  ];

  // Get all lessons from all topics
  List<Lesson> get allLessons {
    return _topics.expand((topic) => topic.lessons).toList();
  }

  // Get progress data for a lesson
  Map<String, dynamic> getLessonProgressData(String lessonId) {
    final lesson = allLessons.firstWhere((l) => l.id == lessonId);
    final progressData = progressManager.getLessonProgress(lesson.title);
    final progress = progressData['average_score'] as double;
    final completed = progress >= 90;

    return {
      'id': lesson.id,
      'title': lesson.title,
      'topicId': lesson.topicId,
      'subtopics': lesson.subtopics,
      'hasAssessment': progressData['exercises_completed'] > 0,
      'progress': progress,
      'completed': completed,
      'videos_completed': progressData['videos_completed'],
      'exercises_completed': progressData['exercises_completed'],
      'average_score': progressData['average_score'],
      'videoCount': lesson.videoCount,
      'exerciseCount': lesson.exerciseCount,
    };
  }

  // Get progress for a topic
  Map<String, dynamic> getTopicProgressData(String topicId) {
    final topicLessons = _topics.firstWhere((t) => t.id == topicId).lessons;
    double totalProgress = 0;
    int completedLessons = 0;
    
    for (var lesson in topicLessons) {
      final progressData = getLessonProgressData(lesson.id);
      final progress = progressData['progress'] as double;
      totalProgress += progress;
      if (progress >= 90) completedLessons++;
    }
    
    final avgProgress = topicLessons.isNotEmpty ? totalProgress / topicLessons.length : 0;
    
    return {
      'topicId': topicId,
      'totalLessons': topicLessons.length,
      'completedLessons': completedLessons,
      'averageProgress': avgProgress,
      'inProgress': topicLessons.length - completedLessons,
    };
  }

  Map<String, dynamic> get summaryStats {
    final progressSummary = progressManager.getProgressSummary();
    int completedLessons = 0;
    int totalProgress = 0;
    
    for (var lesson in allLessons) {
      final progressData = getLessonProgressData(lesson.id);
      final progress = progressData['progress'] as double;
      totalProgress += progress.toInt();
      if (progress >= 90) completedLessons++;
    }
    
    final inProgressLessons = allLessons.where((lesson) {
      final progressData = getLessonProgressData(lesson.id);
      final progress = progressData['progress'] as double;
      return progress > 0 && progress < 90;
    }).length;
    
    return {
      'totalLessons': allLessons.length,
      'completedLessons': completedLessons,
      'avgProgress': allLessons.isNotEmpty ? (totalProgress / allLessons.length).toInt() : 0,
      'inProgress': inProgressLessons,
      'completionRate': allLessons.isNotEmpty ? (completedLessons / allLessons.length * 100).toInt() : 0,
      'videosWatched': progressSummary['videos_watched'],
      'exercisesCompleted': progressSummary['exercises_completed'],
      'accuracyRate': progressSummary['accuracy_rate'],
    };
  }

  void toggleLesson(String lessonId) {
    setState(() {
      if (expandedLessons.contains(lessonId)) {
        expandedLessons.remove(lessonId);
      } else {
        expandedLessons.add(lessonId);
      }
    });
  }

  void toggleTopic(String topicId) {
    setState(() {
      final topicIndex = _topics.indexWhere((t) => t.id == topicId);
      if (topicIndex != -1) {
        _topics[topicIndex].isExpanded = !_topics[topicIndex].isExpanded;
      }
    });
  }

  Color getProgressColor(double progress) {
    if (progress >= 90) return const Color(0xFF4CAF50); // Green
    if (progress >= 75) return const Color(0xFFFF9800); // Orange
    if (progress >= 50) return const Color(0xFFFFC107); // Amber/Yellow
    return const Color(0xFFF44336); // Red
  }

  Map<String, dynamic> getProgressBadge(double progress) {
    if (progress >= 90) return {'text': 'Excellent', 'color': const Color(0xFF4CAF50)};
    if (progress >= 75) return {'text': 'Good', 'color': const Color(0xFFFF9800)};
    if (progress >= 50) return {'text': 'Fair', 'color': const Color(0xFFFFC107)};
    return {'text': 'Needs Help', 'color': const Color(0xFFF44336)};
  }

  List<Topic> get filteredTopics {
    return _topics.map((topic) {
      final filteredLessons = topic.lessons.where((lesson) {
        final matchesSearch = lesson.title
            .toLowerCase()
            .contains(searchTerm.toLowerCase());
        final progressData = getLessonProgressData(lesson.id);
        final progress = progressData['progress'] as double;

        if (filterType == 'completed') {
          return matchesSearch && progress >= 90;
        } else if (filterType == 'in-progress') {
          return matchesSearch && progress > 0 && progress < 90;
        } else if (filterType == 'not-started') {
          return matchesSearch && progress == 0;
        }
        return matchesSearch;
      }).toList();

      return Topic(
        id: topic.id,
        title: topic.title,
        lessons: filteredLessons,
        isExpanded: topic.isExpanded,
      );
    }).where((topic) => topic.lessons.isNotEmpty).toList();
  }

  @override
  Widget build(BuildContext context) {
    // SenyaMatika Color Scheme based on Splash Screen
    final primaryColor = const Color(0xFFFFD700); // Gold/Yellow from SenyaMatika
    final accentColor = const Color(0xFF4CAF50); // Green for accents
    final backgroundColor = Colors.white;
    final textColor = Colors.black;
    final mutedTextColor = Colors.black.withOpacity(0.6);
    final borderColor = Colors.black.withOpacity(0.2);
    final cardColor = const Color(0xFFF8F8F8);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Enhanced Page Header with Back Button
                Row(
                  children: [
                    // Back Button
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: primaryColor, width: 1),
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: textColor,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    
                    // Page Title
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Progress',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              fontFamily: 'Lora-Regular',
                            ),
                          ),
                          Text(
                            'Track your learning journey and completion',
                            style: TextStyle(
                              fontSize: 14,
                              color: mutedTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Progress Icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.track_changes,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Summary Stats Cards
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildStatCard(
                        icon: Icons.menu_book,
                        title: 'Total Lessons',
                        value: '${summaryStats['totalLessons']}',
                        iconBgColor: const Color(0xFFFFF8E1),
                        iconColor: primaryColor,
                        borderColor: borderColor,
                        textColor: textColor,
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        icon: Icons.check_circle,
                        title: 'Lessons Completed',
                        value: '${summaryStats['completedLessons']}',
                        iconBgColor: const Color(0xFFE8F5E9),
                        iconColor: accentColor,
                        borderColor: borderColor,
                        textColor: textColor,
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        icon: Icons.timeline,
                        title: 'Avg Progress',
                        value: '${summaryStats['avgProgress']}%',
                        iconBgColor: const Color(0xFFE3F2FD),
                        iconColor: const Color(0xFF2196F3),
                        borderColor: borderColor,
                        textColor: textColor,
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        icon: Icons.auto_graph,
                        title: 'In Progress',
                        value: '${summaryStats['inProgress']}',
                        iconBgColor: const Color(0xFFFFF3E0),
                        iconColor: const Color(0xFFFF9800),
                        borderColor: borderColor,
                        textColor: textColor,
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        icon: Icons.play_circle,
                        title: 'Videos Watched',
                        value: '${summaryStats['videosWatched']}',
                        iconBgColor: const Color(0xFFF3E5F5),
                        iconColor: const Color(0xFF9C27B0),
                        borderColor: borderColor,
                        textColor: textColor,
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        icon: Icons.assignment,
                        title: 'Exercises Done',
                        value: '${summaryStats['exercisesCompleted']}',
                        iconBgColor: const Color(0xFFE0F7FA),
                        iconColor: const Color(0xFF00BCD4),
                        borderColor: borderColor,
                        textColor: textColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Search and Filter Bar
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Search Input
                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor, width: 1),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 12),
                            Icon(
                              Icons.search,
                              color: mutedTextColor,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search lessons...',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(color: mutedTextColor),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    searchTerm = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Filter Buttons
                      Row(
                        children: [
                          Expanded(
                            child: _buildFilterButton(
                              label: 'All',
                              isActive: filterType == 'all',
                              onTap: () {
                                setState(() {
                                  filterType = 'all';
                                });
                              },
                              primaryColor: primaryColor,
                              textColor: textColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildFilterButton(
                              label: 'Completed',
                              isActive: filterType == 'completed',
                              onTap: () {
                                setState(() {
                                  filterType = 'completed';
                                });
                              },
                              primaryColor: primaryColor,
                              textColor: textColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildFilterButton(
                              label: 'In Progress',
                              isActive: filterType == 'in-progress',
                              onTap: () {
                                setState(() {
                                  filterType = 'in-progress';
                                });
                              },
                              primaryColor: primaryColor,
                              textColor: textColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildFilterButton(
                              label: 'Not Started',
                              isActive: filterType == 'not-started',
                              onTap: () {
                                setState(() {
                                  filterType = 'not-started';
                                });
                              },
                              primaryColor: primaryColor,
                              textColor: textColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Topics & Lessons Section with Dropdown
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Header
                      Row(
                        children: [
                          Icon(
                            Icons.list,
                            color: primaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Topics & Lessons',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Click on topics to expand/collapse lessons',
                        style: TextStyle(
                          fontSize: 12,
                          color: mutedTextColor,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Topics List
                      if (filteredTopics.isEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 48),
                          child: Column(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: mutedTextColor,
                                size: 48,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No lessons match your search',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: mutedTextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Try adjusting your filters or search term',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: mutedTextColor,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Column(
                          children: filteredTopics.map((topic) {
                            final topicProgress = getTopicProgressData(topic.id);
                            final topicAvgProgress = topicProgress['averageProgress'] as double;
                            final topicProgressColor = getProgressColor(topicAvgProgress);
                            
                            return Column(
                              children: [
                                // Topic Header
                                GestureDetector(
                                  onTap: () => toggleTopic(topic.id),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: primaryColor.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: primaryColor.withOpacity(0.3)),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          topic.isExpanded 
                                              ? Icons.expand_more 
                                              : Icons.chevron_right,
                                          color: primaryColor,
                                          size: 24,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                topic.title,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: textColor,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${topic.lessons.length} lessons • ${topicProgress['completedLessons']} completed',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: mutedTextColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Topic Progress
                                        Container(
                                          width: 100,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: topicProgressColor.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(4),
                                                  border: Border.all(
                                                    color: topicProgressColor.withOpacity(0.3),
                                                  ),
                                                ),
                                                child: Text(
                                                  '${topicAvgProgress.toInt()}%',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: topicProgressColor,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Container(
                                                height: 6,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius: BorderRadius.circular(3),
                                                ),
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[200],
                                                        borderRadius: BorderRadius.circular(3),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 100 * (topicAvgProgress / 100),
                                                      decoration: BoxDecoration(
                                                        color: topicProgressColor,
                                                        borderRadius: BorderRadius.circular(3),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Lessons under this topic
                                if (topic.isExpanded)
                                  Column(
                                    children: topic.lessons.map((lesson) {
                                      final progressData = getLessonProgressData(lesson.id);
                                      final progress = progressData['progress'] as double;
                                      final isExpanded = expandedLessons.contains(lesson.id);
                                      final progressColor = getProgressColor(progress);
                                      final badge = getProgressBadge(progress);

                                      return Container(
                                        margin: const EdgeInsets.only(bottom: 8, left: 16),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: borderColor, width: 1),
                                          borderRadius: BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.03),
                                              blurRadius: 2,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            // Lesson Row
                                            Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: () => toggleLesson(lesson.id),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(12),
                                                  child: Row(
                                                    children: [
                                                      // Left Section
                                                      Expanded(
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              padding: const EdgeInsets.all(4),
                                                              decoration: BoxDecoration(
                                                                color: primaryColor.withOpacity(0.1),
                                                                borderRadius: BorderRadius.circular(6),
                                                              ),
                                                              child: Icon(
                                                                Icons.play_lesson,
                                                                color: primaryColor,
                                                                size: 16,
                                                              ),
                                                            ),
                                                            const SizedBox(width: 12),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    lesson.title,
                                                                    style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w600,
                                                                      color: textColor,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height: 4),
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        padding: const EdgeInsets.symmetric(
                                                                          horizontal: 6,
                                                                          vertical: 2,
                                                                        ),
                                                                        decoration: BoxDecoration(
                                                                          color: Colors.grey[100],
                                                                          borderRadius: BorderRadius.circular(4),
                                                                          border: Border.all(color: borderColor),
                                                                        ),
                                                                        child: Row(
                                                                          children: [
                                                                            Icon(
                                                                              Icons.play_circle,
                                                                              size: 12,
                                                                              color: mutedTextColor,
                                                                            ),
                                                                            const SizedBox(width: 2),
                                                                            Text(
                                                                              '${progressData['videoCount']} videos',
                                                                              style: TextStyle(
                                                                                fontSize: 10,
                                                                                color: mutedTextColor,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      const SizedBox(width: 4),
                                                                      Container(
                                                                        padding: const EdgeInsets.symmetric(
                                                                          horizontal: 6,
                                                                          vertical: 2,
                                                                        ),
                                                                        decoration: BoxDecoration(
                                                                          color: Colors.grey[100],
                                                                          borderRadius: BorderRadius.circular(4),
                                                                          border: Border.all(color: borderColor),
                                                                        ),
                                                                        child: Row(
                                                                          children: [
                                                                            Icon(
                                                                              Icons.assignment,
                                                                              size: 12,
                                                                              color: mutedTextColor,
                                                                            ),
                                                                            const SizedBox(width: 2),
                                                                            Text(
                                                                              '${progressData['exerciseCount']} exercises',
                                                                              style: TextStyle(
                                                                                fontSize: 10,
                                                                                color: mutedTextColor,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      // Right Section - Progress
                                                      const SizedBox(width: 12),
                                                      Container(
                                                        width: 100,
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(
                                                                  'Progress',
                                                                  style: TextStyle(
                                                                    fontSize: 11,
                                                                    color: mutedTextColor,
                                                                    fontWeight: FontWeight.w500,
                                                                  ),
                                                                ),
                                                                Container(
                                                                  padding: const EdgeInsets.symmetric(
                                                                    horizontal: 8,
                                                                    vertical: 2,
                                                                  ),
                                                                  decoration: BoxDecoration(
                                                                    color: progressColor.withOpacity(0.1),
                                                                    borderRadius: BorderRadius.circular(4),
                                                                    border: Border.all(
                                                                      color: progressColor.withOpacity(0.3),
                                                                    ),
                                                                  ),
                                                                  child: Text(
                                                                    '${progress.toInt()}%',
                                                                    style: TextStyle(
                                                                      fontSize: 12,
                                                                      fontWeight: FontWeight.bold,
                                                                      color: progressColor,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(height: 4),
                                                            // Custom Progress Bar
                                                            Container(
                                                              height: 6,
                                                              width: 100,
                                                              decoration: BoxDecoration(
                                                                color: Colors.grey[200],
                                                                borderRadius: BorderRadius.circular(3),
                                                              ),
                                                              child: Stack(
                                                                children: [
                                                                  Container(
                                                                    width: double.infinity,
                                                                    decoration: BoxDecoration(
                                                                      color: Colors.grey[200],
                                                                      borderRadius: BorderRadius.circular(3),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    width: 100 * (progress / 100),
                                                                    decoration: BoxDecoration(
                                                                      color: progressColor,
                                                                      borderRadius: BorderRadius.circular(3),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: progressColor.withOpacity(0.3),
                                                                          blurRadius: 2,
                                                                          offset: const Offset(0, 1),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // Subtopic List (Expanded View)
                                            if (isExpanded)
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(48, 0, 12, 12),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      'Subtopics:',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold,
                                                        color: textColor,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Wrap(
                                                      spacing: 4,
                                                      runSpacing: 4,
                                                      children: lesson.subtopics.map((subtopic) {
                                                        return Container(
                                                          padding: const EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 4,
                                                          ),
                                                          decoration: BoxDecoration(
                                                            color: Colors.grey[50],
                                                            borderRadius: BorderRadius.circular(4),
                                                            border: Border.all(color: borderColor),
                                                          ),
                                                          child: Text(
                                                            subtopic,
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              color: mutedTextColor,
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Row(
                                                      children: [
                                                        _buildProgressDetailItem(
                                                          icon: Icons.play_circle,
                                                          value: '${progressData['videos_completed']}/${progressData['videoCount']}',
                                                          label: 'Videos',
                                                          color: const Color(0xFF2196F3),
                                                        ),
                                                        const SizedBox(width: 12),
                                                        _buildProgressDetailItem(
                                                          icon: Icons.assignment,
                                                          value: '${progressData['exercises_completed']}/${progressData['exerciseCount']}',
                                                          label: 'Exercises',
                                                          color: accentColor,
                                                        ),
                                                        const SizedBox(width: 12),
                                                        _buildProgressDetailItem(
                                                          icon: Icons.score,
                                                          value: '${progressData['average_score'].toStringAsFixed(1)}%',
                                                          label: 'Avg Score',
                                                          color: const Color(0xFFFF9800),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                const SizedBox(height: 12),
                              ],
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                
                // Back to Dashboard Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: textColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: primaryColor.withOpacity(0.5), width: 1),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back, size: 20, color: textColor),
                        const SizedBox(width: 8),
                        Text(
                          'Back to Dashboard',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color iconBgColor,
    required Color iconColor,
    required Color borderColor,
    required Color textColor,
  }) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    required Color primaryColor,
    required Color textColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive ? primaryColor : Colors.black.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isActive ? Colors.white : textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressDetailItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  color: color.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============ COUNTING EXERCISE SCREEN ============
class CountingExerciseScreen extends StatefulWidget {
  final String lessonName;
  final String language;
  final int subLessonIndex;

  const CountingExerciseScreen({
    super.key,
    required this.lessonName,
    required this.language,
    required this.subLessonIndex,
  });

  @override
  State<CountingExerciseScreen> createState() => _CountingExerciseScreenState();
}

class _CountingExerciseScreenState extends State<CountingExerciseScreen> {
  int _currentQuestion = 0;
  int _score = 0;
  bool _exerciseCompleted = false;
  List<int?> _userAnswers = List.filled(10, null);
  List<bool> _answeredQuestions = List.filled(10, false);

  final List<Map<String, dynamic>> _questions = [
    {
      'type': 'counting',
      'question': 'Count the objects below:',
      'objectCount': 7,
      'object': '🍎',
      'correctAnswer': 7,
      'options': [6, 7, 8, 9],
      'explanation': 'There are 7 apples in the picture.',
    },
    {
      'type': 'counting',
      'question': 'How many stars do you see?',
      'objectCount': 12,
      'object': '⭐',
      'correctAnswer': 12,
      'options': [11, 12, 13, 14],
      'explanation': 'There are 12 stars in the picture.',
    },
    {
      'type': 'number_sequence',
      'question': 'What number comes after 15?',
      'correctAnswer': 16,
      'options': [14, 15, 16, 17],
      'explanation': 'After 15 comes 16.',
    },
    {
      'type': 'number_sequence',
      'question': 'What number comes before 9?',
      'correctAnswer': 8,
      'options': [7, 8, 9, 10],
      'explanation': 'Before 9 comes 8.',
    },
    {
      'type': 'counting',
      'question': 'Count the hearts below:',
      'objectCount': 5,
      'object': '❤️',
      'correctAnswer': 5,
      'options': [4, 5, 6, 7],
      'explanation': 'There are 5 hearts in the picture.',
    },
    {
      'type': 'number_reading',
      'question': 'What is this number?',
      'number': 23,
      'correctAnswer': 0,
      'options': [23, 32, 13, 21],
      'explanation': 'The number is twenty-three (23).',
    },
    {
      'type': 'counting',
      'question': 'How many circles are there?',
      'objectCount': 9,
      'object': '🔵',
      'correctAnswer': 9,
      'options': [8, 9, 10, 11],
      'explanation': 'There are 9 circles in the picture.',
    },
    {
      'type': 'number_sequence',
      'question': 'What number is missing: 10, 11, __, 13?',
      'correctAnswer': 12,
      'options': [11, 12, 13, 14],
      'explanation': 'The missing number is 12.',
    },
    {
      'type': 'place_value',
      'question': 'How many tens are in the number 34?',
      'correctAnswer': 3,
      'options': [3, 4, 30, 34],
      'explanation': 'In 34, there are 3 tens and 4 ones.',
    },
    {
      'type': 'counting',
      'question': 'Count the triangles:',
      'objectCount': 6,
      'object': '🔺',
      'correctAnswer': 6,
      'options': [5, 6, 7, 8],
      'explanation': 'There are 6 triangles in the picture.',
    },
  ];

  void _answerQuestion(int answerIndex) {
    if (!_answeredQuestions[_currentQuestion]) {
      setState(() {
        _answeredQuestions[_currentQuestion] = true;
        _userAnswers[_currentQuestion] = answerIndex;

        final question = _questions[_currentQuestion];
        bool isCorrect = false;

        if (question['type'] == 'number_reading' || question['type'] == 'place_value') {
          isCorrect = answerIndex == question['correctAnswer'];
        } else {
          isCorrect = answerIndex == question['options'].indexOf(question['correctAnswer']);
        }

        if (isCorrect) {
          _score++;
        }
        
        if (_currentQuestion == _questions.length - 1) {
          _exerciseCompleted = true;
          _recordExerciseResults();
        }
      });
    }
  }

  void _recordExerciseResults() {
    final percentage = (_score / _questions.length * 100).toInt();
    
    progressManager.recordExerciseScore(
      widget.lessonName,
      widget.language,
      widget.subLessonIndex,
      'Counting Exercise',
      _score,
      _questions.length,
      _score,
      percentage.toDouble(),
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 Exercise completed! Score: $percentage%'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _nextQuestion() {
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
      });
    } else {
      _recordExerciseResults();
      setState(() {
        _exerciseCompleted = true;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestion > 0) {
      setState(() {
        _currentQuestion--;
      });
    }
  }

  void _restartExercise() {
    setState(() {
      _currentQuestion = 0;
      _score = 0;
      _exerciseCompleted = false;
      _userAnswers = List.filled(_questions.length, null);
      _answeredQuestions = List.filled(_questions.length, false);
    });
  }

  // Helper methods for responsive design
  double _getQuestionFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.042;
    if (screenWidth > 600) return screenWidth * 0.038;
    return screenWidth * 0.045;
  }

  double _getOptionFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.055;
    if (screenWidth > 600) return screenWidth * 0.045;
    return screenWidth * 0.065;
  }

  double _getOptionButtonSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.16;
    if (screenWidth > 600) return screenWidth * 0.14;
    return screenWidth * 0.18;
  }

  double _getExplanationFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.032;
    if (screenWidth > 600) return screenWidth * 0.028;
    return screenWidth * 0.035;
  }

  @override
  Widget build(BuildContext context) {
    if (_exerciseCompleted) {
      return _buildResultsScreen();
    }

    final currentQuestion = _questions[_currentQuestion];
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Whole Numbers Exercise',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            children: [
              // Header with progress
              Container(
                padding: EdgeInsets.all(screenWidth * 0.03),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question ${_currentQuestion + 1}/${_questions.length}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[900],
                          ),
                        ),
                        Text(
                          'Counting & Number Skills',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Colors.orange[700],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: screenWidth * 0.06),
                        SizedBox(width: screenWidth * 0.01),
                        Text(
                          '$_score',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[800],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              // Main question container
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(0, 0, 0, 0.15),
                      blurRadius: 8,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Question text - RESPONSIVE
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      child: Text(
                        currentQuestion['question'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: _getQuestionFontSize(screenWidth),
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Question content based on type
                    if (currentQuestion['type'] == 'counting')
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F8F8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.orange, width: 2),
                        ),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 15,
                          runSpacing: 10,
                          children: List.generate(currentQuestion['objectCount'], (index) {
                            return Text(
                              currentQuestion['object'],
                              style: TextStyle(fontSize: screenWidth * 0.08),
                            );
                          }),
                        ),
                      )
                    else if (currentQuestion['type'] == 'number_sequence' || 
                             currentQuestion['type'] == 'number_reading')
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F8F8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.blue, width: 2),
                        ),
                        child: Column(
                          children: [
                            if (currentQuestion['type'] == 'number_reading')
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '${currentQuestion['number']}',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[800],
                                  ),
                                ),
                              )
                            else if (currentQuestion['question'].contains('missing'))
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '10, 11, __, 13',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.1,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[800],
                                  ),
                                ),
                              )
                            else
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '${currentQuestion['question'].split(' ').last}',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.1,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[800],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      )
                    else if (currentQuestion['type'] == 'place_value')
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F8F8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.green, width: 2),
                        ),
                        child: Column(
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '${currentQuestion['question'].split(' ').last}',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[800],
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              'Tens and Ones',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: screenHeight * 0.03),

                    // Options - RESPONSIVE
                    Wrap(
                      alignment: WrapAlignment.center,
                      runSpacing: screenWidth * 0.03,
                      spacing: screenWidth * 0.03,
                      children: List.generate(
                        (currentQuestion['options'] as List).length,
                        (index) => _buildOptionButton(index, currentQuestion['options']),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Explanation - RESPONSIVE
                    if (_answeredQuestions[_currentQuestion])
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        decoration: BoxDecoration(
                          color: ((currentQuestion['options'] as List)[_userAnswers[_currentQuestion]!] == currentQuestion['correctAnswer'])
                              ? Colors.green[50]
                              : Colors.red[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: ((currentQuestion['options'] as List)[_userAnswers[_currentQuestion]!] == currentQuestion['correctAnswer'])
                                ? Colors.green
                                : Colors.red,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _getCorrectAnswerText(currentQuestion),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: _getExplanationFontSize(screenWidth),
                            fontWeight: FontWeight.bold,
                            color: ((currentQuestion['options'] as List)[_userAnswers[_currentQuestion]!] == currentQuestion['correctAnswer'])
                                ? Colors.green[900]
                                : Colors.red[900],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // Navigation buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: Size(0, screenHeight * 0.065),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.06),
                          side: const BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      onPressed: _currentQuestion > 0 ? _previousQuestion : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_back, size: screenWidth * 0.05),
                          SizedBox(width: screenWidth * 0.02),
                          Text(
                            'Previous',
                            style: TextStyle(fontSize: screenWidth * 0.04),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF59D),
                        foregroundColor: Colors.black,
                        minimumSize: Size(0, screenHeight * 0.065),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.06),
                          side: const BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      onPressed: _answeredQuestions[_currentQuestion]
                          ? () {
                              if (_currentQuestion < _questions.length - 1) {
                                _nextQuestion();
                              } else {
                                _recordExerciseResults();
                                setState(() {
                                  _exerciseCompleted = true;
                                });
                              }
                            }
                          : null,
                      child: Text(
                        _currentQuestion == _questions.length - 1
                            ? 'Finish Exercise'
                            : 'Next Question',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
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

  Widget _buildOptionButton(int index, List<dynamic> options) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isAnswered = _answeredQuestions[_currentQuestion];
    final isSelected = _userAnswers[_currentQuestion] == index;
    final question = _questions[_currentQuestion];
    final isCorrect = question['type'] == 'number_reading' || question['type'] == 'place_value'
        ? index == question['correctAnswer']
        : options[index] == question['correctAnswer'];

    Color buttonColor = Colors.white;
    Color borderColor = Colors.black;
    Color textColor = Colors.black;

    if (isAnswered) {
      if (isSelected && isCorrect) {
        buttonColor = Colors.green[100]!;
        borderColor = Colors.green;
        textColor = Colors.green[900]!;
      } else if (isSelected && !isCorrect) {
        buttonColor = Colors.red[100]!;
        borderColor = Colors.red;
        textColor = Colors.red[900]!;
      } else if (isCorrect) {
        buttonColor = Colors.green[100]!;
        borderColor = Colors.green;
        textColor = Colors.green[900]!;
      }
    }

    final optionNumber = options[index];
    final buttonSize = _getOptionButtonSize(screenWidth);
    
    return GestureDetector(
      onTap: () => _answerQuestion(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: buttonSize,
        height: buttonSize,
        margin: EdgeInsets.all(screenWidth * 0.015),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              optionNumber.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: _getOptionFontSize(screenWidth),
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getCorrectAnswerText(Map<String, dynamic> question) {
    final userAnswer = _userAnswers[_currentQuestion];
    
    if (userAnswer == null) return '';
    
    final correctAnswer = question['correctAnswer'];
    final options = question['options'] as List<int>;
    final selectedAnswer = question['type'] == 'number_reading' || question['type'] == 'place_value'
        ? options[userAnswer]
        : options[userAnswer];
    
    final isCorrect = question['type'] == 'number_reading' || question['type'] == 'place_value'
        ? userAnswer == correctAnswer
        : selectedAnswer == correctAnswer;
    
    if (isCorrect) {
      return '🎉 Correct! ${question['explanation']}';
    } else {
      return '❌ Correct answer: ${question['type'] == 'number_reading' || question['type'] == 'place_value' ? options[correctAnswer] : correctAnswer}\n${question['explanation']}';
    }
  }

  Widget _buildResultsScreen() {
    final percentage = (_score / _questions.length * 100).toInt();
    String resultText = '';
    String emoji = '';
    Color color = Colors.green;

    if (percentage >= 90) {
      resultText = 'Excellent! Perfect Score!';
      emoji = '🏆';
      color = Colors.green;
    } else if (percentage >= 80) {
      resultText = 'Great Job! You\'re Amazing!';
      emoji = '🎉';
      color = Colors.blue;
    } else if (percentage >= 70) {
      resultText = 'Good Work! Keep Going!';
      emoji = '👍';
      color = Colors.orange;
    } else if (percentage >= 60) {
      resultText = 'Not Bad! Practice More!';
      emoji = '💪';
      color = Colors.orange;
    } else {
      resultText = 'Keep Practicing! You Can Do It!';
      emoji = '📚';
      color = Colors.red;
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Exercise Results',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  emoji,
                  style: TextStyle(fontSize: screenWidth * 0.2),
                ),
                SizedBox(height: screenHeight * 0.02),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(screenWidth * 0.06),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(0, 0, 0, 0.2),
                        blurRadius: 8,
                        offset: const Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        resultText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.065,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: screenWidth * 0.1),
                          SizedBox(width: screenWidth * 0.03),
                          Text(
                            '$_score/${_questions.length}',
                            style: TextStyle(
                              fontSize: screenWidth * 0.09,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF6B8E6B),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      Text(
                        '$percentage% Correct',
                        style: TextStyle(fontSize: screenWidth * 0.05),
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: screenHeight * 0.065,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFF59D),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.06),
                                  side: const BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                              onPressed: _restartExercise,
                              child: Text(
                                'Try Again',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          SizedBox(
                            width: double.infinity,
                            height: screenHeight * 0.065,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.06),
                                  side: const BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Back to Lessons',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// ============ COMPARISON EXERCISE SCREEN ============

class ComparisonExerciseScreen extends StatefulWidget {
  final String lessonName;
  final String language;
  final int subLessonIndex;

  const ComparisonExerciseScreen({
    super.key,
    required this.lessonName,
    required this.language,
    required this.subLessonIndex,
  });

  @override
  State<ComparisonExerciseScreen> createState() => _ComparisonExerciseScreenState();
}

class _ComparisonExerciseScreenState extends State<ComparisonExerciseScreen> {
  int _currentQuestion = 0;
  int _score = 0;
  bool _exerciseCompleted = false;
  List<int?> _userAnswers = List.filled(10, null);
  List<bool> _answeredQuestions = List.filled(10, false);

  final List<Map<String, dynamic>> _questions = [
    {
      'type': 'simple_number',
      'question': 'Compare the numbers:',
      'leftValue': 45,
      'rightValue': 63,
      'leftLabel': '45',
      'rightLabel': '63',
      'correctAnswer': 1, // <
      'explanation': '45 is less than 63 (45 < 63).',
    },
    {
      'type': 'simple_number',
      'question': 'Compare the numbers:',
      'leftValue': 78,
      'rightValue': 78,
      'leftLabel': '78',
      'rightLabel': '78',
      'correctAnswer': 2, // =
      'explanation': '78 is equal to 78 (78 = 78).',
    },
    {
      'type': 'simple_number',
      'question': 'Compare the numbers:',
      'leftValue': 92,
      'rightValue': 87,
      'leftLabel': '92',
      'rightLabel': '87',
      'correctAnswer': 0, // >
      'explanation': '92 is greater than 87 (92 > 87).',
    },
    {
      'type': 'object_count',
      'question': 'Which group has more apples?',
      'leftCount': 5,
      'rightCount': 8,
      'leftLabel': '🍎🍎🍎🍎🍎',
      'rightLabel': '🍎🍎🍎🍎🍎🍎🍎🍎',
      'correctAnswer': 1, // Right group has more (8 > 5) - FIXED FROM 0 TO 1
      'explanation': 'Right group has 8 apples, left has 5. 8 > 5.',
    },
    {
      'type': 'object_count',
      'question': 'Which group has fewer stars?',
      'leftCount': 6,
      'rightCount': 3,
      'leftLabel': '⭐⭐⭐⭐⭐⭐',
      'rightLabel': '⭐⭐⭐',
      'correctAnswer': 1, // Right group has fewer (3 < 6)
      'explanation': 'Right group has 3 stars, left has 6. 3 < 6.',
    },
    {
      'type': 'word_problem',
      'question': 'Anna has 15 candies. Ben has 12 candies. Who has more?',
      'correctAnswer': 0, // Anna
      'options': ['Anna', 'Ben', 'Equal', 'Cannot tell'],
      'explanation': 'Anna has 15 candies, Ben has 12. 15 > 12.',
    },
    {
      'type': 'word_problem',
      'question': 'There are 24 students in Class A and 24 in Class B. Compare:',
      'correctAnswer': 2, // Equal
      'options': ['Class A > Class B', 'Class A < Class B', 'Class A = Class B', 'Cannot tell'],
      'explanation': 'Both classes have 24 students. They are equal.',
    },
    {
      'type': 'inequality',
      'question': 'Which symbol makes this true: 37 ? 42',
      'leftValue': 37,
      'rightValue': 42,
      'correctAnswer': 1, // <
      'options': ['>', '<', '=', '≥'],
      'explanation': '37 is less than 42, so 37 < 42.',
    },
    {
      'type': 'inequality',
      'question': 'Which symbol makes this true: 50 ? 50',
      'leftValue': 50,
      'rightValue': 50,
      'correctAnswer': 2, // =
      'options': ['>', '<', '=', '≠'],
      'explanation': '50 is equal to 50, so 50 = 50.',
    },
    {
      'type': 'mixed_comparison',
      'question': 'Order from smallest to largest: 19, 7, 25',
      'correctAnswer': 2, // 7, 19, 25
      'options': ['19, 7, 25', '25, 19, 7', '7, 19, 25', '7, 25, 19'],
      'explanation': '7 is smallest, then 19, then 25. 7 < 19 < 25.',
    },
  ];

  void _answerQuestion(int answerIndex) {
    if (!_answeredQuestions[_currentQuestion]) {
      setState(() {
        _answeredQuestions[_currentQuestion] = true;
        _userAnswers[_currentQuestion] = answerIndex;

        // SIMPLIFIED ANSWER CHECKING
        final question = _questions[_currentQuestion];
        final correctAnswer = question['correctAnswer'] as int;
        final isCorrect = answerIndex == correctAnswer;

        if (isCorrect) {
          _score++;
        }
        
        // Check if all questions answered
        if (_answeredQuestions.every((answered) => answered)) {
          _exerciseCompleted = true;
          _recordExerciseResults();
        }
      });
    }
  }

  void _recordExerciseResults() {
    final percentage = (_score / _questions.length * 100).toInt();
    
    // I-assume na mayroong progressManager instance
    // progressManager.recordExerciseScore(
    //   widget.lessonName,
    //   widget.language,
    //   widget.subLessonIndex,
    //   'Comparison Exercise',
    //   _score,
    //   _questions.length,
    //   percentage.toDouble(),
    // );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 Exercise completed! Score: $percentage%'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _nextQuestion() {
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestion > 0) {
      setState(() {
        _currentQuestion--;
      });
    }
  }

  void _restartExercise() {
    setState(() {
      _currentQuestion = 0;
      _score = 0;
      _exerciseCompleted = false;
      _userAnswers = List.filled(_questions.length, null);
      _answeredQuestions = List.filled(_questions.length, false);
    });
  }

  // Helper methods for responsive design
  double _getQuestionFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.042;
    if (screenWidth > 600) return screenWidth * 0.038;
    return screenWidth * 0.045;
  }

  double _getSymbolFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.09;
    if (screenWidth > 600) return screenWidth * 0.07;
    return screenWidth * 0.11;
  }

  double _getLabelFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.028;
    if (screenWidth > 600) return screenWidth * 0.024;
    return screenWidth * 0.03;
  }

  double _getComparisonButtonSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.22;
    if (screenWidth > 600) return screenWidth * 0.18;
    return screenWidth * 0.25;
  }

  double _getOptionFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.036;
    if (screenWidth > 600) return screenWidth * 0.032;
    return screenWidth * 0.04;
  }

  @override
  Widget build(BuildContext context) {
    if (_exerciseCompleted) {
      return _buildResultsScreen();
    }

    final currentQuestion = _questions[_currentQuestion];
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Comparison Exercise',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            children: [
              // Header with progress
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.purple[200]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question ${_currentQuestion + 1}/${_questions.length}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[900],
                          ),
                        ),
                        Text(
                          'Comparison Skills',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Colors.purple[700],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.compare_arrows, color: Colors.purple, size: screenWidth * 0.06),
                        SizedBox(width: screenWidth * 0.01),
                        Text(
                          '$_score',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[800],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              // Main question container
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(0, 0, 0, 0.15),
                      blurRadius: 8,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Question text - RESPONSIVE
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      child: Text(
                        currentQuestion['question'] as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: _getQuestionFontSize(screenWidth),
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Question content based on type
                    if (currentQuestion['type'] == 'simple_number')
                      _buildSimpleNumberQuestion(currentQuestion, screenWidth, screenHeight)
                    else if (currentQuestion['type'] == 'object_count')
                      _buildObjectCountQuestion(currentQuestion, screenWidth, screenHeight)
                    else if (currentQuestion['type'] == 'inequality')
                      _buildInequalityQuestion(currentQuestion, screenWidth, screenHeight)
                    else
                      _buildWordOrMixedQuestion(currentQuestion, screenWidth, screenHeight),

                    SizedBox(height: screenHeight * 0.03),

                    // Options
                    if (currentQuestion['type'] == 'simple_number' || 
                        currentQuestion['type'] == 'object_count' || 
                        currentQuestion['type'] == 'inequality')
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: screenWidth * 0.05,
                        runSpacing: screenWidth * 0.03,
                        children: [
                          _buildComparisonButton(0, '>', 'Greater than'),
                          _buildComparisonButton(1, '<', 'Less than'),
                          _buildComparisonButton(2, '=', 'Equal to'),
                        ],
                      )
                    else
                      Column(
                        children: List.generate(
                          (currentQuestion['options'] as List<String>).length,
                          (index) => _buildTextOptionButton(
                            index, 
                            currentQuestion['options'][index] as String
                          ),
                        ),
                      ),

                    SizedBox(height: screenHeight * 0.03),

                    // Explanation
                    if (_answeredQuestions[_currentQuestion])
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        decoration: BoxDecoration(
                          color: (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                              ? Colors.green[50]
                              : Colors.red[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                                ? Colors.green
                                : Colors.red,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _getComparisonAnswerText(currentQuestion),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: _getOptionFontSize(screenWidth) * 0.9,
                            fontWeight: FontWeight.bold,
                            color: (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                                ? Colors.green[900]
                                : Colors.red[900],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // Navigation buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: Size(0, screenHeight * 0.065),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.06),
                          side: const BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      onPressed: _currentQuestion > 0 ? _previousQuestion : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_back, size: screenWidth * 0.05),
                          SizedBox(width: screenWidth * 0.02),
                          Text(
                            'Previous',
                            style: TextStyle(fontSize: screenWidth * 0.04),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF59D),
                        foregroundColor: Colors.black,
                        minimumSize: Size(0, screenHeight * 0.065),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.06),
                          side: const BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      onPressed: _answeredQuestions[_currentQuestion]
                          ? () {
                              if (_currentQuestion < _questions.length - 1) {
                                _nextQuestion();
                              } else {
                                _recordExerciseResults();
                                setState(() {
                                  _exerciseCompleted = true;
                                });
                              }
                            }
                          : null,
                      child: Text(
                        _currentQuestion == _questions.length - 1
                            ? 'Finish Exercise'
                            : 'Next Question',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
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

  Widget _buildSimpleNumberQuestion(Map<String, dynamic> question, double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple, width: 2),
      ),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: screenWidth * 0.08,
            runSpacing: screenWidth * 0.04,
            children: [
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.purple[300]!, width: 2),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    question['leftLabel'] as String,
                    style: TextStyle(
                      fontSize: screenWidth * 0.12,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple[800],
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.purple[300]!, width: 2),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    question['rightLabel'] as String,
                    style: TextStyle(
                      fontSize: screenWidth * 0.12,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple[800],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            'Choose the correct comparison symbol',
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObjectCountQuestion(Map<String, dynamic> question, double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange, width: 2),
      ),
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: screenWidth * 0.1,
            runSpacing: screenWidth * 0.04,
            children: [
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(screenWidth * 0.03),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.orange[300]!, width: 2),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        question['leftLabel'] as String,
                        style: TextStyle(
                          fontSize: screenWidth * 0.08,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    'Group A',
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[800],
                    ),
                  ),
                  Text(
                    '(${question['leftCount']} items)',
                    style: TextStyle(
                      fontSize: screenWidth * 0.03,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(screenWidth * 0.03),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.orange[300]!, width: 2),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        question['rightLabel'] as String,
                        style: TextStyle(
                          fontSize: screenWidth * 0.08,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    'Group B',
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[800],
                    ),
                  ),
                  Text(
                    '(${question['rightCount']} items)',
                    style: TextStyle(
                      fontSize: screenWidth * 0.03,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInequalityQuestion(Map<String, dynamic> question, double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: screenWidth * 0.05,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  question['leftValue'].toString(),
                  style: TextStyle(
                    fontSize: screenWidth * 0.1,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              ),
              Container(
                width: screenWidth * 0.15,
                height: screenWidth * 0.15,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue, width: 3),
                ),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '?',
                      style: TextStyle(
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                  ),
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  question['rightValue'].toString(),
                  style: TextStyle(
                    fontSize: screenWidth * 0.1,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            'Choose the correct symbol',
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordOrMixedQuestion(Map<String, dynamic> question, double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
            child: Text(
              question['question'] as String,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: _getQuestionFontSize(screenWidth),
                color: Colors.green[800],
                fontWeight: FontWeight.w600,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (question['type'] == 'mixed_comparison')
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green[300]!, width: 2),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '19, 7, 25',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildComparisonButton(int index, String symbol, String label) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isAnswered = _answeredQuestions[_currentQuestion];
    final isSelected = _userAnswers[_currentQuestion] == index;
    final isCorrect = index == _questions[_currentQuestion]['correctAnswer'];

    Color buttonColor = Colors.white;
    Color borderColor = Colors.black;
    Color textColor = Colors.black;

    if (isAnswered) {
      if (isSelected && isCorrect) {
        buttonColor = Colors.green[100]!;
        borderColor = Colors.green;
        textColor = Colors.green[900]!;
      } else if (isSelected && !isCorrect) {
        buttonColor = Colors.red[100]!;
        borderColor = Colors.red;
        textColor = Colors.red[900]!;
      } else if (isCorrect) {
        buttonColor = Colors.green[100]!;
        borderColor = Colors.green;
        textColor = Colors.green[900]!;
      }
    }

    final buttonSize = _getComparisonButtonSize(screenWidth);
    
    return GestureDetector(
      onTap: () => _answerQuestion(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: buttonSize,
        height: buttonSize,
        margin: EdgeInsets.all(screenWidth * 0.01),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  symbol,
                  style: TextStyle(
                    fontSize: _getSymbolFontSize(screenWidth),
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.005),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: _getLabelFontSize(screenWidth),
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextOptionButton(int index, String text) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isAnswered = _answeredQuestions[_currentQuestion];
    final isSelected = _userAnswers[_currentQuestion] == index;
    final isCorrect = index == _questions[_currentQuestion]['correctAnswer'];

    Color buttonColor = Colors.white;
    Color borderColor = Colors.black;
    Color textColor = Colors.black;

    if (isAnswered) {
      if (isSelected && isCorrect) {
        buttonColor = Colors.green[100]!;
        borderColor = Colors.green;
        textColor = Colors.green[900]!;
      } else if (isSelected && !isCorrect) {
        buttonColor = Colors.red[100]!;
        borderColor = Colors.red;
        textColor = Colors.red[900]!;
      } else if (isCorrect) {
        buttonColor = Colors.green[100]!;
        borderColor = Colors.green;
        textColor = Colors.green[900]!;
      }
    }

    return GestureDetector(
      onTap: () => _answerQuestion(index),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: _getOptionFontSize(screenWidth),
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getComparisonAnswerText(Map<String, dynamic> question) {
    final userAnswer = _userAnswers[_currentQuestion];
    
    if (userAnswer == null) return '';
    
    final isCorrect = userAnswer == question['correctAnswer'];
    
    if (isCorrect) {
      return '🎉 Correct! ${question['explanation']}';
    } else {
      if (question['type'] == 'simple_number' || 
          question['type'] == 'object_count' || 
          question['type'] == 'inequality') {
        String correctSymbol = '';
        if (question['correctAnswer'] == 0) {
          correctSymbol = '>';
        } else if (question['correctAnswer'] == 1) {
          correctSymbol = '<';
        } else {
          correctSymbol = '=';
        }
        return '❌ Correct answer: $correctSymbol\n${question['explanation']}';
      } else {
        final options = question['options'] as List<String>;
        return '❌ Correct answer: ${options[question['correctAnswer'] as int]}\n${question['explanation']}';
      }
    }
  }

  Widget _buildResultsScreen() {
    final percentage = (_score / _questions.length * 100).toInt();
    String resultText = '';
    String emoji = '';
    Color color = Colors.purple;

    if (percentage >= 90) {
      resultText = 'Excellent! Perfect Score!';
      emoji = '🏆';
      color = Colors.purple;
    } else if (percentage >= 80) {
      resultText = 'Great Job! You\'re Amazing!';
      emoji = '🎉';
      color = Colors.purple;
    } else if (percentage >= 70) {
      resultText = 'Good Work! Keep Going!';
      emoji = '👍';
      color = Colors.orange;
    } else if (percentage >= 60) {
      resultText = 'Not Bad! Practice More!';
      emoji = '💪';
      color = Colors.orange;
    } else {
      resultText = 'Keep Practicing! You Can Do It!';
      emoji = '📚';
      color = Colors.red;
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Exercise Results',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  emoji,
                  style: TextStyle(fontSize: screenWidth * 0.2),
                ),
                SizedBox(height: screenHeight * 0.02),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(screenWidth * 0.06),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(0, 0, 0, 0.2),
                        blurRadius: 8,
                        offset: const Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        resultText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.065,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: screenWidth * 0.1),
                          SizedBox(width: screenWidth * 0.03),
                          Text(
                            '$_score/${_questions.length}',
                            style: TextStyle(
                              fontSize: screenWidth * 0.09,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF6B8E6B),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      Text(
                        '$percentage% Correct',
                        style: TextStyle(fontSize: screenWidth * 0.05),
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: screenHeight * 0.065,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFF59D),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.06),
                                  side: const BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                              onPressed: _restartExercise,
                              child: Text(
                                'Try Again',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          SizedBox(
                            width: double.infinity,
                            height: screenHeight * 0.065,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.06),
                                  side: const BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Back to Lessons',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============ ORDINAL NUMBERS EXERCISE SCREEN ============
class OrdinalExerciseScreen extends StatefulWidget {
  final String lessonName;
  final String language;
  final int subLessonIndex;

  const OrdinalExerciseScreen({
    super.key,
    required this.lessonName,
    required this.language,
    required this.subLessonIndex,
  });

  @override
  State<OrdinalExerciseScreen> createState() => _OrdinalExerciseScreenState();
}

class _OrdinalExerciseScreenState extends State<OrdinalExerciseScreen> {
  int _currentQuestion = 0;
  int _score = 0;
  bool _exerciseCompleted = false;
  List<int?> _userAnswers = List.filled(10, null);
  List<bool> _answeredQuestions = List.filled(10, false);

  // Based on the learning outcomes in the image: identify, read, write ordinal numbers up to 20th, 50th, 100th
  final List<Map<String, dynamic>> _questions = [
    {
      'type': 'identify_position',
      'question': 'What is the position of the red car?',
      'imageType': 'cars',
      'targetPosition': 3,
      'totalItems': 8,
      'correctAnswer': '3rd',
      'options': ['1st', '2nd', '3rd', '4th'],
      'explanation': 'The red car is in the 3rd position.',
    },
    {
      'type': 'read_ordinal',
      'question': 'Read this ordinal number:',
      'number': '15th',
      'correctAnswer': 'fifteenth',
      'options': ['fifteenth', 'fiveteenth', 'fiftieth', 'five tenth'],
      'explanation': '15th is read as "fifteenth".',
    },
    {
      'type': 'write_ordinal',
      'question': 'How do you write "twenty-second" as an ordinal?',
      'spoken': 'twenty-second',
      'correctAnswer': '22nd',
      'options': ['22th', '22nd', '22st', '22rd'],
      'explanation': '"Twenty-second" is written as 22nd.',
    },
    {
      'type': 'identify_position',
      'question': 'Which animal is in 7th place?',
      'imageType': 'animals',
      'targetPosition': 7,
      'totalItems': 10,
      'correctAnswer': '🐰',
      'options': ['🐘', '🦁', '🐰', '🐼'],
      'explanation': 'The rabbit (🐰) is in 7th position.',
    },
    {
      'type': 'missing_ordinal',
      'question': 'Complete the sequence: 1st, 2nd, 3rd, __, 5th',
      'correctAnswer': '4th',
      'options': ['4th', '4rd', '4st', '4nd'],
      'explanation': 'The missing ordinal is 4th (fourth).',
    },
    {
      'type': 'read_ordinal',
      'question': 'How do you read 43rd?',
      'number': '43rd',
      'correctAnswer': 'forty-third',
      'options': ['forty-three', 'forty-threeth', 'forty-third', 'fourty third'],
      'explanation': '43rd is read as "forty-third".',
    },
    {
      'type': 'identify_position',
      'question': 'What position is the trophy in?',
      'imageType': 'trophies',
      'targetPosition': 1,
      'totalItems': 5,
      'correctAnswer': '1st',
      'options': ['1st', '2nd', '3rd', '4th'],
      'explanation': 'The gold trophy is in 1st place.',
    },
    {
      'type': 'write_ordinal',
      'question': 'Write the ordinal for number 99:',
      'number': 99,
      'correctAnswer': '99th',
      'options': ['99th', '99rd', '99nd', '99st'],
      'explanation': '99 is written as 99th (ninety-ninth).',
    },
    {
      'type': 'compare_ordinals',
      'question': 'Which comes first: 21st or 25th?',
      'correctAnswer': '21st',
      'options': ['21st', '25th', 'They are equal', 'Cannot compare'],
      'explanation': '21st comes before 25th in order.',
    },
    {
      'type': 'read_ordinal',
      'question': 'Read this ordinal number:',
      'number': '100th',
      'correctAnswer': 'one hundredth',
      'options': ['one hundred', 'hundredth', 'one hundredth', 'one hundred first'],
      'explanation': '100th is read as "one hundredth".',
    },
  ];

  void _answerQuestion(int answerIndex) {
    if (!_answeredQuestions[_currentQuestion]) {
      setState(() {
        _answeredQuestions[_currentQuestion] = true;
        _userAnswers[_currentQuestion] = answerIndex;

        final question = _questions[_currentQuestion];
        final options = question['options'] as List<String>;
        final selectedAnswer = options[answerIndex];
        final isCorrect = selectedAnswer == question['correctAnswer'];

        if (isCorrect) {
          _score++;
        }
        
        if (_currentQuestion == _questions.length - 1) {
          _exerciseCompleted = true;
          _recordExerciseResults();
        }
      });
    }
  }

  void _recordExerciseResults() {
    final percentage = (_score / _questions.length * 100).toInt();
    
    // You would need to implement progressManager
    // progressManager.recordExerciseScore(
    //   widget.lessonName,
    //   widget.language,
    //   widget.subLessonIndex,
    //   'Ordinal Numbers Exercise',
    //   _score,
    //   _questions.length,
    //   _score,
    //   percentage.toDouble(),
    // );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 Exercise completed! Score: $percentage%'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _nextQuestion() {
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
      });
    } else {
      _recordExerciseResults();
      setState(() {
        _exerciseCompleted = true;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestion > 0) {
      setState(() {
        _currentQuestion--;
      });
    }
  }

  void _restartExercise() {
    setState(() {
      _currentQuestion = 0;
      _score = 0;
      _exerciseCompleted = false;
      _userAnswers = List.filled(_questions.length, null);
      _answeredQuestions = List.filled(_questions.length, false);
    });
  }

  // Helper methods for responsive design
  double _getQuestionFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.042;
    if (screenWidth > 600) return screenWidth * 0.038;
    return screenWidth * 0.045;
  }

  double _getOptionFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.055;
    if (screenWidth > 600) return screenWidth * 0.045;
    return screenWidth * 0.065;
  }

  double _getOptionButtonSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.20;
    if (screenWidth > 600) return screenWidth * 0.18;
    return screenWidth * 0.22;
  }

  double _getExplanationFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.032;
    if (screenWidth > 600) return screenWidth * 0.028;
    return screenWidth * 0.035;
  }

  // Helper method to generate position images
  Widget _buildPositionImage(Map<String, dynamic> question) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageType = question['imageType'];
    final targetPosition = question['targetPosition'];
    final totalItems = question['totalItems'];
    
    List<Widget> items = [];
    
    for (int i = 1; i <= totalItems; i++) {
      String emoji = '';
      Color color = Colors.grey;
      
      switch (imageType) {
        case 'cars':
          emoji = i == targetPosition ? '🚗' : '🚙';
          color = i == targetPosition ? Colors.red : Colors.blue;
          break;
        case 'animals':
          if (i == targetPosition) {
            emoji = '🐰';
          } else if (i == 1) {
            emoji = '🐘';
          } else if (i == 2) {
            emoji = '🦁';
          } else if (i == 10) {
            emoji = '🐼';
          } else {
            emoji = '🐵';
          }
          break;
        case 'trophies':
          if (i == 1) emoji = '🏆';
          else if (i == 2) emoji = '🥈';
          else if (i == 3) emoji = '🥉';
          else emoji = '🎖️';
          break;
      }
      
      items.add(
        Column(
          children: [
            Text(
              emoji,
              style: TextStyle(fontSize: screenWidth * 0.08),
            ),
            SizedBox(height: screenWidth * 0.01),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.02,
                vertical: screenWidth * 0.005,
              ),
              decoration: BoxDecoration(
                color: i == targetPosition ? Colors.orange[100] : Colors.grey[200],
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                '${i}${_getOrdinalSuffix(i)}',
                style: TextStyle(
                  fontSize: screenWidth * 0.03,
                  fontWeight: i == targetPosition ? FontWeight.bold : FontWeight.normal,
                  color: i == targetPosition ? Colors.orange[900] : Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      );
    }
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple, width: 2),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 15,
        runSpacing: 10,
        children: items,
      ),
    );
  }

  String _getOrdinalSuffix(int number) {
    if (number % 100 >= 11 && number % 100 <= 13) {
      return 'th';
    }
    switch (number % 10) {
      case 1: return 'st';
      case 2: return 'nd';
      case 3: return 'rd';
      default: return 'th';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_exerciseCompleted) {
      return _buildResultsScreen();
    }

    final currentQuestion = _questions[_currentQuestion];
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Ordinal Numbers Exercise',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            children: [
              // Header with progress
              Container(
                padding: EdgeInsets.all(screenWidth * 0.03),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.purple[200]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question ${_currentQuestion + 1}/${_questions.length}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[900],
                          ),
                        ),
                        Text(
                          'Identify, Read & Write Ordinals',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Colors.purple[700],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: screenWidth * 0.06),
                        SizedBox(width: screenWidth * 0.01),
                        Text(
                          '$_score',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[800],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              // Main question container
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(0, 0, 0, 0.15),
                      blurRadius: 8,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Question text - RESPONSIVE
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      child: Text(
                        currentQuestion['question'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: _getQuestionFontSize(screenWidth),
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Question content based on type
                    if (currentQuestion['type'] == 'identify_position')
                      _buildPositionImage(currentQuestion)
                    else if (currentQuestion['type'] == 'read_ordinal')
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F8F8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.blue, width: 2),
                        ),
                        child: Column(
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                currentQuestion['number'],
                                style: TextStyle(
                                  fontSize: screenWidth * 0.15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800],
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              'Read this ordinal number',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (currentQuestion['type'] == 'write_ordinal')
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F8F8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.green, width: 2),
                        ),
                        child: Column(
                          children: [
                            if (currentQuestion.containsKey('spoken'))
                              Text(
                                '"${currentQuestion['spoken']}"',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.08,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[800],
                                  fontStyle: FontStyle.italic,
                                ),
                              )
                            else
                              Text(
                                'Number: ${currentQuestion['number']}',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.08,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[800],
                                ),
                              ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              'Write as ordinal number',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (currentQuestion['type'] == 'missing_ordinal' || 
                             currentQuestion['type'] == 'compare_ordinals')
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F8F8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.orange, width: 2),
                        ),
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              currentQuestion['question'].contains('sequence')
                                  ? '1st, 2nd, 3rd, __, 5th'
                                  : '21st vs 25th',
                              style: TextStyle(
                                fontSize: screenWidth * 0.1,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[800],
                              ),
                            ),
                          ),
                        ),
                      ),

                    SizedBox(height: screenHeight * 0.03),

                    // Options - RESPONSIVE
                    Wrap(
                      alignment: WrapAlignment.center,
                      runSpacing: screenWidth * 0.03,
                      spacing: screenWidth * 0.03,
                      children: List.generate(
                        (currentQuestion['options'] as List).length,
                        (index) => _buildOptionButton(index, currentQuestion['options']),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Explanation - RESPONSIVE
                    if (_answeredQuestions[_currentQuestion])
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        decoration: BoxDecoration(
                          color: ((currentQuestion['options'] as List)[_userAnswers[_currentQuestion]!] == currentQuestion['correctAnswer'])
                              ? Colors.green[50]
                              : Colors.red[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: ((currentQuestion['options'] as List)[_userAnswers[_currentQuestion]!] == currentQuestion['correctAnswer'])
                                ? Colors.green
                                : Colors.red,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _getCorrectAnswerText(currentQuestion),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: _getExplanationFontSize(screenWidth),
                            fontWeight: FontWeight.bold,
                            color: ((currentQuestion['options'] as List)[_userAnswers[_currentQuestion]!] == currentQuestion['correctAnswer'])
                                ? Colors.green[900]
                                : Colors.red[900],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // Navigation buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: Size(0, screenHeight * 0.065),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.06),
                          side: const BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      onPressed: _currentQuestion > 0 ? _previousQuestion : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_back, size: screenWidth * 0.05),
                          SizedBox(width: screenWidth * 0.02),
                          Text(
                            'Previous',
                            style: TextStyle(fontSize: screenWidth * 0.04),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF59D),
                        foregroundColor: Colors.black,
                        minimumSize: Size(0, screenHeight * 0.065),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.06),
                          side: const BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      onPressed: _answeredQuestions[_currentQuestion]
                          ? () {
                              if (_currentQuestion < _questions.length - 1) {
                                _nextQuestion();
                              } else {
                                _recordExerciseResults();
                                setState(() {
                                  _exerciseCompleted = true;
                                });
                              }
                            }
                          : null,
                      child: Text(
                        _currentQuestion == _questions.length - 1
                            ? 'Finish Exercise'
                            : 'Next Question',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
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

  Widget _buildOptionButton(int index, List<dynamic> options) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isAnswered = _answeredQuestions[_currentQuestion];
    final isSelected = _userAnswers[_currentQuestion] == index;
    final question = _questions[_currentQuestion];
    final selectedAnswer = options[index];
    final isCorrect = selectedAnswer == question['correctAnswer'];

    Color buttonColor = Colors.white;
    Color borderColor = Colors.black;
    Color textColor = Colors.black;

    if (isAnswered) {
      if (isSelected && isCorrect) {
        buttonColor = Colors.green[100]!;
        borderColor = Colors.green;
        textColor = Colors.green[900]!;
      } else if (isSelected && !isCorrect) {
        buttonColor = Colors.red[100]!;
        borderColor = Colors.red;
        textColor = Colors.red[900]!;
      } else if (isCorrect) {
        buttonColor = Colors.green[100]!;
        borderColor = Colors.green;
        textColor = Colors.green[900]!;
      }
    }

    final optionText = options[index];
    final buttonSize = _getOptionButtonSize(screenWidth);
    
    return GestureDetector(
      onTap: () => _answerQuestion(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: buttonSize,
        height: buttonSize * 0.8,
        margin: EdgeInsets.all(screenWidth * 0.015),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: Text(
                optionText.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: _getOptionFontSize(screenWidth),
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getCorrectAnswerText(Map<String, dynamic> question) {
    final userAnswer = _userAnswers[_currentQuestion];
    
    if (userAnswer == null) return '';
    
    final options = question['options'] as List<String>;
    final selectedAnswer = options[userAnswer];
    final isCorrect = selectedAnswer == question['correctAnswer'];
    
    if (isCorrect) {
      return '🎉 Correct! ${question['explanation']}';
    } else {
      return '❌ Correct answer: ${question['correctAnswer']}\n${question['explanation']}';
    }
  }

  Widget _buildResultsScreen() {
    final percentage = (_score / _questions.length * 100).toInt();
    String resultText = '';
    String emoji = '';
    Color color = Colors.purple;

    if (percentage >= 90) {
      resultText = 'Excellent! Perfect Score!';
      emoji = '🏆';
      color = Colors.purple;
    } else if (percentage >= 80) {
      resultText = 'Great Job! You\'re Amazing!';
      emoji = '🎉';
      color = Colors.purple;
    } else if (percentage >= 70) {
      resultText = 'Good Work! Keep Going!';
      emoji = '👍';
      color = Colors.purple[700]!;
    } else if (percentage >= 60) {
      resultText = 'Not Bad! Practice More!';
      emoji = '💪';
      color = Colors.purple[600]!;
    } else {
      resultText = 'Keep Practicing! You Can Do It!';
      emoji = '📚';
      color = Colors.purple[400]!;
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Exercise Results',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  emoji,
                  style: TextStyle(fontSize: screenWidth * 0.2),
                ),
                SizedBox(height: screenHeight * 0.02),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(screenWidth * 0.06),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(0, 0, 0, 0.2),
                        blurRadius: 8,
                        offset: const Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        resultText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.065,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: screenWidth * 0.1),
                          SizedBox(width: screenWidth * 0.03),
                          Text(
                            '$_score/${_questions.length}',
                            style: TextStyle(
                              fontSize: screenWidth * 0.09,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF6B8E6B),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      Text(
                        '$percentage% Correct',
                        style: TextStyle(fontSize: screenWidth * 0.05),
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: screenHeight * 0.065,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFF59D),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.06),
                                  side: const BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                              onPressed: _restartExercise,
                              child: Text(
                                'Try Again',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          SizedBox(
                            width: double.infinity,
                            height: screenHeight * 0.065,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.06),
                                  side: const BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Back to Lessons',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// ============ MONEY VALUE EXERCISE SCREEN ============

class MoneyValueExerciseScreen extends StatefulWidget {
  final String lessonName;
  final String language;
  final int subLessonIndex;

  const MoneyValueExerciseScreen({
    super.key,
    required this.lessonName,
    required this.language,
    required this.subLessonIndex,
  });

  @override
  State<MoneyValueExerciseScreen> createState() => _MoneyValueExerciseScreenState();
}

class _MoneyValueExerciseScreenState extends State<MoneyValueExerciseScreen> {
  int _currentQuestion = 0;
  int _score = 0;
  bool _exerciseCompleted = false;
  List<int?> _userAnswers = List.filled(11, null);
  List<bool> _answeredQuestions = List.filled(11, false);

  // Philippine currency values
  final List<int> _centavoCoins = [1, 5, 10, 25];
  final List<int> _pesoCoins = [1, 5, 10, 20];
  final List<int> _pesoBills = [20, 50, 100, 200, 500, 1000];

  // Questions based on Philippine currency learning outcomes - FIXED ANSWERS
  final List<Map<String, dynamic>> _questions = [
    // Recognize Philippine coins up to ₱20
    {
      'type': 'recognize_coin',
      'question': 'What is the value of this Philippine coin?',
      'coinValue': 5,
      'isCentavo': true,
      'correctAnswer': '5¢',
      'options': ['5¢', '10¢', '1¢', '25¢'],
      'explanation': 'This is a Philippine 5-centavo coin.',
    },
    {
      'type': 'recognize_coin',
      'question': 'What is the value of this Philippine coin?',
      'coinValue': 10,
      'isCentavo': false,
      'correctAnswer': '₱10',
      'options': ['₱1', '₱5', '₱10', '₱20'],
      'explanation': 'This is a Philippine ten-peso coin.',
    },
    {
      'type': 'recognize_bill',
      'question': 'Which Philippine bill is shown?',
      'billValue': 20,
      'correctAnswer': '₱20',
      'options': ['₱5', '₱10', '₱20', '₱50'],
      'explanation': 'This is a Philippine twenty-peso bill (₱20).',
    },
    {
      'type': 'recognize_bill',
      'question': 'Which Philippine bill is shown?',
      'billValue': 50,
      'correctAnswer': '₱50',
      'options': ['₱20', '₱50', '₱100', '₱200'],
      'explanation': 'This is a Philippine fifty-peso bill.',
    },
    {
      'type': 'recognize_coin',
      'question': 'What is the value of this coin?',
      'coinValue': 25,
      'isCentavo': true,
      'correctAnswer': '25¢',
      'options': ['5¢', '10¢', '25¢', '50¢'],
      'explanation': 'This is a Philippine 25-centavo coin.',
    },
    // Write amount up to ₱20
    {
      'type': 'write_amount',
      'question': 'Write the amount of money shown:',
      'coins': [
        {'value': 10, 'isCentavo': true, 'count': 2}, // 20¢
        {'value': 5, 'isCentavo': true, 'count': 1},  // 5¢
        {'value': 1, 'isCentavo': false, 'count': 1}, // ₱1
      ],
      'correctAnswer': '₱1.25',
      'options': ['₱1.25', '₱1.50', '₱1.75', '₱2.00'],
      'explanation': '2 ten-centavo coins (20¢) + 1 five-centavo coin (5¢) + 1 one-peso coin (₱1) = ₱1.25',
    },
    // Compare amounts up to ₱20 - FIXED: Group A = ₱20, Group B = ₱20, they are equal
    {
      'type': 'compare_amounts',
      'question': 'Which amount is greater?',
      'groupA': [
        {'value': 10, 'isCentavo': false, 'count': 1}, // ₱10
        {'value': 5, 'isCentavo': false, 'count': 2},  // ₱10
      ],
      'groupB': [
        {'value': 20, 'isCentavo': false, 'count': 1}, // ₱20
      ],
      'correctAnswer': 'Equal',
      'options': ['Group A', 'Group B', 'Equal', 'Cannot compare'],
      'explanation': 'Group A: ₱10 + (2×₱5) = ₱20, Group B: ₱20. Both are equal!',
    },
    // Count value up to ₱20
    {
      'type': 'count_value',
      'question': 'What is the total value?',
      'moneyItems': [
        {'value': 20, 'isBill': true, 'count': 1},    // ₱20 bill
        {'value': 10, 'isCentavo': true, 'count': 3}, // 30¢
      ],
      'maxValue': 20,
      'correctAnswer': '₱20.30',
      'options': ['₱20.30', '₱20.50', '₱21.00', '₱19.70'],
      'explanation': '₱20 bill + 3 ten-centavo coins (30¢) = ₱20.30',
    },
    // Compare amounts up to ₱50 - FIXED: Group A = ₱50, Group B = ₱50, they are equal
    {
      'type': 'compare_amounts',
      'question': 'Compare the two amounts:',
      'groupA': [
        {'value': 20, 'isBill': true, 'count': 2},    // ₱40
        {'value': 5, 'isCentavo': false, 'count': 2},  // ₱10
      ],
      'groupB': [
        {'value': 50, 'isBill': true, 'count': 1},    // ₱50
      ],
      'correctAnswer': 'Equal',
      'options': ['Group A is greater', 'Group B is greater', 'Equal', 'Group A is less'],
      'explanation': 'Group A: (2×₱20) + (2×₱5) = ₱50, Group B: ₱50. They are equal!',
    },
    // Identify Philippine currency notation
    {
      'type': 'identify_notation',
      'question': 'Which notation is correct for twenty-five pesos and fifty centavos?',
      'correctAnswer': '₱25.50',
      'options': ['₱25.50', '25.50₱', '₱25,50', '25.50 pesos'],
      'explanation': 'The correct Philippine peso notation is ₱25.50',
    },
  ];

  void _answerQuestion(int answerIndex) {
    if (!_answeredQuestions[_currentQuestion]) {
      setState(() {
        _answeredQuestions[_currentQuestion] = true;
        _userAnswers[_currentQuestion] = answerIndex;

        final question = _questions[_currentQuestion];
        final options = question['options'] as List<String>;
        final selectedAnswer = options[answerIndex];
        final isCorrect = selectedAnswer == question['correctAnswer'];

        if (isCorrect) {
          _score++;
        }
        
        if (_currentQuestion == _questions.length - 1) {
          _exerciseCompleted = true;
          _recordExerciseResults();
        }
      });
    }
  }

  void _recordExerciseResults() {
    final percentage = (_score / _questions.length * 100).toInt();
    
    // IMPORTANT: Record the exercise results to progressManager
    // I-add ang import ng progressManager sa itaas ng file
    // O gumamit ng static instance kung available
    if (ProgressManager != null) {
      // Tawagin ang progressManager para i-record ang resulta
      progressManager.recordExerciseScore(
        widget.lessonName,
        widget.language,
        widget.subLessonIndex,
        'Money Value Exercise',
        _score,
        _questions.length,
        _score,
        percentage.toDouble(),
      );
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 Exercise completed! Score: $percentage%'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _nextQuestion() {
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
      });
    } else {
      _recordExerciseResults();
      setState(() {
        _exerciseCompleted = true;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestion > 0) {
      setState(() {
        _currentQuestion--;
      });
    }
  }

  void _restartExercise() {
    setState(() {
      _currentQuestion = 0;
      _score = 0;
      _exerciseCompleted = false;
      _userAnswers = List.filled(_questions.length, null);
      _answeredQuestions = List.filled(_questions.length, false);
    });
  }

  // Helper methods for responsive design
  double _getQuestionFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.042;
    if (screenWidth > 600) return screenWidth * 0.038;
    return screenWidth * 0.045;
  }

  double _getOptionFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.045;
    if (screenWidth > 600) return screenWidth * 0.04;
    return screenWidth * 0.05;
  }

  double _getOptionButtonSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.28;
    if (screenWidth > 600) return screenWidth * 0.22;
    return screenWidth * 0.25;
  }

  double _getExplanationFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.032;
    if (screenWidth > 600) return screenWidth * 0.028;
    return screenWidth * 0.035;
  }

  // Helper method to get currency emoji
  String _getCurrencyEmoji(int value, bool isBill, bool isCentavo) {
    if (isBill) {
      return '💵'; // Bill emoji
    } else {
      if (isCentavo) {
        return '🪙'; // Small coin for centavos
      } else {
        return '🪙'; // Coin for pesos
      }
    }
  }

  // Helper method to format Philippine currency
  String _formatCurrency(double amount) {
    return '₱${amount.toStringAsFixed(2)}';
  }

  // Build money display for questions
  Widget _buildMoneyDisplay(Map<String, dynamic> question) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: Column(
        children: [
          if (question['type'] == 'recognize_coin' || question['type'] == 'recognize_bill')
            _buildSingleCurrencyDisplay(question, screenWidth)
          else if (question['type'] == 'write_amount' || question['type'] == 'count_value')
            _buildMultipleCurrencyDisplay(question, screenWidth)
          else if (question['type'] == 'compare_amounts')
            _buildComparisonDisplay(question, screenWidth)
          else if (question['type'] == 'identify_notation')
            _buildNotationDisplay(question, screenWidth)
          else
            _buildWordProblemDisplay(question, screenWidth),
        ],
      ),
    );
  }

  Widget _buildSingleCurrencyDisplay(Map<String, dynamic> question, double screenWidth) {
    final isBill = question['type'] == 'recognize_bill';
    final value = isBill ? question['billValue'] : question['coinValue'];
    final isCentavo = question['isCentavo'] ?? false;
    
    return Column(
      children: [
        Text(
          _getCurrencyEmoji(value, isBill, isCentavo),
          style: TextStyle(fontSize: screenWidth * 0.15),
        ),
        SizedBox(height: screenWidth * 0.02),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: screenWidth * 0.02,
          ),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.green, width: 1),
          ),
          child: Text(
            'Philippine Currency',
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
        ),
        SizedBox(height: screenWidth * 0.02),
        Text(
          isBill ? 'Bill' : 'Coin',
          style: TextStyle(
            fontSize: screenWidth * 0.035,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildMultipleCurrencyDisplay(Map<String, dynamic> question, double screenWidth) {
    List<Map<String, dynamic>> items = [];
    
    if (question['type'] == 'write_amount') {
      items = List<Map<String, dynamic>>.from(question['coins']);
    } else if (question['type'] == 'count_value') {
      items = List<Map<String, dynamic>>.from(question['moneyItems']);
    }
    
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: items.expand((item) {
        List<Widget> widgets = [];
        int count = item['count'];
        int value = item['value'];
        bool isBill = item['isBill'] ?? false;
        bool isCentavo = item['isCentavo'] ?? false;
        
        for (int i = 0; i < count; i++) {
          widgets.add(
            Column(
              children: [
                Text(
                  _getCurrencyEmoji(value, isBill, isCentavo),
                  style: TextStyle(fontSize: screenWidth * 0.08),
                ),
                SizedBox(height: screenWidth * 0.01),
                Text(
                  isCentavo ? '${value}¢' : '₱$value',
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
              ],
            ),
          );
        }
        return widgets;
      }).toList(),
    );
  }

  Widget _buildComparisonDisplay(Map<String, dynamic> question, double screenWidth) {
    final groupA = List<Map<String, dynamic>>.from(question['groupA']);
    final groupB = List<Map<String, dynamic>>.from(question['groupB']);
    
    return Column(
      children: [
        Text(
          'Compare Philippine Money',
          style: TextStyle(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
        SizedBox(height: screenWidth * 0.03),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  'Group A',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                SizedBox(height: screenWidth * 0.02),
                _buildCurrencyGroup(groupA, screenWidth),
              ],
            ),
            Column(
              children: [
                Text(
                  'vs',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenWidth * 0.04),
                Text(
                  '?',
                  style: TextStyle(
                    fontSize: screenWidth * 0.08,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  'Group B',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[800],
                  ),
                ),
                SizedBox(height: screenWidth * 0.02),
                _buildCurrencyGroup(groupB, screenWidth),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCurrencyGroup(List<Map<String, dynamic>> items, double screenWidth) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 5,
      runSpacing: 5,
      children: items.expand((item) {
        List<Widget> widgets = [];
        int count = item['count'];
        int value = item['value'];
        bool isBill = item['isBill'] ?? false;
        bool isCentavo = item['isCentavo'] ?? false;
        
        for (int i = 0; i < count; i++) {
          widgets.add(
            Text(
              _getCurrencyEmoji(value, isBill, isCentavo),
              style: TextStyle(fontSize: screenWidth * 0.06),
            ),
          );
        }
        return widgets;
      }).toList(),
    );
  }

  Widget _buildNotationDisplay(Map<String, dynamic> question, double screenWidth) {
    return Column(
      children: [
        Text(
          'Philippine Peso Notation',
          style: TextStyle(
            fontSize: screenWidth * 0.06,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
        SizedBox(height: screenWidth * 0.03),
        Container(
          padding: EdgeInsets.all(screenWidth * 0.04),
          decoration: BoxDecoration(
            color: Colors.yellow[50],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.orange, width: 2),
          ),
          child: Text(
            'How do you write\n"twenty-five pesos and fifty centavos"\nin Philippine currency notation?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWordProblemDisplay(Map<String, dynamic> question, double screenWidth) {
    return Column(
      children: [
        Icon(
          Icons.store,
          size: screenWidth * 0.12,
          color: Colors.orange,
        ),
        SizedBox(height: screenWidth * 0.02),
        Container(
          padding: EdgeInsets.all(screenWidth * 0.04),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange, width: 2),
          ),
          child: Text(
            'Philippine Peso Word Problem',
            style: TextStyle(
              fontSize: screenWidth * 0.055,
              fontWeight: FontWeight.bold,
              color: Colors.orange[900],
            ),
          ),
        ),
        SizedBox(height: screenWidth * 0.02),
        Text(
          'Solve using Philippine currency',
          style: TextStyle(
            fontSize: screenWidth * 0.04,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_exerciseCompleted) {
      return _buildResultsScreen();
    }

    final currentQuestion = _questions[_currentQuestion];
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Philippine Money Exercise',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            children: [
              // Header with progress
              Container(
                padding: EdgeInsets.all(screenWidth * 0.03),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question ${_currentQuestion + 1}/${_questions.length}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[900],
                          ),
                        ),
                        Text(
                          'Philippine Peso & Centavos',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.currency_exchange, color: Colors.green, size: screenWidth * 0.06),
                        SizedBox(width: screenWidth * 0.01),
                        Text(
                          '$_score',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              // Main question container
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(0, 0, 0, 0.15),
                      blurRadius: 8,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Question text - RESPONSIVE
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      child: Text(
                        currentQuestion['question'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: _getQuestionFontSize(screenWidth),
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Money display
                    _buildMoneyDisplay(currentQuestion),

                    SizedBox(height: screenHeight * 0.03),

                    // Options - RESPONSIVE
                    Wrap(
                      alignment: WrapAlignment.center,
                      runSpacing: screenWidth * 0.03,
                      spacing: screenWidth * 0.03,
                      children: List.generate(
                        (currentQuestion['options'] as List).length,
                        (index) => _buildOptionButton(index, currentQuestion['options']),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Explanation - RESPONSIVE
                    if (_answeredQuestions[_currentQuestion])
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        decoration: BoxDecoration(
                          color: ((currentQuestion['options'] as List)[_userAnswers[_currentQuestion]!] == currentQuestion['correctAnswer'])
                              ? Colors.green[50]
                              : Colors.red[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: ((currentQuestion['options'] as List)[_userAnswers[_currentQuestion]!] == currentQuestion['correctAnswer'])
                                ? Colors.green
                                : Colors.red,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _getCorrectAnswerText(currentQuestion),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: _getExplanationFontSize(screenWidth),
                            fontWeight: FontWeight.bold,
                            color: ((currentQuestion['options'] as List)[_userAnswers[_currentQuestion]!] == currentQuestion['correctAnswer'])
                                ? Colors.green[900]
                                : Colors.red[900],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // Navigation buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: Size(0, screenHeight * 0.065),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.06),
                          side: const BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      onPressed: _currentQuestion > 0 ? _previousQuestion : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_back, size: screenWidth * 0.05),
                          SizedBox(width: screenWidth * 0.02),
                          Text(
                            'Previous',
                            style: TextStyle(fontSize: screenWidth * 0.04),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF59D),
                        foregroundColor: Colors.black,
                        minimumSize: Size(0, screenHeight * 0.065),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.06),
                          side: const BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      onPressed: _answeredQuestions[_currentQuestion]
                          ? () {
                              if (_currentQuestion < _questions.length - 1) {
                                _nextQuestion();
                              } else {
                                _recordExerciseResults();
                                setState(() {
                                  _exerciseCompleted = true;
                                });
                              }
                            }
                          : null,
                      child: Text(
                        _currentQuestion == _questions.length - 1
                            ? 'Finish Exercise'
                            : 'Next Question',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
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

  Widget _buildOptionButton(int index, List<dynamic> options) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isAnswered = _answeredQuestions[_currentQuestion];
    final isSelected = _userAnswers[_currentQuestion] == index;
    final question = _questions[_currentQuestion];
    final selectedAnswer = options[index];
    final isCorrect = selectedAnswer == question['correctAnswer'];

    Color buttonColor = Colors.white;
    Color borderColor = Colors.black;
    Color textColor = Colors.black;

    if (isAnswered) {
      if (isSelected && isCorrect) {
        buttonColor = Colors.green[100]!;
        borderColor = Colors.green;
        textColor = Colors.green[900]!;
      } else if (isSelected && !isCorrect) {
        buttonColor = Colors.red[100]!;
        borderColor = Colors.red;
        textColor = Colors.red[900]!;
      } else if (isCorrect) {
        buttonColor = Colors.green[100]!;
        borderColor = Colors.green;
        textColor = Colors.green[900]!;
      }
    }

    final optionText = options[index];
    final buttonSize = _getOptionButtonSize(screenWidth);
    
    return GestureDetector(
      onTap: () => _answerQuestion(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: buttonSize,
        height: buttonSize * 0.7,
        margin: EdgeInsets.all(screenWidth * 0.015),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: Text(
                optionText.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: _getOptionFontSize(screenWidth),
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getCorrectAnswerText(Map<String, dynamic> question) {
    final userAnswer = _userAnswers[_currentQuestion];
    
    if (userAnswer == null) return '';
    
    final options = question['options'] as List<String>;
    final selectedAnswer = options[userAnswer];
    final isCorrect = selectedAnswer == question['correctAnswer'];
    
    if (isCorrect) {
      return '🎉 Correct! ${question['explanation']}';
    } else {
      return '❌ Correct answer: ${question['correctAnswer']}\n${question['explanation']}';
    }
  }

  Widget _buildResultsScreen() {
    final percentage = (_score / _questions.length * 100).toInt();
    String resultText = '';
    String emoji = '';
    Color color = Colors.green;

    if (percentage >= 90) {
      resultText = 'Peso Master! Perfect Score!';
      emoji = '💰';
      color = Colors.green;
    } else if (percentage >= 80) {
      resultText = 'Excellent Money Skills!';
      emoji = '💵';
      color = Colors.green[700]!;
    } else if (percentage >= 70) {
      resultText = 'Good with Philippine Currency!';
      emoji = '💎';
      color = Colors.green[600]!;
    } else if (percentage >= 60) {
      resultText = 'Keep Practicing Philippine Money!';
      emoji = '🪙';
      color = Colors.orange;
    } else {
      resultText = 'More Practice with Peso Needed!';
      emoji = '📚';
      color = Colors.orange;
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Philippine Money Results',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  emoji,
                  style: TextStyle(fontSize: screenWidth * 0.2),
                ),
                SizedBox(height: screenHeight * 0.02),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(screenWidth * 0.06),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(0, 0, 0, 0.2),
                        blurRadius: 8,
                        offset: const Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        resultText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.065,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: screenWidth * 0.1),
                          SizedBox(width: screenWidth * 0.03),
                          Text(
                            '$_score/${_questions.length}',
                            style: TextStyle(
                              fontSize: screenWidth * 0.09,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF6B8E6B),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      Text(
                        '$percentage% Correct',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: screenHeight * 0.065,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFF59D),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.06),
                                  side: const BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                              onPressed: _restartExercise,
                              child: Text(
                                'Try Again',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          SizedBox(
                            width: double.infinity,
                            height: screenHeight * 0.065,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.06),
                                  side: const BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Back to Lessons',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AdditionExerciseScreen extends StatefulWidget {
  final String lessonName;
  final String language;
  final int subLessonIndex;

  const AdditionExerciseScreen({
    super.key,
    required this.lessonName,
    required this.language,
    required this.subLessonIndex,
  });

  @override
  State<AdditionExerciseScreen> createState() => _AdditionExerciseScreenState();
}

class _AdditionExerciseScreenState extends State<AdditionExerciseScreen> {
  int _currentQuestion = 0;
  int _score = 0;
  bool _exerciseCompleted = false;
  List<String?> _userAnswers = List.filled(10, null);
  List<bool> _answeredQuestions = List.filled(10, false);
  List<TextEditingController> _textControllers = List.generate(10, (_) => TextEditingController());

  final List<Map<String, dynamic>> _questions = [
    {
      'type': 'basic_addition',
      'question': 'Add using objects:',
      'leftObjects': '🍎🍎🍎',
      'rightObjects': '🍎🍎',
      'correctAnswer': '5',
      'explanation': '3 apples + 2 apples = 5 apples',
      'hint': 'Count all the apples together',
    },
    {
      'type': 'basic_addition',
      'question': 'Add the numbers:',
      'leftValue': 7,
      'rightValue': 4,
      'correctAnswer': '11',
      'explanation': '7 + 4 = 11',
      'hint': 'Start from 7, count 4 more: 8, 9, 10, 11',
    },
    {
      'type': 'basic_addition',
      'question': 'Complete the addition:',
      'leftValue': 9,
      'rightValue': 6,
      'correctAnswer': '15',
      'explanation': '9 + 6 = 15',
      'hint': 'You can make 10 first: 9 + 1 = 10, then add the remaining 5',
    },
    {
      'type': 'two_digit_addition',
      'question': 'Add two-digit numbers:',
      'leftValue': 23,
      'rightValue': 14,
      'correctAnswer': '37',
      'explanation': '23 + 14 = 37\nAdd ones: 3 + 4 = 7\nAdd tens: 20 + 10 = 30\nTotal: 30 + 7 = 37',
      'hint': 'Add the ones place first, then the tens place',
    },
    {
      'type': 'two_digit_addition',
      'question': 'Calculate the sum:',
      'leftValue': 45,
      'rightValue': 28,
      'correctAnswer': '73',
      'explanation': '45 + 28 = 73\n5 + 8 = 13 (carry 1)\n40 + 20 + 10 = 70\nTotal: 70 + 3 = 73',
      'hint': 'Remember to carry over if the ones sum is 10 or more',
    },
    {
      'type': 'word_problem',
      'question': 'Anna has 15 candies. Her brother gives her 8 more. How many candies does she have now?',
      'correctAnswer': '23',
      'explanation': '15 + 8 = 23\nAnna now has 23 candies.',
      'hint': 'Start with 15, add 8 more',
    },
    {
      'type': 'word_problem',
      'question': 'A farmer collected 37 eggs on Monday and 25 eggs on Tuesday. How many eggs did he collect in total?',
      'correctAnswer': '62',
      'explanation': '37 + 25 = 62\nThe farmer collected 62 eggs in total.',
      'hint': 'Add the eggs from both days',
    },
    {
      'type': 'money_addition',
      'question': 'Maria has ₱75. She earns ₱38 more. How much money does she have now?',
      'correctAnswer': '113',
      'explanation': '₱75 + ₱38 = ₱113\nMaria now has ₱113.',
      'hint': 'Add pesos like regular numbers',
    },
    {
      'type': 'three_digit_addition',
      'question': 'Add three-digit numbers:',
      'leftValue': 256,
      'rightValue': 189,
      'correctAnswer': '445',
      'explanation': '256 + 189 = 445\n6 + 9 = 15 (carry 1)\n50 + 80 + 10 = 140 (carry 1)\n200 + 100 + 100 = 400\nTotal: 400 + 40 + 5 = 445',
      'hint': 'Add ones, then tens, then hundreds',
    },
    {
      'type': 'missing_addend',
      'question': 'Find the missing number: 16 + ? = 24',
      'correctAnswer': '8',
      'explanation': '16 + 8 = 24\nThink: What number added to 16 makes 24?',
      'hint': 'You can subtract: 24 - 16 = ?',
    },
  ];

  @override
  void dispose() {
    for (var controller in _textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _answerQuestion(String answer) {
    if (!_answeredQuestions[_currentQuestion]) {
      setState(() {
        _answeredQuestions[_currentQuestion] = true;
        _userAnswers[_currentQuestion] = answer;

        final question = _questions[_currentQuestion];
        final correctAnswer = question['correctAnswer'] as String;
        final isCorrect = answer.trim() == correctAnswer;

        if (isCorrect) {
          _score++;
        }
        
        if (_answeredQuestions.every((answered) => answered)) {
          _exerciseCompleted = true;
          _recordExerciseResults();
        }
      });
    }
  }

  void _recordExerciseResults() {
    final percentage = (_score / _questions.length * 100).toInt();
    
    // Uncomment and implement your progress manager
    // progressManager.recordExerciseScore(
    //   widget.lessonName,
    //   widget.language,
    //   widget.subLessonIndex,
    //   'Addition Exercise',
    //   _score,
    //   _questions.length,
    //   percentage.toDouble(),
    // );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 Exercise completed! Score: $percentage%'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _nextQuestion() {
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestion > 0) {
      setState(() {
        _currentQuestion--;
      });
    }
  }

  void _restartExercise() {
    setState(() {
      _currentQuestion = 0;
      _score = 0;
      _exerciseCompleted = false;
      _userAnswers = List.filled(_questions.length, null);
      _answeredQuestions = List.filled(_questions.length, false);
      for (var controller in _textControllers) {
        controller.clear();
      }
    });
  }

  // Helper methods for responsive design
  double _getQuestionFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.042;
    if (screenWidth > 600) return screenWidth * 0.038;
    return screenWidth * 0.045;
  }

  double _getNumberFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.09;
    if (screenWidth > 600) return screenWidth * 0.07;
    return screenWidth * 0.11;
  }

  double _getInputFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.05;
    if (screenWidth > 600) return screenWidth * 0.045;
    return screenWidth * 0.06;
  }

  double _getOptionFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.036;
    if (screenWidth > 600) return screenWidth * 0.032;
    return screenWidth * 0.04;
  }

  @override
  Widget build(BuildContext context) {
    if (_exerciseCompleted) {
      return _buildResultsScreen();
    }

    final currentQuestion = _questions[_currentQuestion];
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[50],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Addition Exercise',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            children: [
              // Header with progress
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question ${_currentQuestion + 1}/${_questions.length}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                        ),
                        Text(
                          'Addition Skills',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.add, color: Colors.blue, size: screenWidth * 0.06),
                        SizedBox(width: screenWidth * 0.01),
                        Text(
                          '$_score',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              // Main question container
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(0, 0, 0, 0.15),
                      blurRadius: 8,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Question text
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      child: Text(
                        currentQuestion['question'] as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: _getQuestionFontSize(screenWidth),
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Question content based on type
                    if (currentQuestion['type'] == 'basic_addition' && currentQuestion.containsKey('leftObjects'))
                      _buildObjectAdditionQuestion(currentQuestion, screenWidth, screenHeight)
                    else if (currentQuestion['type'] == 'basic_addition' || 
                             currentQuestion['type'] == 'two_digit_addition' ||
                             currentQuestion['type'] == 'three_digit_addition')
                      _buildNumberAdditionQuestion(currentQuestion, screenWidth, screenHeight)
                    else if (currentQuestion['type'] == 'missing_addend')
                      _buildMissingAddendQuestion(currentQuestion, screenWidth, screenHeight)
                    else
                      _buildWordOrMoneyQuestion(currentQuestion, screenWidth, screenHeight),

                    SizedBox(height: screenHeight * 0.03),

                    // Input field for answer
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Column(
                        children: [
                          Text(
                            'Your Answer:',
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          Container(
                            height: screenHeight * 0.07,
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _answeredQuestions[_currentQuestion]
                                    ? (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer']
                                        ? Colors.green
                                        : Colors.red)
                                    : Colors.blue[300]!,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _textControllers[_currentQuestion],
                                    enabled: !_answeredQuestions[_currentQuestion],
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      fontSize: _getInputFontSize(screenWidth),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter sum',
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                    onChanged: (value) {
                                      // Optional: Real-time validation
                                    },
                                  ),
                                ),
                                if (!_answeredQuestions[_currentQuestion])
                                  Padding(
                                    padding: EdgeInsets.only(right: screenWidth * 0.03),
                                    child: IconButton(
                                      icon: Icon(Icons.check, color: Colors.blue, size: screenWidth * 0.06),
                                      onPressed: () {
                                        final answer = _textControllers[_currentQuestion].text;
                                        if (answer.isNotEmpty) {
                                          _answerQuestion(answer);
                                        }
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // Hint
                    if (!_answeredQuestions[_currentQuestion])
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        decoration: BoxDecoration(
                          color: Colors.amber[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.amber, width: 1),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.lightbulb_outline, color: Colors.amber[700], size: screenWidth * 0.05),
                            SizedBox(width: screenWidth * 0.02),
                            Expanded(
                              child: Text(
                                currentQuestion['hint'] as String,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.035,
                                  color: Colors.amber[900],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: screenHeight * 0.02),

                    // Explanation
                    if (_answeredQuestions[_currentQuestion])
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        decoration: BoxDecoration(
                          color: (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                              ? Colors.green[50]
                              : Colors.red[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                                ? Colors.green
                                : Colors.red,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                                      ? Icons.check_circle
                                      : Icons.error,
                                  color: (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                Text(
                                  (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                                      ? 'Correct!'
                                      : 'Incorrect',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.bold,
                                    color: (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                                        ? Colors.green[900]
                                        : Colors.red[900],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              currentQuestion['explanation'] as String,
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // Navigation buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: Size(0, screenHeight * 0.065),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.06),
                          side: const BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      onPressed: _currentQuestion > 0 ? _previousQuestion : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_back, size: screenWidth * 0.05),
                          SizedBox(width: screenWidth * 0.02),
                          Text(
                            'Previous',
                            style: TextStyle(fontSize: screenWidth * 0.04),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF59D),
                        foregroundColor: Colors.black,
                        minimumSize: Size(0, screenHeight * 0.065),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.06),
                          side: const BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      onPressed: _answeredQuestions[_currentQuestion]
                          ? () {
                              if (_currentQuestion < _questions.length - 1) {
                                _nextQuestion();
                              } else {
                                _recordExerciseResults();
                                setState(() {
                                  _exerciseCompleted = true;
                                });
                              }
                            }
                          : null,
                      child: Text(
                        _currentQuestion == _questions.length - 1
                            ? 'Finish Exercise'
                            : 'Next Question',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
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

  Widget _buildObjectAdditionQuestion(Map<String, dynamic> question, double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[300]!, width: 2),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    question['leftObjects'] as String,
                    style: TextStyle(
                      fontSize: screenWidth * 0.08,
                    ),
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.05),
              Container(
                padding: EdgeInsets.all(screenWidth * 0.02),
                child: Column(
                  children: [
                    Text(
                      '+',
                      style: TextStyle(
                        fontSize: screenWidth * 0.1,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      'plus',
                      style: TextStyle(
                        fontSize: screenWidth * 0.03,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: screenWidth * 0.05),
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[300]!, width: 2),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    question['rightObjects'] as String,
                    style: TextStyle(
                      fontSize: screenWidth * 0.08,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            'Combine both groups',
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberAdditionQuestion(Map<String, dynamic> question, double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[300]!, width: 2),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    question['leftValue'].toString(),
                    style: TextStyle(
                      fontSize: _getNumberFontSize(screenWidth),
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.05),
              Container(
                padding: EdgeInsets.all(screenWidth * 0.02),
                child: Column(
                  children: [
                    Text(
                      '+',
                      style: TextStyle(
                        fontSize: screenWidth * 0.1,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      'add',
                      style: TextStyle(
                        fontSize: screenWidth * 0.03,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: screenWidth * 0.05),
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[300]!, width: 2),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    question['rightValue'].toString(),
                    style: TextStyle(
                      fontSize: _getNumberFontSize(screenWidth),
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            'Calculate the sum',
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissingAddendQuestion(Map<String, dynamic> question, double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple, width: 2),
      ),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: screenWidth * 0.05,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '16',
                  style: TextStyle(
                    fontSize: _getNumberFontSize(screenWidth),
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[800],
                  ),
                ),
              ),
              Text(
                '+',
                style: TextStyle(
                  fontSize: screenWidth * 0.08,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[800],
                ),
              ),
              Container(
                width: screenWidth * 0.2,
                height: screenWidth * 0.2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.purple, width: 3),
                ),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '?',
                      style: TextStyle(
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[800],
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                '=',
                style: TextStyle(
                  fontSize: screenWidth * 0.08,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[800],
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '24',
                  style: TextStyle(
                    fontSize: _getNumberFontSize(screenWidth),
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[800],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            'Find the missing number',
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordOrMoneyQuestion(Map<String, dynamic> question, double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: question['type'] == 'money_addition' ? Colors.orange : Colors.green,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
            child: Column(
              children: [
                Text(
                  question['question'] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: _getQuestionFontSize(screenWidth),
                    color: question['type'] == 'money_addition' ? Colors.orange[800] : Colors.green[800],
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                if (question['type'] == 'money_addition')
                  SizedBox(height: screenHeight * 0.02),
                if (question['type'] == 'money_addition')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.attach_money, color: Colors.orange, size: screenWidth * 0.06),
                      SizedBox(width: screenWidth * 0.02),
                      Text(
                        'Money Addition',
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[800],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsScreen() {
    final percentage = (_score / _questions.length * 100).toInt();
    String resultText = '';
    String emoji = '';
    Color color = Colors.blue;

    if (percentage >= 90) {
      resultText = 'Excellent! Perfect Score!';
      emoji = '🏆';
      color = Colors.blue;
    } else if (percentage >= 80) {
      resultText = 'Great Job! You\'re Amazing!';
      emoji = '🎉';
      color = Colors.blue;
    } else if (percentage >= 70) {
      resultText = 'Good Work! Keep Going!';
      emoji = '👍';
      color = Colors.orange;
    } else if (percentage >= 60) {
      resultText = 'Not Bad! Practice More!';
      emoji = '💪';
      color = Colors.orange;
    } else {
      resultText = 'Keep Practicing! You Can Do It!';
      emoji = '📚';
      color = Colors.red;
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Exercise Results',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  emoji,
                  style: TextStyle(fontSize: screenWidth * 0.2),
                ),
                SizedBox(height: screenHeight * 0.02),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(screenWidth * 0.06),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(0, 0, 0, 0.2),
                        blurRadius: 8,
                        offset: const Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        resultText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.065,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_circle, color: Colors.green, size: screenWidth * 0.1),
                          SizedBox(width: screenWidth * 0.03),
                          Text(
                            '$_score/${_questions.length}',
                            style: TextStyle(
                              fontSize: screenWidth * 0.09,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF6B8E6B),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      Text(
                        '$percentage% Correct',
                        style: TextStyle(fontSize: screenWidth * 0.05),
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: screenHeight * 0.065,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFF59D),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.06),
                                  side: const BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                              onPressed: _restartExercise,
                              child: Text(
                                'Try Again',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          SizedBox(
                            width: double.infinity,
                            height: screenHeight * 0.065,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.06),
                                  side: const BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Back to Lessons',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class SubtractionExerciseScreen extends StatefulWidget {
  final String lessonName;
  final String language;
  final int subLessonIndex;

  const SubtractionExerciseScreen({
    super.key,
    required this.lessonName,
    required this.language,
    required this.subLessonIndex,
  });

  @override
  State<SubtractionExerciseScreen> createState() => _SubtractionExerciseScreenState();
}

class _SubtractionExerciseScreenState extends State<SubtractionExerciseScreen> {
  int _currentQuestion = 0;
  int _score = 0;
  bool _exerciseCompleted = false;
  List<String?> _userAnswers = List.filled(10, null);
  List<bool> _answeredQuestions = List.filled(10, false);
  List<TextEditingController> _textControllers = List.generate(10, (_) => TextEditingController());

  final List<Map<String, dynamic>> _questions = [
    {
      'type': 'basic_subtraction',
      'question': 'Subtract using objects:',
      'totalObjects': '🍎🍎🍎🍎🍎',
      'removeObjects': '🍎🍎',
      'remainingObjects': '🍎🍎🍎',
      'correctAnswer': '3',
      'explanation': '5 apples - 2 apples = 3 apples remaining',
      'hint': 'Start with 5 apples, take away 2',
    },
    {
      'type': 'basic_subtraction',
      'question': 'Find the difference:',
      'minuend': 12,
      'subtrahend': 5,
      'correctAnswer': '7',
      'explanation': '12 - 5 = 7',
      'hint': 'Start from 12, count backward 5: 11, 10, 9, 8, 7',
    },
    {
      'type': 'basic_subtraction',
      'question': 'Subtract the numbers:',
      'minuend': 15,
      'subtrahend': 9,
      'correctAnswer': '6',
      'explanation': '15 - 9 = 6\nYou can also think: 9 + 6 = 15',
      'hint': 'Think what number added to 9 makes 15',
    },
    {
      'type': 'two_digit_subtraction',
      'question': 'Subtract two-digit numbers:',
      'minuend': 37,
      'subtrahend': 14,
      'correctAnswer': '23',
      'explanation': '37 - 14 = 23\nSubtract ones: 7 - 4 = 3\nSubtract tens: 30 - 10 = 20\nTotal: 20 + 3 = 23',
      'hint': 'Subtract the ones place first, then the tens place',
    },
    {
      'type': 'two_digit_subtraction_regrouping',
      'question': 'Subtract with regrouping:',
      'minuend': 52,
      'subtrahend': 27,
      'correctAnswer': '25',
      'explanation': '52 - 27 = 25\n2 - 7 (cannot), borrow from tens\n12 - 7 = 5\n40 - 20 = 20\nTotal: 20 + 5 = 25',
      'hint': 'Borrow 1 from tens if ones digit is smaller',
    },
    {
      'type': 'word_problem_take_away',
      'question': 'Maria had 18 cookies. She ate 7 cookies. How many cookies are left?',
      'correctAnswer': '11',
      'explanation': '18 - 7 = 11\nMaria has 11 cookies left.',
      'hint': 'Start with 18, take away 7',
    },
    {
      'type': 'word_problem_comparison',
      'question': 'Class A has 35 students. Class B has 28 students. How many more students does Class A have?',
      'correctAnswer': '7',
      'explanation': '35 - 28 = 7\nClass A has 7 more students than Class B.',
      'hint': 'Find the difference between 35 and 28',
    },
    {
      'type': 'money_subtraction',
      'question': 'Juan had ₱120. He spent ₱45 on a book. How much money does he have left?',
      'correctAnswer': '75',
      'explanation': '₱120 - ₱45 = ₱75\nJuan has ₱75 left.',
      'hint': 'Subtract 45 from 120',
    },
    {
      'type': 'three_digit_subtraction',
      'question': 'Subtract three-digit numbers:',
      'minuend': 425,
      'subtrahend': 187,
      'correctAnswer': '238',
      'explanation': '425 - 187 = 238\nBorrow from tens and hundreds\n15 - 7 = 8\n110 - 80 = 30\n300 - 100 = 200\nTotal: 200 + 30 + 8 = 238',
      'hint': 'Borrow from next column when needed',
    },
    {
      'type': 'inverse_operation',
      'question': 'If 24 + 16 = 40, then 40 - 16 = ?',
      'correctAnswer': '24',
      'explanation': '40 - 16 = 24\nSubtraction is the inverse of addition.',
      'hint': 'Addition and subtraction undo each other',
    },
  ];

  @override
  void dispose() {
    for (var controller in _textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _answerQuestion(String answer) {
    if (!_answeredQuestions[_currentQuestion]) {
      setState(() {
        _answeredQuestions[_currentQuestion] = true;
        _userAnswers[_currentQuestion] = answer;

        final question = _questions[_currentQuestion];
        final correctAnswer = question['correctAnswer'] as String;
        final isCorrect = answer.trim() == correctAnswer;

        if (isCorrect) {
          _score++;
        }
        
        if (_answeredQuestions.every((answered) => answered)) {
          _exerciseCompleted = true;
          _recordExerciseResults();
        }
      });
    }
  }

  void _recordExerciseResults() {
    final percentage = (_score / _questions.length * 100).toInt();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 Exercise completed! Score: $percentage%'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _nextQuestion() {
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestion > 0) {
      setState(() {
        _currentQuestion--;
      });
    }
  }

  void _restartExercise() {
    setState(() {
      _currentQuestion = 0;
      _score = 0;
      _exerciseCompleted = false;
      _userAnswers = List.filled(_questions.length, null);
      _answeredQuestions = List.filled(_questions.length, false);
      for (var controller in _textControllers) {
        controller.clear();
      }
    });
  }

  // Helper methods for responsive design
  double _getQuestionFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.042;
    if (screenWidth > 600) return screenWidth * 0.038;
    return screenWidth * 0.045;
  }

  double _getNumberFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.09;
    if (screenWidth > 600) return screenWidth * 0.07;
    return screenWidth * 0.11;
  }

  double _getInputFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.05;
    if (screenWidth > 600) return screenWidth * 0.045;
    return screenWidth * 0.06;
  }

  @override
  Widget build(BuildContext context) {
    if (_exerciseCompleted) {
      return _buildResultsScreen();
    }

    final currentQuestion = _questions[_currentQuestion];
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red[50],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Subtraction Exercise',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            children: [
              // Header with progress
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question ${_currentQuestion + 1}/${_questions.length}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[900],
                          ),
                        ),
                        Text(
                          'Subtraction Skills',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Colors.red[700],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.remove, color: Colors.red, size: screenWidth * 0.06),
                        SizedBox(width: screenWidth * 0.01),
                        Text(
                          '$_score',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[800],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              // Main question container
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(0, 0, 0, 0.15),
                      blurRadius: 8,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Question text
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      child: Text(
                        currentQuestion['question'] as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: _getQuestionFontSize(screenWidth),
                          fontWeight: FontWeight.bold,
                          color: Colors.red[900],
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Question content based on type
                    if (currentQuestion['type'] == 'basic_subtraction' && currentQuestion.containsKey('totalObjects'))
                      _buildObjectSubtractionQuestion(currentQuestion, screenWidth, screenHeight)
                    else if (currentQuestion['type'] == 'basic_subtraction' || 
                             currentQuestion['type'] == 'two_digit_subtraction' ||
                             currentQuestion['type'] == 'two_digit_subtraction_regrouping' ||
                             currentQuestion['type'] == 'three_digit_subtraction')
                      _buildNumberSubtractionQuestion(currentQuestion, screenWidth, screenHeight)
                    else if (currentQuestion['type'] == 'inverse_operation')
                      _buildInverseOperationQuestion(currentQuestion, screenWidth, screenHeight)
                    else
                      _buildWordOrMoneyQuestion(currentQuestion, screenWidth, screenHeight),

                    SizedBox(height: screenHeight * 0.03),

                    // Input field for answer
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Column(
                        children: [
                          Text(
                            'Your Answer:',
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          Container(
                            height: screenHeight * 0.07,
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _answeredQuestions[_currentQuestion]
                                    ? (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer']
                                        ? Colors.green
                                        : Colors.red)
                                    : Colors.red[300]!,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _textControllers[_currentQuestion],
                                    enabled: !_answeredQuestions[_currentQuestion],
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      fontSize: _getInputFontSize(screenWidth),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter difference',
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                                if (!_answeredQuestions[_currentQuestion])
                                  Padding(
                                    padding: EdgeInsets.only(right: screenWidth * 0.03),
                                    child: IconButton(
                                      icon: Icon(Icons.check, color: Colors.red, size: screenWidth * 0.06),
                                      onPressed: () {
                                        final answer = _textControllers[_currentQuestion].text;
                                        if (answer.isNotEmpty) {
                                          _answerQuestion(answer);
                                        }
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // Hint
                    if (!_answeredQuestions[_currentQuestion])
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        decoration: BoxDecoration(
                          color: Colors.amber[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.amber, width: 1),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.lightbulb_outline, color: Colors.amber[700], size: screenWidth * 0.05),
                            SizedBox(width: screenWidth * 0.02),
                            Expanded(
                              child: Text(
                                currentQuestion['hint'] as String,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.035,
                                  color: Colors.amber[900],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: screenHeight * 0.02),

                    // Explanation
                    if (_answeredQuestions[_currentQuestion])
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        decoration: BoxDecoration(
                          color: (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                              ? Colors.green[50]
                              : Colors.red[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                                ? Colors.green
                                : Colors.red,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                                      ? Icons.check_circle
                                      : Icons.error,
                                  color: (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                Text(
                                  (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                                      ? 'Correct!'
                                      : 'Incorrect',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.bold,
                                    color: (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                                        ? Colors.green[900]
                                        : Colors.red[900],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              currentQuestion['explanation'] as String,
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                color: Colors.grey[800],
                              ),
                            ),
                            if (currentQuestion['type'] == 'two_digit_subtraction_regrouping' || 
                                currentQuestion['type'] == 'three_digit_subtraction')
                              SizedBox(height: screenHeight * 0.01),
                            if (currentQuestion['type'] == 'two_digit_subtraction_regrouping')
                              _buildRegroupingVisual(currentQuestion, screenWidth),
                            if (currentQuestion['type'] == 'three_digit_subtraction')
                              _buildThreeDigitRegroupingVisual(currentQuestion, screenWidth),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // Navigation buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: Size(0, screenHeight * 0.065),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.06),
                          side: const BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      onPressed: _currentQuestion > 0 ? _previousQuestion : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_back, size: screenWidth * 0.05),
                          SizedBox(width: screenWidth * 0.02),
                          Text(
                            'Previous',
                            style: TextStyle(fontSize: screenWidth * 0.04),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF59D),
                        foregroundColor: Colors.black,
                        minimumSize: Size(0, screenHeight * 0.065),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.06),
                          side: const BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      onPressed: _answeredQuestions[_currentQuestion]
                          ? () {
                              if (_currentQuestion < _questions.length - 1) {
                                _nextQuestion();
                              } else {
                                _recordExerciseResults();
                                setState(() {
                                  _exerciseCompleted = true;
                                });
                              }
                            }
                          : null,
                      child: Text(
                        _currentQuestion == _questions.length - 1
                            ? 'Finish Exercise'
                            : 'Next Question',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
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

  Widget _buildObjectSubtractionQuestion(Map<String, dynamic> question, double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange, width: 2),
      ),
      child: Column(
        children: [
          // Total objects
          Column(
            children: [
              Text(
                'Start with:',
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  color: Colors.orange[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange[300]!, width: 2),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    question['totalObjects'] as String,
                    style: TextStyle(
                      fontSize: screenWidth * 0.08,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: screenHeight * 0.02),

          // Minus symbol
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(screenWidth * 0.02),
                child: Column(
                  children: [
                    Icon(
                      Icons.remove,
                      size: screenWidth * 0.08,
                      color: Colors.red,
                    ),
                    SizedBox(height: screenHeight * 0.005),
                    Text(
                      'take away',
                      style: TextStyle(
                        fontSize: screenWidth * 0.03,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: screenWidth * 0.05),
              Column(
                children: [
                  Text(
                    'Remove:',
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: Colors.red[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Container(
                    padding: EdgeInsets.all(screenWidth * 0.03),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red[300]!, width: 2),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        question['removeObjects'] as String,
                        style: TextStyle(
                          fontSize: screenWidth * 0.08,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: screenHeight * 0.02),

          // Result
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_downward,
                size: screenWidth * 0.06,
                color: Colors.green,
              ),
              SizedBox(width: screenWidth * 0.03),
              Text(
                'Left:',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.green[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              Container(
                padding: EdgeInsets.all(screenWidth * 0.03),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[300]!, width: 2),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    question['remainingObjects'] as String,
                    style: TextStyle(
                      fontSize: screenWidth * 0.08,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumberSubtractionQuestion(Map<String, dynamic> question, double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red, width: 2),
      ),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red[300]!, width: 2),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    question['minuend'].toString(),
                    style: TextStyle(
                      fontSize: _getNumberFontSize(screenWidth),
                      fontWeight: FontWeight.bold,
                      color: Colors.red[800],
                    ),
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.05),
              Container(
                padding: EdgeInsets.all(screenWidth * 0.02),
                child: Column(
                  children: [
                    Icon(
                      Icons.remove,
                      size: screenWidth * 0.08,
                      color: Colors.red,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      'minus',
                      style: TextStyle(
                        fontSize: screenWidth * 0.03,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: screenWidth * 0.05),
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red[300]!, width: 2),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    question['subtrahend'].toString(),
                    style: TextStyle(
                      fontSize: _getNumberFontSize(screenWidth),
                      fontWeight: FontWeight.bold,
                      color: Colors.red[800],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            'Find the difference',
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: Colors.grey[600],
            ),
          ),
          if (question['type'] == 'two_digit_subtraction_regrouping')
            SizedBox(height: screenHeight * 0.01),
          if (question['type'] == 'two_digit_subtraction_regrouping')
            Text(
              '(with regrouping)',
              style: TextStyle(
                fontSize: screenWidth * 0.03,
                color: Colors.orange[800],
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInverseOperationQuestion(Map<String, dynamic> question, double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple, width: 2),
      ),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '24',
                    style: TextStyle(
                      fontSize: _getNumberFontSize(screenWidth) * 0.8,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Icon(Icons.add, size: screenWidth * 0.06, color: Colors.blue),
                  SizedBox(width: screenWidth * 0.03),
                  Text(
                    '16',
                    style: TextStyle(
                      fontSize: _getNumberFontSize(screenWidth) * 0.8,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Text(
                    '=',
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Text(
                    '40',
                    style: TextStyle(
                      fontSize: _getNumberFontSize(screenWidth) * 0.8,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                'So,',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '40',
                    style: TextStyle(
                      fontSize: _getNumberFontSize(screenWidth) * 0.8,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple[800],
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Icon(Icons.remove, size: screenWidth * 0.06, color: Colors.purple),
                  SizedBox(width: screenWidth * 0.03),
                  Text(
                    '16',
                    style: TextStyle(
                      fontSize: _getNumberFontSize(screenWidth) * 0.8,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple[800],
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Text(
                    '=',
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Container(
                    width: screenWidth * 0.15,
                    height: screenWidth * 0.15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.purple, width: 2),
                    ),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '?',
                          style: TextStyle(
                            fontSize: screenWidth * 0.08,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[800],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            'Addition and subtraction are inverse operations',
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordOrMoneyQuestion(Map<String, dynamic> question, double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: question['type'] == 'money_subtraction' ? Colors.orange : Colors.green,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
            child: Column(
              children: [
                Text(
                  question['question'] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: _getQuestionFontSize(screenWidth),
                    color: question['type'] == 'money_subtraction' ? Colors.orange[800] : Colors.green[800],
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                if (question['type'] == 'money_subtraction')
                  SizedBox(height: screenHeight * 0.02),
                if (question['type'] == 'money_subtraction')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.attach_money, color: Colors.orange, size: screenWidth * 0.06),
                      SizedBox(width: screenWidth * 0.02),
                      Text(
                        'Money Subtraction',
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[800],
                        ),
                      ),
                    ],
                  ),
                if (question['type'] == 'word_problem_comparison')
                  SizedBox(height: screenHeight * 0.02),
                if (question['type'] == 'word_problem_comparison')
                  Text(
                    '(Comparison Problem)',
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: Colors.blue[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegroupingVisual(Map<String, dynamic> question, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenWidth * 0.02),
        Text(
          'Regrouping Steps:',
          style: TextStyle(
            fontSize: screenWidth * 0.035,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        SizedBox(height: screenWidth * 0.01),
        Row(
          children: [
            Text(
              '5\t2',
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
                color: Colors.red[800],
              ),
            ),
            SizedBox(width: screenWidth * 0.02),
            Icon(Icons.remove, size: screenWidth * 0.04, color: Colors.red),
            SizedBox(width: screenWidth * 0.02),
            Text(
              '2\t7',
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
                color: Colors.red[800],
              ),
            ),
          ],
        ),
        SizedBox(height: screenWidth * 0.005),
        Container(
          height: 1,
          color: Colors.black,
          width: screenWidth * 0.2,
        ),
        SizedBox(height: screenWidth * 0.01),
        Row(
          children: [
            Text(
              '4\t12',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            SizedBox(width: screenWidth * 0.05),
            Icon(Icons.remove, size: screenWidth * 0.04, color: Colors.red),
            SizedBox(width: screenWidth * 0.05),
            Text(
              '2\t7',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.bold,
                color: Colors.red[800],
              ),
            ),
          ],
        ),
        SizedBox(height: screenWidth * 0.005),
        Container(
          height: 1,
          color: Colors.black,
          width: screenWidth * 0.2,
        ),
        SizedBox(height: screenWidth * 0.01),
        Row(
          children: [
            Text(
              '2\t5',
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildThreeDigitRegroupingVisual(Map<String, dynamic> question, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenWidth * 0.02),
        Text(
          'Regrouping Steps:',
          style: TextStyle(
            fontSize: screenWidth * 0.035,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        SizedBox(height: screenWidth * 0.01),
        Row(
          children: [
            Text(
              '4\t2\t5',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.bold,
                color: Colors.red[800],
              ),
            ),
            SizedBox(width: screenWidth * 0.02),
            Icon(Icons.remove, size: screenWidth * 0.04, color: Colors.red),
            SizedBox(width: screenWidth * 0.02),
            Text(
              '1\t8\t7',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.bold,
                color: Colors.red[800],
              ),
            ),
          ],
        ),
        SizedBox(height: screenWidth * 0.005),
        Container(
          height: 1,
          color: Colors.black,
          width: screenWidth * 0.3,
        ),
        SizedBox(height: screenWidth * 0.01),
        Row(
          children: [
            Text(
              '3\t11\t15',
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            SizedBox(width: screenWidth * 0.05),
            Icon(Icons.remove, size: screenWidth * 0.04, color: Colors.red),
            SizedBox(width: screenWidth * 0.05),
            Text(
              '1\t8\t7',
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.bold,
                color: Colors.red[800],
              ),
            ),
          ],
        ),
        SizedBox(height: screenWidth * 0.005),
        Container(
          height: 1,
          color: Colors.black,
          width: screenWidth * 0.3,
        ),
        SizedBox(height: screenWidth * 0.01),
        Row(
          children: [
            Text(
              '2\t3\t8',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResultsScreen() {
    final percentage = (_score / _questions.length * 100).toInt();
    String resultText = '';
    String emoji = '';
    Color color = Colors.red;

    if (percentage >= 90) {
      resultText = 'Excellent! Perfect Score!';
      emoji = '🏆';
      color = Colors.red;
    } else if (percentage >= 80) {
      resultText = 'Great Job! You\'re Amazing!';
      emoji = '🎉';
      color = Colors.red;
    } else if (percentage >= 70) {
      resultText = 'Good Work! Keep Going!';
      emoji = '👍';
      color = Colors.orange;
    } else if (percentage >= 60) {
      resultText = 'Not Bad! Practice More!';
      emoji = '💪';
      color = Colors.orange;
    } else {
      resultText = 'Keep Practicing! You Can Do It!';
      emoji = '📚';
      color = Colors.red[800]!;
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Exercise Results',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  emoji,
                  style: TextStyle(fontSize: screenWidth * 0.2),
                ),
                SizedBox(height: screenHeight * 0.02),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(screenWidth * 0.06),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(0, 0, 0, 0.2),
                        blurRadius: 8,
                        offset: const Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        resultText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.065,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.remove_circle, color: Colors.green, size: screenWidth * 0.1),
                          SizedBox(width: screenWidth * 0.03),
                          Text(
                            '$_score/${_questions.length}',
                            style: TextStyle(
                              fontSize: screenWidth * 0.09,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF6B8E6B),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      Text(
                        '$percentage% Correct',
                        style: TextStyle(fontSize: screenWidth * 0.05),
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: screenHeight * 0.065,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFF59D),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.06),
                                  side: const BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                              onPressed: _restartExercise,
                              child: Text(
                                'Try Again',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          SizedBox(
                            width: double.infinity,
                            height: screenHeight * 0.065,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.06),
                                  side: const BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Back to Lessons',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class MultiplicationExerciseScreen extends StatefulWidget {
  final String lessonName;
  final String language;
  final int subLessonIndex;

  const MultiplicationExerciseScreen({
    super.key,
    required this.lessonName,
    required this.language,
    required this.subLessonIndex,
  });

  @override
  State<MultiplicationExerciseScreen> createState() => _MultiplicationExerciseScreenState();
}

class _MultiplicationExerciseScreenState extends State<MultiplicationExerciseScreen> {
  int _currentQuestion = 0;
  int _score = 0;
  bool _exerciseCompleted = false;
  List<String?> _userAnswers = List.filled(10, null);
  List<bool> _answeredQuestions = List.filled(10, false);
  List<TextEditingController> _textControllers = List.generate(10, (_) => TextEditingController());

  final List<Map<String, dynamic>> _questions = [
    {
      'type': 'repeated_addition',
      'question': 'Multiply using repeated addition:',
      'groups': 3,
      'itemsPerGroup': 4,
      'items': '🍎🍎🍎🍎 🍎🍎🍎🍎 🍎🍎🍎🍎',
      'correctAnswer': '12',
      'explanation': '3 groups × 4 apples each = 12 apples\n4 + 4 + 4 = 12',
      'hint': 'Add 4 three times: 4 + 4 + 4',
    },
    {
      'type': 'repeated_addition',
      'question': 'What is 5 × 3 as repeated addition?',
      'groups': 5,
      'itemsPerGroup': 3,
      'correctAnswer': '15',
      'explanation': '5 × 3 = 15\n3 + 3 + 3 + 3 + 3 = 15',
      'hint': 'Add 3 five times',
    },
    {
      'type': 'basic_multiplication',
      'question': 'Multiply the numbers:',
      'multiplier': 6,
      'multiplicand': 7,
      'correctAnswer': '42',
      'explanation': '6 × 7 = 42',
      'hint': 'Think: 6 groups of 7',
    },
    {
      'type': 'basic_multiplication',
      'question': 'Find the product:',
      'multiplier': 8,
      'multiplicand': 9,
      'correctAnswer': '72',
      'explanation': '8 × 9 = 72',
      'hint': 'Use multiplication table for 8 and 9',
    },
    {
      'type': 'two_digit_multiplication',
      'question': 'Multiply two-digit numbers:',
      'multiplier': 12,
      'multiplicand': 4,
      'correctAnswer': '48',
      'explanation': '12 × 4 = 48\n10 × 4 = 40\n2 × 4 = 8\n40 + 8 = 48',
      'hint': 'Break 12 into 10 and 2, multiply separately, then add',
    },
    {
      'type': 'two_digit_multiplication',
      'question': 'Calculate: 15 × 6',
      'multiplier': 15,
      'multiplicand': 6,
      'correctAnswer': '90',
      'explanation': '15 × 6 = 90\n10 × 6 = 60\n5 × 6 = 30\n60 + 30 = 90',
      'hint': 'Break 15 into 10 and 5',
    },
    {
      'type': 'word_problem',
      'question': 'A classroom has 4 rows of desks. Each row has 8 desks. How many desks are there in total?',
      'correctAnswer': '32',
      'explanation': '4 rows × 8 desks each = 32 desks\n4 × 8 = 32',
      'hint': 'Multiply rows by desks per row',
    },
    {
      'type': 'money_multiplication',
      'question': 'One pencil costs ₱15. How much do 7 pencils cost?',
      'correctAnswer': '105',
      'explanation': '₱15 × 7 = ₱105\n7 pencils cost ₱105.',
      'hint': 'Multiply price by quantity',
    },
    {
      'type': 'properties_multiplication',
      'question': 'Which property is shown: 5 × 3 = 3 × 5',
      'options': ['Commutative', 'Associative', 'Identity', 'Zero'],
      'correctAnswer': '0',
      'explanation': 'Commutative Property: Changing order doesn\'t change product.',
      'hint': 'Think about changing the order of numbers',
    },
    {
      'type': 'properties_multiplication',
      'question': 'What is 9 × 1?',
      'correctAnswer': '9',
      'explanation': 'Identity Property: Any number × 1 = itself\n9 × 1 = 9',
      'hint': 'What happens when you multiply any number by 1?',
    },
  ];

  @override
  void dispose() {
    for (var controller in _textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _answerQuestion(String answer) {
    if (!_answeredQuestions[_currentQuestion]) {
      setState(() {
        _answeredQuestions[_currentQuestion] = true;
        _userAnswers[_currentQuestion] = answer;

        final question = _questions[_currentQuestion];
        final correctAnswer = question['correctAnswer'] as String;
        final isCorrect = answer.trim() == correctAnswer;

        if (isCorrect) {
          _score++;
        }
        
        if (_answeredQuestions.every((answered) => answered)) {
          _exerciseCompleted = true;
          _recordExerciseResults();
        }
      });
    }
  }

  void _answerPropertyQuestion(int answerIndex) {
    if (!_answeredQuestions[_currentQuestion]) {
      setState(() {
        _answeredQuestions[_currentQuestion] = true;
        _userAnswers[_currentQuestion] = answerIndex.toString();

        final question = _questions[_currentQuestion];
        final correctAnswer = int.parse(question['correctAnswer'] as String);
        final isCorrect = answerIndex == correctAnswer;

        if (isCorrect) {
          _score++;
        }
        
        if (_answeredQuestions.every((answered) => answered)) {
          _exerciseCompleted = true;
          _recordExerciseResults();
        }
      });
    }
  }

  void _recordExerciseResults() {
    final percentage = (_score / _questions.length * 100).toInt();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 Exercise completed! Score: $percentage%'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _nextQuestion() {
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestion > 0) {
      setState(() {
        _currentQuestion--;
      });
    }
  }

  void _restartExercise() {
    setState(() {
      _currentQuestion = 0;
      _score = 0;
      _exerciseCompleted = false;
      _userAnswers = List.filled(_questions.length, null);
      _answeredQuestions = List.filled(_questions.length, false);
      for (var controller in _textControllers) {
        controller.clear();
      }
    });
  }

  // Helper methods for responsive design
  double _getQuestionFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.042;
    if (screenWidth > 600) return screenWidth * 0.038;
    return screenWidth * 0.045;
  }

  double _getNumberFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.09;
    if (screenWidth > 600) return screenWidth * 0.07;
    return screenWidth * 0.11;
  }

  double _getInputFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.05;
    if (screenWidth > 600) return screenWidth * 0.045;
    return screenWidth * 0.06;
  }

  double _getOptionFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.036;
    if (screenWidth > 600) return screenWidth * 0.032;
    return screenWidth * 0.04;
  }

  @override
  Widget build(BuildContext context) {
    if (_exerciseCompleted) {
      return _buildResultsScreen();
    }

    final currentQuestion = _questions[_currentQuestion];
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green[50],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Multiplication Exercise',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            children: [
              // Header with progress
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question ${_currentQuestion + 1}/${_questions.length}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[900],
                          ),
                        ),
                        Text(
                          'Multiplication Skills',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.close, color: Colors.green, size: screenWidth * 0.06),
                        SizedBox(width: screenWidth * 0.01),
                        Text(
                          '$_score',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              // Main question container
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(0, 0, 0, 0.15),
                      blurRadius: 8,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Question text
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      child: Text(
                        currentQuestion['question'] as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: _getQuestionFontSize(screenWidth),
                          fontWeight: FontWeight.bold,
                          color: Colors.green[900],
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Question content based on type
                    if (currentQuestion['type'] == 'repeated_addition' && currentQuestion.containsKey('items'))
                      _buildRepeatedAdditionWithObjects(currentQuestion, screenWidth, screenHeight)
                    else if (currentQuestion['type'] == 'repeated_addition')
                      _buildRepeatedAdditionQuestion(currentQuestion, screenWidth, screenHeight)
                    else if (currentQuestion['type'] == 'basic_multiplication' || 
                             currentQuestion['type'] == 'two_digit_multiplication')
                      _buildMultiplicationQuestion(currentQuestion, screenWidth, screenHeight)
                    else if (currentQuestion['type'] == 'properties_multiplication' && currentQuestion.containsKey('options'))
                      _buildPropertyQuestion(currentQuestion, screenWidth, screenHeight)
                    else
                      _buildWordOrMoneyQuestion(currentQuestion, screenWidth, screenHeight),

                    SizedBox(height: screenHeight * 0.03),

                    // Input field for answer (for non-property questions)
                    if (currentQuestion['type'] != 'properties_multiplication' || 
                        !currentQuestion.containsKey('options'))
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                        child: Column(
                          children: [
                            Text(
                              'Your Answer:',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.015),
                            Container(
                              height: screenHeight * 0.07,
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _answeredQuestions[_currentQuestion]
                                      ? (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer']
                                          ? Colors.green
                                          : Colors.red)
                                      : Colors.green[300]!,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _textControllers[_currentQuestion],
                                      enabled: !_answeredQuestions[_currentQuestion],
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                        fontSize: _getInputFontSize(screenWidth),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Enter product',
                                        hintStyle: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  if (!_answeredQuestions[_currentQuestion])
                                    Padding(
                                      padding: EdgeInsets.only(right: screenWidth * 0.03),
                                      child: IconButton(
                                        icon: Icon(Icons.check, color: Colors.green, size: screenWidth * 0.06),
                                        onPressed: () {
                                          final answer = _textControllers[_currentQuestion].text;
                                          if (answer.isNotEmpty) {
                                            _answerQuestion(answer);
                                          }
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Options for property questions
                    if (currentQuestion['type'] == 'properties_multiplication' && 
                        currentQuestion.containsKey('options'))
                      Column(
                        children: List.generate(
                          (currentQuestion['options'] as List<String>).length,
                          (index) => _buildTextOptionButton(
                            index, 
                            currentQuestion['options'][index] as String
                          ),
                        ),
                      ),

                    SizedBox(height: screenHeight * 0.02),

                    // Hint
                    if (!_answeredQuestions[_currentQuestion])
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        decoration: BoxDecoration(
                          color: Colors.amber[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.amber, width: 1),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.lightbulb_outline, color: Colors.amber[700], size: screenWidth * 0.05),
                            SizedBox(width: screenWidth * 0.02),
                            Expanded(
                              child: Text(
                                currentQuestion['hint'] as String,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.035,
                                  color: Colors.amber[900],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: screenHeight * 0.02),

                    // Explanation
                    if (_answeredQuestions[_currentQuestion])
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        decoration: BoxDecoration(
                          color: (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                              ? Colors.green[50]
                              : Colors.red[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                                ? Colors.green
                                : Colors.red,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                                      ? Icons.check_circle
                                      : Icons.error,
                                  color: (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                Text(
                                  (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                                      ? 'Correct!'
                                      : 'Incorrect',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.bold,
                                    color: (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                                        ? Colors.green[900]
                                        : Colors.red[900],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              currentQuestion['explanation'] as String,
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                color: Colors.grey[800],
                              ),
                            ),
                            if (currentQuestion['type'] == 'repeated_addition')
                              SizedBox(height: screenHeight * 0.01),
                            if (currentQuestion['type'] == 'repeated_addition')
                              _buildRepeatedAdditionVisual(currentQuestion, screenWidth),
                            if (currentQuestion['type'] == 'two_digit_multiplication')
                              SizedBox(height: screenHeight * 0.01),
                            if (currentQuestion['type'] == 'two_digit_multiplication')
                              _buildBreakdownVisual(currentQuestion, screenWidth),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // Navigation buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: Size(0, screenHeight * 0.065),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.06),
                          side: const BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      onPressed: _currentQuestion > 0 ? _previousQuestion : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_back, size: screenWidth * 0.05),
                          SizedBox(width: screenWidth * 0.02),
                          Text(
                            'Previous',
                            style: TextStyle(fontSize: screenWidth * 0.04),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF59D),
                        foregroundColor: Colors.black,
                        minimumSize: Size(0, screenHeight * 0.065),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.06),
                          side: const BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      onPressed: _answeredQuestions[_currentQuestion]
                          ? () {
                              if (_currentQuestion < _questions.length - 1) {
                                _nextQuestion();
                              } else {
                                _recordExerciseResults();
                                setState(() {
                                  _exerciseCompleted = true;
                                });
                              }
                            }
                          : null,
                      child: Text(
                        _currentQuestion == _questions.length - 1
                            ? 'Finish Exercise'
                            : 'Next Question',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
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

  Widget _buildRepeatedAdditionWithObjects(Map<String, dynamic> question, double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange, width: 2),
      ),
      child: Column(
        children: [
          Text(
            '${question['groups']} groups × ${question['itemsPerGroup']} items each',
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.bold,
              color: Colors.orange[800],
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          
          // Display groups
          Wrap(
            spacing: screenWidth * 0.04,
            runSpacing: screenHeight * 0.02,
            children: List.generate(
              question['groups'] as int,
              (index) => Container(
                padding: EdgeInsets.all(screenWidth * 0.03),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange[300]!, width: 2),
                ),
                child: Column(
                  children: [
                    Text(
                      'Group ${index + 1}',
                      style: TextStyle(
                        fontSize: screenWidth * 0.03,
                        color: Colors.orange[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.005),
                    Text(
                      '🍎' * (question['itemsPerGroup'] as int),
                      style: TextStyle(fontSize: screenWidth * 0.05),
                    ),
                    Text(
                      '(${question['itemsPerGroup']} apples)',
                      style: TextStyle(
                        fontSize: screenWidth * 0.025,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          SizedBox(height: screenHeight * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: Colors.green, size: screenWidth * 0.05),
              SizedBox(width: screenWidth * 0.02),
              Text(
                '${question['itemsPerGroup']} + ${question['itemsPerGroup']} + ${question['itemsPerGroup']}',
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              Icon(Icons.arrow_forward, color: Colors.green, size: screenWidth * 0.05),
              SizedBox(width: screenWidth * 0.02),
              Text(
                '${question['groups']} × ${question['itemsPerGroup']}',
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRepeatedAdditionQuestion(Map<String, dynamic> question, double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[300]!, width: 2),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${question['groups']}',
                    style: TextStyle(
                      fontSize: _getNumberFontSize(screenWidth),
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.05),
              Container(
                padding: EdgeInsets.all(screenWidth * 0.02),
                child: Column(
                  children: [
                    Icon(
                      Icons.close,
                      size: screenWidth * 0.08,
                      color: Colors.blue,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      'times',
                      style: TextStyle(
                        fontSize: screenWidth * 0.03,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: screenWidth * 0.05),
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[300]!, width: 2),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${question['itemsPerGroup']}',
                    style: TextStyle(
                      fontSize: _getNumberFontSize(screenWidth),
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            'Repeated addition: ${question['itemsPerGroup']} + ${question['itemsPerGroup']} + ... (${question['groups']} times)',
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultiplicationQuestion(Map<String, dynamic> question, double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[300]!, width: 2),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    question['multiplier'].toString(),
                    style: TextStyle(
                      fontSize: _getNumberFontSize(screenWidth),
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.05),
              Container(
                padding: EdgeInsets.all(screenWidth * 0.02),
                child: Column(
                  children: [
                    Icon(
                      Icons.close,
                      size: screenWidth * 0.08,
                      color: Colors.green,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      'multiplied by',
                      style: TextStyle(
                        fontSize: screenWidth * 0.03,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: screenWidth * 0.05),
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[300]!, width: 2),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    question['multiplicand'].toString(),
                    style: TextStyle(
                      fontSize: _getNumberFontSize(screenWidth),
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            'Find the product',
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: Colors.grey[600],
            ),
          ),
          if (question['type'] == 'two_digit_multiplication')
            SizedBox(height: screenHeight * 0.01),
          if (question['type'] == 'two_digit_multiplication')
            Text(
              '(Break it down)',
              style: TextStyle(
                fontSize: screenWidth * 0.03,
                color: Colors.orange[800],
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPropertyQuestion(Map<String, dynamic> question, double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple, width: 2),
      ),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),
          Center(
            child: Container(
              padding: EdgeInsets.all(screenWidth * 0.04),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple[300]!, width: 2),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  question['question'].toString().split(': ')[1],
                  style: TextStyle(
                    fontSize: _getNumberFontSize(screenWidth) * 0.8,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[800],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            'Choose the correct property',
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordOrMoneyQuestion(Map<String, dynamic> question, double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: question['type'] == 'money_multiplication' ? Colors.orange : Colors.blue,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
            child: Column(
              children: [
                Text(
                  question['question'] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: _getQuestionFontSize(screenWidth),
                    color: question['type'] == 'money_multiplication' ? Colors.orange[800] : Colors.blue[800],
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                if (question['type'] == 'money_multiplication')
                  SizedBox(height: screenHeight * 0.02),
                if (question['type'] == 'money_multiplication')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.attach_money, color: Colors.orange, size: screenWidth * 0.06),
                      SizedBox(width: screenWidth * 0.02),
                      Text(
                        'Money Multiplication',
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[800],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextOptionButton(int index, String text) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isAnswered = _answeredQuestions[_currentQuestion];
    final isSelected = _userAnswers[_currentQuestion] == index.toString();
    final isCorrect = index.toString() == _questions[_currentQuestion]['correctAnswer'];

    Color buttonColor = Colors.white;
    Color borderColor = Colors.black;
    Color textColor = Colors.black;

    if (isAnswered) {
      if (isSelected && isCorrect) {
        buttonColor = Colors.green[100]!;
        borderColor = Colors.green;
        textColor = Colors.green[900]!;
      } else if (isSelected && !isCorrect) {
        buttonColor = Colors.red[100]!;
        borderColor = Colors.red;
        textColor = Colors.red[900]!;
      } else if (isCorrect) {
        buttonColor = Colors.green[100]!;
        borderColor = Colors.green;
        textColor = Colors.green[900]!;
      }
    }

    return GestureDetector(
      onTap: () => _answerPropertyQuestion(index),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: _getOptionFontSize(screenWidth),
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRepeatedAdditionVisual(Map<String, dynamic> question, double screenWidth) {
    final groups = question['groups'] as int;
    final itemsPerGroup = question['itemsPerGroup'] as int;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenWidth * 0.02),
        Text(
          'Repeated Addition:',
          style: TextStyle(
            fontSize: screenWidth * 0.035,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        SizedBox(height: screenWidth * 0.01),
        Wrap(
          children: List.generate(
            groups,
            (index) => Padding(
              padding: EdgeInsets.only(right: screenWidth * 0.02),
              child: Text(
                '$itemsPerGroup${index < groups - 1 ? ' + ' : ''}',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: screenWidth * 0.01),
        Row(
          children: [
            Text(
              '= ',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${groups} × ${itemsPerGroup}',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            SizedBox(width: screenWidth * 0.02),
            Text(
              '= ',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              (groups * itemsPerGroup).toString(),
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBreakdownVisual(Map<String, dynamic> question, double screenWidth) {
    final multiplier = question['multiplier'] as int;
    final multiplicand = question['multiplicand'] as int;
    
    // For two-digit multiplication
    if (multiplier > 9) {
      final tens = multiplier ~/ 10;
      final ones = multiplier % 10;
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenWidth * 0.02),
          Text(
            'Breakdown:',
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.bold,
              color: Colors.orange[800],
            ),
          ),
          SizedBox(height: screenWidth * 0.01),
          Text(
            '$multiplier = $tens tens + $ones ones',
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: screenWidth * 0.01),
          Row(
            children: [
              Text(
                '$tens × $multiplicand = ',
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  color: Colors.blue[800],
                ),
              ),
              Text(
                '${tens * multiplicand}',
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                '$ones × $multiplicand = ',
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  color: Colors.blue[800],
                ),
              ),
              Text(
                '${ones * multiplicand}',
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
          SizedBox(height: screenWidth * 0.01),
          Row(
            children: [
              Text(
                'Total: ${tens * multiplicand} + ${ones * multiplicand} = ',
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  color: Colors.green[800],
                ),
              ),
              Text(
                (multiplier * multiplicand).toString(),
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
            ],
          ),
        ],
      );
    }
    
    return SizedBox.shrink();
  }

  Widget _buildResultsScreen() {
    final percentage = (_score / _questions.length * 100).toInt();
    String resultText = '';
    String emoji = '';
    Color color = Colors.green;

    if (percentage >= 90) {
      resultText = 'Excellent! Perfect Score!';
      emoji = '🏆';
      color = Colors.green;
    } else if (percentage >= 80) {
      resultText = 'Great Job! You\'re Amazing!';
      emoji = '🎉';
      color = Colors.green;
    } else if (percentage >= 70) {
      resultText = 'Good Work! Keep Going!';
      emoji = '👍';
      color = Colors.orange;
    } else if (percentage >= 60) {
      resultText = 'Not Bad! Practice More!';
      emoji = '💪';
      color = Colors.orange;
    } else {
      resultText = 'Keep Practicing! You Can Do It!';
      emoji = '📚';
      color = Colors.red;
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Exercise Results',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  emoji,
                  style: TextStyle(fontSize: screenWidth * 0.2),
                ),
                SizedBox(height: screenHeight * 0.02),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(screenWidth * 0.06),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(0, 0, 0, 0.2),
                        blurRadius: 8,
                        offset: const Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        resultText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.065,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.close, color: Colors.green, size: screenWidth * 0.1),
                          SizedBox(width: screenWidth * 0.03),
                          Text(
                            '$_score/${_questions.length}',
                            style: TextStyle(
                              fontSize: screenWidth * 0.09,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF6B8E6B),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      Text(
                        '$percentage% Correct',
                        style: TextStyle(fontSize: screenWidth * 0.05),
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: screenHeight * 0.065,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFF59D),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.06),
                                  side: const BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                              onPressed: _restartExercise,
                              child: Text(
                                'Try Again',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          SizedBox(
                            width: double.infinity,
                            height: screenHeight * 0.065,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.06),
                                  side: const BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Back to Lessons',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class DivisionExerciseScreen extends StatefulWidget {
  final String lessonName;
  final String language;
  final int subLessonIndex;

  const DivisionExerciseScreen({
    super.key,
    required this.lessonName,
    required this.language,
    required this.subLessonIndex,
  });

  @override
  State<DivisionExerciseScreen> createState() => _DivisionExerciseScreenState();
}

class _DivisionExerciseScreenState extends State<DivisionExerciseScreen> {
  int _currentQuestion = 0;
  int _score = 0;
  bool _exerciseCompleted = false;
  List<String?> _userAnswers = List.filled(10, null);
  List<bool> _answeredQuestions = List.filled(10, false);
  List<TextEditingController> _textControllers = List.generate(10, (_) => TextEditingController());

  final List<Map<String, dynamic>> _questions = [
    {
      'type': 'equal_sharing',
      'question': 'Divide equally: Share 12 cookies among 3 friends',
      'totalItems': 12,
      'groups': 3,
      'items': '🍪🍪🍪🍪 🍪🍪🍪🍪 🍪🍪🍪🍪',
      'correctAnswer': '4',
      'explanation': '12 cookies ÷ 3 friends = 4 cookies each\nEqual sharing: Each friend gets 4 cookies',
      'hint': 'Divide 12 into 3 equal groups',
    },
    {
      'type': 'equal_sharing',
      'question': 'Equal sharing: 15 apples divided among 5 baskets',
      'totalItems': 15,
      'groups': 5,
      'correctAnswer': '3',
      'explanation': '15 apples ÷ 5 baskets = 3 apples per basket',
      'hint': 'How many apples in each basket?',
    },
    {
      'type': 'repeated_subtraction',
      'question': 'Division as repeated subtraction: 20 ÷ 4',
      'dividend': 20,
      'divisor': 4,
      'correctAnswer': '5',
      'explanation': '20 ÷ 4 = 5\n20 - 4 = 16, 16 - 4 = 12, 12 - 4 = 8, 8 - 4 = 4, 4 - 4 = 0\nSubtracted 4 five times',
      'hint': 'How many times can you subtract 4 from 20?',
    },
    {
      'type': 'repeated_subtraction',
      'question': 'How many times can you subtract 3 from 18?',
      'dividend': 18,
      'divisor': 3,
      'correctAnswer': '6',
      'explanation': '18 ÷ 3 = 6\nSubtracted 3 six times from 18',
      'hint': 'Count how many 3s in 18',
    },
    {
      'type': 'basic_division',
      'question': 'Divide: 24 ÷ 6',
      'dividend': 24,
      'divisor': 6,
      'correctAnswer': '4',
      'explanation': '24 ÷ 6 = 4\nThink: 6 × 4 = 24',
      'hint': 'What number times 6 equals 24?',
    },
    {
      'type': 'basic_division',
      'question': 'Find the quotient: 42 ÷ 7',
      'dividend': 42,
      'divisor': 7,
      'correctAnswer': '6',
      'explanation': '42 ÷ 7 = 6\n7 × 6 = 42',
      'hint': 'Use multiplication facts',
    },
    {
      'type': 'two_digit_division',
      'question': 'Divide two-digit number: 56 ÷ 8',
      'dividend': 56,
      'divisor': 8,
      'correctAnswer': '7',
      'explanation': '56 ÷ 8 = 7\n8 × 7 = 56',
      'hint': 'Think of 8 times table',
    },
    {
      'type': 'word_problem',
      'question': 'A teacher has 35 students to divide into 5 equal groups. How many students in each group?',
      'correctAnswer': '7',
      'explanation': '35 students ÷ 5 groups = 7 students per group',
      'hint': 'Divide total students by number of groups',
    },
    {
      'type': 'money_division',
      'question': '₱120 is shared equally among 4 children. How much does each child get?',
      'correctAnswer': '30',
      'explanation': '₱120 ÷ 4 = ₱30\nEach child gets ₱30.',
      'hint': 'Divide total money by number of children',
    },
    {
      'type': 'inverse_operation',
      'question': 'If 7 × 8 = 56, then 56 ÷ 8 = ?',
      'correctAnswer': '7',
      'explanation': '56 ÷ 8 = 7\nDivision is the inverse of multiplication.',
      'hint': 'Multiplication and division undo each other',
    },
  ];

  @override
  void dispose() {
    for (var controller in _textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _answerQuestion(String answer) {
    if (!_answeredQuestions[_currentQuestion]) {
      setState(() {
        _answeredQuestions[_currentQuestion] = true;
        _userAnswers[_currentQuestion] = answer;

        final question = _questions[_currentQuestion];
        final correctAnswer = question['correctAnswer'] as String;
        final isCorrect = answer.trim() == correctAnswer;

        if (isCorrect) {
          _score++;
        }
        
        if (_answeredQuestions.every((answered) => answered)) {
          _exerciseCompleted = true;
          _recordExerciseResults();
        }
      });
    }
  }

  void _recordExerciseResults() {
    final percentage = (_score / _questions.length * 100).toInt();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 Exercise completed! Score: $percentage%'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _nextQuestion() {
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestion > 0) {
      setState(() {
        _currentQuestion--;
      });
    }
  }

  void _restartExercise() {
    setState(() {
      _currentQuestion = 0;
      _score = 0;
      _exerciseCompleted = false;
      _userAnswers = List.filled(_questions.length, null);
      _answeredQuestions = List.filled(_questions.length, false);
      for (var controller in _textControllers) {
        controller.clear();
      }
    });
  }

  // Helper methods for responsive design
  double _getQuestionFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.042;
    if (screenWidth > 600) return screenWidth * 0.038;
    return screenWidth * 0.045;
  }

  double _getNumberFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.09;
    if (screenWidth > 600) return screenWidth * 0.07;
    return screenWidth * 0.11;
  }

  double _getInputFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.05;
    if (screenWidth > 600) return screenWidth * 0.045;
    return screenWidth * 0.06;
  }

  @override
  Widget build(BuildContext context) {
    if (_exerciseCompleted) {
      return _buildResultsScreen();
    }

    final currentQuestion = _questions[_currentQuestion];
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.purple[50],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Division Exercise',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            children: [
              // Header with progress
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.purple[200]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question ${_currentQuestion + 1}/${_questions.length}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[900],
                          ),
                        ),
                        Text(
                          'Division Skills',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Colors.purple[700],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.percent, color: Colors.purple, size: screenWidth * 0.06),
                        SizedBox(width: screenWidth * 0.01),
                        Text(
                          '$_score',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[800],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              // Main question container
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(0, 0, 0, 0.15),
                      blurRadius: 8,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Question text
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      child: Text(
                        currentQuestion['question'] as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: _getQuestionFontSize(screenWidth),
                          fontWeight: FontWeight.bold,
                          color: Colors.purple[900],
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Question content based on type
                    if (currentQuestion['type'] == 'equal_sharing' && currentQuestion.containsKey('items'))
                      _buildEqualSharingWithObjects(currentQuestion, screenWidth, screenHeight)
                    else if (currentQuestion['type'] == 'equal_sharing')
                      _buildEqualSharingQuestion(currentQuestion, screenWidth, screenHeight)
                    else if (currentQuestion['type'] == 'repeated_subtraction')
                      _buildRepeatedSubtractionQuestion(currentQuestion, screenWidth, screenHeight)
                    else if (currentQuestion['type'] == 'basic_division' || 
                             currentQuestion['type'] == 'two_digit_division')
                      _buildDivisionQuestion(currentQuestion, screenWidth, screenHeight)
                    else if (currentQuestion['type'] == 'inverse_operation')
                      _buildInverseOperationQuestion(currentQuestion, screenWidth, screenHeight)
                    else
                      _buildWordOrMoneyQuestion(currentQuestion, screenWidth, screenHeight),

                    SizedBox(height: screenHeight * 0.03),

                    // Input field for answer
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Column(
                        children: [
                          Text(
                            'Your Answer:',
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          Container(
                            height: screenHeight * 0.07,
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _answeredQuestions[_currentQuestion]
                                    ? (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer']
                                        ? Colors.green
                                        : Colors.red)
                                    : Colors.purple[300]!,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _textControllers[_currentQuestion],
                                    enabled: !_answeredQuestions[_currentQuestion],
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      fontSize: _getInputFontSize(screenWidth),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter quotient',
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                                if (!_answeredQuestions[_currentQuestion])
                                  Padding(
                                    padding: EdgeInsets.only(right: screenWidth * 0.03),
                                    child: IconButton(
                                      icon: Icon(Icons.check, color: Colors.purple, size: screenWidth * 0.06),
                                      onPressed: () {
                                        final answer = _textControllers[_currentQuestion].text;
                                        if (answer.isNotEmpty) {
                                          _answerQuestion(answer);
                                        }
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // Hint
                    if (!_answeredQuestions[_currentQuestion])
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        decoration: BoxDecoration(
                          color: Colors.amber[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.amber, width: 1),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.lightbulb_outline, color: Colors.amber[700], size: screenWidth * 0.05),
                            SizedBox(width: screenWidth * 0.02),
                            Expanded(
                              child: Text(
                                currentQuestion['hint'] as String,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.035,
                                  color: Colors.amber[900],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: screenHeight * 0.02),

                    // Explanation
                    if (_answeredQuestions[_currentQuestion])
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        decoration: BoxDecoration(
                          color: (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                              ? Colors.green[50]
                              : Colors.red[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                                ? Colors.green
                                : Colors.red,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                                      ? Icons.check_circle
                                      : Icons.error,
                                  color: (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                Text(
                                  (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                                      ? 'Correct!'
                                      : 'Incorrect',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.bold,
                                    color: (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                                        ? Colors.green[900]
                                        : Colors.red[900],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              currentQuestion['explanation'] as String,
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                color: Colors.grey[800],
                              ),
                            ),
                            if (currentQuestion['type'] == 'repeated_subtraction')
                              SizedBox(height: screenHeight * 0.01),
                            if (currentQuestion['type'] == 'repeated_subtraction')
                              _buildRepeatedSubtractionVisual(currentQuestion, screenWidth),
                            if (currentQuestion['type'] == 'inverse_operation')
                              SizedBox(height: screenHeight * 0.01),
                            if (currentQuestion['type'] == 'inverse_operation')
                              _buildInverseOperationVisual(currentQuestion, screenWidth),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // Navigation buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: Size(0, screenHeight * 0.065),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.06),
                          side: const BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      onPressed: _currentQuestion > 0 ? _previousQuestion : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_back, size: screenWidth * 0.05),
                          SizedBox(width: screenWidth * 0.02),
                          Text(
                            'Previous',
                            style: TextStyle(fontSize: screenWidth * 0.04),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF59D),
                        foregroundColor: Colors.black,
                        minimumSize: Size(0, screenHeight * 0.065),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.06),
                          side: const BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      onPressed: _answeredQuestions[_currentQuestion]
                          ? () {
                              if (_currentQuestion < _questions.length - 1) {
                                _nextQuestion();
                              } else {
                                _recordExerciseResults();
                                setState(() {
                                  _exerciseCompleted = true;
                                });
                              }
                            }
                          : null,
                      child: Text(
                        _currentQuestion == _questions.length - 1
                            ? 'Finish Exercise'
                            : 'Next Question',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
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

  Widget _buildEqualSharingWithObjects(Map<String, dynamic> question, double screenWidth, double screenHeight) {
    final totalItems = question['totalItems'] as int;
    final groups = question['groups'] as int;
    final itemsPerGroup = totalItems ~/ groups;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange, width: 2),
      ),
      child: Column(
        children: [
          // Total items
          Column(
            children: [
              Text(
                'Total to share:',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[800],
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange[300]!, width: 2),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    question['items'] as String,
                    style: TextStyle(fontSize: screenWidth * 0.05),
                  ),
                ),
              ),
              Text(
                '($totalItems items)',
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),

          SizedBox(height: screenHeight * 0.02),

          // Division arrow
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_downward,
                size: screenWidth * 0.06,
                color: Colors.purple,
              ),
              SizedBox(width: screenWidth * 0.02),
              Text(
                '÷',
                style: TextStyle(
                  fontSize: screenWidth * 0.08,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              Text(
                '$groups groups',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[800],
                ),
              ),
            ],
          ),

          SizedBox(height: screenHeight * 0.02),

          // Divided groups
          Text(
            'Each group gets:',
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Wrap(
            spacing: screenWidth * 0.04,
            runSpacing: screenHeight * 0.02,
            children: List.generate(
              groups,
              (index) => Container(
                padding: EdgeInsets.all(screenWidth * 0.03),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green[300]!, width: 2),
                ),
                child: Column(
                  children: [
                    Text(
                      'Group ${index + 1}',
                      style: TextStyle(
                        fontSize: screenWidth * 0.03,
                        color: Colors.green[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.005),
                    Text(
                      '🍪' * itemsPerGroup,
                      style: TextStyle(fontSize: screenWidth * 0.04),
                    ),
                    Text(
                      '($itemsPerGroup cookies)',
                      style: TextStyle(
                        fontSize: screenWidth * 0.025,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEqualSharingQuestion(Map<String, dynamic> question, double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[300]!, width: 2),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    question['totalItems'].toString(),
                    style: TextStyle(
                      fontSize: _getNumberFontSize(screenWidth),
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.05),
              Container(
                padding: EdgeInsets.all(screenWidth * 0.02),
                child: Column(
                  children: [
                    Text(
                      '÷',
                      style: TextStyle(
                        fontSize: screenWidth * 0.1,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      'divided by',
                      style: TextStyle(
                        fontSize: screenWidth * 0.03,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: screenWidth * 0.05),
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[300]!, width: 2),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    question['groups'].toString(),
                    style: TextStyle(
                      fontSize: _getNumberFontSize(screenWidth),
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            'Equal sharing among ${question['groups']} groups',
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRepeatedSubtractionQuestion(Map<String, dynamic> question, double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red, width: 2),
      ),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red[300]!, width: 2),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    question['dividend'].toString(),
                    style: TextStyle(
                      fontSize: _getNumberFontSize(screenWidth),
                      fontWeight: FontWeight.bold,
                      color: Colors.red[800],
                    ),
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.05),
              Container(
                padding: EdgeInsets.all(screenWidth * 0.02),
                child: Column(
                  children: [
                    Text(
                      '÷',
                      style: TextStyle(
                        fontSize: screenWidth * 0.1,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      'how many',
                      style: TextStyle(
                        fontSize: screenWidth * 0.03,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: screenWidth * 0.05),
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red[300]!, width: 2),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    question['divisor'].toString(),
                    style: TextStyle(
                      fontSize: _getNumberFontSize(screenWidth),
                      fontWeight: FontWeight.bold,
                      color: Colors.red[800],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            'Repeated subtraction: How many times can you subtract ${question['divisor']} from ${question['dividend']}?',
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivisionQuestion(Map<String, dynamic> question, double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple, width: 2),
      ),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.purple[300]!, width: 2),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    question['dividend'].toString(),
                    style: TextStyle(
                      fontSize: _getNumberFontSize(screenWidth),
                      fontWeight: FontWeight.bold,
                      color: Colors.purple[800],
                    ),
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.05),
              Container(
                padding: EdgeInsets.all(screenWidth * 0.02),
                child: Column(
                  children: [
                    Text(
                      '÷',
                      style: TextStyle(
                        fontSize: screenWidth * 0.1,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      'divided by',
                      style: TextStyle(
                        fontSize: screenWidth * 0.03,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: screenWidth * 0.05),
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.purple[300]!, width: 2),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    question['divisor'].toString(),
                    style: TextStyle(
                      fontSize: _getNumberFontSize(screenWidth),
                      fontWeight: FontWeight.bold,
                      color: Colors.purple[800],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            'Find the quotient',
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInverseOperationQuestion(Map<String, dynamic> question, double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '7',
                    style: TextStyle(
                      fontSize: _getNumberFontSize(screenWidth) * 0.8,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Icon(Icons.close, size: screenWidth * 0.06, color: Colors.blue),
                  SizedBox(width: screenWidth * 0.03),
                  Text(
                    '8',
                    style: TextStyle(
                      fontSize: _getNumberFontSize(screenWidth) * 0.8,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Text(
                    '=',
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Text(
                    '56',
                    style: TextStyle(
                      fontSize: _getNumberFontSize(screenWidth) * 0.8,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                'So,',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '56',
                    style: TextStyle(
                      fontSize: _getNumberFontSize(screenWidth) * 0.8,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Text(
                    '÷',
                    style: TextStyle(
                      fontSize: screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Text(
                    '8',
                    style: TextStyle(
                      fontSize: _getNumberFontSize(screenWidth) * 0.8,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Text(
                    '=',
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Container(
                    width: screenWidth * 0.15,
                    height: screenWidth * 0.15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green, width: 2),
                    ),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '?',
                          style: TextStyle(
                            fontSize: screenWidth * 0.08,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            'Division is the inverse of multiplication',
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordOrMoneyQuestion(Map<String, dynamic> question, double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: question['type'] == 'money_division' ? Colors.orange : Colors.blue,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
            child: Column(
              children: [
                Text(
                  question['question'] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: _getQuestionFontSize(screenWidth),
                    color: question['type'] == 'money_division' ? Colors.orange[800] : Colors.blue[800],
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                if (question['type'] == 'money_division')
                  SizedBox(height: screenHeight * 0.02),
                if (question['type'] == 'money_division')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.attach_money, color: Colors.orange, size: screenWidth * 0.06),
                      SizedBox(width: screenWidth * 0.02),
                      Text(
                        'Money Division',
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[800],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRepeatedSubtractionVisual(Map<String, dynamic> question, double screenWidth) {
    final dividend = question['dividend'] as int;
    final divisor = question['divisor'] as int;
    final quotient = dividend ~/ divisor;
    
    List<String> steps = [];
    int current = dividend;
    for (int i = 0; i < quotient; i++) {
      steps.add('$current - $divisor = ${current - divisor}');
      current -= divisor;
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenWidth * 0.02),
        Text(
          'Repeated Subtraction Steps:',
          style: TextStyle(
            fontSize: screenWidth * 0.035,
            fontWeight: FontWeight.bold,
            color: Colors.red[800],
          ),
        ),
        SizedBox(height: screenWidth * 0.01),
        ...steps.map((step) => Padding(
          padding: EdgeInsets.only(bottom: screenWidth * 0.01),
          child: Text(
            step,
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: Colors.grey[800],
            ),
          ),
        )).toList(),
        SizedBox(height: screenWidth * 0.01),
        Text(
          'Subtracted $divisor $quotient times',
          style: TextStyle(
            fontSize: screenWidth * 0.035,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
      ],
    );
  }

  Widget _buildInverseOperationVisual(Map<String, dynamic> question, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenWidth * 0.02),
        Text(
          'Inverse Operation:',
          style: TextStyle(
            fontSize: screenWidth * 0.035,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
        SizedBox(height: screenWidth * 0.01),
        Row(
          children: [
            Text(
              'Multiplication: ',
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                color: Colors.blue[800],
              ),
            ),
            Text(
              '7 × 8 = 56',
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              'Division: ',
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                color: Colors.green[800],
              ),
            ),
            Text(
              '56 ÷ 8 = 7',
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
          ],
        ),
        SizedBox(height: screenWidth * 0.01),
        Text(
          'They undo each other!',
          style: TextStyle(
            fontSize: screenWidth * 0.035,
            fontStyle: FontStyle.italic,
            color: Colors.purple[800],
          ),
        ),
      ],
    );
  }

  Widget _buildResultsScreen() {
    final percentage = (_score / _questions.length * 100).toInt();
    String resultText = '';
    String emoji = '';
    Color color = Colors.purple;

    if (percentage >= 90) {
      resultText = 'Excellent! Perfect Score!';
      emoji = '🏆';
      color = Colors.purple;
    } else if (percentage >= 80) {
      resultText = 'Great Job! You\'re Amazing!';
      emoji = '🎉';
      color = Colors.purple;
    } else if (percentage >= 70) {
      resultText = 'Good Work! Keep Going!';
      emoji = '👍';
      color = Colors.orange;
    } else if (percentage >= 60) {
      resultText = 'Not Bad! Practice More!';
      emoji = '💪';
      color = Colors.orange;
    } else {
      resultText = 'Keep Practicing! You Can Do It!';
      emoji = '📚';
      color = Colors.red;
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Exercise Results',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  emoji,
                  style: TextStyle(fontSize: screenWidth * 0.2),
                ),
                SizedBox(height: screenHeight * 0.02),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(screenWidth * 0.06),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(0, 0, 0, 0.2),
                        blurRadius: 8,
                        offset: const Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        resultText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.065,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.percent, color: Colors.green, size: screenWidth * 0.1),
                          SizedBox(width: screenWidth * 0.03),
                          Text(
                            '$_score/${_questions.length}',
                            style: TextStyle(
                              fontSize: screenWidth * 0.09,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF6B8E6B),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      Text(
                        '$percentage% Correct',
                        style: TextStyle(fontSize: screenWidth * 0.05),
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: screenHeight * 0.065,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFF59D),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.06),
                                  side: const BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                              onPressed: _restartExercise,
                              child: Text(
                                'Try Again',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          SizedBox(
                            width: double.infinity,
                            height: screenHeight * 0.065,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.06),
                                  side: const BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Back to Lessons',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




class FractionExerciseScreen extends StatefulWidget {
  final String lessonName;
  final String language;
  final int subLessonIndex;

  const FractionExerciseScreen({
    super.key,
    required this.lessonName,
    required this.language,
    required this.subLessonIndex,
  });

  @override
  State<FractionExerciseScreen> createState() => _FractionExerciseScreenState();
}

class _FractionExerciseScreenState extends State<FractionExerciseScreen> {
  int _currentQuestion = 0;
  int _score = 0;
  bool _exerciseCompleted = false;
  List<String?> _userAnswers = List.filled(10, null);
  List<bool> _answeredQuestions = List.filled(10, false);
  List<TextEditingController> _textControllers = List.generate(10, (_) => TextEditingController());

  final List<Map<String, dynamic>> _questions = [
    {
      'type': 'identify_fraction',
      'question': 'What fraction of the circle is shaded?',
      'imageType': 'circle',
      'fraction': '1/2',
      'shadedParts': 1,
      'totalParts': 2,
      'correctAnswer': '1/2',
      'explanation': '1 out of 2 parts is shaded = ½',
      'hint': 'Count shaded parts vs total parts',
      'options': ['1/4', '1/2', '3/4', '1'],
    },
    {
      'type': 'identify_fraction',
      'question': 'What fraction of the rectangle is shaded?',
      'imageType': 'rectangle',
      'fraction': '1/4',
      'shadedParts': 1,
      'totalParts': 4,
      'correctAnswer': '1/4',
      'explanation': '1 out of 4 parts is shaded = ¼',
      'hint': 'Look for quarters',
      'options': ['1/4', '1/2', '3/4', '1'],
    },
    {
      'type': 'identify_fraction',
      'question': 'What fraction of the square is shaded?',
      'imageType': 'square',
      'fraction': '3/4',
      'shadedParts': 3,
      'totalParts': 4,
      'correctAnswer': '3/4',
      'explanation': '3 out of 4 parts are shaded = ¾',
      'hint': 'How many parts are shaded?',
      'options': ['1/4', '1/2', '3/4', '1'],
    },
    {
      'type': 'represent_fraction',
      'question': 'Shade ½ of the circle',
      'imageType': 'circle_blank',
      'fraction': '1/2',
      'correctAnswer': '1/2',
      'explanation': 'Divide circle into 2 equal parts, shade 1 part',
      'hint': 'Draw a line through the center',
      'options': ['Top half', 'Bottom half', 'Left half', 'Right half'],
    },
    {
      'type': 'read_write_fraction',
      'question': 'Write the fraction: three-quarters',
      'correctAnswer': '3/4',
      'explanation': 'three-quarters = ¾',
      'hint': 'Think: 3 parts out of 4',
    },
    {
      'type': 'read_write_fraction',
      'question': 'Read this fraction: ¼',
      'options': ['One-fourth', 'One-half', 'Three-fourths', 'One'],
      'correctAnswer': '0',
      'explanation': '¼ is read as "one-fourth" or "one-quarter"',
      'hint': '¼ means 1 part out of 4',
    },
    {
      'type': 'compare_fraction',
      'question': 'Compare: ½ _ ¼',
      'fraction1': '1/2',
      'fraction2': '1/4',
      'correctAnswer': '>',
      'explanation': '½ is greater than ¼\n½ = 0.5, ¼ = 0.25\n0.5 > 0.25',
      'hint': 'Which fraction is larger?',
      'options': ['>', '<', '=', '≠'],
    },
    {
      'type': 'compare_fraction',
      'question': 'Compare: ¼ _ ¼',
      'fraction1': '1/4',
      'fraction2': '1/4',
      'correctAnswer': '=',
      'explanation': '¼ is equal to ¼\nSame value = same fraction',
      'hint': 'Are they the same?',
      'options': ['>', '<', '=', '≠'],
    },
    {
      'type': 'order_fraction',
      'question': 'Arrange in increasing order: ½, ¼, ¾',
      'fractions': ['1/2', '1/4', '3/4'],
      'correctAnswer': '1/4, 1/2, 3/4',
      'explanation': 'Increasing order: ¼ (0.25), ½ (0.5), ¾ (0.75)',
      'hint': 'Smallest to largest',
      'options': ['1/4, 1/2, 3/4', '1/2, 1/4, 3/4', '3/4, 1/2, 1/4', '1/4, 3/4, 1/2'],
    },
    {
      'type': 'add_fraction',
      'question': 'Add: ¼ + ¼',
      'fraction1': '1/4',
      'fraction2': '1/4',
      'correctAnswer': '1/2',
      'explanation': '¼ + ¼ = 2/4 = ½\nWhen denominators are same, add numerators',
      'hint': 'Add the numerators, keep denominator same',
    },
  ];

  @override
  void dispose() {
    for (var controller in _textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _answerQuestion(String answer) {
    if (!_answeredQuestions[_currentQuestion]) {
      setState(() {
        _answeredQuestions[_currentQuestion] = true;
        _userAnswers[_currentQuestion] = answer;

        final question = _questions[_currentQuestion];
        final correctAnswer = question['correctAnswer'] as String;
        final isCorrect = answer.trim() == correctAnswer;

        if (isCorrect) {
          _score++;
        }
        
        if (_answeredQuestions.every((answered) => answered)) {
          _exerciseCompleted = true;
          _recordExerciseResults();
        }
      });
    }
  }

  void _answerMultipleChoice(int answerIndex) {
    if (!_answeredQuestions[_currentQuestion]) {
      setState(() {
        _answeredQuestions[_currentQuestion] = true;
        _userAnswers[_currentQuestion] = answerIndex.toString();

        final question = _questions[_currentQuestion];
        final correctAnswer = question['correctAnswer'] as String;
        final isCorrect = answerIndex.toString() == correctAnswer;

        if (isCorrect) {
          _score++;
        }
        
        if (_answeredQuestions.every((answered) => answered)) {
          _exerciseCompleted = true;
          _recordExerciseResults();
        }
      });
    }
  }

  void _recordExerciseResults() {
    final percentage = (_score / _questions.length * 100).toInt();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 Exercise completed! Score: $percentage%'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _nextQuestion() {
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestion > 0) {
      setState(() {
        _currentQuestion--;
      });
    }
  }

  void _restartExercise() {
    setState(() {
      _currentQuestion = 0;
      _score = 0;
      _exerciseCompleted = false;
      _userAnswers = List.filled(_questions.length, null);
      _answeredQuestions = List.filled(_questions.length, false);
      for (var controller in _textControllers) {
        controller.clear();
      }
    });
  }

  // Helper methods for responsive design
  double _getQuestionFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.042;
    if (screenWidth > 600) return screenWidth * 0.038;
    return screenWidth * 0.045;
  }

  double _getFractionFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.08;
    if (screenWidth > 600) return screenWidth * 0.06;
    return screenWidth * 0.1;
  }

  double _getInputFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.05;
    if (screenWidth > 600) return screenWidth * 0.045;
    return screenWidth * 0.06;
  }

  double _getOptionFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.036;
    if (screenWidth > 600) return screenWidth * 0.032;
    return screenWidth * 0.04;
  }

  @override
  Widget build(BuildContext context) {
    if (_exerciseCompleted) {
      return _buildResultsScreen();
    }

    final currentQuestion = _questions[_currentQuestion];
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pink[50],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Fraction Exercise',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            children: [
              // Header with progress
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.pink[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.pink[200]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question ${_currentQuestion + 1}/${_questions.length}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink[900],
                          ),
                        ),
                        Text(
                          'Fraction Skills',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Colors.pink[700],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '½',
                          style: TextStyle(
                            fontSize: screenWidth * 0.06,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.01),
                        Text(
                          '$_score',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink[800],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              // Main question container
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(0, 0, 0, 0.15),
                      blurRadius: 8,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Question text
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      child: Text(
                        currentQuestion['question'] as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: _getQuestionFontSize(screenWidth),
                          fontWeight: FontWeight.bold,
                          color: Colors.pink[900],
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Question content based on type
                    if (currentQuestion['type'] == 'identify_fraction')
                      _buildIdentifyFractionQuestion(currentQuestion, screenWidth, screenHeight)
                    else if (currentQuestion['type'] == 'represent_fraction')
                      _buildRepresentFractionQuestion(currentQuestion, screenWidth, screenHeight)
                    else if (currentQuestion['type'] == 'compare_fraction')
                      _buildCompareFractionQuestion(currentQuestion, screenWidth, screenHeight)
                    else if (currentQuestion['type'] == 'order_fraction')
                      _buildOrderFractionQuestion(currentQuestion, screenWidth, screenHeight)
                    else if (currentQuestion['type'] == 'add_fraction')
                      _buildAddFractionQuestion(currentQuestion, screenWidth, screenHeight)
                    else
                      _buildReadWriteFractionQuestion(currentQuestion, screenWidth, screenHeight),

                    SizedBox(height: screenHeight * 0.03),

                    // Input field for text answers
                    if (currentQuestion['type'] == 'read_write_fraction' || 
                        currentQuestion['type'] == 'add_fraction')
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                        child: Column(
                          children: [
                            Text(
                              'Your Answer:',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.015),
                            Container(
                              height: screenHeight * 0.07,
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _answeredQuestions[_currentQuestion]
                                      ? (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer']
                                          ? Colors.green
                                          : Colors.red)
                                      : Colors.pink[300]!,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _textControllers[_currentQuestion],
                                      enabled: !_answeredQuestions[_currentQuestion],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: _getInputFontSize(screenWidth),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Enter fraction (e.g., 1/2)',
                                        hintStyle: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  if (!_answeredQuestions[_currentQuestion])
                                    Padding(
                                      padding: EdgeInsets.only(right: screenWidth * 0.03),
                                      child: IconButton(
                                        icon: Icon(Icons.check, color: Colors.pink, size: screenWidth * 0.06),
                                        onPressed: () {
                                          final answer = _textControllers[_currentQuestion].text;
                                          if (answer.isNotEmpty) {
                                            _answerQuestion(answer);
                                          }
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Options for multiple choice questions
                    if (currentQuestion.containsKey('options') && 
                        currentQuestion['type'] != 'read_write_fraction' && 
                        currentQuestion['type'] != 'add_fraction')
                      Column(
                        children: List.generate(
                          (currentQuestion['options'] as List<String>).length,
                          (index) => _buildFractionOptionButton(
                            index, 
                            currentQuestion['options'][index] as String,
                            currentQuestion['type']
                          ),
                        ),
                      ),

                    SizedBox(height: screenHeight * 0.02),

                    // Hint
                    if (!_answeredQuestions[_currentQuestion])
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        decoration: BoxDecoration(
                          color: Colors.amber[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.amber, width: 1),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.lightbulb_outline, color: Colors.amber[700], size: screenWidth * 0.05),
                            SizedBox(width: screenWidth * 0.02),
                            Expanded(
                              child: Text(
                                currentQuestion['hint'] as String,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.035,
                                  color: Colors.amber[900],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: screenHeight * 0.02),

                    // Explanation
                    if (_answeredQuestions[_currentQuestion])
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        decoration: BoxDecoration(
                          color: (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                              ? Colors.green[50]
                              : Colors.red[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                                ? Colors.green
                                : Colors.red,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                                      ? Icons.check_circle
                                      : Icons.error,
                                  color: (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                Text(
                                  (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                                      ? 'Correct!'
                                      : 'Incorrect',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.bold,
                                    color: (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                                        ? Colors.green[900]
                                        : Colors.red[900],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              currentQuestion['explanation'] as String,
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                color: Colors.grey[800],
                              ),
                            ),
                            if (currentQuestion['type'] == 'add_fraction')
                              SizedBox(height: screenHeight * 0.01),
                            if (currentQuestion['type'] == 'add_fraction')
                              _buildFractionAdditionVisual(currentQuestion, screenWidth),
                            if (currentQuestion['type'] == 'compare_fraction')
                              SizedBox(height: screenHeight * 0.01),
                            if (currentQuestion['type'] == 'compare_fraction')
                              _buildFractionComparisonVisual(currentQuestion, screenWidth),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // Navigation buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: Size(0, screenHeight * 0.065),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.06),
                          side: const BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      onPressed: _currentQuestion > 0 ? _previousQuestion : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_back, size: screenWidth * 0.05),
                          SizedBox(width: screenWidth * 0.02),
                          Text(
                            'Previous',
                            style: TextStyle(fontSize: screenWidth * 0.04),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF59D),
                        foregroundColor: Colors.black,
                        minimumSize: Size(0, screenHeight * 0.065),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.06),
                          side: const BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      onPressed: _answeredQuestions[_currentQuestion]
                          ? () {
                              if (_currentQuestion < _questions.length - 1) {
                                _nextQuestion();
                              } else {
                                _recordExerciseResults();
                                setState(() {
                                  _exerciseCompleted = true;
                                });
                              }
                            }
                          : null,
                      child: Text(
                        _currentQuestion == _questions.length - 1
                            ? 'Finish Exercise'
                            : 'Next Question',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
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

  Widget _buildIdentifyFractionQuestion(Map<String, dynamic> question, double screenWidth, double screenHeight) {
    final shadedParts = question['shadedParts'] as int;
    final totalParts = question['totalParts'] as int;
    final fraction = question['fraction'] as String;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),
          
          // Fraction shape
          Container(
            width: screenWidth * 0.4,
            height: screenWidth * 0.4,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue[300]!, width: 3),
            ),
            child: CustomPaint(
              painter: _FractionPainter(
                shape: question['imageType'] as String,
                fraction: fraction,
                shadedParts: shadedParts,
                totalParts: totalParts,
              ),
            ),
          ),
          
          SizedBox(height: screenHeight * 0.02),
          
          // Fraction info
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(screenWidth * 0.03),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue[300]!, width: 2),
                ),
                child: Text(
                  '$shadedParts/$totalParts',
                  style: TextStyle(
                    fontSize: _getFractionFontSize(screenWidth) * 0.8,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.05),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shaded: $shadedParts part${shadedParts > 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    'Total: $totalParts equal parts',
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          SizedBox(height: screenHeight * 0.01),
          Text(
            'Select the correct fraction',
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRepresentFractionQuestion(Map<String, dynamic> question, double screenWidth, double screenHeight) {
    final fraction = question['fraction'] as String;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),
          
          // Blank shape
          Container(
            width: screenWidth * 0.4,
            height: screenWidth * 0.4,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green[300]!, width: 3),
            ),
            child: CustomPaint(
              painter: _BlankShapePainter(
                shape: question['imageType'] as String,
                fraction: fraction,
              ),
            ),
          ),
          
          SizedBox(height: screenHeight * 0.02),
          
          // Fraction to represent
          Container(
            padding: EdgeInsets.all(screenWidth * 0.03),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.green[300]!, width: 2),
            ),
            child: Text(
              'Shade $fraction',
              style: TextStyle(
                fontSize: _getFractionFontSize(screenWidth) * 0.8,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
          ),
          
          SizedBox(height: screenHeight * 0.01),
          Text(
            'Choose which part to shade',
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompareFractionQuestion(Map<String, dynamic> question, double screenWidth, double screenHeight) {
    final fraction1 = question['fraction1'] as String;
    final fraction2 = question['fraction2'] as String;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange, width: 2),
      ),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),
          
          // Fractions to compare
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange[300]!, width: 2),
                ),
                child: Text(
                  fraction1,
                  style: TextStyle(
                    fontSize: _getFractionFontSize(screenWidth),
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
              ),
              
              SizedBox(width: screenWidth * 0.05),
              
              Container(
                width: screenWidth * 0.15,
                height: screenWidth * 0.15,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange, width: 3),
                ),
                child: Center(
                  child: Text(
                    '?',
                    style: TextStyle(
                      fontSize: screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[800],
                    ),
                  ),
                ),
              ),
              
              SizedBox(width: screenWidth * 0.05),
              
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange[300]!, width: 2),
                ),
                child: Text(
                  fraction2,
                  style: TextStyle(
                    fontSize: _getFractionFontSize(screenWidth),
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: screenHeight * 0.01),
          Text(
            'Choose correct comparison symbol',
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderFractionQuestion(Map<String, dynamic> question, double screenWidth, double screenHeight) {
    final fractions = question['fractions'] as List<String>;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple, width: 2),
      ),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),
          
          // Fractions to order
          Wrap(
            spacing: screenWidth * 0.04,
            runSpacing: screenHeight * 0.02,
            children: fractions.map((fraction) {
              return Container(
                padding: EdgeInsets.all(screenWidth * 0.03),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.purple[300]!, width: 2),
                ),
                child: Text(
                  fraction,
                  style: TextStyle(
                    fontSize: _getFractionFontSize(screenWidth) * 0.7,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[800],
                  ),
                ),
              );
            }).toList(),
          ),
          
          SizedBox(height: screenHeight * 0.02),
          Text(
            'Arrange from smallest to largest',
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddFractionQuestion(Map<String, dynamic> question, double screenWidth, double screenHeight) {
    final fraction1 = question['fraction1'] as String;
    final fraction2 = question['fraction2'] as String;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red, width: 2),
      ),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),
          
          // Fraction addition
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red[300]!, width: 2),
                ),
                child: Text(
                  fraction1,
                  style: TextStyle(
                    fontSize: _getFractionFontSize(screenWidth),
                    fontWeight: FontWeight.bold,
                    color: Colors.red[800],
                  ),
                ),
              ),
              
              SizedBox(width: screenWidth * 0.03),
              
              Text(
                '+',
                style: TextStyle(
                  fontSize: screenWidth * 0.08,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[800],
                ),
              ),
              
              SizedBox(width: screenWidth * 0.03),
              
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red[300]!, width: 2),
                ),
                child: Text(
                  fraction2,
                  style: TextStyle(
                    fontSize: _getFractionFontSize(screenWidth),
                    fontWeight: FontWeight.bold,
                    color: Colors.red[800],
                  ),
                ),
              ),
              
              SizedBox(width: screenWidth * 0.03),
              
              Text(
                '=',
                style: TextStyle(
                  fontSize: screenWidth * 0.08,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              SizedBox(width: screenWidth * 0.03),
              
              Container(
                width: screenWidth * 0.2,
                height: screenWidth * 0.2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red, width: 3),
                ),
                child: Center(
                  child: Text(
                    '?',
                    style: TextStyle(
                      fontSize: screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[800],
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: screenHeight * 0.01),
          Text(
            'Add the fractions',
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadWriteFractionQuestion(Map<String, dynamic> question, double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: question['question'].toString().contains('Write') ? Colors.blue : Colors.green,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),
          
          Center(
            child: Container(
              padding: EdgeInsets.all(screenWidth * 0.05),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: question['question'].toString().contains('Write') ? Colors.blue[300]! : Colors.green[300]!,
                  width: 2,
                ),
              ),
              child: question['question'].toString().contains('Write')
                  ? Text(
                      question['question'] as String,
                      style: TextStyle(
                        fontSize: _getQuestionFontSize(screenWidth) * 0.9,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    )
                  : Text(
                      '¼',
                      style: TextStyle(
                        fontSize: _getFractionFontSize(screenWidth) * 1.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
            ),
          ),
          
          SizedBox(height: screenHeight * 0.01),
          Text(
            question['question'].toString().contains('Write')
                ? 'Write the fraction in number form'
                : 'Select how to read this fraction',
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFractionOptionButton(int index, String text, String questionType) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isAnswered = _answeredQuestions[_currentQuestion];
    final isSelected = _userAnswers[_currentQuestion] == index.toString();
    final isCorrect = index.toString() == _questions[_currentQuestion]['correctAnswer'];

    Color buttonColor = Colors.white;
    Color borderColor = Colors.black;
    Color textColor = Colors.black;

    if (isAnswered) {
      if (isSelected && isCorrect) {
        buttonColor = Colors.green[100]!;
        borderColor = Colors.green;
        textColor = Colors.green[900]!;
      } else if (isSelected && !isCorrect) {
        buttonColor = Colors.red[100]!;
        borderColor = Colors.red;
        textColor = Colors.red[900]!;
      } else if (isCorrect) {
        buttonColor = Colors.green[100]!;
        borderColor = Colors.green;
        textColor = Colors.green[900]!;
      }
    }

    return GestureDetector(
      onTap: () => _answerMultipleChoice(index),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: questionType == 'compare_fraction'
              ? Text(
                  text,
                  style: TextStyle(
                    fontSize: _getFractionFontSize(screenWidth) * 0.8,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                )
              : Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: _getOptionFontSize(screenWidth),
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildFractionAdditionVisual(Map<String, dynamic> question, double screenWidth) {
    final fraction1 = question['fraction1'] as String;
    final fraction2 = question['fraction2'] as String;
    final parts1 = int.parse(fraction1.split('/')[0]);
    final total1 = int.parse(fraction1.split('/')[1]);
    final parts2 = int.parse(fraction2.split('/')[0]);
    final total2 = int.parse(fraction2.split('/')[1]);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenWidth * 0.02),
        Text(
          'Visual Representation:',
          style: TextStyle(
            fontSize: screenWidth * 0.035,
            fontWeight: FontWeight.bold,
            color: Colors.red[800],
          ),
        ),
        SizedBox(height: screenWidth * 0.01),
        Row(
          children: [
            Text(
              '$fraction1 = ',
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                color: Colors.grey[800],
              ),
            ),
            Text(
              '$parts1 part${parts1 > 1 ? 's' : ''} out of $total1',
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.bold,
                color: Colors.red[800],
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              '$fraction2 = ',
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                color: Colors.grey[800],
              ),
            ),
            Text(
              '$parts2 part${parts2 > 1 ? 's' : ''} out of $total2',
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.bold,
                color: Colors.red[800],
              ),
            ),
          ],
        ),
        SizedBox(height: screenWidth * 0.01),
        Text(
          '$parts1 + $parts2 = ${parts1 + parts2} parts out of $total1',
          style: TextStyle(
            fontSize: screenWidth * 0.035,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
        Text(
          '${parts1 + parts2}/$total1 = ${(parts1 + parts2) ~/ 2}/${total1 ~/ 2} (simplified)',
          style: TextStyle(
            fontSize: screenWidth * 0.035,
            color: Colors.green[800],
          ),
        ),
      ],
    );
  }

  Widget _buildFractionComparisonVisual(Map<String, dynamic> question, double screenWidth) {
    final fraction1 = question['fraction1'] as String;
    final fraction2 = question['fraction2'] as String;
    final value1 = fraction1 == '1/2' ? 0.5 : fraction1 == '1/4' ? 0.25 : 0.75;
    final value2 = fraction2 == '1/2' ? 0.5 : fraction2 == '1/4' ? 0.25 : 0.75;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenWidth * 0.02),
        Text(
          'Decimal Comparison:',
          style: TextStyle(
            fontSize: screenWidth * 0.035,
            fontWeight: FontWeight.bold,
            color: Colors.orange[800],
          ),
        ),
        SizedBox(height: screenWidth * 0.01),
        Row(
          children: [
            Text(
              '$fraction1 = ',
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                color: Colors.grey[800],
              ),
            ),
            Text(
              '$value1',
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.bold,
                color: Colors.orange[800],
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              '$fraction2 = ',
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                color: Colors.grey[800],
              ),
            ),
            Text(
              '$value2',
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.bold,
                color: Colors.orange[800],
              ),
            ),
          ],
        ),
        SizedBox(height: screenWidth * 0.01),
        Text(
          '$value1 ${value1 > value2 ? '>' : value1 < value2 ? '<' : '='} $value2',
          style: TextStyle(
            fontSize: screenWidth * 0.035,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
      ],
    );
  }

  Widget _buildResultsScreen() {
    final percentage = (_score / _questions.length * 100).toInt();
    String resultText = '';
    String emoji = '';
    Color color = Colors.pink;

    if (percentage >= 90) {
      resultText = 'Excellent! Perfect Score!';
      emoji = '🏆';
      color = Colors.pink;
    } else if (percentage >= 80) {
      resultText = 'Great Job! You\'re Amazing!';
      emoji = '🎉';
      color = Colors.pink;
    } else if (percentage >= 70) {
      resultText = 'Good Work! Keep Going!';
      emoji = '👍';
      color = Colors.orange;
    } else if (percentage >= 60) {
      resultText = 'Not Bad! Practice More!';
      emoji = '💪';
      color = Colors.orange;
    } else {
      resultText = 'Keep Practicing! You Can Do It!';
      emoji = '📚';
      color = Colors.red;
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Exercise Results',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  emoji,
                  style: TextStyle(fontSize: screenWidth * 0.2),
                ),
                SizedBox(height: screenHeight * 0.02),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(screenWidth * 0.06),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(0, 0, 0, 0.2),
                        blurRadius: 8,
                        offset: const Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        resultText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.065,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '½',
                            style: TextStyle(
                              fontSize: screenWidth * 0.1,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          Text(
                            '$_score/${_questions.length}',
                            style: TextStyle(
                              fontSize: screenWidth * 0.09,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF6B8E6B),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      Text(
                        '$percentage% Correct',
                        style: TextStyle(fontSize: screenWidth * 0.05),
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: screenHeight * 0.065,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFF59D),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.06),
                                  side: const BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                              onPressed: _restartExercise,
                              child: Text(
                                'Try Again',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          SizedBox(
                            width: double.infinity,
                            height: screenHeight * 0.065,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.06),
                                  side: const BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Back to Lessons',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom painter for fraction shapes
class _FractionPainter extends CustomPainter {
  final String shape;
  final String fraction;
  final int shadedParts;
  final int totalParts;

  _FractionPainter({
    required this.shape,
    required this.fraction,
    required this.shadedParts,
    required this.totalParts,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 * 0.8;

    if (shape == 'circle') {
      // Draw whole circle
      paint.color = Colors.grey[300]!;
      canvas.drawCircle(center, radius, paint);

      // Draw divisions
      paint.color = Colors.black;
      paint.strokeWidth = 2;
      
      if (totalParts == 2) {
        // Draw line for halves
        canvas.drawLine(
          Offset(center.dx, center.dy - radius),
          Offset(center.dx, center.dy + radius),
          paint,
        );
      } else if (totalParts == 4) {
        // Draw lines for quarters
        canvas.drawLine(
          Offset(center.dx, center.dy - radius),
          Offset(center.dx, center.dy + radius),
          paint,
        );
        canvas.drawLine(
          Offset(center.dx - radius, center.dy),
          Offset(center.dx + radius, center.dy),
          paint,
        );
      }

      // Shade parts
      paint.color = Colors.pink[300]!.withOpacity(0.7);
      final path = Path();
      
      if (fraction == '1/2') {
        if (shadedParts == 1) {
          path.moveTo(center.dx, center.dy);
          path.arcTo(
            Rect.fromCircle(center: center, radius: radius),
            -90 * (3.14159 / 180),
            180 * (3.14159 / 180),
            false,
          );
          path.close();
        }
      } else if (fraction == '1/4') {
        if (shadedParts == 1) {
          path.moveTo(center.dx, center.dy);
          path.arcTo(
            Rect.fromCircle(center: center, radius: radius),
            -90 * (3.14159 / 180),
            90 * (3.14159 / 180),
            false,
          );
          path.close();
        }
      } else if (fraction == '3/4') {
        if (shadedParts == 3) {
          path.moveTo(center.dx, center.dy);
          path.arcTo(
            Rect.fromCircle(center: center, radius: radius),
            -90 * (3.14159 / 180),
            270 * (3.14159 / 180),
            false,
          );
          path.close();
        }
      }
      
      canvas.drawPath(path, paint);
      
    } else if (shape == 'square' || shape == 'rectangle') {
      // Draw square/rectangle
      final rect = Rect.fromCenter(
        center: center,
        width: size.width * 0.8,
        height: size.height * 0.8,
      );
      
      paint.color = Colors.grey[300]!;
      canvas.drawRect(rect, paint);

      // Draw divisions
      paint.color = Colors.black;
      paint.strokeWidth = 2;
      
      if (totalParts == 4) {
        // Draw lines for quarters
        canvas.drawLine(
          Offset(rect.left, center.dy),
          Offset(rect.right, center.dy),
          paint,
        );
        canvas.drawLine(
          Offset(center.dx, rect.top),
          Offset(center.dx, rect.bottom),
          paint,
        );
      } else if (totalParts == 2) {
        if (shape == 'rectangle') {
          // Draw line for halves (vertical)
          canvas.drawLine(
            Offset(center.dx, rect.top),
            Offset(center.dx, rect.bottom),
            paint,
          );
        } else {
          // Draw line for halves (horizontal)
          canvas.drawLine(
            Offset(rect.left, center.dy),
            Offset(rect.right, center.dy),
            paint,
          );
        }
      }

      // Shade parts
      paint.color = Colors.pink[300]!.withOpacity(0.7);
      
      if (fraction == '1/2') {
        if (shadedParts == 1) {
          if (shape == 'rectangle') {
            canvas.drawRect(
              Rect.fromLTRB(rect.left, rect.top, center.dx, rect.bottom),
              paint,
            );
          } else {
            canvas.drawRect(
              Rect.fromLTRB(rect.left, rect.top, rect.right, center.dy),
              paint,
            );
          }
        }
      } else if (fraction == '1/4') {
        if (shadedParts == 1) {
          canvas.drawRect(
            Rect.fromLTRB(rect.left, rect.top, center.dx, center.dy),
            paint,
          );
        }
      } else if (fraction == '3/4') {
        if (shadedParts == 3) {
          canvas.drawRect(
            Rect.fromLTRB(rect.left, rect.top, rect.right, rect.bottom),
            paint,
          );
          paint.color = Colors.grey[300]!;
          canvas.drawRect(
            Rect.fromLTRB(center.dx, center.dy, rect.right, rect.bottom),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for blank shapes
class _BlankShapePainter extends CustomPainter {
  final String shape;
  final String fraction;

  _BlankShapePainter({
    required this.shape,
    required this.fraction,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final center = Offset(size.width / 2, size.height / 2);

    if (shape == 'circle_blank') {
      // Draw whole circle
      paint.color = Colors.grey[300]!;
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 3;
      canvas.drawCircle(center, size.width / 2 * 0.8, paint);

      // Draw division lines for the fraction
      paint.color = Colors.black;
      paint.strokeWidth = 2;
      
      if (fraction == '1/2') {
        // Draw line for halves
        canvas.drawLine(
          Offset(center.dx, center.dy - size.width / 2 * 0.8),
          Offset(center.dx, center.dy + size.width / 2 * 0.8),
          paint,
        );
      } else if (fraction == '1/4' || fraction == '3/4') {
        // Draw lines for quarters
        canvas.drawLine(
          Offset(center.dx, center.dy - size.width / 2 * 0.8),
          Offset(center.dx, center.dy + size.width / 2 * 0.8),
          paint,
        );
        canvas.drawLine(
          Offset(center.dx - size.width / 2 * 0.8, center.dy),
          Offset(center.dx + size.width / 2 * 0.8, center.dy),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DecimalExerciseScreen extends StatefulWidget {
  final String lessonName;
  final String language;
  final int subLessonIndex;

  const DecimalExerciseScreen({
    super.key,
    required this.lessonName,
    required this.language,
    required this.subLessonIndex,
  });

  @override
  State<DecimalExerciseScreen> createState() => _DecimalExerciseScreenState();
}

class _DecimalExerciseScreenState extends State<DecimalExerciseScreen> {
  int _currentQuestion = 0;
  int _score = 0;
  bool _exerciseCompleted = false;
  List<int?> _userAnswers = List.filled(10, null);
  List<bool> _answeredQuestions = List.filled(10, false);
  List<TextEditingController> _textControllers = List.generate(3, (_) => TextEditingController());

  final List<Map<String, dynamic>> _questions = [
    // Basic decimal recognition
    {
      'type': 'decimal_recognition',
      'question': 'Which decimal represents one-half?',
      'options': ['0.125', '0.5', '0.75', '1.0'],
      'correctAnswer': 1,
      'explanation': '0.5 represents one-half or 1/2.',
    },
    {
      'type': 'decimal_recognition',
      'question': 'Which decimal represents three-quarters?',
      'options': ['0.25', '0.5', '0.75', '0.125'],
      'correctAnswer': 2,
      'explanation': '0.75 represents three-quarters or 3/4.',
    },
    {
      'type': 'decimal_recognition',
      'question': 'Which decimal represents one-eighth?',
      'options': ['0.125', '0.25', '0.5', '0.75'],
      'correctAnswer': 0,
      'explanation': '0.125 represents one-eighth or 1/8.',
    },
    
    // Decimal to fraction conversion
    {
      'type': 'conversion',
      'question': 'Convert 0.5 to fraction:',
      'options': ['1/2', '1/4', '3/4', '1/8'],
      'correctAnswer': 0,
      'explanation': '0.5 = 5/10 = 1/2',
    },
    {
      'type': 'conversion',
      'question': 'Convert 0.75 to fraction:',
      'options': ['1/2', '3/4', '1/4', '2/3'],
      'correctAnswer': 1,
      'explanation': '0.75 = 75/100 = 3/4',
    },
    {
      'type': 'conversion',
      'question': 'Convert 0.125 to fraction:',
      'options': ['1/8', '1/4', '1/2', '3/8'],
      'correctAnswer': 0,
      'explanation': '0.125 = 125/1000 = 1/8',
    },
    
    // Decimal comparison
    {
      'type': 'comparison',
      'question': 'Compare: 0.5 ? 0.25',
      'leftValue': 0.5,
      'rightValue': 0.25,
      'leftLabel': '0.5',
      'rightLabel': '0.25',
      'correctAnswer': 0, // >
      'explanation': '0.5 is greater than 0.25 (0.5 > 0.25).',
    },
    {
      'type': 'comparison',
      'question': 'Compare: 0.125 ? 0.5',
      'leftValue': 0.125,
      'rightValue': 0.5,
      'leftLabel': '0.125',
      'rightLabel': '0.5',
      'correctAnswer': 1, // <
      'explanation': '0.125 is less than 0.5 (0.125 < 0.5).',
    },
    
    // Decimal ordering
    {
      'type': 'ordering',
      'question': 'Arrange in increasing order: 0.25, 0.5, 0.125',
      'options': ['0.125, 0.25, 0.5', '0.5, 0.25, 0.125', '0.25, 0.5, 0.125', '0.125, 0.5, 0.25'],
      'correctAnswer': 0,
      'explanation': '0.125 < 0.25 < 0.5',
    },
    
    // Place value
    {
      'type': 'place_value',
      'question': 'In 3.456, what is the place value of 5?',
      'options': ['Tenths', 'Hundredths', 'Thousandths', 'Ones'],
      'correctAnswer': 1,
      'explanation': '3.456 = 3 ones, 4 tenths, 5 hundredths, 6 thousandths',
    },
  ];

  void _answerQuestion(int answerIndex) {
    if (!_answeredQuestions[_currentQuestion]) {
      setState(() {
        _answeredQuestions[_currentQuestion] = true;
        _userAnswers[_currentQuestion] = answerIndex;

        final question = _questions[_currentQuestion];
        final correctAnswer = question['correctAnswer'] as int;
        final isCorrect = answerIndex == correctAnswer;

        if (isCorrect) {
          _score++;
        }
        
        if (_answeredQuestions.every((answered) => answered)) {
          _exerciseCompleted = true;
          _recordExerciseResults();
        }
      });
    }
  }

  void _recordExerciseResults() {
    final percentage = (_score / _questions.length * 100).toInt();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 Exercise completed! Score: $percentage%'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _nextQuestion() {
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestion > 0) {
      setState(() {
        _currentQuestion--;
      });
    }
  }

  void _restartExercise() {
    setState(() {
      _currentQuestion = 0;
      _score = 0;
      _exerciseCompleted = false;
      _userAnswers = List.filled(_questions.length, null);
      _answeredQuestions = List.filled(_questions.length, false);
      for (var controller in _textControllers) {
        controller.clear();
      }
    });
  }

  // Helper methods for responsive design
  double _getQuestionFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.042;
    if (screenWidth > 600) return screenWidth * 0.038;
    return screenWidth * 0.045;
  }

  double _getOptionFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.036;
    if (screenWidth > 600) return screenWidth * 0.032;
    return screenWidth * 0.04;
  }

  @override
  void dispose() {
    for (var controller in _textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_exerciseCompleted) {
      return _buildResultsScreen();
    }

    final currentQuestion = _questions[_currentQuestion];
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Decimal Numbers Exercise',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            children: [
              // Header with progress
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question ${_currentQuestion + 1}/${_questions.length}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                        ),
                        Text(
                          'Decimal Numbers',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.numbers, color: Colors.blue, size: screenWidth * 0.06),
                        SizedBox(width: screenWidth * 0.01),
                        Text(
                          '$_score',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              // Main question container
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(0, 0, 0, 0.15),
                      blurRadius: 8,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Question text
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      child: Text(
                        currentQuestion['question'] as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: _getQuestionFontSize(screenWidth),
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Question content based on type
                    if (currentQuestion['type'] == 'comparison')
                      _buildDecimalComparison(currentQuestion, screenWidth, screenHeight)
                    else
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F8F8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.blue, width: 2),
                        ),
                        child: Column(
                          children: [
                            if (currentQuestion['type'] == 'place_value')
                              Container(
                                padding: EdgeInsets.all(screenWidth * 0.04),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.blue[300]!, width: 2),
                                ),
                                child: Text(
                                  '3.456',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.1,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[800],
                                  ),
                                ),
                              ),
                            SizedBox(height: screenHeight * 0.02),
                            Text(
                              _getHintText(currentQuestion['type']),
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: screenHeight * 0.03),

                    // Options
                    Column(
                      children: List.generate(
                        (currentQuestion['options'] as List<String>).length,
                        (index) => _buildTextOptionButton(
                          index, 
                          currentQuestion['options'][index] as String,
                          currentQuestion['type'] == 'comparison'
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Explanation
                    if (_answeredQuestions[_currentQuestion])
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        decoration: BoxDecoration(
                          color: (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                              ? Colors.green[50]
                              : Colors.red[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                                ? Colors.green
                                : Colors.red,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _getAnswerText(currentQuestion),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: _getOptionFontSize(screenWidth) * 0.9,
                            fontWeight: FontWeight.bold,
                            color: (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                                ? Colors.green[900]
                                : Colors.red[900],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // Navigation buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: Size(0, screenHeight * 0.065),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.06),
                          side: const BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      onPressed: _currentQuestion > 0 ? _previousQuestion : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_back, size: screenWidth * 0.05),
                          SizedBox(width: screenWidth * 0.02),
                          Text(
                            'Previous',
                            style: TextStyle(fontSize: screenWidth * 0.04),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFBBDEFB),
                        foregroundColor: Colors.black,
                        minimumSize: Size(0, screenHeight * 0.065),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.06),
                          side: const BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      onPressed: _answeredQuestions[_currentQuestion]
                          ? () {
                              if (_currentQuestion < _questions.length - 1) {
                                _nextQuestion();
                              } else {
                                _recordExerciseResults();
                                setState(() {
                                  _exerciseCompleted = true;
                                });
                              }
                            }
                          : null,
                      child: Text(
                        _currentQuestion == _questions.length - 1
                            ? 'Finish Exercise'
                            : 'Next Question',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
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

  Widget _buildDecimalComparison(Map<String, dynamic> question, double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: screenWidth * 0.08,
            runSpacing: screenWidth * 0.04,
            children: [
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[300]!, width: 2),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    question['leftLabel'] as String,
                    style: TextStyle(
                      fontSize: screenWidth * 0.12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
              ),
              Container(
                width: screenWidth * 0.15,
                height: screenWidth * 0.15,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue, width: 3),
                ),
                child: Center(
                  child: Text(
                    '?',
                    style: TextStyle(
                      fontSize: screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[300]!, width: 2),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    question['rightLabel'] as String,
                    style: TextStyle(
                      fontSize: screenWidth * 0.12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            'Choose the correct comparison symbol',
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextOptionButton(int index, String text, bool isComparison) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isAnswered = _answeredQuestions[_currentQuestion];
    final isSelected = _userAnswers[_currentQuestion] == index;
    final isCorrect = index == _questions[_currentQuestion]['correctAnswer'];

    Color buttonColor = Colors.white;
    Color borderColor = isComparison ? Colors.blue : Colors.black;
    Color textColor = Colors.black;

    if (isAnswered) {
      if (isSelected && isCorrect) {
        buttonColor = Colors.green[100]!;
        borderColor = Colors.green;
        textColor = Colors.green[900]!;
      } else if (isSelected && !isCorrect) {
        buttonColor = Colors.red[100]!;
        borderColor = Colors.red;
        textColor = Colors.red[900]!;
      } else if (isCorrect) {
        buttonColor = Colors.green[100]!;
        borderColor = Colors.green;
        textColor = Colors.green[900]!;
      }
    }

    if (isComparison) {
      final buttonSize = screenWidth * 0.25;
      return GestureDetector(
        onTap: () => _answerQuestion(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: buttonSize,
          height: buttonSize,
          margin: EdgeInsets.all(screenWidth * 0.01),
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: screenWidth * 0.1,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => _answerQuestion(index),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: _getOptionFontSize(screenWidth),
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getHintText(String type) {
    switch (type) {
      case 'decimal_recognition':
        return 'Select the correct decimal';
      case 'conversion':
        return 'Choose the correct fraction';
      case 'ordering':
        return 'Select the correct order';
      case 'place_value':
        return 'Choose the correct place value';
      default:
        return '';
    }
  }

  String _getAnswerText(Map<String, dynamic> question) {
    final userAnswer = _userAnswers[_currentQuestion];
    if (userAnswer == null) return '';
    
    final isCorrect = userAnswer == question['correctAnswer'];
    
    if (isCorrect) {
      return '🎉 Correct! ${question['explanation']}';
    } else {
      final options = question['options'] as List<String>;
      return '❌ Correct answer: ${options[question['correctAnswer'] as int]}\n${question['explanation']}';
    }
  }

  Widget _buildResultsScreen() {
    final percentage = (_score / _questions.length * 100).toInt();
    String resultText = '';
    String emoji = '';
    Color color = Colors.blue;

    if (percentage >= 90) {
      resultText = 'Decimal Master! Perfect Score!';
      emoji = '🏆';
      color = Colors.blue;
    } else if (percentage >= 80) {
      resultText = 'Great Job! You Understand Decimals Well!';
      emoji = '🎉';
      color = Colors.blue;
    } else if (percentage >= 70) {
      resultText = 'Good Work! Keep Practicing!';
      emoji = '👍';
      color = Colors.orange;
    } else if (percentage >= 60) {
      resultText = 'Almost There! Practice More!';
      emoji = '💪';
      color = Colors.orange;
    } else {
      resultText = 'Keep Learning! Decimals Get Easier!';
      emoji = '📚';
      color = Colors.red;
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Exercise Results',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  emoji,
                  style: TextStyle(fontSize: screenWidth * 0.2),
                ),
                SizedBox(height: screenHeight * 0.02),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(screenWidth * 0.06),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(0, 0, 0, 0.2),
                        blurRadius: 8,
                        offset: const Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        resultText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.065,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: screenWidth * 0.1),
                          SizedBox(width: screenWidth * 0.03),
                          Text(
                            '$_score/${_questions.length}',
                            style: TextStyle(
                              fontSize: screenWidth * 0.09,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF6B8E6B),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      Text(
                        '$percentage% Correct',
                        style: TextStyle(fontSize: screenWidth * 0.05),
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: screenHeight * 0.065,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFBBDEFB),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.06),
                                  side: const BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                              onPressed: _restartExercise,
                              child: Text(
                                'Try Again',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          SizedBox(
                            width: double.infinity,
                            height: screenHeight * 0.065,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.06),
                                  side: const BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Back to Lessons',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class PercentageExerciseScreen extends StatefulWidget {
  final String lessonName;
  final String language;
  final int subLessonIndex;

  const PercentageExerciseScreen({
    super.key,
    required this.lessonName,
    required this.language,
    required this.subLessonIndex,
  });

  @override
  State<PercentageExerciseScreen> createState() => _PercentageExerciseScreenState();
}

class _PercentageExerciseScreenState extends State<PercentageExerciseScreen> {
  int _currentQuestion = 0;
  int _score = 0;
  bool _exerciseCompleted = false;
  List<int?> _userAnswers = List.filled(10, null);
  List<bool> _answeredQuestions = List.filled(10, false);

  final List<Map<String, dynamic>> _questions = [
    {
      'type': 'definition',
      'question': 'What does percentage mean?',
      'options': [
        'A part out of 100',
        'A decimal number',
        'A fraction with denominator 10',
        'A whole number'
      ],
      'correctAnswer': 0,
      'explanation': 'Percentage means "per hundred" - it represents a part out of 100.',
    },
    {
      'type': 'visual_representation',
      'question': 'What percentage of the circle is shaded?',
      'imageDescription': 'Circle divided into 4 equal parts, 1 part shaded',
      'correctAnswer': 2, // 25%
      'options': ['10%', '50%', '25%', '75%'],
      'explanation': '1 out of 4 parts is shaded. 1/4 = 25%.',
    },
    {
      'type': 'fraction_to_percentage',
      'question': 'Convert 1/2 to percentage',
      'fraction': '1/2',
      'correctAnswer': 1, // 50%
      'options': ['25%', '50%', '75%', '100%'],
      'explanation': '1/2 = 50%. Half of 100 is 50.',
    },
    {
      'type': 'fraction_to_percentage',
      'question': 'Convert 3/4 to percentage',
      'fraction': '3/4',
      'correctAnswer': 2, // 75%
      'options': ['25%', '50%', '75%', '100%'],
      'explanation': '3/4 = 75%. Three quarters of 100 is 75.',
    },
    {
      'type': 'fraction_to_percentage',
      'question': 'Convert 1/4 to percentage',
      'fraction': '1/4',
      'correctAnswer': 0, // 25%
      'options': ['25%', '50%', '75%', '100%'],
      'explanation': '1/4 = 25%. One quarter of 100 is 25.',
    },
    {
      'type': 'percentage_to_fraction',
      'question': 'Convert 50% to fraction (simplest form)',
      'percentage': '50%',
      'correctAnswer': 1, // 1/2
      'options': ['1/4', '1/2', '3/4', '5/10'],
      'explanation': '50% = 50/100 = 1/2 (simplified).',
    },
    {
      'type': 'percentage_to_fraction',
      'question': 'Convert 25% to fraction (simplest form)',
      'percentage': '25%',
      'correctAnswer': 0, // 1/4
      'options': ['1/4', '1/2', '3/4', '2/8'],
      'explanation': '25% = 25/100 = 1/4 (simplified).',
    },
    {
      'type': 'percentage_to_fraction',
      'question': 'Convert 75% to fraction (simplest form)',
      'percentage': '75%',
      'correctAnswer': 2, // 3/4
      'options': ['1/4', '1/2', '3/4', '7/10'],
      'explanation': '75% = 75/100 = 3/4 (simplified).',
    },
    {
      'type': 'real_life',
      'question': 'If 25% of a pizza is eaten, how much is left?',
      'correctAnswer': 2, // 75%
      'options': ['25%', '50%', '75%', '100%'],
      'explanation': '100% - 25% = 75% left.',
    },
    {
      'type': 'real_life',
      'question': 'A test has 20 questions. You got 50% correct. How many questions did you get right?',
      'correctAnswer': 1, // 10
      'options': ['5', '10', '15', '20'],
      'explanation': '50% of 20 = 10 questions.',
    },
  ];

  void _answerQuestion(int answerIndex) {
    if (!_answeredQuestions[_currentQuestion]) {
      setState(() {
        _answeredQuestions[_currentQuestion] = true;
        _userAnswers[_currentQuestion] = answerIndex;

        final question = _questions[_currentQuestion];
        final correctAnswer = question['correctAnswer'] as int;
        final isCorrect = answerIndex == correctAnswer;

        if (isCorrect) {
          _score++;
        }
        
        if (_answeredQuestions.every((answered) => answered)) {
          _exerciseCompleted = true;
          _recordExerciseResults();
        }
      });
    }
  }

  void _recordExerciseResults() {
    final percentage = (_score / _questions.length * 100).toInt();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 Exercise completed! Score: $percentage%'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _nextQuestion() {
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestion > 0) {
      setState(() {
        _currentQuestion--;
      });
    }
  }

  void _restartExercise() {
    setState(() {
      _currentQuestion = 0;
      _score = 0;
      _exerciseCompleted = false;
      _userAnswers = List.filled(_questions.length, null);
      _answeredQuestions = List.filled(_questions.length, false);
    });
  }

  // Helper methods for responsive design
  double _getQuestionFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.042;
    if (screenWidth > 600) return screenWidth * 0.038;
    return screenWidth * 0.045;
  }

  double _getFractionFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.09;
    if (screenWidth > 600) return screenWidth * 0.07;
    return screenWidth * 0.11;
  }

  double _getLabelFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.028;
    if (screenWidth > 600) return screenWidth * 0.024;
    return screenWidth * 0.03;
  }

  double _getOptionFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.036;
    if (screenWidth > 600) return screenWidth * 0.032;
    return screenWidth * 0.04;
  }

  Widget _buildVisualRepresentation() {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      width: screenWidth * 0.4,
      height: screenWidth * 0.4,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.purple, width: 3),
      ),
      child: Stack(
        children: [
          // Quarter circles
          CustomPaint(
            size: Size(screenWidth * 0.4, screenWidth * 0.4),
            painter: _QuarterCirclePainter(),
          ),
          // Center lines
          Center(
            child: Container(
              width: screenWidth * 0.4,
              height: 2,
              color: Colors.purple[300],
            ),
          ),
          Center(
            child: Container(
              width: 2,
              height: screenWidth * 0.4,
              color: Colors.purple[300],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_exerciseCompleted) {
      return _buildResultsScreen();
    }

    final currentQuestion = _questions[_currentQuestion];
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Percentage Exercise',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            children: [
              // Header with progress
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.purple[200]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question ${_currentQuestion + 1}/${_questions.length}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[900],
                          ),
                        ),
                        Text(
                          'Percentage Basics',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Colors.purple[700],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.percent, color: Colors.purple, size: screenWidth * 0.06),
                        SizedBox(width: screenWidth * 0.01),
                        Text(
                          '$_score',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[800],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              // Main question container
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(0, 0, 0, 0.15),
                      blurRadius: 8,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Question text
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      child: Text(
                        currentQuestion['question'] as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: _getQuestionFontSize(screenWidth),
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Visual content based on question type
                    if (currentQuestion['type'] == 'visual_representation')
                      Column(
                        children: [
                          _buildVisualRepresentation(),
                          SizedBox(height: screenHeight * 0.02),
                          Text(
                            currentQuestion['imageDescription'] as String,
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      )
                    else if (currentQuestion['type'] == 'fraction_to_percentage')
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.blue, width: 2),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Convert:',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: Colors.blue[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Container(
                              padding: EdgeInsets.all(screenWidth * 0.04),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.blue[300]!, width: 2),
                              ),
                              child: Text(
                                currentQuestion['fraction'] as String,
                                style: TextStyle(
                                  fontSize: _getFractionFontSize(screenWidth),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800],
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '→',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.06,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                Container(
                                  padding: EdgeInsets.all(screenWidth * 0.04),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.blue[300]!, width: 2),
                                  ),
                                  child: Text(
                                    '? %',
                                    style: TextStyle(
                                      fontSize: _getFractionFontSize(screenWidth),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[800],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    else if (currentQuestion['type'] == 'percentage_to_fraction')
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.green, width: 2),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Convert:',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: Colors.green[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Container(
                              padding: EdgeInsets.all(screenWidth * 0.04),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.green[300]!, width: 2),
                              ),
                              child: Text(
                                currentQuestion['percentage'] as String,
                                style: TextStyle(
                                  fontSize: _getFractionFontSize(screenWidth),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[800],
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '→',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.06,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                Container(
                                  padding: EdgeInsets.all(screenWidth * 0.04),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.green[300]!, width: 2),
                                  ),
                                  child: Text(
                                    '?',
                                    style: TextStyle(
                                      fontSize: _getFractionFontSize(screenWidth),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[800],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: screenHeight * 0.03),

                    // Options
                    Column(
                      children: List.generate(
                        (currentQuestion['options'] as List<String>).length,
                        (index) => _buildTextOptionButton(
                          index, 
                          currentQuestion['options'][index] as String
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Explanation
                    if (_answeredQuestions[_currentQuestion])
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        decoration: BoxDecoration(
                          color: (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                              ? Colors.green[50]
                              : Colors.red[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                                ? Colors.green
                                : Colors.red,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              _userAnswers[_currentQuestion] == currentQuestion['correctAnswer']
                                  ? '🎉 Correct!'
                                  : '❌ Incorrect',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: _getOptionFontSize(screenWidth) * 0.9,
                                fontWeight: FontWeight.bold,
                                color: (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                                    ? Colors.green[900]
                                    : Colors.red[900],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              currentQuestion['explanation'] as String,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: _getOptionFontSize(screenWidth) * 0.85,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // Navigation buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: Size(0, screenHeight * 0.065),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.06),
                          side: const BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      onPressed: _currentQuestion > 0 ? _previousQuestion : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_back, size: screenWidth * 0.05),
                          SizedBox(width: screenWidth * 0.02),
                          Text(
                            'Previous',
                            style: TextStyle(fontSize: screenWidth * 0.04),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF59D),
                        foregroundColor: Colors.black,
                        minimumSize: Size(0, screenHeight * 0.065),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.06),
                          side: const BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      onPressed: _answeredQuestions[_currentQuestion]
                          ? () {
                              if (_currentQuestion < _questions.length - 1) {
                                _nextQuestion();
                              } else {
                                _recordExerciseResults();
                                setState(() {
                                  _exerciseCompleted = true;
                                });
                              }
                            }
                          : null,
                      child: Text(
                        _currentQuestion == _questions.length - 1
                            ? 'Finish Exercise'
                            : 'Next Question',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
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

  Widget _buildTextOptionButton(int index, String text) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isAnswered = _answeredQuestions[_currentQuestion];
    final isSelected = _userAnswers[_currentQuestion] == index;
    final isCorrect = index == _questions[_currentQuestion]['correctAnswer'];

    Color buttonColor = Colors.white;
    Color borderColor = Colors.black;
    Color textColor = Colors.black;

    if (isAnswered) {
      if (isSelected && isCorrect) {
        buttonColor = Colors.green[100]!;
        borderColor = Colors.green;
        textColor = Colors.green[900]!;
      } else if (isSelected && !isCorrect) {
        buttonColor = Colors.red[100]!;
        borderColor = Colors.red;
        textColor = Colors.red[900]!;
      } else if (isCorrect) {
        buttonColor = Colors.green[100]!;
        borderColor = Colors.green;
        textColor = Colors.green[900]!;
      }
    }

    return GestureDetector(
      onTap: () => _answerQuestion(index),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: _getOptionFontSize(screenWidth),
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultsScreen() {
    final percentage = (_score / _questions.length * 100).toInt();
    String resultText = '';
    String emoji = '';
    Color color = Colors.purple;

    if (percentage >= 90) {
      resultText = 'Excellent! Perfect Score!';
      emoji = '🏆';
      color = Colors.purple;
    } else if (percentage >= 80) {
      resultText = 'Great Job! You\'re Amazing!';
      emoji = '🎉';
      color = Colors.purple;
    } else if (percentage >= 70) {
      resultText = 'Good Work! Keep Going!';
      emoji = '👍';
      color = Colors.orange;
    } else if (percentage >= 60) {
      resultText = 'Not Bad! Practice More!';
      emoji = '💪';
      color = Colors.orange;
    } else {
      resultText = 'Keep Practicing! You Can Do It!';
      emoji = '📚';
      color = Colors.red;
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Exercise Results',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  emoji,
                  style: TextStyle(fontSize: screenWidth * 0.2),
                ),
                SizedBox(height: screenHeight * 0.02),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(screenWidth * 0.06),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(0, 0, 0, 0.2),
                        blurRadius: 8,
                        offset: const Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        resultText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.065,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.percent, color: Colors.green, size: screenWidth * 0.1),
                          SizedBox(width: screenWidth * 0.03),
                          Text(
                            '$_score/${_questions.length}',
                            style: TextStyle(
                              fontSize: screenWidth * 0.09,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF6B8E6B),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      Text(
                        '$percentage% Correct',
                        style: TextStyle(fontSize: screenWidth * 0.05),
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: screenHeight * 0.065,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFF59D),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.06),
                                  side: const BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                              onPressed: _restartExercise,
                              child: Text(
                                'Try Again',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          SizedBox(
                            width: double.infinity,
                            height: screenHeight * 0.065,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.06),
                                  side: const BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Back to Lessons',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuarterCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.purple[300]!
      ..style = PaintingStyle.fill;

    final radius = size.width / 2;
    final center = Offset(radius, radius);

    // Draw one quarter circle (top-left)
    final path = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(center.dx, 0)
      ..arcTo(
        Rect.fromCircle(center: center, radius: radius),
        -3.14159, // -180 degrees
        1.5708, // 90 degrees
        false,
      )
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}



class TimeExerciseScreen extends StatefulWidget {
  final String lessonName;
  final String language;
  final int subLessonIndex;

  const TimeExerciseScreen({
    super.key,
    required this.lessonName,
    required this.language,
    required this.subLessonIndex,
  });

  @override
  State<TimeExerciseScreen> createState() => _TimeExerciseScreenState();
}

class _TimeExerciseScreenState extends State<TimeExerciseScreen> {
  int _currentQuestion = 0;
  int _score = 0;
  bool _exerciseCompleted = false;
  List<int?> _userAnswers = List.filled(10, null);
  List<bool> _answeredQuestions = List.filled(10, false);

  final List<Map<String, dynamic>> _questions = [
    {
      'type': 'clock_analog',
      'question': 'What time does this analog clock show?',
      'hour': 3,
      'minute': 0,
      'image': 'assets/time/3_00.png', // You would need actual images
      'correctAnswer': 1, // 3:00
      'options': ['2:30', '3:00', '3:15', '12:03'],
      'explanation': 'The hour hand is at 3, minute hand is at 12. This shows 3:00.',
    },
    {
      'type': 'clock_digital',
      'question': 'Which analog clock matches the digital time 04:45?',
      'digitalTime': '04:45',
      'correctAnswer': 2, // Third option
      'options': [
        'Hour hand between 4-5, minute at 9',
        'Hour hand at 4, minute at 9',
        'Hour hand between 4-5, minute at 9 (correct)',
        'Hour hand at 5, minute at 9'
      ],
      'explanation': '04:45 means hour hand between 4 and 5, minute hand at 9 (45 minutes).',
    },
    {
      'type': 'am_pm',
      'question': 'School starts at 8:30 AM. What does AM mean?',
      'correctAnswer': 0, // Morning
      'options': ['Morning (before noon)', 'Afternoon', 'Evening', 'Night'],
      'explanation': 'AM means Ante Meridiem (before noon), from midnight to 11:59 AM.',
    },
    {
      'type': 'am_pm',
      'question': 'Dinner time is 7:00 PM. What does PM mean?',
      'correctAnswer': 1, // Afternoon to night
      'options': ['Morning', 'Afternoon to night', 'Only evening', 'Midnight'],
      'explanation': 'PM means Post Meridiem (after noon), from 12:00 PM to 11:59 PM.',
    },
    {
      'type': 'time_conversion',
      'question': 'How many minutes are in 2 hours?',
      'correctAnswer': 3, // 120 minutes
      'options': ['60 minutes', '90 minutes', '100 minutes', '120 minutes'],
      'explanation': '1 hour = 60 minutes, so 2 hours = 2 × 60 = 120 minutes.',
    },
    {
      'type': 'time_conversion',
      'question': 'How many seconds are in 3 minutes?',
      'correctAnswer': 2, // 180 seconds
      'options': ['60 seconds', '120 seconds', '180 seconds', '300 seconds'],
      'explanation': '1 minute = 60 seconds, so 3 minutes = 3 × 60 = 180 seconds.',
    },
    {
      'type': 'time_problem',
      'question': 'If a movie starts at 2:30 PM and ends at 4:15 PM, how long is the movie?',
      'correctAnswer': 1, // 1 hour 45 minutes
      'options': ['1 hour 30 minutes', '1 hour 45 minutes', '2 hours', '2 hours 15 minutes'],
      'explanation': 'From 2:30 to 3:30 = 1 hour, from 3:30 to 4:15 = 45 minutes. Total: 1 hour 45 minutes.',
    },
    {
      'type': 'time_problem',
      'question': 'Breakfast is at 7:00 AM. Lunch is 4 hours later. What time is lunch?',
      'correctAnswer': 2, // 11:00 AM
      'options': ['10:00 AM', '10:30 AM', '11:00 AM', '11:30 AM'],
      'explanation': '7:00 AM + 4 hours = 11:00 AM.',
    },
    {
      'type': 'time_write',
      'question': 'Write "quarter past nine in the morning" in digital time:',
      'correctAnswer': 1, // 9:15 AM
      'options': ['9:00 AM', '9:15 AM', '9:30 AM', '9:45 AM'],
      'explanation': 'Quarter past nine = 9:15. Morning means AM.',
    },
    {
      'type': 'time_write',
      'question': 'Write "half past eight in the evening" in digital time:',
      'correctAnswer': 3, // 8:30 PM
      'options': ['8:00 PM', '8:15 PM', '8:20 PM', '8:30 PM'],
      'explanation': 'Half past eight = 8:30. Evening means PM.',
    },
  ];

  void _answerQuestion(int answerIndex) {
    if (!_answeredQuestions[_currentQuestion]) {
      setState(() {
        _answeredQuestions[_currentQuestion] = true;
        _userAnswers[_currentQuestion] = answerIndex;

        final question = _questions[_currentQuestion];
        final correctAnswer = question['correctAnswer'] as int;
        final isCorrect = answerIndex == correctAnswer;

        if (isCorrect) {
          _score++;
        }
        
        if (_answeredQuestions.every((answered) => answered)) {
          _exerciseCompleted = true;
          _recordExerciseResults();
        }
      });
    }
  }

  void _recordExerciseResults() {
    final percentage = (_score / _questions.length * 100).toInt();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 Time exercise completed! Score: $percentage%'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _nextQuestion() {
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestion > 0) {
      setState(() {
        _currentQuestion--;
      });
    }
  }

  void _restartExercise() {
    setState(() {
      _currentQuestion = 0;
      _score = 0;
      _exerciseCompleted = false;
      _userAnswers = List.filled(_questions.length, null);
      _answeredQuestions = List.filled(_questions.length, false);
    });
  }

  // Helper methods for responsive design
  double _getQuestionFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.042;
    if (screenWidth > 600) return screenWidth * 0.038;
    return screenWidth * 0.045;
  }

  double _getOptionFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.036;
    if (screenWidth > 600) return screenWidth * 0.032;
    return screenWidth * 0.04;
  }

  double _getClockFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.08;
    if (screenWidth > 600) return screenWidth * 0.06;
    return screenWidth * 0.09;
  }

  @override
  Widget build(BuildContext context) {
    if (_exerciseCompleted) {
      return _buildResultsScreen();
    }

    final currentQuestion = _questions[_currentQuestion];
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Time Exercise',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            children: [
              // Header with progress
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question ${_currentQuestion + 1}/${_questions.length}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                        ),
                        Text(
                          'Time Skills',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.blue, size: screenWidth * 0.06),
                        SizedBox(width: screenWidth * 0.01),
                        Text(
                          '$_score',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              // Main question container
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(0, 0, 0, 0.15),
                      blurRadius: 8,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Question text
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      child: Text(
                        currentQuestion['question'] as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: _getQuestionFontSize(screenWidth),
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Visual representation based on question type
                    _buildTimeVisual(currentQuestion, screenWidth, screenHeight),

                    SizedBox(height: screenHeight * 0.03),

                    // Options
                    Column(
                      children: List.generate(
                        (currentQuestion['options'] as List<String>).length,
                        (index) => _buildTextOptionButton(
                          index, 
                          currentQuestion['options'][index] as String
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Explanation
                    if (_answeredQuestions[_currentQuestion])
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        decoration: BoxDecoration(
                          color: (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                              ? Colors.green[50]
                              : Colors.red[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                                ? Colors.green
                                : Colors.red,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _getAnswerText(currentQuestion),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: _getOptionFontSize(screenWidth) * 0.9,
                            fontWeight: FontWeight.bold,
                            color: (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                                ? Colors.green[900]
                                : Colors.red[900],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // Navigation buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: Size(0, screenHeight * 0.065),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.06),
                          side: const BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      onPressed: _currentQuestion > 0 ? _previousQuestion : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_back, size: screenWidth * 0.05),
                          SizedBox(width: screenWidth * 0.02),
                          Text(
                            'Previous',
                            style: TextStyle(fontSize: screenWidth * 0.04),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF59D),
                        foregroundColor: Colors.black,
                        minimumSize: Size(0, screenHeight * 0.065),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.06),
                          side: const BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      onPressed: _answeredQuestions[_currentQuestion]
                          ? () {
                              if (_currentQuestion < _questions.length - 1) {
                                _nextQuestion();
                              } else {
                                _recordExerciseResults();
                                setState(() {
                                  _exerciseCompleted = true;
                                });
                              }
                            }
                          : null,
                      child: Text(
                        _currentQuestion == _questions.length - 1
                            ? 'Finish Exercise'
                            : 'Next Question',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
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

  Widget _buildTimeVisual(Map<String, dynamic> question, double screenWidth, double screenHeight) {
    final type = question['type'] as String;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),
          
          if (type == 'clock_analog')
            Column(
              children: [
                // Analog clock visualization
                Container(
                  width: screenWidth * 0.4,
                  height: screenWidth * 0.4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 4),
                  ),
                  child: Stack(
                    children: [
                      // Clock numbers
                      ...List.generate(12, (index) {
                        final angle = (index * 30) * 3.14159 / 180;
                        final radius = screenWidth * 0.15;
                        final x = radius * -sin(angle);
                        final y = radius * -cos(angle);
                        
                        return Positioned(
                          left: screenWidth * 0.2 + x - 10,
                          top: screenWidth * 0.2 + y - 10,
                          child: Text(
                            index == 0 ? '12' : index.toString(),
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }),
                      
                      // Hour hand
                      Transform.rotate(
                        angle: (question['hour']! * 30 + question['minute']! * 0.5) * 3.14159 / 180,
                        child: Container(
                          width: 4,
                          height: screenWidth * 0.1,
                          color: Colors.black,
                          margin: EdgeInsets.only(bottom: screenWidth * 0.1),
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                      
                      // Minute hand
                      Transform.rotate(
                        angle: question['minute']! * 6 * 3.14159 / 180,
                        child: Container(
                          width: 3,
                          height: screenWidth * 0.15,
                          color: Colors.black,
                          margin: EdgeInsets.only(bottom: screenWidth * 0.15),
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                      
                      // Center circle
                      Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  'Analog Clock',
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              ],
            )
          else if (type == 'clock_digital')
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    question['digitalTime'] as String,
                    style: TextStyle(
                      fontSize: _getClockFontSize(screenWidth),
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontFamily: 'Digital',
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  'Digital Clock Display',
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            )
          else if (type == 'am_pm')
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.06,
                    vertical: screenHeight * 0.015,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.orange, width: 2),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'AM',
                        style: TextStyle(
                          fontSize: screenWidth * 0.08,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[800],
                        ),
                      ),
                      Text(
                        'Morning',
                        style: TextStyle(
                          fontSize: screenWidth * 0.03,
                          color: Colors.orange[600],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: screenWidth * 0.05),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.06,
                    vertical: screenHeight * 0.015,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.purple[100],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.purple, width: 2),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'PM',
                        style: TextStyle(
                          fontSize: screenWidth * 0.08,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple[800],
                        ),
                      ),
                      Text(
                        'Afternoon/Night',
                        style: TextStyle(
                          fontSize: screenWidth * 0.03,
                          color: Colors.purple[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          else if (type == 'time_conversion' || type == 'time_problem' || type == 'time_write')
            Container(
              padding: EdgeInsets.all(screenWidth * 0.05),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: Column(
                children: [
                  if (type == 'time_conversion')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.timer, size: screenWidth * 0.08, color: Colors.green),
                        SizedBox(width: screenWidth * 0.03),
                        Text(
                          'Time Conversion',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                      ],
                    )
                  else if (type == 'time_problem')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calculate, size: screenWidth * 0.08, color: Colors.green),
                        SizedBox(width: screenWidth * 0.03),
                        Text(
                          'Time Problem Solving',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                      ],
                    )
                  else if (type == 'time_write')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit, size: screenWidth * 0.08, color: Colors.green),
                        SizedBox(width: screenWidth * 0.03),
                        Text(
                          'Writing Time',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextOptionButton(int index, String text) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isAnswered = _answeredQuestions[_currentQuestion];
    final isSelected = _userAnswers[_currentQuestion] == index;
    final isCorrect = index == _questions[_currentQuestion]['correctAnswer'];

    Color buttonColor = Colors.white;
    Color borderColor = Colors.black;
    Color textColor = Colors.black;

    if (isAnswered) {
      if (isSelected && isCorrect) {
        buttonColor = Colors.green[100]!;
        borderColor = Colors.green;
        textColor = Colors.green[900]!;
      } else if (isSelected && !isCorrect) {
        buttonColor = Colors.red[100]!;
        borderColor = Colors.red;
        textColor = Colors.red[900]!;
      } else if (isCorrect) {
        buttonColor = Colors.green[100]!;
        borderColor = Colors.green;
        textColor = Colors.green[900]!;
      }
    }

    return GestureDetector(
      onTap: () => _answerQuestion(index),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: _getOptionFontSize(screenWidth),
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getAnswerText(Map<String, dynamic> question) {
    final userAnswer = _userAnswers[_currentQuestion];
    
    if (userAnswer == null) return '';
    
    final isCorrect = userAnswer == question['correctAnswer'];
    
    if (isCorrect) {
      return '🎉 Correct! ${question['explanation']}';
    } else {
      final options = question['options'] as List<String>;
      return '❌ Correct answer: ${options[question['correctAnswer'] as int]}\n${question['explanation']}';
    }
  }

  Widget _buildResultsScreen() {
    final percentage = (_score / _questions.length * 100).toInt();
    String resultText = '';
    String emoji = '';
    Color color = Colors.blue;

    if (percentage >= 90) {
      resultText = 'Perfect Timing! You\'re a Time Master!';
      emoji = '⏰🏆';
      color = Colors.blue;
    } else if (percentage >= 80) {
      resultText = 'Excellent Work! You Tell Time Perfectly!';
      emoji = '🎉⏱️';
      color = Colors.blue;
    } else if (percentage >= 70) {
      resultText = 'Great Job! You Understand Time Well!';
      emoji = '👍🕐';
      color = Colors.green;
    } else if (percentage >= 60) {
      resultText = 'Good Effort! Keep Practicing!';
      emoji = '💪🕑';
      color = Colors.orange;
    } else {
      resultText = 'Keep Learning! Time Will Tell!';
      emoji = '📚⏳';
      color = Colors.red;
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Time Exercise Results',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  emoji,
                  style: TextStyle(fontSize: screenWidth * 0.2),
                ),
                SizedBox(height: screenHeight * 0.02),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(screenWidth * 0.06),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(0, 0, 0, 0.2),
                        blurRadius: 8,
                        offset: const Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        resultText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.065,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.access_time, color: Colors.blue, size: screenWidth * 0.1),
                          SizedBox(width: screenWidth * 0.03),
                          Text(
                            '$_score/${_questions.length}',
                            style: TextStyle(
                              fontSize: screenWidth * 0.09,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      Text(
                        '$percentage% Correct',
                        style: TextStyle(fontSize: screenWidth * 0.05),
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: screenHeight * 0.065,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFF59D),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.06),
                                  side: const BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                              onPressed: _restartExercise,
                              child: Text(
                                'Try Again',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          SizedBox(
                            width: double.infinity,
                            height: screenHeight * 0.065,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.06),
                                  side: const BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Back to Lessons',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class DaysWeeksMonthsExerciseScreen extends StatefulWidget {
  final String lessonName;
  final String language;
  final int subLessonIndex;

  const DaysWeeksMonthsExerciseScreen({
    super.key,
    required this.lessonName,
    required this.language,
    required this.subLessonIndex,
  });

  @override
  State<DaysWeeksMonthsExerciseScreen> createState() => _DaysWeeksMonthsExerciseScreenState();
}

class _DaysWeeksMonthsExerciseScreenState extends State<DaysWeeksMonthsExerciseScreen> {
  int _currentQuestion = 0;
  int _score = 0;
  bool _exerciseCompleted = false;
  List<int?> _userAnswers = List.filled(10, null);
  List<bool> _answeredQuestions = List.filled(10, false);

  final List<Map<String, dynamic>> _questions = [
    {
      'type': 'days_count',
      'question': 'How many days are in a week?',
      'correctAnswer': 2, // 7 days
      'options': ['5 days', '6 days', '7 days', '8 days'],
      'explanation': 'There are 7 days in a week: Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday.',
    },
    {
      'type': 'days_order',
      'question': 'What day comes after Wednesday?',
      'correctAnswer': 2, // Thursday
      'options': ['Tuesday', 'Friday', 'Thursday', 'Saturday'],
      'explanation': 'The days order is: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday.',
    },
    {
      'type': 'days_order',
      'question': 'What day comes before Monday?',
      'correctAnswer': 3, // Sunday
      'options': ['Saturday', 'Friday', 'Tuesday', 'Sunday'],
      'explanation': 'Sunday comes before Monday. Week starts with Sunday or Monday depending on culture.',
    },
    {
      'type': 'months_count',
      'question': 'How many months are in a year?',
      'correctAnswer': 1, // 12 months
      'options': ['10 months', '12 months', '13 months', '11 months'],
      'explanation': 'There are 12 months in a year: January to December.',
    },
    {
      'type': 'months_order',
      'question': 'What month comes after June?',
      'correctAnswer': 0, // July
      'options': ['July', 'May', 'August', 'September'],
      'explanation': 'Months order: January, February, March, April, May, June, July, August, September, October, November, December.',
    },
    {
      'type': 'months_order',
      'question': 'What month comes before October?',
      'correctAnswer': 3, // September
      'options': ['November', 'August', 'July', 'September'],
      'explanation': 'September (9th month) comes before October (10th month).',
    },
    {
      'type': 'daytime_activity',
      'question': 'Brushing teeth is usually done in the:',
      'correctAnswer': 1, // Morning
      'options': ['Afternoon', 'Morning', 'Night', 'Evening'],
      'explanation': 'We usually brush our teeth in the morning after waking up.',
    },
    {
      'type': 'daytime_activity',
      'question': 'Eating dinner is usually done in the:',
      'correctAnswer': 3, // Night
      'options': ['Morning', 'Afternoon', 'Evening', 'Night'],
      'explanation': 'Dinner is typically eaten in the evening or night time.',
    },
    {
      'type': 'am_pm_activity',
      'question': 'School usually starts at 8:00 ___.',
      'correctAnswer': 0, // AM
      'options': ['AM', 'PM', 'Noon', 'Midnight'],
      'explanation': 'School starts in the morning, so it\'s 8:00 AM.',
    },
    {
      'type': 'am_pm_activity',
      'question': 'Watching a movie at 7:30 ___.',
      'correctAnswer': 1, // PM
      'options': ['AM', 'PM', 'Morning', 'Afternoon'],
      'explanation': 'Movies are usually watched in the evening, so it\'s 7:30 PM.',
    },
  ];

  void _answerQuestion(int answerIndex) {
    if (!_answeredQuestions[_currentQuestion]) {
      setState(() {
        _answeredQuestions[_currentQuestion] = true;
        _userAnswers[_currentQuestion] = answerIndex;

        final question = _questions[_currentQuestion];
        final correctAnswer = question['correctAnswer'] as int;
        final isCorrect = answerIndex == correctAnswer;

        if (isCorrect) {
          _score++;
        }
        
        if (_answeredQuestions.every((answered) => answered)) {
          _exerciseCompleted = true;
          _recordExerciseResults();
        }
      });
    }
  }

  void _recordExerciseResults() {
    final percentage = (_score / _questions.length * 100).toInt();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 Calendar exercise completed! Score: $percentage%'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _nextQuestion() {
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestion > 0) {
      setState(() {
        _currentQuestion--;
      });
    }
  }

  void _restartExercise() {
    setState(() {
      _currentQuestion = 0;
      _score = 0;
      _exerciseCompleted = false;
      _userAnswers = List.filled(_questions.length, null);
      _answeredQuestions = List.filled(_questions.length, false);
    });
  }

  // Helper methods for responsive design
  double _getQuestionFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.042;
    if (screenWidth > 600) return screenWidth * 0.038;
    return screenWidth * 0.045;
  }

  double _getOptionFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.036;
    if (screenWidth > 600) return screenWidth * 0.032;
    return screenWidth * 0.04;
  }

  double _getCalendarFontSize(double screenWidth) {
    if (screenWidth < 360) return screenWidth * 0.06;
    if (screenWidth > 600) return screenWidth * 0.05;
    return screenWidth * 0.07;
  }

  @override
  Widget build(BuildContext context) {
    if (_exerciseCompleted) {
      return _buildResultsScreen();
    }

    final currentQuestion = _questions[_currentQuestion];
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Days, Weeks & Months',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            children: [
              // Header with progress
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question ${_currentQuestion + 1}/${_questions.length}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[900],
                          ),
                        ),
                        Text(
                          'Calendar Skills',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.green, size: screenWidth * 0.06),
                        SizedBox(width: screenWidth * 0.01),
                        Text(
                          '$_score',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              // Main question container
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(0, 0, 0, 0.15),
                      blurRadius: 8,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Question text
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      child: Text(
                        currentQuestion['question'] as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: _getQuestionFontSize(screenWidth),
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Visual representation based on question type
                    _buildCalendarVisual(currentQuestion, screenWidth, screenHeight),

                    SizedBox(height: screenHeight * 0.03),

                    // Options
                    Column(
                      children: List.generate(
                        (currentQuestion['options'] as List<String>).length,
                        (index) => _buildTextOptionButton(
                          index, 
                          currentQuestion['options'][index] as String
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Explanation
                    if (_answeredQuestions[_currentQuestion])
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        decoration: BoxDecoration(
                          color: (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                              ? Colors.green[50]
                              : Colors.red[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                                ? Colors.green
                                : Colors.red,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _getAnswerText(currentQuestion),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: _getOptionFontSize(screenWidth) * 0.9,
                            fontWeight: FontWeight.bold,
                            color: (_userAnswers[_currentQuestion] == currentQuestion['correctAnswer'])
                                ? Colors.green[900]
                                : Colors.red[900],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // Navigation buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: Size(0, screenHeight * 0.065),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.06),
                          side: const BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      onPressed: _currentQuestion > 0 ? _previousQuestion : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_back, size: screenWidth * 0.05),
                          SizedBox(width: screenWidth * 0.02),
                          Text(
                            'Previous',
                            style: TextStyle(fontSize: screenWidth * 0.04),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF59D),
                        foregroundColor: Colors.black,
                        minimumSize: Size(0, screenHeight * 0.065),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.06),
                          side: const BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      onPressed: _answeredQuestions[_currentQuestion]
                          ? () {
                              if (_currentQuestion < _questions.length - 1) {
                                _nextQuestion();
                              } else {
                                _recordExerciseResults();
                                setState(() {
                                  _exerciseCompleted = true;
                                });
                              }
                            }
                          : null,
                      child: Text(
                        _currentQuestion == _questions.length - 1
                            ? 'Finish Exercise'
                            : 'Next Question',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
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

  Widget _buildCalendarVisual(Map<String, dynamic> question, double screenWidth, double screenHeight) {
    final type = question['type'] as String;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),
          
          if (type == 'days_count' || type == 'days_order')
            Column(
              children: [
                Text(
                  'Days of the Week',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Wrap(
                  spacing: screenWidth * 0.02,
                  runSpacing: screenWidth * 0.02,
                  alignment: WrapAlignment.center,
                  children: _buildDaysOfWeek(screenWidth),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  '7 days in total',
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            )
          else if (type == 'months_count' || type == 'months_order')
            Column(
              children: [
                Text(
                  'Months of the Year',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Container(
                  height: screenHeight * 0.2,
                  child: GridView.count(
                    crossAxisCount: 4,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      'Jan', 'Feb', 'Mar', 'Apr',
                      'May', 'Jun', 'Jul', 'Aug',
                      'Sep', 'Oct', 'Nov', 'Dec',
                    ].map((month) => Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[300]!),
                      ),
                      child: Center(
                        child: Text(
                          month,
                          style: TextStyle(
                            fontSize: _getCalendarFontSize(screenWidth) * 0.8,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                      ),
                    )).toList(),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  '12 months in total',
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            )
          else if (type == 'daytime_activity')
            Column(
              children: [
                Text(
                  'Time of Day',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTimeOfDayChip('Morning', Icons.wb_sunny, Colors.yellow[700]!, screenWidth),
                    _buildTimeOfDayChip('Afternoon', Icons.sunny, Colors.orange, screenWidth),
                    _buildTimeOfDayChip('Night', Icons.nights_stay, Colors.indigo, screenWidth),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                if (question['question'].toString().contains('Brushing'))
                  Icon(Icons.brush, size: screenWidth * 0.12, color: Colors.blue)
                else if (question['question'].toString().contains('Eating'))
                  Icon(Icons.restaurant, size: screenWidth * 0.12, color: Colors.red)
                else if (question['question'].toString().contains('School'))
                  Icon(Icons.school, size: screenWidth * 0.12, color: Colors.green)
                else if (question['question'].toString().contains('Watching'))
                  Icon(Icons.movie, size: screenWidth * 0.12, color: Colors.purple),
              ],
            )
          else if (type == 'am_pm_activity')
            Column(
              children: [
                Text(
                  'AM vs PM',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[800],
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06,
                        vertical: screenHeight * 0.015,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.yellow[100],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.yellow[700]!, width: 2),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'AM',
                            style: TextStyle(
                              fontSize: screenWidth * 0.08,
                              fontWeight: FontWeight.bold,
                              color: Colors.yellow[900],
                            ),
                          ),
                          Text(
                            'Morning\n(12:00 AM - 11:59 AM)',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: screenWidth * 0.025,
                              color: Colors.yellow[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06,
                        vertical: screenHeight * 0.015,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.indigo[100],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.indigo, width: 2),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'PM',
                            style: TextStyle(
                              fontSize: screenWidth * 0.08,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo[900],
                            ),
                          ),
                          Text(
                            'Afternoon/Night\n(12:00 PM - 11:59 PM)',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: screenWidth * 0.025,
                              color: Colors.indigo[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                if (question['question'].toString().contains('School'))
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.school, color: Colors.green, size: screenWidth * 0.08),
                      SizedBox(width: screenWidth * 0.02),
                      Text(
                        '8:00',
                        style: TextStyle(
                          fontSize: screenWidth * 0.07,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                else if (question['question'].toString().contains('Watching'))
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.movie, color: Colors.purple, size: screenWidth * 0.08),
                      SizedBox(width: screenWidth * 0.02),
                      Text(
                        '7:30',
                        style: TextStyle(
                          fontSize: screenWidth * 0.07,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
        ],
      ),
    );
  }

  List<Widget> _buildDaysOfWeek(double screenWidth) {
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final colors = [
      Colors.red, Colors.orange, Colors.yellow[700]!, Colors.green,
      Colors.blue, Colors.indigo, Colors.purple
    ];
    
    return List.generate(7, (index) => Container(
      width: screenWidth * 0.12,
      height: screenWidth * 0.12,
      decoration: BoxDecoration(
        color: colors[index],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: colors[index].withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          days[index],
          style: TextStyle(
            fontSize: screenWidth * 0.035,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ));
  }

  Widget _buildTimeOfDayChip(String label, IconData icon, Color color, double screenWidth) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(screenWidth * 0.03),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Icon(icon, color: color, size: screenWidth * 0.06),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: screenWidth * 0.03,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildTextOptionButton(int index, String text) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isAnswered = _answeredQuestions[_currentQuestion];
    final isSelected = _userAnswers[_currentQuestion] == index;
    final isCorrect = index == _questions[_currentQuestion]['correctAnswer'];

    Color buttonColor = Colors.white;
    Color borderColor = Colors.black;
    Color textColor = Colors.black;

    if (isAnswered) {
      if (isSelected && isCorrect) {
        buttonColor = Colors.green[100]!;
        borderColor = Colors.green;
        textColor = Colors.green[900]!;
      } else if (isSelected && !isCorrect) {
        buttonColor = Colors.red[100]!;
        borderColor = Colors.red;
        textColor = Colors.red[900]!;
      } else if (isCorrect) {
        buttonColor = Colors.green[100]!;
        borderColor = Colors.green;
        textColor = Colors.green[900]!;
      }
    }

    return GestureDetector(
      onTap: () => _answerQuestion(index),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: _getOptionFontSize(screenWidth),
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getAnswerText(Map<String, dynamic> question) {
    final userAnswer = _userAnswers[_currentQuestion];
    
    if (userAnswer == null) return '';
    
    final isCorrect = userAnswer == question['correctAnswer'];
    
    if (isCorrect) {
      return '🎉 Correct! ${question['explanation']}';
    } else {
      final options = question['options'] as List<String>;
      return '❌ Correct answer: ${options[question['correctAnswer'] as int]}\n${question['explanation']}';
    }
  }

  Widget _buildResultsScreen() {
    final percentage = (_score / _questions.length * 100).toInt();
    String resultText = '';
    String emoji = '';
    Color color = Colors.green;

    if (percentage >= 90) {
      resultText = 'Calendar Master! Perfect Score!';
      emoji = '📅🏆';
      color = Colors.green;
    } else if (percentage >= 80) {
      resultText = 'Excellent! You Know Your Calendar!';
      emoji = '🎉📆';
      color = Colors.green;
    } else if (percentage >= 70) {
      resultText = 'Great Work! Calendar Expert!';
      emoji = '👍📅';
      color = Colors.blue;
    } else if (percentage >= 60) {
      resultText = 'Good Job! Keep Learning!';
      emoji = '💪📆';
      color = Colors.orange;
    } else {
      resultText = 'Keep Practicing! You\'ll Get It!';
      emoji = '📚🗓️';
      color = Colors.red;
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Calendar Exercise Results',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  emoji,
                  style: TextStyle(fontSize: screenWidth * 0.2),
                ),
                SizedBox(height: screenHeight * 0.02),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(screenWidth * 0.06),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(0, 0, 0, 0.2),
                        blurRadius: 8,
                        offset: const Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        resultText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.065,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_today, color: Colors.green, size: screenWidth * 0.1),
                          SizedBox(width: screenWidth * 0.03),
                          Text(
                            '$_score/${_questions.length}',
                            style: TextStyle(
                              fontSize: screenWidth * 0.09,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[800],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      Text(
                        '$percentage% Correct',
                        style: TextStyle(fontSize: screenWidth * 0.05),
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: screenHeight * 0.065,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFF59D),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.06),
                                  side: const BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                              onPressed: _restartExercise,
                              child: Text(
                                'Try Again',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          SizedBox(
                            width: double.infinity,
                            height: screenHeight * 0.065,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.06),
                                  side: const BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Back to Lessons',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



// ============ EXERCISE SCREEN ============
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
          _recordExerciseResults();
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

  void _recordExerciseResults() {
    final percentage = _score;
    
    progressManager.recordExerciseScore(
      widget.lessonName,
      widget.language,
      widget.subLessonIndex,
      'Basic Exercise',
      _score,
      _totalQuestions,
      _score,
      percentage.toDouble(),
    );
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${widget.lessonName} Exercise',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
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
              child: Column(
                children: [
                  Icon(Icons.question_answer, size: 40, color: Colors.black),
                  const SizedBox(height: 10),
                  const Text(
                    'What number comes AFTER the given number?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Question ${_currentQuestion + 1}/$_totalQuestions',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
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
                      color: const Color.fromRGBO(0, 0, 0, 0.1),
                      blurRadius: 6,
                      offset: const Offset(3, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'What comes AFTER:',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${_numbers[_currentQuestion]}',
                      style: const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
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
                        style: TextStyle(fontWeight: FontWeight.bold),
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
                          _recordExerciseResults();
                        }
                      },
                      child: Text(
                        _currentQuestion == _totalQuestions - 1 ? 'Finish' : 'Next',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
      backgroundColor: Colors.white, // White background
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Sign Dictionary',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Lora-Regular',
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
              'Choose a',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lora-Regular',
              ),
            ),
            Text(
              'Category',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lora-Regular',
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
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'Lora-Regular',
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
      backgroundColor: Colors.white, // White background
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Lora-Regular',
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
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Poppins-Regular',
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
        Text(
          'Video not found',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Lora-Regular',
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFF59D),
            foregroundColor: Colors.black,
          ),
          onPressed: _initializeVideo,
          child: Text(
            'Try Again',
            style: TextStyle(
              fontFamily: 'Lora-Regular',
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
              Text(
                'Speed:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Lora-Regular',
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
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lora-Regular',
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
                      style: TextStyle(
                        fontFamily: 'Poppins-Regular',
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
    backgroundColor: Colors.white, // White background
    appBar: AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Lora-Regular',
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
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Lora-Regular',
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
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Poppins-Regular',
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (videoAsset == null)
                    Text(
                      '(Video coming soon)',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins-Regular',
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
  
  // ADDED: State for tracking which option is selected
  bool _isStudentSelected = false;
  bool _isSenyamatikardSelected = false;

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

  // ADDED: Function to handle option selection
  void _selectStudent() {
    setState(() {
      _isStudentSelected = true;
      _isSenyamatikardSelected = false;
    });
  }

  // ADDED: Function to handle Senyamatikard selection
  void _selectSenyamatikard() async {
    // Launch the Senyamatikard website
    await _launchSenyamatikard();
    
    // Update UI state
    if (mounted) {
      setState(() {
        _isStudentSelected = false;
        _isSenyamatikardSelected = true;
      });
    }
  }

  // ADDED: Function to launch Senyamatikard website
  Future<void> _launchSenyamatikard() async {
    final Uri url = Uri.parse('https://senyamatikard.figma.site/');
    
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cannot open website. Please check your connection.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isVerySmallScreen = screenHeight < 600;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.white, // White background
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
                            fontFamily: 'Lora-Regular',
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
                            fontFamily: 'Lora-Regular',
                            color: Colors.black,
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
                      color: Colors.white, // White background
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
                        // ADDED: CONDITIONAL RENDERING - Show options first
                        if (!_isStudentSelected && !_isSenyamatikardSelected)
                          Column(
                            children: [
                              // FOR STUDENT BUTTON
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
                                  onPressed: _selectStudent,
                                  child: Text(
                                    'For Student',
                                    style: TextStyle(
                                      fontSize: isVerySmallScreen
                                          ? 17
                                          : isTablet
                                              ? 24
                                              : 21,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Lora-Regular',
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: isVerySmallScreen ? 18 : 25),

                              // SENYAMATIKARD BUTTON
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
                                  onPressed: _selectSenyamatikard,
                                  child: Text(
                                    'Senyamatikard',
                                    style: TextStyle(
                                      fontSize: isVerySmallScreen
                                          ? 17
                                          : isTablet
                                              ? 24
                                              : 21,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Lora-Regular',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                        // ADDED: SHOW CREATE ACCOUNT AND LOG IN BUTTONS AFTER STUDENT IS SELECTED
                        if (_isStudentSelected)
                          Column(
                            children: [
                              // BACK BUTTON
                              Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isStudentSelected = false;
                                          _isSenyamatikardSelected = false;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          border: Border.all(color: Colors.black, width: 1),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.arrow_back,
                                            color: Colors.black,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Text(
                                      'For Student',
                                      style: TextStyle(
                                        fontSize: isVerySmallScreen
                                            ? 20
                                            : isTablet
                                                ? 28
                                                : 24,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Lora-Regular',
                                      ),
                                    ),
                                  ],
                                ),
                              ),

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
                                      fontFamily: 'Lora-Regular',
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
                                      fontFamily: 'Lora-Regular',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                        // ADDED: SHOW SENYAMATIKARD MESSAGE
                        if (_isSenyamatikardSelected)
                          Column(
                            children: [
                              // BACK BUTTON
                              Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isStudentSelected = false;
                                          _isSenyamatikardSelected = false;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          border: Border.all(color: Colors.black, width: 1),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.arrow_back,
                                            color: Colors.black,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Text(
                                      'Senyamatikard',
                                      style: TextStyle(
                                        fontSize: isVerySmallScreen
                                            ? 20
                                            : isTablet
                                                ? 28
                                                : 24,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Lora-Regular',
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // SENYAMATIKARD INFO MESSAGE
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F5E9),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.green, width: 2),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      size: 40,
                                      color: Colors.green[800],
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      'Senyamatikard Feature',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: isVerySmallScreen
                                            ? 18
                                            : isTablet
                                                ? 26
                                                : 22,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Lora-Regular',
                                        color: Colors.green[900],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'This feature is coming soon!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: isVerySmallScreen
                                            ? 14
                                            : isTablet
                                                ? 18
                                                : 16,
                                        fontFamily: 'Poppins-Regular',
                                        color: Colors.green[700],
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      'Senyamatikard will be a special feature for advanced users.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: isVerySmallScreen
                                            ? 12
                                            : isTablet
                                                ? 16
                                                : 14,
                                        fontFamily: 'Poppins-Regular',
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  
  // List of schools
  final List<String> _schools = [
    'San Miguel HighSchool',
    'Bajet-Castillo High School',
    'Dampol 2nd National High School',
    'Engr. Virgilio V. Dionisio Memorial High School',
    'Pulong Buhangin National High School'
  ];
  
  // List of sections (Grade 7-12)
  final List<String> _sections = [
    'Grade 7-Section A',
    'Grade 7-Section B',
    'Grade 7-Section C',
    'Grade 8-Section A',
    'Grade 8-Section B',
    'Grade 8-Section C',
    'Grade 9-Section A',
    'Grade 9-Section B',
    'Grade 9-Section C',
    'Grade 10-Section A',
    'Grade 10-Section B',
    'Grade 10-Section C',
    'Grade 11-Section A',
    'Grade 11-Section B',
    'Grade 11-Section C',
    'Grade 12-Section A',
    'Grade 12-Section B',
    'Grade 12-Section C',
  ];
  
  String? _selectedSchool;
  String? _selectedSection;

  void _createAccount() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final school = _selectedSchool;
    final section = _selectedSection;

    // Validation for all fields
    if (firstName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter your first name',
            style: TextStyle(fontFamily: 'Poppins-Regular'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (lastName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter your last name',
            style: TextStyle(fontFamily: 'Poppins-Regular'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter your email',
            style: TextStyle(fontFamily: 'Poppins-Regular'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validation para siguraduhing may @gmail.com ang email
    if (!email.endsWith('@gmail.com')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please use a valid Gmail address (@gmail.com)',
            style: TextStyle(fontFamily: 'Poppins-Regular'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter a password',
            style: TextStyle(fontFamily: 'Poppins-Regular'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Passwords do not match',
            style: TextStyle(fontFamily: 'Poppins-Regular'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (school == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select your school',
            style: TextStyle(fontFamily: 'Poppins-Regular'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (section == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select your section',
            style: TextStyle(fontFamily: 'Poppins-Regular'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Save user data with full name and additional info
    final fullName = '$firstName $lastName';
    UserProvider.setUser(UserData(
      name: fullName, 
      email: email,
      school: school,
      section: section,
    ));

    // Save credentials for login validation
    UserProvider.saveCredentials(email, {
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'school': school,
      'section': section,
    });

    // Simulate account creation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Account created successfully!',
          style: TextStyle(fontFamily: 'Poppins-Regular', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
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
      backgroundColor: Colors.white, // White background
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
                  Center(
                    child: Text(
                      'Welcome to SenyaMatika!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lora-Regular',
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
                                fontFamily: 'Lora-Regular',
                                color: Colors.black,
                                height: 0.9,
                              ),
                            ),
                            Text(
                              'Account',
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Lora-Regular',
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
                              'assets/images/avatar1.png',
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
                        // First Name field
                        _buildTextField(
                          controller: _firstNameController,
                          label: 'First Name:',
                          hintText: 'Enter your first name',
                          prefixIcon: Icons.person,
                        ),
                        const SizedBox(height: 20),
                        
                        // Last Name field
                        _buildTextField(
                          controller: _lastNameController,
                          label: 'Last Name:',
                          hintText: 'Enter your last name',
                          prefixIcon: Icons.person_outline,
                        ),
                        const SizedBox(height: 20),
                        
                        // Select School dropdown
                        _buildDropdownField(
                          label: 'Select your school:',
                          hintText: 'Choose your school',
                          prefixIcon: Icons.school,
                          value: _selectedSchool,
                          items: _schools.map((school) {
                            return DropdownMenuItem<String>(
                              value: school,
                              child: Text(
                                school,
                                style: TextStyle(fontFamily: 'Poppins-Regular'),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedSchool = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        
                        // Select Section dropdown
                        _buildDropdownField(
                          label: 'Select your section:',
                          hintText: 'Choose your grade and section',
                          prefixIcon: Icons.group,
                          value: _selectedSection,
                          items: _sections.map((section) {
                            return DropdownMenuItem<String>(
                              value: section,
                              child: Text(
                                section,
                                style: TextStyle(fontFamily: 'Poppins-Regular'),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedSection = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        
                        // Email field
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email:',
                          hintText: 'Enter your Gmail address (@gmail.com)',
                          prefixIcon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),
                        
                        // Password field
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
                        
                        // Confirm Password field
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
                            child: Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Lora-Regular',
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 40),
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
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Lora-Regular',
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
                fontFamily: 'Poppins-Regular',
                color: Colors.grey[600],
              ),
              border: InputBorder.none,
              prefixIcon: Icon(prefixIcon, color: Colors.black),
              filled: true,
              fillColor: Colors.transparent,
            ),
            style: TextStyle(
              fontFamily: 'Poppins-Regular',
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hintText,
    required IconData prefixIcon,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Lora-Regular',
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                hint: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    hintText,
                    style: TextStyle(
                      fontFamily: 'Poppins-Regular',
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                iconSize: 30,
                isExpanded: true,
                style: TextStyle(
                  fontFamily: 'Poppins-Regular',
                  fontSize: 16,
                  color: Colors.black,
                ),
                items: items,
                onChanged: onChanged,
              ),
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
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Lora-Regular',
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
                fontFamily: 'Poppins-Regular',
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
            style: TextStyle(
              fontFamily: 'Poppins-Regular',
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

// ============ LOG IN SCREEN (FIXED VERSION) ============
class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  // ADD THESE CONTROLLERS
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  void _logIn() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter your email',
            style: TextStyle(fontFamily: 'Poppins-Regular'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // DAGDAG: Validation para siguraduhing may @gmail.com ang email
    if (!email.endsWith('@gmail.com')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please use a valid Gmail address (@gmail.com)',
            style: TextStyle(fontFamily: 'Poppins-Regular'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter your password',
            style: TextStyle(fontFamily: 'Poppins-Regular'),
          ),
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
      SnackBar(
        content: Text(
          'Logged in successfully!',
          style: TextStyle(fontFamily: 'Poppins-Regular', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
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
      backgroundColor: Colors.white, // White background
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
                  Center(
                    child: Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lora-Regular',
                        color: Colors.black,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Sign in text - CENTERED
                  Center(
                    child: Text(
                      'Sign In to continue',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Poppins-Regular',
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
                        // "Log In" title - LEFT SIDE - IDINIKIT NA SA IISANG LINE
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Log',
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Lora-Regular',
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 8), // Maliit na spacing sa pagitan ng "Log" at "In"
                            Text(
                              'In',
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Lora-Regular',
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        
                        // Image na nasa RIGHT SIDE (same child image) - PINALAKI AT INILAPIT SA DIVIDER
                        Positioned(
                          top: -25, // Inangat para mas malapit sa divider
                          right: -5, // Nilapit sa kanang gilid
                          child: SizedBox(
                            width: 180, // PINALAKI (mula 120)
                            height: 180, // PINALAKI (mula 120)
                            child: Image.asset(
                              'assets/images/avatar1.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.transparent,
                                  child: const Center(
                                    child: Icon(
                                      Icons.child_care,
                                      size: 60, // PINALAKI din ang fallback icon
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
                  
                  // Divider line na kasabay ng image - NILAPITAN NG IMAGE
                  Container(
                    margin: const EdgeInsets.only(top: 5, bottom: 30), // Adjusted margin
                    height: 2,
                    color: Colors.grey[300],
                  ),
                  
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
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins-Regular',
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
                            child: Text(
                              'Log In',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Lora-Regular',
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Don't have an account? Sign up
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins-Regular',
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
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins-Regular',
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
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Lora-Regular',
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
                fontFamily: 'Poppins-Regular',
                color: Colors.grey[600],
              ),
              border: InputBorder.none,
              prefixIcon: Icon(prefixIcon, color: Colors.black),
              filled: true,
              fillColor: Colors.transparent,
            ),
            style: TextStyle(
              fontFamily: 'Poppins-Regular',
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
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Lora-Regular',
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
                fontFamily: 'Poppins-Regular',
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
            style: TextStyle(
              fontFamily: 'Poppins-Regular',
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}


// ============ PROFILE SCREEN ============
// ============ PROFILE SCREEN ============
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isDrawerOpen = false;

  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main Content
          Column(
            children: [
              // App Bar with Back Button Only
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lora-Regular',
                        color: Colors.black,
                      ),
                    ),
                    // Removed the blue profile icon button from here
                    Container(width: 48), // Empty container to maintain spacing
                  ],
                ),
              ),
              
              const Divider(height: 1, color: Colors.grey),
              
              // User Info
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      Container(
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
                      const SizedBox(height: 20),
                      Text(
                        UserProvider.getUserName(),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Lora-Regular',
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        UserProvider.getUserEmail(),
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins-Regular',
                          color: Colors.grey[700],
                        ),
                      ),
                      
                      // School and Section Info
                      if (UserProvider.getUserSchool() != null)
                        Column(
                          children: [
                            const SizedBox(height: 15),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.blue[200]!),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '${UserProvider.getUserSchool()}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Poppins-Regular',
                                      color: Colors.blue[900],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${UserProvider.getUserSection()}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Poppins-Regular',
                                      color: Colors.blue[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      
                      const SizedBox(height: 40),
                      
                      // Edit Profile Button
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFEDA5E),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: Colors.black, width: 2),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 5,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.edit, size: 20),
                              const SizedBox(width: 10),
                              Text(
                                'Edit Profile',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Lora-Regular',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Other Profile Info
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Account Information',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Lora-Regular',
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildInfoRow('Full Name:', UserProvider.getUserName()),
                            const SizedBox(height: 8),
                            _buildInfoRow('Email:', UserProvider.getUserEmail()),
                            if (UserProvider.getUserSchool() != null)
                              const SizedBox(height: 8),
                            if (UserProvider.getUserSchool() != null)
                              _buildInfoRow('School:', UserProvider.getUserSchool()!),
                            if (UserProvider.getUserSection() != null)
                              const SizedBox(height: 8),
                            if (UserProvider.getUserSection() != null)
                              _buildInfoRow('Section:', UserProvider.getUserSection()!),
                          ],
                        ),
                      ),
                      
                      // REMOVED THE ENTIRE LEARNING PROGRESS SECTION
                      
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Right Side Drawer (Overlay)
          if (_isDrawerOpen)
            GestureDetector(
              onTap: _toggleDrawer,
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),

          // Drawer Content (Slides from right)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            right: _isDrawerOpen ? 0 : -300,
            top: 0,
            bottom: 0,
            child: Container(
              width: 300,
              color: Colors.white,
              child: Column(
                children: [
                  // Drawer Header
                  Container(
                    height: 120,
                    width: double.infinity,
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          UserProvider.getUserName(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Lora-Regular',
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          UserProvider.getUserEmail(),
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins-Regular',
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Drawer Menu Items
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        // EDIT PROFILE OPTION
                        _buildDrawerMenuItem(
                          title: 'Edit Profile',
                          icon: Icons.edit,
                          onTap: () {
                            _toggleDrawer();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        
                        _buildDrawerMenuItem(
                          title: 'Settings',
                          icon: Icons.settings,
                          onTap: () {
                            _toggleDrawer();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SettingsScreen()),
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        _buildDrawerMenuItem(
                          title: 'Help',
                          icon: Icons.help_outline,
                          onTap: () {
                            _toggleDrawer();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HelpScreen()),
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        _buildDrawerMenuItem(
                          title: 'About',
                          icon: Icons.info_outline,
                          onTap: () {
                            _toggleDrawer();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AboutScreen()),
                            );
                          },
                        ),
                        const SizedBox(height: 30),
                        const Divider(color: Colors.grey),
                        const SizedBox(height: 30),
                        
                        // Log Out Button
                        _buildLogOutButton(context),
                      ],
                    ),
                  ),

                  // Close Button
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: IconButton(
                      icon: const Icon(Icons.close, size: 30, color: Colors.black),
                      onPressed: _toggleDrawer,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Poppins-Regular',
            color: Colors.black87,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Lora-Regular',
            color: Colors.blue[700],
          ),
        ),
      ],
    );
  }

  Widget _buildDrawerMenuItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.black,
                size: 24,
              ),
              const SizedBox(width: 15),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Lora-Regular',
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogOutButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _toggleDrawer();
          
          // Clear user data on sign out
          UserProvider.setUser(UserData(name: '', email: ''));
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Sign out successfully',
                style: TextStyle(
                  fontFamily: 'Poppins-Regular',
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
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
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red, width: 1),
          ),
          child: Row(
            children: [
              Icon(
                Icons.logout,
                color: Colors.red.shade700,
                size: 24,
              ),
              const SizedBox(width: 15),
              Text(
                'Logout',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Lora-Regular',
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============ EDIT PROFILE SCREEN ============
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  
  // List of schools
  final List<String> _schools = [
    'San Miguel HighSchool',
    'Bajet-Castillo High School',
    'Dampol 2nd National High School',
    'Engr. Virgilio V. Dionisio Memorial High School',
    'Pulong Buhangin National High School'
  ];
  
  // List of sections (Grade 7-12)
  final List<String> _sections = [
    'Grade 7-Section A',
    'Grade 7-Section B',
    'Grade 7-Section C',
    'Grade 8-Section A',
    'Grade 8-Section B',
    'Grade 8-Section C',
    'Grade 9-Section A',
    'Grade 9-Section B',
    'Grade 9-Section C',
    'Grade 10-Section A',
    'Grade 10-Section B',
    'Grade 10-Section C',
    'Grade 11-Section A',
    'Grade 11-Section B',
    'Grade 11-Section C',
    'Grade 12-Section A',
    'Grade 12-Section B',
    'Grade 12-Section C',
  ];
  
  String? _selectedSchool;
  String? _selectedSection;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    // Get current user data from UserProvider
    final currentName = UserProvider.getUserName();
    final currentEmail = UserProvider.getUserEmail();
    final currentSchool = UserProvider.getUserSchool();
    final currentSection = UserProvider.getUserSection();
    
    // Split name into first and last name
    final nameParts = currentName.split(' ');
    if (nameParts.length >= 2) {
      _firstNameController.text = nameParts.first;
      _lastNameController.text = nameParts.sublist(1).join(' ');
    } else {
      _firstNameController.text = currentName;
    }
    
    _emailController.text = currentEmail;
    
    // Set school and section from current user data
    setState(() {
      _selectedSchool = currentSchool ?? _schools.first;
      _selectedSection = currentSection ?? _sections.first;
    });
  }

  void _saveProfile() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final school = _selectedSchool;
    final section = _selectedSection;

    // Validation
    if (firstName.isEmpty) {
      _showErrorSnackbar('Please enter your first name');
      return;
    }

    if (lastName.isEmpty) {
      _showErrorSnackbar('Please enter your last name');
      return;
    }

    if (email.isEmpty) {
      _showErrorSnackbar('Please enter your email');
      return;
    }

    if (!email.endsWith('@gmail.com')) {
      _showErrorSnackbar('Please use a valid Gmail address (@gmail.com)');
      return;
    }

    if (password.isNotEmpty) {
      if (password != confirmPassword) {
        _showErrorSnackbar('Passwords do not match');
        return;
      }
    }

    if (school == null) {
      _showErrorSnackbar('Please select your school');
      return;
    }

    if (section == null) {
      _showErrorSnackbar('Please select your section');
      return;
    }

    // Update user data in UserProvider
    UserProvider.updateUserInfo(
      name: '$firstName $lastName',
      email: email,
      school: school,
      section: section,
    );

    // If password was changed, update it
    if (password.isNotEmpty) {
      final currentEmail = UserProvider.getUserEmail();
      final credentials = UserProvider.getCredentials(currentEmail);
      if (credentials != null) {
        credentials['password'] = password;
        credentials['firstName'] = firstName;
        credentials['lastName'] = lastName;
        credentials['school'] = school;
        credentials['section'] = section;
      }
    }

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Profile updated successfully!',
          style: TextStyle(fontFamily: 'Poppins-Regular', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.pop(context);
    });
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontFamily: 'Poppins-Regular'),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  // Back button
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
                  
                  // Title - CENTERED
                  Center(
                    child: Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lora-Regular',
                        color: Colors.black,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Subtitle - CENTERED
                  Center(
                    child: Text(
                      'Update your personal information',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins-Regular',
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Container with image
                  SizedBox(
                    width: double.infinity,
                    child: Stack(
                      children: [
                        // Title on left
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Update',
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Lora-Regular',
                                color: Colors.black,
                                height: 0.9,
                              ),
                            ),
                            Text(
                              'Profile',
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Lora-Regular',
                                color: Colors.black,
                                height: 0.9,
                              ),
                            ),
                          ],
                        ),
                        
                        // Image on right
                        Positioned(
                          top: -10,
                          right: 0,
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.asset(
                              'assets/images/avatar1.png',
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
                  
                  // Edit Profile card
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
                        // First Name
                        _buildTextField(
                          controller: _firstNameController,
                          label: 'First Name:',
                          hintText: 'Enter your first name',
                          prefixIcon: Icons.person,
                        ),
                        const SizedBox(height: 20),
                        
                        // Last Name
                        _buildTextField(
                          controller: _lastNameController,
                          label: 'Last Name:',
                          hintText: 'Enter your last name',
                          prefixIcon: Icons.person_outline,
                        ),
                        const SizedBox(height: 20),
                        
                        // Select School
                        _buildDropdownField(
                          label: 'School:',
                          hintText: 'Select your school',
                          prefixIcon: Icons.school,
                          value: _selectedSchool,
                          items: _schools.map((school) {
                            return DropdownMenuItem<String>(
                              value: school,
                              child: Text(
                                school,
                                style: TextStyle(fontFamily: 'Poppins-Regular'),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedSchool = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        
                        // Select Section
                        _buildDropdownField(
                          label: 'Section:',
                          hintText: 'Select your grade and section',
                          prefixIcon: Icons.group,
                          value: _selectedSection,
                          items: _sections.map((section) {
                            return DropdownMenuItem<String>(
                              value: section,
                              child: Text(
                                section,
                                style: TextStyle(fontFamily: 'Poppins-Regular'),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedSection = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        
                        // Email
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email:',
                          hintText: 'Enter your Gmail address',
                          prefixIcon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),
                        
                        // New Password
                        _buildPasswordField(
                          controller: _passwordController,
                          label: 'New Password (optional):',
                          hintText: 'Enter new password (leave empty to keep current)',
                          isPasswordVisible: _isPasswordVisible,
                          onToggleVisibility: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        
                        // Confirm Password
                        _buildPasswordField(
                          controller: _confirmPasswordController,
                          label: 'Confirm Password:',
                          hintText: 'Confirm your new password',
                          isPasswordVisible: _isConfirmPasswordVisible,
                          onToggleVisibility: () {
                            setState(() {
                              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                        
                        const SizedBox(height: 35),
                        
                        // Save Button
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
                            onPressed: _saveProfile,
                            child: Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Lora-Regular',
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 40),
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
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Lora-Regular',
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
                fontFamily: 'Poppins-Regular',
                color: Colors.grey[600],
              ),
              border: InputBorder.none,
              prefixIcon: Icon(prefixIcon, color: Colors.black),
              filled: true,
              fillColor: Colors.transparent,
            ),
            style: TextStyle(
              fontFamily: 'Poppins-Regular',
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hintText,
    required IconData prefixIcon,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Lora-Regular',
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                hint: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    hintText,
                    style: TextStyle(
                      fontFamily: 'Poppins-Regular',
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                iconSize: 30,
                isExpanded: true,
                style: TextStyle(
                  fontFamily: 'Poppins-Regular',
                  fontSize: 16,
                  color: Colors.black,
                ),
                items: items,
                onChanged: onChanged,
              ),
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
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Lora-Regular',
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
                fontFamily: 'Poppins-Regular',
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
            style: TextStyle(
              fontFamily: 'Poppins-Regular',
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
        SnackBar(
          content: Text(
            'Please enter your email address',
            style: TextStyle(fontFamily: 'Poppins-Regular'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // DAGDAG: Validation para siguraduhing may @gmail.com ang email
    if (!email.endsWith('@gmail.com')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please use a valid Gmail address (@gmail.com)',
            style: TextStyle(fontFamily: 'Poppins-Regular'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Password reset link sent to your email!',
          style: TextStyle(fontFamily: 'Poppins-Regular', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
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
                  Center(
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lora-Regular',
                        color: Colors.black,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Instruction text - CENTERED
                  Center(
                    child: Text(
                      'Enter your Gmail to reset your password',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Poppins-Regular',
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
                                fontFamily: 'Lora-Regular',
                                color: Colors.black,
                                height: 0.9,
                              ),
                            ),
                            Text(
                              'Password',
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Lora-Regular',
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
                        Text(
                          'We\'ll send you a link to reset your password.',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins-Regular',
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
                            child: Text(
                              'Send Reset Link',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Lora-Regular',
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
                            child: Text(
                              'Back to Log In',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins-Regular',
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
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Lora-Regular',
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
                fontFamily: 'Poppins-Regular',
                color: Colors.grey[600],
              ),
              border: InputBorder.none,
              prefixIcon: Icon(prefixIcon, color: Colors.black),
              filled: true,
              fillColor: Colors.transparent,
            ),
            style: TextStyle(
              fontFamily: 'Poppins-Regular',
              fontSize: 16,
              color: Colors.black,
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
      backgroundColor: Colors.white, // White background
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Lora-Regular',
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
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lora-Regular',
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
          style: TextStyle(
            fontFamily: 'Poppins-Regular',
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
      backgroundColor: Colors.white, // White background
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Languages',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Lora-Regular',
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
            
            Text(
              'Select your preferred language:',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins-Regular',
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
                    : Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Lora-Regular',
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
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Lora-Regular',
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
      backgroundColor: Colors.white, // White background
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Help & Support',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Lora-Regular',
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
                  Text(
                    'SenyaMatika Help Center',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lora-Regular',
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lora-Regular',
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
                  Text(
                    'Need More Help?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lora-Regular',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Our support team is here to help you with any questions or issues you may have.',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins-Regular',
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  _buildContactMethod('Email', 'support@senyamatika.com', Icons.email),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            Center(
              child: Text(
                'App Version: 1.0.0',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins-Regular',
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
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Lora-Regular',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins-Regular',
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
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Lora-Regular',
                ),
              ),
              Text(
                details,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Poppins-Regular',
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
      backgroundColor: Colors.white, // White background
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'About SenyaMatika',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Lora-Regular',
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
                  Text(
                    'SenyaMatika',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lora-Regular',
                    ),
                  ),
                  Text(
                    'Mathematics Learning App',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins-Regular',
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            Text(
              'About Our App',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lora-Regular',
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'SenyaMatika is an innovative educational app designed to make learning mathematics fun and engaging for students of all ages. Our app combines interactive lessons and progress tracking to help you master mathematical concepts.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins-Regular',
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 25),
            
            Text(
              'Key Features',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lora-Regular',
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
                  Text(
                    'App Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lora-Regular',
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
        
            Center(
              child: Text(
                '© 2025 SenyaMatika. All rights reserved.',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Poppins-Regular',
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lora-Regular',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins-Regular',
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
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'Lora-Regular',
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins-Regular',
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
      backgroundColor: Colors.white, // White background
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Privacy Policy',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Lora-Regular',
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
            Text(
              'Last Updated: January 2024',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins-Regular',
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'By using SenyaMatika, you agree to the collection and use of information in accordance with this policy.',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins-Regular',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'We are committed to protecting your privacy and providing a safe learning environment.',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins-Regular',
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
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Lora-Regular',
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins-Regular',
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
      backgroundColor: Colors.white, // White background
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Terms of Use',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Lora-Regular',
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
            Text(
              'Last Updated: January 2024',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins-Regular',
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Terms of Use',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lora-Regular',
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'By using SenyaMatika, you agree to these terms and conditions. Please read them carefully.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins-Regular',
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'User Responsibilities',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lora-Regular',
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'You are responsible for maintaining the confidentiality of your account and password. You agree to accept responsibility for all activities that occur under your account.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins-Regular',
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// ============ SIGN LANGUAGE AVATAR SCREEN (UPDATED) ============
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
  
  // Avatar loading state
  bool _isAvatarLoading = false;
  bool _hasAvatarError = false;
  bool _hasUserInput = false; // Track if user has provided input
  
  // ============ GIF ROTATION SYSTEM ============
  int _gifCounter = 0; // Tracks number of inputs
  final List<String> _gifAssets = [
    'assets/gif/FirstSign.gif',
    'assets/gif/SecondSign.gif',
    'assets/gif/ThirdSign.gif',
  ];
  
  // Current GIF to display
  String get _currentGif {
    if (_gifAssets.isEmpty) return 'assets/gif/SignTutor.gif'; // Fallback
    
    // Calculate which GIF to show based on counter
    final index = _gifCounter % _gifAssets.length;
    return _gifAssets[index];
  }
  
  // Method to handle text input and rotate GIF
  void _handleTextInput(String text) {
    if (text.trim().isNotEmpty) {
      // Set flag that user has provided input
      setState(() {
        _hasUserInput = true;
        _gifCounter++;
        _isAvatarLoading = true;
      });
      
      // Play the appropriate GIF animation
      _playAvatarAnimation(text);
    }
  }
  // ============ END GIF ROTATION SYSTEM ============

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
                _handleTextInput(result.recognizedWords);
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
        
      } catch (e) {
        setState(() {
          _isListening = false;
        });
        _cancelTimer();
      }
    }
  }

  void _sendText() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      _handleTextInput(text);
    } else {
      _showErrorSnackBar('Please enter or speak some text first');
    }
  }

  void _playAvatarAnimation(String text) {
    if (!mounted) return;
    
    // Simple snackbar message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Translating to sign language...',
          style: TextStyle(fontFamily: 'Poppins-Regular'),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
    
    // Reset loading after a short delay (to show loading spinner)
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isAvatarLoading = false;
        });
      }
    });
  }

  void _showReminderSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(fontFamily: 'Poppins-Regular'),
          ),
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
          content: Text(
            message,
            style: TextStyle(fontFamily: 'Poppins-Regular'),
          ),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Sign Language Avatar',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Lora-Regular',
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
                    // ============ Avatar Display ============
                    SizedBox(
                      width: 300,
                      height: 300,
                      child: _buildAvatar(),
                    ),
                    
                    // SPEECH INITIALIZING OVERLAY
                    if (_isInitializing)
                      Positioned.fill(
                        child: Container(
                          color: const Color.fromRGBO(0, 0, 0, 0.3),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: Colors.yellow,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    
                    // LISTENING OVERLAY
                    if (_isListening)
                      Positioned.fill(
                        child: Container(
                          color: const Color.fromRGBO(0, 0, 0, 0.3),
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
                                
                                if (_recognizedText.isNotEmpty)
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(0, 0, 0, 0.5),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '"$_recognizedText"',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                        fontFamily: 'Poppins-Regular',
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

            // TEXT INPUT FIELD WITH CONTROLS
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
                      color: const Color.fromRGBO(0, 0, 0, 0.1),
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
                              ? 'Type or speak to translate...' 
                              : 'Speech not available. Type here...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: _speechAvailable ? Colors.grey : Colors.grey[400],
                            fontFamily: 'Poppins-Regular',
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
                        style: TextStyle(fontFamily: 'Poppins-Regular'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    
                    // SEND BUTTON
                    if (_textController.text.trim().isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.blue),
                        onPressed: _sendText,
                        tooltip: 'Translate text to sign language',
                      ),
                    
                    // MICROPHONE BUTTON
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

            // INSTRUCTION TEXT
            Padding(
              padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
              child: Text(
                _speechAvailable 
                    ? 'Tap the microphone and speak, or type text to translate'
                    : 'Speech recognition is not available. Please type your text.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _speechAvailable ? Colors.green : Colors.orange,
                  fontSize: 12,
                  fontFamily: 'Poppins-Regular',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return GestureDetector(
      onTap: () {
        // Tap the avatar to replay animation if there's text
        final text = _textController.text.trim();
        if (text.isNotEmpty) {
          _handleTextInput(text);
        }
      },
      child: Stack(
        children: [
          // ============ Static Image when no input ============
          if (!_hasUserInput)
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: const Color(0xFFA8D5E3),
                borderRadius: BorderRadius.circular(150),
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.person,
                  size: 100,
                  color: Colors.white,
                ),
              ),
            ),
          
          // ============ GIF Animation when user has input ============
          if (_hasUserInput && !_hasAvatarError && !_isAvatarLoading)
            Image.asset(
              _currentGif,
              width: 300,
              height: 300,
              fit: BoxFit.contain,
              gaplessPlayback: true,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded) {
                  return child;
                }
                
                if (frame == null) {
                  return Container(
                    width: 300,
                    height: 300,
                    color: Colors.white,
                  );
                }
                
                return child;
              },
              errorBuilder: (context, error, stackTrace) {
                if (mounted) {
                  setState(() {
                    _hasAvatarError = true;
                    _isAvatarLoading = false;
                  });
                }
                
                return _buildFallbackAvatar();
              },
            ),
          
          // LOADING OVERLAY (shows when loading new GIF)
          if (_hasUserInput && _isAvatarLoading)
            Positioned.fill(
              child: Container(
                color: Colors.white,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.yellow,
                  ),
                ),
              ),
            ),
          
          // ERROR OVERLAY
          if (_hasUserInput && _hasAvatarError && !_isAvatarLoading)
            Positioned.fill(
              child: Container(
                color: Colors.white,
                child: const Center(
                  child: Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFallbackAvatar() {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        color: const Color(0xFFA8D5E3),
        borderRadius: BorderRadius.circular(150),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.person,
          size: 100,
          color: Colors.white,
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