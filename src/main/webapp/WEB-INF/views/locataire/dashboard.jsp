<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Tableau de bord - Locataire" scope="request"/>

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

        .stats-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            border: none;
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        }

        .stats-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: white;
        }

        .stats-number {
            font-size: 2.5rem;
            font-weight: 700;
            color: #2c3e50;
            margin: 10px 0;
        }

        .user-info {
            color: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 20px;
        }

        .payment-item {
            background: white;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            border-left: 4px solid #dee2e6;
        }

        .payment-item.en-attente {
            border-left-color: #ffc107;
        }

        .payment-item.en-retard {
            border-left-color: #dc3545;
        }

        .payment-item.paye {
            border-left-color: #28a745;
        }

        .contract-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        }

        .status-badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .status-en-cours {
            background: #d4edda;
            color: #155724;
        }

        .status-termine {
            background: #f8d7da;
            color: #721c24;
        }

        .welcome-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            position: relative;
            overflow: hidden;
        }

        .welcome-section::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -20%;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
        }

        .urgent-alert {
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { opacity: 1; }
            50% { opacity: 0.7; }
            100% { opacity: 1; }
        }

        .action-btn {
            transition: all 0.3s;
        }

        .action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        .notification-badge {
            position: absolute;
            top: -5px;
            right: -5px;
            background: #dc3545;
            color: white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            font-size: 0.7rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
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
            <a class="nav-link active" href="${pageContext.request.contextPath}/locataire/dashboard">
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
            <a class="nav-link" href="${pageContext.request.contextPath}/locataire/contrats">
                <i class="fas fa-file-contract me-2"></i>Mes Contrats
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link position-relative" href="${pageContext.request.contextPath}/locataire/paiements">
                <i class="fas fa-credit-card me-2"></i>Mes Paiements
                <c:if test="${not empty paiementsEnRetard and paiementsEnRetard.size() > 0}">
                    <span class="notification-badge">${paiementsEnRetard.size()}</span>
                </c:if>
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
        <h2 class="mb-0">Tableau de bord locataire</h2>
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

    <!-- Alerte pour paiements en retard -->
    <c:if test="${not empty paiementsEnRetard and paiementsEnRetard.size() > 0}">
        <!-- Trouve le premier paiement en retard -->
        <c:set var="firstOverduePayment" value="" />
        <c:forEach var="paiement" items="${paiementsEnRetard}" varStatus="status">
            <c:if test="${status.first}">
                <c:set var="firstOverduePayment" value="${paiement}" />
            </c:if>
        </c:forEach>

        <div class="alert alert-danger urgent-alert d-flex align-items-center" role="alert">
            <i class="fas fa-exclamation-triangle me-3 fa-2x"></i>
            <div class="flex-grow-1">
                <h5 class="alert-heading mb-2">Paiements en retard !</h5>
                <p class="mb-2">
                    Vous avez <strong>${paiementsEnRetard.size()} paiement(s)</strong> en retard.
                    Régularisez votre situation rapidement pour éviter des frais supplémentaires.
                </p>
            </div>
            <div>
                <c:choose>
                    <c:when test="${not empty firstOverduePayment}">
                        <a href="${pageContext.request.contextPath}/locataire/paiement?id=${firstOverduePayment.id}"
                           class="btn btn-light btn-lg">
                            <i class="fas fa-credit-card me-2"></i>Payer maintenant
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/locataire/paiements"
                           class="btn btn-light btn-lg">
                            <i class="fas fa-credit-card me-2"></i>Voir les paiements
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </c:if>

    <!-- Section de bienvenue -->
    <div class="welcome-section">
        <div class="row align-items-center">
            <div class="col-md-8">
                <h3 class="mb-2">Bienvenue, ${sessionScope.utilisateur.prenom} ${sessionScope.utilisateur.nom}</h3>
                <p class="mb-0">Gérez vos locations et paiements en toute simplicité</p>
                <c:if test="${not empty paiementsEnAttente and paiementsEnAttente.size() > 0}">
                    <div class="mt-3">
                        <small class="opacity-75">
                            <i class="fas fa-info-circle me-1"></i>
                            Vous avez ${paiementsEnAttente.size()} paiement(s) à venir
                        </small>
                    </div>
                </c:if>
            </div>
            <div class="col-md-4 text-end">
                <i class="fas fa-home fa-5x opacity-50"></i>
            </div>
        </div>
    </div>

    <!-- Statistiques -->
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="card stats-card text-center">
                <div class="stats-icon mx-auto" style="background: linear-gradient(135deg, #28a745 0%, #20c997 100%);">
                    <i class="fas fa-file-contract"></i>
                </div>
                <div class="stats-number">${totalContrats}</div>
                <h6 class="text-muted">Total Contrats</h6>
                <small class="text-muted">
                    <c:choose>
                        <c:when test="${totalContrats == 0}">Aucun contrat</c:when>
                        <c:when test="${totalContrats == 1}">Contrat unique</c:when>
                        <c:otherwise>Contrats multiples</c:otherwise>
                    </c:choose>
                </small>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card stats-card text-center">
                <div class="stats-icon mx-auto" style="background: linear-gradient(135deg, #007bff 0%, #6f42c1 100%);">
                    <i class="fas fa-play-circle"></i>
                </div>
                <div class="stats-number">${contratsActifs.size()}</div>
                <h6 class="text-muted">Contrats Actifs</h6>
                <small class="text-success">
                    <i class="fas fa-check-circle me-1"></i>En cours
                </small>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card stats-card text-center">
                <div class="stats-icon mx-auto" style="background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);">
                    <i class="fas fa-clock"></i>
                </div>
                <div class="stats-number">${paiementsEnAttente.size()}</div>
                <h6 class="text-muted">Paiements en Attente</h6>
                <small class="text-warning">
                    <i class="fas fa-hourglass-half me-1"></i>À venir
                </small>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card stats-card text-center">
                <div class="stats-icon mx-auto" style="background: linear-gradient(135deg, #dc3545 0%, #e83e8c 100%);">
                    <i class="fas fa-exclamation-triangle"></i>
                </div>
                <div class="stats-number">${paiementsEnRetard.size()}</div>
                <h6 class="text-muted">Paiements en Retard</h6>
                <small class="text-danger">
                    <i class="fas fa-exclamation-triangle me-1"></i>Urgent
                </small>
            </div>
        </div>
    </div>

    <!-- Contrats actifs et paiements -->
    <div class="row">
        <div class="col-md-8">
            <div class="card stats-card">
                <h5 class="mb-3">
                    <i class="fas fa-file-contract me-2 text-primary"></i>
                    Mes Contrats Actifs
                </h5>
                <c:choose>
                    <c:when test="${not empty contratsActifs}">
                        <c:forEach var="contrat" items="${contratsActifs}">
                            <div class="contract-card">
                                <div class="row align-items-center">
                                    <div class="col-md-8">
                                        <h6 class="mb-1">
                                                ${contrat.unite.immeuble.nom} - Unité ${contrat.unite.numero}
                                        </h6>
                                        <small class="text-muted">
                                            <i class="fas fa-map-marker-alt me-1"></i>
                                                ${contrat.unite.immeuble.adresse}, ${contrat.unite.immeuble.ville}
                                        </small>
                                        <br>
                                        <small class="text-muted">
                                            <i class="fas fa-calendar me-1"></i>
                                            Du <fmt:formatDate value="${contrat.dateDebut}" pattern="dd/MM/yyyy"/>
                                            au <fmt:formatDate value="${contrat.dateFin}" pattern="dd/MM/yyyy"/>
                                        </small>
                                        <br>
                                        <small class="text-muted">
                                            <i class="fas fa-home me-1"></i>
                                                ${contrat.unite.nombrePieces} pièce(s) - ${contrat.unite.superficie} m²
                                        </small>
                                    </div>
                                    <div class="col-md-4 text-end">
                                        <div class="mb-2">
                                            <span class="status-badge status-en-cours">
                                                <i class="fas fa-play-circle me-1"></i>En cours
                                            </span>
                                        </div>
                                        <div class="fw-bold text-success mb-2">
                                            <fmt:formatNumber value="${contrat.loyer}" pattern="#,##0" /> F CFA
                                        </div>
                                        <div>
                                            <a href="${pageContext.request.contextPath}/locataire/contrat?id=${contrat.id}"
                                               class="btn btn-outline-primary btn-sm me-1">
                                                <i class="fas fa-eye me-1"></i>Détails
                                            </a>
                                            <!-- Vérifier s'il y a des paiements en retard pour ce contrat -->
                                            <c:set var="hasOverduePayments" value="false"/>
                                            <c:forEach var="paiement" items="${paiementsEnRetard}">
                                                <c:if test="${paiement.contrat.id == contrat.id}">
                                                    <c:set var="hasOverduePayments" value="true"/>
                                                </c:if>
                                            </c:forEach>

                                            <c:choose>
                                                <c:when test="${hasOverduePayments}">
                                                    <a href="${pageContext.request.contextPath}/locataire/paiement?contratId=${contrat.id}"
                                                       class="btn btn-danger btn-sm">
                                                        <i class="fas fa-exclamation-triangle me-1"></i>Payer
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/locataire/paiement?contratId=${contrat.id}"
                                                       class="btn btn-success btn-sm">
                                                        <i class="fas fa-credit-card me-1"></i>Payer
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5">
                            <i class="fas fa-file-contract fa-4x text-muted mb-3"></i>
                            <h5 class="text-muted mb-3">Aucun contrat actif</h5>
                            <p class="text-muted mb-4">
                                Vous n'avez pas encore de contrat de location actif.
                                Recherchez et candidatez pour un logement.
                            </p>
                            <a href="${pageContext.request.contextPath}/locataire/recherche"
                               class="btn btn-primary btn-lg action-btn">
                                <i class="fas fa-search me-2"></i>Rechercher un logement
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card stats-card">
                <h5 class="mb-3">
                    <i class="fas fa-credit-card me-2 text-primary"></i>
                    Paiements Récents
                </h5>
                <div style="max-height: 400px; overflow-y: auto;">
                    <c:choose>
                        <c:when test="${not empty derniersPaiements}">
                            <c:forEach var="paiement" items="${derniersPaiements}">
                                <div class="payment-item ${paiement.statut.toString().toLowerCase().replace('_', '-')}">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <div class="fw-bold">
                                                <fmt:formatNumber value="${paiement.montant}" pattern="#,##0" /> F CFA
                                            </div>
                                            <small class="text-muted">
                                                <c:choose>
                                                    <c:when test="${paiement.statut == 'PAYE' and not empty paiement.datePaiement}">
                                                        <i class="fas fa-check me-1"></i>
                                                        <fmt:formatDate value="${paiement.datePaiement}" pattern="dd/MM/yyyy"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="fas fa-calendar me-1"></i>
                                                        Échéance: <fmt:formatDate value="${paiement.dateEcheance}" pattern="dd/MM/yyyy"/>
                                                    </c:otherwise>
                                                </c:choose>
                                            </small>
                                        </div>
                                        <div class="text-end">
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
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-4">
                                <i class="fas fa-credit-card fa-3x text-muted mb-3"></i>
                                <p class="text-muted">Aucun paiement récent</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <c:if test="${not empty paiementsEnAttente or not empty paiementsEnRetard}">
                    <div class="mt-3 pt-3 border-top">
                        <a href="${pageContext.request.contextPath}/locataire/paiements"
                           class="btn btn-outline-primary w-100 action-btn">
                            <i class="fas fa-list me-2"></i>Voir tous les paiements
                        </a>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <!-- Actions rapides -->
    <div class="row mt-4">
        <div class="col-12">
            <div class="card stats-card">
                <h5 class="mb-3">
                    <i class="fas fa-bolt me-2 text-warning"></i>
                    Actions rapides
                </h5>
                <div class="row">
                    <div class="col-md-3">
                        <c:choose>
                            <c:when test="${not empty paiementsEnRetard and paiementsEnRetard.size() > 0}">
                                <!-- Utilise le premier paiement en retard -->
                                <c:set var="firstOverduePayment" value="" />
                                <c:forEach var="paiement" items="${paiementsEnRetard}" varStatus="status">
                                    <c:if test="${status.first}">
                                        <c:set var="firstOverduePayment" value="${paiement}" />
                                    </c:if>
                                </c:forEach>

                                <c:choose>
                                    <c:when test="${not empty firstOverduePayment}">
                                        <a href="${pageContext.request.contextPath}/locataire/paiement?id=${firstOverduePayment.id}"
                                           class="btn btn-danger w-100 mb-2 action-btn">
                                            <i class="fas fa-credit-card me-2"></i>
                                            Payer maintenant (${paiementsEnRetard.size()})
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/locataire/paiements"
                                           class="btn btn-danger w-100 mb-2 action-btn">
                                            <i class="fas fa-credit-card me-2"></i>
                                            Paiements en retard (${paiementsEnRetard.size()})
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:when test="${not empty paiementsEnAttente and paiementsEnAttente.size() > 0}">
                                <!-- Utilise le premier paiement en attente -->
                                <c:set var="firstPendingPayment" value="" />
                                <c:forEach var="paiement" items="${paiementsEnAttente}" varStatus="status">
                                    <c:if test="${status.first}">
                                        <c:set var="firstPendingPayment" value="${paiement}" />
                                    </c:if>
                                </c:forEach>

                                <c:choose>
                                    <c:when test="${not empty firstPendingPayment}">
                                        <a href="${pageContext.request.contextPath}/locataire/paiement?id=${firstPendingPayment.id}"
                                           class="btn btn-warning w-100 mb-2 action-btn">
                                            <i class="fas fa-credit-card me-2"></i>
                                            Paiements à venir (${paiementsEnAttente.size()})
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/locataire/paiements"
                                           class="btn btn-warning w-100 mb-2 action-btn">
                                            <i class="fas fa-credit-card me-2"></i>
                                            Paiements à venir (${paiementsEnAttente.size()})
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/locataire/recherche"
                                   class="btn btn-outline-primary w-100 mb-2 action-btn">
                                    <i class="fas fa-search me-2"></i>
                                    Rechercher un logement
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="col-md-3">
                        <a href="${pageContext.request.contextPath}/locataire/profile"
                           class="btn btn-outline-success w-100 mb-2 action-btn">
                            <i class="fas fa-user-edit me-2"></i>
                            Modifier mon profil
                        </a>
                    </div>
                    <div class="col-md-3">
                        <a href="${pageContext.request.contextPath}/locataire/paiements"
                           class="btn btn-outline-info w-100 mb-2 action-btn">
                            <i class="fas fa-credit-card me-2"></i>
                            Historique paiements
                        </a>
                    </div>
                    <div class="col-md-3">
                        <a href="${pageContext.request.contextPath}/locataire/contrats"
                           class="btn btn-outline-secondary w-100 mb-2 action-btn">
                            <i class="fas fa-file-alt me-2"></i>
                            Mes contrats
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Informations utiles -->
    <c:if test="${not empty contratsActifs and contratsActifs.size() > 0}">
        <div class="row mt-4">
            <div class="col-md-6">
                <div class="card stats-card">
                    <h6 class="mb-3">
                        <i class="fas fa-info-circle me-2 text-info"></i>
                        Prochaines échéances
                    </h6>
                    <c:choose>
                        <c:when test="${not empty paiementsEnAttente}">
                            <c:forEach var="paiement" items="${paiementsEnAttente}" end="2">
                                <div class="d-flex justify-content-between align-items-center mb-2 p-2 bg-light rounded">
                                    <div>
                                        <small class="text-muted">Échéance</small>
                                        <div class="fw-bold">
                                            <fmt:formatDate value="${paiement.dateEcheance}" pattern="dd/MM/yyyy"/>
                                        </div>
                                    </div>
                                    <div class="text-end">
                                        <div class="fw-bold text-primary">
                                            <fmt:formatNumber value="${paiement.montant}" pattern="#,##0" /> F CFA
                                        </div>
                                        <small class="text-muted">Loyer</small>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted mb-0">Aucune échéance à venir</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card stats-card">
                    <h6 class="mb-3">
                        <i class="fas fa-home me-2 text-success"></i>
                        Mes logements
                    </h6>
                    <c:forEach var="contrat" items="${contratsActifs}" end="2">
                        <div class="d-flex align-items-center mb-2 p-2 bg-light rounded">
                            <div class="me-2">
                                <i class="fas fa-door-open text-success"></i>
                            </div>
                            <div class="flex-grow-1">
                                <div class="fw-bold">${contrat.unite.immeuble.nom}</div>
                                <small class="text-muted">Unité ${contrat.unite.numero} - ${contrat.unite.nombrePieces} pièces</small>
                            </div>
                            <div class="text-end">
                                <small class="text-success fw-bold">
                                    <fmt:formatNumber value="${contrat.loyer}" pattern="#,##0" /> F CFA
                                </small>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </c:if>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Animation pour les alertes
    document.addEventListener('DOMContentLoaded', function() {
        // Auto-dismiss des alertes après 5 secondes
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert-dismissible:not(.urgent-alert)');
            alerts.forEach(alert => {
                alert.style.opacity = '0';
                alert.style.transition = 'opacity 0.5s';
                setTimeout(() => {
                    if (alert.parentNode) {
                        alert.remove();
                    }
                }, 500);
            });
        }, 5000);

        // Highlight des actions urgentes
        const urgentButtons = document.querySelectorAll('.btn-danger');
        urgentButtons.forEach(btn => {
            btn.addEventListener('mouseenter', function() {
                this.style.transform = 'scale(1.05)';
            });
            btn.addEventListener('mouseleave', function() {
                this.style.transform = 'scale(1)';
            });
        });
    });

    // Fonction pour formater les montants
    function formatCurrency(amount) {
        return new Intl.NumberFormat('fr-SN', {
            minimumFractionDigits: 0,
            maximumFractionDigits: 0
        }).format(amount).replace(/\s/g, ' ') + ' F CFA';
    }
</script>
</body>
</html>