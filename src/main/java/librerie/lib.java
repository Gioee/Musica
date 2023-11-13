package librerie;

import javax.servlet.http.HttpSession;
import classi.Carrello;

public class lib {
    public static String escapeHTML(String str) {
        StringBuilder sb = new StringBuilder(str.length());
        for (int i = 0; i < str.length(); i++) {
            char ch = str.charAt(i);
            if (ch == '&' || ch == '"' || ch == '<' || ch == '>' || ch > 127) {
                sb.append(String.format("&#%d;", (int) ch));
            } else {
                sb.append(ch);
            }
        }
        return sb.toString();
    }

    public static Carrello getCarrello(HttpSession sessione) {
        Carrello c = (Carrello) sessione.getAttribute("carrello");
        if (c == null) {
            c = new Carrello();
            sessione.setAttribute("carrello", c);
        }
        return c;
    }
}
