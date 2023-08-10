import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/const/colors.dart';
import 'package:music_player/const/text_style.dart';
import 'package:music_player/controller/player_controller.dart';
import 'package:music_player/player.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var controller= Get.put(PlayerController());
    return Scaffold(
      backgroundColor: bgDarkColor,
      appBar: AppBar(
        backgroundColor: bgcolor,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search, color: bgDarkColor,))],
        leading: Icon(
          Icons.sort_rounded,
          color: bgDarkColor,
        ),
        title: Text('BeatBot', style: textStyle(family: bold, size: 24)),
      ),
      body: FutureBuilder<List<SongModel>>(
        future: controller.audioQuery.querySongs(
        ignoreCase: true,
        orderType: OrderType.ASC_OR_SMALLER,
        sortType: SongSortType.DISPLAY_NAME,
        uriType: UriType.EXTERNAL
      ),
        builder:(BuildContext context, snapshot) {
          if(snapshot.data== null){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else if(snapshot.data!.isEmpty){
            return Center(
              child: Text('No Songs added', 
              style: textStyle(),),
            );
          }
          else{
            return Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: snapshot.data!.length,
          itemBuilder: (BuildContext context,int index) {
          
          return Container(
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
            child: Obx(
              ()=> ListTile(
                tileColor: bgDarkColor,
                title: Text(
                  snapshot.data![index].displayNameWOExt,
                  style: textStyle(family: regular, size: 18),
                ),
                subtitle: Text(
                  "${snapshot.data![index].artist}",
                  style: textStyle(color: Colors.grey.shade400),
                ),
                leading: QueryArtworkWidget(id: snapshot.data![index].id, type:ArtworkType.AUDIO,
                nullArtworkWidget: const Icon(
                  Icons.music_note,
                  color: whiteColor,
                  size: 24,
                ),
                ),
                trailing: controller.playIndex.value==index && controller.isPlaying.value? 
                const Icon(
                      Icons.play_arrow_rounded,
                      color: whiteColor,
                      size: 24,
                    ): null,
                    onTap: () {
                      Get.to(()=>Player(data: snapshot.data!,));
                      controller.playSong(snapshot.data![index].uri, index);
                    },
              ),
            ),
          );
        }),
      );
          }
        } )
    );
  }
}




