import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'detailsview.dart';
import 'package:fetch_data_using_api/model/pages.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var loading = false;
  Future<Null> _fetchData() async {
    setState(() {
      loading = true;
    });
  }
  List<Model> model = List<Model>();
  final fb = FirebaseDatabase.instance;
  Future<List<Model>> fetchPost() async {
    var url = "https://reqres.in/api/users?page";
    var response = await http.get(url);

    var post = List<Model>();

    if (response.statusCode == 200) {
      var  postJson = json.decode(response.body);
      //for (var postJson in Data) {
      setState(() {
        post.add(Model.fromJson(postJson));
        loading = false;
      });
      //print(post);
      //}
    }
    return post;
  }

  @override
  void initState() {
    _fetchData();
    fetchPost().then((value) {
      setState(() {
        model.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ref=fb.reference().child("Details");
    return Scaffold(
      backgroundColor: Colors.cyan[20],
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Users List'),
      ),
      body: loading
          ?  Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Card(
                  // shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(50.0)
                  // ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: (){
                            ref.child("Id").set(model[index].data[1].id);
                            ref.child("First Name").set(model[index].data[1].firstName);
                            ref.child("Last Name").set(model[index].data[1].lastName);
                            ref.child("Email").set(model[index].data[1].email);
                            ref.child("Avatar").set(model[index].data[1].avatar);
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context)=> DetailsPage(
                                )));
                          },
                          // leading: Container(
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(50.0)
                          //   ),
                          //   child: CircleAvatar(
                          //     radius: 29,
                          //     child: ClipOval(
                          //         child: Image.network("${model[index].data[index].avatar}",width: 60.0,)),
                          //   ),
                          // ),
                          title:Text(' ${model[index].data[1].email}',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 22,
                              //fontWeight: FontWeight.bold
                            ),
                          ),
                          // subtitle: Text(' ${model[index].data[1].lastName}',
                          //   //textAlign: TextAlign.center,
                          //   style: TextStyle(
                          //     fontSize: 17,
                          //     // fontWeight: FontWeight.bold
                          //   ),
                          // ),
                          trailing: Icon(Icons.arrow_forward_ios,color: Colors.black,),
                        ),
                      ),

                    ],
                  ),
                ),
                SizedBox(height: 500,),
                Padding(
                  padding: const EdgeInsets.only(left:170.0,right: 12.0),
                  child: Container(
                    decoration: BoxDecoration(
                        //color: Colors.white
                    ),
                    child: ListTile(
                      title: Text("Total Users: ${model[index].perPage}",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        itemCount: model.length,
      ),
    );
  }
}