<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Mon Profil - Locataire" scope="request"/>

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

        .profile-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 40px;
            margin-bottom: 30px;
            position: relative;
            overflow: hidden;
        }

        .profile-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -20%;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
        }

        .profile-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            border: none;
            margin-bottom: 20px;
        }

        .info-item {
            display: flex;
            align-items: start;
            padding: 15px 0;
            border-bottom: 1px solid #f8f9fa;
        }

        .info-item:last-child {
            border-bottom: none;
        }

        .info-item .icon {
            width: 40px;
            text-align: center;
            margin-right: 15px;
            color: #667eea;
            margin-top: 2px;
        }

        .info-item .content {
            flex: 1;
        }

        .info-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 5px;
        }

        .info-value {
            color: #6c757d;
        }

        .user-info {
            color: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 20px;
        }

        .avatar-section {
            text-align: center;
            margin-bottom: 20px;
        }

        .avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.2);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            color: white;
            margin-bottom: 15px;
        }

        .status-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
        }

        .status-active {
            background: #d4edda;
            color: #155724;
        }

        .status-inactive {
            background: #f8d7da;
            color: #721c24;
        }

        .quick-stats {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-top: 20px;
        }

        .stat-item {
            text-align: center;
            margin-bottom: 15px;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: #667eea;
        }

        .stat-label {
            color: #6c757d;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
<!-- Sidebar -->
<nav class="sidebar">
    <div class="user-info">
        <div class="d-flex align-items-center">
            <i class="fas fa-user fa-2x me-3"></i>
            <div>
                <h6 class="mb-0">${sessionScope.userName}</h6>
                <small class="opacity-75">Locataire</small>
            </div>
        </div>
    </div>

    <ul class="nav flex-column">
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/locataire/dashboard">
                <i class="fas fa-tachometer-alt me-2"></i>Tableau de bord
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link active" href="${pageContext.request.contextPath}/locataire/profile">
                <i class="fas fa-user-circle me-2"></i>Mon Profil
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/locataire/recherche">
                <i class="fas fa-search me-2"></i>Rechercher un logement
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/locataire/contrats">
                <i class="fas fa-file-contract me-2"></i>Mes Contrats
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/locataire/paiements">
                <i class="fas fa-credit-card me-2"></i>Mes Paiements
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
        <h2 class="mb-0">Mon Profil</h2>
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

    <div class="row">
        <!-- Profil principal -->
        <div class="col-md-8">
            <!-- En-tête du profil -->
            <div class="profile-header">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <div class="avatar-section">
                            <div class="avatar">
                                <i class="fas fa-user"></i>
                            </div>
                            <h3 class="mb-2">${locataire.utilisateur.prenom} ${locataire.utilisateur.nom}</h3>
                            <span class="status-badge ${locataire.actif ? 'status-active' : 'status-inactive'}">
                                ${locataire.actif ? 'Profil actif' : 'Profil inactif'}
                            </span>
                        </div>
                    </div>
                    <div class="col-md-4 text-end">
                        <a href="${pageContext.request.contextPath}/locataire/profile-edit"
                           class="btn btn-light btn-lg">
                            <i class="fas fa-edit me-2"></i>Modifier
                        </a>
                    </div>
                </div>
            </div>

            <!-- Informations personnelles -->
            <div class="profile-card">
                <h5 class="mb-3">
                    <i class="fas fa-user me-2 text-primary"></i>
                    Informations personnelles
                </h5>

                <div class="info-item">
                    <div class="icon">
                        <i class="fas fa-envelope"></i>
                    </div>
                    <div class="content">
                        <div class="info-label">Adresse email</div>
                        <div class="info-value">${locataire.utilisateur.email}</div>
                    </div>
                </div>

                <c:if test="${not empty locataire.utilisateur.telephone}">
                    <div class="info-item">
                        <div class="icon">
                            <i class="fas fa-phone"></i>
                        </div>
                        <div class="content">
                            <div class="info-label">Téléphone</div>
                            <div class="info-value">${locataire.utilisateur.telephone}</div>
                        </div>
                    </div>
                </c:if>

                <c:if test="${not empty locataire.utilisateur.adresse}">
                    <div class="info-item">
                        <div class="icon">
                            <i class="fas fa-map-marker-alt"></i>
                        </div>
                        <div class="content">
                            <div class="info-label">Adresse</div>
                            <div class="info-value">${locataire.utilisateur.adresse}</div>
                        </div>
                    </div>
                </c:if>

                <div class="info-item">
                    <div class="icon">
                        <i class="fas fa-calendar-alt"></i>
                    </div>
                    <div class="content">
                        <div class="info-label">Membre depuis</div>
                        <div class="info-value">
                            <fmt:formatDate value="${locataire.utilisateur.dateCreation}" pattern="dd/MM/yyyy"/>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Informations professionnelles -->
            <div class="profile-card">
                <h5 class="mb-3">
                    <i class="fas fa-briefcase me-2 text-primary"></i>
                    Informations professionnelles
                </h5>

                <div class="info-item">
                    <div class="icon">
                        <i class="fas fa-user-tie"></i>
                    </div>
                    <div class="content">
                        <div class="info-label">Profession</div>
                        <div class="info-value">${locataire.profession}</div>
                    </div>
                </div>

                <c:if test="${not empty locataire.employeur}">
                    <div class="info-item">
                        <div class="icon">
                            <i class="fas fa-building"></i>
                        </div>
                        <div class="content">
                            <div class="info-label">Employeur</div>
                            <div class="info-value">${locataire.employeur}</div>
                        </div>
                    </div>
                </c:if>

                <div class="info-item">
                    <div class="icon">
                        <i class="fas fa-euro-sign"></i>
                    </div>
                    <div class="content">
                        <div class="info-label">Revenu mensuel</div>
                        <div class="info-value">
                            <span class="fw-bold text-success">
                                <fmt:formatNumber value="${locataire.revenuMensuel}" type="currency" currencySymbol="€"/>
                            </span>
                        </div>
                    </div>
                </div>

                <c:if test="${not empty locataire.adresseEmployeur}">
                    <div class="info-item">
                        <div class="icon">
                            <i class="fas fa-map-marker-alt"></i>
                        </div>
                        <div class="content">
                            <div class="info-label">Adresse de l'employeur</div>
                            <div class="info-value">${locataire.adresseEmployeur}</div>
                        </div>
                    </div>
                </c:if>

                <c:if test="${not empty locataire.telephoneEmployeur}">
                    <div class="info-item">
                        <div class="icon">
                            <i class="fas fa-phone-alt"></i>
                        </div>
                        <div class="content">
                            <div class="info-label">Téléphone de l'employeur</div>
                            <div class="info-value">${locataire.telephoneEmployeur}</div>
                        </div>
                    </div>
                </c:if>
            </div>

            <!-- Autres informations -->
            <c:if test="${not empty locataire.numeroIdentification or
                         not empty locataire.contactUrgenceNom or
                         not empty locataire.contactUrgenceTelephone}">
                <div class="profile-card">
                    <h5 class="mb-3">
                        <i class="fas fa-info-circle me-2 text-primary"></i>
                        Autres informations
                    </h5>

                    <c:if test="${not empty locataire.numeroIdentification}">
                        <div class="info-item">
                            <div class="icon">
                                <i class="fas fa-id-card"></i>
                            </div>
                            <div class="content">
                                <div class="info-label">Numéro d'identification</div>
                                <div class="info-value">${locataire.numeroIdentification}</div>
                            </div>
                        </div>
                    </c:if>

                    <c:if test="${not empty locataire.contactUrgenceNom}">
                        <div class="info-item">
                            <div class="icon">
                                <i class="fas fa-user-friends"></i>
                            </div>
                            <div class="content">
                                <div class="info-label">Contact d'urgence</div>
                                <div class="info-value">
                                        ${locataire.contactUrgenceNom}
                                    <c:if test="${not empty locataire.contactUrgenceRelation}">
                                        <small class="text-muted">(${locataire.contactUrgenceRelation})</small>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <c:if test="${not empty locataire.contactUrgenceTelephone}">
                        <div class="info-item">
                            <div class="icon">
                                <i class="fas fa-phone"></i>
                            </div>
                            <div class="content">
                                <div class="info-label">Téléphone du contact d'urgence</div>
                                <div class="info-value">${locataire.contactUrgenceTelephone}</div>
                            </div>
                        </div>
                    </c:if>
                </div>
            </c:if>
        </div>

        <!-- Sidebar droite -->
        <div class="col-md-4">
            <!-- Statistiques rapides -->
            <div class="profile-card">
                <h5 class="mb-3">
                    <i class="fas fa-chart-line me-2 text-primary"></i>
                    Mes statistiques
                </h5>

                <div class="quick-stats">
                    <div class="row">
                        <div class="col-6">
                            <div class="stat-item">
                                <div class="stat-number">0</div>
                                <div class="stat-label">Contrats</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="stat-item">
                                <div class="stat-number">0</div>
                                <div class="stat-label">Paiements</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Actions rapides -->
            <div class="profile-card">
                <h5 class="mb-3">
                    <i class="fas fa-bolt me-2 text-primary"></i>
                    Actions rapides
                </h5>

                <div class="d-grid gap-2">
                    <a href="${pageContext.request.contextPath}/locataire/profile-edit"
                       class="btn btn-primary">
                        <i class="fas fa-edit me-2"></i>Modifier mon profil
                    </a>
                    <a href="${pageContext.request.contextPath}/locataire/recherche"
                       class="btn btn-outline-primary">
                        <i class="fas fa-search me-2"></i>Rechercher un logement
                    </a>
                    <a href="${pageContext.request.contextPath}/locataire/contrats"
                       class="btn btn-outline-secondary">
                        <i class="fas fa-file-contract me-2"></i>Voir mes contrats
                    </a>
                </div>
            </div>

            <!-- Conseils -->
            <div class="profile-card">
                <h5 class="mb-3">
                    <i class="fas fa-lightbulb me-2 text-warning"></i>
                    Conseils
                </h5>

                <div class="alert alert-info">
                    <small>
                        <i class="fas fa-info-circle me-2"></i>
                        Gardez votre profil à jour pour maximiser vos chances
                        d'obtenir un logement.
                    </small>
                </div>

                <div class="alert alert-warning">
                    <small>
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        Vérifiez régulièrement vos informations de contact
                        pour ne manquer aucune opportunité.
                    </small>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>