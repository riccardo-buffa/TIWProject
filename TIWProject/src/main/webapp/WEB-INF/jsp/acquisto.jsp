<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="it.polimi.model.*" %>
<%@ page import="it.polimi.util.DateUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
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
  <%
    Map<Integer, Utente> venditoriMap = (Map<Integer, Utente>) request.getAttribute("venditoriMap");
    if (asteVinte != null && !asteVinte.isEmpty()) {
  %>
  <div class="table-container">
    <h3>🏆 Le Mie Aste Vinte (<%= asteVinte.size() %>)</h3>
    <table>
      <tr>
        <th>📦 Articoli</th>
        <th>💰 Prezzo Pagato</th>
        <th>👤 Venditore</th>
        <th>📅 Data Aggiudicazione</th>
        <th>📍 Il Mio Indirizzo</th>
        <th>⚙️ Azioni</th>
      </tr>
      <% for (Asta asta : asteVinte) {
        Utente venditore = venditoriMap != null ? venditoriMap.get(asta.getVenditoreId()) : null;
      %>
      <tr style="background-color: #f0f8ff; border-left: 4px solid #27ae60;">
        <!-- Articoli -->
        <td>
          <% for (Articolo art : asta.getArticoli()) { %>
          <div style="margin-bottom: 8px;">
            <strong style="color: #2c3e50;"><%= art.getCodice() %> - <%= art.getNome() %></strong><br>
            <small style="color: #666; line-height: 1.4;"><%= art.getDescrizione().length() > 60 ? art.getDescrizione().substring(0, 60) + "..." : art.getDescrizione() %></small><br>
            <small style="color: #888;">Valore base: €<%= String.format("%.2f", art.getPrezzo()) %></small>
          </div>
          <% } %>
        </td>

        <!-- Prezzo Pagato -->
        <td>
          <div style="text-align: center;">
            <span style="background: linear-gradient(135deg, #27ae60, #229954); color: white; padding: 8px 12px; border-radius: 15px; font-weight: bold; display: inline-block;">
              🏆 €<%= String.format("%.2f", asta.getPrezzoFinale()) %>
            </span>
            <br>
            <%
              double risparmio = 0;
              for (Articolo art : asta.getArticoli()) {
                risparmio += art.getPrezzo();
              }
              risparmio = risparmio - asta.getPrezzoFinale();
              String risparmioCss = risparmio > 0 ? "#27ae60" : "#e74c3c";
              String risparmioText = risparmio > 0 ? "Risparmiato" : "Pagato extra";
            %>
            <small style="color: <%= risparmioCss %>; font-weight: bold; margin-top: 5px; display: block;">
              <%= risparmio > 0 ? "💰" : "💸" %> <%= risparmioText %>: €<%= String.format("%.2f", Math.abs(risparmio)) %>
            </small>
          </div>
        </td>

        <!-- Venditore -->
        <td>
          <% if (venditore != null) { %>
          <div style="background-color: #f8f9fa; padding: 10px; border-radius: 8px;">
            <strong style="color: #2c3e50;"><%= venditore.getNomeCompleto() %></strong><br>
            <small style="color: #666;">@<%= venditore.getUsername() %></small><br>
            <small style="color: #888; margin-top: 5px; display: block;">
              📍 <%= venditore.getIndirizzo() %>
            </small>
          </div>
          <% } else { %>
          <span style="color: #888;">Venditore non disponibile</span>
          <% } %>
        </td>

        <!-- Data Aggiudicazione -->
        <td>
          <strong style="color: #2c3e50;"><%= DateUtil.formatDateTime(asta.getScadenza()) %></strong><br>
          <%
            java.time.LocalDateTime now = java.time.LocalDateTime.now();
            java.time.LocalDateTime scadenza = asta.getScadenza();
            long giorniPassati = java.time.temporal.ChronoUnit.DAYS.between(scadenza, now);
          %>
          <small style="color: #666;">
            <%= giorniPassati == 0 ? "Oggi" : giorniPassati + (giorniPassati == 1 ? " giorno fa" : " giorni fa") %>
          </small>
        </td>

        <!-- Indirizzo Spedizione -->
        <td>
          <div style="background: linear-gradient(135deg, #e8f5e8, #d4edda); padding: 10px; border-radius: 8px; border-left: 4px solid #28a745;">
            <strong style="color: #155724;">📍 Spedire a:</strong><br>
            <span style="font-size: 14px; line-height: 1.4; color: #155724;">
              <%= utente.getIndirizzo() %>
            </span>
          </div>
          <div style="margin-top: 8px; padding: 8px; background-color: #fff3cd; border-radius: 5px;">
            <small style="color: #856404;">
              <strong>💡 Promemoria:</strong> Il venditore dovrebbe aver già spedito gli articoli a questo indirizzo.
            </small>
          </div>
        </td>

        <!-- Azioni -->
        <td>
          <div style="display: flex; flex-direction: column; gap: 8px;">
            <!-- Link dettagli -->
            <a href="dettaglio-asta?id=<%= asta.getId() %>"
               class="link-button"
               style="font-size: 12px; padding: 8px; text-align: center; background: #3498db; color: white; border-radius: 5px; text-decoration: none;">
              📋 Dettagli Completi
            </a>

            <!-- Riepilogo spesa -->
            <div style="background-color: #d1ecf1; padding: 8px; border-radius: 5px; text-align: center; font-size: 11px;">
              <strong style="color: #0c5460;">💳 Pagato</strong><br>
              <span style="color: #0c5460; font-weight: bold;">€<%= String.format("%.2f", asta.getPrezzoFinale()) %></span>
            </div>

            <!-- ID Asta -->
            <div style="font-size: 10px; color: #666; text-align: center;">
              <em>Asta #<%= asta.getId() %></em>
            </div>
          </div>
        </td>
      </tr>
      <% } %>
    </table>

    <!-- Statistiche riassuntive aste vinte -->
    <div style="margin-top: 20px; display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px;">
      <%
        int totaleAsteVinte = asteVinte.size();
        double spesaTotale = 0.0;
        double valoreTotaleArticoli = 0.0;

        for (Asta asta : asteVinte) {
          spesaTotale += asta.getPrezzoFinale();
          for (Articolo art : asta.getArticoli()) {
            valoreTotaleArticoli += art.getPrezzo();
          }
        }

        double risparmiTotali = valoreTotaleArticoli - spesaTotale;
        double percentualeRisparmio = valoreTotaleArticoli > 0 ? (risparmiTotali / valoreTotaleArticoli) * 100 : 0;
      %>

      <div style="background: linear-gradient(135deg, #27ae60, #229954); color: white; padding: 15px; border-radius: 10px; text-align: center;">
        <h4 style="margin: 0; font-size: 16px;">🏆 Aste Vinte</h4>
        <p style="font-size: 24px; font-weight: bold; margin: 5px 0;"><%= totaleAsteVinte %></p>
        <small>aggiudicate</small>
      </div>

      <div style="background: linear-gradient(135deg, #e74c3c, #c0392b); color: white; padding: 15px; border-radius: 10px; text-align: center;">
        <h4 style="margin: 0; font-size: 16px;">💳 Spesa Totale</h4>
        <p style="font-size: 24px; font-weight: bold; margin: 5px 0;">€<%= String.format("%.2f", spesaTotale) %></p>
        <small>investimento</small>
      </div>

      <div style="background: linear-gradient(135deg, #3498db, #2980b9); color: white; padding: 15px; border-radius: 10px; text-align: center;">
        <h4 style="margin: 0; font-size: 16px;">💰 Valore Articoli</h4>
        <p style="font-size: 24px; font-weight: bold; margin: 5px 0;">€<%= String.format("%.2f", valoreTotaleArticoli) %></p>
        <small>valore originale</small>
      </div>

      <div style="background: linear-gradient(135deg, <%= risparmiTotali >= 0 ? "#f39c12, #e67e22" : "#9b59b6, #8e44ad" %>); color: white; padding: 15px; border-radius: 10px; text-align: center;">
        <h4 style="margin: 0; font-size: 16px;"><%= risparmiTotali >= 0 ? "💰 Risparmiato" : "💸 Extra Pagato" %></h4>
        <p style="font-size: 24px; font-weight: bold; margin: 5px 0;">
          <%= risparmiTotali >= 0 ? "+" : "" %>€<%= String.format("%.2f", risparmiTotali) %>
        </p>
        <small>(<%= String.format("%.1f", Math.abs(percentualeRisparmio)) %>%)</small>
      </div>
    </div>
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