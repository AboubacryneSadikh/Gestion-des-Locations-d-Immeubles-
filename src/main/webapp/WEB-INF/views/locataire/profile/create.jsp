<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Créer mon profil locataire" scope="request"/>

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

        .welcome-hero {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 40px;
            margin-bottom: 30px;
            text-align: center;
        }

        .form-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            border: none;
            margin-bottom: 20px;
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
            padding: 12px 30px;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #5a67d8 0%, #6b4196 100%);
        }

        .step-indicator {
            display: flex;
            justify-content: center;
            margin-bottom: 30px;
        }

        .step {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #e9ecef;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 10px;
            color: #6c757d;
            font-weight: bold;
            position: relative;
        }

        .step.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .step:not(:last-child)::after {
            content: '';
            position: absolute;
            right: -20px;
            top: 50%;
            transform: translateY(-50%);
            width: 20px;
            height: 2px;
            background: #e9ecef;
        }

        .step.active:not(:last-child)::after {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .benefits-list {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
        }

        .benefit-item {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
            padding: 10px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }

        .benefit-item:last-child {
            margin-bottom: 0;
        }

        .benefit-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            margin-right: 15px;
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
    <!-- Messages d'alerte -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-triangle me-2"></i>
                ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Section de bienvenue -->
    <div class="welcome-hero">
        <h2 class="mb-3">Bienvenue dans votre espace locataire !</h2>
        <p class="lead mb-4">
            Pour commencer à rechercher des logements et postuler aux offres,
            vous devez d'abord compléter votre profil locataire.
        </p>
        <i class="fas fa-user-plus fa-4x opacity-50"></i>
    </div>

    <!-- Indicateur d'étapes -->
    <div class="step-indicator">
        <div class="step active">1</div>
        <div class="step">2</div>
        <div class="step">3</div>
    </div>

    <div class="row">
        <div class="col-md-8">
            <!-- Formulaire de création -->
            <div class="form-card">
                <h4 class="mb-4">
                    <i class="fas fa-user-edit me-2 text-primary"></i>
                    Créer mon profil locataire
                </h4>

                <form method="post" action="${pageContext.request.contextPath}/locataire/profile-create" novalidate>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="profession" class="form-label">
                                    Profession <span class="required">*</span>
                                </label>
                                <input type="text" class="form-control" id="profession" name="profession"
                                       value="${profession}" placeholder="Ex: Ingénieur, Professeur..." required>
                                <div class="form-text">Indiquez votre profession actuelle</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="employeur" class="form-label">Employeur</label>
                                <input type="text" class="form-control" id="employeur" name="employeur"
                                       value="${employeur}" placeholder="Nom de votre entreprise">
                                <div class="form-text">Nom de votre employeur (optionnel)</div>
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
                                           value="${revenuMensuel}" placeholder="2500" step="0.01" min="0" required>
                                    <span class="input-group-text">€</span>
                                </div>
                                <div class="form-text">Votre revenu mensuel net en euros</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="numeroIdentification" class="form-label">Numéro d'identification</label>
                                <input type="text" class="form-control" id="numeroIdentification" name="numeroIdentification"
                                       value="${numeroIdentification}" placeholder="CNI, Passeport...">
                                <div class="form-text">Numéro de carte d'identité ou passeport (optionnel)</div>
                            </div>
                        </div>
                    </div>

                    <div class="alert alert-info mt-4">
                        <h6><i class="fas fa-info-circle me-2"></i>Information importante</h6>
                        <p class="mb-0">
                            Ces informations sont essentielles pour évaluer votre éligibilité aux offres de location.
                            Vous pourrez les modifier à tout moment depuis votre profil.
                        </p>
                    </div>

                    <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
                        <button type="submit" class="btn btn-primary btn-lg">
                            <i class="fas fa-check me-2"></i>Créer mon profil
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <div class="col-md-4">
            <!-- Avantages -->
            <div class="form-card">
                <h5 class="mb-3">
                    <i class="fas fa-star me-2 text-warning"></i>
                    Avantages de votre profil locataire
                </h5>

                <div class="benefits-list">
                    <div class="benefit-item">
                        <div class="benefit-icon">
                            <i class="fas fa-search"></i>
                        </div>
                        <div>
                            <strong>Recherche personnalisée</strong>
                            <div class="text-muted small">
                                Trouvez des logements adaptés à votre budget
                            </div>
                        </div>
                    </div>

                    <div class="benefit-item">
                        <div class="benefit-icon">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <div>
                            <strong>Éligibilité automatique</strong>
                            <div class="text-muted small">
                                Vérification instantanée de votre éligibilité
                            </div>
                        </div>
                    </div>

                    <div class="benefit-item">
                        <div class="benefit-icon">
                            <i class="fas fa-paper-plane"></i>
                        </div>
                        <div>
                            <strong>Candidature simplifiée</strong>
                            <div class="text-muted small">
                                Postulez en un clic aux offres qui vous intéressent
                            </div>
                        </div>
                    </div>

                    <div class="benefit-item">
                        <div class="benefit-icon">
                            <i class="fas fa-file-contract"></i>
                        </div>
                        <div>
                            <strong>Suivi des contrats</strong>
                            <div class="text-muted small">
                                Gérez vos locations et paiements en ligne
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Sécurité -->
            <div class="form-card">
                <h5 class="mb-3">
                    <i class="fas fa-shield-alt me-2 text-success"></i>
                    Sécurité et confidentialité
                </h5>

                <div class="alert alert-success">
                    <small>
                        <i class="fas fa-lock me-2"></i>
                        Vos données personnelles sont chiffrées et sécurisées.
                        Elles ne sont partagées qu'avec les propriétaires lors de vos candidatures.
                    </small>
                </div>

                <div class="alert alert-info">
                    <small>
                        <i class="fas fa-user-shield me-2"></i>
                        Vous gardez le contrôle total sur vos informations et
                        pouvez les modifier à tout moment.
                    </small>
                </div>
            </div>

            <!-- Aide -->
            <div class="form-card">
                <h5 class="mb-3">
                    <i class="fas fa-question-circle me-2 text-info"></i>
                    Besoin d'aide ?
                </h5>

                <p class="small text-muted mb-3">
                    Si vous avez des questions sur la création de votre profil,
                    n'hésitez pas à nous contacter.
                </p>

                <div class="d-grid">
                    <button class="btn btn-outline-info btn-sm" onclick="showHelpModal()">
                        <i class="fas fa-life-ring me-2"></i>Centre d'aide
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal d'aide -->
<div class="modal fade" id="helpModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-question-circle me-2"></i>
                    Aide pour créer votre profil
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="accordion" id="helpAccordion">
                    <div class="accordion-item">
                        <h2 class="accordion-header">
                            <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#help1">
                                Quelle profession dois-je indiquer ?
                            </button>
                        </h2>
                        <div id="help1" class="accordion-collapse collapse show" data-bs-parent="#helpAccordion">
                            <div class="accordion-body">
                                Indiquez votre profession actuelle telle qu'elle apparaît sur vos fiches de paie.
                                Si vous êtes étudiant, indiquez "Étudiant". Si vous êtes en recherche d'emploi,
                                vous pouvez indiquer votre dernière profession suivie de "(en recherche)".
                            </div>
                        </div>
                    </div>

                    <div class="accordion-item">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#help2">
                                Comment calculer mon revenu mensuel net ?
                            </button>
                        </h2>
                        <div id="help2" class="accordion-collapse collapse" data-bs-parent="#helpAccordion">
                            <div class="accordion-body">
                                Votre revenu mensuel net correspond au montant que vous percevez réellement
                                chaque mois après déduction des cotisations sociales et des impôts.
                                C'est le montant qui apparaît sur votre compte bancaire.
                            </div>
                        </div>
                    </div>

                    <div class="accordion-item">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#help3">
                                Mes données sont-elles sécurisées ?
                            </button>
                        </h2>
                        <div id="help3" class="accordion-collapse collapse" data-bs-parent="#helpAccordion">
                            <div class="accordion-body">
                                Oui, toutes vos données sont chiffrées et stockées de manière sécurisée.
                                Elles ne sont partagées qu'avec les propriétaires lorsque vous postulez
                                à leurs offres de location. Vous gardez le contrôle total sur vos informations.
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function showHelpModal() {
        const modal = new bootstrap.Modal(document.getElementById('helpModal'));
        modal.show();
    }

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
            if (revenuField.value && parseFloat(revenuField.value) <= 0) {
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