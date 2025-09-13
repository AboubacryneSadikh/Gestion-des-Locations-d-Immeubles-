<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Créer une unité" scope="request"/>

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

        .sidebar .nav-link:hover {
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

        .form-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            border: none;
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
            <h2 class="mb-0">Créer une unité</h2>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/proprietaire/dashboard">Tableau de bord</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/proprietaire/unites">Unités</a></li>
                    <li class="breadcrumb-item active">Créer</li>
                </ol>
            </nav>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/proprietaire/unites" class="btn btn-secondary">
                <i class="fas fa-arrow-left me-2"></i>Retour
            </a>
        </div>
    </div>

    <!-- Messages d'alerte -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-triangle me-2"></i>
                ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Formulaire -->
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card form-card">
                <form action="${pageContext.request.contextPath}/proprietaire/unites/create" method="post" class="needs-validation" novalidate>
                    <div class="row">
                        <!-- Immeuble -->
                        <div class="col-md-12 mb-3">
                            <label for="immeubleId" class="form-label">
                                <i class="fas fa-building me-2 text-success"></i>Immeuble *
                            </label>
                            <select class="form-select" id="immeubleId" name="immeubleId" required>
                                <option value="">Sélectionnez un immeuble</option>
                                <c:forEach var="immeuble" items="${immeubles}">
                                    <option value="${immeuble.id}" ${selectedImmeubleId == immeuble.id ? 'selected' : ''}>
                                            ${immeuble.nom} - ${immeuble.ville}
                                    </option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback">
                                Veuillez sélectionner un immeuble.
                            </div>
                        </div>

                        <!-- Numéro d'unité -->
                        <div class="col-md-6 mb-3">
                            <label for="numero" class="form-label">
                                <i class="fas fa-hashtag me-2 text-primary"></i>Numéro d'unité *
                            </label>
                            <input type="text" class="form-control" id="numero" name="numero"
                                   value="${numero}" required placeholder="Ex: A101, 2B, etc.">
                            <div class="invalid-feedback">
                                Le numéro d'unité est obligatoire.
                            </div>
                        </div>

                        <!-- Étage -->
                        <div class="col-md-6 mb-3">
                            <label for="etage" class="form-label">
                                <i class="fas fa-layer-group me-2 text-info"></i>Étage *
                            </label>
                            <input type="number" class="form-control" id="etage" name="etage"
                                   value="${etage}" required min="0" max="50">
                            <div class="invalid-feedback">
                                L'étage est obligatoire.
                            </div>
                        </div>

                        <!-- Nombre de pièces -->
                        <div class="col-md-6 mb-3">
                            <label for="nombrePieces" class="form-label">
                                <i class="fas fa-door-open me-2 text-warning"></i>Nombre de pièces *
                            </label>
                            <input type="number" class="form-control" id="nombrePieces" name="nombrePieces"
                                   value="${nombrePieces}" required min="1" max="20">
                            <div class="invalid-feedback">
                                Le nombre de pièces est obligatoire.
                            </div>
                        </div>

                        <!-- Superficie -->
                        <div class="col-md-6 mb-3">
                            <label for="superficie" class="form-label">
                                <i class="fas fa-expand-arrows-alt me-2 text-secondary"></i>Superficie (m²) *
                            </label>
                            <input type="number" step="0.01" class="form-control" id="superficie" name="superficie"
                                   value="${superficie}" required min="10" max="1000">
                            <div class="invalid-feedback">
                                La superficie est obligatoire.
                            </div>
                        </div>

                        <!-- Loyer -->
                        <div class="col-md-6 mb-3">
                            <label for="loyer" class="form-label">
                                <i class="fas fa-euro-sign me-2 text-success"></i>Loyer mensuel (€) *
                            </label>
                            <input type="number" step="0.01" class="form-control" id="loyer" name="loyer"
                                   value="${loyer}" required min="0">
                            <div class="invalid-feedback">
                                Le loyer mensuel est obligatoire.
                            </div>
                        </div>

                        <!-- Charges mensuelles -->
                        <div class="col-md-6 mb-3">
                            <label for="chargesMensuelles" class="form-label">
                                <i class="fas fa-receipt me-2 text-warning"></i>Charges mensuelles (€)
                            </label>
                            <input type="number" step="0.01" class="form-control" id="chargesMensuelles"
                                   name="chargesMensuelles" value="${chargesMensuelles}" min="0">
                            <small class="form-text text-muted">Optionnel</small>
                        </div>

                        <!-- Dépôt de garantie -->
                        <div class="col-md-12 mb-3">
                            <label for="depotGarantie" class="form-label">
                                <i class="fas fa-shield-alt me-2 text-danger"></i>Dépôt de garantie (€)
                            </label>
                            <input type="number" step="0.01" class="form-control" id="depotGarantie"
                                   name="depotGarantie" value="${depotGarantie}" min="0">
                            <small class="form-text text-muted">Optionnel</small>
                        </div>

                        <!-- Description -->
                        <div class="col-md-12 mb-3">
                            <label for="description" class="form-label">
                                <i class="fas fa-align-left me-2 text-info"></i>Description
                            </label>
                            <textarea class="form-control" id="description" name="description"
                                      rows="3" placeholder="Décrivez l'unité...">${description}</textarea>
                        </div>

                        <!-- Équipements -->
                        <div class="col-md-12 mb-3">
                            <label for="equipements" class="form-label">
                                <i class="fas fa-tools me-2 text-secondary"></i>Équipements
                            </label>
                            <textarea class="form-control" id="equipements" name="equipements"
                                      rows="3" placeholder="Listez les équipements disponibles...">${equipements}</textarea>
                        </div>
                    </div>

                    <!-- Boutons -->
                    <div class="d-flex justify-content-between">
                        <a href="${pageContext.request.contextPath}/proprietaire/unites"
                           class="btn btn-secondary">
                            <i class="fas fa-times me-2"></i>Annuler
                        </a>
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-save me-2"></i>Créer l'unité
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Validation du formulaire
    (function() {
        'use strict';
        window.addEventListener('load', function() {
            var forms = document.getElementsByClassName('needs-validation');
            var validation = Array.prototype.filter.call(forms, function(form) {
                form.addEventListener('submit', function(event) {
                    if (form.checkValidity() === false) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        }, false);
    })();

    // Calcul automatique du dépôt de garantie (2 mois de loyer)
    document.getElementById('loyer').addEventListener('input', function() {
        const loyer = parseFloat(this.value);
        const depotGarantie = document.getElementById('depotGarantie');

        if (loyer && loyer > 0) {
            depotGarantie.placeholder = 'Suggestion: ' + (loyer * 2).toFixed(2) + ' €';
        } else {
            depotGarantie.placeholder = '';
        }
    });
</script>
</body>
</html>