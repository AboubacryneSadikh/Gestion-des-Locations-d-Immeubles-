<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Gestion des utilisateurs" scope="request"/>

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
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap5.min.css">

    <style>
        .sidebar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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

        .content-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            border: none;
        }

        .user-info {
            color: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 20px;
        }

        .role-badge {
            font-size: 0.75rem;
            padding: 4px 8px;
        }

        .status-active {
            background: #d4edda;
            color: #155724;
        }

        .status-inactive {
            background: #f8d7da;
            color: #721c24;
        }

        .filter-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .table-container {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        }

        .table th {
            background: #f8f9fa;
            border: none;
            font-weight: 600;
            color: #495057;
            padding: 15px 12px;
        }

        .table td {
            border: none;
            padding: 15px 12px;
            vertical-align: middle;
        }

        .table tbody tr {
            border-bottom: 1px solid #f1f3f4;
            transition: background-color 0.2s;
        }

        .table tbody tr:hover {
            background-color: #f8f9fa;
        }

        .action-buttons .btn {
            margin-right: 5px;
            border-radius: 20px;
        }
    </style>
</head>
<body>
<!-- Sidebar -->
<nav class="sidebar">
    <div class="user-info">
        <div class="d-flex align-items-center">
            <i class="fas fa-user-shield fa-2x me-3"></i>
            <div>
                <h6 class="mb-0">${sessionScope.userName}</h6>
                <small class="opacity-75">Administrateur</small>
            </div>
        </div>
    </div>

    <ul class="nav flex-column">
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="fas fa-tachometer-alt me-2"></i>Tableau de bord
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link active" href="${pageContext.request.contextPath}/admin/users">
                <i class="fas fa-users me-2"></i>Gestion des utilisateurs
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/admin/reports">
                <i class="fas fa-chart-bar me-2"></i>Rapports
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/admin/settings">
                <i class="fas fa-cog me-2"></i>Paramètres
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
            <h2 class="mb-0">Gestion des utilisateurs</h2>
            <p class="text-muted mb-0">Gérer tous les comptes utilisateurs de la plateforme</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/users/create" class="btn btn-primary">
            <i class="fas fa-user-plus me-2"></i>Nouvel utilisateur
        </a>
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

    <!-- Filtres -->
    <div class="filter-card">
        <form method="get" action="${pageContext.request.contextPath}/admin/users">
            <div class="row g-3">
                <div class="col-md-3">
                    <h4 class="text-danger">${nbInactifs}</h4>
                    <p class="text-muted mb-0">Inactifs</p>
                </div>
                <div class="col-md-3">
                    <label for="roleFilter" class="form-label">Rôle</label>
                    <select class="form-select" id="roleFilter" name="role">
                        <option value="">Tous les rôles</option>
                        <option value="ADMIN" ${roleFilter == 'ADMIN' ? 'selected' : ''}>Administrateur</option>
                        <option value="PROPRIETAIRE" ${roleFilter == 'PROPRIETAIRE' ? 'selected' : ''}>Propriétaire</option>
                        <option value="LOCATAIRE" ${roleFilter == 'LOCATAIRE' ? 'selected' : ''}>Locataire</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label for="statusFilter" class="form-label">Statut</label>
                    <select class="form-select" id="statusFilter" name="status">
                        <option value="">Tous les statuts</option>
                        <option value="ACTIVE" ${statusFilter == 'ACTIVE' ? 'selected' : ''}>Actif</option>
                        <option value="INACTIVE" ${statusFilter == 'INACTIVE' ? 'selected' : ''}>Inactif</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <label for="searchInput" class="form-label">Recherche</label>
                    <input type="text" class="form-control" id="searchInput" name="search"
                           placeholder="Nom, prénom ou email..." value="${searchQuery}">
                </div>
                <div class="col-md-2 d-flex align-items-end">
                    <button type="submit" class="btn btn-outline-primary me-2">
                        <i class="fas fa-search me-2"></i>Filtrer
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary">
                        <i class="fas fa-times"></i>
                    </a>
                </div>
            </div>
        </form>
    </div>

    <!-- Table des utilisateurs -->
    <div class="table-container">
        <table class="table table-hover" id="usersTable">
            <thead>
            <tr>
                <th>Utilisateur</th>
                <th>Email</th>
                <th>Rôle</th>
                <th>Statut</th>
                <th>Date d'inscription</th>
                <th>Dernière connexion</th>
                <th class="text-end">Actions</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty users}">
                    <c:forEach var="user" items="${users}">
                        <tr>
                            <td>
                                <div class="d-flex align-items-center">
                                    <div class="flex-shrink-0">
                                        <div class="rounded-circle bg-primary d-flex align-items-center justify-content-center"
                                             style="width: 40px; height: 40px; color: white;">
                                            <i class="fas ${user.role == 'ADMIN' ? 'fa-user-shield' :
                                                                  user.role == 'PROPRIETAIRE' ? 'fa-user-tie' : 'fa-user'}"></i>
                                        </div>
                                    </div>
                                    <div class="flex-grow-1 ms-3">
                                        <h6 class="mb-0">${user.prenom} ${user.nom}</h6>
                                        <c:if test="${not empty user.telephone}">
                                            <small class="text-muted">${user.telephone}</small>
                                        </c:if>
                                    </div>
                                </div>
                            </td>
                            <td>${user.email}</td>
                            <td>
                                <span class="badge role-badge
                                             ${user.role == 'ADMIN' ? 'bg-danger' :
                                               user.role == 'PROPRIETAIRE' ? 'bg-success' : 'bg-warning text-dark'}">
                                        ${user.role == 'ADMIN' ? 'Administrateur' :
                                                user.role == 'PROPRIETAIRE' ? 'Propriétaire' : 'Locataire'}
                                </span>
                            </td>
                            <td>
                                <span class="badge ${user.actif ? 'status-active' : 'status-inactive'}">
                                        ${user.actif ? 'Actif' : 'Inactif'}
                                </span>
                            </td>
                            <td><fmt:formatDate value="${user.dateCreation}" pattern="dd/MM/yyyy"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty user.derniereConnexion}">
                                        <fmt:formatDate value="${user.derniereConnexion}" pattern="dd/MM/yyyy HH:mm"/>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Jamais</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-end">
                                <div class="action-buttons">
                                    <a href="${pageContext.request.contextPath}/admin/users/edit?id=${user.id}"
                                       class="btn btn-sm btn-outline-primary" title="Modifier">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <c:if test="${user.id != sessionScope.userId}">
                                        <form method="post" action="${pageContext.request.contextPath}/admin/users/toggle-status"
                                              style="display: inline;"
                                              onsubmit="return confirm('Êtes-vous sûr de vouloir ${user.actif ? 'désactiver' : 'activer'} cet utilisateur ?')">
                                            <input type="hidden" name="id" value="${user.id}">
                                            <button type="submit" class="btn btn-sm ${user.actif ? 'btn-outline-warning' : 'btn-outline-success'}"
                                                    title="${user.actif ? 'Désactiver' : 'Activer'}">
                                                <i class="fas ${user.actif ? 'fa-pause' : 'fa-play'}"></i>
                                            </button>
                                        </form>

                                        <form method="post" action="${pageContext.request.contextPath}/admin/users/delete"
                                              style="display: inline;"
                                              onsubmit="return confirm('Êtes-vous sûr de vouloir supprimer cet utilisateur ? Cette action est irréversible.')">
                                            <input type="hidden" name="id" value="${user.id}">
                                            <button type="submit" class="btn btn-sm btn-outline-danger" title="Supprimer">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </form>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="7" class="text-center py-5">
                            <i class="fas fa-users fa-3x text-muted mb-3"></i>
                            <p class="text-muted">Aucun utilisateur trouvé</p>
                            <a href="${pageContext.request.contextPath}/admin/users/create" class="btn btn-primary">
                                <i class="fas fa-user-plus me-2"></i>Créer le premier utilisateur
                            </a>
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>

    <!-- Statistiques -->
    <c:if test="${not empty users}">
        <div class="content-card mt-4">
            <div class="row text-center">
                <div class="col-md-3">
                    <h4 class="text-primary">${users.size()}</h4>
                    <p class="text-muted mb-0">Total affiché</p>
                </div>
                <div class="col-md-3">
                    <h4 class="text-success">${nbProprietaires}</h4>
                    <p class="text-muted mb-0">Propriétaires</p>
                </div>
                <div class="col-md-3">
                    <h4 class="text-warning">${nbLocataires}</h4>
                    <p class="text-muted mb-0">Locataires</p>
                </div>
                <div class="col-md-3">
                    <h4 class="text-danger">${nbInactifs}</h4>
                    <p class="text-muted mb-0">Inactifs</p>
                </div>
            </div>
        </div>
    </c:if>
