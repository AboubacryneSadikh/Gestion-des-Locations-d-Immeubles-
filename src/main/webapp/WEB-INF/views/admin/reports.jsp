<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Rapports - Administration" scope="request"/>

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

        .report-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            border: none;
            margin-bottom: 20px;
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .report-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        }

        .report-icon {
            width: 60px;
            height: 60px;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: white;
            margin-bottom: 15px;
        }

        .chart-container {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            height: 400px;
            margin-bottom: 20px;
        }

        .filter-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            margin-bottom: 20px;
        }

        .user-info {
            color: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 20px;
        }

        .metric-value {
            font-size: 2rem;
            font-weight: 700;
            color: #2c3e50;
        }

        .metric-label {
            color: #6c757d;
            font-size: 0.9rem;
        }

        .export-btn {
            border-radius: 25px;
            padding: 8px 20px;
        }

        .progress-custom {
            height: 8px;
            border-radius: 5px;
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
            <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
                <i class="fas fa-users me-2"></i>Gestion des utilisateurs
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link active" href="${pageContext.request.contextPath}/admin/reports">
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
    <!-- Top Bar -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0">Rapports et Statistiques</h2>
        <div>
            <button class="btn btn-success export-btn me-2" onclick="exportReport('pdf')">
                <i class="fas fa-file-pdf me-2"></i>Export PDF
            </button>
            <button class="btn btn-outline-success export-btn" onclick="exportReport('excel')">
                <i class="fas fa-file-excel me-2"></i>Export Excel
            </button>
        </div>
    </div>

    <!-- Filtres -->
    <div class="filter-card">
        <h5 class="mb-3"><i class="fas fa-filter me-2 text-primary"></i>Filtres</h5>
        <form id="filterForm">
            <div class="row">
                <div class="col-md-3">
                    <label class="form-label">Période</label>
                    <select class="form-select" id="period">
                        <option value="7">7 derniers jours</option>
                        <option value="30" selected>30 derniers jours</option>
                        <option value="90">3 derniers mois</option>
                        <option value="365">1 dernière année</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Type d'utilisateur</label>
                    <select class="form-select" id="userType">
                        <option value="ALL">Tous les types</option>
                        <option value="PROPRIETAIRE">Propriétaires</option>
                        <option value="LOCATAIRE">Locataires</option>
                        <option value="ADMIN">Administrateurs</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Statut</label>
                    <select class="form-select" id="status">
                        <option value="ALL">Tous les statuts</option>
                        <option value="ACTIVE">Actifs</option>
                        <option value="INACTIVE">Inactifs</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">&nbsp;</label>
                    <div>
                        <button type="button" class="btn btn-primary w-100" onclick="updateReports()">
                            <i class="fas fa-search me-2"></i>Actualiser
                        </button>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <!-- Métriques principales -->
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="report-card text-center">
                <div class="report-icon mx-auto" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                    <i class="fas fa-users"></i>
                </div>
                <div class="metric-value" id="totalUsersMetric">156</div>
                <div class="metric-label">Utilisateurs totaux</div>
                <div class="progress progress-custom mt-2">
                    <div class="progress-bar bg-primary" style="width: 75%"></div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="report-card text-center">
                <div class="report-icon mx-auto" style="background: linear-gradient(135deg, #28a745 0%, #20c997 100%);">
                    <i class="fas fa-user-tie"></i>
                </div>
                <div class="metric-value" id="proprietairesMetric">68</div>
                <div class="metric-label">Propriétaires</div>
                <div class="progress progress-custom mt-2">
                    <div class="progress-bar bg-success" style="width: 85%"></div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="report-card text-center">
                <div class="report-icon mx-auto" style="background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);">
                    <i class="fas fa-user"></i>
                </div>
                <div class="metric-value" id="locatairesMetric">84</div>
                <div class="metric-label">Locataires</div>
                <div class="progress progress-custom mt-2">
                    <div class="progress-bar bg-warning" style="width: 65%"></div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="report-card text-center">
                <div class="report-icon mx-auto" style="background: linear-gradient(135deg, #dc3545 0%, #e83e8c 100%);">
                    <i class="fas fa-chart-line"></i>
                </div>
                <div class="metric-value" id="growthMetric">+12%</div>
                <div class="metric-label">Croissance mensuelle</div>
                <div class="progress progress-custom mt-2">
                    <div class="progress-bar bg-danger" style="width: 60%"></div>
                </div>
            </div>
        </div>
    </div>

    <!-- Graphiques -->
    <div class="row">
        <div class="col-md-8">
            <div class="chart-container">
                <h5 class="mb-3">
                    <i class="fas fa-chart-area me-2 text-primary"></i>
                    Évolution des inscriptions par mois
                </h5>
                <canvas id="inscriptionsChart"></canvas>
            </div>
        </div>
        <div class="col-md-4">
            <div class="chart-container">
                <h5 class="mb-3">
                    <i class="fas fa-chart-pie me-2 text-primary"></i>
                    Répartition par type
                </h5>
                <canvas id="typeChart"></canvas>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-6">
            <div class="chart-container">
                <h5 class="mb-3">
                    <i class="fas fa-chart-bar me-2 text-primary"></i>
                    Activité par jour de la semaine
                </h5>
                <canvas id="weeklyChart"></canvas>
            </div>
        </div>
        <div class="col-md-6">
            <div class="chart-container">
                <h5 class="mb-3">
                    <i class="fas fa-chart-line me-2 text-primary"></i>
                    Taux d'activation des comptes
                </h5>
                <canvas id="activationChart"></canvas>
            </div>
        </div>
    </div>

    <!-- Tableau détaillé -->
    <div class="report-card">
        <h5 class="mb-3">
            <i class="fas fa-table me-2 text-primary"></i>
            Analyse détaillée par période
        </h5>
        <div class="table-responsive">
            <table class="table table-hover">
                <thead>
                <tr>
                    <th>Période</th>
                    <th>Nouvelles inscriptions</th>
                    <th>Propriétaires</th>
                    <th>Locataires</th>
                    <th>Taux d'activation</th>
                    <th>Taux de rétention</th>
                </tr>
                </thead>
                <tbody id="detailedTable">
                <tr>
                    <td>Janvier 2024</td>
                    <td><span class="badge bg-primary">24</span></td>
                    <td><span class="badge bg-success">12</span></td>
                    <td><span class="badge bg-warning">12</span></td>
                    <td>
                        <div class="progress" style="height: 20px;">
                            <div class="progress-bar bg-success" style="width: 87%">87%</div>
                        </div>
                    </td>
                    <td>
                        <div class="progress" style="height: 20px;">
                            <div class="progress-bar bg-info" style="width: 92%">92%</div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>Février 2024</td>
                    <td><span class="badge bg-primary">31</span></td>
                    <td><span class="badge bg-success">18</span></td>
                    <td><span class="badge bg-warning">13</span></td>
                    <td>
                        <div class="progress" style="height: 20px;">
                            <div class="progress-bar bg-success" style="width: 94%">94%</div>
                        </div>
                    </td>
                    <td>
                        <div class="progress" style="height: 20px;">
                            <div class="progress-bar bg-info" style="width: 89%">89%</div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>Mars 2024</td>
                    <td><span class="badge bg-primary">28</span></td>
                    <td><span class="badge bg-success">15</span></td>
                    <td><span class="badge bg-warning">13</span></td>
                    <td>
                        <div class="progress" style="height: 20px;">
                            <div class="progress-bar bg-success" style="width: 91%">91%</div>
                        </div>
                    </td>
                    <td>
                        <div class="progress" style="height: 20px;">
                            <div class="progress-bar bg-info" style="width: 95%">95%</div>
                        </div>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Chart.js Scripts -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Graphique des inscriptions
        const inscriptionsCtx = document.getElementById('inscriptionsChart').getContext('2d');
        const inscriptionsChart = new Chart(inscriptionsCtx, {
            type: 'line',
            data: {
                labels: ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun', 'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'],
                datasets: [{
                    label: 'Propriétaires',
                    data: [12, 18, 15, 22, 19, 25, 28, 24, 30, 26, 32, 29],
                    borderColor: '#28a745',
                    backgroundColor: 'rgba(40, 167, 69, 0.1)',
                    tension: 0.4,
                    fill: true
                }, {
                    label: 'Locataires',
                    data: [12, 13, 13, 16, 20, 18, 24, 22, 28, 25, 31, 27],
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

        // Graphique en camembert
        const typeCtx = document.getElementById('typeChart').getContext('2d');
        const typeChart = new Chart(typeCtx, {
            type: 'doughnut',
            data: {
                labels: ['Propriétaires', 'Locataires', 'Administrateurs'],
                datasets: [{
                    data: [68, 84, 4],
                    backgroundColor: ['#28a745', '#ffc107', '#667eea'],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                    }
                }
            }
        });

        // Graphique activité hebdomadaire
        const weeklyCtx = document.getElementById('weeklyChart').getContext('2d');
        const weeklyChart = new Chart(weeklyCtx, {
            type: 'bar',
            data: {
                labels: ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'],
                datasets: [{
                    label: 'Connexions',
                    data: [45, 52, 48, 61, 55, 32, 28],
                    backgroundColor: 'rgba(102, 126, 234, 0.8)',
                    borderColor: '#667eea',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
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

        // Graphique taux d'activation
        const activationCtx = document.getElementById('activationChart').getContext('2d');
        const activationChart = new Chart(activationCtx, {
            type: 'line',
            data: {
                labels: ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun'],
                datasets: [{
                    label: 'Taux d\'activation (%)',
                    data: [87, 94, 91, 96, 89, 93],
                    borderColor: '#dc3545',
                    backgroundColor: 'rgba(220, 53, 69, 0.1)',
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        min: 80,
                        max: 100,
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

    function updateReports() {
        // Ici vous pourriez faire un appel AJAX pour actualiser les données
        console.log('Actualisation des rapports...');

        // Animation des métriques
        animateValue('totalUsersMetric', 156, 2000);
        animateValue('proprietairesMetric', 68, 1500);
        animateValue('locatairesMetric', 84, 1800);

        // Afficher un message de succès
        showNotification('Rapports actualisés avec succès!', 'success');
    }

    function exportReport(format) {
        console.log('Export en format:', format);
        showNotification(`Export ${format.toUpperCase()} généré avec succès!`, 'success');
    }

    function animateValue(elementId, endValue, duration) {
        const element = document.getElementById(elementId);
        const startValue = parseInt(element.textContent) || 0;
        const range = endValue - startValue;
        const startTime = performance.now();

        function updateValue(currentTime) {
            const elapsed = currentTime - startTime;
            const progress = Math.min(elapsed / duration, 1);
            const currentValue = Math.floor(startValue + (range * progress));
            element.textContent = currentValue;

            if (progress < 1) {
                requestAnimationFrame(updateValue);
            }
        }

        requestAnimationFrame(updateValue);
    }

    function showNotification(message, type) {
        const alertDiv = document.createElement('div');
        alertDiv.className = `alert alert-${type} alert-dismissible fade show position-fixed`;
        alertDiv.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
        alertDiv.innerHTML = `
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;
        document.body.appendChild(alertDiv);

        setTimeout(() => {
            if (alertDiv.parentNode) {
                alertDiv.parentNode.removeChild(alertDiv);
            }
        }, 5000);
    }
</script>
</body>
</html>