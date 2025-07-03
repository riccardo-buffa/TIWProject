
package it.polimi.servlet;

import it.polimi.dao.ArticoloDAO;
import it.polimi.dao.AstaDAO;
import it.polimi.dao.OffertaDAO;
import it.polimi.model.Asta;
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
            response.sendRedirect("login.html");
            return;
        }

        Utente utente = (Utente) session.getAttribute("utente");

        try {
            int astaId = Integer.parseInt(request.getParameter("astaId"));
            System.out.println("🔒 [Jakarta] Chiusura asta " + astaId + " da utente: " + utente.getUsername());

            Asta asta = astaDAO.getById(astaId);
            if (asta == null || asta.getVenditoreId() != utente.getId()) {
                System.err.println("❌ [Jakarta] Accesso negato - Asta non trovata o utente non autorizzato");
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Non autorizzato");
                return;
            }

            if (!asta.isScaduta() || asta.isChiusa()) {
                System.err.println("❌ [Jakarta] Asta non può essere chiusa - Scaduta: " + asta.isScaduta() + ", Chiusa: " + asta.isChiusa());
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Asta non può essere chiusa");
                return;
            }

            // Determina vincitore e prezzo finale
            Double offertaMassima = offertaDAO.getOffertaMassima(astaId);
            Integer vincitoreId = null;
            Double prezzoFinale = null;

            if (offertaMassima != null) {
                vincitoreId = offertaDAO.getVincitore(astaId);
                prezzoFinale = offertaMassima;

                System.out.println("🏆 [Jakarta] Vincitore: ID " + vincitoreId + ", Prezzo finale: €" + prezzoFinale);

                // Marca articoli come venduti
                List<Integer> articoliIds = new ArrayList<>();
                for (int i = 0; i < asta.getArticoli().size(); i++) {
                    articoliIds.add(asta.getArticoli().get(i).getId());
                }
                articoloDAO.marcaVenduti(articoliIds);
                System.out.println("📦 [Jakarta] Marcati " + articoliIds.size() + " articoli come venduti");
            } else {
                System.out.println("📭 [Jakarta] Nessuna offerta ricevuta per l'asta");
            }

            if (astaDAO.chiudiAsta(astaId, vincitoreId != null ? vincitoreId : 0, prezzoFinale)) {
                System.out.println("✅ [Jakarta] Asta chiusa con successo");
                response.sendRedirect("dettaglio-asta?id=" + astaId);
            } else {
                System.err.println("❌ [Jakarta] Errore chiusura asta nel database");
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Errore nella chiusura dell'asta");
            }

        } catch (NumberFormatException e) {
            System.err.println("❌ [Jakarta] ID asta non valido: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID asta non valido");
        } catch (Exception e) {
            System.err.println("❌ [Jakarta] Errore chiusura asta: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Errore nella chiusura dell'asta");
        }
    }
}