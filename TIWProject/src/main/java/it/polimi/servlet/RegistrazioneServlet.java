package it.polimi.servlet;

import it.polimi.dao.UtenteDAO;
import it.polimi.model.Utente;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "RegistrazioneServlet", urlPatterns = {"/registrazione"})
public class RegistrazioneServlet extends HttpServlet {
    private UtenteDAO utenteDAO = new UtenteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect alla pagina di registrazione
        response.sendRedirect("registrazione.html");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confermaPassword = request.getParameter("confermaPassword");
        String nome = request.getParameter("nome");
        String cognome = request.getParameter("cognome");
        String indirizzo = request.getParameter("indirizzo");

        System.out.println(" Tentativo registrazione per: " + username);

        try {
            // Validazione dati
            String errore = validaDatiRegistrazione(username, password, confermaPassword, nome, cognome, indirizzo);

            if (errore != null) {
                System.err.println(" Errore validazione: " + errore);
                mostraErroreRegistrazione(request, response, errore, username, nome, cognome, indirizzo);
                return;
            }

            // Controlla se username già esiste
            if (utenteDAO.existsByUsername(username)) {
                System.err.println(" Username già esistente: " + username);
                mostraErroreRegistrazione(request, response,
                        " Username '" + username + "' già esistente. Scegline un altro!",
                        null, nome, cognome, indirizzo);
                return;
            }

            // Crea nuovo utente
            Utente nuovoUtente = new Utente(username.trim(), password, nome.trim(), cognome.trim(), indirizzo.trim());

            if (utenteDAO.creaUtente(nuovoUtente)) {
                System.out.println(" Registrazione completata per: " + username);

                // Crea sessione e reindirizza
                HttpSession session = request.getSession();

                // Recupera l'utente appena creato per avere l'ID
                Utente utenteCreato = utenteDAO.login(username, password);
                session.setAttribute("utente", utenteCreato);

                // Mostra pagina di successo
                request.setAttribute("messaggio", "🎉 Registrazione completata con successo! Benvenuto " + nome + "!");
                request.getRequestDispatcher("/WEB-INF/jsp/registrazione-successo.jsp").forward(request, response);

            } else {
                System.err.println(" Errore database durante registrazione: " + username);
                mostraErroreRegistrazione(request, response,
                        " Errore interno del server. Riprova più tardi.",
                        username, nome, cognome, indirizzo);
            }

        } catch (Exception e) {
            System.err.println(" Eccezione durante registrazione: " + e.getMessage());
            e.printStackTrace();
            mostraErroreRegistrazione(request, response,
                    " Errore imprevisto. Riprova più tardi.",
                    username, nome, cognome, indirizzo);
        }
    }

    /**
     * Valida i dati di registrazione
     */
    private String validaDatiRegistrazione(String username, String password, String confermaPassword,
                                           String nome, String cognome, String indirizzo) {

        // Controlla campi vuoti
        if (username == null || username.trim().isEmpty()) {
            return " Username è obbligatorio";
        }
        if (password == null || password.isEmpty()) {
            return " Password è obbligatoria";
        }
        if (confermaPassword == null || confermaPassword.isEmpty()) {
            return " Conferma password è obbligatoria";
        }
        if (nome == null || nome.trim().isEmpty()) {
            return " Nome è obbligatorio";
        }
        if (cognome == null || cognome.trim().isEmpty()) {
            return " Cognome è obbligatorio";
        }
        if (indirizzo == null || indirizzo.trim().isEmpty()) {
            return " Indirizzo è obbligatorio";
        }

        // Controlla lunghezze
        if (username.trim().length() < 3) {
            return " Username deve essere di almeno 3 caratteri";
        }
        if (username.trim().length() > 50) {
            return " Username troppo lungo (massimo 50 caratteri)";
        }
        if (password.length() < 6) {
            return " Password deve essere di almeno 6 caratteri";
        }
        if (password.length() > 100) {
            return " Password troppo lunga (massimo 100 caratteri)";
        }
        if (nome.trim().length() > 50) {
            return " Nome troppo lungo (massimo 50 caratteri)";
        }
        if (cognome.trim().length() > 50) {
            return " Cognome troppo lungo (massimo 50 caratteri)";
        }
        if (indirizzo.trim().length() > 200) {
            return " Indirizzo troppo lungo (massimo 200 caratteri)";
        }

        // Controlla corrispondenza password
        if (!password.equals(confermaPassword)) {
            return " Le password non corrispondono";
        }

        // Controlla caratteri username (solo lettere, numeri, punti, underscore)
        if (!username.matches("^[a-zA-Z0-9._]+$")) {
            return " Username può contenere solo lettere, numeri, punti e underscore";
        }

        return null; // Tutto OK
    }

    /**
     * Mostra la pagina di errore con i dati precompilati
     */
    private void mostraErroreRegistrazione(HttpServletRequest request, HttpServletResponse response,
                                           String errore, String username, String nome, String cognome, String indirizzo)
            throws ServletException, IOException {

        request.setAttribute("errore", errore);
        request.setAttribute("username", username);
        request.setAttribute("nome", nome);
        request.setAttribute("cognome", cognome);
        request.setAttribute("indirizzo", indirizzo);

        request.getRequestDispatcher("/WEB-INF/jsp/registrazione-error.jsp").forward(request, response);
    }
}