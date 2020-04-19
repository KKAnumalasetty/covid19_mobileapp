import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:timeago/timeago.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
       debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'COVID19 Dashboard'),
      //home: Dashboard(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String searchString = "";

  void setSearchString(String mySearchString){
    this.searchString = mySearchString;
  }

  String getSearchString(){
    return this.searchString;
  }

  
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
        SliverAppBar(
                floating: true,
        snap: true,
        expandedHeight: 100,
        flexibleSpace: FlexibleSpaceBar(
          background: Column(
            children: <Widget>[
              //new Image.network("https://cdn.pixabay.com/photo/2020/04/03/06/58/social-distancing-4997637_1280.jpg",
              //fit: BoxFit.fill),
              Padding(
                padding: const EdgeInsets.only(top:25.0),
                child: Text('COVID-19 Tracker',style: TextStyle(fontSize: 35,color: Colors.white),),
              ),
              Expanded(child: 
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 15.0, 10.0),
                child: Container(
                  height: 10.0,
                  width: double.infinity,
                  child: CupertinoTextField(
                    keyboardType: TextInputType.text,
                    readOnly: true,
                     onSubmitted: (text) {
                        setSearchString(text);
                      },
                    placeholder: 'Search functionality under construction!',
                    placeholderStyle: TextStyle(
                      color: Color(0xffC4C6CC),
                      fontSize: 14.0,
                      fontFamily: 'Brutal',
                      ),
                    prefix: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(10.0, 0.0, 15.0, 10.0),
                      child: Icon(
                        Icons.search,
                        color: Color(0xffC4C6CC),
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Color(0xffF0F1F5),
                    ),
                  ),
                ),
              ),
              ),
            ],
          ),
           
        ),
        ),
        SliverFillRemaining(child: ListPage()),
        ],
      ),

          
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ListPage extends StatefulWidget {
  final String searchString;

  ListPage({this.searchString});


  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  
@override
  void initState() {
    //items.addAll(duplicateItems);
    super.initState();
  }


  Future getFirestoreData() async {
    var firestoreObj = Firestore.instance;
    QuerySnapshot qs = await firestoreObj
        .collection('COVID19_NYTimes')
        .orderBy("Date", descending: true)
        .limit(1)
        .getDocuments();
    var mostRecentDate = qs.documents[0].data['Date'];
    //print(qs.documents[0].data);
    //print("mostRecentDate");
    //print(mostRecentDate.toDate());

    qs = await firestoreObj
        .collection('COVID19_NYTimes')
        .where("Date", isEqualTo: mostRecentDate)
        .orderBy("Cases", descending: true)
        .getDocuments();

    return qs.documents;
  }

  navigateToDetail(DocumentSnapshot state) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DetailPage(state: state)));
  }

  @override
  Widget build(BuildContext context) {
    final formatter = new NumberFormat("#,###");
    return Container(
        child: FutureBuilder(
      future: getFirestoreData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: snapshot.data.length,
              itemBuilder: (_, index) {
                return Card(
                  child: ListTile(
                    contentPadding: EdgeInsets.all(5),
                    title: Text(snapshot.data[index]['State'],
                        style: TextStyle(
                            color: Colors.deepOrange, fontSize: 25.0)),
                    subtitle: Text(
                        DateFormat.yMMMd()
                                .add_jm()
                                .format(snapshot.data[index]['Date'].toDate()) +
                            "  - Cases:  " +
                            formatter.format(snapshot.data[index]['Cases']),
                        style: TextStyle(fontSize: 15)),
                    onTap: () => navigateToDetail(snapshot.data[index]),
                  ),
                );
              });
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                child: Center(child: CircularProgressIndicator()),
                width: 60,
                height: 60,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Loading data... Please wait...'),
              )
            ],
          ),
        );

        //return Text('Final return statement');
      },
    ));
  }
}

class StateData {
  String state;
  DateTime reportedDate;
  int cases;
  int deaths;

  StateData(this.state, this.reportedDate, this.cases, this.deaths);

  StateData.fromMap(Map<dynamic, dynamic> dataMap) 
      : reportedDate = dataMap['Date'].toDate(), 
        cases = dataMap['Cases'].round(),
        deaths = dataMap['Deaths'].round(),
        state = dataMap['State'];
         
}

class DetailPage extends StatefulWidget {
  final DocumentSnapshot state;

  DetailPage({this.state});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  String currentStateName;
  QuerySnapshot qs;


 String setStateName(String state){
   this.currentStateName = state;
   setQS(state);
   return this.currentStateName;
 }

Future<QuerySnapshot> setQS(String stateName) async{
   QuerySnapshot querySnapshot = await Firestore.instance
        .collection('COVID19_NYTimes')
        .where("State", isEqualTo: stateName)
        .orderBy("Date")
        .getDocuments();  
  this.qs = querySnapshot;
  return querySnapshot;
}
  
  dynamic getCasesData(String stateName) async {
    print(stateName);
    var firestoreObj = Firestore.instance;
    QuerySnapshot qs = await firestoreObj
        .collection('COVID19_NYTimes')
        .where("State", isEqualTo: stateName)
        .orderBy("Date")
        .getDocuments();

    print('************************ Results *********************');
    print(qs.documents.length);
    print(qs.documents[0].data);
    print(qs.documents[3].data);

    return qs.documents;
  }

