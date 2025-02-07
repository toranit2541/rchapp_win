import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:rchapp_v2/data/apiexception.dart';
import 'package:rchapp_v2/data/apiservice.dart';
import 'package:rchapp_v2/sreens/authen/login.dart';
import 'package:rchapp_v2/widget/healthcarepainter.dart';

class Register extends StatefulWidget {
  const Register({super.key, required String title});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final Map<String, dynamic> userData = {};
  final ApiService _apiService = ApiService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _idCardController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final List<String> _genderOptions = ['MALE', 'FEMALE', 'OTHER'];
  String? _selectedGender;
  bool _isLoading = false;

  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      final String birthDate = _birthDateController.text.isNotEmpty
          ? _birthDateController.text
          : '2000-01-01'; // Default birthday if not provided.

      final data = {
        "username": _idCardController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
        "password2": _confirmPasswordController.text,
        "first_name": _firstNameController.text,
        "last_name": _lastNameController.text,
        "account": {
          "gender": _selectedGender,
          "birthday": birthDate,
          "phonenumber": _phoneController.text,
        }
      };

      try {
        await _apiService.registerUser(data);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful!')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const LoginPage(
                      title: 'Rch Plus',
                    )),
          );
        }
      } catch (e) {
        final errorMessage =
            e is ApiException ? e.message : 'An error occurred';
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $errorMessage')),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _birthDateController.dispose();
    _idCardController.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: 120,
          child: Image.asset('assets/images/icons.png'),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
      ),
      body: Stack(
        children: [
          // Background painter
          Positioned.fill(
            child: CustomPaint(
              painter: HealthCarePainter(),
            ),
          ),

          // Content with scrolling
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Center(
                            child: SizedBox(
                              width: 200,
                              height: 150,
                              child: Image.asset('assets/images/rb_3115.png'),
                            ),
                          ),
                        ),
                        _buildTextFormField(
                          hintText: 'Enter ID Card',
                          labelText: 'ID Card',
                          icon: Icons.badge,
                          controller: _idCardController,
                          validator: MultiValidator([
                            RequiredValidator(errorText: 'Enter ID Card'),
                            MinLengthValidator(3,
                                errorText: 'Minimum 3 characters required'),
                          ]).call,
                        ),
                        _buildTextFormField(
                          hintText: 'Enter Password',
                          labelText: 'Password',
                          icon: Icons.lock,
                          controller: _passwordController,
                          isPassword: true,
                          validator: MultiValidator([
                            RequiredValidator(errorText: 'Enter Password'),
                            MinLengthValidator(3,
                                errorText: 'Minimum 3 characters required'),
                          ]).call,
                        ),
                        _buildTextFormField(
                          hintText: 'Enter Confirm Password',
                          labelText: 'Confirm Password',
                          icon: Icons.lock,
                          controller: _confirmPasswordController,
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Confirm Password is required';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        _buildTextFormField(
                          hintText: 'Enter First Name',
                          labelText: 'First Name',
                          icon: Icons.person,
                          controller: _firstNameController,
                          validator: MultiValidator([
                            RequiredValidator(errorText: 'Enter first name'),
                            MinLengthValidator(3,
                                errorText: 'Minimum 3 characters required'),
                          ]).call,
                        ),
                        _buildTextFormField(
                          hintText: 'Enter Last Name',
                          labelText: 'Last Name',
                          icon: Icons.person,
                          controller: _lastNameController,
                          validator: MultiValidator([
                            RequiredValidator(errorText: 'Enter last name'),
                            MinLengthValidator(3,
                                errorText: 'Minimum 3 characters required'),
                          ]).call,
                        ),
                        _buildDatePickerFormField(
                          hintText: 'Enter Birth Day',
                          labelText: 'Birth Day',
                          icon: Icons.calendar_today,
                          controller: _birthDateController,
                          validator: MultiValidator([
                            RequiredValidator(errorText: 'Enter Birth Day'),
                          ]).call,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            setState(() {
                              _birthDateController.text =
                              '${pickedDate?.toLocal()}'.split(' ')[0];
                            });
                          },
                        ),
                        _buildDropdownFormField(
                          hintText: 'Select Gender',
                          labelText: 'Gender',
                          icon: Icons.wc,
                          value: _selectedGender,
                          items: _genderOptions,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a gender';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                        ),
                        _buildTextFormField(
                          hintText: 'Email',
                          labelText: 'Email',
                          icon: Icons.email,
                          controller: _emailController,
                          validator: MultiValidator([
                            RequiredValidator(errorText: 'Enter email address'),
                            EmailValidator(errorText: 'Please enter a valid email'),
                          ]).call,
                        ),
                        _buildTextFormField(
                          hintText: 'Mobile',
                          labelText: 'Mobile',
                          icon: Icons.phone,
                          controller: _phoneController,
                          validator: MultiValidator([
                            RequiredValidator(errorText: 'Enter mobile number'),
                            PatternValidator(r'^\d{10}$',
                                errorText: 'Enter a valid mobile number'),
                          ]).call,
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _register,
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: _isLoading
                                    ? const CircularProgressIndicator(
                                    color: Colors.white)
                                    : const Text('Register',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 22)),
                              ),
                            ),
                          ),
                        ),
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              'Or Sign Up Using',
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20, left: 90),
                            child: Row(
                              children: [
                                _buildIconContainer('assets/images/facebook.svg'),
                                _buildIconContainer('assets/images/google.svg'),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.only(top: 60),
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage(
                                        title: 'Rch Plus',
                                      )),
                                );
                              },
                              child: const Text('SIGN IN'),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


// Example of _buildIconContainer implementation
  Widget _buildIconContainer(String assetPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: CircleAvatar(
        radius: 25,
        child: SvgPicture.asset(
          assetPath,
          height: 25,
          width: 25,
        ),
      ),
    );
  }

  Widget _buildDatePickerFormField({
    required String hintText,
    required String labelText,
    required IconData icon,
    required String? Function(String?) validator,
    TextEditingController? controller,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    GestureTapCallback? onTap, // Add onTap callback for date picker
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        validator: validator,
        onTap: onTap, // Use onTap to open date picker
        readOnly: true, // Prevent keyboard from appearing
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          prefixIcon: Icon(
            icon,
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(9.0)),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(
      {required String hintText,
      required String labelText,
      required IconData icon,
      required String? Function(String?) validator,
      TextEditingController? controller,
      bool isPassword = false,
      TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          prefixIcon: Icon(
            icon,
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(9.0)),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownFormField({
    required String hintText,
    required String labelText,
    required IconData icon,
    required String? Function(String?) validator,
    required List<String> items, // List of dropdown options
    required String? value, // Current value
    required void Function(String?) onChanged, // Callback for value change
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        validator: validator,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          prefixIcon: Icon(
            icon,
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(9.0)),
          ),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
      ),
    );
  }

  // Widget _buildIconContainer(String assetPath) {
  //   if (assetPath.endsWith('.svg')) {
  //     return Container(
  //       height: 40,
  //       width: 120,
  //       margin: const EdgeInsets.symmetric(horizontal: 8.0),
  //       child: SvgPicture.asset(
  //         assetPath,
  //         fit: BoxFit.cover,
  //       ),
  //     );
  //   } else {
  //     return Container(
  //       height: 40,
  //       width: 120,
  //       margin: const EdgeInsets.symmetric(horizontal: 8.0),
  //       child: Image.asset(
  //         assetPath,
  //         fit: BoxFit.cover,
  //       ),
  //     );
  //   }
  // }
}
