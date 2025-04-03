import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:project_uas/Constant/Contants/Image_Constant.dart';
// import 'package:project_uas/Feature/NoConnection/view/no_connection_page.dart';
import 'package:project_uas/Feature/no_connection/view/Page/no_connection_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    List listMenu = [
      {"title": "Data Ayam", "icon": ImageConstant().data, "route": "/dataAyam"},
      {"title": "History", "icon": ImageConstant().history, "route": "/history"},
      {"title": "Informasi Ayam", "icon": ImageConstant().information, "route": "/information"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("HomePage")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Image.asset(
                    "assets/chicken-2.png",
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Pemantauan Ayam",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: listMenu.map((item) {
                      return InkWell(
                        onTap: () async {
                          var connectivityResult = await Connectivity().checkConnectivity();
                          if (connectivityResult == ConnectivityResult.none) {
                            Get.to(() => const NoConnectionPage());
                          } else {
                            Get.toNamed(item["route"]);
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 32,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                item["icon"],
                                height: 80,
                                width: 80,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                item["title"],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
