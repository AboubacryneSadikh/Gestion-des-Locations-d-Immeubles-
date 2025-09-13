<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Effectuer un paiement - Locataire" scope="request"/>

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

        .payment-hero {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            border-radius: 15px;
            padding: 40px;
            margin-bottom: 30px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .payment-hero::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -20%;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
        }

        .payment-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            border: none;
            margin-bottom: 20px;
        }

        .payment-method {
            border: 2px solid #e9ecef;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 15px;
            cursor: pointer;
            transition: all 0.3s;
            position: relative;
        }

        .payment-method:hover {
            border-color: #667eea;
            background: #f8f9ff;
        }

        .payment-method.selected {
            border-color: #667eea;
            background: #667eea;
            color: white;
        }

        .payment-method input[type="radio"] {
            position: absolute;
            opacity: 0;
            cursor: pointer;
        }

        .payment-method-icon {
            font-size: 2rem;
            margin-bottom: 10px;
            color: #667eea;
        }

        .payment-method.selected .payment-method-icon {
            color: white;
        }

        .payment-method.selected .text-muted {
            color: rgba(255, 255, 255, 0.8) !important;
        }

        .security-info {
            background: #e8f5e8;
            border: 1px solid #c3e6cb;
            border-radius: 10px;
            padding: 15px;
            margin-top: 20px;
        }

        .user-info {
            color: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 20px;
        }

        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }

        .btn-pay {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
            padding: 15px 40px;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 25px;
            transition: all 0.3s;
        }

        .btn-pay:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(40, 167, 69, 0.3);
        }

        .spinner-border {
            display: none;
        }

        .payment-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .detail-item {
            text-align: center;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 10px;
        }

        .detail-label {
            font-size: 0.9rem;
            color: #6c757d;
            margin-bottom: 5px;
        }

        .detail-value {
            font-weight: 600;
            font-size: 1.1rem;
            color: #495057;
        }

        .payment-details-section {
            margin-top: 20px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
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
    <!-- Top Bar -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div class="d-flex align-items-center">
            <a href="${pageContext.request.contextPath}/locataire/paiements"
               class="btn btn-outline-secondary me-3">
                <i class="fas fa-arrow-left me-1"></i>Retour aux paiements
            </a>
            <h2 class="mb-0">Effectuer un paiement</h2>
        </div>
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

    <!-- En-tête de paiement -->
    <div class="payment-hero">
        <div class="row align-items-center">
            <div class="col-md-8">
                <h3 class="mb-2">Paiement du loyer</h3>
                <p class="mb-2">
                    <strong>${unite.immeuble.nom} - Unité ${unite.numero}</strong>
                </p>
                <p class="mb-2">
                    <i class="fas fa-map-marker-alt me-2"></i>
                    ${unite.immeuble.adresse}, ${unite.immeuble.ville}
                </p>
                <p class="mb-0">
                    Période: <fmt:formatDate value="${paiement.dateEcheance}" pattern="MM/yyyy"/>
                </p>
            </div>
            <div class="col-md-4 text-end">
                <i class="fas fa-credit-card fa-5x opacity-50"></i>
            </div>
        </div>
    </div>

    <div class="row">
        <!-- Formulaire de paiement -->
        <div class="col-md-8">
            <!-- Résumé du paiement -->
            <div class="payment-card">
                <h5 class="mb-3">
                    <i class="fas fa-file-invoice-dollar me-2 text-primary"></i>
                    Résumé du paiement
                </h5>

                <div class="payment-details">
                    <div class="detail-item">
                        <div class="detail-label">Date d'échéance</div>
                        <div class="detail-value">
                            <fmt:formatDate value="${paiement.dateEcheance}" pattern="dd/MM/yyyy"/>
                        </div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-label">Montant à payer</div>
                        <div class="detail-value text-success">
                            <fmt:formatNumber value="${paiement.montant}" pattern="#,##0" /> F CFA
                        </div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-label">Type de paiement</div>
                        <div class="detail-value">${paiement.typePaiement}</div>
                    </div>

                    <c:if test="${not empty paiement.description}">
                        <div class="detail-item">
                            <div class="detail-label">Description</div>
                            <div class="detail-value">${paiement.description}</div>
                        </div>
                    </c:if>
                </div>

                <c:if test="${paiement.statut == 'EN_RETARD'}">
                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <strong>Attention :</strong> Ce paiement est en retard.
                        Des frais de retard peuvent s'appliquer.
                    </div>
                </c:if>
            </div>

            <!-- Formulaire de paiement -->
            <div class="payment-card">
                <h5 class="mb-4">
                    <i class="fas fa-credit-card me-2 text-primary"></i>
                    Choisissez votre mode de paiement
                </h5>

                <form id="paymentForm" method="post" action="${pageContext.request.contextPath}/locataire/paiement">
                    <input type="hidden" name="id" value="${paiement.id}">

                    <!-- Modes de paiement CORRIGÉS -->
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <label class="payment-method" for="carte">
                                <input type="radio" name="modePaiement" value="CARTE_BANCAIRE" id="carte">
                                <div class="text-center">
                                    <div class="payment-method-icon">
                                        <i class="fas fa-credit-card"></i>
                                    </div>
                                    <h6>Carte bancaire</h6>
                                    <small class="text-muted">Visa, Mastercard, American Express</small>
                                </div>
                            </label>
                        </div>

                        <div class="col-md-6">
                            <label class="payment-method" for="virement">
                                <input type="radio" name="modePaiement" value="VIREMENT_BANCAIRE" id="virement">
                                <div class="text-center">
                                    <div class="payment-method-icon">
                                        <i class="fas fa-university"></i>
                                    </div>
                                    <h6>Virement bancaire</h6>
                                    <small class="text-muted">Sécurisé et instantané</small>
                                </div>
                            </label>
                        </div>
                    </div>

                    <div class="row mb-4">
                        <div class="col-md-6">
                            <label class="payment-method" for="cheque">
                                <input type="radio" name="modePaiement" value="CHEQUE" id="cheque">
                                <div class="text-center">
                                    <div class="payment-method-icon">
                                        <i class="fas fa-money-check"></i>
                                    </div>
                                    <h6>Chèque</h6>
                                    <small class="text-muted">Paiement traditionnel</small>
                                </div>
                            </label>
                        </div>

                        <div class="col-md-6">
                            <label class="payment-method" for="especes">
                                <input type="radio" name="modePaiement" value="ESPECES" id="especes">
                                <div class="text-center">
                                    <div class="payment-method-icon">
                                        <i class="fas fa-money-bill-wave"></i>
                                    </div>
                                    <h6>Espèces</h6>
                                    <small class="text-muted">Paiement en liquide</small>
                                </div>
                            </label>
                        </div>
                    </div>

                    <!-- Détails spécifiques selon le mode de paiement -->
                    <div id="paymentDetails" style="display: none;">
                        <!-- Détails carte bancaire -->
                        <div id="carteBancaireDetails" class="payment-details-section" style="display: none;">
                            <h6 class="mb-3">
                                <i class="fas fa-credit-card me-2"></i>
                                Informations de la carte
                            </h6>
                            <div class="row">
                                <div class="col-md-12 mb-3">
                                    <label class="form-label">Numéro de carte</label>
                                    <input type="text" name="numeroCarte" class="form-control" placeholder="1234 5678 9012 3456" maxlength="19">
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">MM/AA</label>
                                    <input type="text" name="dateExpiration" class="form-control" placeholder="12/25" maxlength="5">
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">CVV</label>
                                    <input type="text" name="cvv" class="form-control" placeholder="123" maxlength="4">
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">Code postal</label>
                                    <input type="text" name="codePostal" class="form-control" placeholder="12345" maxlength="5">
                                </div>
                            </div>
                        </div>

                        <!-- Détails virement -->
                        <div id="virementBancaireDetails" class="payment-details-section" style="display: none;">
                            <div class="alert alert-info">
                                <h6><i class="fas fa-info-circle me-2"></i>Informations de virement</h6>
                                <p class="mb-2"><strong>IBAN :</strong> SN08 A001 0001 0010001234567</p>
                                <p class="mb-2"><strong>BIC :</strong> CBAOSNDA</p>
                                <p class="mb-0"><strong>Référence :</strong> ${paiement.numeroReference}</p>
                            </div>
                            <div class="alert alert-warning">
                                <small>
                                    <i class="fas fa-exclamation-triangle me-1"></i>
                                    Veuillez mentionner la référence lors de votre virement pour un traitement rapide.
                                </small>
                            </div>
                        </div>

                        <!-- Détails chèque -->
                        <div id="chequeDetails" class="payment-details-section" style="display: none;">
                            <div class="alert alert-warning">
                                <h6><i class="fas fa-info-circle me-2"></i>Paiement par chèque</h6>
                                <p class="mb-2">Veuillez libeller votre chèque à l'ordre de :</p>
                                <p class="mb-2"><strong>${contrat.unite.immeuble.proprietaire.prenom} ${contrat.unite.immeuble.proprietaire.nom}</strong></p>
                                <p class="mb-0">Montant : <strong><fmt:formatNumber value="${paiement.montant}" pattern="#,##0" /> F CFA</strong></p>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Numéro du chèque</label>
                                <input type="text" name="numeroCheque" class="form-control" placeholder="Entrez le numéro du chèque">
                            </div>
                        </div>

                        <!-- Détails espèces -->
                        <div id="especesDetails" class="payment-details-section" style="display: none;">
                            <div class="alert alert-warning">
                                <h6><i class="fas fa-exclamation-triangle me-2"></i>Paiement en espèces</h6>
                                <p class="mb-2">Le paiement en espèces doit être remis directement au propriétaire.</p>
                                <p class="mb-0">Assurez-vous d'obtenir un reçu signé.</p>
                            </div>
                            <div class="alert alert-info">
                                <small>
                                    <i class="fas fa-info-circle me-1"></i>
                                    Pour les montants importants, préférez un autre mode de paiement plus sécurisé.
                                </small>
                            </div>
                        </div>
                    </div>

                    <!-- Référence de transaction -->
                    <div class="mb-3" id="referenceSection" style="display: none;">
                        <label class="form-label">Référence de transaction (optionnel)</label>
                        <input type="text" name="referenceTransaction" class="form-control"
                               placeholder="Numéro de transaction ou de référence">
                        <small class="form-text text-muted">
                            Vous pouvez ajouter une référence pour faciliter le suivi de votre paiement.
                        </small>
                    </div>

                    <!-- Commentaires -->
                    <div class="mb-4">
                        <label class="form-label">Commentaires (optionnel)</label>
                        <textarea name="commentaires" class="form-control" rows="3"
                                  placeholder="Ajoutez un commentaire si nécessaire..."></textarea>
                    </div>

                    <!-- Conditions -->
                    <div class="mb-4">
                        <div class="form-check">
                            <input type="checkbox" class="form-check-input" id="acceptConditions" required>
                            <label class="form-check-label" for="acceptConditions">
                                J'accepte les <a href="#" data-bs-toggle="modal" data-bs-target="#conditionsModal">conditions de paiement</a>
                            </label>
                        </div>
                    </div>

                    <!-- Bouton de soumission -->
                    <div class="text-center">
                        <button type="submit" class="btn btn-success btn-pay" id="submitBtn">
                            <span class="btn-text">
                                <i class="fas fa-lock me-2"></i>
                                Payer <fmt:formatNumber value="${paiement.montant}" pattern="#,##0" /> F CFA
                            </span>
                            <span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
                            <span class="loading-text" style="display: none;">Traitement en cours...</span>
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Informations complémentaires (reste inchangé) -->
        <div class="col-md-4">
            <!-- Sécurité -->
            <div class="payment-card">
                <h5 class="mb-3">
                    <i class="fas fa-shield-alt me-2 text-success"></i>
                    Paiement sécurisé
                </h5>

                <div class="security-info">
                    <div class="d-flex align-items-center mb-3">
                        <i class="fas fa-lock text-success me-3"></i>
                        <div>
                            <strong>Chiffrement SSL</strong>
                            <small class="d-block text-muted">Vos données sont protégées</small>
                        </div>
                    </div>

                    <div class="d-flex align-items-center mb-3">
                        <i class="fas fa-user-shield text-success me-3"></i>
                        <div>
                            <strong>Données protégées</strong>
                            <small class="d-block text-muted">Aucune information stockée</small>
                        </div>
                    </div>

                    <div class="d-flex align-items-center">
                        <i class="fas fa-check-circle text-success me-3"></i>
                        <div>
                            <strong>Transaction sécurisée</strong>
                            <small class="d-block text-muted">Protocole bancaire standard</small>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Informations contrat -->
            <div class="payment-card">
                <h5 class="mb-3">
                    <i class="fas fa-file-contract me-2 text-primary"></i>
                    Informations du contrat
                </h5>

                <div class="mb-3">
                    <small class="text-muted">Période de location</small>
                    <div class="fw-bold">
                        <fmt:formatDate value="${contrat.dateDebut}" pattern="dd/MM/yyyy"/> -
                        <fmt:formatDate value="${contrat.dateFin}" pattern="dd/MM/yyyy"/>
                    </div>
                </div>

                <div class="mb-3">
                    <small class="text-muted">Loyer mensuel</small>
                    <div class="fw-bold text-success">
                        <fmt:formatNumber value="${contrat.loyer}" pattern="#,##0" /> F CFA
                    </div>
                </div>

                <c:if test="${not empty contrat.depotGarantie}">
                    <div class="mb-3">
                        <small class="text-muted">Dépôt de garantie</small>
                        <div class="fw-bold">
                            <fmt:formatNumber value="${contrat.depotGarantie}" pattern="#,##0" /> F CFA
                        </div>
                    </div>
                </c:if>

                <div class="mb-3">
                    <small class="text-muted">Statut du contrat</small>
                    <div class="fw-bold">
                        <span class="badge ${contrat.statut == 'EN_COURS' ? 'bg-success' : 'bg-secondary'}">
                            <c:choose>
                                <c:when test="${contrat.statut == 'EN_COURS'}">En cours</c:when>
                                <c:when test="${contrat.statut == 'TERMINE'}">Terminé</c:when>
                                <c:otherwise>${contrat.statut}</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>
            </div>

            <!-- Contact propriétaire -->
            <div class="payment-card">
                <h5 class="mb-3">
                    <i class="fas fa-user-tie me-2 text-primary"></i>
                    Contact propriétaire
                </h5>

                <div class="mb-2">
                    <strong>
                        ${contrat.unite.immeuble.proprietaire.prenom}
                        ${contrat.unite.immeuble.proprietaire.nom}
                    </strong>
                </div>

                <div class="mb-2">
                    <i class="fas fa-envelope me-2"></i>
                    <a href="mailto:${contrat.unite.immeuble.proprietaire.email}">
                        ${contrat.unite.immeuble.proprietaire.email}
                    </a>
                </div>

                <c:if test="${not empty contrat.unite.immeuble.proprietaire.telephone}">
                    <div class="mb-3">
                        <i class="fas fa-phone me-2"></i>
                        <a href="tel:${contrat.unite.immeuble.proprietaire.telephone}">
                                ${contrat.unite.immeuble.proprietaire.telephone}
                        </a>
                    </div>
                </c:if>

                <div class="alert alert-info">
                    <small>
                        <i class="fas fa-info-circle me-1"></i>
                        En cas de problème avec le paiement, contactez directement votre propriétaire.
                    </small>
                </div>
            </div>

            <!-- Historique des paiements -->
            <div class="payment-card">
                <h5 class="mb-3">
                    <i class="fas fa-history me-2 text-primary"></i>
                    Historique récent
                </h5>

                <a href="${pageContext.request.contextPath}/locataire/paiements"
                   class="btn btn-outline-primary w-100">
                    <i class="fas fa-list me-2"></i>
                    Voir tous mes paiements
                </a>
            </div>
        </div>
    </div>
</div>

<!-- Modal des conditions -->
<div class="modal fade" id="conditionsModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-file-contract me-2"></i>
                    Conditions de paiement
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <h6>1. Modalités de paiement</h6>
                <p>Le paiement du loyer doit être effectué mensuellement à la date d'échéance indiquée dans le contrat de location.</p>

                <h6>2. Modes de paiement acceptés</h6>
                <ul>
                    <li>Carte bancaire (Visa, Mastercard, American Express)</li>
                    <li>Virement bancaire</li>
                    <li>Chèque bancaire</li>
                    <li>Espèces (avec reçu obligatoire)</li>
                </ul>

                <h6>3. Sécurité</h6>
                <p>Toutes les transactions sont sécurisées et chiffrées. Vos informations bancaires ne sont pas stockées sur nos serveurs.</p>

                <h6>4. Retards de paiement</h6>
                <p>En cas de retard de paiement, des frais supplémentaires peuvent être appliqués conformément au contrat de location.</p>

                <h6>5. Reçu de paiement</h6>
                <p>Un reçu électronique vous sera envoyé par email après confirmation du paiement.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-bs-dismiss="modal">
                    J'ai compris
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // JavaScript CORRIGÉ pour gérer les modes de paiement
    document.addEventListener('DOMContentLoaded', function() {

        // Gestion des clics sur les modes de paiement
        const paymentMethods = document.querySelectorAll('.payment-method');

        paymentMethods.forEach(method => {
            method.addEventListener('click', function() {
                // Désélectionner toutes les méthodes
                paymentMethods.forEach(m => m.classList.remove('selected'));

                // Sélectionner la méthode cliquée
                this.classList.add('selected');

                // Cocher le radio button correspondant
                const radioButton = this.querySelector('input[type="radio"]');
                if (radioButton) {
                    radioButton.checked = true;

                    // Déclencher l'affichage des détails
                    showPaymentDetails(radioButton.value);

                    // Afficher la section de référence pour certains modes
                    const referenceSection = document.getElementById('referenceSection');
                    if (radioButton.value === 'VIREMENT_BANCAIRE' || radioButton.value === 'CARTE_BANCAIRE') {
                        referenceSection.style.display = 'block';
                    } else {
                        referenceSection.style.display = 'none';
                    }
                }
            });
        });

        // Gestion directe des changements de radio buttons (au cas où)
        const radioButtons = document.querySelectorAll('input[name="modePaiement"]');
        radioButtons.forEach(radio => {
            radio.addEventListener('change', function() {
                if (this.checked) {
                    // Mettre à jour l'affichage visuel
                    paymentMethods.forEach(m => m.classList.remove('selected'));
                    const parentMethod = this.closest('.payment-method');
                    if (parentMethod) {
                        parentMethod.classList.add('selected');
                    }

                    // Afficher les détails
                    showPaymentDetails(this.value);

                    // Gestion de la référence
                    const referenceSection = document.getElementById('referenceSection');
                    if (this.value === 'VIREMENT_BANCAIRE' || this.value === 'CARTE_BANCAIRE') {
                        referenceSection.style.display = 'block';
                    } else {
                        referenceSection.style.display = 'none';
                    }
                }
            });
        });

        // Validation et soumission du formulaire
        const paymentForm = document.getElementById('paymentForm');

        paymentForm.addEventListener('submit', function(e) {
            // Vérifier qu'un mode de paiement est sélectionné
            const selectedMethod = document.querySelector('input[name="modePaiement"]:checked');
            if (!selectedMethod) {
                e.preventDefault();
                alert('Veuillez sélectionner un mode de paiement.');
                return false;
            }

            console.log('Mode de paiement sélectionné:', selectedMethod.value);

            // Vérifier que les conditions sont acceptées
            const acceptConditions = document.getElementById('acceptConditions');
            if (!acceptConditions.checked) {
                e.preventDefault();
                alert('Veuillez accepter les conditions de paiement.');
                return false;
            }

            // Validation spécifique selon le mode de paiement
            if (selectedMethod.value === 'CARTE_BANCAIRE') {
                const numeroCarte = document.querySelector('input[name="numeroCarte"]');
                const dateExpiration = document.querySelector('input[name="dateExpiration"]');
                const cvv = document.querySelector('input[name="cvv"]');

                if (!numeroCarte.value.trim() || !dateExpiration.value.trim() || !cvv.value.trim()) {
                    e.preventDefault();
                    alert('Veuillez remplir tous les champs de la carte bancaire.');
                    return false;
                }
            }

            if (selectedMethod.value === 'CHEQUE') {
                const numeroCheque = document.querySelector('input[name="numeroCheque"]');
                if (!numeroCheque.value.trim()) {
                    e.preventDefault();
                    alert('Veuillez entrer le numéro du chèque.');
                    return false;
                }
            }

            // Afficher le loading
            const submitBtn = document.getElementById('submitBtn');
            const btnText = submitBtn.querySelector('.btn-text');
            const spinner = submitBtn.querySelector('.spinner-border');
            const loadingText = submitBtn.querySelector('.loading-text');

            if (btnText && spinner && loadingText) {
                btnText.style.display = 'none';
                spinner.style.display = 'inline-block';
                loadingText.style.display = 'inline';
                submitBtn.disabled = true;
            }
        });

        // Formatage automatique du numéro de carte
        const cardInput = document.querySelector('input[name="numeroCarte"]');
        if (cardInput) {
            cardInput.addEventListener('input', function(e) {
                let value = e.target.value.replace(/\s/g, '').replace(/[^0-9]/gi, '');
                let formattedValue = value.match(/.{1,4}/g)?.join(' ') || value;
                if (formattedValue.length > 19) formattedValue = formattedValue.substring(0, 19);
                e.target.value = formattedValue;
            });
        }

        // Formatage de la date d'expiration
        const expInput = document.querySelector('input[name="dateExpiration"]');
        if (expInput) {
            expInput.addEventListener('input', function(e) {
                let value = e.target.value.replace(/\D/g, '');
                if (value.length >= 2) {
                    value = value.substring(0, 2) + '/' + value.substring(2, 4);
                }
                e.target.value = value;
            });
        }

        // Validation CVV (uniquement des chiffres)
        const cvvInput = document.querySelector('input[name="cvv"]');
        if (cvvInput) {
            cvvInput.addEventListener('input', function(e) {
                e.target.value = e.target.value.replace(/[^0-9]/g, '');
            });
        }

        // Validation code postal (uniquement des chiffres)
        const codePostalInput = document.querySelector('input[name="codePostal"]');
        if (codePostalInput) {
            codePostalInput.addEventListener('input', function(e) {
                e.target.value = e.target.value.replace(/[^0-9]/g, '');
            });
        }

        // Validation numéro de chèque (alphanumérique)
        const numeroChequeInput = document.querySelector('input[name="numeroCheque"]');
        if (numeroChequeInput) {
            numeroChequeInput.addEventListener('input', function(e) {
                e.target.value = e.target.value.replace(/[^a-zA-Z0-9]/g, '');
            });
        }
    });

    // Fonction pour afficher les détails du mode de paiement
    function showPaymentDetails(method) {
        console.log('Affichage des détails pour:', method);

        // Masquer tous les détails spécifiques
        document.querySelectorAll('.payment-details-section').forEach(el => {
            el.style.display = 'none';
        });

        // Afficher la section générale des détails
        const paymentDetailsContainer = document.getElementById('paymentDetails');
        paymentDetailsContainer.style.display = 'block';

        // Mapping des méthodes vers les IDs corrects
        const methodToIdMap = {
            'CARTE_BANCAIRE': 'carteBancaireDetails',
            'VIREMENT_BANCAIRE': 'virementBancaireDetails',
            'CHEQUE': 'chequeDetails',
            'ESPECES': 'especesDetails'
        };

        // Afficher les détails spécifiques à la méthode sélectionnée
        const sectionId = methodToIdMap[method];
        const section = document.getElementById(sectionId);
        if (section) {
            section.style.display = 'block';
            console.log('Section affichée:', sectionId);
        }
    }
</script>
</body>
</html>