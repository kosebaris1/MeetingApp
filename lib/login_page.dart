import 'package:app_toplanti/forget_password.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

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
                    Column(
                      children: [
                        Icon(
                          Icons.login_rounded,
                          size: 100,
                          color: Colors.deepPurpleAccent,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Hoş Geldiniz",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurpleAccent,
                          ),
                        ),
                        Text(
                          "Lütfen giriş yapın",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    _buildTextField(
                      controller: emailController,
                      hintText: "Email Adresi",
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 20),
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
                    SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _LoginIslemi,
                        child: Text(
                          "Giriş Yap",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            MaterialPageRoute pageRoute=MaterialPageRoute(
                                builder: (BuildContext context){
                                  return ForgetPage();
                                });
                            Navigator.push(context, pageRoute);
                          },
                          child: Text(
                            "Şifremi Unuttum?",
                            style: TextStyle(
                              color: Colors.deepPurpleAccent,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, "/kayitSayfasi"),
                          child: Text(
                            "Kayıt Ol",
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

  void _LoginIslemi() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lütfen tüm alanları doldurun"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Firebase Authentication ile giriş yapıyoruz
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // Eğer giriş başarılıysa, ana sayfaya yönlendiriyoruz
      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } catch (e) {
      String errorMessage = "Bir hata oluştu. Lütfen tekrar deneyin.";
      // Hata kodlarına göre kullanıcıya anlaşılır mesajlar veriyoruz
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = "Bu e-posta adresiyle kayıtlı bir kullanıcı bulunamadı.";
            break;
          case 'wrong-password':
            errorMessage = "Yanlış şifre. Lütfen şifrenizi kontrol edin.";
            break;
          case 'invalid-email':
            errorMessage = "Geçersiz e-posta adresi formatı.";
            break;
          case 'too-many-requests':
            errorMessage = "Çok fazla giriş denemesi yapıldı. Lütfen biraz bekleyin.";
            break;
          case 'network-request-failed':
            errorMessage = "Bağlantı hatası. İnternet bağlantınızı kontrol edin.";
            break;
          default:
            errorMessage = "Giriş yapılamadı.";
        }
      }

      // Hata mesajını kullanıcıya gösteriyoruz
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

}
