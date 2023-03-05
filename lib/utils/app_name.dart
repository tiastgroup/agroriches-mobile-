import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppName extends StatelessWidget {
  final double fontSize;
  const AppName({Key? key, required this.fontSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image(image: AssetImage('assets/images/logo1.png'),width: 80.0,),
        Text('riches'
        ,style:GoogleFonts.montserrat(fontSize: 34,fontWeight: FontWeight.normal )),
      ],
 
    );
  }
}
