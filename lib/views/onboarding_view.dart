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

    return SafeArea(
      child: Scaffold(
        backgroundColor: cs.surface,
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
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                            child: Text(
                              contents[i],
                              style: tt.titleSmall!.copyWith(color: cs.onSurface),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          images[i],
                          const SizedBox(height: 56),
                          AnimatedSmoothIndicator(
                            activeIndex: currPage,
                            count: contents.length,
                            effect: WormEffect(
                              dotHeight: 10,
                              dotWidth: 10,
                              activeDotColor: cs.primaryContainer,
                              dotColor: cs.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48.0),
                    child: TextButton(
                      onPressed: () {
                        Get.offAll(const LoginView());
                      },
                      child: Text(
                        currPage == contents.length - 1 ? "continue".tr : "skip".tr,
                        style: tt.titleMedium!.copyWith(
                          color: cs.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  if (currPage != contents.length - 1)
                    GestureDetector(
                      onTap: currPage == contents.length - 1
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
                      child: Container(
                        decoration: BoxDecoration(
                          color: cs.primary,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 48),
                          child: Text(
                            "next".tr,
                            style: tt.titleSmall!.copyWith(
                              color: currPage == contents.length - 1 ? cs.primary : cs.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
