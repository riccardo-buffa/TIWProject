package it.polimi.dao;

import it.polimi.model.Offerta;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OffertaDAO {

    public boolean creaOfferta(Offerta offerta) {
        String sql = "INSERT INTO offerte (asta_id, offerente_id, importo) VALUES (?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, offerta.getAstaId());
            stmt.setInt(2, offerta.getOfferenteId());
            stmt.setDouble(3, offerta.getImporto());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Offerta> getOfferteByAsta(int astaId) {
        String sql = "SELECT o.*, u.nome, u.cognome " +
                "FROM offerte o " +
                "JOIN utenti u ON o.offerente_id = u.id " +
                "WHERE o.asta_id = ? " +
                "ORDER BY o.data_offerta DESC";

        List<Offerta> offerte = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, astaId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Offerta offerta = new Offerta();
                    offerta.setId(rs.getInt("id"));
                    offerta.setAstaId(rs.getInt("asta_id"));
                    offerta.setOfferenteId(rs.getInt("offerente_id"));
                    offerta.setImporto(rs.getDouble("importo"));
                    offerta.setDataOfferta(rs.getTimestamp("data_offerta").toLocalDateTime());
                    offerta.setNomeOfferente(rs.getString("nome") + " " + rs.getString("cognome"));
                    offerte.add(offerta);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return offerte;
    }

    public Double getOffertaMassima(int astaId) {
        String sql = "SELECT MAX(importo) as max_offerta FROM offerte WHERE asta_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, astaId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("max_offerta");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Integer getVincitore(int astaId) {
        String sql = "SELECT offerente_id FROM offerte WHERE asta_id = ? ORDER BY importo DESC, data_offerta ASC LIMIT 1";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, astaId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("offerente_id");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}