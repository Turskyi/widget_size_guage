import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title});
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controller = ScrollController();
  OverlayEntry? _stickyLayout;
  GlobalKey _stickyGlobalKey = GlobalKey();

  @override
  void initState() {
    if (_stickyLayout != null) {
      _stickyLayout!.remove();
    }
    _stickyLayout = OverlayEntry(builder: (context) => _stickyBuilder(context));

    SchedulerBinding.instance?.addPostFrameCallback((_) {
      Overlay.of(context)?.insert(_stickyLayout!);
    });

    super.initState();
  }

  @override
  void dispose() {
    _stickyLayout?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        controller: _controller,
        itemBuilder: (context, index) {
          if (index == 6) {
            return Container(
              key: _stickyGlobalKey,
              /* Thanks to [_stickyGlobalKey]
               it is possible to retrieve the height below in other widget */
              height: 120.0,
              color: Colors.green,
              child: const Text("I'm fat"),
            );
          }
          return ListTile(
            title: Text(
              'Hello $index',
              style: const TextStyle(color: Colors.black),
            ),
          );
        },
      ),
    );
  }

  /// this widget is builded above other widgets,
  /// and bellow widget which has "_stickyGlobalKey"
  Widget _stickyBuilder(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_,Widget? child) {
        final BuildContext? keyContext = _stickyGlobalKey.currentContext;
        if (keyContext != null) {
          // widget is visible
          final RenderBox box = keyContext.findRenderObject() as RenderBox;
          final Offset pos = box.localToGlobal(Offset.zero);
          print("===>> ${box.size.height}");
          return Positioned(
            top: pos.dy + box.size.height,
            left: 50.0,
            right: 50.0,
            height: box.size.height,
            child: Material(
              child: Container(
                alignment: Alignment.center,
                color: Colors.purple,
                child: const Text("^ Nah I think you're okay"),
              ),
            ),
          );
        }
        return SizedBox();
      },
    );
  }
}