import 'package:d_method/d_method.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:travel_app_clean_architecture/api/urls.dart';
import 'package:travel_app_clean_architecture/features/homepage/domain/entities/destination_entity.dart';
import 'package:travel_app_clean_architecture/features/homepage/presentation/bloc/all_destination/all_destination_bloc.dart';
import 'package:travel_app_clean_architecture/features/homepage/presentation/bloc/top_destination/top_destination_bloc.dart';
import 'package:travel_app_clean_architecture/features/homepage/presentation/widgets/circle_loading.dart';
import 'package:travel_app_clean_architecture/features/homepage/presentation/widgets/parallax_horiz_delegate.dart';
import 'package:travel_app_clean_architecture/features/homepage/presentation/widgets/text_failure.dart';
import 'package:travel_app_clean_architecture/features/homepage/presentation/widgets/top_destination_image.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final topDestinationController = PageController();

  refresh() {
    context.read<TopDestinationBloc>().add(OnGetTopDestination());
    context.read<AllDestinationBloc>().add(OnGetAllDestination());
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        refresh();
      },
      child: ListView(
        children: [
          const SizedBox(height: 30),
          header(),
          const SizedBox(height: 30),
          search(),
          const SizedBox(height: 30),
          categories(),
          const SizedBox(height: 30),
          topDestination(),
          const SizedBox(height: 30),
          allDestination(),
        ],
      ),
    );
  }

  header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            child: CircleAvatar(
              backgroundImage: const AssetImage(
                'assets/images/avatar/profile.png',
              ),
              radius: 16,
            ),
          ),
          SizedBox(width: 8),
          Text('Hi, User', style: Theme.of(context).textTheme.labelLarge),
          Spacer(),
          Badge(
            backgroundColor: Colors.red,
            alignment: Alignment(0.6, -0.6),
            child: Icon(Icons.notifications_none, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  search() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 1),
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
      ),
      padding: EdgeInsets.only(left: 24),
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Search destination here ...',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                ),
                contentPadding: EdgeInsets.all(0),
              ),
            ),
          ),
          SizedBox(width: 10),
          IconButton.filledTonal(
            onPressed: () {},
            icon: Icon(Icons.search, size: 24),
          ),
        ],
      ),
    );
  }

  categories() {
    List<String> categories = [
      'All',
      'Beach',
      'Mountain',
      'City',
      'Cultural',
      'Adventure',
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(categories.length, (index) {
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 30 : 10,
              right: index == categories.length - 1 ? 30 : 0,
              bottom: 10,
              top: 4,
            ),
            child: Material(
              elevation: 4,
              color: Colors.white,
              shadowColor: Colors.grey[300],
              borderRadius: BorderRadius.circular(30),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 16,
                ),
                child: Text(
                  categories[index],
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  topDestination() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Top Destination",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              BlocBuilder<TopDestinationBloc, TopDestinationState>(
                builder: (context, state) {
                  if (state is TopDestinationLoaded) {
                    return SmoothPageIndicator(
                      controller: topDestinationController,
                      count: state.destinations.length,
                      effect: WormEffect(
                        dotColor: Colors.grey[300]!,
                        activeDotColor: Theme.of(context).primaryColor,
                        dotHeight: 10,
                        dotWidth: 10,
                      ),
                    );
                  }
                  return SizedBox();
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        BlocBuilder<TopDestinationBloc, TopDestinationState>(
          builder: (context, state) {
            if (state is TopDestinationLoading) {
              return CircleLoading();
            } else if (state is TopDestinationFailure) {
              return TextFailure(message: state.message);
            } else if (state is TopDestinationLoaded) {
              List<DestinationEntity> list = state.destinations;
              return AspectRatio(
                aspectRatio: 1.5,
                child: PageView.builder(
                  controller: topDestinationController,
                  itemCount: list.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    DestinationEntity destination = list[index];
                    return itemTopDestination(destination);
                  },
                ),
              );
            }
            return Text(state.toString());
          },
        ),
      ],
    );
  }

  Widget itemTopDestination(DestinationEntity destination) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: TopDestinationImage(url: Urls.image(destination.cover)),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination.name,
                      style: TextStyle(
                        height: 1,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 15,
                          height: 15,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.location_on,
                            color: Colors.grey[600],
                            size: 16,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          destination.location,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 15,
                          height: 15,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.fiber_manual_record,
                            color: Colors.grey[600],
                            size: 10,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          destination.category,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: destination.rate,
                        itemBuilder:
                            (context, index) =>
                                Icon(Icons.star, color: Colors.amber),
                        itemCount: 5,
                        itemSize: 15,
                        direction: Axis.horizontal,
                        unratedColor: Colors.grey,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '(${DMethod.numberAutoDigit(destination.rate)})',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.favorite_border),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  allDestination() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "All Destination",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "See All",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          BlocBuilder<AllDestinationBloc, AllDestinationState>(
            builder: (context, state) {
              if (state is AllDestinationLoading) {
                return CircleLoading();
              } else if (state is AllDestinationFailure) {
                return TextFailure(message: state.message);
              } else if (state is AllDestinationLoaded) {
                List<DestinationEntity> list = state.data;
                return ListView.builder(
                  itemCount: list.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    DestinationEntity destination = list[index];
                    return itemAllDestination(destination);
                  },
                );
              }
              return Text(state.toString());
            },
          ),
        ],
      ),
    );
  }

  Widget itemAllDestination(DestinationEntity destination) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ExtendedImage.network(
              Urls.image(destination.cover),
              fit: BoxFit.cover,
              width: 100,
              height: 100,
              handleLoadingProgress: true,
              loadStateChanged: (state) {
                if (state.extendedImageLoadState == LoadState.failed) {
                  return AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Material(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey[300],
                      child: Icon(Icons.broken_image, color: Colors.black),
                    ),
                  );
                }
                if (state.extendedImageLoadState == LoadState.loading) {
                  return AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Material(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey[300],
                      child: CircleLoading(),
                    ),
                  );
                }
                return null;
              },
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  destination.name,
                  style: TextStyle(
                    height: 1,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: destination.rate,
                      itemBuilder:
                          (context, index) =>
                              Icon(Icons.star, color: Colors.amber),
                      itemCount: 5,
                      itemSize: 15,
                      direction: Axis.horizontal,
                      unratedColor: Colors.grey,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '(${DMethod.numberAutoDigit(destination.rate)}/${NumberFormat.compact().format(destination.rateCount)} )',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[500],
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
                Text(
                  destination.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(height: 1, fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
