package it.com.aste.model;

import java.sql.Timestamp;
import java.io.Serializable;

public class User implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int id;
    private String username;
    private String password;
    private String nome;
    private String cognome;
    private String indirizzo;
    private Timestamp lastLogin;
    private Timestamp createdAt;
    
    // Costruttori
    public User() {}
    
    public User(String username, String password, String nome, String cognome, String indirizzo) {
        this.username = username;
        this.password = password;
        this.nome = nome;
        this.cognome = cognome;
        this.indirizzo = indirizzo;
    }
    
    public User(int id, String username, String nome, String cognome, String indirizzo) {
        this.id = id;
        this.username = username;
        this.nome = nome;
        this.cognome = cognome;
        this.indirizzo = indirizzo;
    }
    
    // Getter e Setter
    public int getId() { 
        return id; 
    }
    
    public void setId(int id) { 
        this.id = id; 
    }
    
    public String getUsername() { 
        return username; 
    }
    
    public void setUsername(String username) { 
        this.username = username; 
    }
    
    public String getPassword() { 
        return password; 
    }
    
    public void setPassword(String password) { 
        this.password = password; 
    }
    
    public String getNome() { 
        return nome; 
    }
    
    public void setNome(String nome) { 
        this.nome = nome; 
    }
    
    public String getCognome() { 
        return cognome; 
    }
    
    public void setCognome(String cognome) { 
        this.cognome = cognome; 
    }
    
    public String getIndirizzo() { 
        return indirizzo; 
    }
    
    public void setIndirizzo(String indirizzo) { 
        this.indirizzo = indirizzo; 
    }
    
    public Timestamp getLastLogin() { 
        return lastLogin; 
    }
    
    public void setLastLogin(Timestamp lastLogin) { 
        this.lastLogin = lastLogin; 
    }
    
    public Timestamp getCreatedAt() { 
        return createdAt; 
    }
    
    public void setCreatedAt(Timestamp createdAt) { 
        this.createdAt = createdAt; 
    }
    
    // Metodi utility
    public String getNomeCompleto() {
        return nome + " " + cognome;
    }
    
    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", nome='" + nome + '\'' +
                ", cognome='" + cognome + '\'' +
                '}';
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        User user = (User) obj;
        return id == user.id;
    }
    
    @Override
    public int hashCode() {
        return Integer.hashCode(id);
    }
}