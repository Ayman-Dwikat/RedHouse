import 'dart:async';
import 'package:client/controller/static_api/static_controller.dart';
import 'package:client/controller/users_auth/login_controller.dart';
import 'package:client/model/property.dart';
import 'package:client/model/property_files.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ImageSliderWidget extends StatefulWidget {
  final List<PropertyFile> propertyFiles;
  final Property property;

  ImageSliderWidget({required this.propertyFiles, required this.property});

  @override
  _ImageSliderWidgetState createState() => _ImageSliderWidgetState();
}

class _ImageSliderWidgetState extends State<ImageSliderWidget> {
  LoginControllerImp loginController = Get.put(LoginControllerImp());
  StaticController staticController = Get.put(StaticController());

  PageController controller = PageController();
  int slider = 1;

  late bool _isLoading;
  late Timer _timer;
  late bool isFavorite;

  @override
  void initState() {
    super.initState();

    // Check if property with the same ID exists in favoriteProperties
    isFavorite = staticController.favoriteProperties
        .any((favProperty) => favProperty.id == widget.property.id);

    timer();
  }

  void timer() {
    _isLoading = true;

    // Create a timer that triggers setState when it's done
    _timer = Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 260,
          child: PageView.builder(
            controller: controller,
            onPageChanged: (index) {
              setState(() {});
            },
            itemCount: widget.propertyFiles.length,
            itemBuilder: (context, index) {
              slider = index + 1;

              if (_isLoading) {
                timer();
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Image.network(
                    widget.propertyFiles[index].downloadUrls!,
                    width: double.infinity,
                    height: 260,
                    fit: BoxFit.cover,
                  ),
                );
              } else {
                timer();
                return Image.network(
                  widget.propertyFiles[index].downloadUrls!,
                  width: double.infinity,
                  height: 260,
                  fit: BoxFit.cover,
                );
              }
            },
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Container(
            width: 50,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text("$slider / ${widget.propertyFiles.length}",
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
            ),
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: const Color.fromARGB(166, 224, 224, 224),
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_back,
                  color: Color.fromARGB(255, 196, 39, 27),
                  size: 21,
                ),
              ),
            ),
          ),
        ),

        // To add the house to favorites
        Positioned(
          top: 16,
          right: 16,
          child: Row(
            children: [
              if (widget.property.userId != loginController.userDto?["id"])
                InkWell(
                  onTap: () async {
                    setState(() {});
                    ScaffoldMessenger.of(context).clearSnackBars();
                    SnackBar snackBar;

                    // If it is in favourites
                    if (isFavorite) {
                      setState(() {
                        isFavorite = false;
                      });
                      // Remove property with the same ID from favoriteProperties
                      staticController.favoriteProperties.removeWhere(
                          (favProperty) =>
                              favProperty.id == widget.property.id);
                      snackBar = const SnackBar(
                        content: Text("Removed Successfully"),
                        backgroundColor: Colors.red,
                      );
                    }
                    // If it is not in favourites
                    else {
                      setState(() {
                        isFavorite = true;
                      });
                      staticController.favoriteProperties.add(widget.property);
                      snackBar = const SnackBar(
                        content: Text("Added Successfully"),
                        backgroundColor: Colors.blue,
                      );
                    }

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: Container(
                    width: 29,
                    height: 29,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(149, 224, 224, 224),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: const Color.fromARGB(255, 196, 39, 27),
                        size: 22,
                      ),
                    ),
                  ),
                )
              else
                InkWell(
                  onTap: () async {},
                  child: Container(
                    width: 29,
                    height: 29,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(149, 224, 224, 224),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.favorite_border,
                        color: Color.fromARGB(255, 196, 39, 27),
                        size: 22,
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () {},
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(166, 224, 224, 224),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.star_border,
                      color: Color.fromARGB(255, 196, 39, 27),
                      size: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () {},
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(166, 224, 224, 224),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.share,
                      color: Color.fromARGB(255, 196, 39, 27),
                      size: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () {},
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(166, 224, 224, 224),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.comment,
                      color: Color.fromARGB(255, 196, 39, 27),
                      size: 19,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
