package it.polimi.servlet;

import it.polimi.dao.AstaDAO;
import it.polimi.dao.UtenteDAO;
import it.polimi.model.Asta;
import it.polimi.model.Utente;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AcquistoServlet", urlPatterns = {"/acquisto"})
public class AcquistoServlet extends HttpServlet {
    private AstaDAO astaDAO = new AstaDAO();
    private UtenteDAO utenteDAO = new UtenteDAO();

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

        System.out.println(" Accesso Acquisto per: " + utente.getUsername() +
                (parolaChiave != null ? " - Ricerca: '" + parolaChiave + "'" : ""));

        try {
            List<Asta> aste = null;

            // Carica sempre le aste vinte dall'utente
            List<Asta> asteVinte = astaDAO.getAsteVinte(utente.getId());
            System.out.println(" Aste vinte caricate: " + asteVinte.size());

            // Crea mappa dei venditori per le aste vinte
            Map<Integer, Utente> venditoriMap = new HashMap<>();
            for (Asta asta : asteVinte) {
                if (!venditoriMap.containsKey(asta.getVenditoreId())) {
                    Utente venditore = utenteDAO.getById(asta.getVenditoreId());
                    if (venditore != null) {
                        venditoriMap.put(asta.getVenditoreId(), venditore);
                        System.out.println(" Venditore caricato: " + venditore.getNomeCompleto() + " per asta " + asta.getId());
                    }
                }
            }

            // Gestione ricerca aste
            if (parolaChiave != null && !parolaChiave.trim().isEmpty()) {
                aste = astaDAO.cercaAste(parolaChiave.trim());
                System.out.println(" Risultati ricerca: " + (aste != null ? aste.size() : 0) + " aste");
            }

            // Imposta attributi per la JSP
            request.setAttribute("utente", utente);
            request.setAttribute("parolaChiave", parolaChiave);
            request.setAttribute("aste", aste);
            request.setAttribute("asteVinte", asteVinte);
            request.setAttribute("venditoriMap", venditoriMap);
            request.getRequestDispatcher("/WEB-INF/jsp/acquisto.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println(" Errore caricamento pagina Acquisto: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Errore caricamento dati");
        }
    }
}