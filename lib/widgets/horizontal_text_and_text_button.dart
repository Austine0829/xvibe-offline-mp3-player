import 'package:flutter/material.dart';

import '../utils/app_text_theme.dart';

class HorizontalTextAndTextButton extends StatelessWidget {
  final String label;
  final VoidCallback? callback;

  const HorizontalTextAndTextButton({
    super.key,
    required this.label,
    this.callback
  });

  void runCallBack() {
    if (callback == null) return;
    callback!();
  }

  @override 
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.sectionLabel
            )  
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap
            ),
            onPressed: () {
             runCallBack();
            }, 
            child: Text("Show More", style: TextStyle(color: Colors.white54))
        )
      ])
    );
  }
}