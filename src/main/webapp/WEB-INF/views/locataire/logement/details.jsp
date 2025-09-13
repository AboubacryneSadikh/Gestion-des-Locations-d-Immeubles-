<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Détails du logement - Location" scope="request"/>

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

    .property-hero {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      border-radius: 15px;
      padding: 40px;
      margin-bottom: 30px;
      position: relative;
      overflow: hidden;
    }

    .property-hero::before {
      content: '';
      position: absolute;
      top: -50%;
      right: -20%;
      width: 300px;
      height: 300px;
      background: rgba(255, 255, 255, 0.1);
      border-radius: 50%;
    }

    .detail-card {
      background: white;
      border-radius: 15px;
      padding: 25px;
      box-shadow: 0 5px 15px rgba(0,0,0,0.08);
      border: none;
      margin-bottom: 20px;
      transition: transform 0.2s ease;
    }

    .detail-card:hover {
      transform: translateY(-2px);
    }

    .info-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
      gap: 20px;
      margin-bottom: 20px;
    }

    .info-item {
      display: flex;
      align-items: center;
      padding: 15px;
      background: #f8f9fa;
      border-radius: 10px;
      transition: all 0.3s ease;
    }

    .info-item:hover {
      background: #e9ecef;
      transform: translateX(5px);
    }

    .info-icon {
      width: 45px;
      height: 45px;
      border-radius: 50%;
      background: white;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-right: 15px;
      color: #667eea;
      box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    }

    .info-content .label {
      font-size: 0.9rem;
      color: #6c757d;
      margin-bottom: 3px;
    }

    .info-content .value {
      font-weight: 600;
      color: #495057;
      font-size: 1.1rem;
    }

    .status-badge {
      padding: 8px 16px;
      border-radius: 25px;
      font-size: 0.9rem;
      font-weight: 600;
      text-transform: uppercase;
    }

    .status-disponible {
      background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
      color: white;
      animation: pulse 2s infinite;
    }

    @keyframes pulse {
      0% { transform: scale(1); }
      50% { transform: scale(1.05); }
      100% { transform: scale(1); }
    }

    .status-loue {
      background: #f8d7da;
      color: #721c24;
    }

    .status-en-maintenance {
      background: #fff3cd;
      color: #856404;
    }

    .user-info {
      color: rgba(255, 255, 255, 0.9);
      padding: 20px;
      border-bottom: 1px solid rgba(255, 255, 255, 0.1);
      margin-bottom: 20px;
    }

    .price-section {
      background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
      color: white;
      padding: 30px;
      border-radius: 15px;
      text-align: center;
      position: relative;
      overflow: hidden;
    }

    .price-section::before {
      content: '';
      position: absolute;
      top: -50%;
      right: -50%;
      width: 200px;
      height: 200px;
      background: rgba(255, 255, 255, 0.1);
      border-radius: 50%;
      animation: float 6s ease-in-out infinite;
    }

    @keyframes float {
      0%, 100% { transform: translate(0, 0) rotate(0deg); }
      50% { transform: translate(-20px, -20px) rotate(180deg); }
    }

    .price-main {
      font-size: 3rem;
      font-weight: bold;
      margin-bottom: 5px;
      position: relative;
      z-index: 1;
    }

    .price-label {
      font-size: 1.2rem;
      opacity: 0.9;
      position: relative;
      z-index: 1;
    }

    .equipment-tag {
      background: linear-gradient(135deg, #e9ecef 0%, #dee2e6 100%);
      color: #495057;
      padding: 8px 15px;
      border-radius: 25px;
      font-size: 0.9rem;
      margin: 5px;
      display: inline-block;
      transition: all 0.3s ease;
      border: 1px solid #dee2e6;
    }

    .equipment-tag:hover {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      transform: scale(1.05);
    }

    .image-gallery {
      border-radius: 15px;
      overflow: hidden;
      margin-bottom: 20px;
    }

    .gallery-main {
      height: 400px;
      background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.5rem;
      color: #6c757d;
      position: relative;
    }

    .gallery-main::before {
      content: '';
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      width: 100px;
      height: 100px;
      background: rgba(102, 126, 234, 0.1);
      border-radius: 50%;
      animation: ripple 3s infinite;
    }

    @keyframes ripple {
      0% { transform: translate(-50%, -50%) scale(0); opacity: 1; }
      100% { transform: translate(-50%, -50%) scale(4); opacity: 0; }
    }

    .eligibility-card {
      border-radius: 15px;
      padding: 25px;
      text-align: center;
      position: relative;
      overflow: hidden;
    }

    .eligibility-card::before {
      content: '';
      position: absolute;
      top: 0;
      left: -100%;
      width: 100%;
      height: 100%;
      background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
      transition: left 0.5s;
    }

    .eligibility-card:hover::before {
      left: 100%;
    }

    .eligibility-eligible {
      background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
      color: #155724;
      border: 2px solid #b8dacc;
    }

    .eligibility-not-eligible {
      background: linear-gradient(135deg, #f8d7da 0%, #f1c2c7 100%);
      color: #721c24;
      border: 2px solid #e4a2aa;
    }

    .eligibility-no-profile {
      background: linear-gradient(135deg, #fff3cd 0%, #fdeaa7 100%);
      color: #856404;
      border: 2px solid #f0d43a;
    }

    .rental-form {
      background: white;
      border-radius: 15px;
      padding: 30px;
      box-shadow: 0 10px 30px rgba(0,0,0,0.1);
      margin-top: 20px;
    }

    .form-floating > .form-control:focus ~ label {
      color: #667eea;
    }

    .form-floating > .form-control:focus {
      border-color: #667eea;
      box-shadow: 0 0 0 0.25rem rgba(102, 126, 234, 0.25);
    }

    .btn-rent {
      background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
      border: none;
      border-radius: 10px;
      padding: 15px 30px;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 1px;
      transition: all 0.3s ease;
      position: relative;
      overflow: hidden;
    }

    .btn-rent::before {
      content: '';
      position: absolute;
      top: 50%;
      left: 50%;
      width: 0;
      height: 0;
      background: rgba(255, 255, 255, 0.3);
      border-radius: 50%;
      transition: all 0.3s ease;
      transform: translate(-50%, -50%);
    }

    .btn-rent:hover::before {
      width: 300px;
      height: 300px;
    }

    .btn-rent:hover {
      transform: translateY(-2px);
      box-shadow: 0 10px 25px rgba(40, 167, 69, 0.3);
    }

    .contact-owner-card {
      background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
      border-radius: 15px;
      padding: 20px;
      margin-top: 20px;
      border: 1px solid #dee2e6;
    }

    .owner-avatar {
      width: 60px;
      height: 60px;
      border-radius: 50%;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-size: 1.5rem;
      margin-bottom: 15px;
    }

    .quick-stats {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      border-radius: 15px;
      padding: 20px;
      margin-bottom: 20px;
    }

    .stat-item {
      text-align: center;
      padding: 10px;
    }

    .stat-number {
      font-size: 1.8rem;
      font-weight: bold;
      display: block;
    }

    .stat-label {
      font-size: 0.9rem;
      opacity: 0.9;
    }

    .action-buttons .btn {
      border-radius: 10px;
      margin-bottom: 10px;
      transition: all 0.3s ease;
    }

    .action-buttons .btn:hover {
      transform: translateY(-2px);
    }

    .modal-content {
      border-radius: 15px;
      border: none;
    }

    .modal-header {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      border-radius: 15px 15px 0 0;
    }

    .loading-spinner {
      display: none;
      width: 20px;
      height: 20px;
      border: 2px solid #f3f3f3;
      border-top: 2px solid #667eea;
      border-radius: 50%;
      animation: spin 1s linear infinite;
    }

    @keyframes spin {
      0% { transform: rotate(0deg); }
      100% { transform: rotate(360deg); }
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
      <a class="nav-link active" href="${pageContext.request.contextPath}/locataire/recherche">
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
      <a href="${pageContext.request.contextPath}/locataire/recherche"
         class="btn btn-outline-secondary me-3">
        <i class="fas fa-arrow-left me-1"></i>Retour à la recherche
      </a>
      <div>
        <h2 class="mb-0">Détails du logement</h2>
        <small class="text-muted">Réf: UL-${unite.id}</small>
      </div>
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

  <div class="row">
    <!-- Contenu principal -->
    <div class="col-lg-8">
      <!-- En-tête du logement -->
      <div class="property-hero">
        <div class="row align-items-center">
          <div class="col-md-8">
            <h3 class="mb-2">${unite.immeuble.nom}</h3>
            <h4 class="mb-3">Unité ${unite.numero}</h4>
            <p class="mb-3">
              <i class="fas fa-map-marker-alt me-2"></i>
              ${unite.immeuble.adresse}, ${unite.immeuble.ville}
              <c:if test="${not empty unite.immeuble.codePostal}">
                ${unite.immeuble.codePostal}
              </c:if>
            </p>
            <span class="status-badge status-${unite.statut.toString().toLowerCase().replace('_', '-')}">
                            <i class="fas fa-circle me-1"></i>
                            <c:choose>
                              <c:when test="${unite.statut == 'DISPONIBLE'}">Disponible</c:when>
                              <c:when test="${unite.statut == 'LOUE'}">Occupé</c:when>
                              <c:when test="${unite.statut == 'EN_MAINTENANCE'}">En maintenance</c:when>
                              <c:when test="${unite.statut == 'RESERVE'}">Réservé</c:when>
                              <c:otherwise>${unite.statut}</c:otherwise>
                            </c:choose>
                        </span>
          </div>
          <div class="col-md-4 text-end">
            <i class="fas fa-home fa-5x opacity-50"></i>
          </div>
        </div>
      </div>

      <!-- Statistiques rapides -->
      <div class="quick-stats">
        <div class="row">
          <div class="col-3">
            <div class="stat-item">
              <span class="stat-number">${unite.nombrePieces}</span>
              <span class="stat-label">Pièces</span>
            </div>
          </div>
          <div class="col-3">
            <div class="stat-item">
              <span class="stat-number">${unite.superficie}</span>
              <span class="stat-label">m²</span>
            </div>
          </div>
          <div class="col-3">
            <div class="stat-item">
                            <span class="stat-number">
                                <c:choose>
                                  <c:when test="${unite.etage == 0}">RDC</c:when>
                                  <c:otherwise>${unite.etage}e</c:otherwise>
                                </c:choose>
                            </span>
              <span class="stat-label">Étage</span>
            </div>
          </div>
          <div class="col-3">
            <div class="stat-item">
                            <span class="stat-number">
                                <fmt:formatNumber value="${unite.loyer}" type="number" maxFractionDigits="0"/>€
                            </span>
              <span class="stat-label">/ mois</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Galerie photos -->
      <div class="detail-card">
        <h5 class="mb-3">
          <i class="fas fa-camera me-2 text-primary"></i>
          Photos du logement
        </h5>
        <div class="image-gallery">
          <div class="gallery-main">
            <div class="text-center">
              <i class="fas fa-image fa-4x mb-3"></i>
              <p class="mb-0">Photos à venir</p>
              <small class="text-muted">Contactez le propriétaire pour plus de photos</small>
            </div>
          </div>
        </div>
      </div>

      <!-- Caractéristiques détaillées -->
      <div class="detail-card">
        <h5 class="mb-4">
          <i class="fas fa-info-circle me-2 text-primary"></i>
          Caractéristiques détaillées
        </h5>

        <div class="info-grid">
          <div class="info-item">
            <div class="info-icon">
              <i class="fas fa-th-large"></i>
            </div>
            <div class="info-content">
              <div class="label">Nombre de pièces</div>
              <div class="value">${unite.nombrePieces} pièce(s)</div>
            </div>
          </div>

          <div class="info-item">
            <div class="info-icon">
              <i class="fas fa-ruler-combined"></i>
            </div>
            <div class="info-content">
              <div class="label">Superficie</div>
              <div class="value">${unite.superficie} m²</div>
            </div>
          </div>

          <div class="info-item">
            <div class="info-icon">
              <i class="fas fa-building"></i>
            </div>
            <div class="info-content">
              <div class="label">Étage</div>
              <div class="value">
                <c:choose>
                  <c:when test="${unite.etage == 0}">Rez-de-chaussée</c:when>
                  <c:when test="${unite.etage == 1}">1er étage</c:when>
                  <c:otherwise>${unite.etage}ème étage</c:otherwise>
                </c:choose>
              </div>
            </div>
          </div>

          <c:if test="${not empty unite.chargesMensuelles}">
            <div class="info-item">
              <div class="info-icon">
                <i class="fas fa-receipt"></i>
              </div>
              <div class="info-content">
                <div class="label">Charges mensuelles</div>
                <div class="value">
                  <fmt:formatNumber value="${unite.chargesMensuelles}" type="currency" currencySymbol="€"/>
                </div>
              </div>
            </div>
          </c:if>

          <c:if test="${not empty unite.depotGarantie}">
            <div class="info-item">
              <div class="info-icon">
                <i class="fas fa-shield-alt"></i>
              </div>
              <div class="info-content">
                <div class="label">Dépôt de garantie</div>
                <div class="value">
                  <fmt:formatNumber value="${unite.depotGarantie}" type="currency" currencySymbol="€"/>
                </div>
              </div>
            </div>
          </c:if>

          <div class="info-item">
            <div class="info-icon">
              <i class="fas fa-calendar-plus"></i>
            </div>
            <div class="info-content">
              <div class="label">Disponible depuis</div>
              <div class="value">
                <fmt:formatDate value="${unite.dateCreation}" pattern="dd/MM/yyyy"/>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Description -->
      <c:if test="${not empty unite.description}">
        <div class="detail-card">
          <h5 class="mb-3">
            <i class="fas fa-file-alt me-2 text-primary"></i>
            Description
          </h5>
          <p class="mb-0 lh-lg">${unite.description}</p>
        </div>
      </c:if>

      <!-- Équipements -->
      <c:if test="${not empty unite.equipements}">
        <div class="detail-card">
          <h5 class="mb-3">
            <i class="fas fa-tools me-2 text-primary"></i>
            Équipements
          </h5>
          <div class="mb-0">
            <c:forTokens items="${unite.equipements}" delims="," var="equipement">
                            <span class="equipment-tag">
                                <i class="fas fa-check me-1"></i>${equipement.trim()}
                            </span>
            </c:forTokens>
          </div>
        </div>
      </c:if>

      <!-- Informations sur l'immeuble -->
      <div class="detail-card">
        <h5 class="mb-3">
          <i class="fas fa-building me-2 text-primary"></i>
          Informations sur l'immeuble
        </h5>

        <div class="row mb-3">
          <div class="col-md-6 mb-2">
            <strong>Adresse complète :</strong><br>
            ${unite.immeuble.adresse}<br>
            ${unite.immeuble.ville}
            <c:if test="${not empty unite.immeuble.codePostal}">
              ${unite.immeuble.codePostal}
            </c:if>
          </div>
        </div>

        <c:if test="${not empty unite.immeuble.description}">
          <p><strong>Description de l'immeuble :</strong></p>
          <p class="text-muted">${unite.immeuble.description}</p>
        </c:if>

        <c:if test="${not empty unite.immeuble.equipements}">
          <p><strong>Équipements de l'immeuble :</strong></p>
          <c:forTokens items="${unite.immeuble.equipements}" delims="," var="equipement">
                        <span class="equipment-tag">
                            <i class="fas fa-building me-1"></i>${equipement.trim()}
                        </span>
          </c:forTokens>
        </c:if>
      </div>
    </div>

    <!-- Sidebar droite -->
    <div class="col-lg-4">
      <!-- Prix et coûts -->
      <div class="price-section mb-4">
        <div class="price-main">
          <fmt:formatNumber value="${unite.loyer}" type="currency" currencySymbol="€"/>
        </div>
        <div class="price-label">Loyer mensuel</div>

        <div class="mt-3 pt-3 border-top border-light">
          <div class="row text-start">
            <c:if test="${not empty unite.chargesMensuelles}">
              <div class="col-6">
                <small>Charges :</small><br>
                <strong>
                  <fmt:formatNumber value="${unite.chargesMensuelles}" type="currency" currencySymbol="€"/>
                </strong>
              </div>
            </c:if>
            <c:if test="${not empty unite.depotGarantie}">
              <div class="col-6">
                <small>Dépôt de garantie :</small><br>
                <strong>
                  <fmt:formatNumber value="${unite.depotGarantie}" type="currency" currencySymbol="€"/>
                </strong>
              </div>
            </c:if>
          </div>
        </div>
      </div>

      <!-- État d'éligibilité et candidature -->
      <div class="eligibility-card mb-4
                        <c:choose>
                            <c:when test="${not hasProfile}">eligibility-no-profile</c:when>
                            <c:when test="${eligible}">eligibility-eligible</c:when>
                            <c:otherwise>eligibility-not-eligible</c:otherwise>
                        </c:choose>">
        <c:choose>
          <c:when test="${not hasProfile}">
            <i class="fas fa-exclamation-triangle fa-3x mb-3"></i>
            <h5>Profil requis</h5>
            <p class="mb-3">Vous devez compléter votre profil locataire pour vérifier votre éligibilité et postuler à ce logement.</p>
            <a href="${pageContext.request.contextPath}/locataire/profile"
               class="btn btn-warning">
              <i class="fas fa-user-plus me-2"></i>Compléter mon profil
            </a>
          </c:when>
          <c:when test="${eligible and unite.statut == 'DISPONIBLE'}">
            <i class="fas fa-check-circle fa-3x mb-3"></i>
            <h5>Vous êtes éligible !</h5>
            <p class="mb-3">Votre profil correspond aux critères pour ce logement. Vous pouvez déposer votre candidature.</p>
            <button class="btn btn-success btn-rent" onclick="showRentalForm()">
              <i class="fas fa-paper-plane me-2"></i>Déposer ma candidature
            </button>
          </c:when>
          <c:when test="${eligible and unite.statut != 'DISPONIBLE'}">
            <i class="fas fa-info-circle fa-3x mb-3"></i>
            <h5>Logement non disponible</h5>
            <p class="mb-3">Ce logement n'est actuellement pas disponible à la location.</p>
            <button class="btn btn-secondary" disabled>
              <i class="fas fa-ban me-2"></i>Non disponible
            </button>
          </c:when>
          <c:otherwise>
            <i class="fas fa-times-circle fa-3x mb-3"></i>
            <h5>Non éligible</h5>
            <p class="mb-3">Votre profil ne correspond pas aux critères requis pour ce logement.</p>
            <small class="d-block mb-3">
              <strong>Critères d'éligibilité :</strong><br>
              • Revenus : minimum ${unite.loyer * 3} €/mois<br>
              • Profil locataire complet
            </small>
            <a href="${pageContext.request.contextPath}/locataire/profile-edit"
               class="btn btn-outline-warning">
              <i class="fas fa-edit me-2"></i>Modifier mon profil
            </a>
          </c:otherwise>
        </c:choose>
      </div>

      <!-- Formulaire de candidature (masqué par défaut) -->
      <div id="rentalFormCard" class="rental-form" style="display: none;">
        <h5 class="mb-4">
          <i class="fas fa-file-signature me-2 text-success"></i>
          Candidature de location
        </h5>

        <form id="rentalApplicationForm" method="post" action="${pageContext.request.contextPath}/locataire/candidature">
          <input type="hidden" name="uniteId" value="${unite.id}">

          <div class="row mb-3">
            <div class="col-md-6">
              <div class="form-floating">
                <input type="date" class="form-control" id="dateDebutSouhaitee" name="dateDebutSouhaitee"
                       min="<fmt:formatDate value='<%=new java.util.Date()%>' pattern='yyyy-MM-dd'/>" required>
                <label for="dateDebutSouhaitee">Date d'entrée souhaitée</label>
              </div>
            </div>
            <div class="col-md-6">
              <div class="form-floating">
                <select class="form-select" id="dureeBail" name="dureeBail" required>
                  <option value="">Choisir...</option>
                  <option value="12">12 mois</option>
                  <option value="24">24 mois</option>
                  <option value="36">36 mois</option>
                </select>
                <label for="dureeBail">Durée de bail souhaitée</label>
              </div>
            </div>
          </div>

          <div class="mb-3">
            <div class="form-floating">
                            <textarea class="form-control" id="motivations" name="motivations"
                                      style="height: 120px" placeholder="Parlez-nous de vous..."></textarea>
              <label for="motivations">Lettre de motivation (optionnel)</label>
            </div>
            <div class="form-text">
              Présentez-vous et expliquez pourquoi ce logement vous intéresse.
            </div>
          </div>

          <div class="mb-3">
            <div class="form-check">
              <input class="form-check-input" type="checkbox" id="accepteConditions" name="accepteConditions" required>
              <label class="form-check-label" for="accepteConditions">
                Je certifie que les informations fournies sont exactes et j'accepte que mes données soient transmises au propriétaire.
              </label>
            </div>
          </div>

          <div class="d-grid gap-2">
            <button type="submit" class="btn btn-success btn-rent">
              <span class="loading-spinner me-2"></span>
              <i class="fas fa-paper-plane me-2"></i>
              Envoyer ma candidature
            </button>
            <button type="button" class="btn btn-outline-secondary" onclick="hideRentalForm()">
              <i class="fas fa-times me-2"></i>Annuler
            </button>
          </div>
        </form>
      </div>

      <!-- Informations du propriétaire -->
      <div class="detail-card">
        <h5 class="mb-3">
          <i class="fas fa-user-tie me-2 text-primary"></i>
          Propriétaire
        </h5>

        <c:if test="${not empty unite.immeuble.proprietaire}">
          <div class="contact-owner-card">
            <div class="owner-avatar mx-auto">
                ${unite.immeuble.proprietaire.prenom.charAt(0)}${unite.immeuble.proprietaire.nom.charAt(0)}
            </div>

            <div class="text-center">
              <h6 class="mb-2">
                  ${unite.immeuble.proprietaire.prenom} ${unite.immeuble.proprietaire.nom}
              </h6>

              <div class="mb-2">
                <i class="fas fa-envelope me-2 text-muted"></i>
                <small>${unite.immeuble.proprietaire.email}</small>
              </div>

              <c:if test="${not empty unite.immeuble.proprietaire.telephone}">
                <div class="mb-3">
                  <i class="fas fa-phone me-2 text-muted"></i>
                  <small>${unite.immeuble.proprietaire.telephone}</small>
                </div>
              </c:if>

              <div class="d-grid gap-2">
                <button class="btn btn-outline-primary btn-sm" onclick="contactOwner()">
                  <i class="fas fa-envelope me-2"></i>Contacter
                </button>
                <button class="btn btn-outline-secondary btn-sm" onclick="reportProperty()">
                  <i class="fas fa-flag me-2"></i>Signaler
                </button>
              </div>
            </div>
          </div>
        </c:if>
      </div>

      <!-- Informations pratiques -->
      <div class="detail-card">
        <h5 class="mb-3">
          <i class="fas fa-info me-2 text-primary"></i>
          Informations pratiques
        </h5>

        <div class="small">
          <div class="d-flex justify-content-between mb-2">
            <strong>Référence :</strong>
            <span>UL-${unite.id}</span>
          </div>
          <div class="d-flex justify-content-between mb-2">
            <strong>Type :</strong>
            <span>${unite.nombrePieces} pièces</span>
          </div>
          <div class="d-flex justify-content-between mb-2">
            <strong>Surface :</strong>
            <span>${unite.superficie} m²</span>
          </div>
          <div class="d-flex justify-content-between mb-2">
            <strong>Étage :</strong>
            <span>
                            <c:choose>
                              <c:when test="${unite.etage == 0}">RDC</c:when>
                              <c:otherwise>${unite.etage}e étage</c:otherwise>
                            </c:choose>
                        </span>
          </div>
          <div class="d-flex justify-content-between mb-2">
            <strong>Disponibilité :</strong>
            <span class="text-success">Immédiate</span>
          </div>
          <div class="d-flex justify-content-between mb-0">
            <strong>Mise à jour :</strong>
            <span>
                            <c:choose>
                              <c:when test="${not empty unite.dateModification}">
                                <fmt:formatDate value="${unite.dateModification}" pattern="dd/MM/yyyy"/>
                              </c:when>
                              <c:otherwise>
                                <fmt:formatDate value="${unite.dateCreation}" pattern="dd/MM/yyyy"/>
                              </c:otherwise>
                            </c:choose>
                        </span>
          </div>
        </div>
      </div>

      <!-- Actions -->
      <div class="detail-card action-buttons">
        <h5 class="mb-3">
          <i class="fas fa-tools me-2 text-primary"></i>
          Actions
        </h5>
        <div class="d-grid gap-2">
          <button class="btn btn-outline-primary" onclick="window.print()">
            <i class="fas fa-print me-2"></i>Imprimer cette page
          </button>
          <button class="btn btn-outline-secondary" onclick="shareProperty()">
            <i class="fas fa-share me-2"></i>Partager ce logement
          </button>
          <button class="btn btn-outline-info" onclick="saveProperty()">
            <i class="fas fa-heart me-2"></i>Sauvegarder
          </button>
          <button class="btn btn-outline-warning" onclick="calculateBudget()">
            <i class="fas fa-calculator me-2"></i>Calculer budget
          </button>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Modal de confirmation -->
<div class="modal fade" id="confirmationModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">
          <i class="fas fa-check-circle me-2"></i>
          Candidature envoyée !
        </h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body text-center">
        <i class="fas fa-paper-plane fa-4x text-success mb-3"></i>
        <h5>Votre candidature a été transmise au propriétaire</h5>
        <p class="mb-3">Vous recevrez une réponse sous 48h maximum.</p>
        <p class="small text-muted">
          Un e-mail de confirmation a été envoyé à votre adresse.
        </p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-bs-dismiss="modal">
          <i class="fas fa-home me-2"></i>Retour au tableau de bord
        </button>
        <a href="${pageContext.request.contextPath}/locataire/recherche" class="btn btn-outline-secondary">
          <i class="fas fa-search me-2"></i>Continuer ma recherche
        </a>
      </div>
    </div>
  </div>
</div>

<!-- Modal calculateur de budget -->
<div class="modal fade" id="budgetModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">
          <i class="fas fa-calculator me-2"></i>
          Calculateur de budget logement
        </h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <div class="row">
          <div class="col-md-6">
            <h6>Coûts mensuels</h6>
            <div class="budget-item">
              <div class="d-flex justify-content-between">
                <span>Loyer :</span>
                <strong><fmt:formatNumber value="${unite.loyer}" type="currency" currencySymbol="€"/></strong>
              </div>
            </div>
            <c:if test="${not empty unite.chargesMensuelles}">
              <div class="budget-item">
                <div class="d-flex justify-content-between">
                  <span>Charges :</span>
                  <strong><fmt:formatNumber value="${unite.chargesMensuelles}" type="currency" currencySymbol="€"/></strong>
                </div>
              </div>
            </c:if>
            <div class="budget-item">
              <div class="d-flex justify-content-between">
                <span>Assurance (estimée) :</span>
                <strong>25 €</strong>
              </div>
            </div>
            <div class="budget-item border-top pt-2 mt-2">
              <div class="d-flex justify-content-between">
                <strong>Total mensuel :</strong>
                <strong class="text-primary">
                  <fmt:formatNumber value="${unite.loyer + (unite.chargesMensuelles != null ? unite.chargesMensuelles : 0) + 25}"
                                    type="currency" currencySymbol="€"/>
                </strong>
              </div>
            </div>
          </div>
          <div class="col-md-6">
            <h6>Coûts d'installation</h6>
            <c:if test="${not empty unite.depotGarantie}">
              <div class="budget-item">
                <div class="d-flex justify-content-between">
                  <span>Dépôt de garantie :</span>
                  <strong><fmt:formatNumber value="${unite.depotGarantie}" type="currency" currencySymbol="€"/></strong>
                </div>
              </div>
            </c:if>
            <div class="budget-item">
              <div class="d-flex justify-content-between">
                <span>Frais d'agence (estimés) :</span>
                <strong><fmt:formatNumber value="${unite.loyer * 0.8}" type="currency" currencySymbol="€"/></strong>
              </div>
            </div>
            <div class="budget-item">
              <div class="d-flex justify-content-between">
                <span>État des lieux :</span>
                <strong>150 €</strong>
              </div>
            </div>
            <div class="budget-item border-top pt-2 mt-2">
              <div class="d-flex justify-content-between">
                <strong>Total installation :</strong>
                <strong class="text-warning">
                  <fmt:formatNumber value="${(unite.depotGarantie != null ? unite.depotGarantie : unite.loyer) + (unite.loyer * 0.8) + 150}"
                                    type="currency" currencySymbol="€"/>
                </strong>
              </div>
            </div>
          </div>
        </div>

        <div class="mt-4 p-3 bg-light rounded">
          <div class="row">
            <div class="col-6">
              <small class="text-muted">Revenu minimum conseillé :</small><br>
              <strong class="text-info">
                <fmt:formatNumber value="${unite.loyer * 3}" type="currency" currencySymbol="€"/>
              </strong>
            </div>
            <div class="col-6">
              <small class="text-muted">Taux d'effort recommandé :</small><br>
              <strong class="text-info">≤ 33%</strong>
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
  function showRentalForm() {
    const formCard = document.getElementById('rentalFormCard');
    formCard.style.display = 'block';
    formCard.scrollIntoView({ behavior: 'smooth', block: 'start' });

    // Pré-remplir la date avec dans 1 mois
    const dateInput = document.getElementById('dateDebutSouhaitee');
    const nextMonth = new Date();
    nextMonth.setMonth(nextMonth.getMonth() + 1);
    dateInput.value = nextMonth.toISOString().split('T')[0];
  }

  function hideRentalForm() {
    document.getElementById('rentalFormCard').style.display = 'none';
  }

  function contactOwner() {
    const email = '${unite.immeuble.proprietaire.email}';
    const subject = encodeURIComponent('Demande d\'information - Logement ${unite.immeuble.nom} - Unité ${unite.numero}');
    const body = encodeURIComponent(`Bonjour,

Je suis intéressé(e) par votre logement :
- ${unite.immeuble.nom} - Unité ${unite.numero}
- ${unite.immeuble.adresse}, ${unite.immeuble.ville}
- ${unite.nombrePieces} pièces, ${unite.superficie} m²
- Loyer : ${unite.loyer} €

Pourriez-vous me fournir plus d'informations ?

Cordialement,
${sessionScope.utilisateur.prenom} ${sessionScope.utilisateur.nom}`);

    window.location.href = `mailto:${email}?subject=${subject}&body=${body}`;
  }

  function shareProperty() {
    if (navigator.share) {
      navigator.share({
        title: '${unite.immeuble.nom} - Unité ${unite.numero}',
        text: 'Logement ${unite.nombrePieces} pièces à ${unite.immeuble.ville} - ${unite.loyer}€/mois',
        url: window.location.href
      });
    } else {
      const url = window.location.href;
      navigator.clipboard.writeText(url).then(() => {
        alert('Lien copié dans le presse-papiers !');
      }).catch(() => {
        prompt('Copiez ce lien :', url);
      });
    }
  }

  function saveProperty() {
    // Simulation de sauvegarde dans les favoris
    const saved = localStorage.getItem('savedProperties') || '[]';
    const savedList = JSON.parse(saved);

    const property = {
      id: '${unite.id}',
      nom: '${unite.immeuble.nom}',
      numero: '${unite.numero}',
      ville: '${unite.immeuble.ville}',
      loyer: '${unite.loyer}',
      pieces: '${unite.nombrePieces}',
      superficie: '${unite.superficie}',
      savedAt: new Date().toISOString()
    };

    const exists = savedList.find(p => p.id === property.id);
    if (!exists) {
      savedList.push(property);
      localStorage.setItem('savedProperties', JSON.stringify(savedList));

      // Animation de confirmation
      const btn = event.target;
      const originalText = btn.innerHTML;
      btn.innerHTML = '<i class="fas fa-check me-2"></i>Sauvegardé !';
      btn.classList.replace('btn-outline-info', 'btn-success');

      setTimeout(() => {
        btn.innerHTML = originalText;
        btn.classList.replace('btn-success', 'btn-outline-info');
      }, 2000);
    } else {
      alert('Ce logement est déjà dans vos favoris.');
    }
  }

  function calculateBudget() {
    const budgetModal = new bootstrap.Modal(document.getElementById('budgetModal'));
    budgetModal.show();
  }

  function reportProperty() {
    const reasons = [
      'Informations erronées',
      'Photos non conformes',
      'Loyer abusif',
      'Discrimination',
      'Arnaque suspectée',
      'Autre'
    ];

    let reasonsText = 'Sélectionnez une raison :\n';
    reasons.forEach((reason, index) => {
      reasonsText += `${index + 1}. ${reason}\n`;
    });

    const choice = prompt(reasonsText + '\nTapez le numéro correspondant :');
    if (choice && choice >= 1 && choice <= reasons.length) {
      const selectedReason = reasons[choice - 1];
      const details = prompt(`Motif : ${selectedReason}\n\nPouvez-vous donner plus de détails ? (optionnel)`);

      alert('Signalement envoyé. Merci pour votre contribution à la sécurité de la plateforme.');

      // Ici vous pouvez envoyer les données au serveur
      console.log('Signalement:', {
        uniteId: '${unite.id}',
        reason: selectedReason,
        details: details,
        reportedBy: '${sessionScope.utilisateur.id}',
        timestamp: new Date().toISOString()
      });
    }
  }

  // Gestion du formulaire de candidature - VERSION CORRIGÉE
  document.getElementById('rentalApplicationForm').addEventListener('submit', function(e) {
    console.log('Form submission started');

    // Ne pas empêcher la soumission par défaut - laissons le formulaire se soumettre normalement
    // e.preventDefault(); // SUPPRIMÉ - c'était le problème principal !

    const submitBtn = this.querySelector('button[type="submit"]');
    const spinner = submitBtn.querySelector('.loading-spinner');

    // Validation côté client avant soumission
    const dateDebutSouhaitee = document.getElementById('dateDebutSouhaitee').value;
    const dureeBail = document.getElementById('dureeBail').value;
    const accepteConditions = document.getElementById('accepteConditions').checked;

    if (!dateDebutSouhaitee) {
      alert('Veuillez sélectionner une date d\'entrée souhaitée.');
      return false;
    }

    if (!dureeBail) {
      alert('Veuillez sélectionner une durée de bail.');
      return false;
    }

    if (!accepteConditions) {
      alert('Vous devez accepter les conditions pour continuer.');
      return false;
    }

    // Validation de la date (ne doit pas être dans le passé)
    const selectedDate = new Date(dateDebutSouhaitee);
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    if (selectedDate < today) {
      alert('La date d\'entrée ne peut pas être dans le passé.');
      return false;
    }

    // Animation de chargement
    submitBtn.disabled = true;
    spinner.style.display = 'inline-block';

    const originalContent = submitBtn.innerHTML;
    submitBtn.innerHTML = '<span class="loading-spinner me-2" style="display: inline-block;"></span>Envoi en cours...';

    console.log('Form data being submitted:', {
      uniteId: document.querySelector('input[name="uniteId"]').value,
      dateDebutSouhaitee: dateDebutSouhaitee,
      dureeBail: dureeBail,
      motivations: document.getElementById('motivations').value,
      accepteConditions: accepteConditions
    });

    // Le formulaire se soumettra maintenant normalement
    // La redirection sera gérée côté serveur

    // Timeout de sécurité pour réactiver le bouton si quelque chose échoue
    setTimeout(() => {
      submitBtn.disabled = false;
      submitBtn.innerHTML = originalContent;
      spinner.style.display = 'none';
    }, 10000); // 10 secondes
  });

  // Fonction pour afficher le formulaire (inchangée)
  function showRentalForm() {
    const formCard = document.getElementById('rentalFormCard');
    formCard.style.display = 'block';
    formCard.scrollIntoView({ behavior: 'smooth', block: 'start' });

    // Pré-remplir la date avec dans 1 mois
    const dateInput = document.getElementById('dateDebutSouhaitee');
    const nextMonth = new Date();
    nextMonth.setMonth(nextMonth.getMonth() + 1);
    dateInput.value = nextMonth.toISOString().split('T')[0];
  }

  // Fonction pour masquer le formulaire (inchangée)
  function hideRentalForm() {
    document.getElementById('rentalFormCard').style.display = 'none';
  }

  // Validation en temps réel des champs
  document.getElementById('dateDebutSouhaitee').addEventListener('change', function() {
    const selectedDate = new Date(this.value);
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    if (selectedDate < today) {
      this.setCustomValidity('La date d\'entrée ne peut pas être dans le passé.');
      this.reportValidity();
    } else {
      this.setCustomValidity('');
    }
  });

  document.getElementById('dureeBail').addEventListener('change', function() {
    const duree = parseInt(this.value);
    if (duree && (duree < 1 || duree > 60)) {
      this.setCustomValidity('La durée doit être comprise entre 1 et 60 mois.');
      this.reportValidity();
    } else {
      this.setCustomValidity('');
    }
  });
  // Auto-hide alerts
  document.addEventListener('DOMContentLoaded', function() {
    setTimeout(function() {
      const alerts = document.querySelectorAll('.alert');
      alerts.forEach(alert => {
        alert.style.transition = 'opacity 0.5s';
        alert.style.opacity = '0';
        setTimeout(() => alert.remove(), 500);
      });
    }, 5000);
  });

  // Smooth scrolling pour les ancres
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
      e.preventDefault();
      const target = document.querySelector(this.getAttribute('href'));
      if (target) {
        target.scrollIntoView({
          behavior: 'smooth',
          block: 'start'
        });
      }
    });
  });
</script>

<style>
  .budget-item {
    padding: 5px 0;
    border-bottom: 1px solid #eee;
  }

  .budget-item:last-child {
    border-bottom: none;
  }

  @media print {
    .sidebar, .btn, .modal {
      display: none !important;
    }

    .main-content {
      margin-left: 0 !important;
    }

    .property-hero {
      background: #f8f9fa !important;
      color: #000 !important;
    }
  }

  @media (max-width: 768px) {
    .sidebar {
      transform: translateX(-100%);
    }

    .main-content {
      margin-left: 0;
    }

    .price-main {
      font-size: 2rem;
    }

    .quick-stats {
      margin-bottom: 10px;
    }

    .stat-item {
      padding: 5px;
    }

    .stat-number {
      font-size: 1.5rem;
    }
  }
</style>
</body>
</html>