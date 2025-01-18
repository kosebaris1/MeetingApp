import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();

}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
 // final TextEditingController firmaController = TextEditingController();
  final TextEditingController firmaKodController = TextEditingController();


  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurpleAccent, Colors.purple.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Başlık ve Logo
                    Column(
                      children: [
                        Icon(
                          Icons.person_add,
                          size: 100,
                          color: Colors.deepPurpleAccent,
                        ),

                        SizedBox(height: 16),
                        Text(
                          "Kayıt Ol",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurpleAccent,
                          ),
                        ),
                        Text(
                          "Yeni Hesap Oluşturun",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),

                    _buildTextField(
                      controller: firmaKodController,
                      hintText: "Firma kodu giriniz ",
                      icon: Icons.code,
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                      controller: usernameController,
                      hintText: "Kullanıcı Adı",
                      icon: Icons.person,
                    ),
                    SizedBox(height: 20),
                    // Email Alanı
                    _buildTextField(
                      controller: emailController,
                      hintText: "Email Adresi",
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 20),
                    // Şifre Alanı
                    _buildTextField(
                      controller: passwordController,
                      hintText: "Şifre",
                      icon: Icons.lock,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    // Şifreyi Tekrar Girin Alanı
                    _buildTextField(
                      controller: confirmPasswordController,
                      hintText: "Şifreyi Tekrar Girin",
                      icon: Icons.lock,
                      obscureText: _obscureConfirmPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 30),
                    // Kayıt Ol Butonu
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _SignupIslemi,
                        child: Text(
                          "Kayıt Ol",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Zaten Hesabınız Var mı? Giriş Yapın
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Zaten Hesabınız Var mı? ",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Giriş Yap",
                            style: TextStyle(
                              color: Colors.deepPurpleAccent,
                              fontSize: 14,
                            ),
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
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.deepPurpleAccent),
        suffixIcon: suffixIcon,
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }

  void _SignupIslemi() async {
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        firmaKodController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lütfen tüm alanları doldurun"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if(passwordController.text.length<6){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Şifre en az 6 haneli olmalıdır"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Şifreler uyuşmuyor"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Kullanıcıyı Firebase'e kaydet
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await _firestore.collection('user').doc(userCredential.user!.uid).set({
        'userName': usernameController.text.trim(),
        'mail': emailController.text.trim(),
        'firma': firmaKodController.text.trim(),

      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Kayıt başarıyla tamamlandı!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      // Hata mesajını göster
      String errorMessage = _getFirebaseErrorMessage(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Hata: $errorMessage"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

// Firebase hata mesajlarını kullanıcı dostu bir şekilde göster
  String _getFirebaseErrorMessage(String error) {
    if (error.contains('network-request-failed')) {
      return "Ağ bağlantısı hatası. Lütfen internet bağlantınızı kontrol edin.";
    } else if (error.contains('email-already-in-use')) {
      return "Bu e-posta adresi zaten kullanılıyor.";
    } else if (error.contains('invalid-email')) {
      return "Geçersiz e-posta adresi.";
    } else if (error.contains('weak-password')) {
      return "Şifre çok zayıf. Daha güçlü bir şifre deneyin.";
    } else {
      return "Bir hata oluştu. Lütfen tekrar deneyin.";
    }
  }



}
