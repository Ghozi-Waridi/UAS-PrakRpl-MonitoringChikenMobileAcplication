import 'package:flutter/material.dart';
import 'package:project_uas/Constant/Contants/Image_Constant.dart';
import 'package:project_uas/Feature/auth/controller/Auth_controller.dart';
import '../widgets/Buttom_Widgets.dart';
import '../widgets/TextField_widget.dart';

class AuthPage extends StatelessWidget { 
  final bool isObscure = true;
 
  AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 70),  
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.13,
                    width: MediaQuery.of(context).size.height * 0.13,
                    child: Image.asset(ImageConstant().data, fit: BoxFit.contain,),
                  ),
                  Text(
                    "Monitoring Ayam",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan[800],
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 50),

                  /// Bagian Form untuk textfield Di jadikan sebagai widget berbeda, berada di folder widgets
                  Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Username",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFieldWidget(
                          inputType: TextInputType.emailAddress,
                          hint: "Masukkan Alamat Email",
                          obscureText: false,
                          controller: AuthController.to.emailController,
                          errorMessage: "Email tidak boleh kosong",
                        ),
                        SizedBox(height: 50),
                        Text(
                          "Password",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFieldWidget(
                          inputType: TextInputType.emailAddress,
                          hint: "Masukan Password",
                          obscureText: false,
                          controller: AuthController.to.passwordController,
                          errorMessage: "Email tidak boleh kosong",
                          suffixIcon: GestureDetector(
                            onTap: () {},
                            child: Align(
                              widthFactor: 1.0,
                              heightFactor: 1.0,
                              child: Icon(
                                isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 100),
                        Center(
                          child: ButtomWidget(
                            borderRadius: 20,
                            width: 250,
                            text: "LOGIN",
                            textSize: 20,
                           onTap: () {
                              AuthController.to.loginUser();
                            }, 
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
    );
  }
}
