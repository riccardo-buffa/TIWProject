<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="it.polimi.model.*" %>
<%@ page import="it.polimi.util.DateUtil" %>
<%@ page import="java.util.List" %>
<%
    Utente utente = (Utente) request.getAttribute("utente");
    Asta asta = (Asta) request.getAttribute("asta");
    List<Offerta> offerte = (List<Offerta>) request.getAttribute("offerte");
    Utente vincitore = (Utente) request.getAttribute("vincitore");
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dettaglio Asta #<%= asta.getId() %> - Aste Online</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<%@ include file="common/header.jsp" %>

<div class="container">
    <div class="user-info">
        Benvenuto, <%= utente.getNomeCompleto() %>
    </div>

    <!-- Dettagli asta -->
    <div class="form-container">
        <h2>🎯 Dettagli Asta #<%= asta.getId() %></h2>

        <!-- Articoli -->
        <div class="form-group">
            <label>📦 Articoli in Asta:</label>
            <% for (Articolo art : asta.getArticoli()) { %>
            <div style="border: 1px solid #ddd; padding: 15px; margin-bottom: 15px; border-radius: 8px; background-color: #f9f9f9;">
                <h4 style="color: #2c3e50; margin-bottom: 10px;">
                    <%= art.getCodice() %> - <%= art.getNome() %>
                </h4>
                <p style="margin-bottom: 10px;"><%= art.getDescrizione() %></p>
                <% if (art.getImmagine() != null && !art.getImmagine().isEmpty()) { %>
                <% if (art.getImmagine() != null && !art.getImmagine().isEmpty()) { %>
                <img src="uploads/images/<%= art.getImmagine() %>" alt="<%= art.getNome() %>"
                     style="max-width: 200px; height: auto; border-radius: 5px;">
                <% } else { %>
                <div style="width: 200px; height: 150px; background: #f0f0f0; display: flex; align-items: center; justify-content: center; border-radius: 5px;">
                    📷 Nessuna immagine
                </div>
                <% } %>
                <% } %>
                <p><strong>💰 Prezzo base: €<%= art.getPrezzo() %></strong></p>
            </div>
            <% } %>
        </div>

        <!-- Informazioni asta -->
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin-top: 20px;">
            <div class="form-group">
                <label>💵 Prezzo Iniziale:</label>
                <p style="font-size: 18px; font-weight: bold; color: #27ae60;">€<%= asta.getPrezzoIniziale() %></p>
            </div>

            <div class="form-group">
                <label>📈 Rialzo Minimo:</label>
                <p style="font-size: 18px; font-weight: bold; color: #e74c3c;">€<%= asta.getRialzoMinimo() %></p>
            </div>

            <div class="form-group">
                <label>⏰ Scadenza:</label>
                <p style="font-size: 16px; font-weight: bold;"><%= DateUtil.formatDateTime(asta.getScadenza()) %></p>
            </div>

            <div class="form-group">
                <label>🏷️ Stato:</label>
                <% if (asta.isChiusa()) { %>
                <span class="status-closed" style="font-size: 16px;">🔴 Chiusa</span>
                <% if (vincitore != null) { %>
                <p style="margin-top: 10px;">
                    <strong>🏆 Aggiudicatario:</strong> <%= vincitore.getNomeCompleto() %><br>
                    <strong>💰 Prezzo Finale:</strong> €<%= asta.getPrezzoFinale() %><br>
                    <strong>📍 Indirizzo Spedizione:</strong> <%= vincitore.getIndirizzo() %>
                </p>
                <% } else { %>
                <p style="margin-top: 10px; color: #888;">❌ Nessun vincitore</p>
                <% } %>
                <% } else { %>
                <% if (asta.isScaduta()) { %>
                <span class="status-closed" style="font-size: 16px;">⏰ Scaduta</span>
                <% if (asta.getVenditoreId() == utente.getId()) { %>
                <form method="post" action="chiudi-asta" style="display: inline-block; margin-left: 15px;">
                    <input type="hidden" name="astaId" value="<%= asta.getId() %>">
                    <button type="submit" class="btn btn-danger"
                            onclick="return confirm('Sei sicuro di voler chiudere questa asta?')">
                        🔒 Chiudi Asta
                    </button>
                </form>
                <% } %>
                <% } else { %>
                <span class="status-open" style="font-size: 16px;">🟢 Aperta</span>
                <p style="margin-top: 10px;">
                    <strong>⏳ Tempo Rimanente:</strong>
                    <span style="color: #e74c3c; font-weight: bold;">
                                    <%= DateUtil.getTempoRimanente(asta.getScadenza()) %>
                                </span>
                </p>
                <% } %>
                <% } %>
            </div>
        </div>
    </div>

    <!-- Lista offerte -->
    <% if (offerte != null && !offerte.isEmpty()) { %>
    <div class="table-container">
        <h3>💰 Offerte Ricevute (<%= offerte.size() %>)</h3>
        <table>
            <tr>
                <th>👤 Offerente</th>
                <th>💵 Importo</th>
                <th>📅 Data/Ora</th>
                <th>🏆 Posizione</th>
            </tr>
            <% for (int i = 0; i < offerte.size(); i++) {
                Offerta offerta = offerte.get(i); %>
            <tr <% if (i == 0) { %>style="background-color: #f0f8ff; font-weight: bold;"<% } %>>
                <td>
                    <% if (i == 0) { %>🥇<% } else if (i == 1) { %>🥈<% } else if (i == 2) { %>🥉<% } %>
                    <%= offerta.getNomeOfferente() %>
                </td>
                <td>
                        <span style="<% if (i == 0) { %>color: #27ae60; font-size: 18px;<% } %>">
                            €<%= offerta.getImporto() %>
                        </span>
                </td>
                <td><%= DateUtil.formatDateTime(offerta.getDataOfferta()) %></td>
                <td>
                    <% if (i == 0) { %>
                    <span class="status-open">🏆 Vincente</span>
                    <% } else { %>
                    #<%= i + 1 %>
                    <% } %>
                </td>
            </tr>
            <% } %>
        </table>
    </div>
    <% } else { %>
    <div class="alert alert-info">
        📭 <strong>Nessuna offerta ricevuta</strong> per questa asta.
    </div>
    <% } %>

    <!-- Pulsante per fare offerta -->
    <% if (!asta.isChiusa() && !asta.isScaduta() && asta.getVenditoreId() != utente.getId()) { %>
    <div style="text-align: center; margin: 30px 0;">
        <a href="offerta?id=<%= asta.getId() %>" class="btn btn-success"
           style="text-decoration: none; font-size: 18px; padding: 15px 30px;">
            💰 Fai la tua Offerta
        </a>
    </div>
    <% } %>
</div>

<%@ include file="common/footer.jsp" %>
</body>
</html>