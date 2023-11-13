<%@ page import="java.sql.*" %>
<%@ page import="edu.fauser.DbUtility" %>
<%@ page import="librerie.lib" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%

  HttpSession sessione = request.getSession();

  if(sessione.getAttribute("nome")!=null)
    response.sendRedirect("index.jsp");
%>
<!DOCTYPE html>
<html lang="it">

<%@include file="comp/head.jsp"%>

<body id="page-top">

<header class="masthead d-flex">
  <div class="container text-center my-auto">
    <h1 class="mb-1">Login Musica</h1>
    <h3 class="mb-5">
      <em>Un sito dove puoi comprare musica</em>
    </h3>

    <form class="form-signin" action="musica" method="post">
      <% if (request.getParameter("errore") != null) { %>
      <div class="alert alert-danger" role="alert">
        Nome utente e/o password non validi.
      </div>
      <% } %>
      <label for="username" class="sr-only">Nome utente</label>
      <input type="text" id="username" name="username" class="form-control" placeholder="Nome utente" required autofocus value="demo"/>
      <label for="password" class="sr-only">Password</label>
      <input type="password" id="password" name="password" class="form-control" placeholder="Password" value="demo"/>
      <button class="btn btn-lg btn-primary btn-block" type="submit">Accedi</button>
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