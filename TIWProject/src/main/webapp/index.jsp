<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.aste.model.User" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Aste Online - Benvenuto</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .welcome-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            padding: 40px;
            text-align: center;
            max-width: 500px;
            width: 90%;
        }
        
        .logo {
            font-size: 3em;
            color: #667eea;
            margin-bottom: 20px;
            font-weight: bold;
        }
        
        h1 {
            color: #333;
            margin-bottom: 10px;
            font-size: 2.5em;
        }
        
        .subtitle {
            color: #666;
            margin-bottom: 30px;
            font-size: 1.2em;
        }
        
        .features {
            text-align: left;
            margin: 30px 0;
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
        }
        
        .features h3 {
            color: #333;
            margin-bottom: 15px;
            text-align: center;
        }
        
        .features ul {
            list-style: none;
            padding: 0;
        }
        
        .features li {
            padding: 8px 0;
            color: #555;
            position: relative;
            padding-left: 25px;
        }
        
        .features li:before {
            content: "✓";
            position: absolute;
            left: 0;
            color: #28a745;
            font-weight: bold;
        }
        
        .btn-group {
            margin-top: 30px;
        }
        
        .btn {
            display: inline-block;
            padding: 15px 30px;
            margin: 10px;
            text-decoration: none;
            border-radius: 25px;
            font-weight: bold;
            font-size: 1.1em;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
        }
        
        .btn-primary {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }
        
        .btn-secondary {
            background: transparent;
            color: #667eea;
            border: 2px solid #667eea;
        }
        
        .btn-secondary:hover {
            background: #667eea;
            color: white;
            transform: translateY(-2px);
        }
        
        .info-section {
            margin-top: 40px;
            padding-top: 30px;
            border-top: 1px solid #eee;
        }
        
        .info-section h4 {
            color: #333;
            margin-bottom: 15px;
        }
        
        .info-section p {
            color: #666;
            line-height: 1.6;
        }
        
        .user-info {
            background: #d4edda;
            border: 1px solid #c3e6cb;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
        }
        
        .user-info h3 {
            color: #155724;
            margin-bottom: 10px;
        }
        
        @media (max-width: 768px) {
            .welcome-container {
                padding: 20px;
                margin: 20px;
            }
            
            h1 {
                font-size: 2em;
            }
            
            .logo {
                font-size: 2em;
            }
            
            .btn {
                display: block;
                margin: 10px 0;
            }
        }
    </style>
</head>
<body>
    <%
        // Controlla se l'utente è già loggato
        User user = (User) session.getAttribute("user");
        boolean isLoggedIn = (user != null);
    %>
    
    <div class="welcome-container">
        <div class="logo">🏛️</div>
        <h1>Aste Online</h1>
        <p class="subtitle">Il marketplace per comprare e vendere all'asta</p>
        
        <% if (isLoggedIn) { %>
            <!-- Sezione per utente già loggato -->
            <div class="user-info">
                <h3>Bentornato, ${user.nome} ${user.cognome}!</h3>
                <p>Sei già connesso al sistema. Cosa vuoi fare oggi?</p>
            </div>
            
            <div class="btn-group">
                <a href="home.jsp" class="btn btn-primary">Vai alla Dashboard</a>
                <a href="vendo" class="btn btn-secondary">Vendi Articoli</a>
                <a href="acquisto" class="btn btn-secondary">Cerca Aste</a>
            </div>
            
            <div class="info-section">
                <p><a href="login" style="color: #667eea;">Cambia account</a></p>
            </div>
            
        <% } else { %>
            <!-- Sezione per utente non loggato -->
            <div class="features">
                <h3>Cosa puoi fare con Aste Online</h3>
                <ul>
                    <li>Vendi i tuoi articoli tramite aste online</li>
                    <li>Partecipa alle aste e fai offerte</li>
                    <li>Gestisci facilmente le tue vendite</li>
                    <li>Cerca articoli per parola chiave</li>
                    <li>Monitora le tue aste in tempo reale</li>
                    <li>Sistema sicuro di pagamenti</li>
                </ul>
            </div>
            
            <div class="btn-group">
                <a href="login" class="btn btn-primary">Accedi</a>
                <a href="#info" class="btn btn-secondary">Scopri di più</a>
            </div>
            
            <div class="info-section" id="info">
                <h4>Come funziona</h4>
                <p>
                    <strong>Venditori:</strong> Crea i tuoi articoli, avvia aste con prezzi e scadenze personalizzate, 
                    monitora le offerte e chiudi le aste quando scadono.
                </p>
                <br>
                <p>
                    <strong>Acquirenti:</strong> Cerca aste per parola chiave, visualizza dettagli degli articoli, 
                    fai offerte competitive e aggiudicati gli oggetti che desideri.
                </p>
                
                <div style="margin-top: 20px; padding: 15px; background: #fff3cd; border-radius: 8px;">
                    <strong>Account di prova:</strong><br>
                    Username: <code>mario.rossi</code><br>
                    Password: <code>password123</code>
                </div>
            </div>
        <% } %>
    </div>
</body>
</html>
