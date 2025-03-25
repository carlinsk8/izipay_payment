package com.izipay.payment.izipay_payment

import android.util.Log
import android.app.Activity
import android.content.Intent
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry
import com.izipay.izipay_pw_sdk.ui.fullscreend.ContainerActivity
import com.izipay.izipay_pw_sdk.data.model.*
import com.izipay.izipay_pw_sdk.domain.model.PaymentResponse

import org.json.JSONObject
import com.google.gson.Gson
import java.text.SimpleDateFormat
import java.util.*


/** IzipayPaymentPlugin */
class IzipayPaymentPlugin: FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware,
PluginRegistry.ActivityResultListener{
    private var channel: MethodChannel? = null
    private var channelResult: MethodChannel.Result? = null
    private var activity: FlutterActivity? = null
    private var flutterBinding: FlutterPlugin.FlutterPluginBinding? = null
    private var activityBinding: ActivityPluginBinding? = null
    private var transactionStartDatetime: String = ""

    private lateinit var listPayMethod: ArrayList<PayOption>

    companion object {
        const val CHANNEL_NAME = "izipay_payment_flutter"
        const val EXPECTED_REQUEST_CODE = 1001
        

        // @JvmStatic
        // fun registerWith(registrar: PluginRegistry.Registrar) {
        //     val channel = MethodChannel(registrar.messenger(), CHANNEL_NAME)
        //     channel.setMethodCallHandler(IzipayPaymentPlugin())
        // }
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME)
        channel?.setMethodCallHandler(this)
        flutterBinding = flutterPluginBinding
    }

    override fun onDetachedFromEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        flutterBinding = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        channel = MethodChannel(flutterBinding!!.binaryMessenger, CHANNEL_NAME)
        channel?.setMethodCallHandler(this)

        activityBinding = binding
        activityBinding?.addActivityResultListener(this)
        activity = binding.activity as FlutterActivity
    }

    override fun onDetachedFromActivity() {
        channel?.setMethodCallHandler(null)
        channel = null
        channelResult = null

        activityBinding?.removeActivityResultListener(this)
        activityBinding = null
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "startPayment") {
            transactionStartDatetime = getCurrentTimestamp()
            channelResult = result

            val args = call.arguments as? Map<String, Any> ?: run {
                result.error("INVALID_ARGUMENTS", "Invalid arguments received from Dart", null)
                return
            }

            val environment = args["environment"] as? String ?: "SBOX"
            val action = args["action"] as? String ?: "register"
            val clientId = args["clientId"] as? String ?: ""//"<CODIGO DE COMERCIO>"
            val merchantId = args["merchantId"] as? String ?: ""//<public key>
            val orderTimestamp = System.currentTimeMillis().toString()

            listPayMethod = arrayListOf(PayOption.CARD)
            Log.d("IzipayPaymentPlugin", "Processing payment: $args")

            val request = buildConfigRequest(
                listPayMethod,
                environment,
                action,
                clientId,
                "DMKTL$orderTimestamp",
                merchantId,
                orderTimestamp,
                args["order"] as? Map<String, Any> ?: mapOf(),
                args["billing"] as? Map<String, Any> ?: mapOf(),
                args["shipping"] as? Map<String, Any> ?: mapOf(),
                args["appearance"] as? Map<String, Any> ?: mapOf()
            )
            Log.d("IzipayPaymentPlugin", "Processing payment buildConfigRequest: $request")

            val intent = Intent(activity, ContainerActivity::class.java).apply {
                putExtra(ContainerActivity.REQUEST, request)
            }
            activity?.startActivityForResult(intent, EXPECTED_REQUEST_CODE)
        } else {
            result.notImplemented()
        }
    }

    fun getCurrentTimestamp(): String {
        val formatter = SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS", Locale.getDefault())
        return formatter.format(Date())
    }
    
    fun calculateMillis(start: String, end: String): Int {
        val formatter = SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS", Locale.getDefault())
        return try {
            val startDate = formatter.parse(start)
            val endDate = formatter.parse(end)
            if (startDate != null && endDate != null) {
                (endDate.time - startDate.time).toInt()
            } else {
                0
            }
        } catch (e: Exception) {
            0
        }
    }

    private fun buildConfigRequest(
        listPayMethod: ArrayList<PayOption>,
        environment: String,
        action: String,
        clientId: String,
        transactionId: String,
        merchantId: String,
        timestamp: String,
        order: Map<String, Any>,
        billing: Map<String, Any>,
        shipping: Map<String, Any>,
        appearance: Map<String, Any>
    ): ConfigRequest {
        val orderTimestamp = System.currentTimeMillis().toString()
        return ConfigRequest(
            environment,
            action,
            clientId,
            transactionId,
            merchantId,
            "",
            OrderPaymentIzipay(
                timestamp,
                order["currency"] as? String ?: "PEN",
                order["amount"] as? String ?: "11.00",
                listPayMethod,
                "mobile",
                "autorize",
                "MB10$orderTimestamp",
                timestamp
            ),
            TokenPaymentIzipay(""),
            BillingPaymentIzipay(
                billing["firstName"] as? String ?: "Juan",
                billing["lastName"] as? String ?: "Quispe",
                billing["email"] as? String ?: "ejemplo01@gmail.com",
                billing["phone"] as? String ?: "930292619",
                billing["address"] as? String ?: "Av. flores",
                billing["city"] as? String ?: "Lima",
                billing["region"] as? String ?: "Lima",
                billing["country"] as? String ?: "PE",
                billing["postalCode"] as? String ?: "33065",
                billing["idType"] as? String ?: "DNI",
                billing["idNumber"] as? String ?: "55555555"
            ),
            ShippingPaymentIzipay(
                shipping["firstName"] as? String ?: "Juan",
                shipping["lastName"] as? String ?: "Quispe",
                shipping["email"] as? String ?: "ejemplo01@gmail.com",
                shipping["phone"] as? String ?: "930292619",
                shipping["address"] as? String ?: "Av. Alamo",
                shipping["city"] as? String ?: "Lima",
                shipping["region"] as? String ?: "Lima",
                shipping["country"] as? String ?: "PE",
                shipping["postalCode"] as? String ?: "33065",
                shipping["idType"] as? String ?: "DNI",
                shipping["idNumber"] as? String ?: "55555555"
            ),
            AppearencePaymentIzipay(
                appearance["language"] as? String ?: "ESP",
                AppearenceControlsPaymentIzipay(true, true),
                AppearenceVisualSettingsPaymentIzipay(true),
                "green",
                CustomThemePaymentIzipay(
                    appearance["primaryColor"] as? String ?: "#333399",
                    appearance["secondaryColor"] as? String ?: "#333399",
                    appearance["tertiaryColor"] as? String ?: "#333399"
                ),
                appearance["logoUrl"] as? String ?: "https://logowik.com/content/uploads/images/shopping-cart5929.jpg"
            ),
            ""
        )
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == EXPECTED_REQUEST_CODE) {
            val dataPayLoad = data?.extras?.getString(ContainerActivity.RESPONSEPAYLOAD)
            
            val jsonData = JSONObject(dataPayLoad)
            val response = jsonData.optJSONObject("response")
            val merchant = response?.optJSONObject("merchant")
            val card = response?.optJSONObject("card")
            val token = response?.optJSONObject("token")
            val order = response?.optJSONArray("order")?.optJSONObject(0)
            val dataMap = mapOf(
                "code" to jsonData.optString("code"),
                "message" to jsonData.optString("message"),
                "header" to mapOf(
                    "transactionStartDatetime" to transactionStartDatetime,
                    "transactionEndDatetime" to getCurrentTimestamp(),
                    "millis" to calculateMillis(transactionStartDatetime, getCurrentTimestamp())
                ),
                "response" to if (response != null) {
                    mapOf(
                        "merchantCode" to (merchant?.optString("merchantCode", "") ?: ""),
                        "facilitatorCode" to "",
                        "merchantBuyerId" to (token?.optString("merchantBuyerId", "") ?: ""),
                        "card" to mapOf(
                            "brand" to (card?.optString("brand", "") ?: ""),
                            "pan" to (card?.optString("pan", "") ?: "")
                        ),
                        "token" to mapOf(
                            "cardToken" to (token?.optString("cardToken", "") ?: "")
                        ),
                        "transactionId" to (jsonData?.optString("transactionId", "") ?: ""),
                        "orderNumber" to (order?.optString("orderNumber", "") ?: ""),
                    )
                } else {
                    emptyMap() // Si no hay respuesta, dejar vacío
                },
                "payload" to jsonData.optString("payloadHttp", ""),
                "result" to mapOf(
                    "messageFriendly" to jsonData.optString("messageUser", "")
                )
            )

            val gson = Gson()
            val jsonGson = gson.toJson(dataMap)

            if (resultCode == Activity.RESULT_OK) {
                channelResult?.success(jsonGson)
            } else {
                channelResult?.error("PAYMENT_FAILED", "$jsonGson", null)
            }
            return true
        }
        return false
    }
}
