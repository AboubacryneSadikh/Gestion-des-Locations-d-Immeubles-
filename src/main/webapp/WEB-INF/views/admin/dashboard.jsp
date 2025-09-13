<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Tableau de bord - Administration" scope="request"/>

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

        .chart-container {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            height: 400px;
        }

        .recent-activity {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            max-height: 500px;
            overflow-y: auto;
        }

        .activity-item {
            padding: 15px 0;
            border-bottom: 1px solid #eee;
            display: flex;
            align-items: center;
        }

        .activity-item:last-child {
            border-bottom: none;
        }

        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            color: white;
        }

        .navbar-brand {
            font-weight: 700;
            color: white !important;
        }

        .user-info {
            color: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 20px;
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
    <!-- Top Bar -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0">Tableau de bord administrateur</h2>
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
                <div class="stats-icon mx-auto" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                    <i class="fas fa-users"></i>
                </div>
                <div class="stats-number">${totalUsers}</div>
                <h6 class="text-muted">Total Utilisateurs</h6>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card stats-card text-center">
                <div class="stats-icon mx-auto" style="background: linear-gradient(135deg, #28a745 0%, #20c997 100%);">
                    <i class="fas fa-user-tie"></i>
                </div>
                <div class="stats-number">${totalProprietaires}</div>
                <h6 class="text-muted">Propriétaires</h6>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card stats-card text-center">
                <div class="stats-icon mx-auto" style="background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);">
                    <i class="fas fa-user"></i>
                </div>
                <div class="stats-number">${totalLocataires}</div>
                <h6 class="text-muted">Locataires</h6>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card stats-card text-center">
                <div class="stats-icon mx-auto" style="background: linear-gradient(135deg, #dc3545 0%, #e83e8c 100%);">
                    <i class="fas fa-building"></i>
                </div>
                <div class="stats-number">${totalImmeubles}</div>
                <h6 class="text-muted">Immeubles</h6>
            </div>
        </div>
    </div>

    <!-- Deuxième ligne de statistiques -->
    <div class="row mb-4">
        <div class="col-md-12">
            <div class="card stats-card text-center">
                <div class="row">
                    <div class="col-md-6">
                        <div class="stats-icon mx-auto mb-3" style="background: linear-gradient(135deg, #6f42c1 0%, #e83e8c 100%);">
                            <i class="fas fa-file-contract"></i>
                        </div>
                        <div class="stats-number">${totalContrats}</div>
                        <h6 class="text-muted">Contrats Actifs</h6>
                    </div>
                    <div class="col-md-6">
                        <div class="d-flex justify-content-center align-items-center h-100">
                            <div class="text-center">
                                <h5 class="text-primary mb-3">Vue d'ensemble du système</h5>
                                <p class="text-muted">Gestion centralisée de tous les utilisateurs et propriétés</p>
                                <div class="d-flex justify-content-center gap-3 mt-3">
                                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-primary btn-sm">
                                        <i class="fas fa-users me-2"></i>Gérer les utilisateurs
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/reports" class="btn btn-outline-secondary btn-sm">
                                        <i class="fas fa-chart-bar me-2"></i>Voir les rapports
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Graphiques et activités récentes -->
    <div class="row">
        <div class="col-md-8">
            <div class="chart-container">
                <h5 class="mb-3">
                    <i class="fas fa-chart-line me-2 text-primary"></i>
                    Évolution des inscriptions
                </h5>
                <canvas id="inscriptionsChart"></canvas>
            </div>
        </div>
        <div class="col-md-4">
            <div class="recent-activity">
                <h5 class="mb-3">
                    <i class="fas fa-clock me-2 text-primary"></i>
                    Utilisateurs récents
                </h5>
                <c:choose>
                    <c:when test="${not empty recentUsers}">
                        <c:forEach var="user" items="${recentUsers}">
                            <div class="activity-item">
                                <div class="activity-icon"
                                     style="background: ${user.role == 'PROPRIETAIRE' ? 'linear-gradient(135deg, #28a745 0%, #20c997 100%)' :
                                             user.role == 'LOCATAIRE' ? 'linear-gradient(135deg, #ffc107 0%, #fd7e14 100%)' :
                                                     'linear-gradient(135deg, #667eea 0%, #764ba2 100%)'};">
                                    <i class="fas ${user.role == 'PROPRIETAIRE' ? 'fa-user-tie' :
                                                     user.role == 'LOCATAIRE' ? 'fa-user' :
                                                     'fa-user-shield'}"></i>
                                </div>
                                <div class="flex-grow-1">
                                    <div class="fw-bold">${user.prenom} ${user.nom}</div>
                                    <small class="text-muted">${user.email}</small>
                                    <br>
                                    <small class="badge bg-light text-dark">${user.role}</small>
                                    <small class="text-muted ms-2">
                                        <fmt:formatDate value="${user.dateCreation}" pattern="dd/MM/yyyy"/>
                                    </small>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-4">
                            <i class="fas fa-users fa-3x text-muted mb-3"></i>
                            <p class="text-muted">Aucun utilisateur récent</p>
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
                <div class="row">
                    <div class="col-md-3">
                        <a href="${pageContext.request.contextPath}/admin/users/create"
                           class="btn btn-outline-primary w-100 mb-2">
                            <i class="fas fa-user-plus me-2"></i>
                            Ajouter un utilisateur
                        </a>
                    </div>
                    <div class="col-md-3">
                        <a href="${pageContext.request.contextPath}/admin/users?status=INACTIVE"
                           class="btn btn-outline-warning w-100 mb-2">
                            <i class="fas fa-user-slash me-2"></i>
                            Comptes inactifs
                        </a>
                    </div>
                    <div class="col-md-3">
                        <a href="${pageContext.request.contextPath}/admin/reports"
                           class="btn btn-outline-info w-100 mb-2">
                            <i class="fas fa-file-alt me-2"></i>
                            Générer un rapport
                        </a>
                    </div>
                    <div class="col-md-3">
                        <a href="${pageContext.request.contextPath}/admin/settings"
                           class="btn btn-outline-secondary w-100 mb-2">
                            <i class="fas fa-cogs me-2"></i>
                            Configuration
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
        // Graphique des inscriptions
        const ctx = document.getElementById('inscriptionsChart').getContext('2d');

        // Données simulées pour le graphique (dans une vraie application, ces données viendraient du serveur)
        const inscriptionsChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun'],
                datasets: [{
                    label: 'Propriétaires',
                    data: [2, 5, 3, 8, 6, 4],
                    borderColor: '#28a745',
                    backgroundColor: 'rgba(40, 167, 69, 0.1)',
                    tension: 0.4,
                    fill: true
                }, {
                    label: 'Locataires',
                    data: [3, 8, 5, 12, 9, 7],
                    borderColor: '#ffc107',
                    backgroundColor: 'rgba(255, 193, 7, 0.1)',
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'top',
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: 'rgba(0,0,0,0.1)'
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        }
                    }
                }
            }
        });
    });
</script>
</body>
</html><a class="nav-link active" href="${pageContext.request.contextPath}/admin/dashboard">
    <i class="fas fa-tachometer-alt me-2"></i>Tableau de bord
</a>
</li>
<li class="nav-item">
    <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
        <i class="fas fa-users me-2"></i>Gestion des utilisateurs
    </a>
</li>
<li class="nav-item">
    <a class="nav-link" href="${pageContext.request.contextPath}/admin/reports">
        <i class="fas fa-chart-bar me-2"></i>Rapports
    </a>
</li>
<li class="nav-item">