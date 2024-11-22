/*
Ethan Nakashima
Project: Explore Chicago
Description: The app consists of a single screen containing two tabs containing information about Chicago museums and Chicago sports teams.
Flutter SDK 3.5.1
*/

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Explore Chicago',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red.shade900,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Explore Chicago'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with TickerProviderStateMixin{
  String _currTab = "Sports Teams";
  late final TabController _tabController;
  List<int> thumbsUpCount = List.filled(10, 0);
  List<int> thumbsDownCount = List.filled(10, 0);

  // Snackbar and Appbar action button
  void setCurrTab() {
    setState(() {
      _currTab = _tabController.index == 0 ? "Museums" : "Sports Teams";
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 1
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // increment corresponding likes
  void addThumbsUp(int index) {
    setState(() {
      thumbsUpCount[index]++;
    });
  }

  // increment corresponding dislikes
  void addThumbsDown(int index) {
    setState(() {
      thumbsDownCount[index]++;
    });
  }

  // like and dislike buttons
  Widget thumbsPair(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        IconButton(
            onPressed: () => addThumbsUp(index),
            icon: Icon(Icons.thumb_up)
        ),
        Text(thumbsUpCount[index].toString()),
        IconButton(
          onPressed: () => addThumbsDown(index),
          icon: Icon(Icons.thumb_down),
        ),
        Text(thumbsDownCount[index].toString()),
        SizedBox(width: 10,)
      ],
    );
  }

  // museum/sports box
  Widget entry({
    required String name,
    required String address,
    required String img,
    double? imgWidth,
    required int index,
    double? offset}) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xff66ccff),
          width: 10
        ),
      ),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red.shade900,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Image.network(img,
                width: imgWidth ?? 100
              )
            )
          ),
          Align(
            alignment: Alignment(
              (offset ?? 0) / 100,
              -0.5,
            ),
            child: Column( // Name and Address
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.red[900],
                    fontSize: 17,
                    fontWeight: FontWeight.bold
                  )
                ),
                SizedBox(height: 15,),
                Text(
                  address,
                  style: TextStyle(
                    color: Colors.red[900]
                  )
                )
              ],
            )
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: thumbsPair(index)
          )
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Stack(
          children: <Widget>[
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 3
                  ..color = Colors.red.shade900,
              ),
            ),
            Text(
              widget.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setCurrTab();
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(_currTab)));
            },
            icon: Icon(Icons.dvr_sharp),
            color: Colors.white,
          )
        ],
        flexibleSpace: CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: <Widget>[
            SliverAppBar(
              stretch: true,
              onStretchTrigger: () {
                // Function callback for stretch
                return Future<void>.value();
              },
              expandedHeight: 200.0,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const <StretchMode>[
                  StretchMode.zoomBackground,
                  StretchMode.blurBackground,
                  StretchMode.fadeTitle,
                ],
                collapseMode: CollapseMode.parallax,
                centerTitle: true,
                background: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Image.network(
                      'https://research.euro.savills.co.uk/_images/chicago123456(2).jpg',
                      fit: BoxFit.cover,
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.0, 0.5),
                          end: Alignment.center,
                          colors: <Color>[
                            Color(0x60000000),
                            Color(0x00000000),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white38,
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.apartment),
            ),
            Tab(
                icon : Icon(Icons.sports_baseball_rounded)
            ),
          ]
        )
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          ListView(
            children: <Widget>[
              entry(
                name: 'Field Museum',
                address: '1400 S Lake Shore Dr',
                img: 'https://media.tacdn.com/media/attractions-splice-spp-674x446/12/33/16/54.jpg',
                index: 0
              ),
              SizedBox(height:10),
              entry(
                name: 'Museum of Science\nand Industry',
                address: '5700 S Dusable Lake Shore Dr',
                img: 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/72/Museum_of_Science_and_Industry_%28Chicago%29.jpg/640px-Museum_of_Science_and_Industry_%28Chicago%29.jpg',
                index: 1,
                offset: 30
              ),
              SizedBox(height:10),
              entry(
                name: 'Art Institute of Chicago',
                address: '111 S Michigan Ave',
                img: 'https://cdn.choosechicago.com/uploads/2019/10/AIC_Facade-900x600.png',
                index: 2,
                offset: 20
              ),
              SizedBox(height:10),
              entry(
                name: 'Museum Of Contemporary\nArt Chicago',
                address: '220 E Chicago Ave',
                img: 'https://www.evisitorguide.com/images/chicago/tours/magnificent-mile/museum-of-comtemporary-art1.jpg',
                index: 3,
                offset: 35
              ),
              SizedBox(height:10),
              entry(
                name: 'Peggy Notebaert\nNature Museum',
                address: '2430 N Cannon Dr',
                img: 'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0e/8b/7f/3c/surrounded-by-nature.jpg?w=1200&h=-1&s=1',
                index: 4
              ),
              Image.network('https://www.shutterstock.com/image-illustration/chicago-skyline-panorama-pencil-style-600nw-2089579012.jpg',
                width: 100,
                color: Colors.red[900],
                colorBlendMode: BlendMode.lighten,
              )
            ],
          ),
          ListView(
            children: <Widget>[
              entry(
                name: 'Cubs\nBaseball',
                address: '1060 W Addison St',
                img: 'https://i0.wp.com/thewindycitymama.com/wp-content/uploads/2023/03/7E389F74-6328-492C-A35E-A621862477FC-edited.jpeg?resize=960%2C721&ssl=1',
                index: 5
              ),
              SizedBox(height:10),
              entry(
                name: 'Bulls\nBasketball',
                address: '1901 W Madison St',
                img: 'https://www.hispanosnba.com/imagenes/estadios/united-center.jpg',
                index: 6
              ),
              SizedBox(height:10),
              entry(
                name: 'Bears\nFootball',
                address: '1410 Special Olympics Dr',
                img: 'https://cdn.britannica.com/65/132265-050-48C4CE64/view-Soldier-Field-Chicago.jpg',
                index: 7,
                offset: 20
              ),
              SizedBox(height:10),
              entry(
                name: 'Blackhawks\nHockey',
                address: '1901 W Madison St',
                img: 'https://www.elitesportstours.ca/images/2020/03/13/chicago-blackhawks-travel-packages__962x768.jpg',
                index: 8
              ),
              SizedBox(height:10),
              entry(
                name: 'Fire\nSoccer',
                address: '1410 Special Olympics Dr,',
                img: 'https://images.mlssoccer.com/image/private/t_keep-aspect-ratio-e-mobile/f_auto/mls-chi/yrrclsbx3osmtysoqmv3.jpg',
                index: 9,
                offset: 25
              ),
              Image.network('https://www.shutterstock.com/image-illustration/chicago-skyline-panorama-pencil-style-600nw-2089579012.jpg',
                width: 100,
                color: Colors.red[900],
                colorBlendMode: BlendMode.lighten,
              )
            ]
          )
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setCurrTab();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(_currTab)));
        },
        tooltip: 'Show Current Tab',
        child: const Icon(Icons.dvr_sharp),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
