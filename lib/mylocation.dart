//digunakan untuk convert data (json to dart object/string)
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_location/location.dart';

class Mylocation extends StatefulWidget {
  const Mylocation({super.key});

  @override
  State<Mylocation> createState() => _MylocationState();
}

class _MylocationState extends State<Mylocation> {
  List<MyLocation> mylocation = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Location", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: () {
              searchLocation();
            },
            icon: const Icon(Icons.search),
            color: Colors.white,
          ),
        ],
      ),
      body: Center(
        child: mylocation.isEmpty
            ? const Text("No data Available")
            :
              //ListView.builder => guna untk create list secara dynamic(good for performance if data banyak)
              ListView.builder(
                //berapa banyak data untuk display
                itemCount: mylocation.length,
                //kita nak loop setiap item
                itemBuilder: (context, index) {
                  //setiap item akan dibungkus(wrap) dalam card => nampak macam kotak dengan shadow
                  return Card(
                    child: ListTile(
                      leading: Image.network(
                        mylocation[index].imageUrl.toString(),
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error);
                        },
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(mylocation[index].name ?? ""),
                      subtitle: Text(mylocation[index].state ?? ""),
                    ),
                  );
                },
              ),
      ),
    );
  }

  void searchLocation() {
    //ni kita nk request data daripada backend(api)
    http.get(Uri.parse('https://slumberjer.com/teaching/a252/api.php')).then((
      response,
    ) {
      if (response.statusCode == 200) {
        var jsonArray = jsonDecode(response.body);
        mylocation.clear();

        int i = 0;
        for (var item in jsonArray["data"]["results"]) {
          mylocation.add(MyLocation.fromJson(item));
          i++;
        }
        setState(() {});
      }
    });
  }
}
