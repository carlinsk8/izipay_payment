import Flutter
import UIKit
import IzipayPayButtonSDK
import RLTMXProfiling
import RLTMXProfilingConnections
import VisaSensoryBranding
import MastercardSonic

public class IzipayPaymentPlugin: NSObject, FlutterPlugin, IzipayPaymentDelegate {
  var transactionId : String?
    var transactionStartDatetime : String?
    private var channelResult: FlutterResult!
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "izipay_payment_flutter", binaryMessenger: registrar.messenger())
        let instance = IzipayPaymentPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        channelResult = result
        if (call.method == "startPayment") {
            transactionStartDatetime = getCurrentTimestamp()
            let arguments = call.arguments as! [String: Any]
            let random = Int.random(in: 356547157..<366547157) //solo es un ejemplo, el transactionId debe ser unico y el comercio elige la forma de generarlo
            
            let tranxId = "\(random)"
            self.transactionId = tranxId
            showIzipayForm(
                listPayMethod: "",
                environment: arguments["environment"] as! String,
                action: arguments["action"] as! String,
                clientId: arguments["clientId"] as! String,
                transactionId: tranxId,
                merchantId: arguments["merchantId"] as! String,
                order: arguments["order"] as! [String: Any],
                billing: arguments["billing"] as! [String: Any],
                shipping: arguments["shipping"] as! [String: Any],
                appearance: arguments["appearance"] as! [String: Any]
            )
            
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    private let sonicManager: MCSonicController = MCSonicController()

    private func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        UIFont.registerFontsForIzipayFramework() //Agregar fuentes al SDK
            
        return true
    }
    
    // Obtener la fecha y hora actual
    func getCurrentTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter.string(from: Date())
    }
    
    func calculateMillis(start: String, end: String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        guard let startDate = formatter.date(from: start),
              let endDate = formatter.date(from: end) else {
            return 0
        }
        return Int(endDate.timeIntervalSince(startDate) * 1000)
    }

    public func getPaymentResult(_ paymentResult: IzipayPayButtonSDK.PaymentResult) {
    print("Código: \(paymentResult.code ?? "N/A")")
    print("Mensaje: \(paymentResult.message ?? "N/A")")

    let header: [String: Any] = [
        "transactionStartDatetime": transactionStartDatetime!,
        "transactionEndDatetime": getCurrentTimestamp(),
        "millis": calculateMillis(start: transactionStartDatetime!, end: getCurrentTimestamp())
    ]

    let card: [String: Any] = [
        "brand": paymentResult.response?.card?.brand ?? "N/A",
        "pan": paymentResult.response?.card?.pan ?? "N/A"
    ]

    let token: [String: Any] = [
        "cardToken": paymentResult.response?.token?.cardToken ?? "N/A"
    ]

    let response: [String: Any] = [
        "merchantCode": paymentResult.response?.merchant?.merchantCode ?? "N/A",
        "facilitatorCode": "",
        "merchantBuyerId": paymentResult.response?.token?.merchantBuyerId ?? "N/A",
        "card": card,
        "token": token,
        "transactionId": paymentResult.transactionId ?? "N/A",
        "orderNumber": paymentResult.response?.order?.first?.orderNumber ?? "N/A"
    ]

    let resultMap: [String: Any] = [
        "messageFriendly": paymentResult.message ?? "N/A"
    ]

    let dataMap: [String: Any] = [
        "code": paymentResult.code ?? "N/A",
        "message": paymentResult.message ?? "N/A",
        "header": header,
        "response": response,
        "result": resultMap
    ]

    var result = ""
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: dataMap, options: .prettyPrinted)
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString)
            result = jsonString
        }
    } catch {
        print("Error al convertir el diccionario a JSON: \(error.localizedDescription)")
    }

    if let paymentResultCode = paymentResult.code, paymentResultCode == "00" {
        if paymentResult.response != nil {
            print("Transacción exitosa. \(paymentResult.response?.description ?? "N/A")")
            sendResult(data: result, message: paymentResult.message)
        } else {
            sendResult(data: "", message: "Error: response is nil")
        }
    } else {
        print("Operación no completada o rechazada. Consultar/anular orden.")
        sendResult(data: result, message: paymentResult.message)
    }
}
    
    public func executeProfiling(_ params: IzipayPayButtonSDK.ScoringParams) {
        // Implementar según sea necesario
    }
    
    public func executeSensoryBrandVisa(view: UIView) {
        if let visaview = view as? SensoryBranding {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                visaview.animate()
            }
        }
    }

    private func sendResult(data: String = "", message: String? = nil) {
        channelResult([data])
    }
    
    public func executeSensoryBrandMastercard(view: UIView, params: IzipayPayButtonSDK.MastercardSonicParams) {
        let merchant = MCSonicMerchant(merchantName: params.name, countryCode: params.country,
                                       city: nil, merchantCategoryCodes: [params.mcc], merchantId: nil)
        if let mastercardview = view as? MCSonicView, let safeMerchant = merchant {
            self.sonicManager.prepare(with: .soundAndAnimation, sonicCue: params.sonicCue,
                                      sonicEnvironment: .production, merchant: safeMerchant) { status in
                if status == .success {
                    self.sonicManager.play(with: mastercardview) { MCSonicStatus in
                        print(MCSonicStatus)
                    }
                }
            }
        }
    }
    
    private func currentTimeMillis() -> Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000 * 1000)
    }
    func showIzipayForm(
        listPayMethod: String,
        environment: String,
        action: String,
        clientId: String,
        transactionId: String,
        merchantId: String,
        order: [String: Any],
        billing: [String: Any],
        shipping: [String: Any],
        appearance: [String: Any]
    ) {
        let random = Int.random(in: 356547157..<366547157) //solo es un ejemplo, el transactionId debe ser unico y el comercio elige la forma de generarlo
        
        let tranxId = "\(random)"
        self.transactionId = tranxId
        
        var config = ConfigPaymentIzipay()
        config.enviroment = environment //TEST o PROD o SBOX
        config.merchantCode = merchantId
        config.facilitatorCode = ""
        config.publicKey = clientId
        
        config.transactionId = tranxId
        config.action = action
        
        config.order = OrderPaymentIzipay()
        config.order?.orderNumber = "10\(random)"
        config.order?.amount = order["amount"] as? String ?? "10.00"
        config.order?.currency = order["currency"] as? String ?? "PEN"
        //config.order?.channel = "mobile" ya no requerido
        config.order?.processType = "autorize" //"autorize" o "preautorize"
        config.order?.payMethod = [.all] //.all, .card
        config.order?.merchantBuyerId = "MB10\(random)" //es un ejemplo, debe ser unico por usuario del comercio
        config.order?.dateTimeTransaction = "\(currentTimeMillis())"
        config.billing = BillingPaymentIzipay()
        config.billing?.firstName = billing["firstName"] as? String ?? "John"
        config.billing?.lastName = billing["lastName"] as? String ?? "Doe"
        config.billing?.email = billing["email"] as? String ?? "ejemplo@gmail.com"
        config.billing?.phoneNumber = billing["phonphoneeNumber"] as? String ?? "989339999"
        config.billing?.street = billing["address"] as? String ?? "calle el demo sdk example"
        config.billing?.city = billing["city"] as? String ?? "lima"
        config.billing?.state = billing["region"] as? String ?? "lima"
        config.billing?.country = billing["country"] as? String ?? "PE"
        config.billing?.postalCode = billing["postalCode"] as? String ?? "15047"
        config.billing?.documentType = billing["idType"] as? String ?? "DNI"
        config.billing?.document = billing["idNumber"] as? String ?? "22334455"
        
        config.shipping = ShippingPaymentIzipay()
        config.shipping?.firstName = shipping["firstName"] as? String ?? "John"
        config.shipping?.lastName = shipping["lastName"] as? String ?? "Doe"
        config.shipping?.email = shipping["email"] as? String ?? "ejemplo@gmail.com"
        config.shipping?.phoneNumber = shipping["phone"] as? String ?? "989339999"
        config.shipping?.street = shipping["address"] as? String ?? "calle el demo sdk example"
        config.shipping?.city = shipping["city"] as? String ?? "lima"
        config.shipping?.state = shipping["region"] as? String ?? "lima"
        config.shipping?.country = shipping["country"] as? String ?? "PE"
        config.shipping?.postalCode = shipping["postalCode"] as? String ?? "15047"
        config.shipping?.documentType = shipping["idType"] as? String ?? "DNI"
        config.shipping?.document = shipping["idNumber"] as? String ?? "22334455"
        
        config.token = TokenPaymentIzipay()
        config.token?.cardToken = nil //requerido solo en action pay_token
        config.appearance = AppearencePaymentIzipay()
        config.appearance?.theme = appearance["themeColor"] as? String ?? "green"
        config.appearance?.logo = appearance["logoUrl"] as? String ?? "https://logowik.com/content/uploads/images/shopping-cart5929.jpg" //es solo un ejemplo
        config.appearance?.formControls = AppearenceControlsPaymentIzipay()
        config.appearance?.formControls?.isAmountLabelVisible = true
        config.appearance?.formControls?.isLangControlVisible = true
        config.appearance?.language = appearance["language"] as? String ?? "ESP"
        config.appearance?.visualSettings = AppearenceVisualSettingsPaymentIzipay()
        config.appearance?.visualSettings?.presentationMode = .fullscreen
        config.appearance?.visualSettings?.showResultScreen = true
        //Objetos para sensory branding
        let sensoryBrandingVisa = SensoryBranding()
        sensoryBrandingVisa.backdropColor = .white
        sensoryBrandingVisa.isSoundEnabled = true
        sensoryBrandingVisa.isHapticFeedbackEnabled = true
        sensoryBrandingVisa.checkmarkMode = .checkmark

        let sensoryBrandMastercard = MCSonicView()
        sensoryBrandMastercard.background = MCSonicBackground.white

        config.appearance?.sensoryBrand = AppearenceSensoryBrandIzipay()
        config.appearance?.sensoryBrand?.visaSBView = sensoryBrandingVisa
        config.appearance?.sensoryBrand?.mastercardSBView = sensoryBrandMastercard
        
        config.urlIPN = nil //enviar si se quiere notificaciones server to server
      
        
        let s = UIStoryboard(name: "IziPayment", bundle: Bundle(for: PaymentFormViewController.self))
        let vc = s.instantiateViewController(withIdentifier: "PaymentFormView") as! PaymentFormViewController
        vc.delegate = self
        vc.configPayment = config
        vc.modalPresentationStyle = .fullScreen

        // Obtener el rootViewController de la escena activa
         if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }),
            let windowScene = scene as? UIWindowScene,
            let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController {

             // Presentar el PaymentFormViewController
            rootViewController.present(vc, animated: true, completion: nil)
        }
        
        
    }
}
