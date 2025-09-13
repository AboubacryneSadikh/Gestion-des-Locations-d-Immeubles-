<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Tableau de bord - Propriétaire" scope="request"/>

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
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        .sidebar {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
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
            height: 100%;
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

        .recent-properties {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            max-height: 500px;
            overflow-y: auto;
        }

        .property-item {
            padding: 15px 0;
            border-bottom: 1px solid #eee;
            display: flex;
            align-items: center;
        }

        .property-item:last-child {
            border-bottom: none;
        }

        .property-icon {
            width: 50px;
            height: 50px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            color: white;
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
        }

        .contracts-expiring {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        }

        .contract-item {
            padding: 12px 15px;
            margin-bottom: 10px;
            background: #f8f9fa;
            border-radius: 10px;
            border-left: 4px solid #ffc107;
        }

        .candidature-item {
            padding: 12px 15px;
            margin-bottom: 10px;
            background: #f8f9fa;
            border-radius: 10px;
            border-left: 4px solid #17a2b8;
        }

        .quick-actions .btn {
            border-radius: 10px;
            padding: 15px;
            font-weight: 600;
            text-decoration: none;
            display: block;
            margin-bottom: 10px;
            transition: all 0.3s;
        }

        .quick-actions .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }

        .notification-badge {
            background: #dc3545;
            color: white;
            border-radius: 50%;
            padding: 2px 6px;
            font-size: 0.75rem;
            font-weight: 600;
            margin-left: 5px;
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
            <a class="nav-link active" href="${pageContext.request.contextPath}/proprietaire/dashboard">
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
                <c:if test="${candidaturesEnAttente > 0}">
                    <span class="notification-badge">${candidaturesEnAttente}</span>
                </c:if>
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/proprietaire/contrats">
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
    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="mb-0">Tableau de bord</h2>
            <p class="text-muted mb-0">Vue d'ensemble de votre patrimoine immobilier</p>
        </div>
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

    <!-- Statistiques principales -->
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="card stats-card text-center">
                <div class="stats-icon mx-auto" style="background: linear-gradient(135deg, #28a745 0%, #20c997 100%);">
                    <i class="fas fa-building"></i>
                </div>
                <div class="stats-number">${totalImmeubles}</div>
                <h6 class="text-muted">Immeubles</h6>
                <small class="text-success">
                    <i class="fas fa-arrow-up"></i> Portfolio actif
                </small>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card stats-card text-center">
                <div class="stats-icon mx-auto" style="background: linear-gradient(135deg, #007bff 0%, #6610f2 100%);">
                    <i class="fas fa-door-open"></i>
                </div>
                <div class="stats-number">${totalUnites}</div>
                <h6 class="text-muted">Unités totales</h6>
                <small class="text-info">
                    <i class="fas fa-home"></i> Logements
                </small>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card stats-card text-center">
                <div class="stats-icon mx-auto" style="background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);">
                    <i class="fas fa-user-check"></i>
                </div>
                <div class="stats-number">${candidaturesEnAttente != null ? candidaturesEnAttente : 0}</div>
                <h6 class="text-muted">Candidatures</h6>
                <small class="text-warning">
                    <i class="fas fa-clock"></i> En attente
                </small>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card stats-card text-center">
                <div class="stats-icon mx-auto" style="background: linear-gradient(135deg, #dc3545 0%, #e83e8c 100%);">
                    <i class="fas fa-handshake"></i>
                </div>
                <div class="stats-number">${unitesLouees}</div>
                <h6 class="text-muted">Louées</h6>
                <small class="text-danger">
                    <i class="fas fa-check"></i> Contrats actifs
                </small>
            </div>
        </div>
    </div>

    <!-- Taux d'occupation -->
    <div class="row mb-4">
        <div class="col-md-12">
            <div class="card stats-card">
                <div class="row">
                    <div class="col-md-8">
                        <h5 class="mb-3">
                            <i class="fas fa-chart-pie me-2 text-success"></i>
                            Taux d'occupation
                        </h5>
                        <c:set var="tauxOccupation" value="${totalUnites > 0 ? (unitesLouees * 100.0 / totalUnites) : 0}"/>
                        <div class="progress" style="height: 30px;">
                            <div class="progress-bar bg-success" role="progressbar"
                                 style="width: ${tauxOccupation}%"
                                 aria-valuenow="${tauxOccupation}"
                                 aria-valuemin="0" aria-valuemax="100">
                                <fmt:formatNumber value="${tauxOccupation}" type="number" maxFractionDigits="1"/>%
                            </div>
                        </div>
                        <div class="d-flex justify-content-between mt-2">
                            <small class="text-success">Louées: ${unitesLouees}</small>
                            <small class="text-warning">Disponibles: ${unitesDisponibles}</small>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <canvas id="occupationChart" width="200" height="200"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Contenu principal -->
    <div class="row">
        <!-- Candidatures récentes -->
        <div class="col-md-6">
            <div class="recent-properties">
                <h5 class="mb-3">
                    <i class="fas fa-user-check me-2 text-info"></i>
                    Candidatures récentes
                </h5>
                <c:choose>
                    <c:when test="${not empty candidaturesRecentes}">
                        <c:forEach var="candidature" items="${candidaturesRecentes}">
                            <div class="candidature-item">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <div class="fw-bold">
                                                ${candidature.locataire.utilisateur.prenom} ${candidature.locataire.utilisateur.nom}
                                        </div>
                                        <small class="text-muted">
                                                ${candidature.unite.immeuble.nom} - Unité ${candidature.unite.numero}
                                        </small>
                                        <br>
                                        <small class="text-info">
                                            <fmt:formatDate value="${candidature.dateCreation}" pattern="dd/MM/yyyy"/>
                                        </small>
                                    </div>
                                    <div class="text-end">
                                        <c:choose>
                                            <c:when test="${candidature.statut == 'EN_ATTENTE'}">
                                                <span class="badge bg-warning">En attente</span>
                                                <br>
                                                <a href="${pageContext.request.contextPath}/proprietaire/candidatures/manage?id=${candidature.id}"
                                                   class="btn btn-sm btn-outline-warning mt-1">
                                                    <i class="fas fa-cogs"></i>
                                                </a>
                                            </c:when>
                                            <c:when test="${candidature.statut == 'APPROUVEE'}">
                                                <span class="badge bg-success">Approuvée</span>
                                            </c:when>
                                            <c:when test="${candidature.statut == 'REFUSEE'}">
                                                <span class="badge bg-danger">Refusée</span>
                                            </c:when>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                        <div class="text-center mt-3">
                            <a href="${pageContext.request.contextPath}/proprietaire/candidatures"
                               class="btn btn-sm btn-outline-info">
                                <i class="fas fa-eye me-1"></i>
                                Voir toutes les candidatures
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-4">
                            <i class="fas fa-user-check fa-3x text-muted mb-3"></i>
                            <p class="text-muted">Aucune candidature récente</p>
                            <a href="${pageContext.request.contextPath}/proprietaire/unites"
                               class="btn btn-info btn-sm">
                                <i class="fas fa-door-open me-2"></i>Voir mes unités
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Contrats expirant -->
        <div class="col-md-6">
            <div class="contracts-expiring">
                <h5 class="mb-3">
                    <i class="fas fa-exclamation-triangle me-2 text-warning"></i>
                    Contrats expirant (30 jours)
                </h5>
                <c:choose>
                    <c:when test="${not empty contratsExpirant}">
                        <c:forEach var="contrat" items="${contratsExpirant}" varStatus="loop">
                            <c:if test="${loop.index < 5}">
                                <div class="contract-item">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <div class="fw-bold">
                                                    ${contrat.locataire.utilisateur.prenom} ${contrat.locataire.utilisateur.nom}
                                            </div>
                                            <small class="text-muted">
                                                    ${contrat.unite.immeuble.nom} - Unité ${contrat.unite.numero}
                                            </small>
                                        </div>
                                        <div class="text-end">
                                            <div class="fw-bold text-warning">
                                                <fmt:formatDate value="${contrat.dateFin}" pattern="dd/MM/yyyy"/>
                                            </div>
                                            <small class="text-muted">Expiration</small>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                        <c:if test="${contratsExpirant.size() > 5}">
                            <div class="text-center mt-3">
                                <a href="${pageContext.request.contextPath}/proprietaire/contrats"
                                   class="btn btn-sm btn-outline-warning">
                                    Voir tous les contrats (${contratsExpirant.size()})
                                </a>
                            </div>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-4">
                            <i class="fas fa-check-circle fa-3x text-success mb-3"></i>
                            <p class="text-muted">Aucun contrat n'expire dans les 30 prochains jours</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Immeubles récents -->
    <div class="row mt-4">
        <div class="col-12">
            <div class="recent-properties">
                <h5 class="mb-3">
                    <i class="fas fa-building me-2 text-success"></i>
                    Immeubles récents
                </h5>
                <c:choose>
                    <c:when test="${not empty recentImmeubles}">
                        <div class="row">
                            <c:forEach var="immeuble" items="${recentImmeubles}" varStatus="loop">
                                <c:if test="${loop.index < 6}">
                                    <div class="col-md-6">
                                        <div class="property-item">
                                            <div class="property-icon">
                                                <i class="fas fa-building"></i>
                                            </div>
                                            <div class="flex-grow-1">
                                                <div class="fw-bold">${immeuble.nom}</div>
                                                <small class="text-muted">${immeuble.adresse}, ${immeuble.ville}</small>
                                                <br>
                                                <small class="text-success">
                                                    <i class="fas fa-door-open me-1"></i>
                                                        ${immeuble.nombreUnites != null ? immeuble.nombreUnites : 0} unité(s)
                                                </small>
                                                <small class="text-muted ms-3">
                                                    <fmt:formatDate value="${immeuble.dateCreation}" pattern="dd/MM/yyyy"/>
                                                </small>
                                            </div>
                                            <div class="text-end">
                                                <a href="${pageContext.request.contextPath}/proprietaire/immeubles/view?id=${immeuble.id}"
                                                   class="btn btn-sm btn-outline-success">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-4">
                            <i class="fas fa-building fa-3x text-muted mb-3"></i>
                            <p class="text-muted">Aucun immeuble enregistré</p>
                            <a href="${pageContext.request.contextPath}/proprietaire/immeubles/create"
                               class="btn btn-success">
                                <i class="fas fa-plus me-2"></i>Ajouter un immeuble
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
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
                <div class="row quick-actions">
                    <div class="col-md-3">
                        <a href="${pageContext.request.contextPath}/proprietaire/immeubles/create"
                           class="btn btn-success">
                            <i class="fas fa-building me-2"></i>
                            Nouvel immeuble
                        </a>
                    </div>
                    <div class="col-md-3">
                        <a href="${pageContext.request.contextPath}/proprietaire/unites/create"
                           class="btn btn-primary">
                            <i class="fas fa-plus me-2"></i>
                            Nouvelle unité
                        </a>
                    </div>
                    <div class="col-md-3">
                        <a href="${pageContext.request.contextPath}/proprietaire/candidatures?statut=EN_ATTENTE"
                           class="btn btn-warning">
                            <i class="fas fa-user-check me-2"></i>
                            Candidatures en attente
                            <c:if test="${candidaturesEnAttente > 0}">
                                <span class="notification-badge">${candidaturesEnAttente}</span>
                            </c:if>
                        </a>
                    </div>
                    <div class="col-md-3">
                        <a href="${pageContext.request.contextPath}/proprietaire/contrats"
                           class="btn btn-info">
                            <i class="fas fa-file-contract me-2"></i>
                            Gérer contrats
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Chart.js Script -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Graphique en camembert pour l'occupation
        const ctx = document.getElementById('occupationChart').getContext('2d');

        const unitesLouees = ${unitesLouees};
        const unitesDisponibles = ${unitesDisponibles};

        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Louées', 'Disponibles'],
                datasets: [{
                    data: [unitesLouees, unitesDisponibles],
                    backgroundColor: [
                        '#28a745',
                        '#ffc107'
                    ],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            padding: 20,
                            usePointStyle: true
                        }
                    }
                }
            }
        });

        // Animation pour les alertes
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                alert.style.opacity = '0';
                alert.style.transition = 'opacity 0.5s';
                setTimeout(() => alert.remove(), 500);
            });
        }, 5000);
    });
</script>
</body>
</html>