package it.polimi.dao;

import it.polimi.model.Asta;
import it.polimi.model.Articolo;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AstaDAO {
    public boolean creaAsta(Asta asta, List<Integer> articoliIds) {
        String sqlAsta = "INSERT INTO aste (prezzo_iniziale, rialzo_minimo, scadenza, venditore_id) VALUES (?, ?, ?, ?)";
        String sqlAstaArticoli = "INSERT INTO asta_articoli (asta_id, articolo_id) VALUES (?, ?)";

        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);

            // Inserisci l'asta
            try (PreparedStatement stmtAsta = conn.prepareStatement(sqlAsta, Statement.RETURN_GENERATED_KEYS)) {
                stmtAsta.setDouble(1, asta.getPrezzoIniziale());
                stmtAsta.setInt(2, asta.getRialzoMinimo());
                stmtAsta.setTimestamp(3, Timestamp.valueOf(asta.getScadenza()));
                stmtAsta.setInt(4, asta.getVenditoreId());

                int affectedRows = stmtAsta.executeUpdate();
                if (affectedRows == 0) {
                    throw new SQLException("Creazione asta fallita");
                }

                try (ResultSet generatedKeys = stmtAsta.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int astaId = generatedKeys.getInt(1);

                        // Inserisci gli articoli dell'asta
                        try (PreparedStatement stmtArticoli = conn.prepareStatement(sqlAstaArticoli)) {
                            for (Integer articoloId : articoliIds) {
                                stmtArticoli.setInt(1, astaId);
                                stmtArticoli.setInt(2, articoloId);
                                stmtArticoli.addBatch();
                            }
                            stmtArticoli.executeBatch();
                        }

                        conn.commit();
                        return true;
                    }
                }
            }
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return false;
    }

    public List<Asta> getAsteByVenditore(int venditoreId, boolean chiuse) {
        String sql = "SELECT a.*, MAX(o.importo) as offerta_massima " +
                "FROM aste a LEFT JOIN offerte o ON a.id = o.asta_id " +
                "WHERE a.venditore_id = ? AND a.chiusa = ? " +
                "GROUP BY a.id ORDER BY a.scadenza ASC";

        List<Asta> aste = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, venditoreId);
            stmt.setBoolean(2, chiuse);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Asta asta = mapResultSetToAsta(rs);
                    asta.setArticoli(getArticoliByAsta(asta.getId()));
                    aste.add(asta);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return aste;
    }

    public List<Asta> cercaAste(String parolaChiave) {
        String sql = "SELECT DISTINCT a.*, MAX(o.importo) as offerta_massima " +
                "FROM aste a " +
                "JOIN asta_articoli aa ON a.id = aa.asta_id " +
                "JOIN articoli art ON aa.articolo_id = art.id " +
                "LEFT JOIN offerte o ON a.id = o.asta_id " +
                "WHERE a.chiusa = FALSE AND a.scadenza > NOW() " +
                "AND (art.nome LIKE ? OR art.descrizione LIKE ?) " +
                "GROUP BY a.id " +
                "ORDER BY a.scadenza DESC";

        List<Asta> aste = new ArrayList<>();
        String searchPattern = "%" + parolaChiave + "%";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Asta asta = mapResultSetToAsta(rs);
                    asta.setArticoli(getArticoliByAsta(asta.getId()));
                    aste.add(asta);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return aste;
    }

    public Asta getById(int id) {
        String sql = "SELECT a.*, MAX(o.importo) as offerta_massima " +
                "FROM aste a LEFT JOIN offerte o ON a.id = o.asta_id " +
                "WHERE a.id = ? GROUP BY a.id";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Asta asta = mapResultSetToAsta(rs);
                    asta.setArticoli(getArticoliByAsta(id));
                    return asta;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean chiudiAsta(int astaId, int vincitoreId, Double prezzoFinale) {
        String sql = "UPDATE aste SET chiusa = TRUE, vincitore_id = ?, prezzo_finale = ? WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            if (vincitoreId > 0) {
                stmt.setInt(1, vincitoreId);
            } else {
                stmt.setNull(1, Types.INTEGER);
            }

            if (prezzoFinale != null) {
                stmt.setDouble(2, prezzoFinale);
            } else {
                stmt.setNull(2, Types.DECIMAL);
            }

            stmt.setInt(3, astaId);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Asta> getAsteVinte(int utenteId) {
        String sql = "SELECT a.*, MAX(o.importo) as offerta_massima " +
                "FROM aste a LEFT JOIN offerte o ON a.id = o.asta_id " +
                "WHERE a.vincitore_id = ? " +
                "GROUP BY a.id ORDER BY a.scadenza DESC";

        List<Asta> aste = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, utenteId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Asta asta = mapResultSetToAsta(rs);
                    asta.setArticoli(getArticoliByAsta(asta.getId()));
                    aste.add(asta);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return aste;
    }

    private List<Articolo> getArticoliByAsta(int astaId) {
        String sql = "SELECT a.* FROM articoli a " +
                "JOIN asta_articoli aa ON a.id = aa.articolo_id " +
                "WHERE aa.asta_id = ?";

        List<Articolo> articoli = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, astaId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Articolo articolo = new Articolo();
                    articolo.setId(rs.getInt("id"));
                    articolo.setCodice(rs.getString("codice"));
                    articolo.setNome(rs.getString("nome"));
                    articolo.setDescrizione(rs.getString("descrizione"));
                    articolo.setImmagine(rs.getString("immagine"));
                    articolo.setPrezzo(rs.getDouble("prezzo"));
                    articolo.setProprietarioId(rs.getInt("proprietario_id"));
                    articolo.setVenduto(rs.getBoolean("venduto"));
                    articoli.add(articolo);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return articoli;
    }

	private Asta mapResultSetToAsta(ResultSet rs) throws SQLException {
        Asta asta = new Asta();
        asta.setId(rs.getInt("id"));
        asta.setPrezzoIniziale(rs.getDouble("prezzo_iniziale"));
        asta.setRialzoMinimo(rs.getInt("rialzo_minimo"));
        asta.setScadenza(rs.getTimestamp("scadenza").toLocalDateTime());
        asta.setChiusa(rs.getBoolean("chiusa"));
        asta.setVenditoreId(rs.getInt("venditore_id"));

        int vincitoreId = rs.getInt("vincitore_id");
        if (!rs.wasNull()) {
            asta.setVincitoreId(vincitoreId);
        }

        Double prezzoFinale = rs.getDouble("prezzo_finale");
        if (prezzoFinale != null) {
            asta.setPrezzoFinale(prezzoFinale);
        }

        Double offertaMassima = rs.getDouble("offerta_massima");
        if (offertaMassima != null) {
            asta.setOffertaMassima(offertaMassima);
        } else {
            asta.setOffertaMassima(asta.getPrezzoIniziale());
        }

        return asta;
    }
}