<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Détails de l’immeuble" scope="request"/>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
            color: rgba(255,255,255,0.9);
            padding: 12px 20px;
            border-radius: 0 25px 25px 0;
        }
        .sidebar .nav-link:hover,
        .sidebar .nav-link.active {
            background: rgba(255,255,255,0.15);
            color: white;
        }
        .main-content {
            margin-left: 250px;
            padding: 20px;
            background: #f8f9fa;
            min-height: 100vh;
        }
        .card-custom {
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            border: none;
        }
        .badge {
            font-size: 0.85rem;
        }
    </style>
</head>
<body>
<!-- Sidebar -->
<nav class="sidebar">
    <div class="user-info text-white p-3 border-bottom border-light">
        <i class="fas fa-user-tie fa-2x me-2"></i>
        <span>${sessionScope.utilisateur.prenom} ${sessionScope.utilisateur.nom}</span><br>
        <small>Propriétaire</small>
    </div>
    <ul class="nav flex-column mt-3">
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/proprietaire/dashboard">
                <i class="fas fa-tachometer-alt me-2"></i> Tableau de bord
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link active" href="${pageContext.request.contextPath}/proprietaire/immeubles">
                <i class="fas fa-building me-2"></i> Mes immeubles
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/proprietaire/unites">
                <i class="fas fa-door-open me-2"></i> Mes unités
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/proprietaire/contrats">
                <i class="fas fa-file-contract me-2"></i> Contrats
            </a>
        </li>
        <li class="nav-item mt-auto">
            <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                <i class="fas fa-sign-out-alt me-2"></i> Déconnexion
            </a>
        </li>
    </ul>
</nav>

<!-- Main Content -->
<div class="main-content">
    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0"><i class="fas fa-building me-2 text-success"></i> ${immeuble.nom}</h2>
        <div class="text-muted">
            <i class="fas fa-calendar-alt me-2"></i>
            <fmt:formatDate value="<%=new java.util.Date()%>" pattern="dd/MM/yyyy HH:mm"/>
        </div>
    </div>

    <!-- Infos immeuble -->
    <div class="card card-custom mb-4">
        <div class="card-body">
            <h5 class="card-title text-success">Informations générales</h5>
            <p><i class="fas fa-map-marker-alt me-2 text-muted"></i> ${immeuble.adresse}, ${immeuble.ville} ${immeuble.codePostal}</p>
            <p><i class="fas fa-align-left me-2 text-muted"></i> ${immeuble.description}</p>
            <p><i class="fas fa-cogs me-2 text-muted"></i> ${immeuble.equipements}</p>
            <p><i class="fas fa-calendar-plus me-2 text-muted"></i>
                Créé le <fmt:formatDate value="${immeuble.dateCreation}" pattern="dd/MM/yyyy"/>
            </p>
        </div>
    </div>

    <!-- Liste des unités -->
    <div class="card card-custom">
        <div class="card-body">
            <h5 class="card-title text-success"><i class="fas fa-door-open me-2"></i>Unités de l’immeuble</h5>

            <c:if test="${empty unites}">
                <div class="alert alert-info">Aucune unité enregistrée pour cet immeuble.</div>
            </c:if>

            <c:if test="${not empty unites}">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                    <tr>
                        <th>#</th>
                        <th>Pièces</th>
                        <th>Superficie</th>
                        <th>Loyer</th>
                        <th>Étage</th>
                        <th>Statut</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="unite" items="${unites}">
                        <tr>
                            <td>${unite.numero}</td>
                            <td>${unite.nombrePieces}</td>
                            <td>${unite.superficie} m²</td>
                            <td><fmt:formatNumber value="${unite.loyer}" type="number"/> FCFA</td>
                            <td>${unite.etage}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${unite.statut == 'DISPONIBLE'}">
                                        <span class="badge bg-success"><i class="fas fa-check"></i> Disponible</span>
                                    </c:when>
                                    <c:when test="${unite.statut == 'LOUE'}">
                                        <span class="badge bg-danger"><i class="fas fa-times"></i> Loué</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">${unite.statut}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/proprietaire/unites/edit?id=${unite.id}"
                                   class="btn btn-sm btn-outline-primary"><i class="fas fa-edit"></i></a>
                                <a href="${pageContext.request.contextPath}/proprietaire/unites/delete?id=${unite.id}"
                                   class="btn btn-sm btn-outline-danger"
                                   onclick="return confirm('Confirmer la suppression ?');"><i class="fas fa-trash"></i></a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:if>
        </div>
    </div>

    <a href="${pageContext.request.contextPath}/proprietaire/immeubles"
       class="btn btn-secondary mt-3"><i class="fas fa-arrow-left"></i> Retour</a>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
