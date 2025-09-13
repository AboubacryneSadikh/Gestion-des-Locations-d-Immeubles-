<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Mes contrats" scope="request"/>

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

        .user-info {
            color: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 20px;
        }

        .page-header {
            background: white;
            padding: 1.5rem;
            border-radius: 15px;
            margin-bottom: 2rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        }

        .filters-card {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        }

        .contracts-table {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            overflow: hidden;
        }

        .table th {
            background: #f8f9fa;
            border: none;
            font-weight: 600;
            color: #495057;
            padding: 1rem;
            position: sticky;
            top: 0;
            z-index: 10;
        }

        .table td {
            padding: 1rem;
            border: none;
            border-bottom: 1px solid #eee;
            vertical-align: middle;
        }

        .table tbody tr:hover {
            background-color: #f8f9fa;
            transition: background-color 0.3s;
        }

        .contract-status {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-block;
        }

        .status-actif {
            background: #d4edda;
            color: #155724;
        }

        .status-expire {
            background: #f8d7da;
            color: #721c24;
        }

        .status-resilier {
            background: #e2e3e5;
            color: #383d41;
        }

        .status-expiring-soon {
            background: #fff3cd;
            color: #856404;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.7; }
        }

        .tenant-info {
            display: flex;
            align-items: center;
        }

        .tenant-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #007bff 0%, #6610f2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            margin-right: 12px;
        }

        .property-info {
            display: flex;
            align-items: center;
        }

        .property-icon {
            width: 35px;
            height: 35px;
            border-radius: 8px;
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 0.9rem;
            margin-right: 10px;
        }

        .action-buttons .btn {
            margin: 0 0.2rem;
            border-radius: 6px;
            font-size: 0.85rem;
            padding: 0.4rem 0.8rem;
            transition: all 0.3s;
        }

        .btn-view {
            background: #17a2b8;
            color: white;
            border: none;
        }

        .btn-view:hover {
            background: #138496;
            transform: translateY(-1px);
        }

        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: #6c757d;
        }

        .empty-state i {
            font-size: 5rem;
            margin-bottom: 1.5rem;
            opacity: 0.3;
        }

        .stats-cards {
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            border: none;
            height: 100%;
            transition: transform 0.3s;
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            margin: 0 auto 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: #6c757d;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .breadcrumb {
            background: white;
            padding: 1rem 1.5rem;
            border-radius: 10px;
            margin-bottom: 1.5rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .breadcrumb-item + .breadcrumb-item::before {
            color: #6c757d;
        }

        .filter-btn {
            border: 2px solid #dee2e6;
            background: white;
            color: #6c757d;
            border-radius: 25px;
            padding: 0.5rem 1rem;
            margin: 0 0.25rem 0.5rem 0;
            transition: all 0.3s;
        }

        .filter-btn.active,
        .filter-btn:hover {
            background: #28a745;
            border-color: #28a745;
            color: white;
        }

        .search-box {
            position: relative;
        }

        .search-box .form-control {
            border-radius: 25px;
            padding-left: 2.5rem;
            border: 2px solid #e9ecef;
            transition: all 0.3s;
        }

        .search-box .form-control:focus {
            border-color: #28a745;
            box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
        }

        .search-box i {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
        }

        .contract-amount {
            font-weight: 600;
            color: #28a745;
        }

        .date-info {
            font-size: 0.9rem;
        }

        .date-start {
            color: #6c757d;
        }

        .date-end {
            color: #dc3545;
            font-weight: 600;
        }

        .days-remaining {
            font-size: 0.8rem;
            padding: 0.2rem 0.5rem;
            border-radius: 10px;
            background: #fff3cd;
            color: #856404;
            display: inline-block;
            margin-top: 0.25rem;
        }

        .days-remaining.critical {
            background: #f8d7da;
            color: #721c24;
        }

        .table-container {
            max-height: 70vh;
            overflow-y: auto;
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
            <li class="breadcrumb-item active">Mes contrats</li>
        </ol>
    </nav>

    <!-- En-tête -->
    <div class="page-header">
        <div class="row align-items-center">
            <div class="col-md-6">
                <h2 class="mb-1">
                    <i class="fas fa-file-contract me-2 text-success"></i>
                    Mes contrats de location
                </h2>
                <p class="text-muted mb-0">Gestion et suivi de tous vos contrats</p>
            </div>
            <div class="col-md-6 text-end">
                <div class="text-muted">
                    <i class="fas fa-calendar-alt me-2"></i>
                    <fmt:formatDate value="<%=new java.util.Date()%>" pattern="dd/MM/yyyy"/>
                </div>
            </div>
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

    <!-- Statistiques -->
    <div class="row stats-cards">
        <c:set var="contratsActifs" value="${0}"/>
        <c:set var="contratsExpires" value="${0}"/>
        <c:set var="contratsExpirantBientot" value="${0}"/>
        <c:set var="totalContrats" value="${contrats.size()}"/>

        <jsp:useBean id="now" class="java.util.Date" />
        <jsp:useBean id="in30Days" class="java.util.Date" />
        <c:set target="${in30Days}" property="time" value="${now.time + (30 * 24 * 60 * 60 * 1000)}" />

        <c:forEach var="contrat" items="${contrats}">
            <c:choose>
                <c:when test="${contrat.dateFin.before(now)}">
                    <c:set var="contratsExpires" value="${contratsExpires + 1}"/>
                </c:when>
                <c:when test="${contrat.dateFin.before(in30Days)}">
                    <c:set var="contratsExpirantBientot" value="${contratsExpirantBientot + 1}"/>
                    <c:set var="contratsActifs" value="${contratsActifs + 1}"/>
                </c:when>
                <c:otherwise>
                    <c:set var="contratsActifs" value="${contratsActifs + 1}"/>
                </c:otherwise>
            </c:choose>
        </c:forEach>

        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #28a745 0%, #20c997 100%);">
                    <i class="fas fa-file-contract"></i>
                </div>
                <div class="stat-number">${totalContrats}</div>
                <div class="stat-label">Total Contrats</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #007bff 0%, #6610f2 100%);">
                    <i class="fas fa-handshake"></i>
                </div>
                <div class="stat-number">${contratsActifs}</div>
                <div class="stat-label">Actifs</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);">
                    <i class="fas fa-exclamation-triangle"></i>
                </div>
                <div class="stat-number">${contratsExpirantBientot}</div>
                <div class="stat-label">Expirant bientôt</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #dc3545 0%, #e83e8c 100%);">
                    <i class="fas fa-times-circle"></i>
                </div>
                <div class="stat-number">${contratsExpires}</div>
                <div class="stat-label">Expirés</div>
            </div>
        </div>
    </div>

    <!-- Filtres et recherche -->
    <div class="filters-card">
        <div class="row align-items-center">
            <div class="col-md-8">
                <h6 class="mb-2">Filtrer par statut :</h6>
                <button class="filter-btn active" onclick="filterContracts('all')">
                    <i class="fas fa-list me-1"></i>Tous
                </button>
                <button class="filter-btn" onclick="filterContracts('actif')">
                    <i class="fas fa-check-circle me-1"></i>Actifs
                </button>
                <button class="filter-btn" onclick="filterContracts('expiring')">
                    <i class="fas fa-exclamation-triangle me-1"></i>Expirant bientôt
                </button>
                <button class="filter-btn" onclick="filterContracts('expire')">
                    <i class="fas fa-times-circle me-1"></i>Expirés
                </button>
            </div>
            <div class="col-md-4">
                <div class="search-box">
                    <i class="fas fa-search"></i>
                    <input type="text" class="form-control" placeholder="Rechercher un locataire..."
                           id="searchInput" onkeyup="searchContracts()">
                </div>
            </div>
        </div>
    </div>

    <!-- Liste des contrats -->
    <div class="contracts-table">
        <c:choose>
            <c:when test="${not empty contrats}">
                <div class="table-container">
                    <table class="table table-hover mb-0" id="contractsTable">
                        <thead>
                        <tr>
                            <th>Locataire</th>
                            <th>Propriété</th>
                            <th>Période</th>
                            <th>Loyer</th>
                            <th>Statut</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="contrat" items="${contrats}">
                            <!-- Calculer le statut -->
                            <c:set var="isExpired" value="${contrat.dateFin.before(now)}"/>
                            <c:set var="isExpiringSoon" value="${contrat.dateFin.before(in30Days) && !isExpired}"/>
                            <c:set var="contractStatus" value="${isExpired ? 'expire' : (isExpiringSoon ? 'expiring' : 'actif')}"/>

                            <!-- Calculer les jours restants -->
                            <c:set var="daysRemaining" value="${(contrat.dateFin.time - now.time) / (1000 * 60 * 60 * 24)}"/>
                            <c:set var="daysRemainingInt" value="${daysRemaining < 0 ? 0 : Math.floor(daysRemaining)}"/>

                            <tr class="contract-row" data-status="${contractStatus}"
                                data-tenant="${contrat.locataire.utilisateur.nom} ${contrat.locataire.utilisateur.prenom}">
                                <td>
                                    <div class="tenant-info">
                                        <div class="tenant-avatar">
                                                ${contrat.locataire.utilisateur.prenom.substring(0,1)}${contrat.locataire.utilisateur.nom.substring(0,1)}
                                        </div>
                                        <div>
                                            <div class="fw-bold">
                                                    ${contrat.locataire.utilisateur.prenom} ${contrat.locataire.utilisateur.nom}
                                            </div>
                                            <small class="text-muted">
                                                <i class="fas fa-phone me-1"></i>
                                                    ${contrat.locataire.utilisateur.telephone}
                                            </small>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="property-info">
                                        <div class="property-icon">
                                            <i class="fas fa-building"></i>
                                        </div>
                                        <div>
                                            <div class="fw-bold">${contrat.unite.immeuble.nom}</div>
                                            <small class="text-muted">
                                                Unité ${contrat.unite.numero} - ${contrat.unite.nombrePieces} pièces
                                            </small>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="date-info">
                                        <div class="date-start">
                                            <i class="fas fa-play me-1"></i>
                                            <fmt:formatDate value="${contrat.dateDebut}" pattern="dd/MM/yyyy"/>
                                        </div>
                                        <div class="date-end">
                                            <i class="fas fa-stop me-1"></i>
                                            <fmt:formatDate value="${contrat.dateFin}" pattern="dd/MM/yyyy"/>
                                        </div>
                                        <c:if test="${!isExpired && isExpiringSoon}">
                                            <div class="days-remaining ${daysRemainingInt <= 7 ? 'critical' : ''}">
                                                <c:choose>
                                                    <c:when test="${daysRemainingInt == 0}">Expire aujourd'hui</c:when>
                                                    <c:when test="${daysRemainingInt == 1}">Expire demain</c:when>
                                                    <c:otherwise>Expire dans ${daysRemainingInt} jours</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </c:if>
                                    </div>
                                </td>
                                <td>
                                    <div class="contract-amount">
                                        <fmt:formatNumber value="${contrat.loyer}" type="currency" currencyCode="XOF"/>
                                    </div>
                                    <c:if test="${not empty contrat.unite.chargesMensuelles}">
                                        <small class="text-muted d-block">
                                            + <fmt:formatNumber value="${contrat.unite.chargesMensuelles}" type="currency" currencyCode="XOF"/> charges
                                        </small>
                                    </c:if>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${isExpired}">
                                            <span class="contract-status status-expire">
                                                <i class="fas fa-times-circle me-1"></i>Expiré
                                            </span>
                                        </c:when>
                                        <c:when test="${isExpiringSoon}">
                                            <span class="contract-status status-expiring-soon">
                                                <i class="fas fa-exclamation-triangle me-1"></i>Expire bientôt
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="contract-status status-actif">
                                                <i class="fas fa-check-circle me-1"></i>Actif
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="${pageContext.request.contextPath}/proprietaire/contrats/view?id=${contrat.id}"
                                           class="btn btn-sm btn-view"
                                           title="Voir détails">
                                            <i class="fas fa-eye me-1"></i>Détails
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-file-contract"></i>
                    <h4>Aucun contrat</h4>
                    <p class="mb-4">Vous n'avez pas encore de contrats de location.</p>
                    <div>
                        <a href="${pageContext.request.contextPath}/proprietaire/immeubles"
                           class="btn btn-success me-2">
                            <i class="fas fa-building me-2"></i>Gérer mes immeubles
                        </a>
                        <a href="${pageContext.request.contextPath}/proprietaire/unites"
                           class="btn btn-primary">
                            <i class="fas fa-door-open me-2"></i>Gérer mes unités
                        </a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Information sur les contrats expirant -->
    <c:if test="${contratsExpirantBientot > 0}">
        <div class="alert alert-warning mt-3" role="alert">
            <div class="d-flex align-items-center">
                <i class="fas fa-exclamation-triangle fa-2x me-3"></i>
                <div>
                    <h6 class="alert-heading mb-1">Attention : Contrats expirant bientôt</h6>
                    <p class="mb-0">
                        Vous avez <strong>${contratsExpirantBientot} contrat(s)</strong> qui expire(nt) dans les 30 prochains jours.
                        Pensez à contacter vos locataires pour le renouvellement.
                    </p>
                </div>
            </div>
        </div>
    </c:if>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Fonction de filtrage
    function filterContracts(status) {
        // Mettre à jour les boutons actifs
        document.querySelectorAll('.filter-btn').forEach(btn => {
            btn.classList.remove('active');
        });
        event.target.classList.add('active');

        // Filtrer les lignes
        const rows = document.querySelectorAll('.contract-row');
        rows.forEach(row => {
            const rowStatus = row.getAttribute('data-status');

            if (status === 'all') {
                row.style.display = '';
            } else {
                row.style.display = rowStatus === status ? '' : 'none';
            }
        });

        // Mettre à jour le compteur
        updateVisibleCount();
    }

    // Fonction de recherche
    function searchContracts() {
        const searchTerm = document.getElementById('searchInput').value.toLowerCase();
        const rows = document.querySelectorAll('.contract-row');

        rows.forEach(row => {
            const tenantName = row.getAttribute('data-tenant').toLowerCase();
            const isVisible = tenantName.includes(searchTerm);

            if (isVisible && row.style.display !== 'none') {
                row.style.display = '';
            } else if (!isVisible) {
                row.style.display = 'none';
            }
        });

        updateVisibleCount();
    }

    // Mettre à jour le compteur de résultats visibles
    function updateVisibleCount() {
        const visibleRows = document.querySelectorAll('.contract-row[style=""], .contract-row:not([style])').length;
        const totalRows = document.querySelectorAll('.contract-row').length;

        // Vous pouvez ajouter un élément pour afficher le compteur si nécessaire
        console.log(`${visibleRows} sur ${totalRows} contrats affichés`);
    }

    // Animation pour les alertes
    setTimeout(function() {
        const alerts = document.querySelectorAll('.alert:not(.alert-warning)');
        alerts.forEach(alert => {
            alert.style.opacity = '0';
            alert.style.transition = 'opacity 0.5s';
            setTimeout(() => alert.remove(), 500);
        });
    }, 5000);

    // Initialisation
    document.addEventListener('DOMContentLoaded', function() {
        // Vérifier s'il y a des paramètres d'URL pour le filtrage
        const urlParams = new URLSearchParams(window.location.search);
        const statusFilter = urlParams.get('status');

        if (statusFilter) {
            filterContracts(statusFilter);
        }
    });
</script>
</body>
</html>