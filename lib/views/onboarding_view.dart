import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shipment/views/login_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  @override
  void initState() {
    GetStorage getStorage = GetStorage();
    getStorage.write("onboarding", true);
    super.initState();
  }

  int currPage = 0;

  List<Widget> images = [
    SvgPicture.asset("assets/images/driver.svg", height: 150),
    SvgPicture.asset("assets/images/employee.svg", height: 150),
    SvgPicture.asset("assets/images/customer.svg", height: 150),
    SvgPicture.asset("assets/images/company.svg", height: 150),
  ];

  List<String> titles = [
    "Welcome to Kamiyon".tr,
    "smart orders".tr,
    "Real-Time Tracking".tr,
    "Manage Your Fleet".tr,
  ];

  List<String> contents = [
    "Easily connect with drivers, companies, and customers to manage every shipment in one place.".tr,
    "Create or accept shipment requests in seconds — simple, fast, and reliable for everyone.".tr,
    "Track every delivery live on the map. Stay informed about your shipment’s progress anytime, anywhere.".tr,
    "For companies with multiple vehicles and drivers — organize, assign, and monitor everything effortlessly.".tr,
  ];

  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(
                contents.length,
                (i) => Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    images[i],
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 32),
                          child: Text(
                            titles[i],
                            style: tt.headlineLarge!.copyWith(color: cs.primary),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                          child: Text(
                            contents[i],
                            style: tt.titleMedium!.copyWith(color: cs.onSurface),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: cs.primary,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.offAll(const LoginView());
                    },
                    child: Text(
                      currPage == contents.length - 1 ? "continue".tr : "skip".tr,
                      style: tt.titleLarge!.copyWith(color: cs.onPrimary),
                    ),
                  ),
                  AnimatedSmoothIndicator(
                    activeIndex: currPage,
                    count: contents.length,
                    effect: WormEffect(
                      dotHeight: 11,
                      dotWidth: 11,
                      activeDotColor: cs.primaryContainer,
                      dotColor: cs.onPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: currPage == contents.length - 1
                        ? null
                        : () {
                            setState(() {
                              pageController.nextPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeIn,
                              );
                              currPage++;
                            });
                          },
                    child: Text(
                      "next".tr,
                      style: tt.titleLarge!.copyWith(
                        color: currPage == contents.length - 1 ? cs.primary : cs.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
