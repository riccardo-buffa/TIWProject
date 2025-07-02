<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="it.polimi.model.*" %>
<%@ page import="java.util.List" %>
<%
  Utente utente = (Utente) request.getAttribute("utente");
  List<Asta> asteAperte = (List<Asta>) request.getAttribute("asteAperte");
  List<Asta> asteChiuse = (List<Asta>) request.getAttribute("asteChiuse");
  List<Articolo> articoliDisponibili = (List<Articolo>) request.getAttribute("articoliDisponibili");
%>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Vendo - Aste Online</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
<%@ include file="common/header.jsp" %>

<div class="container">
  <div class="user-info">
    Benvenuto, <%= utente.getNomeCompleto() %>
  </div>

  <!-- Form per creare nuovo articolo -->
  <div class="form-container">
    <h2>🆕 Crea Nuovo Articolo</h2>
    <form method="post" action="crea-articolo">
      <div class="form-group">
        <label for="codice">Codice:</label>
        <input type="text" id="codice" name="codice" placeholder="Es. ART001" required>
      </div>
      <div class="form-group">
        <label for="nome">Nome:</label>
        <input type="text" id="nome" name="nome" placeholder="Es. iPhone 14 Pro" required>
      </div>
      <div class="form-group">
        <label for="descrizione">Descrizione:</label>
        <textarea id="descrizione" name="descrizione" rows="3" placeholder="Descrizione dettagliata dell'articolo..." required></textarea>
      </div>
      <div class="form-group">
        <label for="immagine">URL Immagine:</label>
        <input type="url" id="immagine" name="immagine" placeholder="https://..." required>
      </div>
      <div class="form-group">
        <label for="prezzo">Prezzo (€):</label>
        <input type="number" step="0.01" id="prezzo" name="prezzo" min="0.01" placeholder="0.00" required>
      </div>
      <button type="submit" class="btn btn-success">Crea Articolo</button>
    </form>
  </div>

  <!-- Form per creare nuova asta -->
    <% if (articoliDisponibili != null && !articoliDisponibili.isEmpty()) { %>
  <div class="form-container">
    <h2>🎯 Crea Nuova Asta</h2>
    <form method="post" action="crea-asta">
      <div class="form-group">
        <label>Seleziona Articoli:</label>
        <div class="checkbox-list">
          <% for (Articolo articolo : articoliDisponibili) { %>
          <div class="checkbox-item">
            <input type="checkbox" id="art<%= articolo.getId() %>" name="articoli" value="<%= articolo.getId() %>">
            <label for="art<%= articolo.getId() %>">
              <strong><%= articolo.getCodice() %> - <%= articolo.getNome() %></strong>
              <br>€<%= articolo.getPrezzo() %> - <%= articolo.getDescrizione() %>
            </label>
          </div>
          <% } %>
          </table>
        </div>
        <% } %>

        <% if ((asteAperte == null || asteAperte.isEmpty()) && (asteChiuse == null || asteChiuse.isEmpty())) { %>
        <div class="alert alert-info">
          🎯 <strong>Nessuna asta creata.</strong> Crea alcuni articoli e poi crea la tua prima asta!
        </div>
        <% } %>
      </div>

      <%@ include file="common/footer.jsp" %>
</body>
</html>