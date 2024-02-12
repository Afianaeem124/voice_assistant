import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:voice_assistant/openAi_Service.dart';
import 'package:voice_assistant/utils/pallete.dart';
import 'package:voice_assistant/widgets/FeaturesList.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:animate_do/animate_do.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override  
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SpeechToText speechToText = SpeechToText();
  String lastWords = '';
  OpenApiService openApiService = OpenApiService();
  FlutterTts flutterTts = FlutterTts();
  String? genenrateImageURL;
  String? genenrateContent;
  int start = 200;
  int delay = 200;
  @override
  void initState() {
    super.initState();
    initSpeech();
    initSpeak();
  }

  Future<void> initSpeech() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> initSpeak() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> startSpeak(String content) async {
    await flutterTts.speak(content);
    setState(() {});
  }

  /// Each time to start a speech recognition session
  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(child: const Text('Allen')),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          //virtual Assistant Picture
          Center(
            child: Stack(children: [
              Container(
                  height: 120,
                  width: 120,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: const BoxDecoration(
                    color: Pallete.assistantCircleColor,
                    shape: BoxShape.circle,
                  )),
              ZoomIn(
                child: Container(
                    height: 123,
                    width: 120,
                    decoration: const BoxDecoration(
                      image: DecorationImage(image: AssetImage('assets/images/virtualAssistant.png')),
                      shape: BoxShape.circle,
                    )),
              ),
            ]),
          ),
          //Chat Bubble
          FadeInRight(
            child: Visibility(
              visible: genenrateImageURL == null,
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(top: 30),
                  decoration: BoxDecoration(border: Border.all(color: Pallete.borderColor), borderRadius: BorderRadius.circular(20).copyWith(topLeft: Radius.zero)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      genenrateContent == null ? 'Good Morning, what task can I do for you?' : genenrateContent!,
                      style: TextStyle(
                        fontFamily: 'Cera Pro',
                        color: Pallete.mainFontColor,
                        fontSize: genenrateContent == null ? 25 : 18,
                      ),
                    ),
                  )),
            ),
          ),
          //Image Shown
          if (genenrateImageURL != null)
            JelloIn(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(genenrateImageURL!),
                ),
              ),
            ),

          //Text
          JelloIn(
            child: Visibility(
              visible: genenrateContent == null && genenrateImageURL == null,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(10.0).copyWith(top: 10, left: 22),
                  child: const Text(
                    'Here are a few features',
                    style: TextStyle(fontFamily: 'Cera Pro', fontSize: 20, color: Pallete.mainFontColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          //FeaturesList
          Visibility(
            visible: genenrateContent == null && genenrateImageURL == null,
            child: Column(
              children: [
                SlideInLeft(
                    duration: Duration(milliseconds: start),
                    child: const FeaturesBox(color: Pallete.firstSuggestionBoxColor, header: 'ChatGPT', description: 'A smarter way to stay organized and informed with ChatGPT')),
                SlideInLeft(
                    duration: Duration(milliseconds: start + delay),
                    child: const FeaturesBox(color: Pallete.secondSuggestionBoxColor, header: 'Dall-E', description: 'Get inspired and stay creative with your personal assistant powered by Dall-E')),
                SlideInLeft(
                    duration: Duration(milliseconds: start + 2 * delay),
                    child: const FeaturesBox(
                        color: Pallete.thirdSuggestionBoxColor, header: 'Smart Voice Assistant', description: 'Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT')),
              ],
            ),
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Pallete.firstSuggestionBoxColor,
          onPressed: () async {
            if (await speechToText.hasPermission && speechToText.isNotListening) {
              await startListening();
            } else if (speechToText.isListening) {
              final speech = await openApiService.isArtPromptAPI(lastWords);
              if (speech.contains('https')) {
                genenrateImageURL = speech;
                genenrateContent = null;
                setState(() {});
              } else {
                genenrateContent = speech;
                genenrateImageURL = null;
                setState(() {});
                await startSpeak(speech);
              }
              await stopListening();
            } else {
              initSpeech();
            }
            if (kDebugMode) {
              print(lastWords);
            }
          },
          child: Icon(speechToText.isListening ? Icons.stop : Icons.mic)),
    );
  }
}
