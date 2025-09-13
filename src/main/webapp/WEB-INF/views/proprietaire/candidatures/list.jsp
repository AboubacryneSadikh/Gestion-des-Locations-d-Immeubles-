<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="Candidatures - Propriétaire" scope="request"/>

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

        .candidature-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            margin-bottom: 20px;
            transition: all 0.3s;
            border-left: 5px solid #dee2e6;
        }

        .candidature-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        }

        .candidature-card.en-attente {
            border-left-color: #ffc107;
        }

        .candidature-card.approuvee {
            border-left-color: #28a745;
        }

        .candidature-card.refusee {
            border-left-color: #dc3545;
        }

        .candidature-card.contrat-signe {
            border-left-color: #17a2b8;
        }

        .status-badge {
            padding: 8px 15px;
            border-radius: 25px;
            font-weight: 600;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-en-attente {
            background: #fff3cd;
            color: #856404;
        }

        .status-approuvee {
            background: #d1eddd;
            color: #155724;
        }

        .status-refusee {
            background: #f8d7da;
            color: #721c24;
        }

        .status-contrat-signe {
            background: #d1ecf1;
            color: #0c5460;
        }

        .filter-pills .nav-link {
            background: white;
            border: 2px solid #dee2e6;
            border-radius: 25px;
            color: #495057;
            margin-right: 10px;
            padding: 10px 20px;
            transition: all 0.3s;
            text-decoration: none;
        }

        .filter-pills .nav-link.active,
        .filter-pills .nav-link:hover {
            background: #28a745;
            border-color: #28a745;
            color: white;
            transform: translateY(-2px);
        }

        .locataire-info {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 15px;
        }

        .property-info {
            background: #e9ecef;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 15px;
        }

        .action-buttons .btn {
            border-radius: 10px;
            padding: 10px 20px;
            font-weight: 600;
            margin-right: 10px;
            transition: all 0.3s;
        }

        .action-buttons .btn:hover {
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
            <a class="nav-link active" href="${pageContext.request.contextPath}/proprietaire/candidatures">
                <i class="fas fa-user-check me-2"></i>Candidatures
                <c:if test="${not empty statsStatuts['EN_ATTENTE'] and statsStatuts['EN_ATTENTE'] > 0}">
                    <span class="notification-badge">${statsStatuts['EN_ATTENTE']}</span>
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
            <h2 class="mb-0">Candidatures</h2>
            <p class="text-muted mb-0">Gérez les demandes de location pour vos propriétés</p>
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

    <!-- Statistiques -->
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="card stats-card text-center">
                <div class="text-warning mb-2">
                    <i class="fas fa-clock fa-2x"></i>
                </div>
                <div class="h4 mb-1">${statsStatuts['EN_ATTENTE'] != null ? statsStatuts['EN_ATTENTE'] : 0}</div>
                <small class="text-muted">En attente</small>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card stats-card text-center">
                <div class="text-success mb-2">
                    <i class="fas fa-check-circle fa-2x"></i>
                </div>
                <div class="h4 mb-1">${statsStatuts['APPROUVEE'] != null ? statsStatuts['APPROUVEE'] : 0}</div>
                <small class="text-muted">Approuvées</small>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card stats-card text-center">
                <div class="text-danger mb-2">
                    <i class="fas fa-times-circle fa-2x"></i>
                </div>
                <div class="h4 mb-1">${statsStatuts['REFUSEE'] != null ? statsStatuts['REFUSEE'] : 0}</div>
                <small class="text-muted">Refusées</small>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card stats-card text-center">
                <div class="text-info mb-2">
                    <i class="fas fa-file-signature fa-2x"></i>
                </div>
                <div class="h4 mb-1">${statsStatuts['CONTRAT_SIGNE'] != null ? statsStatuts['CONTRAT_SIGNE'] : 0}</div>
                <small class="text-muted">Contrats signés</small>
            </div>
        </div>
    </div>

    <!-- Filtres -->
    <div class="card stats-card mb-4">
        <div class="d-flex align-items-center justify-content-between flex-wrap">
            <h5 class="mb-0">
                <i class="fas fa-filter me-2 text-success"></i>
                Filtrer par statut
            </h5>
            <nav class="filter-pills">
                <a class="nav-link ${empty statutFilter ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/proprietaire/candidatures">
                    Toutes
                </a>
                <a class="nav-link ${statutFilter == 'EN_ATTENTE' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/proprietaire/candidatures?statut=EN_ATTENTE">
                    En attente
                </a>
                <a class="nav-link ${statutFilter == 'APPROUVEE' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/proprietaire/candidatures?statut=APPROUVEE">
                    Approuvées
                </a>
                <a class="nav-link ${statutFilter == 'REFUSEE' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/proprietaire/candidatures?statut=REFUSEE">
                    Refusées
                </a>
                <a class="nav-link ${statutFilter == 'CONTRAT_SIGNE' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/proprietaire/candidatures?statut=CONTRAT_SIGNE">
                    Contrats signés
                </a>
            </nav>
        </div>
    </div>

    <!-- Liste des candidatures -->
    <c:choose>
        <c:when test="${not empty candidatures}">
            <c:forEach var="candidature" items="${candidatures}">
                <div class="candidature-card ${fn:toLowerCase(fn:replace(candidature.statut, '_', '-'))}">
                    <div class="row align-items-center">
                        <div class="col-md-3">
                            <div class="locataire-info">
                                <h6 class="mb-1">
                                    <i class="fas fa-user me-2"></i>
                                        ${candidature.locataire.utilisateur.prenom} ${candidature.locataire.utilisateur.nom}
                                </h6>
                                <small class="text-muted">
                                    <i class="fas fa-envelope me-1"></i>
                                        ${candidature.locataire.utilisateur.email}
                                </small>
                                <c:if test="${not empty candidature.locataire.utilisateur.telephone}">
                                    <br>
                                    <small class="text-muted">
                                        <i class="fas fa-phone me-1"></i>
                                            ${candidature.locataire.utilisateur.telephone}
                                    </small>
                                </c:if>
                                <c:if test="${candidature.locataire.revenuMensuel != null}">
                                    <br>
                                    <small class="text-success">
                                        <i class="fas fa-euro-sign me-1"></i>
                                        <fmt:formatNumber value="${candidature.locataire.revenuMensuel}" pattern="#,##0.00"/>€/mois
                                    </small>
                                </c:if>
                            </div>
                        </div>

                        <div class="col-md-3">
                            <div class="property-info">
                                <h6 class="mb-1">
                                    <i class="fas fa-building me-2"></i>
                                        ${candidature.unite.immeuble.nom}
                                </h6>
                                <small class="text-muted">Unité ${candidature.unite.numero}</small>
                                <br>
                                <small class="text-muted">
                                    <i class="fas fa-home me-1"></i>
                                        ${candidature.unite.nombrePieces} pièce(s)
                                    <c:if test="${candidature.unite.superficie != null}">
                                        , ${candidature.unite.superficie}m²
                                    </c:if>
                                </small>
                                <br>
                                <small class="text-success">
                                    <i class="fas fa-euro-sign me-1"></i>
                                    <fmt:formatNumber value="${candidature.unite.loyer}" pattern="#,##0.00"/>€/mois
                                </small>
                            </div>
                        </div>

                        <div class="col-md-2 text-center">
                            <div class="mb-2">
                                <span class="status-badge status-${fn:toLowerCase(fn:replace(candidature.statut, '_', '-'))}">
                                    <c:choose>
                                        <c:when test="${candidature.statut == 'EN_ATTENTE'}">En attente</c:when>
                                        <c:when test="${candidature.statut == 'APPROUVEE'}">Approuvée</c:when>
                                        <c:when test="${candidature.statut == 'REFUSEE'}">Refusée</c:when>
                                        <c:when test="${candidature.statut == 'CONTRAT_SIGNE'}">Contrat signé</c:when>
                                        <c:otherwise>${candidature.statut}</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <small class="text-muted">
                                <i class="fas fa-calendar-alt me-1"></i>
                                <fmt:formatDate value="${candidature.dateCreation}" pattern="dd/MM/yyyy"/>
                            </small>
                            <c:if test="${candidature.dateDebutSouhaitee != null}">
                                <br>
                                <small class="text-info">
                                    Début souhaité: <fmt:formatDate value="${candidature.dateDebutSouhaitee}" pattern="dd/MM/yyyy"/>
                                </small>
                            </c:if>
                        </div>

                        <div class="col-md-4">
                            <div class="action-buttons text-end">
                                <a href="${pageContext.request.contextPath}/proprietaire/candidatures/view?id=${candidature.id}"
                                   class="btn btn-outline-info btn-sm">
                                    <i class="fas fa-eye me-1"></i>
                                    Détails
                                </a>

                                <c:if test="${candidature.statut == 'EN_ATTENTE'}">
                                    <a href="${pageContext.request.contextPath}/proprietaire/candidatures/manage?id=${candidature.id}"
                                       class="btn btn-warning btn-sm">
                                        <i class="fas fa-cogs me-1"></i>
                                        Gérer
                                    </a>
                                </c:if>

                                <c:if test="${candidature.statut == 'APPROUVEE'}">
                                    <form method="post"
                                          action="${pageContext.request.contextPath}/proprietaire/candidatures/create-contract"
                                          style="display: inline;">
                                        <input type="hidden" name="candidatureId" value="${candidature.id}"/>
                                        <button type="submit" class="btn btn-success btn-sm"
                                                onclick="return confirm('Créer le contrat pour cette candidature ?')">
                                            <i class="fas fa-file-contract me-1"></i>
                                            Créer contrat
                                        </button>
                                    </form>
                                </c:if>
                            </div>

                            <c:if test="${not empty candidature.commentaireProprietaire}">
                                <div class="mt-2">
                                    <small class="text-muted">
                                        <i class="fas fa-comment me-1"></i>
                                        Commentaire: ${candidature.commentaireProprietaire}
                                    </small>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <div class="card stats-card text-center py-5">
                <i class="fas fa-user-check fa-3x text-muted mb-3"></i>
                <h5 class="text-muted mb-2">Aucune candidature trouvée</h5>
                <p class="text-muted">
                    <c:choose>
                        <c:when test="${not empty statutFilter}">
                            Aucune candidature avec le statut
                            "<c:choose>
                            <c:when test="${statutFilter == 'EN_ATTENTE'}">En attente</c:when>
                            <c:when test="${statutFilter == 'APPROUVEE'}">Approuvée</c:when>
                            <c:when test="${statutFilter == 'REFUSEE'}">Refusée</c:when>
                            <c:when test="${statutFilter == 'CONTRAT_SIGNE'}">Contrat signé</c:when>
                            <c:otherwise>${statutFilter}</c:otherwise>
                        </c:choose>"
                            pour le moment.
                        </c:when>
                        <c:otherwise>
                            Aucune candidature reçue pour le moment. Les candidatures apparaîtront ici dès qu'un locataire postulera pour une de vos propriétés.
                        </c:otherwise>
                    </c:choose>
                </p>
                <a href="${pageContext.request.contextPath}/proprietaire/unites" class="btn btn-success">
                    <i class="fas fa-door-open me-2"></i>
                    Voir mes unités disponibles
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function() {
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