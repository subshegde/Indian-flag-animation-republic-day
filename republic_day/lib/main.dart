import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    ));

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: screenWidth < 600 ? 2 : 4,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: 10,
          itemBuilder: (context, index) {
            return FlagWidget(controller: _controller, screenWidth: screenWidth, screenHeight: screenHeight);
          },
        ),
      ),
    );
  }
}

class FlagWidget extends StatelessWidget {
  final AnimationController controller;
  final double screenWidth;
  final double screenHeight;

  const FlagWidget({Key? key, required this.controller, required this.screenWidth, required this.screenHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              color: const Color.fromRGBO(255, 153, 51, 1),
              width: screenWidth * 1,
            ),
          ),
        ),
        AnimatedBuilder(
          animation: controller,
          child: Image.asset(
            'assets/ashok_chakra.png',
            height: screenWidth * 0.15,
            width: screenWidth * 0.15,
          ),
          builder: (BuildContext context, Widget? _widget) {
            if (_widget == null) {
              return const SizedBox.shrink();
            }
            return Transform.rotate(
              angle: controller.value * 2 * 3.141592653589793,
              child: _widget,
            );
          },
        ),
        Expanded(
          child: RotatedBox(
            quarterTurns: 2,
            child: ClipPath(
              clipper: CustomShapeClipper(),
              child: Container(
                color: const Color.fromRGBO(19, 136, 8, 1),
                width: screenWidth * 0.5
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height);

    var firstEndPoint = Offset(size.width * 0.5, size.height - 30.0);
    var firstControlPoint = Offset(size.width * 0.25, size.height - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 80.0);
    var secondControlPoint = Offset(size.width * .75, size.height - 10);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0.0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
