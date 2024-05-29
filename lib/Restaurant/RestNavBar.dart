import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';
import 'package:orderligui/Restaurant/GenerateOR.dart';
import 'package:orderligui/Restaurant/RestHome.dart';
import 'package:orderligui/Restaurant/RestMenu.dart';
import 'package:orderligui/Restaurant/RestOrderHistory.dart';
import 'package:orderligui/Restaurant/RestProfile.dart';

class RestVav extends StatelessWidget {
  const RestVav({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =Get.put(NavigationController2());
    return Scaffold(
      bottomNavigationBar: Obx(
            ()=> NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index)=>controller.selectedIndex.value=index,
          destinations: [
            NavigationDestination(icon: Icon(Iconsax.home), label:"Home"),
            NavigationDestination(icon: Icon(Icons.history), label:"History"),
            NavigationDestination(icon: Icon(Iconsax.menu), label:"Menu"),
            NavigationDestination(icon: Icon(Iconsax.scan_barcode), label:"QR"),
            NavigationDestination(icon: Icon(Iconsax.user), label:"Profile"),
          ],

        ),
      ),
      body: Obx(()=> controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController2 extends GetxController{
  final Rx<int> selectedIndex=0.obs;

  final screens=[RestHome(),SecondScreen2(),MenuListPage(), QRCodeGeneratorScreen(),RestProfile(),];

}
