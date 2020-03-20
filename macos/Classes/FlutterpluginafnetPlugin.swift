import Cocoa
import FlutterMacOS
import Alamofire

public class FlutterpluginafnetPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutterpluginafnet", binaryMessenger: registrar.messenger)
    let instance = FlutterpluginafnetPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
	switch call.method {
	case "getPlatformVersion":
		result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
	case "getRequest":
		let arguments:[String:Any] = call.arguments as! [String : Any]
		let url:String = arguments["url"] as! String
		let param:[String:Any]?  = arguments["param"] as? Dictionary
		self.GET(url: url, params: param, success: { (json) in
			result(["success":0,"data":json])
		}) { (code, message) in
			result(["success":1,"code":code ?? 0,"message":message])
		}
		
	case "postRequest":
		let arguments:[String:Any] = call.arguments as! [String : Any]
		let url:String = arguments["url"] as! String
		let param:[String:Any]?  = arguments["param"] as? Dictionary
		self.POST(url: url, params: param, success: { (json) in
			result(["success":0,"data":json])
		}) { (code, message) in
			result(["success":1,"code":code ?? 0,"message":message])
		}
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

extension FlutterpluginafnetPlugin {
	
	/// 发起网络请求
	/// - Parameter url: 请求连接
	/// - Parameter method: 请求方法
	/// - Parameter params: 请求参数
	/// - Parameter success: 请求成功h之后的回调
	/// - Parameter failure: 请求失败之后的回调
	func request(_ url:URLConvertible,method:HTTPMethod = .get,params:Dictionary<String,Any>?,success:@escaping(_ response:Any)->(),failure:((_ code:Int?,_ message: String)->Void)?) {
		
		AF.request(url, method: method, parameters: params, encoding: URLEncoding.default, headers: nil, interceptor: nil)
			.responseJSON { [weak self] (response)  in
				switch response.result {
				case .success(let json):
					success(json)
				case .failure(let error):
					print("error=\(error)")
					self?.failureHandle(failure: failure, stateCode: error.responseCode, message: String(describing: error.errorDescription))
				}
		}
	}
	
	func failureHandle(failure:((Int?,String) -> Void)?,stateCode:Int?,message:String) -> Void {
		// 可以设置弹窗提示
		// 执行回调
		failure?(stateCode,message)
	}
	
	/// GET请求
	/// - Parameter url: 链接
	/// - Parameter params: 参数
	/// - Parameter success: 成功回调
	/// - Parameter failure: 失败回调
	func GET(url:String,params:[String:Any]?,success:@escaping(_ json:Any)->(),failure:((_ code:Int?,_ message:String)->Void)?) -> Void {
		self.request(url, method: .get, params: params, success: success, failure: failure)
	}
	
	/// POST请求
	/// - Parameter url: 链接
	/// - Parameter params: 参数
	/// - Parameter success: 成功回调
	/// - Parameter failure: 失败回调
	func POST(url:String,params:[String:Any]?,success:@escaping(_ json:Any)->(),failure:((_ code:Int?,_ message:String)->Void)?) -> Void {
		self.request(url, method: .post, params: params, success: success, failure: failure)
	}
}
