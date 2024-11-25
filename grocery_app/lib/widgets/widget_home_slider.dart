import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/models/pagination.dart';
import 'package:grocery_app/models/slider.dart';
import 'package:grocery_app/providers/providers.dart';

class HomeSliderWidget extends ConsumerWidget {
  const HomeSliderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.white,
      child: _sliderList(ref),
    );
  }

  Widget _sliderList(WidgetRef ref) {
    final sliders = ref.watch(
      slidersProvider(
        PaginationModel(
          page: 1,
          pageSize: 10,
        ),
      ),
    );

    return sliders.when(
      data: (list) {
        // Filter out null elements from the list if any
        final nonNullSliders = list?.whereType<SliderModel>().toList() ?? [];
        if (nonNullSliders.isEmpty) {
          return const Center(child: Text('No sliders available.'));
        }
        return imageCarousel(nonNullSliders); // Pass the filtered list
      },
      error: (error, stack) => Center(
        child: Text('Error loading sliders: $error'),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget imageCarousel(List<SliderModel> sliderList) {
    return CarouselSlider(
      items: sliderList.map((model) {
        return Container(
          child: Image.network(
            model.fullImagePath,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(child: Icon(Icons.error));
            },
          ),
        );
      }).toList(),
      options: CarouselOptions(
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.decelerate,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        viewportFraction: 0.8,
      ),
    );
  }
}
