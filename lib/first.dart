import 'dart:convert';
import 'package:ac_book/second.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class first extends StatefulWidget {
  const first({Key? key}) : super(key: key);

  @override
  State<first> createState() => _firstState();
}
class _firstState extends State<first> {
  TextEditingController acname=TextEditingController();
  List<user> userlist=[];
  @override
  Future<List<user>> get()
  async {
    var url = Uri.parse('https://jdflutter.000webhostapp.com/g_name.php');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    List d=jsonDecode(response.body);
    userlist.clear();
    d.forEach((element) {
      userlist.add(user.fromJson(element));
    });
    return userlist;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("data"),
        actions: [
         IconButton(onPressed: () {

         }, icon: Icon(Icons.search))
        ],

      ),
      drawer: Drawer(
      backgroundColor: Colors.teal,
      child: Column(
        children: [
          ConstrainedBox(constraints: BoxConstraints(maxHeight: 30,minWidth: 50)),
          Center(child: Text("Welcome"),)
        ],
      ),
      ),
      body: FutureBuilder(
        future:get(),
        builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.done)
          {
            if(snapshot.hasData)
            {
              List<user> l=snapshot.data as List<user>;
              return ListView.builder(itemCount:l.length,itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return ac(l[index].acname,l[index].id);
                    },));
                  },
                  child: Card(
                    elevation: 5,
                    shadowColor: Colors.black,
                    child: Container(
                        height: 120,
                        // elevation: 5,
                        margin: EdgeInsets.all(7),
                        // shadowColor: Colors.black,
                        child: Column(
                          children: [
                            SizedBox(
                                height: 40,
                                width: double.infinity,
                                child:Row(
                                  children: [
                                    Expanded(child: Text("${l[index].acname}",style: TextStyle(fontSize: 23),)),
                                    IconButton(onPressed: () {

                                    }, icon: Icon(Icons.note_alt_outlined,color: Colors.deepPurple)),
                                    IconButton(onPressed: () async {
                                      var url = Uri.parse('https://jdflutter.000webhostapp.com/delete_ac.php?id=${l[index].id}');
                                      var response = await http.get(url);
                                      print(response.body);
                                      if(response.body=="Data is deleted")
                                      {
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                          return first();
                                        },));
                                      }
                                    }, icon: Icon(Icons.delete,color: Colors.deepPurple)),
                                  ],
                                )
                              // ColoredBox(color: Colors.black12),
                            ),
                            Expanded(child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  height: 70,
                                  width: 100,
                                  child:ColoredBox(color: Colors.black12,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child:Text("Credit(+)\nbiijkb",textAlign: TextAlign.center,style: TextStyle(fontSize: 20),),
                                      )
                                  ) ,),
                                SizedBox(
                                  height: 70,
                                  width: 100,
                                  child:ColoredBox(color: Colors.black38,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child:Text("Debit(-)\nbiijkb",textAlign: TextAlign.center,style: TextStyle(fontSize: 20)),
                                      )
                                  )),
                                SizedBox(
                                  height: 70,
                                  width: 100,
                                  child:ColoredBox(color: Colors.deepPurple,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child:Text("Balance\nbiijkb",textAlign: TextAlign.center,style: TextStyle(fontSize: 20),),
                                      )
                                  ) ,)
                              ],
                            ))
                          ],
                        )
                    ),
                  )
                );
              },);
            }
            else
            {
              return Center(child: CircularProgressIndicator(),);
            }
          }
          else
          {
            return Center(child: CircularProgressIndicator(),);
          }
        },),
      floatingActionButton:FloatingActionButton(
        child: Icon(Icons.bookmark_add,color: Colors.orange,),
        backgroundColor: Colors.teal,
        onPressed: () {
          showDialog(builder: (context) {
            return AlertDialog(
              title: Text('Add new account',textAlign: TextAlign.center,),           // To display the title it is optional
              content: TextField(
                controller: acname,
                decoration: InputDecoration(labelText: "Account name"),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                      return first();
                    },));
                  },
                  child: Text('Cancle'),
                ),
                TextButton(
                  onPressed: () async{
                    String name=acname.text;
                    var url = Uri.parse('https://jdflutter.000webhostapp.com/name.php?ac_name=$name');
                    var response = await http.get(url);
                    print('Response status: ${response.statusCode}');
                    print('Response body: ${response.body}');
                    if(response.body=="Data is inserted") {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return first();
                        },));
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },context: context);
        }
         )
    );
  }
}

class user {
  String? id;
  String? acname;

  user({this.id, this.acname});

  user.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    acname = json['acname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['acname'] = this.acname;
    return data;
  }
}

