import 'package:flutter/material.dart';

class TenantConfig {
  final String name;
  //final String logoAsset;
  final Color mainColor;
  final String fontFamily;

  const TenantConfig({
    required this.name,
    //required this.logoAsset,
    required this.mainColor,
    this.fontFamily = "Roboto",
  });
}

// Tenant configuration
const TenantConfig tenant = TenantConfig(
  name: "Studio Manager",
  //logoAsset: "assets/logo.png",
  mainColor: Color(0xFF1152D4), // Change this once, updates everything
  fontFamily: "Roboto",
);
