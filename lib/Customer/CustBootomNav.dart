import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';
import 'package:orderligui/Customer/CustHome.dart';
import 'package:orderligui/Customer/CustOrderHistory.dart';
import 'package:orderligui/Customer/CustProfile.dart';
import 'package:orderligui/Customer/Scanner.dart';

class CustVav extends StatelessWidget {
  const CustVav({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =Get.put(NavigationController());
    return Scaffold(
      bottomNavigationBar: Obx(
        ()=> NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index)=>controller.selectedIndex.value=index,
          destinations: [
            NavigationDestination(icon: Icon(Iconsax.home), label:"Home"),
            NavigationDestination(icon: Icon(Iconsax.scan), label:"Scan"),
            NavigationDestination(icon: Icon(Icons.history), label:"History"),
            NavigationDestination(icon: Icon(Iconsax.user), label:"Profile"),
          ],
        
        ),
      ),
      body: Obx(()=> controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController{
  final Rx<int> selectedIndex=0.obs;

  final screens=[CustHome(),QRCodeScreen(),SecondScreen(),Custprofile()];

}
