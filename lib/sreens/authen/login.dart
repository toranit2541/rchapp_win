import 'package:flutter/material.dart';
import 'package:rchapp_v2/data/apiservice.dart';
import 'package:rchapp_v2/sreens/main/mainpage.dart';
import 'package:rchapp_v2/sreens/main/pdpapage.dart';
import 'package:rchapp_v2/widget/abstractthemepainter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ApiService _apiService = ApiService();
  final TextEditingController idCardController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  void sendCredentials() async {
    if (idCardController.text.isEmpty || passwordController.text.isEmpty) {
      // Show a SnackBar for empty fields
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Both fields are required.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final data = {
      'username': idCardController.text.trim(),
      'password': passwordController.text.trim(),
    };

    try {
      final result = await _apiService.loginUser(data);

      if (result['success']) {
        final tokenData = result['data'];
        if (tokenData != null && tokenData.containsKey('access')) {
          await onLoginSuccess(tokenData['access']);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unexpected response format.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['error'] ?? 'Login failed.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> onLoginSuccess(String token) async {
    await _apiService.saveAccessToken(token);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Painter
          CustomPaint(
            size: Size(double.infinity, double.infinity),
            painter: AbstractThemePainter (),
          ),

          // Main Content
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Image(
                      image: AssetImage('assets/images/im-hop.png'),
                      width: 300,
                    ),
                    const SizedBox(height: 20),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text('Sign in'),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: idCardController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'ID Card',
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Password',
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {},
                                  child: const Text("Forgot Password"),
                                ),
                                const Spacer(),
                                ElevatedButton(
                                  onPressed: isLoading ? null : sendCredentials,
                                  child: isLoading
                                      ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                      : const Text('Login'),
                                ),
                              ],
                            ),
                            if (errorMessage.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Text(
                                  errorMessage,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Do Not Have An Account?'),
                        const SizedBox(width: 4),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PDPAPage()),
                            );
                          },
                          child: const Text('Go to Register'),
                        ),
                      ],
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

}
