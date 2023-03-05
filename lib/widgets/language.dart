import 'package:flutter/material.dart';
import 'package:news_app/config/config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class LanguagePopup extends StatefulWidget {
  const LanguagePopup({Key? key}) : super(key: key);

  @override
  _LanguagePopupState createState() => _LanguagePopupState();
}

class _LanguagePopupState extends State<LanguagePopup> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('select language').tr(),
      ),
      body : ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: Config().languages.length,
        itemBuilder: (BuildContext context, int index) {
         return _itemList(Config().languages[index], index);
       },
      ),
    );
  }

  Widget _itemList (d, index){
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.language),
          title: Text(d),
          onTap: () async{
            if(d == 'English'){
             await context.setLocale(Locale('en'));
             Get.updateLocale(Locale('en'));
            }
             else if(d == 'Chinese'){
             await context.setLocale(Locale('zh'));
             Get.updateLocale(Locale('zh'));

            }
            else if(d == 'French'){ 
            await context.setLocale(Locale('fr'));
            Get.updateLocale(Locale('fr'));

            }
            // else if (d == 'Arabic'){
            //   context.setLocale(Locale('ar'));
            // }
            // else if(d == 'your_language_name'){
            //   context.setLocale(Locale('your_language_code'));
            // }
            
            Navigator.pop(context);
          },
        ),
        Divider(height: 3, color: Colors.grey[400],)
      ],
    );
  }
}