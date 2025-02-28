import Foundation
import AsyncHTTPClient

// OpenAI API キーを入力してください
let openAIAPIKey = ""

// AIによる健康アドバイスを生成
func getHealthAdvice(message: String) async throws -> String {
    let url = "https://api.openai.com/v1/chat/completions"
    let client = HTTPClient(eventLoopGroupProvider: .createNew)

    defer { try? client.syncShutdown() }

    let requestBody: [String: Any] = [
        "model": "gpt-3.5-turbo",
        "messages": [["role": "user", "content": message]]
    ]

    let requestData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
    var request = HTTPClientRequest(url: url)
    request.method = .POST
    request.headers.add(name: "Authorization", value: "Bearer \(openAIAPIKey)")
    request.headers.add(name: "Content-Type", value: "application/json")
    request.body = .bytes(requestData)

    let response = try await client.execute(request, timeout: .seconds(30))
    guard let body = response.body else { throw URLError(.badServerResponse) }
    let responseData = Data(buffer: body)

    if let json = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
       let choices = json["choices"] as? [[String: Any]],
       let content = choices.first?["message"] as? [String: String],
       let text = content["content"] {
        return text
    }

    throw URLError(.badServerResponse)
}

// メイン処理
@main
struct HealthAssistant {
    static func main() async {
        print("健康管理アプリへようこそ！")

        // ユーザー入力を取得
        print("運動時間（分）を入力してください:")
        guard let exerciseInput = readLine(), let exerciseTime = Int(exerciseInput) else {
            print("正しい数値を入力してください。")
            return
        }

        print("食事内容を入力してください:")
        guard let mealDescription = readLine() else {
            print("正しい食事内容を入力してください。")
            return
        }

        print("睡眠時間（時間）を入力してください:")
        guard let sleepInput = readLine(), let sleepTime = Int(sleepInput) else {
            print("正しい数値を入力してください。")
            return
        }

        // AIに送信するメッセージを生成
        let userMessage = """
        今日の健康データ:
        運動時間: \(exerciseTime) 分
        食事: \(mealDescription)
        睡眠時間: \(sleepTime) 時間
        これを基に健康アドバイスをください。
        """

        // AIアドバイスを取得
        do {
            let advice = try await getHealthAdvice(message: userMessage)
            print("AIからのアドバイス:\n\(advice)")
        } catch {
            print("アドバイスの取得に失敗しました: \(error)")
        }
    }
}
