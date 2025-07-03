
package it.polimi.servlet;

import it.polimi.dao.ArticoloDAO;
import it.polimi.model.Articolo;
import it.polimi.model.Utente;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "CreaArticoloServlet", urlPatterns = {"/crea-articolo"})
public class CreaArticoloServlet extends HttpServlet {
    private ArticoloDAO articoloDAO = new ArticoloDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("utente") == null) {
            response.sendRedirect("login.html");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        Utente utente = (Utente) session.getAttribute("utente");

        try {
            String codice = request.getParameter("codice");
            String nome = request.getParameter("nome");
            String descrizione = request.getParameter("descrizione");
            String immagine = request.getParameter("immagine");
            double prezzo = Double.parseDouble(request.getParameter("prezzo"));

            System.out.println("📦 [Jakarta] Creazione articolo: " + codice + " - " + nome + " per utente: " + utente.getUsername());

            Articolo articolo = new Articolo(codice, nome, descrizione, immagine, prezzo, utente.getId());

            if (articoloDAO.creaArticolo(articolo)) {
                System.out.println("✅ [Jakarta] Articolo creato con successo: " + codice);
                response.sendRedirect("vendo");
            } else {
                System.err.println("❌ [Jakarta] Errore creazione articolo: " + codice);
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Errore nella creazione dell'articolo");
            }

        } catch (NumberFormatException e) {
            System.err.println("❌ [Jakarta] Prezzo non valido: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Prezzo non valido");
        } catch (Exception e) {
            System.err.println("❌ [Jakarta] Errore creazione articolo: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Errore nella creazione dell'articolo");
        }
    }
}
