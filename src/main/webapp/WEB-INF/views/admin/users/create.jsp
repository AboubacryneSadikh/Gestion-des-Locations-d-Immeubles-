<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Créer un utilisateur" scope="request"/>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle}</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        .sidebar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            width: 250px;
            z-index: 1000;
        }

        .sidebar .nav-link {
            color: rgba(255, 255, 255, 0.8);
            padding: 12px 20px;
            margin: 2px 0;
            border-radius: 0 25px 25px 0;
            transition: all 0.3s;
        }

        .sidebar .nav-link:hover,
        .sidebar .nav-link.active {
            color: white;
            background: rgba(255, 255, 255, 0.1);
            transform: translateX(5px);
        }

        .main-content {
            margin-left: 250px;
            padding: 20px;
            background-color: #f8f9fa;
            min-height: 100vh;
        }

        .content-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            border: none;
            max-width: 800px;
            margin: 0 auto;
        }

        .user-info {
            color: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 20px;
        }

        .form-floating .form-control:focus,
        .form-floating .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            font-weight: 600;
            padding: 12px 30px;
            border-radius: 25px;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #5a6fd8 0%, #6a4190 100%);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }

        .password-requirements {
            font-size: 0.875rem;
            color: #6c757d;
            margin-top: 0.5rem;
        }

        .password-requirements ul {
            margin: 0.5rem 0 0 0;
            padding-left: 1.5rem;
        }

        .password-requirements li {
            margin-bottom: 0.25rem;
        }

        .role-description {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            margin-top: 10px;
            font-size: 0.9rem;
            color: #6c757d;
            display: none;
        }

        .breadcrumb {
            background: transparent;
            padding: 0;
            margin-bottom: 20px;
        }

        .breadcrumb-item a {
            color: #667eea;
            text-decoration: none;
        }

        .breadcrumb-item a:hover {
            text-decoration: underline;
        }

        .form-section {
            margin-bottom: 2rem;
            padding-bottom: 2rem;
            border-bottom: 1px solid #e9ecef;
        }

        .form-section:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }

        .section-title {
            color: #495057;
            font-weight: 600;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
        }

        .section-title i {
            margin-right: 10px;
            color: #667eea;
        }
    </style>
</head>
<body>
<!-- Sidebar -->
<nav class="sidebar">
    <div class="user-info">
        <div class="d-flex align-items-center">
            <i class="fas fa-user-shield fa-2x me-3"></i>
            <div>
                <h6 class="mb-0">${sessionScope.userName}</h6>
                <small class="opacity-75">Administrateur</small>
            </div>
        </div>
    </div>

    <ul class="nav flex-column">
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="fas fa-tachometer-alt me-2"></i>Tableau de bord
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link active" href="${pageContext.request.contextPath}/admin/users">
                <i class="fas fa-users me-2"></i>Gestion des utilisateurs
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/admin/reports">
                <i class="fas fa-chart-bar me-2"></i>Rapports
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/admin/settings">
                <i class="fas fa-cog me-2"></i>Paramètres
            </a>
        </li>
        <li class="nav-item mt-auto">
            <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                <i class="fas fa-sign-out-alt me-2"></i>Déconnexion
            </a>
        </li>
    </ul>
</nav>

