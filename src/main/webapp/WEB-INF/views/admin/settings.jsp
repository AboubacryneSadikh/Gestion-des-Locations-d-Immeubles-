<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Paramètres - Administration" scope="request"/>

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
            transition: all 0.3s;
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

        .settings-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            border: none;
            margin-bottom: 20px;
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .settings-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        }

        .settings-icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            color: white;
            margin-bottom: 15px;
        }

        .user-info {
            color: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 20px;
        }

        .form-control:focus,
        .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }

        .btn-save {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 25px;
            padding: 10px 30px;
            color: white;
            font-weight: 500;
            transition: all 0.3s;
        }

        .btn-save:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
            color: white;
        }

        .toggle-switch {
            position: relative;
            display: inline-block;
            width: 60px;
            height: 34px;
        }

        .toggle-switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }

        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            transition: .4s;
            border-radius: 34px;
        }

        .slider:before {
            position: absolute;
            content: "";
            height: 26px;
            width: 26px;
            left: 4px;
            bottom: 4px;
            background-color: white;
            transition: .4s;
            border-radius: 50%;
        }

        input:checked + .slider {
            background-color: #667eea;
        }

        input:checked + .slider:before {
            transform: translateX(26px);
        }

        .settings-section {
            border-left: 4px solid #667eea;
            padding-left: 20px;
            margin-bottom: 30px;
        }

        .danger-zone {
            border: 2px solid #dc3545;
            border-radius: 10px;
            padding: 20px;
            background-color: #fff5f5;
        }

        .log-entry {
            padding: 10px 15px;
            border-left: 3px solid #667eea;
            background-color: #f8f9fa;
            margin-bottom: 10px;
            border-radius: 0 5px 5px 0;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }

        .stat-item {
            background: white;
            padding: 15px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .stat-value {
            font-size: 1.5rem;
            font-weight: 700;
            color: #2c3e50;
        }

        .stat-label {
            color: #6c757d;
            font-size: 0.9rem;
        }

        .backup-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            margin-bottom: 10px;
        }

        .backup-item:hover {
            background-color: #f8f9fa;
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
            <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
                <i class="fas fa-users me-2"></i>Gestion des utilisateurs
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/admin/reports">
                <i class="fas fa-chart-bar me-2"></i>Rapports
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link active" href="${pageContext.request.contextPath}/admin/settings">
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
    <!-- Top Bar -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0">Paramètres du système</h2>
        <div class="text-muted">
            <i class="fas fa-calendar-alt me-2"></i>
            <fmt:formatDate value="<%=new java.util.Date()%>" pattern="dd/MM/yyyy HH:mm"/>
        </div>
    </div>

    <!-- Messages d'alerte -->
    <c:if test="${not empty sessionScope.error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-triangle me-2"></i>
                ${sessionScope.error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="error" scope="session"/>
    </c:if>

    <c:if test="${not empty sessionScope.success}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle me-2"></i>
                ${sessionScope.success}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="success" scope="session"/>
    </c:if>

    <!-- Statistiques du système -->
    <div class="settings-card">
        <h5 class="mb-3">
            <i class="fas fa-info-circle me-2 text-primary"></i>
            État du système
        </h5>
        <div class="stats-grid">
            <div class="stat-item">
                <div class="stat-value text-success">En ligne</div>
                <div class="stat-label">Statut du serveur</div>
            </div>
            <div class="stat-item">
                <div class="stat-value">2.1 GB</div>
                <div class="stat-label">Utilisation mémoire</div>
            </div>
            <div class="stat-item">
                <div class="stat-value">45.2 GB</div>
                <div class="stat-label">Espace disque utilisé</div>
            </div>
            <div class="stat-item">
                <div class="stat-value">99.8%</div>
                <div class="stat-label">Disponibilité</div>
            </div>
        </div>
    </div>

    <div class="row">
        <!-- Configuration générale -->
        <div class="col-md-6">
            <div class="settings-card">
                <div class="settings-section">
                    <h5 class="mb-3">
                        <i class="fas fa-cogs me-2 text-primary"></i>
                        Configuration générale
                    </h5>
                    <form id="generalSettingsForm">
                        <div class="mb-3">
                            <label class="form-label">Nom de l'application</label>
                            <input type="text" class="form-control" value="GesLocation Pro" id="appName">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">URL de base</label>
                            <input type="text" class="form-control" value="https://geslocation.com" id="baseUrl">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Fuseau horaire</label>
                            <select class="form-select" id="timezone">
                                <option value="Europe/Paris" selected>Europe/Paris (GMT+1)</option>
                                <option value="UTC">UTC (GMT+0)</option>
                                <option value="America/New_York">America/New_York (GMT-5)</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Langue par défaut</label>
                            <select class="form-select" id="defaultLanguage">
                                <option value="fr" selected>Français</option>
                                <option value="en">English</option>
                                <option value="es">Español</option>
                            </select>
                        </div>
                        <button type="button" class="btn btn-save" onclick="saveGeneralSettings()">
                            <i class="fas fa-save me-2"></i>Sauvegarder
                        </button>
                    </form>
                </div>
            </div>

            <!-- Configuration des notifications -->
            <div class="settings-card">
                <div class="settings-section">
                    <h5 class="mb-3">
                        <i class="fas fa-bell me-2 text-warning"></i>
                        Notifications
                    </h5>
                    <div class="mb-3 d-flex justify-content-between align-items-center">
                        <div>
                            <strong>Notifications par email</strong>
                            <p class="text-muted mb-0">Envoyer des notifications par email aux administrateurs</p>
                        </div>
                        <label class="toggle-switch">
                            <input type="checkbox" checked id="emailNotifications">
                            <span class="slider"></span>
                        </label>
                    </div>
                    <div class="mb-3 d-flex justify-content-between align-items-center">
                        <div>
                            <strong>Notifications de sécurité</strong>
                            <p class="text-muted mb-0">Alertes pour les connexions suspectes</p>
                        </div>
                        <label class="toggle-switch">
                            <input type="checkbox" checked id="securityNotifications">
                            <span class="slider"></span>
                        </label>
                    </div>
                    <div class="mb-3 d-flex justify-content-between align-items-center">
                        <div>
                            <strong>Notifications de maintenance</strong>
                            <p class="text-muted mb-0">Alertes pour les maintenances programmées</p>
                        </div>
                        <label class="toggle-switch">
                            <input type="checkbox" id="maintenanceNotifications">
                            <span class="slider"></span>
                        </label>
                    </div>
                    <button type="button" class="btn btn-save" onclick="saveNotificationSettings()">
                        <i class="fas fa-save me-2"></i>Sauvegarder
                    </button>
                </div>
            </div>
        </div>

        <!-- Configuration de sécurité -->
        <div class="col-md-6">
            <div class="settings-card">
                <div class="settings-section">
                    <h5 class="mb-3">
                        <i class="fas fa-shield-alt me-2 text-success"></i>
                        Sécurité
                    </h5>
                    <form id="securitySettingsForm">
                        <div class="mb-3">
                            <label class="form-label">Durée de session (minutes)</label>
                            <input type="number" class="form-control" value="30" min="5" max="480" id="sessionTimeout">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Tentatives de connexion max</label>
                            <input type="number" class="form-control" value="5" min="3" max="10" id="maxLoginAttempts">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Longueur minimale mot de passe</label>
                            <input type="number" class="form-control" value="8" min="6" max="20" id="minPasswordLength">
                        </div>
                        <div class="mb-3 d-flex justify-content-between align-items-center">
                            <div>
                                <strong>Authentification à deux facteurs</strong>
                                <p class="text-muted mb-0">Obliger la 2FA pour les administrateurs</p>
                            </div>
                            <label class="toggle-switch">
                                <input type="checkbox" id="require2FA">
                                <span class="slider"></span>
                            </label>
                        </div>
                        <button type="button" class="btn btn-save" onclick="saveSecuritySettings()">
                            <i class="fas fa-save me-2"></i>Sauvegarder
                        </button>
                    </form>
                </div>
            </div>

            <!-- Configuration des sauvegardes -->
            <div class="settings-card">
                <div class="settings-section">
                    <h5 class="mb-3">
                        <i class="fas fa-database me-2 text-info"></i>
                        Sauvegardes
                    </h5>
                    <div class="mb-3 d-flex justify-content-between align-items-center">
                        <div>
                            <strong>Sauvegardes automatiques</strong>
                            <p class="text-muted mb-0">Effectuer des sauvegardes quotidiennes</p>
                        </div>
                        <label class="toggle-switch">
                            <input type="checkbox" checked id="autoBackup">
                            <span class="slider"></span>
                        </label>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Heure de sauvegarde</label>
                        <input type="time" class="form-control" value="02:00" id="backupTime">
                    </div>
                    <div class="mb-3">
                        <button type="button" class="btn btn-outline-primary me-2" onclick="createBackup()">
                            <i class="fas fa-plus me-2"></i>Créer une sauvegarde
                        </button>
                        <button type="button" class="btn btn-outline-secondary" onclick="showBackupHistory()">
                            <i class="fas fa-history me-2"></i>Historique
                        </button>
                    </div>
                    <div id="backupHistory" style="display: none;">
                        <h6>Sauvegardes récentes :</h6>
                        <div class="backup-item">
                            <div>
                                <strong>Sauvegarde_2024-01-15_02-00</strong>
                                <br><small class="text-muted">15/01/2024 à 02:00 - 45.2 MB</small>
                            </div>
                            <div>
                                <button class="btn btn-sm btn-outline-success me-1">
                                    <i class="fas fa-download"></i>
                                </button>
                                <button class="btn btn-sm btn-outline-primary">
                                    <i class="fas fa-undo"></i>
                                </button>
                            </div>
                        </div>
                        <div class="backup-item">
                            <div>
                                <strong>Sauvegarde_2024-01-14_02-00</strong>
                                <br><small class="text-muted">14/01/2024 à 02:00 - 44.8 MB</small>
                            </div>
                            <div>
                                <button class="btn btn-sm btn-outline-success me-1">
                                    <i class="fas fa-download"></i>
                                </button>
                                <button class="btn btn-sm btn-outline-primary">
                                    <i class="fas fa-undo"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Configuration des emails -->
    <div class="settings-card">
        <div class="settings-section">
            <h5 class="mb-3">
                <i class="fas fa-envelope me-2 text-primary"></i>
                Configuration SMTP
            </h5>
            <form id="emailSettingsForm">
                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label">Serveur SMTP</label>
                            <input type="text" class="form-control" placeholder="smtp.gmail.com" id="smtpHost">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label">Port</label>
                            <input type="number" class="form-control" value="587" id="smtpPort">
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label">Nom d'utilisateur</label>
                            <input type="email" class="form-control" placeholder="admin@geslocation.com" id="smtpUsername">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label">Mot de passe</label>
                            <input type="password" class="form-control" id="smtpPassword">
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-3 d-flex justify-content-between align-items-center">
                            <div>
                                <strong>Utiliser SSL/TLS</strong>
                            </div>
                            <label class="toggle-switch">
                                <input type="checkbox" checked id="smtpSSL">
                                <span class="slider"></span>
                            </label>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="mb-3">
                            <button type="button" class="btn btn-outline-info" onclick="testEmailConfig()">
                                <i class="fas fa-paper-plane me-2"></i>Tester la configuration
                            </button>
                        </div>
                    </div>
                </div>
                <button type="button" class="btn btn-save" onclick="saveEmailSettings()">
                    <i class="fas fa-save me-2"></i>Sauvegarder
                </button>
            </form>
        </div>
    </div>

    <!-- Journal d'activité -->
    <div class="settings-card">
        <h5 class="mb-3">
            <i class="fas fa-list-alt me-2 text-secondary"></i>
            Journal d'activité récent
        </h5>
        <div id="activityLog">
            <div class="log-entry">
                <div class="d-flex justify-content-between">
                    <span><i class="fas fa-user me-2"></i>Nouvel utilisateur inscrit: jean.dupont@email.com</span>
                    <small class="text-muted">Il y a 2 heures</small>
                </div>
            </div>
            <div class="log-entry">
                <div class="d-flex justify-content-between">
                    <span><i class="fas fa-cog me-2"></i>Paramètres de sécurité mis à jour</span>
                    <small class="text-muted">Il y a 4 heures</small>
                </div>
            </div>
            <div class="log-entry">
                <div class="d-flex justify-content-between">
                    <span><i class="fas fa-database me-2"></i>Sauvegarde automatique effectuée</span>
                    <small class="text-muted">Il y a 6 heures</small>
                </div>
            </div>
            <div class="log-entry">
                <div class="d-flex justify-content-between">
                    <span><i class="fas fa-shield-alt me-2"></i>Tentative de connexion suspecte bloquée</span>
                    <small class="text-muted">Il y a 8 heures</small>
                </div>
            </div>
        </div>
        <div class="text-center mt-3">
            <button class="btn btn-outline-secondary" onclick="loadMoreLogs()">
                <i class="fas fa-chevron-down me-2"></i>Charger plus
            </button>
        </div>
    </div>

    <!-- Zone dangereuse -->
    <div class="settings-card">
        <div class="danger-zone">
            <h5 class="text-danger mb-3">
                <i class="fas fa-exclamation-triangle me-2"></i>
                Zone dangereuse
            </h5>
            <p class="text-muted">
                Les actions suivantes sont irréversibles. Procédez avec prudence.
            </p>
            <div class="row">
                <div class="col-md-4">
                    <button class="btn btn-outline-warning w-100" onclick="confirmAction('clearLogs')">
                        <i class="fas fa-trash-alt me-2"></i>Vider les journaux
                    </button>
                </div>
                <div class="col-md-4">
                    <button class="btn btn-outline-danger w-100" onclick="confirmAction('resetSettings')">
                        <i class="fas fa-undo me-2"></i>Réinitialiser paramètres
                    </button>
                </div>
                <div class="col-md-4">
                    <button class="btn btn-danger w-100" onclick="confirmAction('maintenance')">
                        <i class="fas fa-tools me-2"></i>Mode maintenance
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Scripts JavaScript -->
<script>
    function saveGeneralSettings() {
        const settings = {
            appName: document.getElementById('appName').value,
            baseUrl: document.getElementById('baseUrl').value,
            timezone: document.getElementById('timezone').value,
            defaultLanguage: document.getElementById('defaultLanguage').value
        };

        // Ici vous feriez un appel AJAX pour sauvegarder les paramètres
        console.log('Sauvegarde des paramètres généraux:', settings);
        showNotification('Paramètres généraux sauvegardés avec succès!', 'success');
    }

    function saveNotificationSettings() {
        const settings = {
            emailNotifications: document.getElementById('emailNotifications').checked,
            securityNotifications: document.getElementById('securityNotifications').checked,
            maintenanceNotifications: document.getElementById('maintenanceNotifications').checked
        };

        console.log('Sauvegarde des paramètres de notification:', settings);
        showNotification('Paramètres de notification sauvegardés avec succès!', 'success');
    }

    function saveSecuritySettings() {
        const settings = {
            sessionTimeout: document.getElementById('sessionTimeout').value,
            maxLoginAttempts: document.getElementById('maxLoginAttempts').value,
            minPasswordLength: document.getElementById('minPasswordLength').value,
            require2FA: document.getElementById('require2FA').checked
        };

        console.log('Sauvegarde des paramètres de sécurité:', settings);
        showNotification('Paramètres de sécurité sauvegardés avec succès!', 'success');
    }

    function saveEmailSettings() {
        const settings = {
            smtpHost: document.getElementById('smtpHost').value,
            smtpPort: document.getElementById('smtpPort').value,
            smtpUsername: document.getElementById('smtpUsername').value,
            smtpPassword: document.getElementById('smtpPassword').value,
            smtpSSL: document.getElementById('smtpSSL').checked
        };

        console.log('Sauvegarde des paramètres email:', settings);
        showNotification('Configuration SMTP sauvegardée avec succès!', 'success');
    }

    function testEmailConfig() {
        // Simulation du test d'email
        showNotification('Test en cours...', 'info');

        setTimeout(() => {
            const success = Math.random() > 0.3; // Simulation aléatoire du résultat
            if (success) {
                showNotification('Email de test envoyé avec succès!', 'success');
            } else {
                showNotification('Échec de l\'envoi. Vérifiez la configuration.', 'danger');
            }
        }, 2000);
    }

    function createBackup() {
        showNotification('Création de la sauvegarde en cours...', 'info');

        setTimeout(() => {
            showNotification('Sauvegarde créée avec succès!', 'success');
            // Ajouter la nouvelle sauvegarde à la liste
            const backupHistory = document.getElementById('backupHistory');
            if (backupHistory.style.display !== 'none') {
                location.reload(); // Recharger pour voir la nouvelle sauvegarde
            }
        }, 3000);
    }

    function showBackupHistory() {
        const backupHistory = document.getElementById('backupHistory');
        backupHistory.style.display = backupHistory.style.display === 'none' ? 'block' : 'none';
    }

    function loadMoreLogs() {
        const activityLog = document.getElementById('activityLog');

        // Simulation de chargement de plus de logs
        const moreLogs = [
            '<div class="log-entry"><div class="d-flex justify-content-between"><span><i class="fas fa-user-edit me-2"></i>Profil utilisateur modifié: marie.martin@email.com</span><small class="text-muted">Il y a 10 heures</small></div></div>',
            '<div class="log-entry"><div class="d-flex justify-content-between"><span><i class="fas fa-building me-2"></i>Nouvel immeuble ajouté</span><small class="text-muted">Il y a 12 heures</small></div></div>'
        ];

        moreLogs.forEach(log => {
            activityLog.innerHTML += log;
        });

        showNotification('Journaux supplémentaires chargés', 'info');
    }

    function confirmAction(action) {
        let message = '';
        let confirmText = '';

        switch(action) {
            case 'clearLogs':
                message = 'Êtes-vous sûr de vouloir vider tous les journaux d\'activité ?';
                confirmText = 'Vider les journaux';
                break;
            case 'resetSettings':
                message = 'Êtes-vous sûr de vouloir réinitialiser tous les paramètres ?';
                confirmText = 'Réinitialiser';
                break;
            case 'maintenance':
                message = 'Activer le mode maintenance ? Les utilisateurs ne pourront plus accéder au système.';
                confirmText = 'Activer';
                break;
        }

        if (confirm(message)) {
            performDangerousAction(action);
        }
    }

    function performDangerousAction(action) {
        console.log('Action dangereuse:', action);

        switch(action) {
            case 'clearLogs':
                document.getElementById('activityLog').innerHTML = '<p class="text-muted text-center py-3">Journaux vidés</p>';
                showNotification('Journaux vidés avec succès', 'warning');
                break;
            case 'resetSettings':
                showNotification('Paramètres réinitialisés', 'warning');
                setTimeout(() => location.reload(), 1500);
                break;
            case 'maintenance':
                showNotification('Mode maintenance activé', 'danger');
                break;
        }
    }

    function showNotification(message, type) {
        const alertDiv = document.createElement('div');
        alertDiv.className = `alert alert-${type} alert-dismissible fade show position-fixed`;
        alertDiv.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
        alertDiv.innerHTML = `
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;
        document.body.appendChild(alertDiv);

        setTimeout(() => {
            if (alertDiv.parentNode) {
                alertDiv.parentNode.removeChild(alertDiv);
            }
        }, 5000);
    }
</script>
</body>
</html>