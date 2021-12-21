import 'package:flutter/cupertino.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 150),
        height: 180,
        child: const CupertinoActivityIndicator(),
      ),
    );
  }
}
