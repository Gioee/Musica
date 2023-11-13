<%@ page import="java.sql.*" %>
<%@ page import="edu.fauser.DbUtility" %>
<%@ page import="librerie.lib" %>
<%@ page import="classi.Carrello" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%

    HttpSession sessione = request.getSession();

    if(sessione.getAttribute("nome")==null)
        response.sendRedirect("login.jsp");

    Carrello c = lib.getCarrello(sessione);
    String query = "SELECT * FROM brano WHERE ";

    for (int i = 0; i < c.numeroCanzoni(); i++) {
        query = query + "id = " + c.getID().get(i);
        if(i!=c.numeroCanzoni()-1)
            query = query + " OR ";
    }

    DbUtility dbu = (DbUtility) application.getAttribute("dbutility");
%>
<!DOCTYPE html>
<html lang="it">

<%@include file="comp/head.jsp"%>

<body id="page-top">

<%@include file="comp/nav.jsp"%>

<section class="content-section bg-primary text-white text-center" id="musica">
    <br class="container">
    <div class="content-section-heading">
        <h3 class="text-secondary mb-0">Carrello</h3>
        <h2 class="mb-5">Puoi decidere cosa acquistare e cosa rimuovere dal carrello</h2>
    </div>
    <% if(c.numeroCanzoni()>0)
        try(Connection cn = DriverManager.getConnection(dbu.getUrl(), dbu.getUser(), dbu.getPassword());
            Statement s = cn.createStatement();
            ResultSet rs = s.executeQuery(query);) {
    %>
    <div class="row">
        <% int conta = 0;
        double prezzo = 0.0;
            while (rs.next()) {
                conta++;
                if (conta > 1 && (conta % 4) == 1) {
        %>
    </div><br/><div class="row">
    <%      } %>

    <div class="col-lg-3 col-md-6 mb-5 mb-lg-0">
                <span class="rounded-circle mx-auto mb-3">
                    <img src="anteprime/<%= lib.escapeHTML(rs.getString("nomemp3")) %>.jpg" class="img-fluid rounded-circle">
                    <a href="musica?operazione=elimina&id=<%= lib.escapeHTML(rs.getString("id")) %>" class="btn btn-xl btn-light mr-4">Elimina</a>
                </span>
        <h4>
            <%= lib.escapeHTML(rs.getString("id")) %> - <strong><%= lib.escapeHTML(rs.getString("titolo")) %></strong>
        </h4>
        <p class="text-faded mb-0"><%= lib.escapeHTML(rs.getString("artista")) %></p>
    </div>
    <%     prezzo += rs.getDouble("prezzo");
            } %>
</div>
    </div>

    <br/>

    <div class="container text-center">
        <a href="index.jsp" class="btn btn-xl btn-dark">Home</a>
        <a href="pagamento.jsp" class="btn btn-xl btn-light mr-4">Pagamento di <%= prezzo %> &euro;</a>
    </div>
    <%
            } catch (Exception e) {
                e.printStackTrace(response.getWriter());
            }
    %>
</section>

<%@include file="comp/footer.jsp"%>

<%@include file="comp/top.jsp"%>

<script src="vendor/jquery/jquery.min.js"></script>
<script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="vendor/jquery-easing/jquery.easing.min.js"></script>
<script src="js/stylish-portfolio.min.js"></script>

</body>

</html>