  dynamic getStateData(String stateName) async {
    print(stateName);
    var firestoreObj = Firestore.instance;
    QuerySnapshot qs = await firestoreObj
        .collection('COVID19_NYTimes')
        .where("State", isEqualTo: stateName)
        .orderBy("Date")
        .getDocuments();

    print('************************ Results *********************');
    print(qs.documents.length);
    print(qs.documents[0].data);
    print(qs.documents[3].data);

    List<StateData> stateDataList = <StateData>[];
    for (int index = 0; index < qs.documents.length; index++) {
      print(index);
      print(qs.documents[index].data['State']);
      //var state = qs.documents[index].data['State'];
      //var reportedDate = DateTime.tryParse(qs.documents[index].data['Date'].toString());
      //var cases = qs.documents[index].data['Cases'].round();
      //var deaths = qs.documents[index].data['Deaths'].round();

      //stateDataList.add(StateData(state, reportedDate, cases, deaths));
      stateDataList.add(StateData.fromMap(qs.documents[index].data));
    }

    return stateDataList;
  }


 final CollectionReference fireData = Firestore.instance.collection('COVID19_NYTimes');
Widget build(BuildContext context) { 
    print('################################################');
    //print(widget.state.data);
    setStateName(widget.state.data['State']);
    //print(qs.sn);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
        SliverAppBar(
                floating: true,
        snap: true,
        expandedHeight: 250,
        flexibleSpace: FlexibleSpaceBar(
          background: new Image.network("https://cdn.pixabay.com/photo/2020/04/03/06/58/social-distancing-4997637_1280.jpg",
          fit: BoxFit.fill),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 120),
            child: Text('Location: '+currentStateName,style: TextStyle(fontSize:16.0,color: Colors.black ),),
          ),
        ),
        ),
        SliverFillRemaining(child: StreamBuilder<void>( 
          stream: fireData.snapshots(), 
          builder: (BuildContext context, AsyncSnapshot snapshot) { 
            Widget widget;
            if (snapshot.hasData) { 
              print('entered if condition..hurray');
              List<StateData> stateDataList = <StateData>[]; 
              for (int index = 0; index < snapshot.data.documents.length; index++) { 
                DocumentSnapshot documentSnapshot = 
                    snapshot.data.documents[index]; 

                    if (documentSnapshot.data['State']==currentStateName){
                      DateTime reportedDate = documentSnapshot.data['Date'].toDate();
                      DateTime mySetDate = new DateTime(2020,4,1);
                      if ((mySetDate.difference(reportedDate).inDays)<=11){
                            stateDataList.add(StateData.fromMap(documentSnapshot.data)); 
                      }
                    }
                      
              } 

        final List<Color> bluecolor = <Color>[];
        bluecolor.add(Colors.blue[50]);
        bluecolor.add(Colors.blue[200]);
        bluecolor.add(Colors.blue);

        final List<Color> redcolor = <Color>[];
        redcolor.add(Colors.red[50]);
        redcolor.add(Colors.red[200]);
        redcolor.add(Colors.red);

        final List<double> stops = <double>[];
        stops.add(0.0);
        stops.add(0.5);
        stops.add(1.0);

        final LinearGradient blueGradientColors =
            LinearGradient(colors: bluecolor, stops: stops);

        final LinearGradient redGradientColors =
            LinearGradient(colors: redcolor, stops: stops);

              return Column(
                children: <Widget>[
                  Expanded(child: 
                  Container( 
                    
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SfCartesianChart( 
                            title: ChartTitle(
                              text: 'Total COVID-19 Cases by Day'),
                    primaryXAxis: DateTimeAxis(), 
                    series: <ChartSeries<StateData, dynamic>>[ 
                          AreaSeries<StateData, dynamic>( 
                              dataSource: stateDataList, 
                              xValueMapper: (StateData data, _) => data.reportedDate,
                              yValueMapper: (StateData data, _) => data.cases,
                              gradient : blueGradientColors,),
                    ], 
                  ),
                        ),
                      ),
                      ),
                      ),
                      Expanded(child: Container( 
                       child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: SfCartesianChart(
                          title: ChartTitle(
                              text: 'Total COVID-19 Deaths by Day'),
                    primaryXAxis: DateTimeAxis(), 
                    series: <ChartSeries<StateData, dynamic>>[ 
                          AreaSeries<StateData, dynamic>( 
                              dataSource: stateDataList, 
                              xValueMapper: (StateData data, _) => data.reportedDate,
                              yValueMapper: (StateData data, _) => data.deaths,
                              gradient : redGradientColors), 
                    ], 
                  ),
                        ),
                      ),
                      ),
                      ),
                ],
              ); 
            }  
            return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                child: Center(child: CircularProgressIndicator()),
                width: 60,
                height: 60,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Loading data... Please wait...'),
              ),
              
            ],
          ),
        ); 
          }, 
        ),
        ),         
        ],
      ), 
        ); 
  } 
}

/*
body: StreamBuilder(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
         
          stream: Firestore.instance.collection("COVID19_NYTimes").snapshots(),
          builder: (context, snapshot){
              if (!snapshot.hasData) return Text('Loading data... Please wait..');
              return Column(                
                children:<Widget>[
                  Text(snapshot.data.documents.length.toString()+' Records',style: TextStyle(fontSize: 50)),
                  Text(snapshot.data.documents[0]['State'],style: TextStyle(fontSize: 20)),
                  Text(snapshot.data.documents[0]['Cases'].toString(),style: TextStyle(fontSize: 20)),
                  Text(snapshot.data.documents[0]['Deaths'].toString(),style: TextStyle(fontSize: 20)),
                  Text(DateFormat.yMMMd().add_jm().format(snapshot.data.documents[0]['Date'].toDate()),style: TextStyle(fontSize: 20)),
                  
                ],
              );

          },

        ),
*/
