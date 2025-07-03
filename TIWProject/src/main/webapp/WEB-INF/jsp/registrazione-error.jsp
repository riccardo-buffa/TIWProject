<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String errore = (String) request.getAttribute("errore");
  String username = (String) request.getAttribute("username");
  String nome = (String) request.getAttribute("nome");
  String cognome = (String) request.getAttribute("cognome");
  String indirizzo = (String) request.getAttribute("indirizzo");
%>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Errore Registrazione - Aste Online</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="container">
  <div class="login-container">
    <h2>❌ Errore Registrazione</h2>

    <div class="alert alert-error">
      <%= errore %>
    </div>

    <form method="post" action="registrazione">
      <div class="form-group">
        <label for="username">👤 Username:</label>
        <input type="text" id="username" name="username"
               minlength="3" maxlength="50" required
               value="<%= username != null ? username : "" %>"
               placeholder="Es. mario.rossi">
      </div>

      <div class="form-group">
        <label for="password">🔒 Password:</label>
        <input type="password" id="password" name="password"
               minlength="6" maxlength="100" required
               placeholder="Almeno 6 caratteri">
      </div>

      <div class="form-group">
        <label for="confermaPassword">🔒 Conferma Password:</label>
        <input type="password" id="confermaPassword" name="confermaPassword"
               minlength="6" maxlength="100" required
               placeholder="Ripeti la password">
      </div>

      <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
        <div class="form-group">
          <label for="nome">🏷️ Nome:</label>
          <input type="text" id="nome" name="nome"
                 maxlength="50" required
                 value="<%= nome != null ? nome : "" %>"
                 placeholder="Es. Mario">
        </div>

        <div class="form-group">
          <label for="cognome">🏷️ Cognome:</label>
          <input type="text" id="cognome" name="cognome"
                 maxlength="50" required
                 value="<%= cognome != null ? cognome : "" %>"
                 placeholder="Es. Rossi">
        </div>
      </div>

      <div class="form-group">
        <label for="indirizzo">📍 Indirizzo:</label>
        <textarea id="indirizzo" name="indirizzo"
                  maxlength="200" required
                  placeholder="Es. Via Roma 123, 20121 Milano (MI)"><%= indirizzo != null ? indirizzo : "" %></textarea>
      </div>

      <button type="submit" class="btn">🚀 Riprova Registrazione</button>
    </form>

    <div style="text-align: center; margin-top: 20px;">
      <p>Hai già un account? <a href="login.html" class="link-button">Accedi qui</a></p>
    </div>
  </div>
</div>
</body></html>