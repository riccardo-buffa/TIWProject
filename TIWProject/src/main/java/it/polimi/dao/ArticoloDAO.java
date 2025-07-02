package it.polimi.dao;
import it.polimi.model.Articolo;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ArticoloDAO {

    public boolean createArticolo(Articolo articolo) {
        String sql = "INSERT INTO articoli (nome, descrizione, immagine, prezzo, proprietario_id) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, articolo.getNome());
            stmt.setString(2, articolo.getDescrizione());
            stmt.setString(3, articolo.getImmagine());
            stmt.setDouble(4, articolo.getPrezzo());
            stmt.setInt(5, articolo.getProprietarioId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Articolo> getArticoliDisponibili(int proprietarioId) {
        String sql = "SELECT * FROM articoli WHERE proprietario_id = ? AND venduto = false";
        List<Articolo> articoli = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, proprietarioId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Articolo articolo = new Articolo();
                articolo.setCodice(rs.getString("codice"));
                articolo.setNome(rs.getString("nome"));
                articolo.setDescrizione(rs.getString("descrizione"));
                articolo.setImmagine(rs.getString("immagine"));
                articolo.setPrezzo(rs.getDouble("prezzo"));
                articolo.setProprietarioId(rs.getInt("proprietario_id"));
                articolo.setVenduto(rs.getBoolean("venduto"));
                articoli.add(articolo);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return articoli;
    }

    public Articolo getArticoloById(int codice) {
        String sql = "SELECT * FROM articoli WHERE codice = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, codice);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Articolo articolo = new Articolo();
                articolo.setCodice(rs.getString("codice"));
                articolo.setNome(rs.getString("nome"));
                articolo.setDescrizione(rs.getString("descrizione"));
                articolo.setImmagine(rs.getString("immagine"));
                articolo.setPrezzo(rs.getDouble("prezzo"));
                articolo.setProprietarioId(rs.getInt("proprietario_id"));
                articolo.setVenduto(rs.getBoolean("venduto"));
                return articolo;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void markAsVenduto(int codice) {
        String sql = "UPDATE articoli SET venduto = true WHERE codice = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, codice);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
