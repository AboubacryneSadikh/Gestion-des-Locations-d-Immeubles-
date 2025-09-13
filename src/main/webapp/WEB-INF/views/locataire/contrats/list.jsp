<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="pageTitle" value="Mes Contrats - Locataire" scope="request"/>

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

        .contract-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            border: none;
            margin-bottom: 20px;
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .contract-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .contract-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 20px;
        }

        .property-info {
            flex: 1;
        }

        .status-badge {
            padding: 8px 16px;
            border-radius: 25px;
            font-size: 0.9rem;
            font-weight: 600;
            margin-left: 15px;
        }

        .status-en-cours {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }

        .status-termine {
            background: #f8d7da;
            color: #721c24;
        }

        .status-suspendu {
            background: #fff3cd;
            color: #856404;
        }

        .contract-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .detail-item {
            display: flex;
            align-items: center;
        }

        .detail-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #f8f9fa;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 12px;
            color: #667eea;
        }

        .detail-content .label {
            font-size: 0.85rem;
            color: #6c757d;
            margin-bottom: 2px;
        }

        .detail-content .value {
            font-weight: 600;
            color: #495057;
        }

        .contract-actions {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #f8f9fa;
        }

        .user-info {
            color: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 20px;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 20px;
            opacity: 0.5;
        }

        .stats-overview {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            border: none;
            margin-bottom: 30px;
        }

        .stat-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 20px;
        }

        .stat-item {
            text-align: center;
            padding: 15px;
            border-radius: 10px;
            background: #f8f9fa;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: #667eea;
            margin-bottom: 5px;
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
    <!-- Top Bar -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0">Mes Contrats de Location</h2>
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

    <c:choose>
        <c:when test="${not empty contrats}">
            <!-- Statistiques rapides -->
            <div class="stats-overview">
                <h5 class="mb-3">
                    <i class="fas fa-chart-pie me-2 text-primary"></i>
                    Vue d'ensemble
                </h5>
                <div class="stat-grid">
                    <div class="stat-item">
                        <div class="stat-number">${contrats.size()}</div>
                        <div class="stat-label">Total contrats</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">
                            <c:set var="contratsActifs" value="0"/>
                            <c:forEach var="contrat" items="${contrats}">
                                <c:if test="${contrat.statut eq 'EN_COURS'}">
                                    <c:set var="contratsActifs" value="${contratsActifs + 1}"/>
                                </c:if>
                            </c:forEach>
                                ${contratsActifs}
                        </div>
                        <div class="stat-label">Contrats actifs</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">
                            <c:set var="contratsTermines" value="0"/>
                            <c:forEach var="contrat" items="${contrats}">
                                <c:if test="${contrat.statut eq 'TERMINE' or contrat.statut eq 'RESILIE'}">
                                    <c:set var="contratsTermines" value="${contratsTermines + 1}"/>
                                </c:if>
                            </c:forEach>
                                ${contratsTermines}
                        </div>
                        <div class="stat-label">Contrats terminés</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">
                            <c:set var="loyerTotal" value="0"/>
                            <c:forEach var="contrat" items="${contrats}">
                                <c:if test="${contrat.statut == 'EN_COURS'}">
                                    <c:set var="loyerTotal" value="${loyerTotal + contrat.loyer}"/>
                                </c:if>
                            </c:forEach>
                            <fmt:formatNumber value="${loyerTotal}" type="currency" currencySymbol="€"/>
                        </div>
                        <div class="stat-label">Loyer total/mois</div>
                    </div>
                </div>
            </div>

            <!-- Liste des contrats -->
            <c:forEach var="contrat" items="${contrats}">
                <div class="contract-card">
                    <div class="contract-header">
                        <div class="property-info">
                            <h5 class="mb-1">
                                    ${contrat.unite.immeuble.nom} - Unité ${contrat.unite.numero}
                            </h5>
                            <p class="text-muted mb-0">
                                <i class="fas fa-map-marker-alt me-1"></i>
                                    ${contrat.unite.immeuble.adresse}, ${contrat.unite.immeuble.ville}
                            </p>
                        </div>
                        <span class="status-badge status-${fn:toLowerCase(fn:replace(contrat.statut, '_', '-'))}">
    <c:choose>
        <c:when test="${contrat.statut == 'EN_COURS'}">En cours</c:when>
        <c:when test="${contrat.statut == 'TERMINE'}">Terminé</c:when>
        <c:when test="${contrat.statut == 'RESILIE'}">Résilié</c:when>
        <c:when test="${contrat.statut == 'EN_ATTENTE'}">En attente</c:when>
        <c:when test="${contrat.statut == 'SUSPENDU'}">Suspendu</c:when>
        <c:otherwise>${contrat.statut}</c:otherwise>
    </c:choose>
</span>
                    </div>

                    <div class="contract-details">
                        <div class="detail-item">
                            <div class="detail-icon">
                                <i class="fas fa-calendar-alt"></i>
                            </div>
                            <div class="detail-content">
                                <div class="label">Date de début</div>
                                <div class="value">
                                    <fmt:formatDate value="${contrat.dateDebut}" pattern="dd/MM/yyyy"/>
                                </div>
                            </div>
                        </div>

                        <div class="detail-item">
                            <div class="detail-icon">
                                <i class="fas fa-calendar-check"></i>
                            </div>
                            <div class="detail-content">
                                <div class="label">Date de fin</div>
                                <div class="value">
                                    <fmt:formatDate value="${contrat.dateFin}" pattern="dd/MM/yyyy"/>
                                </div>
                            </div>
                        </div>

                        <div class="detail-item">
                            <div class="detail-icon">
                                <i class="fas fa-euro-sign"></i>
                            </div>
                            <div class="detail-content">
                                <div class="label">Loyer mensuel</div>
                                <div class="fw-bold text-success">
                                    <fmt:formatNumber value="${contrat.loyer}" type="currency" currencySymbol="€"/>
                                </div>
                            </div>
                        </div>



                        <div class="detail-item">
                            <div class="detail-icon">
                                <i class="fas fa-th-large"></i>
                            </div>
                            <div class="detail-content">
                                <div class="label">Logement</div>
                                <div class="value">
                                        ${contrat.unite.nombrePieces} pièce(s) - ${contrat.unite.superficie} m²
                                </div>
                            </div>
                        </div>

                        <div class="detail-item">
                            <div class="detail-icon">
                                <i class="fas fa-clock"></i>
                            </div>
                            <div class="detail-content">
                                <div class="label">Durée</div>
                                <div class="value">
                                    <c:set var="startDate" value="${contrat.dateDebut}"/>
                                    <c:set var="endDate" value="${contrat.dateFin}"/>
                                    <c:set var="diffInMillies" value="${endDate.time - startDate.time}"/>
                                    <c:set var="diffInMonths" value="${diffInMillies / (1000 * 60 * 60 * 24 * 30)}"/>
                                    <fmt:formatNumber value="${diffInMonths}" maxFractionDigits="0"/> mois
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="contract-actions">
                        <a href="${pageContext.request.contextPath}/locataire/contrat?id=${contrat.id}"
                           class="btn btn-outline-primary">
                            <i class="fas fa-eye me-1"></i>Voir détails
                        </a>

                        <c:if test="${contrat.statut == 'EN_COURS'}">
                            <a href="${pageContext.request.contextPath}/locataire/paiements?contrat=${contrat.id}"
                               class="btn btn-outline-success">
                                <i class="fas fa-credit-card me-1"></i>Paiements
                            </a>
                        </c:if>

                        <div class="dropdown">
                            <button class="btn btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                <i class="fas fa-ellipsis-h"></i>
                            </button>
                            <ul class="dropdown-menu">
                                <li>
                                    <a class="dropdown-item" href="#" onclick="downloadContract(${contrat.id})">
                                        <i class="fas fa-download me-2"></i>Télécharger
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="#" onclick="printContract(${contrat.id})">
                                        <i class="fas fa-print me-2"></i>Imprimer
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item" href="#" onclick="contactOwner(${contrat.unite.immeuble.proprietaire.id})">
                                        <i class="fas fa-envelope me-2"></i>Contacter le propriétaire
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <!-- État vide -->
            <div class="contract-card">
                <div class="empty-state">
                    <i class="fas fa-file-contract"></i>
                    <h4 class="mb-3">Aucun contrat de location</h4>
                    <p class="mb-4">
                        Vous n'avez encore aucun contrat de location.
                        Recherchez un logement qui vous intéresse et postulez pour commencer.
                    </p>
                    <a href="${pageContext.request.contextPath}/locataire/recherche"
                       class="btn btn-primary btn-lg">
                        <i class="fas fa-search me-2"></i>Rechercher un logement
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function downloadContract(contractId) {
        // Logique pour télécharger le contrat
        console.log('Télécharger contrat:', contractId);
        alert('Fonctionnalité de téléchargement à implémenter');
    }

    function printContract(contractId) {
        // Logique pour imprimer le contrat
        console.log('Imprimer contrat:', contractId);
        window.open(`${pageContext.request.contextPath}/locataire/contrat/${contractId}/print`, '_blank');
    }

    function contactOwner(ownerId) {
        // Logique pour contacter le propriétaire
        console.log('Contacter propriétaire:', ownerId);
        alert('Fonctionnalité de contact à implémenter');
    }
</script>
</body>
</html>