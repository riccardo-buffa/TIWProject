package it.polimi.dao;

import it.polimi.model.Articolo;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ArticoloDAO {

    /**
     * Crea un nuovo articolo nel database
     */
    public boolean creaArticolo(Articolo articolo) {
        // QUERY CORRETTA con TUTTI i campi obbligatori
        String sql = "INSERT INTO articoli (codice, nome, descrizione, immagine, prezzo, proprietario_id, venduto) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            // Popola TUTTI i parametri
            stmt.setString(1, articolo.getCodice());
            stmt.setString(2, articolo.getNome());
            stmt.setString(3, articolo.getDescrizione());
            stmt.setString(4, articolo.getImmagine());
            stmt.setDouble(5, articolo.getPrezzo());  // DOUBLE non BigDecimal!
            stmt.setInt(6, articolo.getProprietarioId());
            stmt.setBoolean(7, articolo.isVenduto());

            int result = stmt.executeUpdate();
            System.out.println("✅ [DAO] Articolo creato: " + articolo.getCodice());
            return result > 0;

        } catch (SQLException e) {
            System.err.println("❌ [DAO] Errore creazione articolo: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Ottieni articoli disponibili per un proprietario
     */
    public List<Articolo> getArticoliDisponibili(int proprietarioId) {
        String sql = "SELECT * FROM articoli WHERE proprietario_id = ? AND venduto = FALSE";
        List<Articolo> articoli = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, proprietarioId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Articolo articolo = mapResultSetToArticolo(rs);
                    articoli.add(articolo);
                }
            }

        } catch (SQLException e) {
            System.err.println("❌ [DAO] Errore get articoli disponibili: " + e.getMessage());
            e.printStackTrace();
        }

        return articoli;
    }

    /**
     * Ottieni articoli per lista di ID
     */
    public List<Articolo> getArticoliByIds(List<Integer> ids) {
        if (ids == null || ids.isEmpty()) {
            return new ArrayList<>();
        }

        // Costruisci query con IN clause
        StringBuilder sql = new StringBuilder("SELECT * FROM articoli WHERE id IN (");
        for (int i = 0; i < ids.size(); i++) {
            sql.append("?");
            if (i < ids.size() - 1) sql.append(",");
        }
        sql.append(")");

        List<Articolo> articoli = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            // Popola parametri
            for (int i = 0; i < ids.size(); i++) {
                stmt.setInt(i + 1, ids.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Articolo articolo = mapResultSetToArticolo(rs);
                    articoli.add(articolo);
                }
            }

        } catch (SQLException e) {
            System.err.println("❌ [DAO] Errore get articoli by IDs: " + e.getMessage());
            e.printStackTrace();
        }

        return articoli;
    }

    /**
     * Marca articoli come venduti
     */
    public void marcaVenduti(List<Integer> articoliIds) {
        if (articoliIds == null || articoliIds.isEmpty()) return;

        StringBuilder sql = new StringBuilder("UPDATE articoli SET venduto = TRUE WHERE id IN (");
        for (int i = 0; i < articoliIds.size(); i++) {
            sql.append("?");
            if (i < articoliIds.size() - 1) sql.append(",");
        }
        sql.append(")");

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < articoliIds.size(); i++) {
                stmt.setInt(i + 1, articoliIds.get(i));
            }

            stmt.executeUpdate();
            System.out.println("✅ [DAO] Marcati " + articoliIds.size() + " articoli come venduti");

        } catch (SQLException e) {
            System.err.println("❌ [DAO] Errore marca venduti: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Mappa ResultSet a oggetto Articolo
     */
    private Articolo mapResultSetToArticolo(ResultSet rs) throws SQLException {
        Articolo articolo = new Articolo();
        articolo.setId(rs.getInt("id"));
        articolo.setCodice(rs.getString("codice"));
        articolo.setNome(rs.getString("nome"));
        articolo.setDescrizione(rs.getString("descrizione"));
        articolo.setImmagine(rs.getString("immagine"));
        articolo.setPrezzo(rs.getDouble("prezzo"));  // DOUBLE non BigDecimal!
        articolo.setProprietarioId(rs.getInt("proprietario_id"));
        articolo.setVenduto(rs.getBoolean("venduto"));
        return articolo;
    }
}