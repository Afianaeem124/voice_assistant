import 'package:voice_assistant/services/network_service.dart';

class OpenApiService {
  final List<Map<String, String>> messages = [];

  Future<String> isArtPromptAPI(String prompt) async {
    try {
      final res = await networkService.postRequest(
        url: 'https://api.openai.com/v1/chat/completions',
        body: {
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              'role': 'user',
              'content':
                  'Does this message want to generate an AI picture, image, art or anything similar? $prompt . Simply answer with a yes or no.',
            }
          ],
        },
      );

      if (res is NetworkSuccess) {
        String content =
            res.data['choices'][0]['message']['content'].toLowerCase().trim();
        switch (content) {
          case 'yes':
          case 'yes.':
            final res = await dallEAPI(prompt);
            return res;
          default:
            final res = await chatGPTAPI(prompt);
            return res;
        }
      } else {
        return 'An internal error occurred';
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> chatGPTAPI(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final res = await networkService.postRequest(
        url: 'https://api.openai.com/v1/chat/completions',
        body: {
          "model": "gpt-3.5-turbo",
          "messages": messages,
        },
      );

      if (res is NetworkSuccess) {
        String content = res.data['choices'][0]['message']['content'].trim();

        messages.add({
          'role': 'assistant',
          'content': content,
        });
        return content;
      } else {
        return 'An internal error occurred';
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> dallEAPI(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final res = await networkService.postRequest(
        url: 'https://api.openai.com/v1/images/generations',
        body: {
          'prompt': prompt,
          'n': 1,
        },
      );

      if (res is NetworkSuccess) {
        String imageUrl = res.data['data'][0]['url'];
        imageUrl = imageUrl.trim();

        messages.add({
          'role': 'assistant',
          'content': imageUrl,
        });
        return imageUrl;
      } else {
        return 'An internal error occurred';
      }
    } catch (e) {
      return e.toString();
    }
  }
}