</div>

<!-- JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.11.5/js/dataTables.bootstrap5.min.js"></script>

<script>
    $(document).ready(function() {
        <c:if test="${not empty users}">
        $('#usersTable').DataTable({
            "language": {"url": "//cdn.datatables.net/plug-ins/1.11.5/i18n/fr-FR.json"},
            "order": [[ 4, "desc" ]],
            "pageLength": 25,
            "responsive": true,
            "columnDefs": [{ "orderable": false, "targets": 6 }]
        });
        </c:if>

        setTimeout(() => $('.alert').fadeOut('slow'), 5000);

        $('.btn-outline-danger').on('click', function(e) {
            if (!confirm('Êtes-vous sûr de vouloir supprimer cet utilisateur ? Cette action est irréversible.')) {
                e.preventDefault();
            }
        });

        $('#roleFilter, #statusFilter').on('change', function() {
            $(this).closest('form').submit();
        });

        let searchTimeout;
        $('#searchInput').on('input', function() {
            clearTimeout(searchTimeout);
            const form = $(this).closest('form');
            searchTimeout = setTimeout(function() {
                if ($('#searchInput').val().length >= 3 || $('#searchInput').val().length === 0) {
                    form.submit();
                }
            }, 500);
        });
    });
</script>
</body>
</html>
