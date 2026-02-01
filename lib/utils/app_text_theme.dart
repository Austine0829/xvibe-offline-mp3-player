import 'package:flutter/material.dart';

extension AppTextTheme on TextTheme {
  TextStyle get pageLabel => 
    titleLarge!.copyWith(fontSize: 20,
                         color: Colors.white);

  TextStyle get sectionLabel => 
    titleLarge!.copyWith(fontSize: 22,
                         color: Colors.white,);

  TextStyle get horizontalCardTitle => 
    titleLarge!.copyWith(fontSize: 14,
                         color: Colors.white);

  TextStyle get cardGenre => 
    titleLarge!.copyWith(fontSize: 14,
                         color: Colors.white54);

  TextStyle get verticalCardTitle => 
    titleLarge!.copyWith(fontSize: 14,
                         color: Colors.white);  
  TextStyle get textButtonColor => 
    titleLarge!.copyWith(color: Colors.white54);                      
}