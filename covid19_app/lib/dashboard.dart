
/*

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Dashboard extends StatefulWidget{
  


  @override
  _DashboardState createState() => _DashboardState();

}

class _DashboardState extends State<Dashboard>{
  

Material myItems(IconData icon, String heading, int color){
  return Material(
    color:Colors.white,
    elevation: 14,
    shadowColor: Color(0x802196F3),
    borderRadius: BorderRadius.circular(24.0),
    child: Center(
      child:Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(heading,
                  style: TextStyle(
                    color: new Color(color),
                    fontSize: 20.0,
                  ),
              ),
                ),

                Material(
                  color: new Color(color),
                  borderRadius: BorderRadius.circular(24.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(icon,
                    color: Colors.white,
                    size: 30.0,),

                    ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}



  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(title: Text('Karthik Dashboard',
      style: TextStyle(color: Colors.white,
      ),
    ),
  ),
      body:StaggeredGridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      children: <Widget>[
        myItems(Icons.graphic_eq,"Total Views",0xffed622b),
        myItems(Icons.bookmark,"Comments",0xff26cb3c),
        myItems(Icons.notifications,"Likes",0xffff3266),
        myItems(Icons.attach_money,"Dislikes",0xff3399fe),
        myItems(Icons.settings,"Shares",0xfff4c83f),
        myItems(Icons.group_work,"Retweets",0xff622F74),
        myItems(Icons.message,"Hashtags",0xff7297ff),
      ],
      staggeredTiles: [
        StaggeredTile.extent(2, 130.0),
        StaggeredTile.extent(1, 150.0),
        StaggeredTile.extent(1, 150.0),
        StaggeredTile.extent(1, 150.0),
        StaggeredTile.extent(1, 150.0),
        StaggeredTile.extent(2, 250.0),
        StaggeredTile.extent(2, 120.0),

      ],
      ),
    );
    
  }  
}

*/