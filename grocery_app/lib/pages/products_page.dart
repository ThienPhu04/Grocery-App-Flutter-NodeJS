import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/components/product_card.dart';
import 'package:grocery_app/models/pagination.dart';
import 'package:grocery_app/models/product_filter.dart';
import 'package:grocery_app/models/product_sort.dart';
import 'package:grocery_app/providers/providers.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String? categoryId;
  String? categoryName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sản phẩm"),
      ),
      body: Container(
        color: Colors.grey[300],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProductFilters(
              categoryId: categoryId,
              categoryName: categoryName,
            ),
            Flexible(
              child: _ProductsList(),
              flex: 1,
            )
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    final Map? arguments = ModalRoute.of(context)!.settings.arguments as Map;

    if (arguments != null) {
      categoryName = arguments['categoryName'];
      categoryId = arguments['categoryId'];
    }
    super.didChangeDependencies();
  }
}

class _ProductFilters extends ConsumerWidget {
  final _sortOptions = [
    ProductSortModel(value: "createdAt", label: "Latest"),
    ProductSortModel(value: "-productPrice", label: "Price: High to Low"),
    ProductSortModel(value: "productPrice", label: "Price: Low to Hight"),
  ];

  _ProductFilters({
    Key? key,
    this.categoryName,
    this.categoryId,
  });

  final String? categoryName;
  final String? categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterProvider = ref.watch(productsFilterProvider);

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(productsNotifierProvider.notifier).refreshProducts(),
      child: Container(
        height: 51,
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                categoryName!,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.grey[300]),
              child: PopupMenuButton(
                onSelected: (sortBy) {
                  ProductFilterModel filterModel = ProductFilterModel(
                      paginationModel: PaginationModel(page: 0, pageSize: 10),
                      categoryId: filterProvider.categoryId,
                      sortBy: sortBy.toString());

                  ref
                      .read(productsFilterProvider.notifier)
                      .setProductFilter(filterModel);

                  ref.read(productsNotifierProvider.notifier).getProducts();
                },
                initialValue: filterProvider.sortBy,
                itemBuilder: (BuildContext context) {
                  return _sortOptions.map((item) {
                    return PopupMenuItem(
                        value: item.value,
                        child: InkWell(
                          child: Text(item.label!),
                        ));
                  }).toList();
                },
                icon: const Icon(Icons.filter_list_alt),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductsList extends ConsumerWidget {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(productsNotifierProvider);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        final productsViewModel = ref.read(productsNotifierProvider.notifier);
        final productsState = ref.watch(productsNotifierProvider);

        if (productsState.hasNext) {
          productsViewModel.getProducts();
        }
      }
    });
    if (productsState.products.isEmpty) {
      if (!productsState.hasNext && !productsState.isLoading) {
        return const Center(
          child: Text("No Products"),
        ); // Center
      }
      return const LinearProgressIndicator();
    }

    return Column(
      children: [
        Flexible(
          flex: 1,
          child: GridView.count(
            crossAxisCount: 2,
            controller: _scrollController,
            children: List.generate(
              productsState.products.length,
              (index) {
                return ProductCard(
                  model: productsState.products[index],
                );
              },
            ),
          ),
        ),
        Visibility(
          visible: productsState.isLoading && productsState.products.isNotEmpty,
          child: SizedBox(
            height: 35,
            width: 35,
            child: const CircularProgressIndicator(),
          ),
        )
      ],
    );
  }
}
