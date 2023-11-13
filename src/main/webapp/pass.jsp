<%@ page import="java.sql.*" %>
<%@ page import="edu.fauser.DbUtility" %>
<%@ page import="librerie.lib" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%

    HttpSession sessione = request.getSession();

    if(sessione.getAttribute("nome")==null)
        response.sendRedirect("login.jsp");

%>
<!DOCTYPE html>
<html lang="it">

<%@include file="comp/head.jsp"%>

<body id="page-top">

<%@include file="comp/nav.jsp"%>

<header class="masthead d-flex">
    <div class="container text-center my-auto">
        <h1 class="mb-1">Cambia Password</h1>
        <h3 class="mb-5">
            <em>Un sito dove puoi comprare musica</em>
        </h3>

        <form class="form-signin" action="musica" method="post">
            <% if (request.getParameter("errore") != null) { %>
            <div class="alert alert-danger" role="alert">
                Password errata.
            </div>
            <% } %>
            <input type="hidden" id="cpass" name="cpass" value="cpass">
            <label for="password" class="sr-only">Password</label>
            <input type="password" id="password" name="password" class="form-control" placeholder="Password" required autofocus />
            <label for="npassword" class="sr-only">Password</label>
            <input type="password" id="npassword" name="npassword" class="form-control" placeholder="Nuova password" required />
            <button class="btn btn-lg btn-primary btn-block" type="submit" <% if (sessione.getAttribute("username").equals("demo")) { %> disabled <% } %>>Cambia password <% if (sessione.getAttribute("username").equals("demo")) { %> (impossibile cambiare la password dell'utente demo) <% } %></button>
        </form>

    </div>
    <div class="overlay"></div>
</header>

<%@include file="comp/footer.jsp"%>

<script src="vendor/jquery/jquery.min.js"></script>
<script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="vendor/jquery-easing/jquery.easing.min.js"></script>
<script src="js/stylish-portfolio.min.js"></script>

</body>

</html>