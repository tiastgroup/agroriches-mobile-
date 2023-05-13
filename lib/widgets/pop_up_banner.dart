import 'package:flutter/material.dart';
import 'package:news_app/utils/urls.dart';

bool _isAlertDialogShowing = false;

void showCustomAlertDialog(
    BuildContext context, String siteUrl, String imageUrl) async {
  if (_isAlertDialogShowing) return;

  _isAlertDialogShowing = true;
  await showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 500),
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => openUrl(siteUrl),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.fitWidth,
                ),
              ),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close),
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
  );

  _isAlertDialogShowing = false;
}

  // showDialog(
  //   context: context,
  //   barrierDismissible: true, // Allows dismissing the dialog by tapping outside
  //   builder: (BuildContext context) {
  //     return AlertDialog(
  //       contentPadding: EdgeInsets.all(0), // Remove padding around the image
  //       content: Stack(
  //         alignment: Alignment.topRight,
  //         children: [
  //           InkWell(
  //             onTap: () => openUrl('https://www.example.com'),
  //             child: Image.network(
  //               imageUrl,
  //               fit: BoxFit.cover,
  //             ),
  //           ),
  //           IconButton(
  //             icon: Icon(Icons.close),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       ),
  //     );
  //   },
  // );