<!-- Main Content -->
<div class="main-content">
    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/admin/dashboard">
                    <i class="fas fa-home me-1"></i>Accueil
                </a>
            </li>
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/admin/users">Utilisateurs</a>
            </li>
            <li class="breadcrumb-item active" aria-current="page">Créer un utilisateur</li>
        </ol>
    </nav>

    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="mb-0">Créer un nouvel utilisateur</h2>
            <p class="text-muted mb-0">Ajouter un nouveau compte à la plateforme</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary">
            <i class="fas fa-arrow-left me-2"></i>Retour à la liste
        </a>
    </div>

    <!-- Formulaire -->
    <div class="content-card">
        <!-- Messages d'alerte -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>
                    ${error}
            </div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/admin/users/create" id="createUserForm" novalidate>
            <!-- Informations personnelles -->
            <div class="form-section">
                <h5 class="section-title">
                    <i class="fas fa-user"></i>
                    Informations personnelles
                </h5>

                <div class="row">
                    <div class="col-md-6">
                        <div class="form-floating mb-3">
                            <input type="text" class="form-control" id="nom" name="nom"
                                   placeholder="Nom" required value="${nom}">
                            <label for="nom">Nom *</label>
                            <div class="invalid-feedback">
                                Veuillez saisir le nom.
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-floating mb-3">
                            <input type="text" class="form-control" id="prenom" name="prenom"
                                   placeholder="Prénom" required value="${prenom}">
                            <label for="prenom">Prénom *</label>
                            <div class="invalid-feedback">
                                Veuillez saisir le prénom.
                            </div>
                        </div>
                    </div>
                </div>

                <div class="form-floating mb-3">
                    <input type="email" class="form-control" id="email" name="email"
                           placeholder="Email" required value="${email}">
                    <label for="email">Adresse email *</label>
                    <div class="invalid-feedback">
                        Veuillez saisir une adresse email valide.
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="form-floating mb-3">
                            <input type="tel" class="form-control" id="telephone" name="telephone"
                                   placeholder="Téléphone" value="${telephone}">
                            <label for="telephone">Téléphone</label>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-floating mb-3">
                            <select class="form-select" id="role" name="role" required>
                                <option value="">Sélectionnez un rôle</option>
                                <option value="ADMIN" ${role == 'ADMIN' ? 'selected' : ''}>Administrateur</option>
                                <option value="PROPRIETAIRE" ${role == 'PROPRIETAIRE' ? 'selected' : ''}>Propriétaire</option>
                                <option value="LOCATAIRE" ${role == 'LOCATAIRE' ? 'selected' : ''}>Locataire</option>
                            </select>
                            <label for="role">Rôle *</label>
                            <div class="invalid-feedback">
                                Veuillez sélectionner un rôle.
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Descriptions des rôles -->
                <div id="adminDescription" class="role-description">
                    <strong>Administrateur :</strong> Accès complet à toutes les fonctionnalités de la plateforme.
                    Peut gérer tous les utilisateurs, immeubles, contrats et paramètres système.
                </div>
                <div id="proprietaireDescription" class="role-description">
                    <strong>Propriétaire :</strong> Peut gérer ses propres immeubles et unités de location,
                    consulter les contrats et suivre les paiements de ses locataires.
                </div>
                <div id="locataireDescription" class="role-description">
                    <strong>Locataire :</strong> Peut rechercher des logements, consulter ses contrats
                    et gérer ses paiements de loyer.
                </div>

                <div class="form-floating mb-3">
                        <textarea class="form-control" id="adresse" name="adresse"
                                  placeholder="Adresse complète" style="height: 100px">${adresse}</textarea>
                    <label for="adresse">Adresse</label>
                </div>
            </div>

            <!-- Sécurité -->
            <div class="form-section">
                <h5 class="section-title">
                    <i class="fas fa-lock"></i>
                    Sécurité du compte
                </h5>

                <div class="row">
                    <div class="col-md-6">
                        <div class="form-floating mb-3">
                            <input type="password" class="form-control" id="motDePasse" name="motDePasse"
                                   placeholder="Mot de passe" required minlength="6">
                            <label for="motDePasse">Mot de passe *</label>
                            <div class="invalid-feedback">
                                Le mot de passe doit contenir au moins 6 caractères.
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-floating mb-3">
                            <input type="password" class="form-control" id="confirmMotDePasse"
                                   name="confirmMotDePasse" placeholder="Confirmer" required minlength="6">
                            <label for="confirmMotDePasse">Confirmer le mot de passe *</label>
                            <div class="invalid-feedback">
                                Les mots de passe ne correspondent pas.
                            </div>
                        </div>
                    </div>
                </div>

                <div class="password-requirements">
                    <i class="fas fa-info-circle me-2"></i>Exigences du mot de passe :
                    <ul>
                        <li>Au moins 6 caractères</li>
                        <li>Recommandé : mélange de lettres, chiffres et caractères spéciaux</li>
                        <li>Évitez les mots de passe trop simples</li>
                    </ul>
                </div>
            </div>

            <!-- Options du compte -->
            <div class="form-section">
                <h5 class="section-title">
                    <i class="fas fa-cog"></i>
                    Options du compte
                </h5>

                <div class="form-check mb-3">
                    <input class="form-check-input" type="checkbox" id="actif" name="actif" checked>
                    <label class="form-check-label" for="actif">
                        <strong>Compte actif</strong>
                        <br><small class="text-muted">L'utilisateur pourra se connecter immédiatement</small>
                    </label>
                </div>

                <div class="form-check mb-3">
                    <input class="form-check-input" type="checkbox" id="notifierUtilisateur" name="notifierUtilisateur" checked>
                    <label class="form-check-label" for="notifierUtilisateur">
                        <strong>Notifier l'utilisateur par email</strong>
                        <br><small class="text-muted">Envoyer les informations de connexion à l'utilisateur</small>
                    </label>
                </div>
            </div>

            <!-- Boutons d'action -->
            <div class="d-flex justify-content-end gap-3">
                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary">
                    <i class="fas fa-times me-2"></i>Annuler
                </a>
                <button type="submit" class="btn btn-primary" id="submitBtn">
                    <i class="fas fa-user-plus me-2"></i>Créer l'utilisateur
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('createUserForm');
        const roleSelect = document.getElementById('role');
        const motDePasseInput = document.getElementById('motDePasse');
        const confirmMotDePasseInput = document.getElementById('confirmMotDePasse');
        const submitBtn = document.getElementById('submitBtn');

        // Gestion des descriptions de rôles
        roleSelect.addEventListener('change', function() {
            // Cacher toutes les descriptions
            document.querySelectorAll('.role-description').forEach(desc => {
                desc.style.display = 'none';
            });

            // Afficher la description correspondante
            const selectedRole = this.value;
            if (selectedRole) {
                const description = document.getElementById(selectedRole.toLowerCase() + 'Description');
                if (description) {
                    description.style.display = 'block';
                }
            }
        });

        // Déclencher l'événement change au chargement si un rôle est déjà sélectionné
        if (roleSelect.value) {
            roleSelect.dispatchEvent(new Event('change'));
        }

        // Validation des mots de passe
        function validatePasswords() {
            const password = motDePasseInput.value;
            const confirmPassword = confirmMotDePasseInput.value;

            if (confirmPassword && password !== confirmPassword) {
                confirmMotDePasseInput.setCustomValidity('Les mots de passe ne correspondent pas');
                return false;
            } else {
                confirmMotDePasseInput.setCustomValidity('');
                return true;
            }
        }

        motDePasseInput.addEventListener('input', validatePasswords);
        confirmMotDePasseInput.addEventListener('input', validatePasswords);

        // Validation du formulaire
        form.addEventListener('submit', function(event) {
            event.preventDefault();
            event.stopPropagation();

            let isValid = true;

            // Validation des mots de passe
            if (!validatePasswords()) {
                isValid = false;
            }

            // Validation des champs requis
            const requiredFields = form.querySelectorAll('[required]');
            requiredFields.forEach(field => {
                if (!field.value.trim()) {
                    field.setCustomValidity('Ce champ est requis');
                    isValid = false;
                } else if (field.type === 'email' && !isValidEmail(field.value)) {
                    field.setCustomValidity('Veuillez saisir une adresse email valide');
                    isValid = false;
                } else {
                    field.setCustomValidity('');
                }
            });

            form.classList.add('was-validated');

            if (isValid && form.checkValidity()) {
                // Changer le texte du bouton pendant l'envoi
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Création en cours...';
                submitBtn.disabled = true;

                // Soumettre le formulaire
                form.submit();
            }
        });

        // Fonction de validation email
        function isValidEmail(email) {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return emailRegex.test(email);
        }

        // Validation en temps réel
        const inputs = form.querySelectorAll('input, select, textarea');
        inputs.forEach(input => {
            input.addEventListener('blur', function() {
                if (form.classList.contains('was-validated')) {
                    this.checkValidity();
                }
            });

            input.addEventListener('input', function() {
                if (this.classList.contains('is-invalid') || this.classList.contains('is-valid')) {
                    this.checkValidity();
                    if (this.checkValidity()) {
                        this.classList.remove('is-invalid');
                        this.classList.add('is-valid');
                    } else {
                        this.classList.remove('is-valid');
                        this.classList.add('is-invalid');
                    }
                }
            });
        });

        // Focus automatique sur le premier champ
        document.getElementById('nom').focus();
    });
</script>
</body>
</html>