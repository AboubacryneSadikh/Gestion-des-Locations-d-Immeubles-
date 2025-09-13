<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détails de la candidature</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h3>Détails de la candidature</h3>
                    <a href="${pageContext.request.contextPath}/proprietaire/candidatures" class="btn btn-secondary">
                        Retour à la liste
                    </a>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty candidature}">
                            <div class="row">
                                <div class="col-md-6">
                                    <h5>Informations du locataire</h5>
                                    <p><strong>Nom :</strong>
                                        <c:choose>
                                            <c:when test="${not empty candidature.locataire and not empty candidature.locataire.utilisateur}">
                                                ${candidature.locataire.utilisateur.prenom} ${candidature.locataire.utilisateur.nom}
                                            </c:when>
                                            <c:otherwise>Non disponible</c:otherwise>
                                        </c:choose>
                                    </p>
                                    <p><strong>Email :</strong>
                                        <c:choose>
                                            <c:when test="${not empty candidature.locataire and not empty candidature.locataire.utilisateur}">
                                                ${candidature.locataire.utilisateur.email}
                                            </c:when>
                                            <c:otherwise>Non disponible</c:otherwise>
                                        </c:choose>
                                    </p>
                                    <c:if test="${not empty candidature.locataire.revenuMensuel}">
                                        <p><strong>Revenu mensuel :</strong>
                                            <fmt:formatNumber value="${candidature.locataire.revenuMensuel}" type="currency" currencySymbol="€"/>
                                        </p>
                                    </c:if>
                                </div>
                                <div class="col-md-6">
                                    <h5>Informations du logement</h5>
                                    <c:if test="${not empty candidature.unite and not empty candidature.unite.immeuble}">
                                        <p><strong>Immeuble :</strong> ${candidature.unite.immeuble.nom}</p>
                                        <p><strong>Unité :</strong> ${candidature.unite.numero}</p>
                                        <p><strong>Loyer :</strong>
                                            <fmt:formatNumber value="${candidature.unite.loyer}" type="currency" currencySymbol="€"/>
                                        </p>
                                    </c:if>
                                </div>
                            </div>

                            <div class="row mt-3">
                                <div class="col-12">
                                    <h5>Détails de la candidature</h5>
                                    <p><strong>Statut :</strong> ${candidature.statut}</p>
                                    <p><strong>Date de création :</strong>
                                        <fmt:formatDate value="${candidature.dateCreation}" pattern="dd/MM/yyyy HH:mm"/>
                                    </p>
                                    <c:if test="${not empty candidature.dateDebutSouhaitee}">
                                        <p><strong>Date d'entrée souhaitée :</strong>
                                            <fmt:formatDate value="${candidature.dateDebutSouhaitee}" pattern="dd/MM/yyyy"/>
                                        </p>
                                    </c:if>
                                    <c:if test="${not empty candidature.motivations}">
                                        <p><strong>Motivations :</strong></p>
                                        <div class="alert alert-light">
                                                ${candidature.motivations}
                                        </div>
                                    </c:if>
                                </div>
                            </div>

                            <c:if test="${candidature.statut == 'EN_ATTENTE'}">
                                <div class="mt-3">
                                    <a href="${pageContext.request.contextPath}/proprietaire/candidatures/manage?id=${candidature.id}"
                                       class="btn btn-warning">
                                        Gérer cette candidature
                                    </a>
                                </div>
                            </c:if>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-danger">
                                Aucune candidature trouvée ou erreur de chargement.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>