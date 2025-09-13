<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Modifier utilisateur" scope="request"/>

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

        .user-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 2rem;
            margin: 0 auto;
        }

        .user-header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #e9ecef;
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

        .info-badge {
            background: #e3f2fd;
            color: #1976d2;
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 0.85rem;
            display: inline-flex;
            align-items: center;
            margin-bottom: 20px;
        }

        .account-status {
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .account-status.active {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .account-status.inactive {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .danger-zone {
            background: #fff5f5;
            border: 2px dashed #fed7d7;
            border-radius: 10px;
            padding: 20px;
            margin-top: 30px;
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
            <li class="breadcrumb-item active" aria-current="page">Modifier utilisateur</li>
        </ol>
    </nav>

    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="mb-0">Modifier l'utilisateur</h2>
            <p class="text-muted mb-0">Mettre à jour les informations du compte</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary">
            <i class="fas fa-arrow-left me-2"></i>Retour à la liste
        </a>
    </div>

    <!-- Formulaire -->
    <div class="content-card">
        <c:if test="${not empty user}">
            <!-- En-tête utilisateur -->
            <div class="user-header">
                <div class="user-avatar mb-3"
                     style="background: ${user.role == 'ADMIN' ? 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)' :
                             user.role == 'PROPRIETAIRE' ? 'linear-gradient(135deg, #28a745 0%, #20c997 100%)' :
                                     'linear-gradient(135deg, #ffc107 0%, #fd7e14 100%)'};">
                        ${user.prenom.substring(0,1).toUpperCase()}${user.nom.substring(0,1).toUpperCase()}
                </div>
                <h4 class="mb-2">${user.prenom} ${user.nom}</h4>
                <div class="info-badge">
                    <i class="fas fa-info-circle me-2"></i>
                    Membre depuis le <fmt:formatDate value="${user.dateCreation}" pattern="dd/MM/yyyy"/>
                </div>

                <!-- Statut du compte -->
                <div class="account-status ${user.actif ? 'active' : 'inactive'}">
                    <i class="fas ${user.actif ? 'fa-check-circle' : 'fa-times-circle'} me-2"></i>
                    <strong>Compte ${user.actif ? 'actif' : 'inactif'}</strong>
                    - ${user.actif ? 'L\'utilisateur peut se connecter normalement' : 'L\'utilisateur ne peut pas se connecter'}
                </div>
            </div>

            <!-- Messages d'alerte -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                        ${error}
                </div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/admin/users/edit" id="editUserForm" novalidate>
                <input type="hidden" name="id" value="${user.id}">

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
                                       placeholder="Nom" required value="${user.nom}">
                                <label for="nom">Nom *</label>
                                <div class="invalid-feedback">
                                    Veuillez saisir le nom.
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-floating mb-3">
                                <input type="text" class="form-control" id="prenom" name="prenom"
                                       placeholder="Prénom" required value="${user.prenom}">
                                <label for="prenom">Prénom *</label>
                                <div class="invalid-feedback">
                                    Veuillez saisir le prénom.
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="form-floating mb-3">
                        <input type="email" class="form-control" id="email" name="email"
                               placeholder="Email" required value="${user.email}">
                        <label for="email">Adresse email *</label>
                        <div class="invalid-feedback">
                            Veuillez saisir une adresse email valide.
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-floating mb-3">
                                <input type="tel" class="form-control" id="telephone" name="telephone"
                                       placeholder="Téléphone" value="${user.telephone}">
                                <label for="telephone">Téléphone</label>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-floating mb-3">
                                <select class="form-select" id="role" name="role" required>
                                    <option value="">Sélectionnez un rôle</option>
                                    <option value="ADMIN" ${user.role == 'ADMIN' ? 'selected' : ''}>Administrateur</option>
                                    <option value="PROPRIETAIRE" ${user.role == 'PROPRIETAIRE' ? 'selected' : ''}>Propriétaire</option>
                                    <option value="LOCATAIRE" ${user.role == 'LOCATAIRE' ? 'selected' : ''}>Locataire</option>
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
                                  placeholder="Adresse complète" style="height: 100px">${user.adresse}</textarea>
                        <label for="adresse">Adresse</label>
                    </div>
                </div>

                <!-- Statut et sécurité -->
                <div class="form-section">
                    <h5 class="section-title">
                        <i class="fas fa-shield-alt"></i>
                        Statut du compte
                    </h5>

                    <div class="form-check form-switch mb-3">
                        <input class="form-check-input" type="checkbox" id="actif" name="actif"
                            ${user.actif ? 'checked' : ''}>
                        <label class="form-check-label" for="actif">
                            <strong>Compte actif</strong>
                            <br><small class="text-muted">L'utilisateur peut se connecter à la plateforme</small>
                        </label>
                    </div>

                    <div class="alert alert-info">
                        <i class="fas fa-info-circle me-2"></i>
                        <strong>Note :</strong> Pour changer le mot de passe, l'utilisateur doit utiliser
                        la fonction "Mot de passe oublié" ou vous pouvez le réinitialiser depuis les actions avancées.
                    </div>
                </div>

                <!-- Boutons d'action -->
                <div class="d-flex justify-content-end gap-3">
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary">
                        <i class="fas fa-times me-2"></i>Annuler
                    </a>
                    <button type="submit" class="btn btn-primary" id="submitBtn">
                        <i class="fas fa-save me-2"></i>Enregistrer les modifications
                    </button>
                </div>
            </form>

            <!-- Zone de danger -->
            <c:if test="${user.id != sessionScope.utilisateur.id}">
                <div class="danger-zone">
                    <h6 class="text-danger mb-3">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        Zone de danger
                    </h6>
                    <p class="text-muted mb-3">
                        Ces actions sont irréversibles et peuvent affecter l'accès de l'utilisateur à la plateforme.
                    </p>
                    <div class="d-flex gap-2 flex-wrap">
                        <button type="button" class="btn btn-outline-warning btn-sm"
                                onclick="toggleUserStatus(${user.id}, ${user.actif})">
                            <i class="fas ${user.actif ? 'fa-user-slash' : 'fa-user-check'} me-1"></i>
                                ${user.actif ? 'Désactiver' : 'Activer'} le compte
                        </button>
                        <button type="button" class="btn btn-outline-info btn-sm" onclick="resetPassword(${user.id})">
                            <i class="fas fa-key me-1"></i>Réinitialiser mot de passe
                        </button>
                        <button type="button" class="btn btn-outline-danger btn-sm"
                                onclick="deleteUser(${user.id}, '${user.prenom} ${user.nom}')">
                            <i class="fas fa-trash me-1"></i>Supprimer définitivement
                        </button>
                    </div>
                </div>
            </c:if>
        </c:if>
    </div>
</div>

<!-- Modales de confirmation -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title">
                    <i class="fas fa-exclamation-triangle me-2"></i>Confirmer la suppression
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>Êtes-vous sûr de vouloir supprimer l'utilisateur <strong id="deleteUserName"></strong> ?</p>
                <div class="alert alert-warning">
                    <i class="fas fa-info-circle me-2"></i>
                    Cette action désactivera définitivement le compte utilisateur.
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                <form method="post" action="${pageContext.request.contextPath}/admin/users/delete" style="display: inline;">
                    <input type="hidden" name="id" id="deleteUserId">
                    <button type="submit" class="btn btn-danger">
                        <i class="fas fa-trash me-2"></i>Supprimer
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="toggleStatusModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="toggleStatusTitle"></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="toggleStatusMessage"></div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                <form method="post" action="${pageContext.request.contextPath}/admin/users/toggle-status" style="display: inline;">
                    <input type="hidden" name="id" id="toggleUserId">
                    <button type="submit" class="btn btn-primary" id="toggleStatusBtn">Confirmer</button>
                </form>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="resetPasswordModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-info text-white">
                <h5 class="modal-title">
                    <i class="fas fa-key me-2"></i>Réinitialiser le mot de passe
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>Voulez-vous réinitialiser le mot de passe de cet utilisateur ?</p>
                <div class="alert alert-info">
                    <i class="fas fa-info-circle me-2"></i>
                    Un nouveau mot de passe temporaire sera généré et envoyé par email à l'utilisateur.
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                <button type="button" class="btn btn-info" onclick="confirmResetPassword()">
                    <i class="fas fa-key me-2"></i>Réinitialiser
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('editUserForm');
        const roleSelect = document.getElementById('role');
        const submitBtn = document.getElementById('submitBtn');

        // Gestion des descriptions de rôles
        roleSelect.addEventListener('change', function() {
            document.querySelectorAll('.role-description').forEach(desc => {
                desc.style.display = 'none';
            });

            const selectedRole = this.value;
            if (selectedRole) {
                const description = document.getElementById(selectedRole.toLowerCase() + 'Description');
                if (description) {
                    description.style.display = 'block';
                }
            }
        });

        // Déclencher l'événement change au chargement
        if (roleSelect.value) {
            roleSelect.dispatchEvent(new Event('change'));
        }

        // Validation du formulaire
        form.addEventListener('submit', function(event) {
            event.preventDefault();
            event.stopPropagation();

            let isValid = true;

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
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Enregistrement...';
                submitBtn.disabled = true;
                form.submit();
            }
        });

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
        });
    });

    function deleteUser(userId, userName) {
        document.getElementById('deleteUserId').value = userId;
        document.getElementById('deleteUserName').textContent = userName;
        new bootstrap.Modal(document.getElementById('deleteModal')).show();
    }

    function toggleUserStatus(userId, isActive) {
        document.getElementById('toggleUserId').value = userId;

        const modal = document.getElementById('toggleStatusModal');
        const title = document.getElementById('toggleStatusTitle');
        const message = document.getElementById('toggleStatusMessage');
        const button = document.getElementById('toggleStatusBtn');

        if (isActive) {
            title.textContent = 'Désactiver l\'utilisateur';
            message.innerHTML = '<p>Voulez-vous désactiver ce compte utilisateur ?</p><div class="alert alert-warning"><i class="fas fa-info-circle me-2"></i>L\'utilisateur ne pourra plus se connecter à la plateforme.</div>';
            button.textContent = 'Désactiver';
            button.className = 'btn btn-warning';
        } else {
            title.textContent = 'Activer l\'utilisateur';
            message.innerHTML = '<p>Voulez-vous activer ce compte utilisateur ?</p><div class="alert alert-info"><i class="fas fa-info-circle me-2"></i>L\'utilisateur pourra se connecter à la plateforme.</div>';
            button.textContent = 'Activer';
            button.className = 'btn btn-success';
        }

        new bootstrap.Modal(modal).show();
    }

    function resetPassword(userId) {
        window.resetUserId = userId;
        new bootstrap.Modal(document.getElementById('resetPasswordModal')).show();
    }

    function confirmResetPassword() {
        // Simuler la réinitialisation du mot de passe
        alert('Un nouveau mot de passe temporaire a été envoyé par email à l\'utilisateur.');
        bootstrap.Modal.getInstance(document.getElementById('resetPasswordModal')).hide();
    }
</script>
</body>
</html>