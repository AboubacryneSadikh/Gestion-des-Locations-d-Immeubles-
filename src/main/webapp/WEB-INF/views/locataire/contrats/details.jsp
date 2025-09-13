<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Détails du contrat - Locataire" scope="request"/>

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

        .contract-hero {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 40px;
            margin-bottom: 30px;
            position: relative;
            overflow: hidden;
        }

        .contract-hero::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -20%;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
        }

        .detail-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            border: none;
            margin-bottom: 20px;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .info-item {
            display: flex;
            align-items: start;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 10px;
            transition: all 0.3s;
        }

        .info-item:hover {
            background: #e9ecef;
            transform: translateY(-2px);
        }

        .info-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            color: #667eea;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .info-content .label {
            font-size: 0.9rem;
            color: #6c757d;
            margin-bottom: 3px;
        }

        .info-content .value {
            font-weight: 600;
            color: #495057;
        }

        .status-badge {
            padding: 8px 16px;
            border-radius: 25px;
            font-size: 0.9rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
        }

        .status-en-cours {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }

        .status-termine {
            background: #f8d7da;
            color: #721c24;
        }

        .status-resilie {
            background: #f8d7da;
            color: #721c24;
        }

        .payment-item {
            background: white;
            border: 1px solid #e9ecef;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 10px;
            transition: all 0.3s;
        }

        .payment-item:hover {
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            transform: translateY(-1px);
        }

        .payment-item.en-attente {
            border-left: 4px solid #ffc107;
        }

        .payment-item.en-retard {
            border-left: 4px solid #dc3545;
        }

        .payment-item.paye {
            border-left: 4px solid #28a745;
        }

        .user-info {
            color: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 20px;
        }

        .quick-actions {
            position: sticky;
            top: 20px;
        }

        .timeline {
            position: relative;
            padding-left: 30px;
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
            margin-bottom: 20px;
        }

        .timeline-item::before {
            content: '';
            position: absolute;
            left: -8px;
            top: 5px;
            width: 16px;
            height: 16px;
            border-radius: 50%;
            background: #667eea;
            border: 3px solid white;
            box-shadow: 0 0 0 2px #e9ecef;
        }

        .contact-card {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 10px;
            padding: 20px;
            margin-top: 20px;
        }

        .breadcrumb {
            background: white;
            padding: 1rem 1.5rem;
            border-radius: 10px;
            margin-bottom: 1.5rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .urgent-payment-alert {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { opacity: 1; }
            50% { opacity: 0.9; }
            100% { opacity: 1; }
        }

        .action-btn {
            transition: all 0.3s;
            margin-bottom: 10px;
        }

        .action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
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
                <h6 class="mb-0">${sessionScope.utilisateur.prenom} ${sessionScope.utilisateur.nom}</h6>
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
            <a class="nav-link" href="${pageContext.request.contextPath}/locataire/profile">
                <i class="fas fa-user-circle me-2"></i>Mon Profil
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/locataire/recherche">
                <i class="fas fa-search me-2"></i>Rechercher un logement
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link active" href="${pageContext.request.contextPath}/locataire/contrats">
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
    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/locataire/dashboard">
                    <i class="fas fa-home"></i> Accueil
                </a>
            </li>
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/locataire/contrats">Mes contrats</a>
            </li>
            <li class="breadcrumb-item active">Détails du contrat</li>
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

    <!-- Vérifier s'il y a des paiements en retard pour ce contrat -->
    <c:set var="hasOverduePayments" value="false"/>
    <c:set var="firstOverduePaiement" value="" />
    <c:forEach var="paiement" items="${paiements}">
        <c:if test="${paiement.statut == 'EN_RETARD'}">
            <c:set var="hasOverduePayments" value="true"/>
            <!-- Capturer le premier paiement en retard si pas encore défini -->
            <c:if test="${empty firstOverduePaiement}">
                <c:set var="firstOverduePaiement" value="${paiement}" />
            </c:if>
        </c:if>
    </c:forEach>

    <!-- Alerte paiements urgents -->
    <c:if test="${hasOverduePayments}">
        <div class="urgent-payment-alert">
            <div class="d-flex align-items-center">
                <i class="fas fa-exclamation-triangle fa-2x me-3"></i>
                <div class="flex-grow-1">
                    <h6 class="mb-1">Paiements en retard !</h6>
                    <p class="mb-0">Vous avez des paiements en retard pour ce contrat. Régularisez rapidement votre situation.</p>
                </div>
                <c:if test="${not empty firstOverduePaiement}">
                    <a href="${pageContext.request.contextPath}/locataire/paiement?id=${firstOverduePaiement.id}"
                       class="btn btn-light btn-lg">
                        <i class="fas fa-credit-card me-2"></i>Payer maintenant
                    </a>
                </c:if>
            </div>
        </div>
    </c:if>

    <div class="row">
        <!-- Contenu principal -->
        <div class="col-md-8">
            <!-- En-tête du contrat -->
            <div class="contract-hero">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h3 class="mb-2">${contrat.unite.immeuble.nom}</h3>
                        <h5 class="mb-3">Unité ${contrat.unite.numero}</h5>
                        <p class="mb-2">
                            <i class="fas fa-map-marker-alt me-2"></i>
                            ${contrat.unite.immeuble.adresse}, ${contrat.unite.immeuble.ville}
                        </p>
                        <div class="d-flex align-items-center">
                            <span class="status-badge status-${contrat.statut.toString().toLowerCase().replace('_', '-')}">
                                <c:choose>
                                    <c:when test="${contrat.statut == 'EN_COURS'}">
                                        <i class="fas fa-play-circle me-1"></i>Contrat en cours
                                    </c:when>
                                    <c:when test="${contrat.statut == 'TERMINE'}">
                                        <i class="fas fa-check-circle me-1"></i>Contrat terminé
                                    </c:when>
                                    <c:when test="${contrat.statut == 'RESILIE'}">
                                        <i class="fas fa-times-circle me-1"></i>Contrat résilié
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fas fa-info-circle me-1"></i>${contrat.statut}
                                    </c:otherwise>
                                </c:choose>
                            </span>
                            <span class="ms-3 opacity-75">
                                Contrat n° ${contrat.numeroContrat}
                            </span>
                        </div>
                    </div>
                    <div class="col-md-4 text-end">
                        <i class="fas fa-file-contract fa-5x opacity-50"></i>
                    </div>
                </div>
            </div>

            <!-- Informations générales -->
            <div class="detail-card">
                <h5 class="mb-3">
                    <i class="fas fa-info-circle me-2 text-primary"></i>
                    Informations générales
                </h5>

                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-calendar-alt"></i>
                        </div>
                        <div class="info-content">
                            <div class="label">Date de début</div>
                            <div class="value">
                                <fmt:formatDate value="${contrat.dateDebut}" pattern="dd/MM/yyyy"/>
                            </div>
                        </div>
                    </div>

                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                        <div class="info-content">
                            <div class="label">Date de fin</div>
                            <div class="value">
                                <fmt:formatDate value="${contrat.dateFin}" pattern="dd/MM/yyyy"/>
                            </div>
                        </div>
                    </div>

                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-coins"></i>
                        </div>
                        <div class="info-content">
                            <div class="label">Loyer mensuel</div>
                            <div class="value text-success">
                                <fmt:formatNumber value="${contrat.loyer}" pattern="#,##0" /> F CFA
                            </div>
                        </div>
                    </div>

                    <c:if test="${not empty contrat.chargesMensuelles && contrat.chargesMensuelles > 0}">
                        <div class="info-item">
                            <div class="info-icon">
                                <i class="fas fa-bolt"></i>
                            </div>
                            <div class="info-content">
                                <div class="label">Charges mensuelles</div>
                                <div class="value text-warning">
                                    <fmt:formatNumber value="${contrat.chargesMensuelles}" pattern="#,##0" /> F CFA
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <c:if test="${not empty contrat.depotGarantie && contrat.depotGarantie > 0}">
                        <div class="info-item">
                            <div class="info-icon">
                                <i class="fas fa-shield-alt"></i>
                            </div>
                            <div class="info-content">
                                <div class="label">Dépôt de garantie</div>
                                <div class="value text-info">
                                    <fmt:formatNumber value="${contrat.depotGarantie}" pattern="#,##0" /> F CFA
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-th-large"></i>
                        </div>
                        <div class="info-content">
                            <div class="label">Nombre de pièces</div>
                            <div class="value">${contrat.unite.nombrePieces} pièce(s)</div>
                        </div>
                    </div>

                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-ruler-combined"></i>
                        </div>
                        <div class="info-content">
                            <div class="label">Superficie</div>
                            <div class="value">${contrat.unite.superficie} m²</div>
                        </div>
                    </div>

                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fas fa-calendar-day"></i>
                        </div>
                        <div class="info-content">
                            <div class="label">Jour de paiement</div>
                            <div class="value">${contrat.jourPaiement} de chaque mois</div>
                        </div>
                    </div>
                </div>

                <!-- Montant total mensuel -->
                <div class="alert alert-info">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <strong>Total mensuel à payer :</strong>
                        </div>
                        <div class="h5 mb-0 text-primary">
                            <c:set var="totalMensuel" value="${contrat.loyer}"/>
                            <c:if test="${not empty contrat.chargesMensuelles && contrat.chargesMensuelles > 0}">
                                <c:set var="totalMensuel" value="${totalMensuel + contrat.chargesMensuelles}"/>
                            </c:if>
                            <fmt:formatNumber value="${totalMensuel}" pattern="#,##0" /> F CFA
                        </div>
                    </div>
                </div>
            </div>

            <!-- Description du logement -->
            <c:if test="${not empty contrat.unite.description}">
                <div class="detail-card">
                    <h5 class="mb-3">
                        <i class="fas fa-home me-2 text-primary"></i>
                        Description du logement
                    </h5>
                    <div class="alert alert-light">
                        <p class="mb-0">${contrat.unite.description}</p>
                    </div>
                </div>
            </c:if>

            <!-- Équipements -->
            <c:if test="${not empty contrat.unite.equipements}">
                <div class="detail-card">
                    <h5 class="mb-3">
                        <i class="fas fa-tools me-2 text-primary"></i>
                        Équipements inclus
                    </h5>
                    <div class="alert alert-light">
                        <p class="mb-0">${contrat.unite.equipements}</p>
                    </div>
                </div>
            </c:if>

            <!-- Historique des paiements -->
            <div class="detail-card">
                <h5 class="mb-3">
                    <i class="fas fa-credit-card me-2 text-primary"></i>
                    Historique des paiements
                </h5>

                <c:choose>
                    <c:when test="${not empty paiements}">
                        <div class="row">
                            <c:forEach var="paiement" items="${paiements}" varStatus="status">
                                <div class="col-md-6 mb-3">
                                    <div class="payment-item ${paiement.statut.toString().toLowerCase().replace('_', '-')}">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <div class="fw-bold">
                                                    Loyer <fmt:formatDate value="${paiement.dateEcheance}" pattern="MM/yyyy"/>
                                                </div>
                                                <small class="text-muted">
                                                    Échéance: <fmt:formatDate value="${paiement.dateEcheance}" pattern="dd/MM/yyyy"/>
                                                </small>
                                            </div>
                                            <div class="text-end">
                                                <div class="fw-bold">
                                                    <fmt:formatNumber value="${paiement.montant}" pattern="#,##0" /> F CFA
                                                </div>
                                                <small class="badge ${paiement.statut == 'PAYE' ? 'bg-success' :
                                                                     paiement.statut == 'EN_ATTENTE' ? 'bg-warning' : 'bg-danger'}">
                                                    <c:choose>
                                                        <c:when test="${paiement.statut == 'PAYE'}">
                                                            <i class="fas fa-check me-1"></i>Payé
                                                        </c:when>
                                                        <c:when test="${paiement.statut == 'EN_ATTENTE'}">
                                                            <i class="fas fa-clock me-1"></i>En attente
                                                        </c:when>
                                                        <c:when test="${paiement.statut == 'EN_RETARD'}">
                                                            <i class="fas fa-exclamation-triangle me-1"></i>En retard
                                                        </c:when>
                                                        <c:otherwise>${paiement.statut}</c:otherwise>
                                                    </c:choose>
                                                </small>
                                            </div>
                                        </div>
                                        <c:if test="${paiement.statut == 'PAYE' and not empty paiement.datePaiement}">
                                            <div class="mt-2">
                                                <small class="text-success">
                                                    <i class="fas fa-check me-1"></i>
                                                    Payé le <fmt:formatDate value="${paiement.datePaiement}" pattern="dd/MM/yyyy"/>
                                                </small>
                                            </div>
                                        </c:if>
                                        <c:if test="${paiement.statut != 'PAYE'}">
                                            <div class="mt-2">
                                                <a href="${pageContext.request.contextPath}/locataire/paiement?id=${paiement.id}"
                                                   class="btn btn-sm ${paiement.statut == 'EN_RETARD' ? 'btn-danger' : 'btn-warning'}">
                                                    <i class="fas fa-credit-card me-1"></i>
                                                    <c:choose>
                                                        <c:when test="${paiement.statut == 'EN_RETARD'}">Payer d'urgence</c:when>
                                                        <c:otherwise>Payer</c:otherwise>
                                                    </c:choose>
                                                </a>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <div class="text-center mt-3">
                            <a href="${pageContext.request.contextPath}/locataire/paiements?contratId=${contrat.id}"
                               class="btn btn-outline-primary">
                                <i class="fas fa-list me-2"></i>Voir tous les paiements
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-info text-center">
                            <i class="fas fa-info-circle fa-2x mb-3"></i>
                            <h6>Aucun paiement enregistré</h6>
                            <p class="mb-0">Aucun paiement n'a encore été généré pour ce contrat.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Sidebar droite -->
        <div class="col-md-4">
            <div class="quick-actions">
                <!-- Actions rapides -->
                <div class="detail-card">
                    <h5 class="mb-3">
                        <i class="fas fa-bolt me-2 text-primary"></i>
                        Actions rapides
                    </h5>

                    <div class="d-grid gap-2">
                        <!-- Bouton paiement d'urgence si il y a des retards -->
                        <c:if test="${hasOverduePayments and not empty firstOverduePaiement}">
                            <a href="${pageContext.request.contextPath}/locataire/paiement?id=${firstOverduePaiement.id}"
                               class="btn btn-danger action-btn">
                                <i class="fas fa-exclamation-triangle me-2"></i>Payer d'urgence
                            </a>
                        </c:if>

                        <!-- Bouton paiement général par contrat -->
                        <a href="${pageContext.request.contextPath}/locataire/paiement?contratId=${contrat.id}"
                           class="btn btn-success action-btn">
                            <i class="fas fa-credit-card me-2"></i>Effectuer un paiement
                        </a>

                        <button class="btn btn-primary action-btn" onclick="downloadContract()">
                            <i class="fas fa-download me-2"></i>Télécharger le contrat
                        </button>

                        <button class="btn btn-outline-primary action-btn" onclick="printContract()">
                            <i class="fas fa-print me-2"></i>Imprimer
                        </button>

                        <a href="${pageContext.request.contextPath}/locataire/paiements?contratId=${contrat.id}"
                           class="btn btn-outline-info action-btn">
                            <i class="fas fa-list me-2"></i>Historique complet
                        </a>
                    </div>
                </div>

                <!-- Informations sur le propriétaire -->
                <div class="detail-card">
                    <h5 class="mb-3">
                        <i class="fas fa-user-tie me-2 text-primary"></i>
                        Propriétaire
                    </h5>

                    <c:if test="${not empty contrat.unite.immeuble.proprietaire}">
                        <div class="contact-card">
                            <div class="text-center mb-3">
                                <div class="rounded-circle bg-primary text-white d-inline-flex align-items-center justify-content-center"
                                     style="width: 60px; height: 60px; font-size: 1.5rem;">
                                        ${contrat.unite.immeuble.proprietaire.prenom.substring(0,1)}${contrat.unite.immeuble.proprietaire.nom.substring(0,1)}
                                </div>
                            </div>

                            <h6 class="text-center mb-3">
                                    ${contrat.unite.immeuble.proprietaire.prenom}
                                    ${contrat.unite.immeuble.proprietaire.nom}
                            </h6>

                            <div class="mb-2">
                                <i class="fas fa-envelope me-2 text-primary"></i>
                                <a href="mailto:${contrat.unite.immeuble.proprietaire.email}" class="text-decoration-none">
                                        ${contrat.unite.immeuble.proprietaire.email}
                                </a>
                            </div>

                            <c:if test="${not empty contrat.unite.immeuble.proprietaire.telephone}">
                                <div class="mb-3">
                                    <i class="fas fa-phone me-2 text-primary"></i>
                                    <a href="tel:${contrat.unite.immeuble.proprietaire.telephone}" class="text-decoration-none">
                                            ${contrat.unite.immeuble.proprietaire.telephone}
                                    </a>
                                </div>
                            </c:if>

                            <div class="d-grid">
                                <button class="btn btn-outline-primary btn-sm action-btn" onclick="contactOwner()">
                                    <i class="fas fa-envelope me-2"></i>Contacter
                                </button>
                            </div>
                        </div>
                    </c:if>
                </div>

                <!-- Résumé financier -->
                <div class="detail-card">
                    <h5 class="mb-3">
                        <i class="fas fa-calculator me-2 text-primary"></i>
                        Résumé financier
                    </h5>

                    <div class="info-item mb-2">
                        <div class="info-content">
                            <div class="label">Loyer mensuel</div>
                            <div class="value text-success">
                                <fmt:formatNumber value="${contrat.loyer}" pattern="#,##0" /> F CFA
                            </div>
                        </div>
                    </div>

                    <c:if test="${not empty contrat.chargesMensuelles && contrat.chargesMensuelles > 0}">
                        <div class="info-item mb-2">
                            <div class="info-content">
                                <div class="label">Charges mensuelles</div>
                                <div class="value text-warning">
                                    <fmt:formatNumber value="${contrat.chargesMensuelles}" pattern="#,##0" /> F CFA
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <hr>

                    <c:set var="totalPaye" value="0"/>
                    <c:set var="totalAPayert" value="0"/>
                    <c:forEach var="paiement" items="${paiements}">
                        <c:if test="${paiement.statut == 'PAYE'}">
                            <c:set var="totalPaye" value="${totalPaye + paiement.montant}"/>
                        </c:if>
                        <c:if test="${paiement.statut != 'PAYE'}">
                            <c:set var="totalAPayert" value="${totalAPayert + paiement.montant}"/>
                        </c:if>
                    </c:forEach>

                    <div class="info-item mb-2">
                        <div class="info-content">
                            <div class="label">Total payé</div>
                            <div class="value text-success">
                                <fmt:formatNumber value="${totalPaye}" pattern="#,##0" /> F CFA
                            </div>
                        </div>
                    </div>

                    <c:if test="${totalAPayert > 0}">
                        <div class="info-item mb-2">
                            <div class="info-content">
                                <div class="label">Solde à payer</div>
                                <div class="value text-danger">
                                    <fmt:formatNumber value="${totalAPayert}" pattern="#,##0" /> F CFA
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <!-- Calculateur de durée restante -->
                    <c:if test="${contrat.statut == 'EN_COURS'}">
                        <hr>
                        <c:set var="today" value="<%=new java.util.Date()%>"/>
                        <c:set var="daysRemaining" value="${(contrat.dateFin.time - today.time) / (1000 * 60 * 60 * 24)}"/>
                        <c:set var="monthsRemaining" value="${daysRemaining / 30}"/>

                        <div class="info-item">
                            <div class="info-content">
                                <div class="label">Durée restante</div>
                                <div class="value">
                                    <c:choose>
                                        <c:when test="${daysRemaining > 0}">
                                            <span class="text-info">
                                                <fmt:formatNumber value="${monthsRemaining}" maxFractionDigits="1"/> mois
                                                (<fmt:formatNumber value="${daysRemaining}" maxFractionDigits="0"/> jours)
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-warning">Contrat expiré</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>

                <!-- Historique du contrat -->
                <div class="detail-card">
                    <h5 class="mb-3">
                        <i class="fas fa-history me-2 text-primary"></i>
                        Historique
                    </h5>

                    <div class="timeline">
                        <div class="timeline-item">
                            <div class="small">
                                <strong>Contrat créé</strong><br>
                                <span class="text-muted">
                                    <fmt:formatDate value="${contrat.dateCreation}" pattern="dd/MM/yyyy"/>
                                </span>
                            </div>
                        </div>

                        <div class="timeline-item">
                            <div class="small">
                                <strong>Début de location</strong><br>
                                <span class="text-muted">
                                    <fmt:formatDate value="${contrat.dateDebut}" pattern="dd/MM/yyyy"/>
                                </span>
                            </div>
                        </div>

                        <c:if test="${contrat.statut == 'TERMINE' || contrat.statut == 'RESILIE'}">
                            <div class="timeline-item">
                                <div class="small">
                                    <strong>
                                        <c:choose>
                                            <c:when test="${contrat.statut == 'TERMINE'}">Fin de location</c:when>
                                            <c:otherwise>Contrat résilié</c:otherwise>
                                        </c:choose>
                                    </strong><br>
                                    <span class="text-muted">
                                        <fmt:formatDate value="${contrat.dateFin}" pattern="dd/MM/yyyy"/>
                                    </span>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Informations du logement -->
                <div class="detail-card">
                    <h6 class="mb-3">
                        <i class="fas fa-info-circle me-2 text-primary"></i>
                        Informations du logement
                    </h6>

                    <div class="row text-center">
                        <div class="col-6">
                            <div class="border rounded p-2">
                                <i class="fas fa-th-large text-primary mb-1"></i>
                                <div class="fw-bold">${contrat.unite.nombrePieces}</div>
                                <small class="text-muted">Pièces</small>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="border rounded p-2">
                                <i class="fas fa-ruler-combined text-primary mb-1"></i>
                                <div class="fw-bold">${contrat.unite.superficie}</div>
                                <small class="text-muted">m²</small>
                            </div>
                        </div>
                    </div>

                    <div class="row text-center mt-2">
                        <div class="col-6">
                            <div class="border rounded p-2">
                                <i class="fas fa-layer-group text-primary mb-1"></i>
                                <div class="fw-bold">${contrat.unite.etage}</div>
                                <small class="text-muted">Étage</small>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="border rounded p-2">
                                <i class="fas fa-calendar-day text-primary mb-1"></i>
                                <div class="fw-bold">${contrat.jourPaiement}</div>
                                <small class="text-muted">Jour paiement</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function downloadContract() {
        // Simuler le téléchargement
        alert('Fonctionnalité de téléchargement en cours de développement');
        // TODO: Implémenter le téléchargement réel
        // window.location.href = `${pageContext.request.contextPath}/locataire/contrat/${contrat.id}/download`;
    }

    function printContract() {
        window.print();
    }

    function contactOwner() {
        const email = '${contrat.unite.immeuble.proprietaire.email}';
        const subject = 'Contact concernant le logement ${contrat.unite.immeuble.nom} - Unité ${contrat.unite.numero}';
        const body = 'Bonjour,\\n\\nJe vous contacte concernant mon logement.\\n\\nCordialement,\\n${sessionScope.utilisateur.prenom} ${sessionScope.utilisateur.nom}';

        // Encodage manuel simple pour éviter les problèmes avec encodeURIComponent dans JSP
        const encodedSubject = subject.replace(/ /g, '%20').replace(/\n/g, '%0A');
        const encodedBody = body.replace(/ /g, '%20').replace(/\n/g, '%0A');

        const mailtoLink = 'mailto:' + email + '?subject=' + encodedSubject + '&body=' + encodedBody;
        window.location.href = mailtoLink;
    }

    // Animation pour les alertes
    document.addEventListener('DOMContentLoaded', function() {
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert-dismissible');
            alerts.forEach(alert => {
                alert.style.opacity = '0';
                alert.style.transition = 'opacity 0.5s';
                setTimeout(() => alert.remove(), 500);
            });
        }, 5000);

        // Effet hover pour les cartes de paiement
        const paymentItems = document.querySelectorAll('.payment-item');
        paymentItems.forEach(item => {
            item.addEventListener('mouseenter', function() {
                this.style.borderLeftWidth = '6px';
            });
            item.addEventListener('mouseleave', function() {
                this.style.borderLeftWidth = '4px';
            });
        });
    });

    // Fonction utilitaire pour formater les montants
    function formatCurrency(amount) {
        return new Intl.NumberFormat('fr-SN', {
            minimumFractionDigits: 0,
            maximumFractionDigits: 0
        }).format(amount).replace(/\s/g, ' ') + ' F CFA';
    }
</script>
</body>
</html>