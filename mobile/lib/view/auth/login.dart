import 'package:client/controller/users_auth/login_controller.dart';
import 'package:client/core/functions/validInput.dart';
import 'package:client/view/auth/register.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  const Login({
    Key? key,
  }) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loading = false;
  LoginControllerImp controller = Get.put(LoginControllerImp());
  String passwordError = "";
  String emailError = "";

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(), // Disable scrolling
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
                              "Login",
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

            // Form Login
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 45),
              child: Form(
                key: controller.formstate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Email
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
                          Icons.email,
                          size: 25,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    // Password
                    Container(height: 20),
                    const Text(
                      "Password",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
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
                          Icons.lock,
                          size: 25,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    // links
                    Container(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          child: const Text(
                            "Don't have an account?",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () {
                            Get.off(() => const Register());
                          },
                        ),
                        const InkWell(
                          child: Text(
                            "Forgot password?",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Buttons
                    Container(height: 35),
                    MaterialButton(
                      onPressed: () async {
                        setState(() {});
                        if (controller.formstate.currentState!.validate() &&
                            controller.password.text.isNotEmpty &&
                            controller.email.text.isNotEmpty) {
                          setLoading(true);
                          await controller.login();
                          setLoading(false);
                        }
                      },
                      height: 38,
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(height: 10),
                    MaterialButton(
                      onPressed: () async {
                        Get.offAllNamed("/bottom-bar");
                      },
                      color: const Color.fromARGB(255, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(width: 1),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Login as visitor",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
