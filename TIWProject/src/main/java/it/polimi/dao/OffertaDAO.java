
package it.polimi.dao;

import it.polimi.model.Offerta;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class OffertaDAO {

    /**
     * Crea una nuova offerta
     */
    public boolean creaOfferta(Offerta offerta) {
        String sql = "INSERT INTO offerte (asta_id, offerente_id, importo) VALUES (?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, offerta.getAstaId());
            stmt.setInt(2, offerta.getOfferenteId());
            stmt.setDouble(3, offerta.getImporto());  // DOUBLE non BigDecimal!

            int result = stmt.executeUpdate();
            System.out.println("✅ [DAO] Offerta creata: €" + offerta.getImporto() + " per asta " + offerta.getAstaId());
            return result > 0;

        } catch (SQLException e) {
            System.err.println("❌ [DAO] Errore creazione offerta: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Ottieni offerte per un'asta ORDINATE CORRETTAMENTE
     * Prima per IMPORTO DECRESCENTE, poi per DATA CRESCENTE
     */
    public List<Offerta> getOfferteByAsta(int astaId) {
        // QUERY CORRETTA: ordinamento per importo decrescente, poi per data crescente
        String sql = "SELECT o.*, u.nome, u.cognome " +
                "FROM offerte o " +
                "JOIN utenti u ON o.offerente_id = u.id " +
                "WHERE o.asta_id = ? " +
                "ORDER BY o.importo DESC, o.data_offerta ASC";  // ← CORRETTO: importo decrescente!

        List<Offerta> offerte = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, astaId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Offerta offerta = mapResultSetToOfferta(rs);
                    offerte.add(offerta);
                }
            }

        } catch (SQLException e) {
            System.err.println(" Errore get offerte by asta: " + e.getMessage());
            e.printStackTrace();
        }

        return offerte;
    }

    /**
     * Ottieni l'offerta massima per un'asta
     */
    /**
     * Ottieni l'offerta massima per un'asta con debug completo
     */
    public Double getOffertaMassima(int astaId) {
        String sql = "SELECT MAX(importo) as max_offerta, COUNT(*) as num_offerte FROM offerte WHERE asta_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, astaId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    double maxOfferta = rs.getDouble("max_offerta");
                    int numOfferte = rs.getInt("num_offerte");
                    boolean isNull = rs.wasNull();

                    if (!isNull && numOfferte > 0) {
                        return maxOfferta;
                    } else {
                        return null;
                    }
                }
            }

        } catch (SQLException e) {
            System.err.println(" Errore get offerta massima per asta " + astaId + ": " + e.getMessage());
            e.printStackTrace();
        }

        System.out.println(" Nessun risultato per asta " + astaId);
        return null;
    }

    /**
     * Ottieni l'ID del vincitore (chi ha fatto l'offerta più alta)
     * In caso di parità, vince chi ha offerto per primo
     */
    public Integer getVincitore(int astaId) {
        String sql = "SELECT offerente_id, importo, data_offerta FROM offerte " +
                "WHERE asta_id = ? " +
                "ORDER BY importo DESC, data_offerta ASC " +  // Prima il più alto, poi il più vecchio
                "LIMIT 1";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, astaId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int vincitoreId = rs.getInt("offerente_id");
                    double importo = rs.getDouble("importo");
                    java.sql.Timestamp dataOfferta = rs.getTimestamp("data_offerta");

                    return vincitoreId;
                } else {
                    System.out.println(" Nessuna offerta trovata per asta " + astaId);
                }
            }

        } catch (SQLException e) {
            System.err.println(" Errore get vincitore per asta " + astaId + ": " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Mappa ResultSet a oggetto Offerta
     */
    private Offerta mapResultSetToOfferta(ResultSet rs) throws SQLException {
        Offerta offerta = new Offerta();
        offerta.setId(rs.getInt("id"));
        offerta.setAstaId(rs.getInt("asta_id"));
        offerta.setOfferenteId(rs.getInt("offerente_id"));
        offerta.setImporto(rs.getDouble("importo"));  // DOUBLE non BigDecimal!

        // Gestione data
        Timestamp timestamp = rs.getTimestamp("data_offerta");
        if (timestamp != null) {
            offerta.setDataOfferta(timestamp.toLocalDateTime());
        }

        // Nome completo offerente
        String nome = rs.getString("nome");
        String cognome = rs.getString("cognome");
        if (nome != null && cognome != null) {
            offerta.setNomeOfferente(nome + " " + cognome);
        }

        return offerta;
    }
}