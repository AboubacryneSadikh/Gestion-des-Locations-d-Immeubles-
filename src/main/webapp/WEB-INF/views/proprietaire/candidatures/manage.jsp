<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gérer la candidature</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h3>Gérer la candidature</h3>
                    <a href="${pageContext.request.contextPath}/proprietaire/candidatures" class="btn btn-secondary">
                        Retour à la liste
                    </a>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty candidature}">
                            <!-- Informations de la candidature -->
                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <div class="card">
                                        <div class="card-header">
                                            <h5>Informations du locataire</h5>
                                        </div>
                                        <div class="card-body">
                                            <c:if test="${not empty candidature.locataire and not empty candidature.locataire.utilisateur}">
                                                <p><strong>Nom :</strong> ${candidature.locataire.utilisateur.prenom} ${candidature.locataire.utilisateur.nom}</p>
                                                <p><strong>Email :</strong> ${candidature.locataire.utilisateur.email}</p>
                                                <c:if test="${not empty candidature.locataire.utilisateur.telephone}">
                                                    <p><strong>Téléphone :</strong> ${candidature.locataire.utilisateur.telephone}</p>
                                                </c:if>
                                                <c:if test="${not empty candidature.locataire.revenuMensuel}">
                                                    <p><strong>Revenu mensuel :</strong>
                                                        <fmt:formatNumber value="${candidature.locataire.revenuMensuel}" type="currency" currencySymbol="€"/>
                                                    </p>
                                                </c:if>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="card">
                                        <div class="card-header">
                                            <h5>Informations du logement</h5>
                                        </div>
                                        <div class="card-body">
                                            <c:if test="${not empty candidature.unite and not empty candidature.unite.immeuble}">
                                                <p><strong>Immeuble :</strong> ${candidature.unite.immeuble.nom}</p>
                                                <p><strong>Unité :</strong> ${candidature.unite.numero}</p>
                                                <p><strong>Pièces :</strong> ${candidature.unite.nombrePieces}</p>
                                                <p><strong>Loyer :</strong>
                                                    <fmt:formatNumber value="${candidature.unite.loyer}" type="currency" currencySymbol="€"/>
                                                </p>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <c:if test="${not empty candidature.motivations}">
                                <div class="mb-4">
                                    <h5>Motivations du candidat</h5>
                                    <div class="alert alert-light">
                                            ${candidature.motivations}
                                    </div>
                                </div>
                            </c:if>

                            <!-- Actions -->
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="card border-success">
                                        <div class="card-header bg-success text-white">
                                            <h5 class="mb-0">Approuver la candidature</h5>
                                        </div>
                                        <div class="card-body">
                                            <form method="post" action="${pageContext.request.contextPath}/proprietaire/candidatures/approve">
                                                <input type="hidden" name="id" value="${candidature.id}">
                                                <div class="mb-3">
                                                    <label for="commentaireApprouver" class="form-label">Commentaire (optionnel)</label>
                                                    <textarea class="form-control" id="commentaireApprouver" name="commentaire" rows="3"
                                                              placeholder="Message pour le locataire..."></textarea>
                                                </div>
                                                <button type="submit" class="btn btn-success w-100"
                                                        onclick="return confirm('Êtes-vous sûr de vouloir approuver cette candidature ?')">
                                                    <i class="fas fa-check"></i> Approuver
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="card border-danger">
                                        <div class="card-header bg-danger text-white">
                                            <h5 class="mb-0">Refuser la candidature</h5>
                                        </div>
                                        <div class="card-body">
                                            <form method="post" action="${pageContext.request.contextPath}/proprietaire/candidatures/reject">
                                                <input type="hidden" name="id" value="${candidature.id}">
                                                <div class="mb-3">
                                                    <label for="motifRefus" class="form-label">Motif de refus</label>
                                                    <select class="form-select" id="motifRefus" name="motifRefus" required>
                                                        <option value="">Choisir un motif...</option>
                                                        <option value="Revenus insuffisants">Revenus insuffisants</option>
                                                        <option value="Dossier incomplet">Dossier incomplet</option>
                                                        <option value="Autre candidat retenu">Autre candidat retenu</option>
                                                        <option value="Autre">Autre</option>
                                                    </select>
                                                </div>
                                                <div class="mb-3">
                                                    <label for="commentaireRefuser" class="form-label">Commentaire *</label>
                                                    <textarea class="form-control" id="commentaireRefuser" name="commentaire" rows="3"
                                                              placeholder="Expliquez le motif du refus..." required></textarea>
                                                </div>
                                                <button type="submit" class="btn btn-danger w-100"
                                                        onclick="return confirm('Êtes-vous sûr de vouloir refuser cette candidature ?')">
                                                    <i class="fas fa-times"></i> Refuser
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
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
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/all.min.js"></script>
</body>
</html>