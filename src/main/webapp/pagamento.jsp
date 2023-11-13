<%@ page import="java.sql.*" %>
<%@ page import="edu.fauser.DbUtility" %>
<%@ page import="librerie.lib" %>
<%@ page import="classi.Carrello" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%

    HttpSession sessione = request.getSession();
    Carrello c = lib.getCarrello(sessione);

    if(sessione.getAttribute("nome")==null || c.numeroCanzoni()<1)
        response.sendRedirect("login.jsp");

    String query = "SELECT SUM(prezzo) as 'prezzotot' FROM brano WHERE ";

    for (int i = 0; i < c.numeroCanzoni(); i++) {
        query = query + "id = " + c.getID().get(i);
        if(i!=c.numeroCanzoni()-1)
            query = query + " OR ";
    }

    DbUtility dbu = (DbUtility) application.getAttribute("dbutility");

    try(Connection cn = DriverManager.getConnection(dbu.getUrl(), dbu.getUser(), dbu.getPassword());
        Statement s = cn.createStatement();
        ResultSet rs = s.executeQuery(query);) {
        if(rs.next()){
%>
<!DOCTYPE html>
<html lang="it">

<%@include file="comp/head.jsp"%>

<body id="page-top">

<%@include file="comp/nav.jsp"%>

<header class="masthead d-flex">
    <div class="container text-center my-auto">
        <h1 class="mb-1">Musica</h1>
        <h3 class="mb-5">
            <em>Pagamento di <%= lib.escapeHTML(rs.getString("prezzotot")) %> &euro; completato</em>
        </h3>
        <a class="btn btn-primary btn-xl js-scroll-trigger" href="musica?operazione=scarica">Download zip</a>
    </div>
    <div class="overlay"></div>
</header>

<% }
} catch (Exception e) {
    e.printStackTrace(response.getWriter());
}
%>

<%@include file="comp/footer.jsp"%>

<%@include file="comp/top.jsp"%>

<script src="vendor/jquery/jquery.min.js"></script>
<script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="vendor/jquery-easing/jquery.easing.min.js"></script>
<script src="js/stylish-portfolio.min.js"></script>

</body>

</html>