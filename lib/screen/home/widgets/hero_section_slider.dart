import 'dart:async';
import 'package:flutter/material.dart';

class HeroSectionSlider extends StatefulWidget {
  @override
  _HeroSectionSliderState createState() => _HeroSectionSliderState();
}

class _HeroSectionSliderState extends State<HeroSectionSlider> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // Slider data
  final List<Map<String, String>> sliderData = [
    {
      "image":
          "https://images.pexels.com/photos/2693644/pexels-photo-2693644.jpeg?auto=compress&cs=tinysrgb&w=600",
      "text": "Welcome to Ecommerce!"
    },
    {
      "image":
          "https://images.pexels.com/photos/3183150/pexels-photo-3183150.jpeg?auto=compress&cs=tinysrgb&w=600",
      "text": "Discover Amazing Products!"
    },
    {
      "image":
          "https://images.pexels.com/photos/261187/pexels-photo-261187.jpeg?auto=compress&cs=tinysrgb&w=600",
      "text": "Enjoy Big Discounts!"
    },
    {
      "image":
          "https://images.pexels.com/photos/261187/pexels-photo-261187.jpeg?auto=compress&cs=tinysrgb&w=600",
      "text": "Enjoy Big Discounts!"
    },
    {
      "image":
          "https://images.pexels.com/photos/261187/pexels-photo-261187.jpeg?auto=compress&cs=tinysrgb&w=600",
      "text": "Enjoy Big Discounts!"
    },
    {
      "image":
          "https://images.pexels.com/photos/261187/pexels-photo-261187.jpeg?auto=compress&cs=tinysrgb&w=600",
      "text": "Enjoy Big Discounts!"
    },
    {
      "image":
          "https://images.pexels.com/photos/261187/pexels-photo-261187.jpeg?auto=compress&cs=tinysrgb&w=600",
      "text": "Enjoy Big Discounts!"
    },
  ];

  // Timer for auto-slide
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 2), (Timer timer) {
      if (_currentIndex < sliderData.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }

      _pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen height to set responsive height for the slider
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        height: screenHeight * 0.25, // 25% of the screen height
        child: PageView.builder(
          controller: _pageController,
          itemCount: sliderData.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(sliderData[index]["image"]!),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Text(
                  sliderData[index]["text"]!,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
