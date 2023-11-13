<%@ page import="java.sql.*" %>
<%@ page import="edu.fauser.DbUtility" %>
<%@ page import="librerie.lib" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%

    HttpSession sessione = request.getSession();

    if(sessione.getAttribute("nome")==null)
        response.sendRedirect("login.jsp");

    DbUtility dbu = (DbUtility) application.getAttribute("dbutility");

    try(Connection cn = DriverManager.getConnection(dbu.getUrl(), dbu.getUser(), dbu.getPassword());
        Statement s = cn.createStatement();
        ResultSet rs = s.executeQuery("SELECT * FROM brano");) {
%>
<!DOCTYPE html>
<html lang="it">

<%@include file="comp/head.jsp"%>

<body id="page-top">

<%@include file="comp/nav.jsp"%>

<!-- Header -->
<header class="masthead d-flex">
    <div class="container text-center my-auto">
        <h1 class="mb-1">Musica</h1>
        <h3 class="mb-5">
            <em>Un sito dove puoi comprare musica</em>
        </h3>
        <a class="btn btn-primary btn-xl js-scroll-trigger" href="#about">Scopri di più</a>
    </div>
    <div class="overlay"></div>
</header>

<!-- About -->
<section class="content-section bg-light" id="about">
    <div class="container text-center">
        <div class="row">
            <div class="col-lg-10 mx-auto">
                <h2><%= lib.escapeHTML(sessione.getAttribute("nome").toString()) %>, scegli la musica che vuoi acquistare.</h2>
                <p class="lead mb-5">In questo sito puoi acquistare tutta la musica che vuoi, effettuando infine il pagamento nel
                    <a href="carrello.jsp">carrello</a>.</p>
                <a class="btn btn-dark btn-xl js-scroll-trigger" href="#musica">Cosa vendiamo</a>
            </div>
        </div>
    </div>
</section>


<section class="content-section bg-primary text-white text-center" id="musica">
    <br class="container">
        <div class="content-section-heading">
            <h3 class="text-secondary mb-0">Musica</h3>
            <h2 class="mb-5">Ecco le canzoni che vendiamo</h2>
        </div>
        <div class="row">
            <% int conta = 0;
                while (rs.next()) {
                    conta++;
                    if (conta > 1 && (conta % 4) == 1) {
            %>
                    </div><br/><div class="row">
            <%      } %>

            <div class="col-lg-3 col-md-6 mb-5 mb-lg-0">
                <span class="rounded-circle mx-auto mb-3">
                    <img src="anteprime/<%= lib.escapeHTML(rs.getString("nomemp3")) %>.jpg" class="img-fluid rounded-circle">
                    <audio controls>


                        <source src="anteprime/<%= lib.escapeHTML(rs.getString("nomemp3")) %>.mp3" type="audio/mpeg">
                        Errore.
                    </audio>
                    <a href="musica?operazione=aggiungi&id=<%= lib.escapeHTML(rs.getString("id")) %>" class="btn btn-xl btn-light mr-4">Compra <%= lib.escapeHTML(rs.getString("prezzo")) %> &euro;</a>
                </span>
                <h4>
                    <%= lib.escapeHTML(rs.getString("id")) %> - <strong><%= lib.escapeHTML(rs.getString("titolo")) %></strong>
                </h4>
                <p class="text-faded mb-0"><%= lib.escapeHTML(rs.getString("artista")) %></p>
                <p class="text-faded mb-0"><%= lib.escapeHTML(rs.getString("durata")) %></p>
            </div>
        <%     } %>
        </div>
    </div>

    <div class="container text-center">
        <a href="carrello.jsp" class="btn btn-xl btn-light mr-4">Carrello</a>
    </div>
</section>

<%@include file="comp/footer.jsp"%>

<%@include file="comp/top.jsp"%>

<script src="vendor/jquery/jquery.min.js"></script>
<script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="vendor/jquery-easing/jquery.easing.min.js"></script>
<script src="js/stylish-portfolio.min.js"></script>

</body>

</html>
<%
    } catch (Exception e) {
        e.printStackTrace(response.getWriter());
    }
%>