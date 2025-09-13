<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Gestion du contrat" scope="request"/>

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

        .manage-header {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
            color: white;
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }

        .contract-summary {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        }

        .action-card {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            transition: transform 0.3s;
        }

        .action-card:hover {
            transform: translateY(-5px);
        }

        .status-option {
            border: 2px solid #e9ecef;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            cursor: pointer;
            transition: all 0.3s;
            background: white;
        }

        .status-option:hover {
            border-color: #007bff;
            background: #f8f9ff;
        }

        .status-option.selected {
            border-color: #28a745;
            background: #f8fff8;
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.2);
        }

        .status-option input[type="radio"] {
            display: none;
        }

        .status-icon {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
            margin-right: 1rem;
        }

        .status-en-cours .status-icon { background: #28a745; }
        .status-en-attente .status-icon { background: #ffc107; }
        .status-termine .status-icon { background: #6c757d; }
        .status-resilie .status-icon { background: #dc3545; }

        .breadcrumb {
            background: white;
            padding: 1rem 1.5rem;
            border-radius: 10px;
            margin-bottom: 1.5rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .tenant-summary {
            display: flex;
            align-items: center;
            padding: 1rem;
            background: #f8f9fa;
            border-radius: 10px;
            margin-bottom: 1rem;
        }

        .tenant-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, #007bff 0%, #6610f2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            font-size: 1.2rem;
            margin-right: 1rem;
        }

        .property-summary {
            display: flex;
            align-items: center;
            padding: 1rem;
            background: #f8f9fa;
            border-radius: 10px;
            margin-bottom: 1rem;
        }

        .property-icon {
            width: 60px;
            height: 60px;
            border-radius: 10px;
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
            margin-right: 1rem;
        }

        .action-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 2rem;
        }

        .btn-action {
            border-radius: 10px;
            padding: 1rem 2rem;
            font-weight: 600;
            min-width: 150px;
            transition: all 0.3s;
        }

        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }

        .warning-box {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 10px;
            padding: 1rem;
            margin-top: 1rem;
        }

        .danger-box {
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            border-radius: 10px;
            padding: 1rem;
            margin-top: 1rem;
        }

        .additional-fields {
            display: none;
            margin-top: 1rem;
            padding: 1rem;
            background: #f8f9fa;
            border-radius: 10px;
        }

        .form-floating label {
            color: #6c757d;
        }

        .current-status {
            display: inline-flex;
            align-items: center;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .current-status.en-cours { background: #d4edda; color: #155724; }
        .current-status.en-attente { background: #fff3cd; color: #856404; }
        .current-status.termine { background: #e2e3e5; color: #383d41; }
        .current-status.resilie { background: #f8d7da; color: #721c24; }
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
            <a class="nav-link" href="${pageContext.request.contextPath}/proprietaire/candidatures">
                <i class="fas fa-user-check me-2"></i>Candidatures
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
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/proprietaire/contrats">Contrats</a>
            </li>
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/proprietaire/contrats/view?id=${contrat.id}">
                    Contrat ${contrat.numeroContrat}
                </a>
            </li>
            <li class="breadcrumb-item active">Gestion</li>
        </ol>
    </nav>

    <!-- Messages d'alerte -->
    <c:if test="${not empty sessionScope.error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-triangle me-2"></i>
                ${sessionScope.error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="error" scope="session"/>
    </c:if>

    <!-- En-tête -->
    <div class="manage-header">
        <div class="row align-items-center">
            <div class="col-md-8">
                <h2 class="mb-2">
                    <i class="fas fa-cogs me-2"></i>
                    Gestion du contrat ${contrat.numeroContrat}
                </h2>
                <p class="mb-0 opacity-75">Modifier le statut et les conditions du contrat</p>
            </div>
            <div class="col-md-4 text-end">
                <div class="d-flex align-items-center justify-content-end">
                    <span class="me-2">Statut actuel :</span>
                    <c:choose>
                        <c:when test="${contrat.statut == 'EN_COURS'}">
                            <span class="current-status en-cours">
                                <i class="fas fa-play-circle me-1"></i>En cours
                            </span>
                        </c:when>
                        <c:when test="${contrat.statut == 'EN_ATTENTE'}">
                            <span class="current-status en-attente">
                                <i class="fas fa-clock me-1"></i>En attente
                            </span>
                        </c:when>
                        <c:when test="${contrat.statut == 'TERMINE'}">
                            <span class="current-status termine">
                                <i class="fas fa-check-circle me-1"></i>Terminé
                            </span>
                        </c:when>
                        <c:when test="${contrat.statut == 'RESILIE'}">
                            <span class="current-status resilie">
                                <i class="fas fa-times-circle me-1"></i>Résilié
                            </span>
                        </c:when>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <!-- Résumé du contrat -->
    <div class="contract-summary">
        <h5 class="mb-3">
            <i class="fas fa-file-contract me-2 text-primary"></i>
            Résumé du contrat
        </h5>

        <div class="row">
            <div class="col-md-6">
                <!-- Locataire -->
                <div class="tenant-summary">
                    <div class="tenant-avatar">
                        ${contrat.locataire.utilisateur.prenom.substring(0,1)}${contrat.locataire.utilisateur.nom.substring(0,1)}
                    </div>
                    <div>
                        <h6 class="mb-1">${contrat.locataire.utilisateur.prenom} ${contrat.locataire.utilisateur.nom}</h6>
                        <small class="text-muted">
                            <i class="fas fa-phone me-1"></i>${contrat.locataire.utilisateur.telephone}
                        </small>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <!-- Propriété -->
                <div class="property-summary">
                    <div class="property-icon">
                        <i class="fas fa-door-open"></i>
                    </div>
                    <div>
                        <h6 class="mb-1">${contrat.unite.immeuble.nom} - Unité ${contrat.unite.numero}</h6>
                        <small class="text-muted">
                            <i class="fas fa-euro-sign me-1"></i>
                            <fmt:formatNumber value="${contrat.loyer}" type="currency" currencyCode="XOF"/> / mois
                        </small>
                    </div>
                </div>
            </div>
        </div>

        <div class="row mt-3">
            <div class="col-md-4">
                <small class="text-muted">Période du contrat :</small>
                <div class="fw-bold">
                    <fmt:formatDate value="${contrat.dateDebut}" pattern="dd/MM/yyyy"/> -
                    <fmt:formatDate value="${contrat.dateFin}" pattern="dd/MM/yyyy"/>
                </div>
            </div>
            <div class="col-md-4">
                <small class="text-muted">Créé le :</small>
                <div class="fw-bold">
                    <fmt:formatDate value="${contrat.dateCreation}" pattern="dd/MM/yyyy"/>
                </div>
            </div>
            <div class="col-md-4">
                <small class="text-muted">Jour de paiement :</small>
                <div class="fw-bold">${contrat.jourPaiement} de chaque mois</div>
            </div>
        </div>
    </div>

    <!-- Formulaire de gestion -->
    <div class="action-card">
        <h5 class="mb-4">
            <i class="fas fa-exchange-alt me-2 text-warning"></i>
            Changer le statut du contrat
        </h5>

        <form method="post" action="${pageContext.request.contextPath}/proprietaire/contrats/update-status" id="statusForm">
            <input type="hidden" name="contratId" value="${contrat.id}">

            <!-- Options de statut -->
            <div class="row">
                <!-- Activer le contrat (si en attente) -->
                <c:if test="${contrat.statut == 'EN_ATTENTE'}">
                    <div class="col-md-6">
                        <label class="status-option status-en-cours" for="status-en-cours">
                            <input type="radio" name="nouveauStatut" value="EN_COURS" id="status-en-cours">
                            <div class="d-flex align-items-center">
                                <div class="status-icon">
                                    <i class="fas fa-play"></i>
                                </div>
                                <div>
                                    <h6 class="mb-1">Activer le contrat</h6>
                                    <small class="text-muted">
                                        Marquer le contrat comme actif et en cours d'exécution
                                    </small>
                                </div>
                            </div>
                        </label>
                    </div>
                </c:if>

                <!-- Terminer le contrat -->
                <c:if test="${contrat.statut == 'EN_COURS'}">
                    <div class="col-md-6">
                        <label class="status-option status-termine" for="status-termine">
                            <input type="radio" name="nouveauStatut" value="TERMINE" id="status-termine">
                            <div class="d-flex align-items-center">
                                <div class="status-icon">
                                    <i class="fas fa-check"></i>
                                </div>
                                <div>
                                    <h6 class="mb-1">Terminer le contrat</h6>
                                    <small class="text-muted">
                                        Marquer le contrat comme terminé normalement
                                    </small>
                                </div>
                            </div>
                        </label>
                    </div>

                    <div class="col-md-6">
                        <label class="status-option status-resilie" for="status-resilie">
                            <input type="radio" name="nouveauStatut" value="RESILIE" id="status-resilie">
                            <div class="d-flex align-items-center">
                                <div class="status-icon">
                                    <i class="fas fa-times"></i>
                                </div>
                                <div>
                                    <h6 class="mb-1">Résilier le contrat</h6>
                                    <small class="text-muted">
                                        Annuler le contrat avant son terme normal
                                    </small>
                                </div>
                            </div>
                        </label>
                    </div>
                </c:if>

                <!-- Remettre en attente (si terminé ou résilié) -->
                <c:if test="${contrat.statut == 'TERMINE' || contrat.statut == 'RESILIE'}">
                    <div class="col-md-6">
                        <label class="status-option status-en-attente" for="status-en-attente">
                            <input type="radio" name="nouveauStatut" value="EN_ATTENTE" id="status-en-attente">
                            <div class="d-flex align-items-center">
                                <div class="status-icon">
                                    <i class="fas fa-clock"></i>
                                </div>
                                <div>
                                    <h6 class="mb-1">Remettre en attente</h6>
                                    <small class="text-muted">
                                        Remettre le contrat en statut d'attente
                                    </small>
                                </div>
                            </div>
                        </label>
                    </div>

                    <div class="col-md-6">
                        <label class="status-option status-en-cours" for="status-en-cours-2">
                            <input type="radio" name="nouveauStatut" value="EN_COURS" id="status-en-cours-2">
                            <div class="d-flex align-items-center">
                                <div class="status-icon">
                                    <i class="fas fa-play"></i>
                                </div>
                                <div>
                                    <h6 class="mb-1">Réactiver le contrat</h6>
                                    <small class="text-muted">
                                        Remettre le contrat en cours d'exécution
                                    </small>
                                </div>
                            </div>
                        </label>
                    </div>
                </c:if>
            </div>

            <!-- Champs supplémentaires pour la résiliation -->
            <div id="resiliation-fields" class="additional-fields">
                <h6><i class="fas fa-calendar-alt me-2"></i>Détails de la résiliation</h6>
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-floating">
                            <input type="date" class="form-control" name="dateResiliation" id="dateResiliation">
                            <label for="dateResiliation">Date de résiliation</label>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-floating">
                            <select class="form-select" name="motifResiliation" id="motifResiliation">
                                <option value="">Sélectionner un motif</option>
                                <option value="FIN_NORMALE">Fin normale du contrat</option>
                                <option value="DEMANDE_LOCATAIRE">Demande du locataire</option>
                                <option value="DEMANDE_PROPRIETAIRE">Demande du propriétaire</option>
                                <option value="NON_PAIEMENT">Non-paiement des loyers</option>
                                <option value="VIOLATION_CONTRAT">Violation du contrat</option>
                                <option value="VENTE_BIEN">Vente du bien</option>
                                <option value="AUTRE">Autre motif</option>
                            </select>
                            <label for="motifResiliation">Motif de résiliation</label>
                        </div>
                    </div>
                </div>
                <div class="mt-3">
                    <div class="form-floating">
                        <textarea class="form-control" name="commentaire" id="commentaire"
                                  style="height: 100px" placeholder="Commentaire optionnel"></textarea>
                        <label for="commentaire">Commentaire (optionnel)</label>
                    </div>
                </div>
                <div class="danger-box">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    <strong>Attention :</strong> La résiliation du contrat libérera automatiquement l'unité de location
                    et la rendra disponible pour de nouvelles candidatures.
                </div>
            </div>

            <!-- Champs pour la modification de dates -->
            <div id="date-modification-fields" class="additional-fields">
                <h6><i class="fas fa-calendar-alt me-2"></i>Modification des dates</h6>
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-floating">
                            <input type="date" class="form-control" name="nouvelleDateDebut" id="nouvelleDateDebut"
                                   value="<fmt:formatDate value='${contrat.dateDebut}' pattern='yyyy-MM-dd'/>">
                            <label for="nouvelleDateDebut">Nouvelle date de début</label>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-floating">
                            <input type="date" class="form-control" name="nouvelleDateFin" id="nouvelleDateFin"
                                   value="<fmt:formatDate value='${contrat.dateFin}' pattern='yyyy-MM-dd'/>">
                            <label for="nouvelleDateFin">Nouvelle date de fin</label>
                        </div>
                    </div>
                </div>
                <div class="warning-box">
                    <i class="fas fa-info-circle me-2"></i>
                    <strong>Information :</strong> La modification des dates n'est recommandée qu'en cas de nécessité absolue.
                    Assurez-vous d'avoir l'accord du locataire.
                </div>
            </div>

            <!-- Boutons d'action -->
            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/proprietaire/contrats/view?id=${contrat.id}"
                   class="btn btn-secondary btn-action">
                    <i class="fas fa-arrow-left me-2"></i>Annuler
                </a>
                <button type="submit" class="btn btn-primary btn-action" id="submitBtn" disabled>
                    <i class="fas fa-save me-2"></i>Appliquer les modifications
                </button>
            </div>
        </form>
    </div>

    <!-- Informations importantes -->
    <div class="alert alert-info">
        <h6><i class="fas fa-info-circle me-2"></i>Informations importantes</h6>
        <ul class="mb-0">
            <li>Le changement de statut affectera automatiquement la disponibilité de l'unité de location</li>
            <li>Un contrat activé (EN_COURS) marquera l'unité comme "LOUÉE"</li>
            <li>Un contrat terminé ou résilié libérera l'unité et la rendra "DISPONIBLE"</li>
            <li>Toutes les modifications sont enregistrées dans l'historique du contrat</li>
        </ul>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('statusForm');
        const submitBtn = document.getElementById('submitBtn');
        const statusOptions = document.querySelectorAll('input[name="nouveauStatut"]');
        const resiliationFields = document.getElementById('resiliation-fields');
        const dateModificationFields = document.getElementById('date-modification-fields');

        // Gestion de la sélection des options
        statusOptions.forEach(option => {
            option.addEventListener('change', function() {
                // Retirer la classe selected de tous les labels
                document.querySelectorAll('.status-option').forEach(label => {
                    label.classList.remove('selected');
                });

                // Ajouter la classe selected au label parent
                this.closest('.status-option').classList.add('selected');

                // Activer le bouton de soumission
                submitBtn.disabled = false;

                // Gérer l'affichage des champs supplémentaires
                resiliationFields.style.display = 'none';
                dateModificationFields.style.display = 'none';

                if (this.value === 'RESILIE') {
                    resiliationFields.style.display = 'block';
                } else if (this.value === 'EN_COURS' || this.value === 'TERMINE') {
                    dateModificationFields.style.display = 'block';
                }
            });
        });

        // Validation du formulaire
        form.addEventListener('submit', function(e) {
            const selectedStatus = document.querySelector('input[name="nouveauStatut"]:checked');

            if (!selectedStatus) {
                e.preventDefault();
                alert('Veuillez sélectionner un nouveau statut pour le contrat.');
                return false;
            }

            // Validation spécifique pour la résiliation
            if (selectedStatus.value === 'RESILIE') {
                const dateResiliation = document.getElementById('dateResiliation').value;
                const motifResiliation = document.getElementById('motifResiliation').value;

                if (!dateResiliation) {
                    e.preventDefault();
                    alert('Veuillez indiquer la date de résiliation.');
                    return false;
                }

                if (!motifResiliation) {
                    e.preventDefault();
                    alert('Veuillez sélectionner un motif de résiliation.');
                    return false;
                }

                // Vérifier que la date de résiliation n'est pas dans le passé
                const today = new Date();
                const resiliationDate = new Date(dateResiliation);

                if (resiliationDate < today) {
                    e.preventDefault();
                    alert('La date de résiliation ne peut pas être antérieure à aujourd\'hui.');
                    return false;
                }
            }

            // Validation des dates si modification
            if (selectedStatus.value === 'EN_COURS' || selectedStatus.value === 'TERMINE') {
                const dateDebut = document.getElementById('nouvelleDateDebut').value;
                const dateFin = document.getElementById('nouvelleDateFin').value;

                if (dateDebut && dateFin) {
                    const debut = new Date(dateDebut);
                    const fin = new Date(dateFin);

                    if (debut >= fin) {
                        e.preventDefault();
                        alert('La date de début doit être antérieure à la date de fin.');
                        return false;
                    }
                }
            }

            // Confirmation avant soumission
            const statusText = selectedStatus.closest('.status-option').querySelector('h6').textContent;
            const confirmation = confirm(`Êtes-vous sûr de vouloir ${statusText.toLowerCase()} ?`);

            if (!confirmation) {
                e.preventDefault();
                return false;
            }
        });

        // Définir la date minimale pour la résiliation (aujourd'hui)
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('dateResiliation').min = today;

        // Animation pour les alertes
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert-dismissible');
            alerts.forEach(alert => {
                alert.style.opacity = '0';
                alert.style.transition = 'opacity 0.5s';
                setTimeout(() => alert.remove(), 500);
            });
        }, 5000);
    });

    // Fonction pour afficher une confirmation personnalisée
    function showConfirmation(message) {
        return new Promise((resolve) => {
            const modal = document.createElement('div');
            modal.className = 'modal fade';
            modal.innerHTML = `
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Confirmation</h5>
                        </div>
                        <div class="modal-body">
                            <p>${message}</p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" onclick="resolve(false)">Annuler</button>
                            <button type="button" class="btn btn-primary" onclick="resolve(true)">Confirmer</button>
                        </div>
                    </div>
                </div>
            `;

            document.body.appendChild(modal);
            const bootstrapModal = new bootstrap.Modal(modal);
            bootstrapModal.show();

            modal.addEventListener('hidden.bs.modal', () => {
                document.body.removeChild(modal);
                resolve(false);
            });
        });
    }
</script>
</body>
</html>