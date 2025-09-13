<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Recherche de logements - Locataire" scope="request"/>

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

        .search-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            border: none;
            margin-bottom: 20px;
        }

        .property-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            border: none;
            margin-bottom: 20px;
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .property-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .property-image {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            height: 150px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 3rem;
            margin-bottom: 15px;
        }

        .price-badge {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 8px 16px;
            border-radius: 25px;
            font-weight: bold;
            font-size: 1.1rem;
        }

        .status-badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .status-disponible {
            background: #d4edda;
            color: #155724;
        }

        .feature-item {
            display: flex;
            align-items: center;
            margin-bottom: 8px;
        }

        .feature-item i {
            width: 20px;
            text-align: center;
            margin-right: 10px;
            color: #6c757d;
        }

        .user-info {
            color: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 20px;
        }

        .no-profile-alert {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
            color: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
        }

        .filter-section {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 15px;
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
            <a class="nav-link active" href="${pageContext.request.contextPath}/locataire/recherche">
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
        <h2 class="mb-0">Recherche de logements</h2>
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

    <!-- Alerte profil manquant -->
    <c:if test="${not hasProfile}">
        <div class="no-profile-alert">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h5 class="mb-2">
                        <i class="fas fa-info-circle me-2"></i>
                        Profil incomplet
                    </h5>
                    <p class="mb-0">
                        Vous devez compléter votre profil pour pouvoir postuler aux offres de location et vérifier votre éligibilité.
                    </p>
                </div>
                <div class="col-md-4 text-end">
                    <a href="${pageContext.request.contextPath}/locataire/profile"
                       class="btn btn-light">
                        <i class="fas fa-user-plus me-2"></i>Compléter mon profil
                    </a>
                </div>
            </div>
        </div>
    </c:if>

    <!-- Formulaire de recherche -->
    <div class="search-card">
        <h5 class="mb-3">
            <i class="fas fa-filter me-2 text-primary"></i>
            Filtres de recherche
        </h5>

        <form method="get" action="${pageContext.request.contextPath}/locataire/recherche">
            <div class="row">
                <div class="col-md-3">
                    <div class="mb-3">
                        <label for="ville" class="form-label">Ville</label>
                        <input type="text" class="form-control" id="ville" name="ville"
                               placeholder="Ex: Paris, Lyon..." value="${ville}">
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="mb-3">
                        <label for="nombrePieces" class="form-label">Nombre de pièces</label>
                        <select class="form-select" id="nombrePieces" name="nombrePieces">
                            <option value="">Indifférent</option>
                            <option value="1" ${nombrePieces == '1' ? 'selected' : ''}>1 pièce</option>
                            <option value="2" ${nombrePieces == '2' ? 'selected' : ''}>2 pièces</option>
                            <option value="3" ${nombrePieces == '3' ? 'selected' : ''}>3 pièces</option>
                            <option value="4" ${nombrePieces == '4' ? 'selected' : ''}>4 pièces</option>
                            <option value="5" ${nombrePieces == '5' ? 'selected' : ''}>5+ pièces</option>
                        </select>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="mb-3">
                        <label for="loyerMin" class="form-label">Loyer min (€)</label>
                        <input type="number" class="form-control" id="loyerMin" name="loyerMin"
                               placeholder="500" value="${loyerMin}">
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="mb-3">
                        <label for="loyerMax" class="form-label">Loyer max (€)</label>
                        <input type="number" class="form-control" id="loyerMax" name="loyerMax"
                               placeholder="2000" value="${loyerMax}">
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="mb-3">
                        <label class="form-label">&nbsp;</label>
                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-search me-2"></i>Rechercher
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <!-- Résultats de recherche -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h5 class="mb-0">
            <c:choose>
                <c:when test="${rechercheLancee}">
                    Résultats de recherche (${unites.size()} logement(s) trouvé(s))
                </c:when>
                <c:otherwise>
                    Tous les logements disponibles (${unites.size()})
                </c:otherwise>
            </c:choose>
        </h5>
        <c:if test="${rechercheLancee}">
            <a href="${pageContext.request.contextPath}/locataire/recherche"
               class="btn btn-outline-secondary btn-sm">
                <i class="fas fa-times me-1"></i>Effacer les filtres
            </a>
        </c:if>
    </div>

    <!-- Liste des logements -->
    <div class="row">
        <c:choose>
            <c:when test="${not empty unites}">
                <c:forEach var="unite" items="${unites}">
                    <div class="col-md-6 col-lg-4">
                        <div class="property-card">
                            <div class="property-image">
                                <i class="fas fa-home"></i>
                            </div>

                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div>
                                    <h6 class="mb-1">${unite.immeuble.nom}</h6>
                                    <small class="text-muted">
                                        <i class="fas fa-map-marker-alt me-1"></i>
                                            ${unite.immeuble.adresse}, ${unite.immeuble.ville}
                                    </small>
                                </div>
                                <span class="status-badge status-disponible">
                                        ${unite.statut}
                                </span>
                            </div>

                            <div class="mb-3">
                                <div class="feature-item">
                                    <i class="fas fa-door-open"></i>
                                    <span>Unité ${unite.numero}</span>
                                </div>
                                <div class="feature-item">
                                    <i class="fas fa-th-large"></i>
                                    <span>${unite.nombrePieces} pièce(s)</span>
                                </div>
                                <div class="feature-item">
                                    <i class="fas fa-ruler-combined"></i>
                                    <span>${unite.superficie} m²</span>
                                </div>
                                <c:if test="${not empty unite.description}">
                                    <div class="feature-item">
                                        <i class="fas fa-info-circle"></i>
                                        <span>${unite.description}</span>
                                    </div>
                                </c:if>
                            </div>

                            <div class="d-flex justify-content-between align-items-center">
                                <div class="price-badge">
                                    <fmt:formatNumber value="${unite.loyer}" type="currency" currencySymbol="€"/>
                                    <small>/mois</small>
                                </div>
                                <a href="${pageContext.request.contextPath}/locataire/logement?id=${unite.id}"
                                   class="btn btn-outline-primary btn-sm">
                                    <i class="fas fa-eye me-1"></i>Détails
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="col-12">
                    <div class="property-card text-center py-5">
                        <i class="fas fa-home fa-5x text-muted mb-4"></i>
                        <h5 class="text-muted mb-3">Aucun logement trouvé</h5>
                        <p class="text-muted mb-4">
                            <c:choose>
                                <c:when test="${rechercheLancee}">
                                    Aucun logement ne correspond à vos critères de recherche.
                                    Essayez de modifier vos filtres.
                                </c:when>
                                <c:otherwise>
                                    Il n'y a actuellement aucun logement disponible.
                                </c:otherwise>
                            </c:choose>
                        </p>
                        <c:if test="${rechercheLancee}">
                            <a href="${pageContext.request.contextPath}/locataire/recherche"
                               class="btn btn-primary">
                                <i class="fas fa-refresh me-2"></i>Voir tous les logements
                            </a>
                        </c:if>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>