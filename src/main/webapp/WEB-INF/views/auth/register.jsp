<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Inscription" scope="request"/>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription - Gestion des Immeubles</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 2rem 0;
        }
        .register-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            padding: 2rem;
            max-width: 600px;
            width: 100%;
            margin: 0 auto;
        }
        .register-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        .register-header i {
            font-size: 3rem;
            color: #667eea;
            margin-bottom: 1rem;
        }
        .register-header h2 {
            color: #333;
            font-weight: 600;
        }
        .form-floating .form-control, .form-floating .form-select {
            border: 2px solid #e9ecef;
        }
        .form-floating .form-control:focus, .form-floating .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-register {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .btn-register:hover {
            background: linear-gradient(135deg, #5a6fd8 0%, #6a4190 100%);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .login-link {
            text-align: center;
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid #e9ecef;
        }
        .login-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
        }
        .login-link a:hover {
            text-decoration: underline;
        }
        .password-strength {
            font-size: 0.875rem;
            margin-top: 0.5rem;
        }
        .strength-weak { color: #dc3545; }
        .strength-medium { color: #fd7e14; }
        .strength-strong { color: #198754; }
        .alert {
            border-radius: 10px;
            margin-bottom: 1.5rem;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="register-container">
                <div class="register-header">
                    <i class="fas fa-user-plus"></i>
                    <h2>Inscription</h2>
                    <p class="text-muted">Créez votre compte pour accéder à la plateforme</p>
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

                <form method="post" action="${pageContext.request.contextPath}/register" id="registerForm" novalidate>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-floating mb-3">
                                <input type="text"
                                       class="form-control"
                                       id="nom"
                                       name="nom"
                                       placeholder="Nom"
                                       required
                                       value="${not empty param.nom ? param.nom : (not empty nom ? nom : '')}">
                                <label for="nom">
                                    <i class="fas fa-user me-2"></i>Nom *
                                </label>
                                <div class="invalid-feedback">
                                    Veuillez saisir votre nom.
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-floating mb-3">
                                <input type="text"
                                       class="form-control"
                                       id="prenom"
                                       name="prenom"
                                       placeholder="Prénom"
                                       required
                                       value="${not empty param.prenom ? param.prenom : (not empty prenom ? prenom : '')}">
                                <label for="prenom">
                                    <i class="fas fa-user me-2"></i>Prénom *
                                </label>
                                <div class="invalid-feedback">
                                    Veuillez saisir votre prénom.
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="form-floating mb-3">
                        <input type="email"
                               class="form-control"
                               id="email"
                               name="email"
                               placeholder="name@example.com"
                               required
                               value="${not empty param.email ? param.email : (not empty email ? email : '')}">
                        <label for="email">
                            <i class="fas fa-envelope me-2"></i>Adresse email *
                        </label>
                        <div class="invalid-feedback">
                            Veuillez saisir une adresse email valide.
                        </div>
                    </div>

                    <div class="form-floating mb-3">
                        <input type="tel"
                               class="form-control"
                               id="telephone"
                               name="telephone"
                               placeholder="Téléphone"
                               value="${not empty param.telephone ? param.telephone : (not empty telephone ? telephone : '')}">
                        <label for="telephone">
                            <i class="fas fa-phone me-2"></i>Téléphone
                        </label>
                    </div>

                    <div class="form-floating mb-3">
                        <input type="text"
                               class="form-control"
                               id="adresse"
                               name="adresse"
                               placeholder="Adresse"
                               value="${not empty param.adresse ? param.adresse : (not empty adresse ? adresse : '')}">
                        <label for="adresse">
                            <i class="fas fa-map-marker-alt me-2"></i>Adresse
                        </label>
                    </div>

                    <div class="form-floating mb-3">
                        <select class="form-select" id="role" name="role" required>
                            <option value="">Choisissez votre rôle</option>
                            <option value="LOCATAIRE"
                            ${(not empty param.role && param.role == 'LOCATAIRE') ||
                                    (not empty role && role == 'LOCATAIRE') ? 'selected' : ''}>
                                Locataire
                            </option>
                            <option value="PROPRIETAIRE"
                            ${(not empty param.role && param.role == 'PROPRIETAIRE') ||
                                    (not empty role && role == 'PROPRIETAIRE') ? 'selected' : ''}>
                                Propriétaire
                            </option>
                        </select>
                        <label for="role">
                            <i class="fas fa-user-tag me-2"></i>Rôle *
                        </label>
                        <div class="invalid-feedback">
                            Veuillez sélectionner votre rôle.
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-floating mb-3">
                                <input type="password"
                                       class="form-control"
                                       id="password"
                                       name="password"
                                       placeholder="Mot de passe"
                                       required
                                       minlength="6">
                                <label for="password">
                                    <i class="fas fa-lock me-2"></i>Mot de passe *
                                </label>
                                <div id="passwordStrength" class="password-strength"></div>
                                <div class="invalid-feedback">
                                    Le mot de passe doit contenir au moins 6 caractères.
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-floating mb-3">
                                <input type="password"
                                       class="form-control"
                                       id="confirmPassword"
                                       name="confirmPassword"
                                       placeholder="Confirmer mot de passe"
                                       required
                                       minlength="6">
                                <label for="confirmPassword">
                                    <i class="fas fa-lock me-2"></i>Confirmer *
                                </label>
                                <div id="passwordMatch" class="password-strength"></div>
                                <div class="invalid-feedback">
                                    Veuillez confirmer votre mot de passe.
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="acceptTerms" required>
                            <label class="form-check-label" for="acceptTerms">
                                J'accepte les <a href="#" data-bs-toggle="modal" data-bs-target="#termsModal">conditions d'utilisation</a> *
                            </label>
                            <div class="invalid-feedback">
                                Vous devez accepter les conditions d'utilisation.
                            </div>
                        </div>
                    </div>

                    <div class="d-grid">
                        <button class="btn btn-primary btn-register" type="submit" id="registerButton">
                            <i class="fas fa-user-plus me-2"></i>Créer mon compte
                        </button>
                    </div>
                </form>

                <div class="login-link">
                    <p class="mb-0">Vous avez déjà un compte ?</p>
                    <a href="${pageContext.request.contextPath}/login">
                        <i class="fas fa-sign-in-alt me-1"></i>Se connecter
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal des conditions d'utilisation -->
<div class="modal fade" id="termsModal" tabindex="-1" aria-labelledby="termsModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="termsModalLabel">Conditions d'utilisation</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>En créant un compte sur cette plateforme, vous acceptez de :</p>
                <ul>
                    <li>Fournir des informations exactes et à jour</li>
                    <li>Maintenir la confidentialité de votre mot de passe</li>
                    <li>Utiliser la plateforme de manière responsable</li>
                    <li>Respecter les droits des autres utilisateurs</li>
                    <li>Ne pas utiliser la plateforme à des fins illégales</li>
                </ul>
                <p>Nous nous engageons à protéger vos données personnelles conformément à notre politique de confidentialité.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const passwordInput = document.getElementById('password');
        const confirmPasswordInput = document.getElementById('confirmPassword');
        const passwordStrength = document.getElementById('passwordStrength');
        const passwordMatch = document.getElementById('passwordMatch');
        const form = document.getElementById('registerForm');
        const registerButton = document.getElementById('registerButton');

        // Vérification de la force du mot de passe
        passwordInput.addEventListener('input', function() {
            const password = this.value;
            let strength = '';
            let className = '';

            if (password.length === 0) {
                strength = '';
                className = '';
            } else if (password.length < 6) {
                strength = 'Trop court (minimum 6 caractères)';
                className = 'strength-weak';
            } else if (password.length < 8) {
                strength = 'Faible';
                className = 'strength-weak';
            } else if (password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/)) {
                strength = 'Fort';
                className = 'strength-strong';
            } else {
                strength = 'Moyen';
                className = 'strength-medium';
            }

            passwordStrength.textContent = strength;
            passwordStrength.className = 'password-strength ' + className;

            // Vérifier aussi la correspondance si confirmPassword a une valeur
            if (confirmPasswordInput.value) {
                checkPasswordMatch();
            }
        });

        // Vérification de la correspondance des mots de passe
        function checkPasswordMatch() {
            const password = passwordInput.value;
            const confirmPassword = confirmPasswordInput.value;

            if (confirmPassword === '') {
                passwordMatch.textContent = '';
                passwordMatch.className = 'password-strength';
            } else if (password === confirmPassword) {
                passwordMatch.textContent = 'Les mots de passe correspondent';
                passwordMatch.className = 'password-strength strength-strong';
            } else {
                passwordMatch.textContent = 'Les mots de passe ne correspondent pas';
                passwordMatch.className = 'password-strength strength-weak';
            }
        }

        confirmPasswordInput.addEventListener('input', checkPasswordMatch);

        // Validation du formulaire avec Bootstrap
        form.addEventListener('submit', function(event) {
            event.preventDefault();
            event.stopPropagation();

            let isValid = true;

            // Validation personnalisée des mots de passe
            const password = passwordInput.value;
            const confirmPassword = confirmPasswordInput.value;

            if (password !== confirmPassword) {
                confirmPasswordInput.setCustomValidity('Les mots de passe ne correspondent pas');
                isValid = false;
            } else {
                confirmPasswordInput.setCustomValidity('');
            }

            if (password.length < 6) {
                passwordInput.setCustomValidity('Le mot de passe doit contenir au moins 6 caractères');
                isValid = false;
            } else {
                passwordInput.setCustomValidity('');
            }

            // Vérifier la validité native du formulaire
            if (!form.checkValidity()) {
                isValid = false;
            }

            form.classList.add('was-validated');

            if (isValid) {
                // Changer le texte du bouton pendant l'envoi
                registerButton.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Création...';
                registerButton.disabled = true;

                // Soumettre le formulaire
                form.submit();
            }
        });

        // Validation en temps réel pour une meilleure UX
        const inputs = form.querySelectorAll('input, select');
        inputs.forEach(input => {
            input.addEventListener('blur', function() {
                if (form.classList.contains('was-validated')) {
                    this.checkValidity();
                }
            });
        });
    });
</script>
</body>
</html>