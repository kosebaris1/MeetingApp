import 'package:app_toplanti/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgetPage extends StatefulWidget {
  @override
  _ForgetPageState createState() => _ForgetPageState();
}

class _ForgetPageState extends State<ForgetPage> {
  int deger=0;
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;


  void _sendPasswordResetEmail() async {
    final String email = _emailController.text.trim();

    if (email.isEmpty) {
      _showMessage("Lütfen e-posta adresinizi girin.");
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      _showMessage("Şifre sıfırlama bağlantısı e-posta adresinize gönderildi.");
      deger=1;
    } catch (error) {
      _showMessage("Lütfen geçerli e-posta türü giriniz");
    }
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Bilgilendirme"),
          content: Text(message),
          actions: [
            TextButton(
              child: Text(
                "Tamam",
                style: TextStyle(color: Colors.deepPurpleAccent),
              ),

              onPressed: () {
                if(deger==0)
                  Navigator.pop(context);
                else
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurpleAccent, Colors.blueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Şifremi Unuttum",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Lütfen e-posta adresinizi girin. Şifre sıfırlama bağlantısı size gönderilecektir.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 24),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "E-posta Adresiniz",
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _sendPasswordResetEmail,
                      child: Text(
                        "Bağlantıyı Gönder",
                        style: TextStyle(fontSize: 16,color: Colors.black),

                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text(
                        "Girişe Dön",
                        style: TextStyle(color: Colors.deepPurpleAccent),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
