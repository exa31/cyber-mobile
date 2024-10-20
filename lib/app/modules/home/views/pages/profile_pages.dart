import 'package:cyber/app/modules/home/controllers/home_controller.dart';
import 'package:cyber/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePages extends StatelessWidget {
  ProfilePages({super.key});

  final HomeController homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(children: [
        Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 5,
                        ),
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            AssetImage('assets/images/profile.png'),
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 30),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${homeController.name?.split(' ')[0]}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            '${homeController.email}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Get.toNamed(Routes.ADDRESS);
                      },
                      leading: Icon(Icons.location_on),
                      title: Text('Manage Addresses'),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                    ListTile(
                      onTap: () {
                        Get.toNamed(Routes.ORDER_HISTORY);
                      },
                      leading: Icon(Icons.history),
                      title: Text('Order History'),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
