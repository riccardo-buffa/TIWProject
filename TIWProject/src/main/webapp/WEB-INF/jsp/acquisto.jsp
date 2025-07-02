<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="it.polimi.model.*" %>
<%@ page import="it.polimi.util.DateUtil" %>
<%@ page import="java.util.List" %>
<%
  Utente utente = (Utente) request.getAttribute("utente");
  String parolaChiave = (String) request.getAttribute("parolaChiave");
  List<Asta> aste = (List<Asta>) request.getAttribute("aste");
  List<Asta> asteVinte = (List<Asta>) request.getAttribute("asteVinte");
%>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Acquisto - Aste Online</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
<%@ include file="common/header.jsp" %>

<div class="container">
  <div class="user-info">
    Benvenuto, <%= utente.getNomeCompleto() %>
  </div>

  <!-- Form di ricerca -->
  <div class="form-container">
    <h2>🔍 Cerca Aste</h2>
    <form method="post" action="acquisto">
      <div class="form-group">
        <label for="ricerca">Parola chiave:</label>
        <input type="text" id="ricerca" name="ricerca"
               value="<%= parolaChiave != null ? parolaChiave : "" %>"
               placeholder="Cerca per nome o descrizione articolo..." required>
      </div>
      <button type="submit" class="btn">🔍 Cerca</button>
    </form>
  </div>

  <!-- Risultati della ricerca -->
  <% if (aste != null) { %>
  <% if (!aste.isEmpty()) { %>
  <div class="table-container">
    <h3>📋 Risultati Ricerca per: "<%= parolaChiave %>"</h3>
    <table>
      <tr>
        <th>Articoli</th>
        <th>Prezzo Attuale</th>
        <th>Tempo Rimanente</th>
        <th>Stato</th>
        <th>Azioni</th>
      </tr>
      <% for (Asta asta : aste) { %>
      <tr>
        <td>
          <% for (Articolo art : asta.getArticoli()) { %>
          <div style="margin-bottom: 8px;">
            <strong><%= art.getCodice() %> - <%= art.getNome() %></strong><br>
            <small><%= art.getDescrizione().length() > 50 ?
                    art.getDescrizione().substring(0, 50) + "..." :
                    art.getDescrizione() %></small>
          </div>
          <% } %>
        </td>
        <td>
          <strong>€<%= asta.getOffertaMassima() != 0 ? asta.getOffertaMassima() : asta.getPrezzoIniziale() %></strong>
          <br><small>Rialzo min: €<%= asta.getRialzoMinimo() %></small>
        </td>
        <td>
                            <span class="<%= asta.isScaduta() ? "status-closed" : "status-open" %>">
                                <%= DateUtil.getTempoRimanente(asta.getScadenza()) %>
                            </span>
        </td>
        <td>
          <% if (asta.isChiusa()) { %>
          <span class="status-closed">🔴 Chiusa</span>
          <% } else if (asta.isScaduta()) { %>
          <span class="status-closed">⏰ Scaduta</span>
          <% } else { %>
          <span class="status-open">🟢 Aperta</span>
          <% } %>
        </td>
        <td>
          <% if (!asta.isChiusa() && !asta.isScaduta()) { %>
          <a href="offerta?id=<%= asta.getId() %>" class="btn btn-success" style="text-decoration: none; font-size: 14px;">
            💰 Fai Offerta
          </a>
          <% } else { %>
          <span style="color: #888;">Non disponibile</span>
          <% } %>
        </td>
      </tr>
      <% } %>
    </table>
  </div>
  <% } else { %>
  <div class="alert alert-info">
    🔍 <strong>Nessuna asta trovata</strong> per la parola chiave: "<%= parolaChiave %>"
    <br>Prova con termini diversi o controlla l'ortografia.
  </div>
  <% } %>
  <% } %>

  <!-- Aste vinte -->
  <% if (asteVinte != null && !asteVinte.isEmpty()) { %>
  <div class="table-container">
    <h3>🏆 Le Mie Aste Vinte</h3>
    <table>
      <tr>
        <th>Articoli</th>
        <th>Prezzo Finale</th>
        <th>Data Chiusura</th>
        <th>Indirizzo Spedizione</th>
      </tr>
      <% for (Asta asta : asteVinte) { %>
      <tr style="background-color: #f0f8ff;">
        <td>
          <% for (Articolo art : asta.getArticoli()) { %>
          <div style="margin-bottom: 8px;">
            <strong><%= art.getCodice() %> - <%= art.getNome() %></strong><br>
            <small><%= art.getDescrizione() %></small>
          </div>
          <% } %>
        </td>
        <td>
          <strong style="color: #27ae60;">€<%= asta.getPrezzoFinale() %></strong>
        </td>
        <td>
          <%= DateUtil.formatDateTime(asta.getScadenza()) %>
        </td>
        <td>
          <%= utente.getIndirizzo() %>
        </td>
      </tr>
      <% } %>
    </table>
  </div>
  <% } %>

  <% if (aste == null && (asteVinte == null || asteVinte.isEmpty())) { %>
  <div class="alert alert-info">
    🛒 <strong>Inizia a cercare!</strong> Usa il campo di ricerca sopra per trovare aste interessanti.
  </div>
  <% } %>
</div>

<%@ include file="common/footer.jsp" %>
</body>
</html>