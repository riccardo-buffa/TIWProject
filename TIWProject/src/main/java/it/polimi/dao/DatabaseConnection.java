package it.polimi.dao;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    private static DataSource dataSource;

    static {
        try {
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:/comp/env");
            dataSource = (DataSource) envContext.lookup("jdbc/AsteDB");
            System.out.println("✅ DataSource configurato con connection pooling");
        } catch (Exception e) {
            System.err.println("❌ Errore configurazione DataSource: " + e.getMessage());
            // Fallback alla connessione diretta
            try {
				getDirectConnection();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
        }
    }

    public static Connection getConnection() throws SQLException {
        if (dataSource != null) {
            return dataSource.getConnection();
        } else {
            return getDirectConnection();
        }
    }

    // Metodo fallback
    private static Connection getDirectConnection() throws SQLException {
        String url = "jdbc:mysql://localhost:3306/aste_online?useSSL=false&serverTimezone=Europe/Rome";
        return DriverManager.getConnection(url, "aste_user", "aste_password123");
    }
}