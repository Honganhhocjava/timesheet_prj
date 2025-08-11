import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:timesheet_project/features/ai_assistant/data/models/question_models.dart';

abstract class GeminiRemote {
  Future<List<QuestionModel>> generateSurvey();

  Future<String> sendAnswersToAI(Map<int, String> answers);
}

class GeminiRemoteImpl implements GeminiRemote {
  final Dio dio = Dio();
  final String apiKey = 'AIzaSyCULsH95cvSNUUZRV3y1AwDGH2ldxCN960';

  @override
  Future<List<QuestionModel>> generateSurvey() async {
    const url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

    final prompt = {
      "contents": [
        {
          "parts": [
            {
              "text": """
  Hãy tạo 10 câu hỏi trắc nghiệm cho một bài khảo sát về cảm xúc của nhân viên khi đi làm của nhân viên trong tuần , định dạng dưới dạng JSON như sau:
  [
    {
      "id":"id để phân biệt các câu hỏi",
      "question": "Câu hỏi ở đây",
      "options": ["Đáp án A", "Đáp án B", "Đáp án C", "Đáp án D"],
      "answer": "Đáp án đúng"
    }
  ]
  Chỉ trả về JSON đúng định dạng trên, không có văn bản mô tả thêm.
  """
            }
          ]
        }
      ]
    };

    final response = await dio.post(
      '$url?key=$apiKey',
      data: prompt,
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    final raw = response.data['candidates'][0]['content']['parts'][0]['text'];
    final cleanedRaw =
        raw.replaceAll('```json', '').replaceAll('```', '').trim();
    final List<dynamic> jsonList = jsonDecode(cleanedRaw);

    return jsonList
        .map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<String> sendAnswersToAI(Map<int, String> answers) async {
    const url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

    final userResponses = answers.entries
        .map((e) => 'Câu hỏi ${e.key + 1}: ${e.value}')
        .join('\n');

    final prompt = {
      "contents": [
        {
          "parts": [
            {
              "text": """
Dưới đây là câu trả lời khảo sát của người dùng:

$userResponses

Dựa vào các lựa chọn dưới đây, hãy phân tích hoặc đưa ra lời khuyên ngắn gọn cho người dùng. Trả lời bằng văn phong tự nhiên, rõ ràng, không dùng định dạng JSON, không sử dụng ký hiệu đặc biệt, không viết dài dòng.
"""
            }
          ]
        }
      ]
    };

    final response = await dio.post(
      '$url?key=$apiKey',
      data: prompt,
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    final raw = response.data['candidates'][0]['content']['parts'][0]['text'];
    return raw.trim();
  }
}
