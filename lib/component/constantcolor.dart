import 'package:flutter/material.dart';

// colour for scaffold
const primaryColor = Color.fromARGB(255, 228, 223, 223);
const baseurl = "https://support.nctbutwal.com.np/api/";
//colour for icon colour
const iconColor = Color.fromRGBO(61, 71, 152, 1);
// colour for bottom appbar
const unSelectedColor = Color.fromRGBO(61, 71, 152, 0.7);

// Text Colour
const textColour = Color(0xffaf2627);
const textfieldcolor = Color.fromARGB(
  255,
  212,
  221,
  227,
);
const buttoncolor = Color.fromARGB(255, 199, 166, 124);

Color getColor(int value) {
  double opacityValue = (value + 2) / 10;
  return Color.fromRGBO(255, 0, 0, opacityValue);
}
