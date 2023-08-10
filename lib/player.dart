import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/const/colors.dart';
import 'package:music_player/const/text_style.dart';
import 'package:music_player/controller/player_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Player extends StatelessWidget {
  final List<SongModel> data;
  const Player({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    var controller= Get.find<PlayerController>();
    return Scaffold(
      backgroundColor: bgDarkColor,
      appBar: AppBar(),
      body: Padding(padding: const EdgeInsets.all(8),
      child: Column(
        children:<Widget> [
          Obx(
            ()=> Expanded(
              child: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
            ),
              alignment: Alignment.center,
              child: QueryArtworkWidget(
                id: data[controller.playIndex.value].id, 
                type: ArtworkType.AUDIO,
                artworkHeight: double.infinity,
                artworkWidth: double.infinity,
                nullArtworkWidget: const Icon(Icons.music_note,
                size: 48,
                color: whiteColor,),
                ),
            ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(child: Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(10))
            ),
            child: Obx(
              ()=> Column(children: [
                Text(data[controller.playIndex.value].displayNameWOExt,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  color: bgDarkColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 24
                ),),
                Text(data[controller.playIndex.value].artist.toString(),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  color: bgDarkColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 20
                ),),
                const SizedBox(height: 10,),
                Obx(
                  ()=> Row(children: [
                    Text(controller.position.value,
                    style: textStyle(
                      color: Colors.grey.shade700
                    ),),
                    Expanded(
                      child: Slider(
                        thumbColor: sliderColor,
                        inactiveColor: bgcolor,
                        activeColor: bgDarkColor,
                        min:const Duration(seconds: 0).inSeconds.toDouble(),
                        max:controller.max.value ,
                        value: controller.value.value, 
                        onChanged: (newValue){
                          controller.changeDurationToSeconds(newValue.toInt());
                          newValue=newValue;
                        })),
                    Text(controller.duration.value,
                    style: textStyle(
                      color: Colors.grey.shade700
                    ),)
                
                  ],),
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly  ,
                  children: [
                  IconButton(
                    onPressed: (){
                      controller.playSong(data[controller.playIndex.value-1].uri, controller.playIndex.value-1);
                    },
                     icon:const Icon(
                      Icons.skip_previous_rounded,
                  size: 36,)),
                  Obx(
                    ()=> CircleAvatar(
                      radius: 27,
                      backgroundColor: bgcolor,
                        child: IconButton(
                          onPressed: (){
                            if(controller.isPlaying.value){
                              controller.audioPlayer.pause();
                              controller.isPlaying(false);
                            }
                            else{
                              controller.audioPlayer.play();
                              controller.isPlaying(true);
                            }
                          },
                           icon:controller.isPlaying.value?  const Icon(
                            Icons.pause,
                            color: Colors.black87,
                        size: 36,):
                        const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.black87,
                        size: 36,)
                        ),
                      
                    ),
                  ),
                  IconButton(
                    onPressed: (){
                      controller.playSong(data[controller.playIndex.value+1].uri, controller.playIndex.value+1);
                    },
                     icon:const Icon(
                      Icons.skip_next_rounded,
                  size: 36,)),
                ],)
              ]),
            ),
          ))
        ],
      ),
      ),
    );
  }
}