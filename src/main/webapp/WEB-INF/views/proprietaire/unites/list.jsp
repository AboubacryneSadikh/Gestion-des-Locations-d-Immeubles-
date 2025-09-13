<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Mes unités" scope="request"/>

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

        .unite-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            border: none;
            transition: all 0.3s;
            margin-bottom: 20px;
        }

        .unite-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        }

        .status-badge {
            font-size: 0.8em;
            padding: 6px 12px;
            border-radius: 15px;
            font-weight: 600;
        }

        .status-DISPONIBLE { background-color: #d4edda; color: #155724; }
        .status-LOUE { background-color: #f8d7da; color: #721c24; }
        .status-EN_MAINTENANCE { background-color: #fff3cd; color: #856404; }
        .status-RESERVE { background-color: #d1ecf1; color: #0c5460; }

        .filter-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            margin-bottom: 25px;
        }

        .stats-summary {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 25px;
        }

        .btn-action {
            width: 35px;
            height: 35px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin: 0 2px;
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
                <h6 class="mb-0">${sessionScope.userName}</h6>
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
            <a class="nav-link active" href="${pageContext.request.contextPath}/proprietaire/unites">
                <i class="fas fa-door-open me-2"></i>Mes unités
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
            <h2 class="mb-0">Mes unités</h2>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/proprietaire/dashboard">Tableau de bord</a></li>
                    <li class="breadcrumb-item active">Unités</li>
                </ol>
            </nav>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/proprietaire/unites/create" class="btn btn-success">
                <i class="fas fa-plus me-2"></i>Nouvelle unité
            </a>
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

    <!-- Statistiques résumées -->
    <div class="stats-summary">
        <div class="row text-center">
            <div class="col-md-3">
                <i class="fas fa-home fa-2x mb-2"></i>
                <h3 class="mb-0">${unites.size()}</h3>
                <small>Unités totales</small>
            </div>
            <div class="col-md-3">
                <i class="fas fa-check-circle fa-2x mb-2"></i>
                <h3 class="mb-0">
                    <c:set var="disponibles" value="0"/>
                    <c:forEach var="unite" items="${unites}">
                        <c:if test="${unite.statut == 'DISPONIBLE'}">
                            <c:set var="disponibles" value="${disponibles + 1}"/>
                        </c:if>
                    </c:forEach>
                    ${disponibles}
                </h3>
                <small>Disponibles</small>
            </div>
            <div class="col-md-3">
                <i class="fas fa-handshake fa-2x mb-2"></i>
                <h3 class="mb-0">
                    <c:set var="louees" value="0"/>
                    <c:forEach var="unite" items="${unites}">
                        <c:if test="${unite.statut == 'LOUE'}">
                            <c:set var="louees" value="${louees + 1}"/>
                        </c:if>
                    </c:forEach>
                    ${louees}
                </h3>
                <small>Louées</small>
            </div>
            <div class="col-md-3">
                <i class="fas fa-tools fa-2x mb-2"></i>
                <h3 class="mb-0">
                    <c:set var="maintenance" value="0"/>
                    <c:forEach var="unite" items="${unites}">
                        <c:if test="${unite.statut == 'EN_MAINTENANCE'}">
                            <c:set var="maintenance" value="${maintenance + 1}"/>
                        </c:if>
                    </c:forEach>
                    ${maintenance}
                </h3>
                <small>En maintenance</small>
            </div>
        </div>
    </div>

    <!-- Filtres -->
    <div class="filter-card">
        <form method="get" action="${pageContext.request.contextPath}/proprietaire/unites">
            <div class="row align-items-end">
                <div class="col-md-4">
                    <label for="immeubleId" class="form-label">Filtrer par immeuble</label>
                    <select class="form-select" id="immeubleId" name="immeubleId" onchange="this.form.submit()">
                        <option value="">Tous les immeubles</option>
                        <c:forEach var="immeuble" items="${immeubles}">
                            <option value="${immeuble.id}" ${param.immeubleId == immeuble.id ? 'selected' : ''}>
                                    ${immeuble.nom} - ${immeuble.ville}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <label for="statut" class="form-label">Filtrer par statut</label>
                    <select class="form-select" id="statut" name="statut" onchange="this.form.submit()">
                        <option value="">Tous les statuts</option>
                        <option value="DISPONIBLE" ${param.statut == 'DISPONIBLE' ? 'selected' : ''}>Disponible</option>
                        <option value="LOUE" ${param.statut == 'LOUE' ? 'selected' : ''}>Louée</option>
                        <option value="EN_MAINTENANCE" ${param.statut == 'EN_MAINTENANCE' ? 'selected' : ''}>En maintenance</option>
                        <option value="RESERVE" ${param.statut == 'RESERVE' ? 'selected' : ''}>Réservée</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label for="search" class="form-label">Rechercher</label>
                    <input type="text" class="form-control" id="search" name="search"
                           placeholder="Numéro, étage..." value="${param.search}">
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="fas fa-search"></i> Filtrer
                    </button>
                </div>
            </div>
        </form>
    </div>

    <!-- Liste des unités -->
    <c:choose>
        <c:when test="${not empty unites}">
            <div class="row">
                <c:forEach var="unite" items="${unites}">
                    <div class="col-lg-6 col-xl-4">
                        <div class="card unite-card h-100">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div>
                                        <h5 class="card-title mb-1">
                                            <i class="fas fa-door-open me-2 text-primary"></i>
                                            Unité ${unite.numero}
                                        </h5>
                                        <small class="text-muted">
                                            <i class="fas fa-building me-1"></i>
                                                ${unite.immeuble.nom}
                                        </small>
                                    </div>
                                    <span class="status-badge status-${unite.statut}">
                                            <c:choose>
                                                <c:when test="${unite.statut == 'DISPONIBLE'}">
                                                    <i class="fas fa-check-circle me-1"></i>Disponible
                                                </c:when>
                                                <c:when test="${unite.statut == 'LOUE'}">
                                                    <i class="fas fa-handshake me-1"></i>Louée
                                                </c:when>
                                                <c:when test="${unite.statut == 'EN_MAINTENANCE'}">
                                                    <i class="fas fa-tools me-1"></i>Maintenance
                                                </c:when>
                                                <c:when test="${unite.statut == 'RESERVE'}">
                                                    <i class="fas fa-bookmark me-1"></i>Réservée
                                                </c:when>
                                            </c:choose>
                                        </span>
                                </div>

                                <div class="row text-center mb-3">
                                    <div class="col-4">
                                        <div class="border-end">
                                            <i class="fas fa-layer-group text-info"></i>
                                            <div class="fw-bold">${unite.etage}</div>
                                            <small class="text-muted">Étage</small>
                                        </div>
                                    </div>
                                    <div class="col-4">
                                        <div class="border-end">
                                            <i class="fas fa-door-open text-warning"></i>
                                            <div class="fw-bold">${unite.nombrePieces}</div>
                                            <small class="text-muted">Pièces</small>
                                        </div>
                                    </div>
                                    <div class="col-4">
                                        <i class="fas fa-expand-arrows-alt text-secondary"></i>
                                        <div class="fw-bold">
                                            <fmt:formatNumber value="${unite.superficie}" type="number" maxFractionDigits="0"/>
                                        </div>
                                        <small class="text-muted">m²</small>
                                    </div>
                                </div>

                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <div>
                                        <div class="fw-bold text-success h5 mb-0">
                                            <fmt:formatNumber value="${unite.loyer}" type="number" maxFractionDigits="0"/> €
                                        </div>
                                        <small class="text-muted">Loyer mensuel</small>
                                    </div>
                                    <c:if test="${not empty unite.chargesMensuelles}">
                                        <div class="text-end">
                                            <div class="text-warning">
                                                +<fmt:formatNumber value="${unite.chargesMensuelles}" type="number" maxFractionDigits="0"/> €
                                            </div>
                                            <small class="text-muted">Charges</small>
                                        </div>
                                    </c:if>
                                </div>

                                <c:if test="${not empty unite.description}">
                                    <p class="card-text text-muted small mb-3">
                                        <c:choose>
                                            <c:when test="${unite.description.length() > 100}">
                                                ${unite.description.substring(0, 100)}...
                                            </c:when>
                                            <c:otherwise>
                                                ${unite.description}
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </c:if>

                                <!-- Actions -->
                                <div class="d-flex justify-content-between align-items-center">
                                    <div class="btn-group" role="group">
                                        <a href="${pageContext.request.contextPath}/proprietaire/unites/edit?id=${unite.id}"
                                           class="btn btn-outline-primary btn-action" title="Modifier">
                                            <i class="fas fa-edit"></i>
                                        </a>

                                        <!-- Menu déroulant pour changer de statut -->
                                        <div class="btn-group" role="group">
                                            <button type="button" class="btn btn-outline-warning btn-action dropdown-toggle"
                                                    data-bs-toggle="dropdown" title="Changer statut">
                                                <i class="fas fa-exchange-alt"></i>
                                            </button>
                                            <ul class="dropdown-menu">
                                                <c:if test="${unite.statut != 'DISPONIBLE'}">
                                                    <li>
                                                        <form method="post" action="${pageContext.request.contextPath}/proprietaire/unites/toggle-status" style="display: inline;">
                                                            <input type="hidden" name="id" value="${unite.id}">
                                                            <input type="hidden" name="statut" value="DISPONIBLE">
                                                            <button type="submit" class="dropdown-item">
                                                                <i class="fas fa-check-circle text-success me-2"></i>Disponible
                                                            </button>
                                                        </form>
                                                    </li>
                                                </c:if>
                                                <c:if test="${unite.statut != 'EN_MAINTENANCE'}">
                                                    <li>
                                                        <form method="post" action="${pageContext.request.contextPath}/proprietaire/unites/toggle-status" style="display: inline;">
                                                            <input type="hidden" name="id" value="${unite.id}">
                                                            <input type="hidden" name="statut" value="EN_MAINTENANCE">
                                                            <button type="submit" class="dropdown-item">
                                                                <i class="fas fa-tools text-warning me-2"></i>Maintenance
                                                            </button>
                                                        </form>
                                                    </li>
                                                </c:if>
                                                <c:if test="${unite.statut != 'RESERVE'}">
                                                    <li>
                                                        <form method="post" action="${pageContext.request.contextPath}/proprietaire/unites/toggle-status" style="display: inline;">
                                                            <input type="hidden" name="id" value="${unite.id}">
                                                            <input type="hidden" name="statut" value="RESERVE">
                                                            <button type="submit" class="dropdown-item">
                                                                <i class="fas fa-bookmark text-info me-2"></i>Réservée
                                                            </button>
                                                        </form>
                                                    </li>
                                                </c:if>
                                            </ul>
                                        </div>

                                        <button type="button" class="btn btn-outline-danger btn-action"
                                                onclick="confirmDelete(${unite.id}, '${unite.numero}')" title="Supprimer">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>

                                    <div class="text-muted small">
                                        <i class="fas fa-calendar me-1"></i>
                                        <fmt:formatDate value="${unite.dateCreation}" pattern="dd/MM/yyyy"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="text-center py-5">
                <div class="mb-4">
                    <i class="fas fa-door-open fa-5x text-muted mb-3"></i>
                    <h4 class="text-muted">Aucune unité trouvée</h4>
                    <p class="text-muted">
                        <c:choose>
                            <c:when test="${not empty param.immeubleId or not empty param.statut or not empty param.search}">
                                Aucune unité ne correspond à vos critères de recherche.
                            </c:when>
                            <c:otherwise>
                                Vous n'avez pas encore créé d'unité.
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <div>
                    <c:if test="${not empty param.immeubleId or not empty param.statut or not empty param.search}">
                        <a href="${pageContext.request.contextPath}/proprietaire/unites" class="btn btn-secondary me-2">
                            <i class="fas fa-times me-2"></i>Effacer les filtres
                        </a>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/proprietaire/unites/create" class="btn btn-success">
                        <i class="fas fa-plus me-2"></i>Créer votre première unité
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- Modal de confirmation de suppression -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-exclamation-triangle text-danger me-2"></i>
                    Confirmer la suppression
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>Êtes-vous sûr de vouloir supprimer l'unité <strong id="uniteNumero"></strong> ?</p>
                <div class="alert alert-warning">
                    <i class="fas fa-info-circle me-2"></i>
                    Cette action est irréversible. Toutes les données associées à cette unité seront perdues.
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="fas fa-times me-2"></i>Annuler
                </button>
                <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/proprietaire/unites/delete" style="display: inline;">
                    <input type="hidden" id="deleteUniteId" name="id">
                    <button type="submit" class="btn btn-danger">
                        <i class="fas fa-trash me-2"></i>Supprimer définitivement
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Fonction pour confirmer la suppression
    function confirmDelete(uniteId, uniteNumero) {
        document.getElementById('deleteUniteId').value = uniteId;
        document.getElementById('uniteNumero').textContent = uniteNumero;

        const deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
        deleteModal.show();
    }

    // Auto-submit du formulaire de recherche après une pause
    let searchTimeout;
    document.getElementById('search').addEventListener('input', function() {
        clearTimeout(searchTimeout);
        searchTimeout = setTimeout(() => {
            this.form.submit();
        }, 500);
    });

    // Animation pour les alertes
    setTimeout(function() {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(alert => {
            if (alert.classList.contains('alert-success') || alert.classList.contains('alert-danger')) {
                setTimeout(() => {
                    alert.style.opacity = '0';
                    alert.style.transition = 'opacity 0.5s';
                    setTimeout(() => alert.remove(), 500);
                }, 4000);
            }
        });
    }, 100);
</script>
</body>
</html>