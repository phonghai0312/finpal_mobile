import 'package:flutter/material.dart';

double getWidth(context) => MediaQuery.sizeOf(context).width;
double getHeight(context) => MediaQuery.sizeOf(context).height;

double getKeyboardHeight(BuildContext context) =>
    MediaQuery.of(context).viewInsets.bottom;
