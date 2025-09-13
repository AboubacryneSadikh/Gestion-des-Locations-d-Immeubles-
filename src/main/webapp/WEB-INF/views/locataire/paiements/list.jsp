<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Mes Paiements - Locataire" scope="request"/>

<!-- Configuration de la locale pour le formatage -->
<fmt:setLocale value="fr_FR"/>

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

        .payment-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            border: none;
            margin-bottom: 15px;
            transition: transform 0.3s, box-shadow 0.3s;
            border-left: 4px solid #dee2e6;
        }

        .payment-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .payment-card.paye {
            border-left-color: #28a745;
        }

        .payment-card.en-attente {
            border-left-color: #ffc107;
        }

        .payment-card.en-retard {
            border-left-color: #dc3545;
        }

        .stats-overview {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            border: none;
            margin-bottom: 30px;
        }

        .stat-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 20px;
        }

        .stat-item {
            text-align: center;
            padding: 20px;
            border-radius: 10px;
        }

        .stat-item.success {
            background: linear-gradient(135deg, #d4edda, #c3e6cb);
        }

        .stat-item.warning {
            background: linear-gradient(135deg, #fff3cd, #ffeaa7);
        }

        .stat-item.danger {
            background: linear-gradient(135deg, #f8d7da, #f5c6cb);
        }

        .stat-item.info {
            background: linear-gradient(135deg, #d1ecf1, #b6e7f0);
        }

        .stat-number {
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .urgent-payment {
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { opacity: 1; }
            50% { opacity: 0.7; }
            100% { opacity: 1; }
        }

        .btn-pay {
            background: linear-gradient(135deg, #28a745, #20c997);
            border: none;
            color: white;
            font-weight: 600;
            transition: all 0.3s;
        }

        .btn-pay:hover {
            background: linear-gradient(135deg, #218838, #1aa085);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
            color: white;
        }
    </style>
</head>
<body>

<!-- Sidebar -->
<nav class="sidebar">
    <div class="user-info" style="color: rgba(255, 255, 255, 0.9); padding: 20px; border-bottom: 1px solid rgba(255, 255, 255, 0.1); margin-bottom: 20px;">
        <div class="d-flex align-items-center">
            <i class="fas fa-user fa-2x me-3"></i>
            <div>
                <h6 class="mb-0">${sessionScope.utilisateur.prenom} ${sessionScope.utilisateur.nom}</h6>
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
            <a class="nav-link" href="${pageContext.request.contextPath}/locataire/recherche">
                <i class="fas fa-search me-2"></i>Rechercher un logement
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/locataire/contrats">
                <i class="fas fa-file-contract me-2"></i>Mes Contrats
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link active" href="${pageContext.request.contextPath}/locataire/paiements">
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
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0">Mes Paiements</h2>
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

    <c:choose>
        <c:when test="${not empty paiements}">
            <!-- Statistiques des paiements -->
            <div class="stats-overview">
                <h5 class="mb-3">
                    <i class="fas fa-chart-bar me-2 text-primary"></i>
                    Résumé des paiements
                </h5>
                <div class="stat-grid">
                    <div class="stat-item success">
                        <div class="stat-number text-success">
                            <c:set var="payes" value="0"/>
                            <c:forEach var="paiement" items="${paiements}">
                                <c:if test="${paiement.statut == 'PAYE'}">
                                    <c:set var="payes" value="${payes + 1}"/>
                                </c:if>
                            </c:forEach>
                                ${payes}
                        </div>
                        <div class="stat-label">Paiements effectués</div>
                    </div>

                    <div class="stat-item warning">
                        <div class="stat-number text-warning">
                            <c:set var="enAttente" value="0"/>
                            <c:forEach var="paiement" items="${paiements}">
                                <c:if test="${paiement.statut == 'EN_ATTENTE'}">
                                    <c:set var="enAttente" value="${enAttente + 1}"/>
                                </c:if>
                            </c:forEach>
                                ${enAttente}
                        </div>
                        <div class="stat-label">En attente</div>
                    </div>

                    <div class="stat-item danger">
                        <div class="stat-number text-danger">
                            <c:set var="enRetard" value="0"/>
                            <c:forEach var="paiement" items="${paiements}">
                                <c:if test="${paiement.statut == 'EN_RETARD'}">
                                    <c:set var="enRetard" value="${enRetard + 1}"/>
                                </c:if>
                            </c:forEach>
                                ${enRetard}
                        </div>
                        <div class="stat-label">En retard</div>
                    </div>

                    <div class="stat-item info">
                        <div class="stat-number text-info">
                            <!-- Calcul du total payé avec formatage simple -->
                            <c:set var="totalMontant" value="0"/>
                            <c:forEach var="paiement" items="${paiements}">
                                <c:if test="${paiement.statut == 'PAYE'}">
                                    <c:set var="totalMontant" value="${totalMontant + paiement.montant}"/>
                                </c:if>
                            </c:forEach>
                            <fmt:formatNumber value="${totalMontant}" pattern="#,##0"/> F CFA
                        </div>
                        <div class="stat-label">Total payé</div>
                    </div>
                </div>
            </div>

            <!-- Alerte paiements urgents -->
            <c:set var="paiementsUrgents" value="0"/>
            <c:forEach var="paiement" items="${paiements}">
                <c:if test="${paiement.statut == 'EN_RETARD'}">
                    <c:set var="paiementsUrgents" value="${paiementsUrgents + 1}"/>
                </c:if>
            </c:forEach>
            <c:if test="${paiementsUrgents > 0}">
                <div class="alert alert-danger d-flex align-items-center" role="alert">
                    <i class="fas fa-exclamation-triangle me-3 fa-2x"></i>
                    <div>
                        <h5 class="alert-heading mb-2">Paiements en retard</h5>
                        <p class="mb-0">
                            Vous avez ${paiementsUrgents} paiement(s) en retard.
                            Veuillez régulariser votre situation rapidement pour éviter des frais supplémentaires.
                        </p>
                    </div>
                    <div class="ms-auto">
                        <a href="${pageContext.request.contextPath}/locataire/paiement" class="btn btn-light">
                            <i class="fas fa-credit-card me-2"></i>Payer maintenant
                        </a>
                    </div>
                </div>
            </c:if>

            <!-- Liste des paiements -->
            <div id="paymentsContainer">
                <c:forEach var="paiement" items="${paiements}">
                    <div class="payment-card ${paiement.statut.toString().toLowerCase().replace('_', '-')} ${paiement.statut == 'EN_RETARD' ? 'urgent-payment' : ''}">

                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div class="flex-grow-1">
                                <div class="d-flex align-items-center mb-2">
                                    <h6 class="mb-0 me-2">
                                        Loyer <fmt:formatDate value="${paiement.dateEcheance}" pattern="MM/yyyy"/>
                                    </h6>
                                    <span class="badge bg-light text-dark">
                                        ${paiement.contrat.unite.immeuble.nom} - Unité ${paiement.contrat.unite.numero}
                                    </span>
                                </div>
                                <div class="text-muted">
                                    <i class="fas fa-map-marker-alt me-1"></i>
                                        ${paiement.contrat.unite.immeuble.adresse}, ${paiement.contrat.unite.immeuble.ville}
                                </div>
                            </div>
                            <div class="text-end">
                                <div class="fw-bold fs-5 mb-2">
                                    <!-- Formatage simple du montant -->
                                    <fmt:formatNumber value="${paiement.montant}" pattern="#,##0"/> F CFA
                                </div>
                                <span class="badge ${paiement.statut == 'PAYE' ? 'bg-success' : paiement.statut == 'EN_ATTENTE' ? 'bg-warning' : 'bg-danger'}">
                                    <c:choose>
                                        <c:when test="${paiement.statut == 'PAYE'}">
                                            <i class="fas fa-check me-1"></i>Payé
                                        </c:when>
                                        <c:when test="${paiement.statut == 'EN_ATTENTE'}">
                                            <i class="fas fa-clock me-1"></i>En attente
                                        </c:when>
                                        <c:when test="${paiement.statut == 'EN_RETARD'}">
                                            <i class="fas fa-exclamation-triangle me-1"></i>En retard
                                        </c:when>
                                        <c:otherwise>${paiement.statut}</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>

                        <div class="row text-center">
                            <div class="col-md-3">
                                <div class="small text-muted">Date d'échéance</div>
                                <div class="fw-bold">
                                    <fmt:formatDate value="${paiement.dateEcheance}" pattern="dd/MM/yyyy"/>
                                </div>
                            </div>

                            <c:if test="${paiement.statut == 'PAYE' and not empty paiement.datePaiement}">
                                <div class="col-md-3">
                                    <div class="small text-muted">Date de paiement</div>
                                    <div class="fw-bold text-success">
                                        <fmt:formatDate value="${paiement.datePaiement}" pattern="dd/MM/yyyy"/>
                                    </div>
                                </div>
                            </c:if>

                            <c:if test="${not empty paiement.modePaiement}">
                                <div class="col-md-3">
                                    <div class="small text-muted">Mode de paiement</div>
                                    <div class="fw-bold">${paiement.modePaiement}</div>
                                </div>
                            </c:if>

                            <div class="col-md-3">
                                <div class="small text-muted">Référence</div>
                                <div class="fw-bold">
                                        ${not empty paiement.numeroReference ? paiement.numeroReference : 'N/A'}
                                </div>
                            </div>
                        </div>

                        <!-- Actions pour paiements non payés -->
                        <c:if test="${paiement.statut != 'PAYE'}">
                            <div class="mt-3 pt-3 border-top d-flex justify-content-between align-items-center">
                                <div>
                                    <c:if test="${paiement.statut == 'EN_RETARD'}">
                                        <small class="text-danger">
                                            <i class="fas fa-exclamation-triangle me-1"></i>
                                            En retard depuis
                                            <c:set var="today" value="<%=new java.util.Date()%>"/>
                                            <c:set var="diffInDays" value="${(today.time - paiement.dateEcheance.time) / (1000 * 60 * 60 * 24)}"/>
                                            <strong><fmt:formatNumber value="${diffInDays}" maxFractionDigits="0"/> jour(s)</strong>
                                        </small>
                                    </c:if>
                                    <c:if test="${paiement.statut == 'EN_ATTENTE'}">
                                        <c:set var="today" value="<%=new java.util.Date()%>"/>
                                        <c:set var="daysUntilDue" value="${(paiement.dateEcheance.time - today.time) / (1000 * 60 * 60 * 24)}"/>
                                        <c:choose>
                                            <c:when test="${daysUntilDue <= 0}">
                                                <small class="text-danger">
                                                    <i class="fas fa-clock me-1"></i>Échéance atteinte
                                                </small>
                                            </c:when>
                                            <c:when test="${daysUntilDue <= 3}">
                                                <small class="text-warning">
                                                    <i class="fas fa-clock me-1"></i>
                                                    Échéance dans <strong><fmt:formatNumber value="${daysUntilDue}" maxFractionDigits="0"/> jour(s)</strong>
                                                </small>
                                            </c:when>
                                            <c:otherwise>
                                                <small class="text-muted">
                                                    <i class="fas fa-clock me-1"></i>
                                                    Échéance dans <fmt:formatNumber value="${daysUntilDue}" maxFractionDigits="0"/> jour(s)
                                                </small>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>
                                </div>
                                <a href="${pageContext.request.contextPath}/locataire/paiement?id=${paiement.id}"
                                   class="btn btn-pay btn-sm">
                                    <i class="fas fa-credit-card me-1"></i>
                                    <c:choose>
                                        <c:when test="${paiement.statut == 'EN_RETARD'}">Payer d'urgence</c:when>
                                        <c:otherwise>Payer maintenant</c:otherwise>
                                    </c:choose>
                                </a>
                            </div>
                        </c:if>

                        <!-- Actions pour paiements payés -->
                        <c:if test="${paiement.statut == 'PAYE'}">
                            <div class="mt-3 pt-3 border-top d-flex justify-content-end">
                                <button class="btn btn-outline-primary btn-sm me-2" onclick="downloadReceipt(${paiement.id})">
                                    <i class="fas fa-download me-1"></i>Télécharger reçu
                                </button>
                                <button class="btn btn-outline-secondary btn-sm" onclick="printReceipt(${paiement.id})">
                                    <i class="fas fa-print me-1"></i>Imprimer
                                </button>
                            </div>
                        </c:if>

                        <!-- Commentaires si présents -->
                        <c:if test="${not empty paiement.commentaires}">
                            <div class="mt-3 pt-3 border-top">
                                <small class="text-muted">
                                    <i class="fas fa-comment me-1"></i>
                                    <strong>Commentaire :</strong> ${paiement.commentaires}
                                </small>
                            </div>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <!-- État vide -->
            <div class="payment-card">
                <div class="text-center py-5">
                    <i class="fas fa-credit-card fa-4x text-muted mb-3"></i>
                    <h4 class="mb-3">Aucun paiement enregistré</h4>
                    <p class="mb-4 text-muted">
                        Vous n'avez encore aucun paiement de loyer enregistré.
                        Les paiements apparaîtront ici une fois que vous aurez un contrat de location actif.
                    </p>
                    <a href="${pageContext.request.contextPath}/locataire/contrats" class="btn btn-primary btn-lg">
                        <i class="fas fa-file-contract me-2"></i>Voir mes contrats
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function downloadReceipt(paymentId) {
        console.log('Télécharger reçu:', paymentId);
        alert('Le téléchargement du reçu sera bientôt disponible.');
    }

    function printReceipt(paymentId) {
        console.log('Imprimer reçu:', paymentId);
        window.open(`${pageContext.request.contextPath}/locataire/paiement/${paymentId}/recu`, '_blank');
    }

    // Animation pour les alertes
    document.addEventListener('DOMContentLoaded', function() {
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert-dismissible');
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