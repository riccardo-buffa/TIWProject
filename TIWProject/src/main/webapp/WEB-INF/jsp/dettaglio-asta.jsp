<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="it.polimi.model.*" %>
<%@ page import="it.polimi.util.DateUtil" %>
<%@ page import="java.util.List" %>
<%
    Utente utente = (Utente) request.getAttribute("utente");
    Asta asta = (Asta) request.getAttribute("asta");
    List<Offerta> offerte = (List<Offerta>) request.getAttribute("offerte");
    Utente venditore = (Utente) request.getAttribute("venditore");
    Utente vincitore = (Utente) request.getAttribute("vincitore");
    Integer numeroPartecipanti = (Integer) request.getAttribute("numeroPartecipanti");
    Boolean isVenditore = (Boolean) request.getAttribute("isVenditore");
    Boolean isVincitore = (Boolean) request.getAttribute("isVincitore");
    Boolean isPartecipante = (Boolean) request.getAttribute("isPartecipante");
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
        <% if (isVenditore) { %>
        <span style="background: #3498db; padding: 4px 8px; border-radius: 12px; font-size: 12px; margin-left: 10px;">📦 TUA ASTA</span>
        <% } else if (isVincitore) { %>
        <span style="background: #27ae60; padding: 4px 8px; border-radius: 12px; font-size: 12px; margin-left: 10px;">🏆 HAI VINTO</span>
        <% } else if (isPartecipante) { %>
        <span style="background: #f39c12; padding: 4px 8px; border-radius: 12px; font-size: 12px; margin-left: 10px;">💰 HAI PARTECIPATO</span>
        <% } %>
    </div>

    <!-- Informazioni asta -->
    <div class="form-container">
        <h2>🎯 Dettagli Asta #<%= asta.getId() %></h2>

        <!-- Badge stato asta -->
        <div style="text-align: center; margin-bottom: 20px;">
            <% if (asta.isChiusa()) { %>
            <% if (vincitore != null) { %>
            <div style="background: linear-gradient(135deg, #27ae60, #229954); color: white; padding: 15px 25px; border-radius: 25px; display: inline-block; font-size: 18px; font-weight: bold;">
                🏆 ASTA CONCLUSA - VENDUTA
            </div>
            <% } else { %>
            <div style="background: linear-gradient(135deg, #e74c3c, #c0392b); color: white; padding: 15px 25px; border-radius: 25px; display: inline-block; font-size: 18px; font-weight: bold;">
                ❌ ASTA CONCLUSA - NON VENDUTA
            </div>
            <% } %>
            <% } else if (asta.isScaduta()) { %>
            <div style="background: linear-gradient(135deg, #f39c12, #e67e22); color: white; padding: 15px 25px; border-radius: 25px; display: inline-block; font-size: 18px; font-weight: bold;">
                ⏰ ASTA SCADUTA
                <% if (isVenditore) { %>
                <form method="post" action="chiudi-asta" style="display: inline-block; margin-left: 15px;">
                    <input type="hidden" name="astaId" value="<%= asta.getId() %>">
                    <button type="submit" class="btn btn-danger" style="font-size: 14px; padding: 8px 15px;"
                            onclick="return confirm('Sei sicuro di voler chiudere questa asta?')">
                        🔒 Chiudi Asta
                    </button>
                </form>
                <% } %>
            </div>
            <% } else { %>
            <div style="background: linear-gradient(135deg, #27ae60, #229954); color: white; padding: 15px 25px; border-radius: 25px; display: inline-block; font-size: 18px; font-weight: bold;">
                🟢 ASTA ATTIVA
            </div>
            <% } %>
        </div>

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
                <div style="text-align: center; margin: 10px 0;">
                    <img src="uploads/images/<%= art.getImmagine() %>" alt="<%= art.getNome() %>"
                         style="max-width: 300px; height: auto; border-radius: 5px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                </div>
                <% } %>
                <p><strong>💰 Prezzo base: €<%= String.format("%.2f", art.getPrezzo()) %></strong></p>
            </div>
            <% } %>
        </div>

        <!-- Informazioni generali asta -->
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-top: 20px;">
            <div class="form-group">
                <label>👤 Venditore:</label>
                <div style="background-color: #f8f9fa; padding: 10px; border-radius: 8px;">
                    <strong><%= venditore.getNomeCompleto() %></strong><br>
                    <small>@<%= venditore.getUsername() %></small>
                </div>
            </div>

            <div class="form-group">
                <label>💵 Prezzo Iniziale:</label>
                <p style="font-size: 18px; font-weight: bold; color: #3498db;">€<%= String.format("%.2f", asta.getPrezzoIniziale()) %></p>
            </div>

            <div class="form-group">
                <label>📈 Rialzo Minimo:</label>
                <p style="font-size: 18px; font-weight: bold; color: #e74c3c;">€<%= asta.getRialzoMinimo() %></p>
            </div>

            <div class="form-group">
                <label>⏰ Scadenza:</label>
                <p style="font-size: 16px; font-weight: bold;"><%= DateUtil.formatDateTime(asta.getScadenza()) %></p>
                <% if (!asta.isChiusa() && !asta.isScaduta()) { %>
                <p style="color: #e74c3c; font-weight: bold;">
                    ⏳ <%= DateUtil.getTempoRimanente(asta.getScadenza()) %>
                </p>
                <% } %>
            </div>
        </div>

        <!-- Statistiche asta -->
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 15px; margin-top: 20px;">
            <div style="background: linear-gradient(135deg, #3498db, #2980b9); color: white; padding: 15px; border-radius: 10px; text-align: center;">
                <h4 style="margin: 0; font-size: 14px;">💰 Offerta Attuale</h4>
                <p style="font-size: 20px; font-weight: bold; margin: 5px 0;">
                    €<%= String.format("%.2f", asta.getOffertaMassima()) %>
                </p>
            </div>

            <div style="background: linear-gradient(135deg, #9b59b6, #8e44ad); color: white; padding: 15px; border-radius: 10px; text-align: center;">
                <h4 style="margin: 0; font-size: 14px;">🔢 Offerte Totali</h4>
                <p style="font-size: 20px; font-weight: bold; margin: 5px 0;"><%= offerte != null ? offerte.size() : 0 %></p>
            </div>

            <div style="background: linear-gradient(135deg, #1abc9c, #16a085); color: white; padding: 15px; border-radius: 10px; text-align: center;">
                <h4 style="margin: 0; font-size: 14px;">👥 Partecipanti</h4>
                <p style="font-size: 20px; font-weight: bold; margin: 5px 0;"><%= numeroPartecipanti %></p>
            </div>
        </div>
    </div>

    <!-- Sezione risultato asta (solo se chiusa) -->
    <% if (asta.isChiusa()) { %>
    <div class="form-container">
        <h2><%= vincitore != null ? "🏆 Risultato Asta - VENDUTA" : "❌ Risultato Asta - NON VENDUTA" %></h2>

        <% if (vincitore != null) { %>
        <!-- Asta venduta -->
        <div style="background: linear-gradient(135deg, #d4edda, #c3e6cb); padding: 20px; border-radius: 10px; border-left: 5px solid #28a745;">
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px;">
                <!-- Aggiudicatario -->
                <div>
                    <h4 style="color: #155724; margin-bottom: 15px;">🏆 Aggiudicatario</h4>
                    <div style="background: white; padding: 15px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                        <p style="margin: 0; font-size: 18px; font-weight: bold; color: #2c3e50;">
                            <%= vincitore.getNomeCompleto() %>
                        </p>
                        <p style="margin: 5px 0 0 0; color: #666;">
                            @<%= vincitore.getUsername() %>
                        </p>
                    </div>
                </div>

                <!-- Prezzo Finale -->
                <div>
                    <h4 style="color: #155724; margin-bottom: 15px;">💰 Prezzo Finale</h4>
                    <div style="background: white; padding: 15px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                        <p style="margin: 0; font-size: 24px; font-weight: bold; color: #27ae60;">
                            €<%= String.format("%.2f", asta.getPrezzoFinale()) %>
                        </p>
                        <%
                            double incremento = asta.getPrezzoFinale() - asta.getPrezzoIniziale();
                            double percentualeIncremento = (incremento / asta.getPrezzoIniziale()) * 100;
                        %>
                        <p style="margin: 5px 0 0 0; color: #666;">
                            +€<%= String.format("%.2f", incremento) %>
                            (<%= String.format("%.1f", percentualeIncremento) %>%)
                        </p>
                    </div>
                </div>
            </div>

            <!-- Indirizzo di Spedizione (solo per venditore e vincitore) -->
            <% if (isVenditore || isVincitore) { %>
            <div style="margin-top: 20px;">
                <h4 style="color: #155724; margin-bottom: 15px;">📍 Indirizzo di Spedizione</h4>
                <div style="background: white; padding: 15px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                    <p style="margin: 0; font-size: 16px; line-height: 1.5; color: #2c3e50;">
                        <%= vincitore.getIndirizzo() %>
                    </p>
                    <% if (isVenditore) { %>
                    <div style="margin-top: 10px; padding: 10px; background-color: #fff3cd; border-radius: 5px;">
                        <small style="color: #856404;">
                            <strong>💡 Promemoria:</strong> Procedi con la spedizione e mantieni i documenti di tracking.
                        </small>
                    </div>
                    <% } %>
                </div>
            </div>
            <% } %>
        </div>
        <% } else { %>
        <!-- Asta non venduta -->
        <div style="background: linear-gradient(135deg, #f8d7da, #f1c2c7); padding: 20px; border-radius: 10px; border-left: 5px solid #dc3545;">
            <div style="text-align: center;">
                <h3 style="color: #721c24; margin-bottom: 15px;">Nessuna offerta ricevuta</h3>
                <p style="color: #721c24; font-size: 16px;">
                    Questa asta non ha ricevuto alcuna offerta ed è quindi non venduta.
                </p>
                <% if (isVenditore) { %>
                <div style="margin-top: 15px; padding: 15px; background: white; border-radius: 8px;">
                    <p style="color: #6c757d; margin: 0;">
                        <strong>💡 Suggerimenti:</strong> Considera di ricreare l'asta con un prezzo iniziale più basso
                        o una descrizione più dettagliata degli articoli.
                    </p>
                </div>
                <% } %>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>

    <!-- Lista offerte -->
    <% if (offerte != null && !offerte.isEmpty()) { %>
    <div class="table-container">
        <h3>💰 Cronologia Offerte (<%= offerte.size() %>)</h3>
        <table>
            <tr>
                <th>🏆 Pos.</th>
                <th>👤 Offerente</th>
                <th>💵 Importo</th>
                <th>📅 Data/Ora</th>
                <th>📊 Status</th>
            </tr>
            <% for (int i = 0; i < offerte.size(); i++) {
                Offerta offerta = offerte.get(i);
                boolean isWinning = (i == 0);
                boolean isCurrentUser = (offerta.getOfferenteId() == utente.getId());
            %>
            <tr style="<%= isWinning ? "background-color: #f0f8ff; font-weight: bold;" : "" %>
                    <%= isCurrentUser ? "border-left: 4px solid #3498db;" : "" %>">
                <td style="text-align: center;">
                    <% if (i == 0) { %>🥇
                    <% } else if (i == 1) { %>🥈
                    <% } else if (i == 2) { %>🥉
                    <% } else { %>#<%= i + 1 %>
                    <% } %>
                </td>
                <td>
                    <%= offerta.getNomeOfferente() %>
                    <% if (isCurrentUser) { %>
                    <span style="background: #3498db; color: white; padding: 2px 6px; border-radius: 10px; font-size: 10px; margin-left: 5px;">TU</span>
                    <% } %>
                </td>
                <td>
                    <span style="<%= isWinning ? "color: #27ae60; font-size: 18px;" : "" %>">
                        €<%= String.format("%.2f", offerta.getImporto()) %>
                    </span>
                </td>
                <td><%= DateUtil.formatDateTime(offerta.getDataOfferta()) %></td>
                <td>
                    <% if (isWinning && asta.isChiusa()) { %>
                    <span class="status-open">🏆 VINCENTE</span>
                    <% } else if (isWinning && !asta.isChiusa()) { %>
                    <span class="status-open">👑 IN TESTA</span>
                    <% } else { %>
                    <span style="color: #666;">#<%= i + 1 %></span>
                    <% } %>
                </td>
            </tr>
            <% } %>
        </table>
    </div>
    <% } else { %>
    <div class="alert alert-info">
        📭 <strong>Nessuna offerta ancora ricevuta.</strong>
        <% if (!asta.isChiusa() && !asta.isScaduta()) { %>
        Sii il primo a fare un'offerta!
        <% } %>
    </div>
    <% } %>

    <!-- Pulsante per fare offerta (solo se asta aperta e non è il venditore) -->
    <% if (!asta.isChiusa() && !asta.isScaduta() && !isVenditore) { %>
    <div style="text-align: center; margin: 30px 0;">
        <a href="offerta?id=<%= asta.getId() %>" class="btn btn-success"
           style="text-decoration: none; font-size: 18px; padding: 15px 30px;">
            💰 Fai la tua Offerta
        </a>
    </div>
    <% } %>

    <!-- Pulsanti di navigazione -->
    <div style="text-align: center; margin: 30px 0;">
        <% if (isVenditore) { %>
        <a href="vendo" class="link-button" style="font-size: 16px; margin-right: 15px;">
            ← Torna alle mie aste
        </a>
        <% } else { %>
        <a href="acquisto" class="link-button" style="font-size: 16px; margin-right: 15px;">
            ← Torna alla ricerca
        </a>
        <% } %>
        <a href="home" class="link-button" style="font-size: 16px;">
            🏠 Home
        </a>
    </div>
</div>

<%@ include file="common/footer.jsp" %>
</body>
</html>