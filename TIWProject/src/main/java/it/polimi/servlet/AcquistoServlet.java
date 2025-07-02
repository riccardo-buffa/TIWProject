
package it.polimi.servlet;

import it.polimi.dao.AstaDAO;
import it.polimi.model.Asta;
import it.polimi.model.Utente;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AcquistoServlet", urlPatterns = {"/acquisto"})
public class AcquistoServlet extends HttpServlet {
    private AstaDAO astaDAO = new AstaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

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
        String parolaChiave = request.getParameter("ricerca");

        System.out.println("🔍 [Jakarta] Accesso Acquisto per: " + utente.getUsername() +
                (parolaChiave != null ? " - Ricerca: '" + parolaChiave + "'" : ""));

        try {
            List<Asta> aste = null;
            List<Asta> asteVinte = astaDAO.getAsteVinte(utente.getId());

            if (parolaChiave != null && !parolaChiave.trim().isEmpty()) {
                aste = astaDAO.cercaAste(parolaChiave.trim());
                System.out.println("📊 [Jakarta] Risultati ricerca: " + (aste != null ? aste.size() : 0) + " aste");
            }

            request.setAttribute("utente", utente);
            request.setAttribute("parolaChiave", parolaChiave);
            request.setAttribute("aste", aste);
            request.setAttribute("asteVinte", asteVinte);

            request.getRequestDispatcher("/WEB-INF/jsp/acquisto.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("❌ [Jakarta] Errore caricamento pagina Acquisto: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Errore caricamento dati");
        }
    }
}
