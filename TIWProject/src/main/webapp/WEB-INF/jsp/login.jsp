<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login - Aste Online</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: Arial, sans-serif;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .login-container {
      background: white;
      max-width: 400px;
      margin: 0 auto;
      padding: 40px;
      border-radius: 15px;
      box-shadow: 0 15px 35px rgba(0,0,0,0.1);
    }

    h2 {
      text-align: center;
      color: #333;
      margin-bottom: 30px;
      font-size: 2em;
    }

    .form-group {
      margin-bottom: 20px;
    }

    label {
      display: block;
      margin-bottom: 8px;
      font-weight: bold;
      color: #555;
    }

    input[type="text"], input[type="password"] {
      width: 100%;
      padding: 12px;
      border: 2px solid #ddd;
      border-radius: 8px;
      font-size: 16px;
      transition: border-color 0.3s ease;
    }

    input[type="text"]:focus, input[type="password"]:focus {
      outline: none;
      border-color: #667eea;
    }

    button {
      background: linear-gradient(45deg, #667eea, #764ba2);
      color: white;
      padding: 12px 20px;
      border: none;
      border-radius: 8px;
      cursor: pointer;
      width: 100%;
      font-size: 16px;
      font-weight: bold;
      transition: transform 0.2s ease;
    }

    button:hover {
      transform: translateY(-2px);
    }

    .error {
      color: #dc3545;
      margin-top: 15px;
      padding: 10px;
      background: #f8d7da;
      border: 1px solid #f5c6cb;
      border-radius: 4px;
      text-align: center;
    }

    .demo-info {
      background: #d1ecf1;
      border: 1px solid #bee5eb;
      border-radius: 8px;
      padding: 15px;
      margin-top: 20px;
      text-align: center;
    }

    .demo-info h4 {
      color: #0c5460;
      margin-bottom: 10px;
    }

    .demo-info code {
      background: #e2e3e5;
      padding: 2px 4px;
      border-radius: 3px;
      font-family: monospace;
    }
  </style>
</head>
<body>
<div class="login-container">
  <h2>🏛️ Aste Online</h2>

  <form method="post" action="login">
    <div class="form-group">
      <label for="username">Username:</label>
      <input type="text" id="username" name="username" required>
    </div>

    <div class="form-group">
      <label for="password">Password:</label>
      <input type="password" id="password" name="password" required>
    </div>

    <button type="submit">Accedi</button>
  </form>

  <% if (request.getAttribute("error") != null) { %>
  <div class="error">${error}</div>
  <% } %>

  <div class="demo-info">
    <h4>Account Demo</h4>
    <p>Username: <code>mario.rossi</code></p>
    <p>Password: <code>password123</code></p>
  </div>
</div>
</body>
</html>
