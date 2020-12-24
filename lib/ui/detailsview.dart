import 'package:flutter/material.dart';
import 'package:fetch_data_using_api/model/pages.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class DetailsPage extends StatefulWidget {
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  List<Model> model = List<Model>();
  var loading = false;
  Future<Null> _fetchData() async {
    setState(() {
      loading = true;
    });
  }
  Future<List<Model>> fetchPost() async {
    var url = "https://reqres.in/api/users?page";
    var response = await http.get(url);

    var post = List<Model>();

    if (response.statusCode == 200) {
      var  postJson = json.decode(response.body);
      //for (var postJson in postJson) {
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
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text('Profile'),
        ),
        body: loading
            ?  Center(child: CircularProgressIndicator())
        : ListView.builder(
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 32.0, bottom: 32.0, left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Container(
                        child: CircleAvatar(
                          radius: 63,
                          child: ClipOval(
                              child: Image.network("${model[index].data[1].avatar}",width: 180.0,)),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Text('Avatar',
                          style: TextStyle(
                            fontSize: 20,
                            // fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text('Id: ${model[index].data[1].id}',
                        style: TextStyle(
                          fontSize: 20,
                          // fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text('First Name: ${model[index].data[1].firstName}',

                        style: TextStyle(
                          fontSize: 20,
                          // fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text('Last Name: ${model[index].data[1].lastName}',
                        style: TextStyle(
                          fontSize: 20,
                          // fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text('Email: ${model[index].data[1].email}',
                        style: TextStyle(
                          fontSize: 20,
                          // fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    // Row(
                    //   children: [
                    //     Container(
                    //       padding: EdgeInsets.all(10.0),
                    //       child: Text('Avatar:',
                    //         style: TextStyle(
                    //           fontSize: 20,
                    //           // fontWeight: FontWeight.bold
                    //         ),
                    //       ),
                    //     ),
                    //     Container(
                    //       child: CircleAvatar(
                    //         radius: 25,
                    //         child: ClipOval(
                    //             child: Image.network("${model[index].data[1].avatar}",width: 50.0,)),
                    //       ),
                    //     ),
                    //
                    //   ],
                    // ),
                    // Container(
                    //   padding: EdgeInsets.all(10.0),
                    //   child: Text(' URL:  ${model[index].support.url}',
                    //     style: TextStyle(
                    //       fontSize: 20,
                    //       // fontWeight: FontWeight.bold
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   padding: EdgeInsets.all(10.0),
                    //   child: Text(' Text:  ${model[index].support.text}',
                    //     style: TextStyle(
                    //       fontSize: 20,
                    //       // fontWeight: FontWeight.bold
                    //     ),
                    //   ),
                    // ),
                    // Text(
                    //   'type: ${model[index].type}',
                    //   style: TextStyle(
                    //       color: Colors.black,
                    //     fontSize: 20.0,
                    //   ),
                    // ),
                    // Text(
                    //   'defaultValue:${model[index].defaultValue}',
                    //   style: TextStyle(
                    //       color: Colors.black,
                    //     fontSize: 20.0,
                    //   ),
                    // ),
                    // Text(
                    //   'validationMessage: ${model[index].validationMessage}',
                    //   style: TextStyle(
                    //       color: Colors.black,
                    //     fontSize: 20.0,
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          },
          itemCount: model.length,
        )
    );
  }

}
