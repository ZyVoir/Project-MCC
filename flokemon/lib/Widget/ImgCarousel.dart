import 'dart:async';

import 'package:flutter/material.dart';

class imageCarousel extends StatefulWidget {
  const imageCarousel({super.key});

  @override
  State<imageCarousel> createState() => _imageCarouselState();
}

class _imageCarouselState extends State<imageCarousel> {
  int currentIndex = 0;
  List<String> imgPaths = [
    "Asset/Carousel/Card 1.png",
    "Asset/Carousel/Card 2.png",
    "Asset/Carousel/Card 3.png",
  ];

  Timer? timer;
  PageController pageController = PageController(initialPage: 1000);

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    pageController.dispose();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      setState(() {
        currentIndex = (currentIndex + 1) % imgPaths.length;
        pageController.nextPage(
            duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
      });
    });
  }

  void goToPage(int index) {
    setState(() {
      currentIndex = index;
      pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: pageController,
            itemCount: imgPaths.length * 2000,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index % imgPaths.length;
              });
            },
            itemBuilder: (context, index) {
              return Image.asset(
                imgPaths[index % imgPaths.length],
                fit: BoxFit.contain,
              );
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            imgPaths.length,
            (index) => buildIndicatorButton(index),
          ),
        )
      ],
    );
  }

  Widget buildIndicatorButton(int index) {
    return GestureDetector(
      onTap: () {
        goToPage(index + (imgPaths.length * 1000));
      },
      child: Container(
        height: 10,
        width: 10,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: currentIndex == index ? Colors.blue : Colors.grey,
        ),
      ),
    );
  }
}
