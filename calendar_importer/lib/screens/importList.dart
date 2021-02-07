//Preuzeto sa https://pub.dev/packages/google_sign_in/example

import 'package:calendar_importer/models/calendarSource.dart';
import 'package:calendar_importer/support/widgetView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

GoogleSignIn _googleSignIn= GoogleSignIn();



class ImportList extends StatefulWidget {
  @override
  _ImportListController createState() => _ImportListController();
}

class _ImportListController extends State<ImportList> {
  List<CalendarSource> listOfSources;
  @override
  Widget build(BuildContext context) => _ImportListView(this);
  GoogleSignInAccount _currentUser;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
    listOfSources = [CalendarSource(name: "Naziv",url: "nesto")];

  }


  _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();
}

class _ImportListView extends WidgetView<ImportList, _ImportListController> {
  _ImportListView(_ImportListController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Popis izvora"),
        actions:<Widget> [
          _buildAccountIcon(context)
        ],
      ),
      body:_buildBody(context),
    );
  }
  Widget _buildBody(BuildContext context) {
    if (state._currentUser != null) {
      return Container(
        child: _buildList(context),
      );
    }
    else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 40.0),
                child: Image.network("https://cdn.icon-icons.com/icons2/2119/PNG/512/google_icon_131222.png", height: 100, width: 100),
            ),
            ElevatedButton(
              child: const Text('SIGN IN'),
              onPressed: state._handleSignIn,
            ),
          ],
        ),
      );
    }
  }
  Widget _buildList(BuildContext context)
  {
    return ListView.builder(
        itemCount:state.listOfSources.length,
        itemBuilder: (context,index){
          return Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.8),
                borderRadius: BorderRadius.circular(12.0),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: ListTile(
                title: Text('${state.listOfSources[index].name}'),
                onTap: (){}
          )
          );
        });
  }

  Widget _buildAccountIcon(BuildContext context) {
    if(state._currentUser!=null)
      {
        if(state._currentUser.photoUrl!=null)
          return Container(
            margin: new EdgeInsets.all(4.0),
            child:
              InkResponse(
                  child: CircleAvatar(backgroundImage: NetworkImage(state._currentUser.photoUrl)),
                  onTap:(){ _buildSimpleDialog(context);},
              ),
          );
        else
          return Container(
            margin: new EdgeInsets.all(4.0),
            child:
            InkResponse(
              child: CircleAvatar(child: Text(state._currentUser.displayName[0])),
              onTap:(){ _buildSimpleDialog(context);},
            ),
          );
      }
    else
      return Container();
  }

  void _buildSimpleDialog(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text("Podaci o korisnickom racunu"),
            children:<Widget> [
              Column(crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: new EdgeInsets.all(10.0),
                  child:  CircleAvatar(
                    backgroundImage: NetworkImage(state._currentUser.photoUrl),
                    maxRadius: 30,)
               ),
                Text(state._currentUser.displayName, style: new TextStyle(fontSize: 18)),
                Text(state._currentUser.email, style: new TextStyle(fontSize: 16)),
                FlatButton(
                    onPressed: (){state._handleSignOut();Navigator.pop(context);},
                    color: Colors.red.shade300,
                    child: Text("Odjava"))
                  ],)
            ],
          );
        });

  }
}