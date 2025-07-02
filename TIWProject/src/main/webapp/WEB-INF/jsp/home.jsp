
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="it.polimi.model.Utente" %>
<%
    Utente utente = (Utente) request.getAttribute("utente");
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - Aste Online Jakarta</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="header">
    <h1>🎯 Aste Online Jakarta</h1>
    <div class="nav-links">
        <a href="home">🏠 Home</a>
        <a href="vendo">📦 Vendo</a>
        <a href="acquisto">🛒 Acquisto</a>
        <a href="login.html">🚪 Logout</a>
    </div>
</div>

<div class="container">
    <div class="user-info">
        Benvenuto, <%= utente.getNomeCompleto() %> (<%= utente.getUsername() %>)
    </div>

    <div class="form-container">
        <h2>🚀 Jakarta EE - Cosa vuoi fare?</h2>
        <p>Applicazione moderna con Jakarta EE 9+ e Tomcat 10</p>

        <div style="background: linear-gradient(135deg, #e8f5e8 0%, #d4edda 100%); padding: 20px; border-radius: 10px; margin-bottom: 30px;">
            <h4>✅ Tecnologie utilizzate:</h4>
            <ul style="margin-left: 20px;">
                <li><strong>Jakarta Servlet 5.0</strong> - API moderne</li>
                <li><strong>Jakarta JSP 3.1</strong> - Template engine</li>
                <li><strong>Tomcat 10+</strong> - Application server</li>
                <li><strong>MySQL 8+</strong> - Database</li>
                <li><strong>Maven</strong> - Build automation</li>
            </ul>
        </div>

        <div style="text-align: center; margin-top: 30px;">
            <a href="vendo" class="btn" style="margin: 10px 20px; display: inline-block; text-decoration: none; font-size: 18px; padding: 15px 30px;">
                📦 VENDO
            </a>
            <a href="acquisto" class="btn btn-success" style="margin: 10px 20px; display: inline-block; text-decoration: none; font-size: 18px; padding: 15px 30px;">
                🛒 ACQUISTO
            </a>
        </div>

        <div style="margin-top: 40px; padding: 20px; background: rgba(255,255,255,0.8); border-radius: 10px;">
            <h3>📋 Informazioni Account</h3>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px;">
                <div>
                    <strong>👤 Nome:</strong><br>
                    <%= utente.getNomeCompleto() %>
                </div>
                <div>
                    <strong>🔑 Username:</strong><br>
                    <%= utente.getUsername() %>
                </div>
                <div>
                    <strong>📍 Indirizzo:</strong><br>
                    <%= utente.getIndirizzo() %>
                </div>
            </div>
        </div>
    </div>
</div>

<div style="text-align: center; padding: 20px; margin-top: 40px; color: rgba(255,255,255,0.8);">
    <p>© 2025 Aste Online - Politecnico di Milano</p>
    <p><small>🚀 Powered by Jakarta EE 9+ & Modern Web Technologies</small></p>
</div>
</body>
</html>