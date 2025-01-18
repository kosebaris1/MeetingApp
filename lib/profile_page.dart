import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  Future<Map<String, dynamic>> getUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser; // Giriş yapan kullanıcıyı alıyoruz.
    if (user != null) {

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        throw Exception("Profil bilgisi bulunamadı.");
      }
    }
    throw Exception("Kullanıcı oturumu açık değil.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Bilgileri'),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 5,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Hata: ${snapshot.error}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Profil bilgisi bulunamadı.'));
          }

          Map<String, dynamic> userData = snapshot.data!;

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurpleAccent.shade100,
                  Colors.deepPurpleAccent.shade200,
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Center(
                    child: Card(
                      elevation: 20,
                      shadowColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.deepPurple,
                                child: const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            _profilBilgi('Kullanıcı Adı', userData['userName'] ?? 'Belirtilmemiş', Icons.person),
                            _profilBilgi('Mail Adresi', userData['mail'] ?? 'Belirtilmemiş', Icons.email),
                            _profilBilgi('Firma Kodu', userData['firma'] ?? 'Belirtilmemiş', Icons.code),
                            _profilBilgi('Password', userData['password'] ?? '********', Icons.password),
                            const SizedBox(height: 20),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white, backgroundColor: Colors.deepPurpleAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                                ),
                                onPressed: () {
                                  // Profil düzenleme işlemi buraya eklenebilir
                                },
                                child: const Text('Profili Düzenle',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
          );
        },
      ),
    );
  }

  Widget _profilBilgi(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
