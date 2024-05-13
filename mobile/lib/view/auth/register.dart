import 'package:client/controller/users_auth/signup_controller.dart';
import 'package:client/core/functions/validInput.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  SignUpControllerImp controller =
      Get.put(SignUpControllerImp(), permanent: true);
  bool loading = false;
  String passwordError = "";
  String emailError = "";
  String firstNameError = "";
  String lastNameError = "";
  String phoneError = "";
  String postalCodeError = "";
  List<String> options = ['Basic Account', 'Lawyer'];

  void setLoading(bool value) {
    setState(() {
      loading = value;
    });
  }

  @override
  void initState() {
    super.initState();
    controller.email.text = "";
    controller.password.text = "";
    controller.firstName.text = "";
    controller.lastName.text = "";
    controller.postalCode.text = "";
    controller.phoneNumber.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 230,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(60),
                ),
                color: Colors.black87,
              ),
              child: Stack(
                children: <Widget>[
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 700),
                    builder:
                        (BuildContext context, double value, Widget? child) {
                      return Positioned(
                        left: 40,
                        top: -170 + 170 * value,
                        child: Image.asset("assets/images/light-1.png",
                            scale: 1.6),
                      );
                    },
                  ),
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 700),
                    builder:
                        (BuildContext context, double value, Widget? child) {
                      return Positioned(
                        left: 140,
                        top: -130 + 130 * value,
                        child: Image.asset("assets/images/light-2.png",
                            scale: 1.6),
                      );
                    },
                  ),
                  Positioned(
                    child: Container(
                      margin: const EdgeInsets.only(top: 140),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/logo.png", scale: 11),
                            const SizedBox(width: 3),
                            const Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Color.fromARGB(255, 212, 64, 53),
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 50,
              color: Colors.black87,
              child: Container(
                height: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                  ),
                  color: Colors.white,
                ),
              ),
            ),

            // Form SignUp
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Form(
                key: controller.formstateRegister,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "First Name",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    Container(height: 5),
                    TextFormField(
                      validator: (val) {
                        firstNameError = validInput(val!, 2, 100, "username");
                        return firstNameError.isNotEmpty
                            ? firstNameError
                            : null;
                      },
                      controller: controller.firstName,
                      style: const TextStyle(),
                      decoration: InputDecoration(
                        suffixIcon: const Icon(
                          FontAwesomeIcons.solidUser,
                          size: 22,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Container(height: 22),
                    const Text(
                      "Last Name",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    Container(height: 5),
                    TextFormField(
                      validator: (val) {
                        lastNameError = validInput(val!, 2, 100, "username");
                        return lastNameError.isNotEmpty ? lastNameError : null;
                      },
                      controller: controller.lastName,
                      style: const TextStyle(),
                      decoration: InputDecoration(
                        suffixIcon: const Icon(
                          FontAwesomeIcons.userGroup,
                          size: 22,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Container(height: 22),
                    const Text(
                      "Email",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    Container(height: 5),
                    TextFormField(
                      validator: (val) {
                        emailError = validInput(val!, 5, 100, "email");
                        return emailError.isNotEmpty ? emailError : null;
                      },
                      controller: controller.email,
                      style: const TextStyle(),
                      decoration: InputDecoration(
                        suffixIcon: const Icon(
                          FontAwesomeIcons.solidEnvelope,
                          size: 23,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Container(height: 22),
                    const Text(
                      "Password",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    Container(height: 5),
                    TextFormField(
                      validator: (val) {
                        passwordError = validInput(val!, 8, 100, "password");
                        return passwordError.isNotEmpty ? passwordError : null;
                      },
                      controller: controller.password,
                      obscureText: true,
                      style: const TextStyle(),
                      decoration: InputDecoration(
                        suffixIcon: const Icon(
                          FontAwesomeIcons.fingerprint,
                          size: 22,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Container(height: 22),
                    const Text(
                      "Phone Number",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    Container(height: 5),
                    TextFormField(
                      validator: (val) {
                        phoneError = validInput(val!, 10, 100, "phone");
                        return phoneError.isNotEmpty ? phoneError : null;
                      },
                      controller: controller.phoneNumber,
                      style: const TextStyle(),
                      decoration: InputDecoration(
                        suffixIcon: const Icon(
                          FontAwesomeIcons.phone,
                          size: 22,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Container(height: 22),
                    const Text(
                      "Postal Code",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    Container(height: 5),
                    TextFormField(
                      validator: (val) {
                        postalCodeError =
                            validInput(val!, 4, 100, "postalCode");
                        return postalCodeError.isNotEmpty
                            ? postalCodeError
                            : null;
                      },
                      controller: controller.postalCode,
                      style: const TextStyle(),
                      decoration: InputDecoration(
                        suffixIcon: const Icon(
                          Icons.map,
                          size: 26,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Container(height: 22),
                    const Text(
                      "User Role",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    Container(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black54,
                          width: 1.1,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: DropdownButton<String>(
                        value: controller.userRole,
                        items: options.map((String option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              controller.userRole = newValue;
                            });
                          }
                        },
                        isExpanded: true,
                        underline: const SizedBox(),
                      ),
                    ),

                    // Buttons
                    Container(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          child: const Text(
                            "I already have an account",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () {
                            Get.offNamed("/login");
                          },
                        )
                      ],
                    ),
                    Container(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: MaterialButton(
                            onPressed: () async {
                              setState(() {});
                              if (controller.formstateRegister.currentState!
                                      .validate() &&
                                  controller.password.text.isNotEmpty &&
                                  controller.email.text.isNotEmpty &&
                                  controller.firstName.text.isNotEmpty &&
                                  controller.lastName.text.isNotEmpty &&
                                  controller.phoneNumber.text.isNotEmpty &&
                                  controller.postalCode.text.isNotEmpty) {
                                setLoading(true);
                                await controller.signUp();
                                setLoading(false);
                              }
                            },
                            height: 38,
                            color: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(height: 15),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "or",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Container(height: 15),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(width: 1),
                      ),
                      onPressed: () {},
                      color: const Color.fromARGB(255, 255, 255, 255),
                      child: const Row(
                        children: [
                          Icon(Icons.email),
                          Text(
                            "                 Continue with Google",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(height: 5),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(width: 1),
                      ),
                      onPressed: () {},
                      color: const Color.fromARGB(255, 255, 255, 255),
                      child: const Row(
                        children: [
                          Icon(Icons.facebook),
                          Text(
                            "                  Continue with Facebook",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
