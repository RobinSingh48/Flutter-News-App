
import 'dart:convert';
 import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:news_app/model/newmodel.dart';
import 'package:url_launcher/url_launcher.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

   String apiKey = "your apikey";
  
  List<Newmodel> newsData = [];
  Future<List<Newmodel>> getData()async{
    final response = await http.get(Uri.parse("https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=$apiKey"));
    
    if(response.statusCode == 200){
      final data = jsonDecode(response.body.toString());
       final List<dynamic> articles = data['articles'];

       final filteredArticles = articles.where((article) {
      return article['title'] != "[Removed]"; 
         }).toList();
     
       for(Map<String,dynamic> i  in filteredArticles){
     
        newsData.add(Newmodel.fromJson(i));
       
       }
       return newsData;
    }else{
      return [];
    }
  } 

  Future<void> refreshData() async {
    await getData(); 
    setState(() {}); 
  }

 
  Future<void> _launchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw Exception('Could not launch $url');
  }
}
 

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      appBar: AppBar(backgroundColor: Colors.transparent,title: const Text("Top News",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black54,fontSize: 25),),centerTitle: true,),
      body: FutureBuilder(future: getData(), builder: (context, snapshot) {
        if(snapshot.hasError){
          return const Center(child: Text("Something went wrong "),);
        }
        else if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator(),);
        }else if(!snapshot.hasData){
          return const Center(child: CircularProgressIndicator(),);
        }
        return RefreshIndicator(
          onRefresh: refreshData,
          child: ListView.builder(itemCount: newsData.length,itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 5,bottom: 10,right: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12)
                ),
                child: ListTile(onTap: (){
                  _launchUrl(newsData[index].url.toString());
                },
                  leading: SizedBox(width: 100,height: 150,
                    child: newsData[index].urlToImage != null ? Image.network(newsData[index].urlToImage.toString(),fit: BoxFit.cover,filterQuality: FilterQuality.low,): Image.network("https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg",fit: BoxFit.cover,)),
                    title: Text(newsData[index].title.toString(),style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 13),),
                ),
              ),
            );
          },),
        );
      },),
      
    );
  }
}
