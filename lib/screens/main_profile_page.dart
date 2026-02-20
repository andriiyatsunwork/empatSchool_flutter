/*
 * @author Andrii Yatsun
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'avatar_detail_page.dart';
import '../widgets/stat_item.dart';
import '../widgets/instagram_post.dart';

/**
 * Main Profile Screen (Widget)
 */
class MainProfilePage extends StatefulWidget {
  const MainProfilePage({super.key});

  @override
  State<MainProfilePage> createState() => _MainProfilePageState();
}

class _MainProfilePageState extends State<MainProfilePage> {
  int _selectedIndex = 0;

  Widget _buildAnimatedIcon(IconData icon, int index, bool isDarkMode) {
    bool isSelected = _selectedIndex == index;
    return AnimatedScale(
      scale: isSelected ? 1.3 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Icon(
        icon,
        color: isSelected ? (isDarkMode ? Colors.white : Colors.black) : Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Отримуємо поточну тему
    final isDarkMode = Provider.of<AppProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: const Text('aannnddrriiyyy', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          // Consumer перемальовує ТІЛЬКИ цю іконку при новому лайку
          Consumer<AppProvider>(
            builder: (context, provider, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
                  if (provider.likesCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        child: Text('${provider.likesCount}', style: const TextStyle(color: Colors.white, fontSize: 10)),
                      ),
                    )
                ],
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ... Верхня частина профілю ...
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AvatarDetailPage())),
                  child: const Hero(
                    tag: 'profile_pic',
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                  ),
                ),
                const Expanded(child: StatItem('Posts', '16')),
                const Expanded(child: StatItem('Followers', '236')),
                const Expanded(child: StatItem('Following', '12')),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Andrii Yatsun', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Flutter Developer | Student KMA'),
                Text('Learning Dart & Mobile Dev 🚀', style: TextStyle(color: Colors.blue)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Нетривіальне дерево віджетів починається тут
          Expanded(
            child: GridView.builder(
              itemCount: 16,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 2,
              ),
              itemBuilder: (context, index) {
                return InstagramPost(index: index); // Ніяких колбеків не передаємо!
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // Просто викликаємо метод зміни теми (listen: false)
        onPressed: () => Provider.of<AppProvider>(context, listen: false).toggleTheme(),
        backgroundColor: Colors.grey[700],
        child: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false, showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(icon: _buildAnimatedIcon(Icons.home, 0, isDarkMode), label: ''),
          BottomNavigationBarItem(icon: _buildAnimatedIcon(Icons.movie_filter, 1, isDarkMode), label: ''),
          BottomNavigationBarItem(icon: _buildAnimatedIcon(Icons.send, 2, isDarkMode), label: ''),
          BottomNavigationBarItem(icon: _buildAnimatedIcon(Icons.search, 3, isDarkMode), label: ''),
          BottomNavigationBarItem(icon: _buildAnimatedIcon(Icons.person, 4, isDarkMode), label: ''),
        ],
      ),
    );
  }
}