<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Modifier ${immeuble.nom}" scope="request"/>

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
            <h2 class="mb-0">Modifier l'immeuble</h2>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/proprietaire/dashboard">Tableau de bord</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/proprietaire/immeubles">Immeubles</a></li>
                    <li class="breadcrumb-item active">Modifier ${immeuble.nom}</li>
                </ol>
            </nav>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/proprietaire/immeubles/view?id=${immeuble.id}"
               class="btn btn-info me-2">
                <i class="fas fa-eye me-2"></i>Voir détails
            </a>
            <a href="${pageContext.request.contextPath}/proprietaire/immeubles" class="btn btn-secondary">
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
                <!-- Info création -->
                <div class="alert alert-info mb-4">
                    <div class="row">
                        <div class="col-md-6">
                            <i class="fas fa-calendar-plus me-2"></i>
                            <strong>Créé le :</strong>
                            <fmt:formatDate value="${immeuble.dateCreation}" pattern="dd/MM/yyyy 'à' HH:mm"/>
                        </div>
                        <div class="col-md-6">
                            <c:if test="${not empty immeuble.dateModification}">
                                <i class="fas fa-calendar-edit me-2"></i>
                                <strong>Modifié le :</strong>
                                <fmt:formatDate value="${immeuble.dateModification}" pattern="dd/MM/yyyy 'à' HH:mm"/>
                            </c:if>
                        </div>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/proprietaire/immeubles/edit" method="post" class="needs-validation" novalidate>
                    <input type="hidden" name="id" value="${immeuble.id}">

                    <div class="row">
                        <!-- Nom de l'immeuble -->
                        <div class="col-md-12 mb-3">
                            <label for="nom" class="form-label">
                                <i class="fas fa-building me-2 text-success"></i>Nom de l'immeuble *
                            </label>
                            <input type="text" class="form-control" id="nom" name="nom"
                                   value="${immeuble.nom}" required placeholder="Ex: Résidence Les Palmiers">
                            <div class="invalid-feedback">
                                Le nom de l'immeuble est obligatoire.
                            </div>
                        </div>

                        <!-- Adresse -->
                        <div class="col-md-8 mb-3">
                            <label for="adresse" class="form-label">
                                <i class="fas fa-location-dot me-2 text-primary"></i>Adresse *
                            </label>
                            <input type="text" class="form-control" id="adresse" name="adresse"
                                   value="${immeuble.adresse}" required placeholder="Numéro et nom de la rue">
                            <div class="invalid-feedback">
                                L'adresse est obligatoire.
                            </div>
                        </div>

                        <!-- Code postal -->
                        <div class="col-md-4 mb-3">
                            <label for="codePostal" class="form-label">
                                <i class="fas fa-hashtag me-2 text-info"></i>Code postal
                            </label>
                            <input type="text" class="form-control" id="codePostal" name="codePostal"
                                   value="${immeuble.codePostal}" placeholder="Ex: 75001" pattern="[0-9]{5}">
                            <div class="invalid-feedback">
                                Le code postal doit contenir 5 chiffres.
                            </div>
                        </div>

                        <!-- Ville -->
                        <div class="col-md-12 mb-3">
                            <label for="ville" class="form-label">
                                <i class="fas fa-city me-2 text-warning"></i>Ville *
                            </label>
                            <input type="text" class="form-control" id="ville" name="ville"
                                   value="${immeuble.ville}" required placeholder="Nom de la ville">
                            <div class="invalid-feedback">
                                La ville est obligatoire.
                            </div>
                        </div>

                        <!-- Description -->
                        <div class="col-md-12 mb-3">
                            <label for="description" class="form-label">
                                <i class="fas fa-align-left me-2 text-info"></i>Description
                            </label>
                            <textarea class="form-control" id="description" name="description"
                                      rows="4" placeholder="Décrivez l'immeuble (standing, environnement, particularités...)">${immeuble.description}</textarea>
                            <small class="form-text text-muted">Cette description sera visible par les locataires potentiels</small>
                        </div>

                        <!-- Équipements -->
                        <div class="col-md-12 mb-4">
                            <label for="equipements" class="form-label">
                                <i class="fas fa-tools me-2 text-secondary"></i>Équipements et services
                            </label>
                            <textarea class="form-control" id="equipements" name="equipements"
                                      rows="3" placeholder="Ascenseur, parking, gardien, interphone, etc.">${immeuble.equipements}</textarea>
                            <small class="form-text text-muted">Listez les équipements disponibles dans l'immeuble</small>
                        </div>

                        <!-- Informations sur les unités -->
                        <div class="col-md-12 mb-3">
                            <div class="alert alert-light border">
                                <h6 class="alert-heading">
                                    <i class="fas fa-door-open text-success me-2"></i>
                                    Unités de cet immeuble
                                </h6>
                                <p class="mb-2">
                                    Cet immeuble contient actuellement <strong>${immeuble.nombreUnites != null ? immeuble.nombreUnites : 0} unité(s)</strong>.
                                </p>
                                <a href="${pageContext.request.contextPath}/proprietaire/unites?immeubleId=${immeuble.id}"
                                   class="btn btn-sm btn-outline-success">
                                    <i class="fas fa-door-open me-1"></i>Gérer les unités
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Boutons -->
                    <div class="d-flex justify-content-between">
                        <a href="${pageContext.request.contextPath}/proprietaire/immeubles"
                           class="btn btn-secondary">
                            <i class="fas fa-times me-2"></i>Annuler
                        </a>
                        <div>
                            <button type="button" class="btn btn-warning me-2" onclick="resetForm()">
                                <i class="fas fa-undo me-2"></i>Réinitialiser
                            </button>
                            <button type="submit" class="btn btn-success">
                                <i class="fas fa-save me-2"></i>Enregistrer les modifications
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Sauvegarde des valeurs originales pour la réinitialisation
    const originalValues = {
        nom: '${immeuble.nom}',
        adresse: '${immeuble.adresse}',
        codePostal: '${immeuble.codePostal}',
        ville: '${immeuble.ville}',
        description: '${immeuble.description}',
        equipements: '${immeuble.equipements}'
    };

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

    // Fonction pour réinitialiser le formulaire
    function resetForm() {
        if (confirm('Êtes-vous sûr de vouloir annuler vos modifications ?')) {
            document.getElementById('nom').value = originalValues.nom;
            document.getElementById('adresse').value = originalValues.adresse;
            document.getElementById('codePostal').value = originalValues.codePostal;
            document.getElementById('ville').value = originalValues.ville;
            document.getElementById('description').value = originalValues.description;
            document.getElementById('equipements').value = originalValues.equipements;

            // Enlever les classes de validation
            document.querySelector('form').classList.remove('was-validated');
        }
    }

    // Auto-formatage du nom de l'immeuble
    document.getElementById('nom').addEventListener('input', function() {
        const value = this.value;
        if (value.length > 0) {
            this.value = value.charAt(0).toUpperCase() + value.slice(1);
        }
    });

    // Auto-formatage de la ville
    document.getElementById('ville').addEventListener('input', function() {
        const value = this.value;
        if (value.length > 0) {
            this.value = value.charAt(0).toUpperCase() + value.slice(1);
        }
    });

    // Validation du code postal
    document.getElementById('codePostal').addEventListener('input', function() {
        this.value = this.value.replace(/[^0-9]/g, '').substring(0, 5);
    });
</script>
</body>
</html>