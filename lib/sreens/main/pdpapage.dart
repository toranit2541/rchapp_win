import 'package:flutter/material.dart';
import 'package:rchapp_v2/sreens/authen/register.dart';

class PdpaPage extends StatefulWidget {
  const PdpaPage({super.key});

  @override
  _PdpaPageState createState() => _PdpaPageState();
}

class _PdpaPageState extends State<PdpaPage> {
  bool _isAgreed = false;

  void _onSubmit() {
    if (_isAgreed) {
      // Proceed with next steps, e.g., navigate to the next screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thank you for accepting the PDPA.')),
      );
      // Navigate to another page (Register page)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Register()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the PDPA to continue.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: 120,
          child: Image.asset('assets/images/test/banner.png'),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF66ca97), Color(0xFF66cac9), Color(0xFF6699ca)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.blue[600],
                    alignment: Alignment.center,
                    transform: Matrix4.rotationZ(0.1),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Privacy Data Protection Agreement (PDPA)',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '''
By using this app, you agree to the collection, use, and sharing of your personal data as described in this agreement:

1. **Purpose**: Your data will be used only for purposes related to this service.
2. **Consent**: Your explicit consent is required to collect and process sensitive personal data.
3. **Rights**: You have the right to access, modify, or delete your personal data upon request.
4. **Security**: We prioritize safeguarding your data through encryption and secure storage methods.

Please read the full agreement carefully. By toggling the switch below and proceeding, you confirm your agreement with these terms.
                    ''',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 30),
                      ],
                    )),
                Row(
                  children: [
                    Switch(
                      value: _isAgreed,
                      onChanged: (value) {
                        setState(() {
                          _isAgreed = value;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'I agree to the terms and conditions.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _onSubmit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(fontSize: 18),
                    ),
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
