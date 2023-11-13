// fix svuota carrello
// fix grafica

import classi.Carrello;

import java.io.*;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.*;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

import edu.fauser.DbUtility;
import librerie.lib;

@WebServlet(name = "MusicaServlet", value = "/musica")
public class MusicaServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        boolean cpass = request.getParameter("cpass") != null;
        if (cpass)
            eseguiCambio(request, response);
        else
            eseguiLogin(request, response);
    }


    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html; charset=UTF-8");
        String operazione = request.getParameter("operazione");
        if (operazione == null) operazione = "";
        switch(operazione) {
            case "aggiungi":
                aggiungi(request, response);
                break;
            case "elimina":
                elimina(request, response);
                break;
            case "scarica":
                scarica(request, response);
                break;
            default:
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                return;
        }
    }

    private void aggiungi(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id;
        try {
            id = Integer.parseInt(request.getParameter("id"));
        }
        catch (NumberFormatException ex) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        HttpSession sessione = request.getSession();
        Carrello c = lib.getCarrello(sessione);
        c.aggiungi(id);
        response.sendRedirect("carrello.jsp");
        return;
    }

    private void elimina(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id;
        try {
            id = Integer.parseInt(request.getParameter("id"));
        }
        catch (NumberFormatException ex) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        HttpSession sessione = request.getSession();
        Carrello c = lib.getCarrello(sessione);
        c.elimina(id);
        response.sendRedirect("carrello.jsp");
    }

    private void scarica(HttpServletRequest request, HttpServletResponse response) throws IOException {

        HttpSession sessione = request.getSession();
        Carrello c = lib.getCarrello(sessione);

        if (c == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        byte[] zip;

        String query = "SELECT * FROM brano WHERE ";

        for (int i = 0; i < c.numeroCanzoni(); i++) {
            query = query + "id = " + c.getID().get(i);
            if(i!=c.numeroCanzoni()-1)
                query = query + " OR ";
        }

        ServletContext ctx = request.getServletContext();
        DbUtility dbu = (DbUtility) ctx.getAttribute("dbutility");

        try (Connection cn = DriverManager.getConnection(dbu.getUrl(), dbu.getUser(), dbu.getPassword());
             Statement s = cn.createStatement();
             ResultSet rs = s.executeQuery(query);){

            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            ZipOutputStream zos = new ZipOutputStream(baos);

            while (rs.next()) {

                zos.putNextEntry(new ZipEntry(new File(String.format(lib.escapeHTML(rs.getString("nomemp3")) + ".mp3")).getName()));
                byte[] bytesFile = Files.readAllBytes(Paths.get(request.getServletContext().getRealPath("/WEB-INF/canzoni/" + lib.escapeHTML(rs.getString("nomemp3")) + ".mp3")));

                zos.write(bytesFile, 0, bytesFile.length);
                zos.closeEntry();
            }

            zos.flush();
            baos.flush();
            zos.close();
            baos.close();

            zip = baos.toByteArray();

            sessione.removeAttribute("carrello");

        } catch (IOException | SQLException ex) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            return;
        }

        if (zip == null) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            return;
        }

        ServletOutputStream sos = response.getOutputStream();
        response.setContentType("application/zip");
        response.setHeader("Content-disposition", String.format("attachment; filename=brani.zip"));

        sos.write(zip);
        sos.flush();

    }

    private void eseguiLogin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession sessione = request.getSession(false);
        if (sessione != null && sessione.getAttribute("nome") != null) {
            response.sendRedirect(request.getContextPath());
            return;
        }
        String user = request.getParameter("username");
        String pwd = request.getParameter("password");
        String redirect = request.getParameter("redirect");
        if (redirect == null || redirect.isEmpty())
            redirect = request.getContextPath();

        ServletContext ctx = request.getServletContext();
        DbUtility dbu = (DbUtility) ctx.getAttribute("dbutility");

        try (Connection cn = DriverManager.getConnection(dbu.getUrl(), dbu.getUser(), dbu.getPassword())) {
            String strSql = "SELECT username, cognome, nome FROM utente " +
                    "WHERE username = ? AND SHA2(CONCAT(salt, ?), 256) = password_hash";
            try (PreparedStatement ps = cn.prepareStatement(strSql)) {
                ps.setString(1, user);
                ps.setString(2, pwd);
                ResultSet rs = ps.executeQuery();
                if (rs.next() == true) {
                    sessione = request.getSession(true);
                    sessione.setAttribute("username", rs.getString("username"));
                    sessione.setAttribute("nome", rs.getString("nome") + " " + rs.getString("cognome"));
                    sessione.setMaxInactiveInterval(30*60);
                    response.sendRedirect(redirect);
                } else {
                    String url = String.format("%s/login.jsp?errore&redirect=%s", request.getContextPath(), URLEncoder.encode(redirect, "utf-8"));
                    response.sendRedirect(url);
                }
            }
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void eseguiCambio(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession sessione = request.getSession(false);

        String user = sessione.getAttribute("username").toString();;
        String pwd = request.getParameter("password");
        String npwd = request.getParameter("npassword");

        String redirect = request.getParameter("redirect");
        if (redirect == null || redirect.isEmpty())
            redirect = request.getContextPath();

        DbUtility dbu = (DbUtility) getServletContext().getAttribute("dbutility");

        try (Connection cn = DriverManager.getConnection(dbu.getUrl(), dbu.getUser(), dbu.getPassword())) {

            String strSql = "CALL cambiaPassword(?, ?, ?)";
            try (PreparedStatement ps = cn.prepareStatement(strSql)) {
                ps.setString(1, user);
                ps.setString(2, pwd);
                ps.setString(3, npwd);
                if (ps.executeUpdate() == 0) {
                    String url = String.format("%s/pass.jsp?errore&redirect=%s", request.getContextPath(), URLEncoder.encode(redirect, "utf-8"));
                    response.sendRedirect(url);
                }
                else {
                    sessione = request.getSession(true);
                    sessione.invalidate();
                    response.sendRedirect("login.jsp");
                }
            }
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }


}