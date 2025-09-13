<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Connexion" scope="request"/>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - Gestion des Immeubles</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
        }
        .login-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            padding: 2rem;
            max-width: 400px;
            width: 100%;
        }
        .login-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        .login-header i {
            font-size: 3rem;
            color: #667eea;
            margin-bottom: 1rem;
        }
        .login-header h2 {
            color: #333;
            font-weight: 600;
        }
        .form-floating .form-control {
            border: 2px solid #e9ecef;
        }
        .form-floating .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-login {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .btn-login:hover {
            background: linear-gradient(135deg, #5a6fd8 0%, #6a4190 100%);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .register-link {
            text-align: center;
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid #e9ecef;
        }
        .register-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
        }
        .register-link a:hover {
            text-decoration: underline;
        }
        .alert {
            border-radius: 10px;
            margin-bottom: 1.5rem;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-4">
            <div class="login-container">
                <div class="login-header">
                    <i class="fas fa-building"></i>
                    <h2>Connexion</h2>
                    <p class="text-muted">Accédez à votre espace de gestion</p>
                </div>

                <!-- Messages d'alerte -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                            ${error}
                    </div>
                </c:if>

                <c:if test="${not empty success}">
                    <div class="alert alert-success" role="alert">
                        <i class="fas fa-check-circle me-2"></i>
                            ${success}
                    </div>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/login" id="loginForm" novalidate>
                    <div class="form-floating mb-3">
                        <input type="email"
                               class="form-control"
                               id="email"
                               name="email"
                               placeholder="name@example.com"
                               required
                               value="${not empty param.email ? param.email : (not empty email ? email : '')}">
                        <label for="email">
                            <i class="fas fa-envelope me-2"></i>Adresse email
                        </label>
                        <div class="invalid-feedback">
                            Veuillez saisir une adresse email valide.
                        </div>
                    </div>

                    <div class="form-floating mb-4">
                        <input type="password"
                               class="form-control"
                               id="password"
                               name="password"
                               placeholder="Mot de passe"
                               required
                               minlength="1">
                        <label for="password">
                            <i class="fas fa-lock me-2"></i>Mot de passe
                        </label>
                        <div class="invalid-feedback">
                            Veuillez saisir votre mot de passe.
                        </div>
                    </div>

                    <!-- Option "Se souvenir de moi" -->
                    <div class="form-check mb-3">
                        <input class="form-check-input" type="checkbox" id="rememberMe" name="rememberMe">
                        <label class="form-check-label" for="rememberMe">
                            Se souvenir de moi
                        </label>
                    </div>

                    <div class="d-grid">
                        <button class="btn btn-primary btn-login" type="submit" id="loginButton">
                            <i class="fas fa-sign-in-alt me-2"></i>Se connecter
                        </button>
                    </div>
                </form>

                <div class="register-link">
                    <p class="mb-1">Vous n'avez pas de compte ?</p>
                    <a href="${pageContext.request.contextPath}/register">
                        <i class="fas fa-user-plus me-1"></i>Créer un compte
                    </a>
                    <br>
                    <small class="text-muted mt-2 d-block">
                        <a href="#" class="text-decoration-none">Mot de passe oublié ?</a>
                    </small>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const loginForm = document.getElementById('loginForm');
        const loginButton = document.getElementById('loginButton');
        const emailInput = document.getElementById('email');
        const passwordInput = document.getElementById('password');

        // Validation du formulaire
        loginForm.addEventListener('submit', function(event) {
            event.preventDefault();
            event.stopPropagation();

            let isValid = true;

            // Valider l'email
            if (!emailInput.value.trim()) {
                emailInput.classList.add('is-invalid');
                isValid = false;
            } else if (!isValidEmail(emailInput.value.trim())) {
                emailInput.classList.add('is-invalid');
                isValid = false;
            } else {
                emailInput.classList.remove('is-invalid');
                emailInput.classList.add('is-valid');
            }

            // Valider le mot de passe
            if (!passwordInput.value.trim()) {
                passwordInput.classList.add('is-invalid');
                isValid = false;
            } else {
                passwordInput.classList.remove('is-invalid');
                passwordInput.classList.add('is-valid');
            }

            if (isValid) {
                // Changer le texte du bouton pendant l'envoi
                loginButton.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Connexion...';
                loginButton.disabled = true;

                // Soumettre le formulaire
                this.submit();
            }

            loginForm.classList.add('was-validated');
        });

        // Retirer la validation en temps réel
        emailInput.addEventListener('input', function() {
            if (this.classList.contains('is-invalid') || this.classList.contains('is-valid')) {
                if (this.value.trim() && isValidEmail(this.value.trim())) {
                    this.classList.remove('is-invalid');
                    this.classList.add('is-valid');
                } else {
                    this.classList.remove('is-valid');
                    this.classList.add('is-invalid');
                }
            }
        });

        passwordInput.addEventListener('input', function() {
            if (this.classList.contains('is-invalid') || this.classList.contains('is-valid')) {
                if (this.value.trim()) {
                    this.classList.remove('is-invalid');
                    this.classList.add('is-valid');
                } else {
                    this.classList.remove('is-valid');
                    this.classList.add('is-invalid');
                }
            }
        });

        // Fonction de validation email
        function isValidEmail(email) {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return emailRegex.test(email);
        }

        // Focus automatique sur le champ email s'il est vide
        if (!emailInput.value.trim()) {
            emailInput.focus();
        } else {
            passwordInput.focus();
        }
    });
</script>
</body>
</html>