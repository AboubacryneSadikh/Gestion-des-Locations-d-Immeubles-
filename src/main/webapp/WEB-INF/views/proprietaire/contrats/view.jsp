<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Détails du contrat" scope="request"/>

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
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
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

        .user-info {
            color: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 20px;
        }

        .contract-header {
            background: linear-gradient(135deg, #007bff 0%, #6610f2 100%);
            color: white;
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }

        .contract-status {
            padding: 0.7rem 1.5rem;
            border-radius: 30px;
            font-size: 1rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            display: inline-block;
            margin-left: 1rem;
        }

        .status-en-cours { background: #d4edda; color: #155724; }
        .status-en-attente { background: #fff3cd; color: #856404; }
        .status-termine { background: #e2e3e5; color: #383d41; }
        .status-resilie { background: #f8d7da; color: #721c24; }

        .info-card {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            border: none;
        }

        .info-section {
            margin-bottom: 2rem;
        }

        .info-section h5 {
            color: #2c3e50;
            font-weight: 600;
            margin-bottom: 1.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #e9ecef;
            display: flex;
            align-items: center;
        }

        .info-section h5 i {
            margin-right: 10px;
            color: #28a745;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 0;
            border-bottom: 1px solid #f8f9fa;
        }

        .info-row:last-child {
            border-bottom: none;
        }

        .info-label {
            font-weight: 600;
            color: #6c757d;
            display: flex;
            align-items: center;
        }

        .info-label i {
            margin-right: 8px;
            color: #28a745;
        }

        .info-value {
            color: #2c3e50;
            font-weight: 500;
        }

        .amount-value {
            color: #28a745;
            font-weight: 700;
            font-size: 1.1rem;
        }

        .date-value {
            color: #007bff;
            font-weight: 600;
        }

        .tenant-info {
            display: flex;
            align-items: center;
            padding: 1.5rem;
            background: #f8f9fa;
            border-radius: 15px;
            margin-bottom: 1rem;
        }

        .tenant-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: linear-gradient(135deg, #007bff 0%, #6610f2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            font-size: 1.5rem;
            margin-right: 1.5rem;
        }

        .property-info {
            display: flex;
            align-items: center;
            padding: 1.5rem;
            background: #f8f9fa;
            border-radius: 15px;
            margin-bottom: 1rem;
        }

        .property-icon {
            width: 80px;
            height: 80px;
            border-radius: 15px;
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 2rem;
            margin-right: 1.5rem;
        }

        .action-buttons {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
            flex-wrap: wrap;
        }

        .btn-action {
            border-radius: 10px;
            padding: 0.8rem 2rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
        }

        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }

        .btn-action i {
            margin-right: 8px;
        }

        .timeline {
            position: relative;
            padding-left: 2rem;
        }

        .timeline::before {
            content: '';
            position: absolute;
            left: 15px;
            top: 0;
            bottom: 0;
            width: 2px;
            background: #e9ecef;
        }

        .timeline-item {
            position: relative;
            margin-bottom: 2rem;
        }

        .timeline-item::before {
            content: '';
            position: absolute;
            left: -7px;
            top: 5px;
            width: 14px;
            height: 14px;
            border-radius: 50%;
            background: #28a745;
        }

        .timeline-content {
            background: white;
            border-radius: 10px;
            padding: 1.5rem;
            margin-left: 1rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .warning-card {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
            color: white;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }

        .breadcrumb {
            background: white;
            padding: 1rem 1.5rem;
            border-radius: 10px;
            margin-bottom: 1.5rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .documents-section {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .document-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 1rem;
            background: white;
            border-radius: 10px;
            margin-bottom: 1rem;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }

        .document-info {
            display: flex;
            align-items: center;
        }

        .document-icon {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            background: #dc3545;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            margin-right: 1rem;
        }
    </style>
</head>
<body>
<!-- Sidebar -->
<nav class="sidebar">
    <div class="user-info">
        <div class="d-flex align-items-center">
            <i class="fas fa-user-tie fa-2x me-3"></i>
            <div>
                <h6 class="mb-0">${sessionScope.utilisateur.prenom} ${sessionScope.utilisateur.nom}</h6>
                <small class="opacity-75">Propriétaire</small>
            </div>
        </div>
    </div>

    <ul class="nav flex-column">
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/proprietaire/dashboard">
                <i class="fas fa-tachometer-alt me-2"></i>Tableau de bord
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/proprietaire/immeubles">
                <i class="fas fa-building me-2"></i>Mes immeubles
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/proprietaire/unites">
                <i class="fas fa-door-open me-2"></i>Mes unités
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/proprietaire/candidatures">
                <i class="fas fa-user-check me-2"></i>Candidatures
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link active" href="${pageContext.request.contextPath}/proprietaire/contrats">
                <i class="fas fa-file-contract me-2"></i>Contrats
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
                <a href="${pageContext.request.contextPath}/proprietaire/dashboard">
                    <i class="fas fa-home"></i> Accueil
                </a>
            </li>
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/proprietaire/contrats">Contrats</a>
            </li>
            <li class="breadcrumb-item active">Contrat ${contrat.numeroContrat}</li>
        </ol>
    </nav>

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

    <!-- En-tête du contrat -->
    <div class="contract-header">
        <div class="row align-items-center">
            <div class="col-md-8">
                <h2 class="mb-2">
                    <i class="fas fa-file-contract me-2"></i>
                    Contrat ${contrat.numeroContrat}
                </h2>
                <p class="mb-0 opacity-75">
                    Créé le <fmt:formatDate value="${contrat.dateCreation}" pattern="dd/MM/yyyy"/>
                </p>
            </div>
            <div class="col-md-4 text-end">
                <c:choose>
                    <c:when test="${contrat.statut == 'EN_COURS'}">
                        <span class="contract-status status-en-cours">
                            <i class="fas fa-play-circle me-1"></i>En cours
                        </span>
                    </c:when>
                    <c:when test="${contrat.statut == 'EN_ATTENTE'}">
                        <span class="contract-status status-en-attente">
                            <i class="fas fa-clock me-1"></i>En attente
                        </span>
                    </c:when>
                    <c:when test="${contrat.statut == 'TERMINE'}">
                        <span class="contract-status status-termine">
                            <i class="fas fa-check-circle me-1"></i>Terminé
                        </span>
                    </c:when>
                    <c:when test="${contrat.statut == 'RESILIE'}">
                        <span class="contract-status status-resilie">
                            <i class="fas fa-times-circle me-1"></i>Résilié
                        </span>
                    </c:when>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Vérifier l'expiration proche -->
    <jsp:useBean id="now" class="java.util.Date" />
    <jsp:useBean id="in30Days" class="java.util.Date" />
    <c:set target="${in30Days}" property="time" value="${now.time + (30 * 24 * 60 * 60 * 1000)}" />

    <c:if test="${contrat.dateFin.before(in30Days) && contrat.dateFin.after(now) && contrat.statut == 'EN_COURS'}">
        <div class="warning-card">
            <div class="d-flex align-items-center">
                <i class="fas fa-exclamation-triangle fa-2x me-3"></i>
                <div>
                    <h6 class="mb-1">Contrat expirant bientôt</h6>
                    <p class="mb-0">
                        Ce contrat expire le <strong><fmt:formatDate value="${contrat.dateFin}" pattern="dd/MM/yyyy"/></strong>.
                        Pensez à contacter le locataire pour le renouvellement.
                    </p>
                </div>
            </div>
        </div>
    </c:if>

    <div class="row">
        <!-- Informations principales -->
        <div class="col-md-8">
            <!-- Informations du locataire -->
            <div class="info-card">
                <div class="info-section">
                    <h5><i class="fas fa-user"></i>Informations du locataire</h5>
                    <div class="tenant-info">
                        <div class="tenant-avatar">
                            ${contrat.locataire.utilisateur.prenom.substring(0,1)}${contrat.locataire.utilisateur.nom.substring(0,1)}
                        </div>
                        <div>
                            <h6 class="mb-1">${contrat.locataire.utilisateur.prenom} ${contrat.locataire.utilisateur.nom}</h6>
                            <div class="text-muted">
                                <div><i class="fas fa-envelope me-2"></i>${contrat.locataire.utilisateur.email}</div>
                                <div><i class="fas fa-phone me-2"></i>${contrat.locataire.utilisateur.telephone}</div>
                                <c:if test="${not empty contrat.locataire.profession}">
                                    <div><i class="fas fa-briefcase me-2"></i>${contrat.locataire.profession}</div>
                                </c:if>
                                <c:if test="${not empty contrat.locataire.revenuMensuel}">
                                    <div><i class="fas fa-coins me-2"></i>
                                        Revenus: <fmt:formatNumber value="${contrat.locataire.revenuMensuel}" type="currency" currencyCode="XOF"/>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Informations de la propriété -->
            <div class="info-card">
                <div class="info-section">
                    <h5><i class="fas fa-building"></i>Propriété louée</h5>
                    <div class="property-info">
                        <div class="property-icon">
                            <i class="fas fa-door-open"></i>
                        </div>
                        <div>
                            <h6 class="mb-1">${contrat.unite.immeuble.nom} - Unité ${contrat.unite.numero}</h6>
                            <div class="text-muted">
                                <div><i class="fas fa-map-marker-alt me-2"></i>
                                    ${contrat.unite.immeuble.adresse}, ${contrat.unite.immeuble.ville}
                                </div>
                                <div><i class="fas fa-home me-2"></i>
                                    ${contrat.unite.nombrePieces} pièces - ${contrat.unite.superficie} m²
                                </div>
                                <div><i class="fas fa-layer-group me-2"></i>
                                    Étage ${contrat.unite.etage}
                                </div>
                            </div>
                            <div class="mt-2">
                                <a href="${pageContext.request.contextPath}/proprietaire/unites/view?id=${contrat.unite.id}"
                                   class="btn btn-sm btn-outline-success">
                                    <i class="fas fa-eye me-1"></i>Voir l'unité
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Conditions financières -->
            <div class="info-card">
                <div class="info-section">
                    <h5><i class="fas fa-euro-sign"></i>Conditions financières</h5>
                    <div class="info-row">
                        <div class="info-label">
                            <i class="fas fa-home"></i>Loyer mensuel
                        </div>
                        <div class="info-value amount-value">
                            <fmt:formatNumber value="${contrat.loyer}" type="currency" currencyCode="XOF"/>
                        </div>
                    </div>
                    <c:if test="${not empty contrat.chargesMensuelles}">
                        <div class="info-row">
                            <div class="info-label">
                                <i class="fas fa-bolt"></i>Charges mensuelles
                            </div>
                            <div class="info-value amount-value">
                                <fmt:formatNumber value="${contrat.chargesMensuelles}" type="currency" currencyCode="XOF"/>
                            </div>
                        </div>
                    </c:if>
                    <c:if test="${not empty contrat.depotGarantie}">
                        <div class="info-row">
                            <div class="info-label">
                                <i class="fas fa-shield-alt"></i>Dépôt de garantie
                            </div>
                            <div class="info-value amount-value">
                                <fmt:formatNumber value="${contrat.depotGarantie}" type="currency" currencyCode="XOF"/>
                            </div>
                        </div>
                    </c:if>
                    <div class="info-row">
                        <div class="info-label">
                            <i class="fas fa-calendar-day"></i>Jour de paiement
                        </div>
                        <div class="info-value">
                            ${contrat.jourPaiement} de chaque mois
                        </div>
                    </div>
                    <hr>
                    <div class="info-row">
                        <div class="info-label">
                            <strong><i class="fas fa-calculator"></i>Total mensuel</strong>
                        </div>
                        <div class="info-value amount-value" style="font-size: 1.3rem;">
                            <c:set var="totalMensuel" value="${contrat.loyer}"/>
                            <c:if test="${not empty contrat.chargesMensuelles}">
                                <c:set var="totalMensuel" value="${totalMensuel + contrat.chargesMensuelles}"/>
                            </c:if>
                            <fmt:formatNumber value="${totalMensuel}" type="currency" currencyCode="XOF"/>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Informations secondaires -->
        <div class="col-md-4">
            <!-- Informations temporelles -->
            <div class="info-card">
                <div class="info-section">
                    <h5><i class="fas fa-clock"></i>Période du contrat</h5>
                    <div class="info-row">
                        <div class="info-label">
                            <i class="fas fa-play"></i>Date de début
                        </div>
                        <div class="info-value date-value">
                            <fmt:formatDate value="${contrat.dateDebut}" pattern="dd/MM/yyyy"/>
                        </div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">
                            <i class="fas fa-stop"></i>Date de fin
                        </div>
                        <div class="info-value date-value">
                            <fmt:formatDate value="${contrat.dateFin}" pattern="dd/MM/yyyy"/>
                        </div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">
                            <i class="fas fa-hourglass-half"></i>Durée
                        </div>
                        <div class="info-value">
                            <c:set var="duree" value="${(contrat.dateFin.time - contrat.dateDebut.time) / (1000 * 60 * 60 * 24 * 30)}"/>
                            <fmt:formatNumber value="${duree}" maxFractionDigits="0"/> mois
                        </div>
                    </div>
                    <c:if test="${contrat.statut == 'EN_COURS'}">
                        <div class="info-row">
                            <div class="info-label">
                                <i class="fas fa-calendar-alt"></i>Temps restant
                            </div>
                            <div class="info-value">
                                <c:set var="joursRestants" value="${(contrat.dateFin.time - now.time) / (1000 * 60 * 60 * 24)}"/>
                                <c:choose>
                                    <c:when test="${joursRestants > 0}">
                                        <span class="text-success">
                                            <fmt:formatNumber value="${joursRestants}" maxFractionDigits="0"/> jours
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-danger">Expiré</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Actions rapides -->
            <div class="info-card">
                <div class="info-section">
                    <h5><i class="fas fa-cogs"></i>Actions</h5>
                    <div class="action-buttons">
                        <c:if test="${contrat.statut == 'EN_ATTENTE'}">
                            <a href="${pageContext.request.contextPath}/proprietaire/contrats/manage?id=${contrat.id}"
                               class="btn btn-success btn-action">
                                <i class="fas fa-play"></i>Activer contrat
                            </a>
                        </c:if>

                        <c:if test="${contrat.statut == 'EN_COURS'}">
                            <a href="${pageContext.request.contextPath}/proprietaire/contrats/manage?id=${contrat.id}"
                               class="btn btn-warning btn-action">
                                <i class="fas fa-edit"></i>Modifier statut
                            </a>
                            <button type="button" class="btn btn-info btn-action" data-bs-toggle="modal" data-bs-target="#renewModal">
                                <i class="fas fa-redo"></i>Renouveler
                            </button>
                        </c:if>

                        <a href="${pageContext.request.contextPath}/proprietaire/paiements?contratId=${contrat.id}"
                           class="btn btn-primary btn-action">
                            <i class="fas fa-money-bill-wave"></i>Paiements
                        </a>

                        <button type="button" class="btn btn-secondary btn-action" onclick="window.print()">
                            <i class="fas fa-print"></i>Imprimer
                        </button>
                    </div>
                </div>
            </div>

            <!-- Documents -->
            <div class="documents-section">
                <h5><i class="fas fa-file-alt me-2"></i>Documents</h5>
                <div class="document-item">
                    <div class="document-info">
                        <div class="document-icon">
                            <i class="fas fa-file-pdf"></i>
                        </div>
                        <div>
                            <div class="fw-bold">Contrat de location</div>
                            <small class="text-muted">PDF - Généré automatiquement</small>
                        </div>
                    </div>
                    <button class="btn btn-sm btn-outline-danger">
                        <i class="fas fa-download"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Historique/Timeline -->
    <div class="info-card">
        <div class="info-section">
            <h5><i class="fas fa-history"></i>Historique du contrat</h5>
            <div class="timeline">
                <div class="timeline-item">
                    <div class="timeline-content">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <h6 class="mb-1">Contrat créé</h6>
                                <p class="mb-0 text-muted">Le contrat a été créé dans le système</p>
                            </div>
                            <small class="text-muted">
                                <fmt:formatDate value="${contrat.dateCreation}" pattern="dd/MM/yyyy HH:mm"/>
                            </small>
                        </div>
                    </div>
                </div>

                <c:if test="${not empty contrat.dateModification}">
                    <div class="timeline-item">
                        <div class="timeline-content">
                            <div class="d-flex justify-content-between align-items-start">
                                <div>
                                    <h6 class="mb-1">Dernière modification</h6>
                                    <p class="mb-0 text-muted">Le contrat a été modifié</p>
                                </div>
                                <small class="text-muted">
                                    <fmt:formatDate value="${contrat.dateModification}" pattern="dd/MM/yyyy HH:mm"/>
                                </small>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<!-- Modal de renouvellement -->
<div class="modal fade" id="renewModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-redo me-2"></i>Renouveler le contrat
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/proprietaire/contrats/renew">
                <div class="modal-body">
                    <input type="hidden" name="contratId" value="${contrat.id}">

                    <div class="mb-3">
                        <label class="form-label">Nouvelle date de fin</label>
                        <input type="date" class="form-control" name="nouvelleDateFin" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Nouveau loyer (optionnel)</label>
                        <div class="input-group">
                            <input type="number" step="0.01" class="form-control" name="nouveauLoyer"
                                   placeholder="Laisser vide pour conserver le loyer actuel">
                            <span class="input-group-text">F CFA</span>
                        </div>
                    </div>

                    <div class="alert alert-info">
                        <i class="fas fa-info-circle me-2"></i>
                        Le renouvellement prolongera la durée du contrat actuel avec les nouvelles conditions spécifiées.
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-redo me-2"></i>Renouveler
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Animation pour les alertes
    setTimeout(function() {
        const alerts = document.querySelectorAll('.alert-dismissible');
        alerts.forEach(alert => {
            alert.style.opacity = '0';
            alert.style.transition = 'opacity 0.5s';
            setTimeout(() => alert.remove(), 500);
        });
    }, 5000);

    // Validation du formulaire de renouvellement
    document.querySelector('#renewModal form').addEventListener('submit', function(e) {
        const nouvelleDateFin = document.querySelector('input[name="nouvelleDateFin"]').value;
        const dateFinActuelle = new Date('${contrat.dateFin}');
        const nouvelleDate = new Date(nouvelleDateFin);

        if (nouvelleDate <= dateFinActuelle) {
            e.preventDefault();
            alert('La nouvelle date de fin doit être postérieure à la date de fin actuelle.');
            return false;
        }
    });
</script>
</body>
</html>