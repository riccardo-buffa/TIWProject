<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="it.polimi.model.*" %>
<%@ page import="it.polimi.util.DateUtil" %>
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
  <title>Vendo - Aste Online Jakarta</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="header">
  <h1>📦 Vendo - Aste Online</h1>
  <div class="nav-links">
    <a href="home">🏠 Home</a>
    <a href="vendo">📦 Vendo</a>
    <a href="acquisto">🛒 Acquisto</a>
    <a href="login.html">🚪 Logout</a>
  </div>
</div>

<div class="container">
  <div class="user-info">
    Benvenuto, <%= utente.getNomeCompleto() %>
  </div>

  <!-- Form per creare nuovo articolo -->
  <div class="form-container">
    <h2>🆕 Crea Nuovo Articolo</h2>
    <form method="post" action="crea-articolo" enctype="multipart/form-data">
      <div class="form-group">
        <label for="codice">📋 Codice:</label>
        <input type="text" id="codice" name="codice" placeholder="Es. ART001" required>
      </div>
      <div class="form-group">
        <label for="nome">🏷️ Nome:</label>
        <input type="text" id="nome" name="nome" placeholder="Es. iPhone 14 Pro" required>
      </div>
      <div class="form-group">
        <label for="descrizione">📝 Descrizione:</label>
        <textarea id="descrizione" name="descrizione" rows="3" placeholder="Descrizione dettagliata dell'articolo..." required></textarea>
      </div>
      <div class="form-group">
        <label for="immagine">📷 Immagine:</label>
        <input type="file" id="immagine" name="immagine" accept=".jpg,.jpeg,.png,.gif">
        <small style="color: #666;">Formati supportati: JPG, PNG, GIF (max 10MB) - Opzionale</small>
      </div>
      <div class="form-group">
        <label for="prezzo">💰 Prezzo (€):</label>
        <input type="number" step="0.01" id="prezzo" name="prezzo" min="0.01" placeholder="0.00" required>
      </div>
      <button type="submit" class="btn btn-success">🚀 Crea Articolo</button>
    </form>
  </div>

  <!-- Form per creare nuova asta -->
  <% if (articoliDisponibili != null && !articoliDisponibili.isEmpty()) { %>
  <div class="form-container">
    <h2>🎯 Crea Nuova Asta</h2>
    <p style="color: #666; margin-bottom: 20px;">
      Seleziona uno o più articoli e imposta i parametri dell'asta.
    </p>

    <form method="post" action="crea-asta">
      <!-- Selezione Articoli -->
      <div class="form-group">
        <label>📦 Seleziona Articoli da Mettere all'Asta:</label>
        <div class="checkbox-list">
          <%
            double totalePrezzo = 0.0;
            for (Articolo articolo : articoliDisponibili) {
              totalePrezzo += articolo.getPrezzo();
          %>
          <div class="checkbox-item">
            <input type="checkbox"
                   id="art<%= articolo.getId() %>"
                   name="articoli"
                   value="<%= articolo.getId() %>"
                   data-prezzo="<%= articolo.getPrezzo() %>"
                   onchange="calcolaPrezzoTotale()">
            <label for="art<%= articolo.getId() %>">
              <strong><%= articolo.getCodice() %> - <%= articolo.getNome() %></strong>
              <br>💰 €<%= String.format("%.2f", articolo.getPrezzo()) %>
              <br><small style="color: #666;"><%= articolo.getDescrizione() %></small>
            </label>
          </div>
          <% } %>
        </div>
        <div id="prezzo-totale" style="margin-top: 15px; padding: 10px; background-color: #e8f5e8; border-radius: 5px; font-weight: bold;">
          💰 Prezzo iniziale asta: €<span id="totale-valore">0.00</span>
        </div>
      </div>

      <!-- Parametri Asta -->
      <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin-top: 20px;">
        <div class="form-group">
          <label for="rialzo">📈 Rialzo Minimo (€):</label>
          <input type="number" id="rialzo" name="rialzo" min="1" value="10" required>
          <small>Importo minimo che deve essere aggiunto a ogni offerta</small>
        </div>

        <div class="form-group">
          <label for="scadenza">⏰ Scadenza Asta:</label>
          <input type="text"
                 id="scadenza"
                 name="scadenza"
                 placeholder="dd-MM-yyyy HH:mm"
                 pattern="\d{2}-\d{2}-\d{4} \d{2}:\d{2}"
                 title="Formato: 10-07-2025 23:59"
                 required>
          <small>Formato: <strong>dd-MM-yyyy HH:mm</strong> (es. 10-07-2025 23:59)</small>
        </div>
      </div>

      <!-- Esempio e Aiuto -->
      <div style="background-color: #f0f8ff; padding: 15px; border-radius: 8px; margin: 20px 0;">
        <h4 style="color: #2c3e50; margin-bottom: 10px;">💡 Esempio:</h4>
        <ul style="margin-left: 20px; color: #555;">
          <li><strong>Articoli selezionati:</strong> iPhone (€899) + Cuffie (€99) = €998 prezzo iniziale</li>
          <li><strong>Rialzo minimo:</strong> €25 → prossima offerta minima: €1023</li>
          <li><strong>Scadenza:</strong> 15-07-2025 20:00 → asta chiude automaticamente</li>
        </ul>
      </div>

      <!-- Pulsante Crea Asta -->
      <div style="text-align: center; margin-top: 30px;">
        <button type="submit"
                class="btn btn-success"
                style="font-size: 18px; padding: 15px 30px;"
                onclick="return validaFormAsta()">
          🚀 Crea Asta
        </button>
      </div>
    </form>
  </div>
  <% } else { %>
  <div class="alert alert-info">
    📦 <strong>Nessun articolo disponibile per creare aste.</strong>
    <br>Crea prima alcuni articoli usando il form sopra!
  </div>
  <% } %>

  <!-- Lista aste aperte -->
  <% if (asteAperte != null && !asteAperte.isEmpty()) { %>
  <div class="table-container">
    <h3>Le Mie Aste</h3>
    <table>
      <tr>
        <th>Articoli</th>
        <th>Prezzo Iniziale</th>
        <th>Offerta Massima</th>
        <th>Tempo Rimanente</th>
        <th>Azioni</th>
      </tr>
      <% for (Asta asta : asteAperte) { %>
      <tr>
        <td>
          <% for (Articolo art : asta.getArticoli()) { %>
          <strong><%= art.getCodice() %></strong> - <%= art.getNome() %><br>
          <% } %>
        </td>
        <td>€<%= String.format("%.2f", asta.getPrezzoIniziale()) %></td>
        <td>
          <strong style="color: #27ae60;">
            €<%= String.format("%.2f", asta.getOffertaMassima()) %>
          </strong>
        </td>
        <td>
                        <span class="<%= asta.isScaduta() ? "status-closed" : "status-open" %>">
                            <%= DateUtil.getTempoRimanente(asta.getScadenza()) %>
                        </span>
        </td>
        <td>
          <a href="dettaglio-asta?id=<%= asta.getId() %>" class="link-button">📋 Dettagli</a>
        </td>
      </tr>
      <% } %>
    </table>
  </div>
  <% } %>

  <!-- Lista aste chiuse -->
  <% if (asteChiuse != null && !asteChiuse.isEmpty()) { %>
  <div class="table-container">
    <h3>🔴 Le Mie Aste Chiuse (<%= asteChiuse.size() %>)</h3>
    <table>
      <tr>
        <th>📦 Articoli</th>
        <th>💰 Prezzo Iniziale</th>
        <th>💸 Prezzo Finale</th>
        <th>🏆 Stato</th>
        <th>📅 Data Chiusura</th>
        <th>⚙️ Azioni</th>
      </tr>
      <% for (Asta asta : asteChiuse) { %>
      <tr style="<%= asta.getVincitoreId() != null ? "background-color: #f0f8ff;" : "background-color: #fff5f5;" %>">
        <!-- Articoli -->
        <td>
          <% for (Articolo art : asta.getArticoli()) { %>
          <div style="margin-bottom: 8px;">
            <strong><%= art.getCodice() %></strong><br>
            <span style="font-size: 14px;"><%= art.getNome() %></span>
          </div>
          <% } %>
        </td>

        <!-- Prezzo Iniziale -->
        <td>
          <strong style="color: #3498db;">€<%= String.format("%.2f", asta.getPrezzoIniziale()) %></strong><br>
          <small style="color: #666;">Rialzo: €<%= asta.getRialzoMinimo() %></small>
        </td>

        <!-- Prezzo Finale -->
        <td>
          <% if (asta.getPrezzoFinale() != null) { %>
          <strong style="color: #27ae60; font-size: 16px;">€<%= String.format("%.2f", asta.getPrezzoFinale()) %></strong><br>
          <%
            double guadagno = asta.getPrezzoFinale() - asta.getPrezzoIniziale();
            String guadagnoColor = guadagno >= 0 ? "#27ae60" : "#e74c3c";
          %>
          <small style="color: <%= guadagnoColor %>;">
            <%= guadagno >= 0 ? "+" : "" %>€<%= String.format("%.2f", guadagno) %>
          </small>
          <% } else { %>
          <span style="color: #e74c3c; font-weight: bold;">Nessuna offerta</span>
          <% } %>
        </td>

        <!-- Stato -->
        <td>
          <% if (asta.getVincitoreId() != null) { %>
          <div style="background: linear-gradient(135deg, #27ae60, #229954); color: white; padding: 8px 12px; border-radius: 15px; text-align: center;">
            <strong>🏆 VENDUTO</strong>
          </div>
          <% } else { %>
          <div style="background: linear-gradient(135deg, #e74c3c, #c0392b); color: white; padding: 8px 12px; border-radius: 15px; text-align: center;">
            <strong>❌ NON VENDUTO</strong>
          </div>
          <% } %>
        </td>

        <!-- Data Chiusura -->
        <td>
          <strong><%= DateUtil.formatDateTime(asta.getScadenza()) %></strong><br>
          <%
            java.time.LocalDateTime now = java.time.LocalDateTime.now();
            java.time.LocalDateTime scadenza = asta.getScadenza();
            long giorniPassati = java.time.temporal.ChronoUnit.DAYS.between(scadenza, now);
          %>
          <small style="color: #666;">
            <%= giorniPassati == 0 ? "Oggi" : giorniPassati + (giorniPassati == 1 ? " giorno fa" : " giorni fa") %>
          </small>
        </td>

        <!-- Azioni -->
        <td>
          <a href="dettaglio-asta?id=<%= asta.getId() %>" class="link-button">📋 Dettagli</a>
        </td>
      </tr>
      <% } %>
    </table>

    <!-- Statistiche riassuntive aste chiuse -->
    <div style="margin-top: 20px; display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px;">
      <%
        int asteVendute = 0;
        int asteNonVendute = 0;
        double fatturato = 0.0;
        double investimento = 0.0;

        for (Asta asta : asteChiuse) {
          if (asta.getVincitoreId() != null) {
            asteVendute++;
            fatturato += asta.getPrezzoFinale();
          } else {
            asteNonVendute++;
          }
          investimento += asta.getPrezzoIniziale();
        }

        double percentualeSuccesso = asteChiuse.size() > 0 ? ((double)asteVendute / asteChiuse.size()) * 100 : 0;
        double guadagnoTotale = fatturato - investimento;
      %>

      <div style="background: linear-gradient(135deg, #27ae60, #229954); color: white; padding: 15px; border-radius: 10px; text-align: center;">
        <h4 style="margin: 0; font-size: 16px;">🏆 Vendute</h4>
        <p style="font-size: 24px; font-weight: bold; margin: 5px 0;"><%= asteVendute %></p>
        <small>su <%= asteChiuse.size() %> totali</small>
      </div>

      <div style="background: linear-gradient(135deg, #3498db, #2980b9); color: white; padding: 15px; border-radius: 10px; text-align: center;">
        <h4 style="margin: 0; font-size: 16px;">💰 Fatturato</h4>
        <p style="font-size: 24px; font-weight: bold; margin: 5px 0;">€<%= String.format("%.2f", fatturato) %></p>
        <small>incasso totale</small>
      </div>

      <div style="background: linear-gradient(135deg, <%= guadagnoTotale >= 0 ? "#f39c12, #e67e22" : "#e74c3c, #c0392b" %>); color: white; padding: 15px; border-radius: 10px; text-align: center;">
        <h4 style="margin: 0; font-size: 16px;"><%= guadagnoTotale >= 0 ? "📈" : "📉" %> Guadagno</h4>
        <p style="font-size: 24px; font-weight: bold; margin: 5px 0;">
          <%= guadagnoTotale >= 0 ? "+" : "" %>€<%= String.format("%.2f", guadagnoTotale) %>
        </p>
        <small><%= guadagnoTotale >= 0 ? "profitto" : "perdita" %></small>
      </div>

      <div style="background: linear-gradient(135deg, #9b59b6, #8e44ad); color: white; padding: 15px; border-radius: 10px; text-align: center;">
        <h4 style="margin: 0; font-size: 16px;">📊 Successo</h4>
        <p style="font-size: 24px; font-weight: bold; margin: 5px 0;"><%= String.format("%.1f", percentualeSuccesso) %>%</p>
        <small>tasso vendita</small>
      </div>
    </div>
  </div>
  <% } %>

  <% if ((asteAperte == null || asteAperte.isEmpty()) && (asteChiuse == null || asteChiuse.isEmpty())) { %>
  <div class="alert alert-info">
    🎯 <strong>Nessuna asta creata ancora.</strong>
    <br>Crea alcuni articoli e poi la tua prima asta!
  </div>
  <% } %>
