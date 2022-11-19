import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ac extends StatefulWidget {
  String? acname;
  String? id;
  ac(this.acname,this.id);

  @override
  State<ac> createState() => _acState();
}
class _acState extends State<ac> {
  // List item=["adv","sc","sd"];
  String type="";
  TextEditingController t1=TextEditingController();
  TextEditingController t2=TextEditingController();
  TextEditingController t3=TextEditingController();
  List<tr> trlist=[];
  @override
  Future<List<tr>> get()
  async {
    var url = Uri.parse('https://jdflutter.000webhostapp.com/tran_view.php?c_id=${widget.id}');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    List d=jsonDecode(response.body);
    trlist.clear();
    d.forEach((element) {
      trlist.add(tr.fromJson(element));
    });
    return trlist;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.acname}"),
        actions: [
          IconButton(onPressed: () {
            showDialog( builder: (context) {
               return StatefulBuilder(builder: (context, setState1) {
                 return Dialog(
                   child: Container(
                     height: 400,
                     child: Column(
                       children: [
                         TextField(
                           controller: t1,
                           decoration: InputDecoration(
                               hintText: "Transaction date"
                           ),
                         ),
                         RadioListTile(onChanged:(value) {
                           setState1((){type=value.toString();});
                         },value: "credit", groupValue: type,title: Text("credit(+)"), ),
                         RadioListTile(onChanged:(value) {
                           setState1((){type=value.toString();});
                         },value: "debit", groupValue: type,title: Text("debit(-)"), ),
                         TextField(
                           controller: t2,
                           decoration: InputDecoration(
                               hintText: "Amount"
                           ),
                         ),
                         TextField(
                           controller: t3,
                           decoration: InputDecoration(
                               hintText: "Particular"
                           ),
                         ),
                         ElevatedButton(onPressed: () {
                           Navigator.pop(context);
                         }, child:Text("cancle")),
                         ElevatedButton(onPressed: () async {
                           String d=t1.text;
                           String am=t2.text;
                           // int am=int.parse(t2.text);
                           //  print("$am");
                           String parti=t3.text;
                            String t=type;
                           int n_id=int.parse(widget.id!);
                           var url = Uri.parse('https://jdflutter.000webhostapp.com/tranjection.php?type=$t&date=$d&amo=$am&par=$parti&n_id=$n_id');                             var response = await http.get(url);
                           print('Response status: ${response.statusCode}');
                           print('Response body: ${response.body}');
                           if(response.body=="Data is inserted") {
                             setState((){
                               Navigator.pop(context);
                             });
                           }
                         }, child: Text("Add"))
                       ],
                     ),
                   ),
                 );
               },);
            },context: context);
          }, icon: Icon(Icons.add))
        ],
      ),
      body: SingleChildScrollView(
        child:FutureBuilder(future:get(),builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.done)
          {
            if(snapshot.hasData)
            {
              List<tr> l=snapshot.data as List<tr>;
                 return Column(
                  children: [
                    SizedBox(
                        height: 30,
                        width: double.infinity,
                        child: ColoredBox(color: Colors.black12,
                            child:Align(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text("date"),
                                  Text("Particular"),
                                  Text("Credit(+)"),
                                  Text("Debit(-)"),
                                ],
                              ),
                            )
                        )
                    ),
                    ListView.builder(shrinkWrap:true, itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        margin: EdgeInsets.all(5),
                        shadowColor: Colors.black,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(child: Text("${l[index].date}")),
                            Expanded(child: Text("${l[index].per}")),
                            Expanded(child: (l[index].type=="credit")?Text("    ${l[index].amo}"):Text("-")),
                            Expanded(child: (l[index].type=="debit")?Text("    ${l[index].amo}"):Text("-"))
                          ],
                        ),
                      );
                    },itemCount: l.length,)
                  ],
                );

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
        },)
      )
    );
  }
}

class tr {
  String? id;
  String? type;
  String? date;
  String? per;
  String? amo;
  String? nId;
  tr({this.id, this.type, this.date, this.per, this.amo, this.nId});
  tr.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    date = json['date'];
    per = json['per'];
    amo = json['amo'];
    nId = json['n_id'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['date'] = this.date;
    data['per'] = this.per;
    data['amo'] = this.amo;
    data['n_id'] = this.nId;
    return data;
  }
}
