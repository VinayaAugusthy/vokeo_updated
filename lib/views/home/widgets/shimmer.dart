
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vokeo/controller/utils/spacing.dart';

class LoadingShimmer extends StatefulWidget {
  const LoadingShimmer({super.key});

  @override
  State<LoadingShimmer> createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<LoadingShimmer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) => loadingShimmer(context),
      ),
    );
  }

  SingleChildScrollView loadingShimmer(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.width * 0.005,
          horizontal: MediaQuery.of(context).size.width * 0.005,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 16,
              ).copyWith(right: 0),
              child: Row(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade800,
                    highlightColor: Colors.grey.shade600,
                    enabled: true,
                    child: const CircleAvatar(
                      radius: 16,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade800,
                    highlightColor: Colors.grey.shade600,
                    child: SizedBox(
                      height: 10,
                      width: 60,
                      child: Container(
                        color: Colors.grey.shade800,
                      ),
                    ),
                  )
                ],
              ),
            ),
            getVerticalSpace(10),
            Shimmer.fromColors(
              baseColor: Colors.grey.shade800,
              highlightColor: Colors.grey.shade600,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                child: Container(
                  color: Colors.white, // Background color for shimmer
                ),
              ),
            ),
            getVerticalSpace(10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade800,
                highlightColor: Colors.grey.shade600,
                child: SizedBox(
                  height: 10,
                  width: 60,
                  child: Container(
                    color: Colors.white, // Background color for shimmer
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade800,
                highlightColor: Colors.grey.shade600,
                child: SizedBox(
                  height: 10,
                  width: 100,
                  child: Container(
                    color: Colors.white, // Background color for shimmer
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade800,
                highlightColor: Colors.grey.shade600,
                child: SizedBox(
                  height: 10,
                  width: 150,
                  child: Container(
                    color: Colors.white, // Background color for shimmer
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade800,
                highlightColor: Colors.grey.shade600,
                child: SizedBox(
                  height: 10,
                  width: 100,
                  child: Container(
                    color: Colors.white, // Background color for shimmer
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
