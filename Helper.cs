using System;
using System.Security.Cryptography;
using System.Web;

/// <summary>Password hashing (PBKDF2) aur chhote helper functions.</summary>
public static class Helper
{
    private const int Iterations = 10000;

    // ---------- Password ----------
    public static string HashPassword(string password)
    {
        byte[] salt = new byte[16];
        using (RNGCryptoServiceProvider rng = new RNGCryptoServiceProvider())
        {
            rng.GetBytes(salt);
        }
        byte[] hash = new Rfc2898DeriveBytes(password, salt, Iterations).GetBytes(32);
        return Convert.ToBase64String(salt) + ":" + Convert.ToBase64String(hash);
    }

    public static bool VerifyPassword(string password, string stored)
    {
        if (string.IsNullOrEmpty(stored) || !stored.Contains(":")) return false;
        string[] parts = stored.Split(':');
        byte[] salt = Convert.FromBase64String(parts[0]);
        byte[] expected = Convert.FromBase64String(parts[1]);
        byte[] actual = new Rfc2898DeriveBytes(password, salt, Iterations).GetBytes(32);
        return SlowEquals(expected, actual);
    }

    private static bool SlowEquals(byte[] a, byte[] b)
    {
        if (a.Length != b.Length) return false;
        int diff = 0;
        for (int i = 0; i < a.Length; i++) diff |= a[i] ^ b[i];
        return diff == 0;
    }

    // ---------- Display helpers (aspx ke andar use hote hain) ----------
    public static string Money(object value)
    {
        decimal d = 0;
        if (value != null && value != DBNull.Value) d = Convert.ToDecimal(value);
        return "₹" + d.ToString("N2");
    }

    public static string ImgUrl(object image)
    {
        string name = (image == null || image == DBNull.Value) ? "" : image.ToString();
        if (name.Length == 0) name = "placeholder.svg";
        return VirtualPathUtility.ToAbsolute("~/images/products/" + name);
    }

    public static string CatIcon(object name)
    {
        string n = (name == null || name == DBNull.Value) ? "" : name.ToString().ToLower();
        if (n.Contains("skin")) return "&#129524;";
        if (n.Contains("make") || n.Contains("lip")) return "&#128132;";
        if (n.Contains("hair")) return "&#128135;";
        if (n.Contains("fragr") || n.Contains("perf")) return "&#127800;";
        return "&#10024;";
    }

    public static string ShortText(object text, int max)
    {
        string s = (text == null || text == DBNull.Value) ? "" : text.ToString();
        if (s.Length <= max) return s;
        return s.Substring(0, max).TrimEnd() + "...";
    }

    /// <summary>Product card ka chhota label: "Lakme - Lipstick" (HTML safe).</summary>
    public static string Tag(object brand, object category)
    {
        string b = (brand == null || brand == DBNull.Value) ? "" : brand.ToString();
        string c = (category == null || category == DBNull.Value) ? "" : category.ToString();
        if (b.Length == 0) return HttpUtility.HtmlEncode(c);
        return HttpUtility.HtmlEncode(b) + " &middot; " + HttpUtility.HtmlEncode(c);
    }

    /// <summary>Brand ke naam se ek fixed gradient (logo ke background ke liye).</summary>
    public static string BrandStyle(object name)
    {
        string[] from = { "#e0457b", "#7a3fb3", "#e2802f", "#1f9d6b", "#2f6fdd", "#c23b5b", "#b8892b" };
        string[] to   = { "#a82a57", "#4a2578", "#b85a12", "#127049", "#1c47a3", "#7e1f38", "#805c12" };
        string n = (name == null || name == DBNull.Value) ? "" : name.ToString();
        int sum = 0;
        foreach (char ch in n) sum += ch;
        int i = sum % from.Length;
        return "background:linear-gradient(135deg," + from[i] + "," + to[i] + ")";
    }

    public static string BrandInitial(object name)
    {
        string n = (name == null || name == DBNull.Value) ? "" : name.ToString().Trim();
        return n.Length == 0 ? "?" : HttpUtility.HtmlEncode(n.Substring(0, 1).ToUpper());
    }

    public static string StatusClass(object status)
    {
        string s = (status == null) ? "" : status.ToString().ToLower();
        return "badge badge-" + s;
    }

    /// <summary>Order tracker ke liye step ka CSS class: done / current / (khali).</summary>
    public static string Step(object status, int stepNo)
    {
        string s = (status == null || status == DBNull.Value) ? "" : status.ToString();
        int now = s == "Placed" ? 1 : s == "Shipped" ? 2 : s == "Delivered" ? 3 : 0;
        if (now == 0) return "step";
        if (stepNo < now || now == 3) return "step done";
        return stepNo == now ? "step done current" : "step";
    }

    /// <summary>Lambe message ko safe HTML me badlo (new line = br).</summary>
    public static string Multiline(object text)
    {
        string s = (text == null || text == DBNull.Value) ? "" : text.ToString();
        return HttpUtility.HtmlEncode(s).Replace("\r\n", "<br />").Replace("\n", "<br />");
    }

    public static bool IsCancelled(object status)
    {
        return status != null && status != DBNull.Value && status.ToString() == "Cancelled";
    }

    public static bool IsValidEmail(string email)
    {
        try
        {
            System.Net.Mail.MailAddress m = new System.Net.Mail.MailAddress(email);
            return m.Address == email;
        }
        catch { return false; }
    }
}
