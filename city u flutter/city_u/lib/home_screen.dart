import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'Locationspage.dart';
import 'loginandsing.dart';
import 'profile_page.dart';
import 'blog_page.dart'; // Import the new Blog Page
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      menuScreen: const MenuScreen(),
      mainScreen: const MainContent(),
      borderRadius: 24.0,
      showShadow: true,
      angle: -12.0,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      openCurve: Curves.fastOutSlowIn,
      closeCurve: Curves.bounceIn,
    );
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/profile.jpg'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.home, color: Colors.white),
                title:
                    const Text('Home', style: TextStyle(color: Colors.white)),
                onTap: () {
                  ZoomDrawer.of(context)?.close();
                },
              ),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.white),
                title: const Text('Profile',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.article, color: Colors.white),
                title: const Text('Blog Page',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BlogPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.login, color: Colors.white),
                title: const Text('Login / Sign Up',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginAndSignPage()),
                  );
                },
              ),
              const Divider(color: Colors.white54),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.video_library, color: Colors.white),
                    onPressed: () {
                      // Open YouTube link
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.music_note, color: Colors.white),
                    onPressed: () {
                      // Open TikTok link
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    onPressed: () {
                      // Open Instagram link
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.facebook, color: Colors.white),
                    onPressed: () {
                      // Open Facebook link
                    },
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

class MainContent extends StatelessWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/university_logo.png', height: 30),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6, color: Colors.black),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Image.asset(
                    'assets/campus_image.png',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.white],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.all(16.0),
              ),
              GridView.count(
                shrinkWrap: true, // To fit the grid within the scrollable area
                crossAxisCount: 2,
                padding: const EdgeInsets.all(16.0),
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  _buildGridButton(Icons.school, 'LMS', () {
                    _launchURL(
                        "https://www.cityulms.com/Account/CityLogin.aspx");
                  }),
                  _buildGridButton(Icons.account_balance, 'Student Portal', () {
                    _launchURL(
                        "https://student.city.edu.my/sp-dev/default/login");
                  }),
                  _buildGridButton(Icons.location_on, 'Locations', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LocationsPage()),
                    );
                  }),
                  _buildGridButton(Icons.article, 'Blog Page', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BlogPage()),
                    );
                  }),
                  _buildGridButton(Icons.person, 'Profile', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfilePage()),
                    );
                  }),
                  
                  _buildGridButton(Icons.login, 'Login / Sign Up', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginAndSignPage()),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridButton(IconData icon, String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.blue),
              const SizedBox(height: 8),
              Text(
                label,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
