import 'package:app_toplanti/profile_page.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

class CustomDrawer extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String profileImage;

  CustomDrawer({
    required this.userName,
    required this.userEmail,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270,
      child: Drawer(
        child: Container(
          color: Colors.white, // Açık renkli arka plan
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Kullanıcı Bilgileri
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent, // Hafif mavi tonları
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.account_circle,size: 60,),
                    SizedBox(height: 10),
                    Text(
                      userName,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      userEmail,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              // Kullanıcı menüsü
              _buildDrawerItem(Icons.person, "Profilim",Colors.black87, context),
              _buildDrawerItem(Icons.schedule, "Toplantılarım",Colors.black87, context),
              Divider(color: Colors.grey),
              _buildDrawerItem(Icons.logout, "Çıkış Yap",Colors.redAccent, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title,Color color, BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.black87,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        if (title == "Profilim") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => ProfilePage(),
            ),
          );
        } else if (title == "Toplantılarım") {
          Navigator.pop(context);
        } else if (title == "Ayarlar") {
          // Ayarlar sayfası yönlendirmesi yapılabilir
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => LoginPage(),
            ),
          );
        }
      },
    );
  }
}
