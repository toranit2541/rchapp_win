import 'package:flutter/material.dart';
import 'package:rchapp_v2/sreens/authen/register.dart';

class PDPAPage extends StatefulWidget {
  const PDPAPage({super.key});

  @override
  State<PDPAPage> createState() => _PDPAPageState();
}

class _PDPAPageState extends State<PDPAPage> {
  bool _isAgreed = false;

  void _onSubmit() {
    if (_isAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Thank you for accepting the agreement."),
          duration: Duration(seconds: 1),
        ),
      );

      // Navigate after the snackbar is shown
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Register(title: 'Rch Plus'),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please accept the agreement to continue."),
          duration: Duration(seconds: 2),
        ),
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
            bottomLeft: Radius.circular(25),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.greenAccent, Colors.teal],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Privacy Data Protection Agreement (PDPA)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        '''By using this app, you agree to the collection, use, and sharing of your personal data as described in this agreement:

1. **Purpose**: Your data will be used only for purposes related to this service.
2. **Consent**: Your explicit consent is required to collect and process sensitive personal data.
3. **Rights**: You have the right to access, modify, or delete your personal data upon request.
4. **Security**: We prioritize safeguarding your data through encryption and secure storage methods.

Please read the full agreement carefully. By toggling the switch below and proceeding, you confirm your agreement with these terms.
''',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
              ElevatedButton(
                onPressed: _isAgreed ? _onSubmit : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: _isAgreed ? Colors.teal : Colors.grey,
                  disabledForegroundColor: Colors.white.withOpacity(0.5),
                  disabledBackgroundColor: Colors.grey.withOpacity(0.5),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


