import 'package:flutter/material.dart';

final Color primaryColor = Color.fromARGB(255, 79, 160, 202);
final Color primaryTextColor = Color.fromARGB(255, 3, 37, 54);
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;
double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
int navCurrentIndex = 2;
void setBottomNavbar({int index = -1}) => navCurrentIndex = index;
