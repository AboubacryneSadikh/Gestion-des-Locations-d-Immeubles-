<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="Mes immeubles" scope="request"/>

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

        .immeuble-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            border: none;
            transition: all 0.3s;
            margin-bottom: 20px;
        }

        .immeuble-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
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

        .stats-summary {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 25px;
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
            <a class="nav-link active" href="${pageContext.request.contextPath}/proprietaire/immeubles">
                <i class="fas fa-building me-2"></i>Mes immeubles
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/proprietaire/unites">
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
            <h2 class="mb-0">Mes immeubles</h2>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/proprietaire/dashboard">Tableau de bord</a></li>
                    <li class="breadcrumb-item active">Immeubles</li>
                </ol>
            </nav>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/proprietaire/immeubles/create" class="btn btn-success">
                <i class="fas fa-plus me-2"></i>Nouvel immeuble
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
            <div class="col-md-4">
                <i class="fas fa-building fa-2x mb-2"></i>
                <h3 class="mb-0">
                    <c:choose>
                        <c:when test="${not empty immeubles}">
                            ${fn:length(immeubles)}
                        </c:when>
                        <c:otherwise>
                            0
                        </c:otherwise>
                    </c:choose>
                </h3>
                <small>Immeubles totaux</small>
            </div>
            <div class="col-md-4">
                <i class="fas fa-door-open fa-2x mb-2"></i>
                <h3 class="mb-0">
                    <c:set var="totalUnites" value="0"/>
                    <c:if test="${not empty immeubles}">
                        <c:forEach var="immeuble" items="${immeubles}">
                            <c:if test="${not empty immeuble.nombreUnites}">
                                <c:set var="totalUnites" value="${totalUnites + immeuble.nombreUnites}"/>
                            </c:if>
                        </c:forEach>
                    </c:if>
                    ${totalUnites}
                </h3>
                <small>Unités totales</small>
            </div>
            <div class="col-md-4">
                <i class="fas fa-map-marker-alt fa-2x mb-2"></i>
                <h3 class="mb-0">
                    <c:set var="villesSet" value=","/>
                    <c:set var="compteurVilles" value="0"/>
                    <c:if test="${not empty immeubles}">
                        <c:forEach var="immeuble" items="${immeubles}">
                            <c:set var="searchPattern" value=",${immeuble.ville},"/>
                            <c:if test="${not empty immeuble.ville and not fn:contains(villesSet, searchPattern)}">
                                <c:set var="villesSet" value="${villesSet}${immeuble.ville},"/>
                                <c:set var="compteurVilles" value="${compteurVilles + 1}"/>
                            </c:if>
                        </c:forEach>
                    </c:if>
                    ${compteurVilles}
                </h3>
                <small>Villes</small>
            </div>
        </div>
    </div>

    <!-- Liste des immeubles -->
    <c:choose>
        <c:when test="${not empty immeubles}">
            <div class="row">
                <c:forEach var="immeuble" items="${immeubles}">
                    <div class="col-lg-6 col-xl-4">
                        <div class="card immeuble-card h-100">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div>
                                        <h5 class="card-title mb-1">
                                            <i class="fas fa-building me-2 text-success"></i>
                                            <c:out value="${immeuble.nom}" default="Sans nom"/>
                                        </h5>
                                        <small class="text-muted">
                                            <i class="fas fa-map-marker-alt me-1"></i>
                                            <c:out value="${immeuble.ville}" default="Ville non spécifiée"/>
                                        </small>
                                    </div>
                                    <span class="badge bg-success">Actif</span>
                                </div>

                                <div class="mb-3">
                                    <small class="text-muted d-block">
                                        <i class="fas fa-location-dot me-1"></i>
                                        <c:out value="${immeuble.adresse}" default="Adresse non spécifiée"/>
                                    </small>
                                    <c:if test="${not empty immeuble.codePostal}">
                                        <small class="text-muted">
                                            <c:out value="${immeuble.codePostal}"/>
                                        </small>
                                    </c:if>
                                </div>

                                <div class="text-center mb-3">
                                    <div class="row">
                                        <div class="col">
                                            <i class="fas fa-door-open text-primary fa-2x"></i>
                                            <div class="fw-bold h4 mb-0">
                                                <c:out value="${immeuble.nombreUnites}" default="0"/>
                                            </div>
                                            <small class="text-muted">Unités</small>
                                        </div>
                                    </div>
                                </div>

                                <c:if test="${not empty immeuble.description}">
                                    <p class="card-text text-muted small mb-3">
                                        <c:choose>
                                            <c:when test="${fn:length(immeuble.description) > 100}">
                                                <c:out value="${fn:substring(immeuble.description, 0, 100)}"/>...
                                            </c:when>
                                            <c:otherwise>
                                                <c:out value="${immeuble.description}"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </c:if>

                                <c:if test="${not empty immeuble.equipements}">
                                    <div class="mb-3">
                                        <small class="text-success">
                                            <i class="fas fa-tools me-1"></i>
                                            Équipements disponibles
                                        </small>
                                    </div>
                                </c:if>

                                <!-- Actions -->
                                <div class="d-flex justify-content-between align-items-center">
                                    <div class="btn-group" role="group">
                                        <a href="${pageContext.request.contextPath}/proprietaire/immeubles/view?id=${immeuble.id}"
                                           class="btn btn-outline-info btn-action" title="Voir détails">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/proprietaire/immeubles/edit?id=${immeuble.id}"
                                           class="btn btn-outline-primary btn-action" title="Modifier">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/proprietaire/unites?immeubleId=${immeuble.id}"
                                           class="btn btn-outline-success btn-action" title="Voir unités">
                                            <i class="fas fa-door-open"></i>
                                        </a>
                                        <button type="button" class="btn btn-outline-danger btn-action"
                                                onclick="confirmDelete(${immeuble.id}, '<c:out value="${immeuble.nom}" escapeXml="true"/>')" title="Supprimer">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>

                                    <div class="text-muted small">
                                        <i class="fas fa-calendar me-1"></i>
                                        <c:if test="${not empty immeuble.dateCreation}">
                                            <fmt:formatDate value="${immeuble.dateCreation}" pattern="dd/MM/yyyy"/>
                                        </c:if>
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
                    <i class="fas fa-building fa-5x text-muted mb-3"></i>
                    <h4 class="text-muted">Aucun immeuble trouvé</h4>
                    <p class="text-muted">Vous n'avez pas encore créé d'immeuble.</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/proprietaire/immeubles/create" class="btn btn-success">
                        <i class="fas fa-plus me-2"></i>Créer votre premier immeuble
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
                <p>Êtes-vous sûr de vouloir supprimer l'immeuble <strong id="immeubleNom"></strong> ?</p>
                <div class="alert alert-warning">
                    <i class="fas fa-info-circle me-2"></i>
                    Cette action supprimera également toutes les unités associées à cet immeuble.
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="fas fa-times me-2"></i>Annuler
                </button>
                <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/proprietaire/immeubles/delete" style="display: inline;">
                    <input type="hidden" id="deleteImmeubleId" name="id">
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
    function confirmDelete(immeubleId, immeubleNom) {
        document.getElementById('deleteImmeubleId').value = immeubleId;
        document.getElementById('immeubleNom').textContent = immeubleNom;

        const deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
        deleteModal.show();
    }

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