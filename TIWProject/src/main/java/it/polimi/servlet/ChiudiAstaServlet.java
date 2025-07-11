package it.polimi.servlet;

import it.polimi.dao.ArticoloDAO;
import it.polimi.dao.AstaDAO;
import it.polimi.dao.OffertaDAO;
import it.polimi.model.Asta;
import it.polimi.model.Articolo;
import it.polimi.model.Utente;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "ChiudiAstaServlet", urlPatterns = {"/chiudi-asta"})
public class ChiudiAstaServlet extends HttpServlet {
    private AstaDAO astaDAO = new AstaDAO();
    private OffertaDAO offertaDAO = new OffertaDAO();
    private ArticoloDAO articoloDAO = new ArticoloDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("utente") == null) {
            System.out.println(" Accesso negato - Sessione non valida");
            response.sendRedirect("login.html");
            return;
        }

        Utente utente = (Utente) session.getAttribute("utente");

        try {
            int astaId = Integer.parseInt(request.getParameter("astaId"));
            System.out.println(" ===== INIZIO CHIUSURA ASTA " + astaId + " =====");
            System.out.println(" Richiesta da utente: " + utente.getUsername() + " (ID: " + utente.getId() + ")");

            // Verifica esistenza e autorizzazione
            Asta asta = astaDAO.getById(astaId);
            if (asta == null) {
                System.err.println(" Asta non trovata: " + astaId);
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Asta non trovata");
                return;
            }

            if (asta.getVenditoreId() != utente.getId()) {
                System.err.println(" Accesso negato - Utente " + utente.getId() + " non è il venditore (venditore: " + asta.getVenditoreId() + ")");
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Non autorizzato a chiudere questa asta");
                return;
            }

            // Verifica stato asta
            System.out.println(" Verifica stato asta:");
            System.out.println("   - Scadenza: " + asta.getScadenza());
            System.out.println("   - Ora attuale: " + java.time.LocalDateTime.now());
            System.out.println("   - È scaduta: " + asta.isScaduta());
            System.out.println("   - È già chiusa: " + asta.isChiusa());

            if (!asta.isScaduta()) {
                System.err.println(" Asta non ancora scaduta");
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "L'asta non è ancora scaduta");
                return;
            }

            if (asta.isChiusa()) {
                System.err.println(" Asta già chiusa");
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "L'asta è già stata chiusa");
                return;
            }

            System.out.println(" Asta valida per chiusura");

            // Ricerca offerta massima
            System.out.println(" ===== RICERCA OFFERTE =====");
            Double offertaMassima = offertaDAO.getOffertaMassima(astaId);
            System.out.println(" Offerta massima ricevuta: " + (offertaMassima != null ? "€" + offertaMassima : "NULL"));

            Integer vincitoreId = null;
            Double prezzoFinale = null;

            if (offertaMassima != null && offertaMassima > 0) {
                System.out.println(" Offerte trovate, ricerca vincitore...");
                vincitoreId = offertaDAO.getVincitore(astaId);
                prezzoFinale = offertaMassima;

                System.out.println(" ===== RISULTATO ASTA =====");
                System.out.println("   - Vincitore ID: " + vincitoreId);
                System.out.println("   - Prezzo finale: €" + prezzoFinale);
                System.out.println("   - Prezzo iniziale: €" + asta.getPrezzoIniziale());

                if (prezzoFinale != null && asta.getPrezzoIniziale() > 0) {
                    double incremento = prezzoFinale - asta.getPrezzoIniziale();
                    double percentuale = (incremento / asta.getPrezzoIniziale()) * 100;
                    System.out.println("   - Incremento: €" + String.format("%.2f", incremento) +
                            " (+" + String.format("%.1f", percentuale) + "%)");
                }

                if (vincitoreId != null && vincitoreId > 0) {
                    // Marca articoli come venduti
                    System.out.println(" Marcatura articoli come venduti...");
                    List<Integer> articoliIds = new ArrayList<>();
                    for (Articolo articolo : asta.getArticoli()) {
                        articoliIds.add(articolo.getId());
                        System.out.println("   - Articolo ID " + articolo.getId() + ": " + articolo.getCodice());
                    }

                    if (!articoliIds.isEmpty()) {
                        articoloDAO.marcaVenduti(articoliIds);
                        System.out.println(" Marcati " + articoliIds.size() + " articoli come venduti");
                    }
                } else {
                    System.err.println("⚠ Vincitore ID non valido: " + vincitoreId);
                }
            } else {
                System.out.println(" ===== ASTA SENZA OFFERTE =====");
                System.out.println("   - Nessuna offerta ricevuta");
                System.out.println("   - L'asta verrà chiusa senza vincitore");
            }

            // Prepara valori finali per il database
            Integer vincitoreFinal = (vincitoreId != null && vincitoreId > 0) ? vincitoreId : null;
            Double prezzoFinal = (prezzoFinale != null && prezzoFinale > 0) ? prezzoFinale : null;

            System.out.println(" ===== AGGIORNAMENTO DATABASE =====");
            System.out.println("   - Asta ID: " + astaId);
            System.out.println("   - Chiusa: TRUE");
            System.out.println("   - Vincitore finale: " + (vincitoreFinal != null ? vincitoreFinal : "NULL"));
            System.out.println("   - Prezzo finale: " + (prezzoFinal != null ? "€" + prezzoFinal : "NULL"));

            // Effettua l'aggiornamento nel database
            boolean success = astaDAO.chiudiAsta(astaId, vincitoreFinal, prezzoFinal);

            if (success) {
                System.out.println(" Aggiornamento database completato con successo");

                // Verifica immediata nel database
                System.out.println(" ===== VERIFICA POST-AGGIORNAMENTO =====");
                Asta astaAggiornata = astaDAO.getById(astaId);

                if (astaAggiornata != null) {
                    System.out.println("   - Asta trovata nel DB");
                    System.out.println("   - Chiusa: " + astaAggiornata.isChiusa());
                    System.out.println("   - Vincitore DB: " + astaAggiornata.getVincitoreId());
                    System.out.println("   - Prezzo finale DB: " + astaAggiornata.getPrezzoFinale());

                    boolean isConsistent = astaAggiornata.isChiusa() &&
                            (vincitoreFinal == null ? astaAggiornata.getVincitoreId() == null : vincitoreFinal.equals(astaAggiornata.getVincitoreId())) &&
                            (prezzoFinal == null ? astaAggiornata.getPrezzoFinale() == null : Math.abs(prezzoFinal - astaAggiornata.getPrezzoFinale()) < 0.01);

                    if (isConsistent) {
                        System.out.println(" Dati nel database coerenti con l'aggiornamento");
                    } else {
                        System.err.println("⚠ ATTENZIONE: Dati nel database non coerenti!");
                        System.err.println("   Expected - Vincitore: " + vincitoreFinal + ", Prezzo: " + prezzoFinal);
                        System.err.println("   Found    - Vincitore: " + astaAggiornata.getVincitoreId() + ", Prezzo: " + astaAggiornata.getPrezzoFinale());
                    }
                } else {
                    System.err.println(" ERRORE: Asta non trovata dopo l'aggiornamento!");
                }

                System.out.println(" ===== CHIUSURA ASTA COMPLETATA =====");
                System.out.println(" Reindirizzamento a dettaglio-asta?id=" + astaId);

                response.sendRedirect("dettaglio-asta?id=" + astaId);

            } else {
                System.err.println(" ===== ERRORE AGGIORNAMENTO DATABASE =====");
                System.err.println(" L'operazione di chiusura è fallita");
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Errore durante la chiusura dell'asta. Contattare l'amministratore.");
            }

        } catch (NumberFormatException e) {
            System.err.println(" ID asta non valido: " + request.getParameter("astaId"));
            System.err.println(" Errore parsing: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID asta non valido");
        } catch (Exception e) {
            System.err.println(" ===== ECCEZIONE DURANTE CHIUSURA ASTA =====");
            System.err.println(" Errore imprevisto: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Errore imprevisto durante la chiusura dell'asta");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to appropriate page
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "Metodo GET non supportato");
    }
}