</div>

<script>
  // Calcola prezzo totale degli articoli selezionati
  function calcolaPrezzoTotale() {
    let checkboxes = document.querySelectorAll('input[name="articoli"]:checked');
    let totale = 0;

    checkboxes.forEach(function(checkbox) {
      totale += parseFloat(checkbox.getAttribute('data-prezzo'));
    });

    document.getElementById('totale-valore').textContent = totale.toFixed(2);
  }

  // Valida form prima dell'invio
  function validaFormAsta() {
    let checkboxes = document.querySelectorAll('input[name="articoli"]:checked');

    if (checkboxes.length === 0) {
      alert('⚠️ Devi selezionare almeno un articolo per creare l\'asta!');
      return false;
    }

    let scadenza = document.getElementById('scadenza').value;
    let regexData = /^\d{2}-\d{2}-\d{4} \d{2}:\d{2}$/;

    if (!regexData.test(scadenza)) {
      alert('⚠️ Formato data non corretto!\nUsa: dd-MM-yyyy HH:mm\nEsempio: 15-07-2025 20:00');
      return false;
    }

    return confirm('🎯 Confermi di voler creare questa asta?');
  }

  // Imposta data di esempio
  window.onload = function() {
    let oggi = new Date();
    oggi.setDate(oggi.getDate() + 7); // +7 giorni
    let giorno = String(oggi.getDate()).padStart(2, '0');
    let mese = String(oggi.getMonth() + 1).padStart(2, '0');
    let anno = oggi.getFullYear();

    document.getElementById('scadenza').placeholder = giorno + '-' + mese + '-' + anno + ' 23:59';
  };
</script>

<div style="text-align: center; padding: 20px; margin-top: 40px; color: rgba(255,255,255,0.8);">
  <p>© 2025 Aste Online - Politecnico di Milano</p>
  <p><small>🚀 Powered by Jakarta EE 9+ & Modern Web Technologies</small></p>
</div>
</body>
</html>