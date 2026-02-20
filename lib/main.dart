/*
 * @author Andrii Yatsun
 *
 * Project 6 Requirements:
 * 1) Побудувати нетривіальне дерево віджетів
 * 2) Продемонструвати використання класу ChangeNotifier
 * 3) Побудувати Модель стану, до якої будуть здійснюватись звернення
 * 4) Продемонструвати доступ до моделі:
 *  4.1) Через Consumer
 *  4.2) Через Provider.of()
 */

import 'package:flutter/material.dart';

void main() {
  runApp(const InstagramProfileApp());
}

// 1. КОРЕНЕВИЙ ВІДЖЕТ (Stateful - керує темою)
class InstagramProfileApp extends StatefulWidget {
  const InstagramProfileApp({super.key});

  @override
  State<InstagramProfileApp> createState() => _InstagramProfileAppState();
}

class _InstagramProfileAppState extends State<InstagramProfileApp> {
  // початковий стан теми
  bool _isDarkMode = false;

  // функція для зміни теми
  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // динамічне налаштування теми на основі стану _isDarkMode
      theme: ThemeData(
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        primaryColor: _isDarkMode ? Colors.black : Colors.white,
        scaffoldBackgroundColor: _isDarkMode ? Colors.black : Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: _isDarkMode ? Colors.black : Colors.white,
          foregroundColor: _isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      home: MainProfilePage(
        isDarkMode: _isDarkMode,
        onThemeToggle: _toggleTheme,
      ),
    );
  }
}

// 2. ГОЛОВНИЙ ЕКРАН (Stateful - керує станом лайків)
class MainProfilePage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const MainProfilePage({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<MainProfilePage> createState() => _MainProfilePageState();
}

class _MainProfilePageState extends State<MainProfilePage> {
  int _selectedIndex = 0;

  // Змінна зберігає загальну кількість лайків, хоча самі кнопки знаходяться
  // глибоко в GridView.
  int _likesCount = 0;

  // Lifting State Up
  // передається вниз дочірнім віджетам
  void _addLike() {
    setState(() {
      _likesCount++;
    });
    // Показуємо повідомлення знизу
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Вам сподобався цей пост! ❤️"),
        duration: Duration(milliseconds: 500),
      ),
    );
  }

  // іконка для нижньої панелі
  Widget _buildAnimatedIcon(IconData icon, int index) {
    bool isSelected = _selectedIndex == index;
    return AnimatedScale(
      scale: isSelected ? 1.3 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Icon(
        icon,
        color: isSelected
            ? (widget.isDarkMode ? Colors.white : Colors.black)
            : Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // колір фону підлаштовується автоматично через тему
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      // Scaffold елементи: AppBar, Drawer, FloatingButton
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: widget.isDarkMode ? Colors.white : Colors.black,
        ),
        title: Text(
          'aannnddrriiyyy',
          style: TextStyle(
            color: widget.isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Відображення стану ЛАЙКІВ в AppBar
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border), // Серце
              ),
              if (_likesCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$_likesCount',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                )
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
      /* Menu */
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: widget.isDarkMode ? Colors.white10 : Colors.black87,
              ),
              child: const Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            const ListTile(leading: Icon(Icons.settings), title: Text('Settings')),
            const ListTile(leading: Icon(Icons.history), title: Text('Archive')),
          ],
        ),
      ),
      body: Column(
        /* розміщення опису притиснутим вліво */
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* верхня частина: аватар + статистика */
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /* анімований Hero для фото профілю */
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AvatarDetailPage()),
                  ),
                  child: const Hero(
                    tag: 'profile_pic',
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                  ),
                ),
                const Expanded(child: StatItem('Posts', '16')), // Кількість постів
                const Expanded(child: StatItem('Followers', '236')),
                const Expanded(child: StatItem('Following', '12')),
              ],
            ),
          ),
          // блок опису (Container + Column)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Andrii Yatsun', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Flutter Developer | Student KMA'),
                Text('Learning Dart & Mobile Dev 🚀', style: TextStyle(color: Colors.blue)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 3. GridView з постами
          Expanded(
            child: GridView.builder(
              itemCount: 16,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemBuilder: (context, index) {
                // МИ ПЕРЕДАЄМО ФУНКЦІЮ _addLike ВНИЗ У ДОЧІРНІЙ ВІДЖЕТ
                return InstagramPost(
                  index: index,
                  isDarkMode: widget.isDarkMode,
                  onLikePressed: _addLike, // <--- Lifting State Up: передаємо callback
                );
              },
            ),
          ),
        ],
      ),
      /* Floating button */
      // Тепер ця кнопка перемикає тему застосунку
      floatingActionButton: FloatingActionButton(
        onPressed: widget.onThemeToggle,
        backgroundColor: Colors.grey[700],
        child: Icon(
          widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
          color: Colors.white,
        ),
      ),
      // анімований BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(icon: _buildAnimatedIcon(Icons.home, 0), label: ''),
          BottomNavigationBarItem(icon: _buildAnimatedIcon(Icons.movie_filter, 1), label: ''),
          BottomNavigationBarItem(icon: _buildAnimatedIcon(Icons.send, 2), label: ''),
          BottomNavigationBarItem(icon: _buildAnimatedIcon(Icons.search, 3), label: ''),
          BottomNavigationBarItem(icon: _buildAnimatedIcon(Icons.person, 4), label: ''),
        ],
      ),
    );
  }
}

// 4. ОКРЕМИЙ STATELESS ВІДЖЕТ (Пост Інстаграм)
// Цей віджет не зберігає стан лайків.
// Коли на нього тиснуть, він просто сповіщає батька через onLikePressed.
class InstagramPost extends StatelessWidget {
  final int index;
  final bool isDarkMode;
  final VoidCallback onLikePressed; // Callback

  const InstagramPost({
    super.key,
    required this.index,
    required this.isDarkMode,
    required this.onLikePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDarkMode ? Colors.white10 : Colors.grey[200],
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Icons.image, color: Colors.white),
          Positioned(
            bottom: 4,
            right: 4,
            child: GestureDetector(
              onTap: onLikePressed, // Викликаємо функцію батька при натисканні (Lifting State Up)
              child: Container(
                padding: const EdgeInsets.all(4),
                // Прозорий фон для іконки лайка, щоб не перекривати фото
                child: const Icon(Icons.favorite, size: 20, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// сторінка детального перегляду для Hero анімації
class AvatarDetailPage extends StatelessWidget {
  const AvatarDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Hero(
          tag: 'profile_pic',
          child: Container(
            width: double.infinity,
            height: 400,
            color: Colors.grey[500],
            child: const Icon(Icons.person, size: 200, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class StatItem extends StatelessWidget {
  final String label;
  final String count;

  const StatItem(this.label, this.count, {super.key});

  /* статистика шаблон */
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}