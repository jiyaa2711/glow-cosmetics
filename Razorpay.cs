using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Net;
using System.Security.Cryptography;
using System.Text;
using System.Web.Script.Serialization;

/// <summary>
/// Razorpay payment (test mode).
/// Flow: server par order banao -> browser me Razorpay Checkout kholo ->
/// payment ke baad signature server par verify karo.
/// </summary>
public static class Razorpay
{
    public static string KeyId { get { return ConfigurationManager.AppSettings["RazorpayKeyId"]; } }
    private static string KeySecret { get { return ConfigurationManager.AppSettings["RazorpayKeySecret"]; } }

    /// <summary>Razorpay par order banata hai aur uska order_id (order_xxxx) return karta hai.</summary>
    public static string CreateOrder(decimal amountRupees, string receipt)
    {
        ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;

        long paise = (long)Math.Round(amountRupees * 100m, 0);
        JavaScriptSerializer js = new JavaScriptSerializer();
        string body = js.Serialize(new { amount = paise, currency = "INR", receipt = receipt });

        HttpWebRequest req = (HttpWebRequest)WebRequest.Create("https://api.razorpay.com/v1/orders");
        req.Method = "POST";
        req.ContentType = "application/json";
        string auth = Convert.ToBase64String(Encoding.UTF8.GetBytes(KeyId + ":" + KeySecret));
        req.Headers["Authorization"] = "Basic " + auth;

        byte[] data = Encoding.UTF8.GetBytes(body);
        req.ContentLength = data.Length;
        using (Stream s = req.GetRequestStream())
        {
            s.Write(data, 0, data.Length);
        }

        try
        {
            using (HttpWebResponse res = (HttpWebResponse)req.GetResponse())
            using (StreamReader sr = new StreamReader(res.GetResponseStream()))
            {
                Dictionary<string, object> obj = js.Deserialize<Dictionary<string, object>>(sr.ReadToEnd());
                return Convert.ToString(obj["id"]);
            }
        }
        catch (WebException ex)
        {
            string detail = "";
            if (ex.Response != null)
            {
                using (StreamReader sr = new StreamReader(ex.Response.GetResponseStream()))
                {
                    detail = sr.ReadToEnd();
                }
            }
            throw new Exception("Razorpay error: " + ex.Message + " " + detail);
        }
    }

    /// <summary>Payment ke baad aaya signature sahi hai ya nahi - HMAC SHA256 se check.</summary>
    public static bool VerifySignature(string orderId, string paymentId, string signature)
    {
        if (string.IsNullOrEmpty(orderId) || string.IsNullOrEmpty(paymentId) || string.IsNullOrEmpty(signature))
            return false;

        using (HMACSHA256 hmac = new HMACSHA256(Encoding.UTF8.GetBytes(KeySecret)))
        {
            byte[] hash = hmac.ComputeHash(Encoding.UTF8.GetBytes(orderId + "|" + paymentId));
            StringBuilder sb = new StringBuilder();
            foreach (byte b in hash) sb.Append(b.ToString("x2"));
            string expected = sb.ToString();

            if (expected.Length != signature.Length) return false;
            int diff = 0;
            for (int i = 0; i < expected.Length; i++) diff |= expected[i] ^ signature[i];
            return diff == 0;
        }
    }
}
