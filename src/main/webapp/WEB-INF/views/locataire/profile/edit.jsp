<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Modifier mon profil - Locataire" scope="request"/>

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

        .form-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            border: none;
            margin-bottom: 20px;
        }

        .form-section {
            margin-bottom: 30px;
        }

        .form-section:last-child {
            margin-bottom: 0;
        }

        .section-header {
            border-bottom: 2px solid #f8f9fa;
            padding-bottom: 15px;
            margin-bottom: 25px;
        }

        .section-header h5 {
            margin: 0;
            color: #495057;
        }

        .form-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 8px;
        }

        .form-control:focus,
        .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }

        .required {
            color: #dc3545;
        }

        .user-info {
            color: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 20px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #5a67d8 0%, #6b4196 100%);
        }

        .form-text {
            font-size: 0.875rem;
        }

        .input-group-text {
            background-color: #f8f9fa;
            border-color: #ced4da;
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
            <a class="nav-link active" href="${pageContext.request.contextPath}/locataire/profile">
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
        <div class="d-flex align-items-center">
            <a href="${pageContext.request.contextPath}/locataire/profile"
               class="btn btn-outline-secondary me-3">
                <i class="fas fa-arrow-left me-1"></i>Retour
            </a>
            <h2 class="mb-0">Modifier mon profil</h2>
        </div>
        <div class="text-muted">
            <i class="fas fa-calendar-alt me-2"></i>
            <fmt:formatDate value="<%=new java.util.Date()%>" pattern="dd/MM/yyyy HH:mm"/>
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

    <c:if test="${not empty sessionScope.success}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle me-2"></i>
                ${sessionScope.success}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="success" scope="session"/>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/locataire/profile-update" novalidate>
        <div class="row">
            <div class="col-md-8">
                <!-- Informations professionnelles -->
                <div class="form-card">
                    <div class="section-header">
                        <h5>
                            <i class="fas fa-briefcase me-2 text-primary"></i>
                            Informations professionnelles
                        </h5>
                    </div>

                    <div class="form-section">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="profession" class="form-label">
                                        Profession <span class="required">*</span>
                                    </label>
                                    <input type="text" class="form-control" id="profession" name="profession"
                                           value="${not empty profession ? profession : locataire.profession}"
                                           placeholder="Ex: Ingénieur, Professeur..." required>
                                    <div class="form-text">Votre profession actuelle</div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="employeur" class="form-label">Employeur</label>
                                    <input type="text" class="form-control" id="employeur" name="employeur"
                                           value="${not empty employeur ? employeur : locataire.employeur}"
                                           placeholder="Nom de votre entreprise">
                                    <div class="form-text">Nom de votre employeur ou entreprise</div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="revenuMensuel" class="form-label">
                                        Revenu mensuel net <span class="required">*</span>
                                    </label>
                                    <div class="input-group">
                                        <input type="number" class="form-control" id="revenuMensuel" name="revenuMensuel"
                                               value="${not empty revenuMensuel ? revenuMensuel : locataire.revenuMensuel}"
                                               placeholder="2500" step="0.01" min="0" required>
                                        <span class="input-group-text">€</span>
                                    </div>
                                    <div class="form-text">Votre revenu mensuel net en euros</div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="numeroIdentification" class="form-label">Numéro d'identification</label>
                                    <input type="text" class="form-control" id="numeroIdentification" name="numeroIdentification"
                                           value="${not empty numeroIdentification ? numeroIdentification : locataire.numeroIdentification}"
                                           placeholder="CNI, Passeport...">
                                    <div class="form-text">Numéro de carte d'identité ou passeport</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Informations de l'employeur -->
                <div class="form-card">
                    <div class="section-header">
                        <h5>
                            <i class="fas fa-building me-2 text-primary"></i>
                            Informations de l'employeur (optionnel)
                        </h5>
                    </div>

                    <div class="form-section">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="telephoneEmployeur" class="form-label">Téléphone employeur</label>
                                    <input type="tel" class="form-control" id="telephoneEmployeur" name="telephoneEmployeur"
                                           value="${locataire.telephoneEmployeur}"
                                           placeholder="01 23 45 67 89">
                                    <div class="form-text">Numéro de téléphone de votre employeur</div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="adresseEmployeur" class="form-label">Adresse employeur</label>
                                    <input type="text" class="form-control" id="adresseEmployeur" name="adresseEmployeur"
                                           value="${locataire.adresseEmployeur}"
                                           placeholder="123 rue de l'Entreprise, 75001 Paris">
                                    <div class="form-text">Adresse complète de votre lieu de travail</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Contact d'urgence -->
                <div class="form-card">
                    <div class="section-header">
                        <h5>
                            <i class="fas fa-user-friends me-2 text-primary"></i>
                            Contact d'urgence (optionnel)
                        </h5>
                    </div>

                    <div class="form-section">
                        <div class="row">
                            <div class="col-md-4">
                                <div class="mb-3">
                                    <label for="contactUrgenceNom" class="form-label">Nom complet</label>
                                    <input type="text" class="form-control" id="contactUrgenceNom" name="contactUrgenceNom"
                                           value="${locataire.contactUrgenceNom}"
                                           placeholder="Jean Dupont">
                                    <div class="form-text">Nom de votre contact d'urgence</div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="mb-3">
                                    <label for="contactUrgenceTelephone" class="form-label">Téléphone</label>
                                    <input type="tel" class="form-control" id="contactUrgenceTelephone" name="contactUrgenceTelephone"
                                           value="${locataire.contactUrgenceTelephone}"
                                           placeholder="06 12 34 56 78">
                                    <div class="form-text">Numéro de téléphone</div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="mb-3">
                                    <label for="contactUrgenceRelation" class="form-label">Relation</label>
                                    <select class="form-select" id="contactUrgenceRelation" name="contactUrgenceRelation">
                                        <option value="">Sélectionner...</option>
                                        <option value="Conjoint(e)" ${locataire.contactUrgenceRelation == 'Conjoint(e)' ? 'selected' : ''}>Conjoint(e)</option>
                                        <option value="Parent" ${locataire.contactUrgenceRelation == 'Parent' ? 'selected' : ''}>Parent</option>
                                        <option value="Enfant" ${locataire.contactUrgenceRelation == 'Enfant' ? 'selected' : ''}>Enfant</option>
                                        <option value="Frère/Sœur" ${locataire.contactUrgenceRelation == 'Frère/Sœur' ? 'selected' : ''}>Frère/Sœur</option>
                                        <option value="Ami(e)" ${locataire.contactUrgenceRelation == 'Ami(e)' ? 'selected' : ''}>Ami(e)</option>
                                        <option value="Autre" ${locataire.contactUrgenceRelation == 'Autre' ? 'selected' : ''}>Autre</option>
                                    </select>
                                    <div class="form-text">Votre lien avec cette personne</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Sidebar droite -->
            <div class="col-md-4">
                <!-- Actions -->
                <div class="form-card">
                    <h5 class="mb-3">
                        <i class="fas fa-save me-2 text-primary"></i>
                        Enregistrer les modifications
                    </h5>

                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary btn-lg">
                            <i class="fas fa-save me-2"></i>Enregistrer
                        </button>
                        <a href="${pageContext.request.contextPath}/locataire/profile"
                           class="btn btn-outline-secondary">
                            <i class="fas fa-times me-2"></i>Annuler
                        </a>
                    </div>
                </div>

                <!-- Aide -->
                <div class="form-card">
                    <h5 class="mb-3">
                        <i class="fas fa-question-circle me-2 text-info"></i>
                        Aide
                    </h5>

                    <div class="alert alert-info">
                        <small>
                            <i class="fas fa-info-circle me-2"></i>
                            Les champs marqués d'un astérisque (<span class="required">*</span>) sont obligatoires.
                        </small>
                    </div>

                    <div class="alert alert-warning">
                        <small>
                            <i class="fas fa-shield-alt me-2"></i>
                            Vos informations personnelles sont protégées et ne seront partagées
                            qu'avec les propriétaires concernés lors de vos demandes de location.
                        </small>
                    </div>
                </div>

                <!-- Conseils -->
                <div class="form-card">
                    <h5 class="mb-3">
                        <i class="fas fa-lightbulb me-2 text-warning"></i>
                        Conseils
                    </h5>

                    <div class="mb-3">
                        <h6 class="small fw-bold">Revenu mensuel</h6>
                        <p class="small text-muted">
                            Indiquez votre revenu net réel. Un revenu trop élevé ou trop faible
                            par rapport à la réalité pourrait compromettre votre candidature.
                        </p>
                    </div>

                    <div class="mb-3">
                        <h6 class="small fw-bold">Contact d'urgence</h6>
                        <p class="small text-muted">
                            Un contact d'urgence peut rassurer les propriétaires sur votre sérieux
                            et leur donner une personne à contacter si nécessaire.
                        </p>
                    </div>

                    <div>
                        <h6 class="small fw-bold">Informations employeur</h6>
                        <p class="small text-muted">
                            Ces informations peuvent être utiles pour vérifier votre situation
                            professionnelle lors de l'étude de votre candidature.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Validation côté client
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.querySelector('form');
        const requiredFields = form.querySelectorAll('[required]');

        form.addEventListener('submit', function(e) {
            let isValid = true;

            requiredFields.forEach(field => {
                if (!field.value.trim()) {
                    field.classList.add('is-invalid');
                    isValid = false;
                } else {
                    field.classList.remove('is-invalid');
                }
            });

            // Validation du revenu mensuel
            const revenuField = document.getElementById('revenuMensuel');
            if (revenuField.value && parseFloat(revenuField.value) < 0) {
                revenuField.classList.add('is-invalid');
                isValid = false;
            }

            if (!isValid) {
                e.preventDefault();
                const firstInvalid = form.querySelector('.is-invalid');
                if (firstInvalid) {
                    firstInvalid.focus();
                    firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }
            }
        });

        // Suppression de la classe is-invalid lors de la saisie
        requiredFields.forEach(field => {
            field.addEventListener('input', function() {
                if (this.value.trim()) {
                    this.classList.remove('is-invalid');
                }
            });
        });
    });
</script>
</body>
</html>