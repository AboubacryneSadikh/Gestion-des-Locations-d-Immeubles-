package com.example.geslocation.servlet;

import com.example.geslocation.model.*;
import com.example.geslocation.service.*;
import com.example.geslocation.service.impl.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Optional;

/**
 * Servlet pour gérer toutes les fonctionnalités des locataires.
 * Gestion simplifiée avec routing clair.
 */
@WebServlet(name = "locataireServlet", urlPatterns = {"/locataire/*"})
public class LocataireServlet extends HttpServlet {

    private final LocataireService locataireService;
    private final UniteLocationService uniteLocationService;
    private final ContratLocationService contratLocationService;
    private final PaiementService paiementService;
    private final CandidatureLocationService candidatureLocationService;
    private final EmailService emailService;

    public LocataireServlet() {
        this.locataireService = new LocataireServiceImpl();
        this.uniteLocationService = new UniteLocationServiceImpl();
        // CORRECTION : Utilisez l'implémentation complète
        this.contratLocationService = new ContratLocationServiceImpl();
        this.paiementService = new PaiementServiceImpl();
        this.candidatureLocationService = new CandidatureLocationServiceImpl();
        this.emailService = new EmailServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isLocataireConnecte(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = getAction(request);

        try {
            switch (action) {
                case "dashboard":
                    afficherDashboard(request, response);
                    break;
                case "profile":
                    afficherProfil(request, response);
                    break;
                case "profile-edit":
                    afficherEditionProfil(request, response);
                    break;
                case "recherche":
                    afficherRecherche(request, response);
                    break;
                case "logement":
                    afficherDetailsLogement(request, response);
                    break;
                case "contrats":
                    afficherMesContrats(request, response);
                    break;
                case "contrat":
                    afficherDetailsContrat(request, response);
                    break;
                case "paiements":
                    afficherMesPaiements(request, response);
                    break;
                case "paiement":
                    afficherFormulairePaiement(request, response);
                    break;
                default:
                    if (!response.isCommitted()) {
                        response.sendRedirect(request.getContextPath() + "/locataire/dashboard");
                    }
                    break;
            }
        } catch (Exception e) {
            System.err.println("ERREUR dans doGet: " + e.getMessage());
            e.printStackTrace();

            // Ne gérer l'erreur que si la réponse n'est pas encore envoyée
            if (!response.isCommitted()) {
                handleError(request, response, "Erreur lors du traitement de la demande: " + e.getMessage());
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isLocataireConnecte(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = getAction(request);

        try {
            switch (action) {
                case "profile-update":
                    mettreAJourProfil(request, response);
                    break;
                case "profile-create":
                    creerProfilLocataire(request, response);
                    break;
                case "candidature":
                    soumettreCandidat(request, response);
                    break;
                // CORRECTION : Une seule route pour les paiements
                case "paiement":
                    effectuerPaiement(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/locataire/dashboard");
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, "Erreur lors du traitement: " + e.getMessage());
        }
    }


    /**
     * Affiche le formulaire de paiement pour un paiement spécifique.
     * VERSION CORRIGÉE - Gestion améliorée des paramètres
     */
    private void afficherFormulairePaiement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String paiementIdStr = request.getParameter("id");
        String contratIdStr = request.getParameter("contratId");

        System.out.println("DEBUG: Paramètres reçus - id=" + paiementIdStr + ", contratId=" + contratIdStr);

        // Cas 1: Un ID de paiement spécifique est fourni
        if (paiementIdStr != null && !paiementIdStr.trim().isEmpty()) {
            try {
                Long paiementId = Long.parseLong(paiementIdStr);
                Optional<Paiement> optPaiement = paiementService.obtenirParId(paiementId);

                if (!optPaiement.isPresent()) {
                    request.getSession().setAttribute("error", "Paiement introuvable.");
                    response.sendRedirect(request.getContextPath() + "/locataire/paiements");
                    return;
                }

                Paiement paiement = optPaiement.get();

                // Vérifier que le paiement appartient bien au locataire connecté
                Utilisateur utilisateur = getUtilisateurConnecte(request);
                Optional<Locataire> optLocataire = locataireService.obtenirParUtilisateur(utilisateur.getId());

                if (!optLocataire.isPresent() ||
                        !paiement.getContrat().getLocataire().getId().equals(optLocataire.get().getId())) {
                    request.getSession().setAttribute("error", "Accès non autorisé à ce paiement.");
                    response.sendRedirect(request.getContextPath() + "/locataire/paiements");
                    return;
                }

                // Vérifier que le paiement n'est pas déjà payé
                if (paiement.getStatut() == Paiement.Statut.PAYE) {
                    request.getSession().setAttribute("error", "Ce paiement a déjà été effectué.");
                    response.sendRedirect(request.getContextPath() + "/locataire/paiements");
                    return;
                }

                request.setAttribute("paiement", paiement);
                request.setAttribute("contrat", paiement.getContrat());
                request.setAttribute("unite", paiement.getContrat().getUnite());

                request.getRequestDispatcher("/WEB-INF/views/locataire/paiements/form.jsp")
                        .forward(request, response);
                return;

            } catch (NumberFormatException e) {
                request.getSession().setAttribute("error", "Identifiant de paiement invalide.");
                response.sendRedirect(request.getContextPath() + "/locataire/paiements");
                return;
            }
        }

        // Cas 2: Un ID de contrat est fourni, trouver le premier paiement non payé
        if (contratIdStr != null && !contratIdStr.trim().isEmpty()) {
            try {
                Long contratId = Long.parseLong(contratIdStr);

                // Vérifier que le contrat appartient au locataire connecté
                Utilisateur utilisateur = getUtilisateurConnecte(request);
                Optional<Locataire> optLocataire = locataireService.obtenirParUtilisateur(utilisateur.getId());

                if (!optLocataire.isPresent()) {
                    request.getSession().setAttribute("error", "Profil locataire introuvable.");
                    response.sendRedirect(request.getContextPath() + "/locataire/paiements");
                    return;
                }

                Optional<ContratLocation> optContrat = contratLocationService.obtenirParId(contratId);
                if (!optContrat.isPresent() ||
                        !optContrat.get().getLocataire().getId().equals(optLocataire.get().getId())) {
                    request.getSession().setAttribute("error", "Accès non autorisé à ce contrat.");
                    response.sendRedirect(request.getContextPath() + "/locataire/paiements");
                    return;
                }

                ContratLocation contrat = optContrat.get();
                System.out.println("DEBUG: Traitement contrat ID: " + contratId);

                // CORRECTION 1: Récupérer d'abord les paiements existants
                List<Paiement> paiements = paiementService.obtenirParContrat(contratId);
                System.out.println("DEBUG: Nombre de paiements existants avant génération: " + paiements.size());

                // CORRECTION 2: Générer seulement si nécessaire (contrat EN_COURS et pas de paiements récents)
                boolean genererPaiements = false;
                if (contrat.getStatut() == ContratLocation.Statut.EN_COURS) {
                    if (paiements.isEmpty()) {
                        genererPaiements = true;
                        System.out.println("DEBUG: Aucun paiement trouvé, génération nécessaire");
                    } else {
                        // Vérifier si nous avons des paiements pour les 3 prochains mois
                        Calendar cal = Calendar.getInstance();
                        cal.add(Calendar.MONTH, 3);
                        Date dansTroisMois = cal.getTime();

                        boolean aPaiementsFuturs = paiements.stream()
                                .anyMatch(p -> p.getDateEcheance().after(new Date()) &&
                                        p.getDateEcheance().before(dansTroisMois));

                        if (!aPaiementsFuturs) {
                            genererPaiements = true;
                            System.out.println("DEBUG: Pas de paiements futurs, génération nécessaire");
                        }
                    }
                }

                // CORRECTION 3: Générer seulement si nécessaire et une seule fois
                if (genererPaiements) {
                    try {
                        System.out.println("DEBUG: Génération des paiements manquants...");
                        paiementService.genererPaiementsMensuels(contrat);

                        // Mettre à jour les statuts seulement après génération
                        paiementService.mettreAJourStatutsPaiements();

                        // Récupérer la liste mise à jour
                        paiements = paiementService.obtenirParContrat(contratId);
                        System.out.println("DEBUG: Nombre de paiements après génération: " + paiements.size());

                    } catch (Exception e) {
                        System.err.println("ERREUR lors de la génération des paiements: " + e.getMessage());
                        e.printStackTrace();
                    }
                } else {
                    System.out.println("DEBUG: Génération de paiements non nécessaire");
                    // Mettre à jour seulement les statuts
                    try {
                        paiementService.mettreAJourStatutsPaiements();
                    } catch (Exception e) {
                        System.err.println("ERREUR lors de la mise à jour des statuts: " + e.getMessage());
                    }
                }

                // CORRECTION 4: Si toujours pas de paiements après génération
                if (paiements.isEmpty()) {
                    try {
                        System.out.println("DEBUG: Création d'un paiement immédiat");
                        Paiement paiementImmediat = paiementService.creerPaiementImmediat(contrat, "LOYER");
                        System.out.println("DEBUG: Paiement immédiat créé avec ID: " + paiementImmediat.getId());
                        response.sendRedirect(request.getContextPath() +
                                "/locataire/paiement?id=" + paiementImmediat.getId());
                        return;
                    } catch (Exception e) {
                        System.err.println("ERREUR lors de la création du paiement immédiat: " + e.getMessage());
                        request.getSession().setAttribute("error",
                                "Impossible de créer un paiement pour ce contrat. Contactez l'administrateur.");
                        response.sendRedirect(request.getContextPath() + "/locataire/contrat?id=" + contratId);
                        return;
                    }
                }

                // Trouver le premier paiement non payé
                Optional<Paiement> premierPaiementNonPaye = paiements.stream()
                        .filter(p -> p.getStatut() != Paiement.Statut.PAYE)
                        .sorted((p1, p2) -> {
                            // Prioriser les paiements en retard, puis par date d'échéance
                            if (p1.getStatut() == Paiement.Statut.EN_RETARD &&
                                    p2.getStatut() != Paiement.Statut.EN_RETARD) {
                                return -1;
                            }
                            if (p2.getStatut() == Paiement.Statut.EN_RETARD &&
                                    p1.getStatut() != Paiement.Statut.EN_RETARD) {
                                return 1;
                            }
                            return p1.getDateEcheance().compareTo(p2.getDateEcheance());
                        })
                        .findFirst();

                if (premierPaiementNonPaye.isPresent()) {
                    System.out.println("DEBUG: Premier paiement non payé trouvé - ID: " +
                            premierPaiementNonPaye.get().getId());
                    response.sendRedirect(request.getContextPath() +
                            "/locataire/paiement?id=" + premierPaiementNonPaye.get().getId());
                    return;
                } else {
                    // CORRECTION 5: Plus prudent dans la création de paiements anticipés
                    if (contrat.getStatut() == ContratLocation.Statut.EN_COURS) {
                        try {
                            Calendar cal = Calendar.getInstance();
                            cal.add(Calendar.MONTH, 1); // Mois suivant
                            cal.set(Calendar.DAY_OF_MONTH, Math.max(1, Math.min(contrat.getJourPaiement(),
                                    cal.getActualMaximum(Calendar.DAY_OF_MONTH))));

                            // Vérifier qu'un paiement n'existe pas déjà pour cette période
                            final Date dateEcheancePrevue = cal.getTime();
                            boolean paiementExisteDeja = paiements.stream()
                                    .anyMatch(p -> {
                                        Calendar existingCal = Calendar.getInstance();
                                        existingCal.setTime(p.getDateEcheance());
                                        Calendar newCal = Calendar.getInstance();
                                        newCal.setTime(dateEcheancePrevue);
                                        return existingCal.get(Calendar.MONTH) == newCal.get(Calendar.MONTH) &&
                                                existingCal.get(Calendar.YEAR) == newCal.get(Calendar.YEAR);
                                    });

                            if (!paiementExisteDeja) {
                                Paiement paiementAnticipe = paiementService.creerPaiementImmediat(contrat, "LOYER");
                                System.out.println("DEBUG: Paiement anticipé créé avec ID: " + paiementAnticipe.getId());

                                response.sendRedirect(request.getContextPath() +
                                        "/locataire/paiement?id=" + paiementAnticipe.getId());
                                return;
                            } else {
                                System.out.println("DEBUG: Un paiement existe déjà pour la période anticipée");
                            }

                        } catch (Exception e) {
                            System.err.println("ERREUR lors de la création du paiement anticipé: " + e.getMessage());
                        }
                    }

                    // Si aucun paiement n'est disponible
                    request.getSession().setAttribute("info",
                            "Tous les paiements sont à jour pour ce contrat.");
                    response.sendRedirect(request.getContextPath() + "/locataire/contrat?id=" + contratId);
                    return;
                }

            } catch (NumberFormatException e) {
                request.getSession().setAttribute("error", "Identifiant de contrat invalide.");
                response.sendRedirect(request.getContextPath() + "/locataire/paiements");
                return;
            }
        }

        // Cas 3: Aucun paramètre fourni - erreur
        request.getSession().setAttribute("error", "Identifiant de paiement ou de contrat manquant.");
        response.sendRedirect(request.getContextPath() + "/locataire/paiements");
    }

    /**
     * Traite l'effectuation d'un paiement.
     */
    private void effectuerPaiement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Utilisateur utilisateur = getUtilisateurConnecte(request);
        Optional<Locataire> optLocataire = locataireService.obtenirParUtilisateur(utilisateur.getId());

        if (!optLocataire.isPresent()) {
            request.getSession().setAttribute("error", "Profil locataire introuvable.");
            response.sendRedirect(request.getContextPath() + "/locataire/profile");
            return;
        }

        try {
            // CORRECTION : Utiliser "id" au lieu de "paiementId"
            String paiementIdStr = request.getParameter("id");
            String modePaiement = request.getParameter("modePaiement");
            String referenceTransaction = request.getParameter("referenceTransaction");
            String commentaires = request.getParameter("commentaires");

            System.out.println("DEBUG: Effectuation paiement - ID: " + paiementIdStr + ", Mode: " + modePaiement);

            // Validation des paramètres
            if (paiementIdStr == null || paiementIdStr.trim().isEmpty()) {
                request.getSession().setAttribute("error", "Identifiant de paiement manquant.");
                response.sendRedirect(request.getContextPath() + "/locataire/paiements");
                return;
            }

            if (modePaiement == null || modePaiement.trim().isEmpty()) {
                request.getSession().setAttribute("error", "Le mode de paiement est obligatoire.");
                response.sendRedirect(request.getContextPath() + "/locataire/paiement?id=" + paiementIdStr);
                return;
            }

            Long paiementId = Long.parseLong(paiementIdStr);
            Optional<Paiement> optPaiement = paiementService.obtenirParId(paiementId);

            if (!optPaiement.isPresent()) {
                request.getSession().setAttribute("error", "Paiement introuvable.");
                response.sendRedirect(request.getContextPath() + "/locataire/paiements");
                return;
            }

            Paiement paiement = optPaiement.get();

            // Vérifier que le paiement appartient bien au locataire
            if (!paiement.getContrat().getLocataire().getId().equals(optLocataire.get().getId())) {
                request.getSession().setAttribute("error", "Accès non autorisé à ce paiement.");
                response.sendRedirect(request.getContextPath() + "/locataire/paiements");
                return;
            }

            // Vérifier que le paiement n'est pas déjà payé
            if (paiement.getStatut() == Paiement.Statut.PAYE) {
                request.getSession().setAttribute("error", "Ce paiement a déjà été effectué.");
                response.sendRedirect(request.getContextPath() + "/locataire/paiements");
                return;
            }

            // Simulation du traitement de paiement
            boolean paiementReussi = traiterPaiement(paiement, modePaiement, referenceTransaction);

            if (paiementReussi) {
                // Marquer le paiement comme payé
                boolean marque = paiementService.marquerCommePaye(
                        paiementId,
                        new Date(),
                        modePaiement
                );

                if (marque) {
                    // Mettre à jour les commentaires si fournis
                    if (commentaires != null && !commentaires.trim().isEmpty()) {
                        paiement.setCommentaires(commentaires.trim());
                        paiementService.mettreAJour(paiement);
                    }

                    // Générer le reçu
                    try {
                        paiementService.genererRecu(paiementId);
                    } catch (Exception e) {
                        System.err.println("ERREUR lors de la génération du reçu : " + e.getMessage());
                    }

                    // Envoyer notification par email
                    try {
                        emailService.envoyerConfirmationPaiement(paiement);
                    } catch (Exception e) {
                        System.err.println("ERREUR lors de l'envoi de confirmation : " + e.getMessage());
                    }

                    request.getSession().setAttribute("success",
                            "Paiement effectué avec succès ! Un reçu vous a été envoyé par email.");

                    System.out.println("DEBUG: Paiement réussi pour ID: " + paiementId);
                    response.sendRedirect(request.getContextPath() + "/locataire/paiements");

                } else {
                    request.getSession().setAttribute("error",
                            "Erreur lors de l'enregistrement du paiement. Veuillez réessayer.");
                    response.sendRedirect(request.getContextPath() + "/locataire/paiement?id=" + paiementId);
                }

            } else {
                request.getSession().setAttribute("error",
                        "Le paiement n'a pas pu être traité. Veuillez vérifier vos informations et réessayer.");
                response.sendRedirect(request.getContextPath() + "/locataire/paiement?id=" + paiementId);
            }

        } catch (NumberFormatException e) {
            System.err.println("ERREUR: Format de paiement ID invalide");
            request.getSession().setAttribute("error", "Identifiant de paiement invalide.");
            response.sendRedirect(request.getContextPath() + "/locataire/paiements");
        } catch (Exception e) {
            System.err.println("ERREUR lors du traitement du paiement : " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("error",
                    "Une erreur inattendue s'est produite lors du paiement. Veuillez réessayer.");
            response.sendRedirect(request.getContextPath() + "/locataire/paiements");
        }
    }

    /**
     * Simule le traitement du paiement avec un système de paiement externe.
     * Dans une implémentation réelle, ceci communiquerait avec un processeur de paiement
     * comme Stripe, PayPal, ou un système bancaire.
     */
    private boolean traiterPaiement(Paiement paiement, String modePaiement, String referenceTransaction) {
        System.out.println("DEBUG: Simulation traitement paiement...");

        try {
            // Simulation d'un délai de traitement
            Thread.sleep(1000);

            // Validation des données de paiement selon le mode
            switch (modePaiement.toUpperCase()) {
                case "CARTE_BANCAIRE":
                    // Ici on vérifierait les données de carte, CVV, etc.
                    System.out.println("DEBUG: Traitement paiement par carte bancaire");
                    break;

                case "VIREMENT_BANCAIRE":
                    // Ici on initierait un virement ou vérifierait la réception
                    System.out.println("DEBUG: Traitement virement bancaire");
                    break;

                case "CHEQUE":
                    // Ici on enregistrerait les détails du chèque
                    System.out.println("DEBUG: Enregistrement paiement par chèque");
                    break;

                case "ESPECES":
                    // Ici on enregistrerait le paiement en espèces
                    System.out.println("DEBUG: Enregistrement paiement en espèces");
                    break;

                default:
                    System.err.println("ERREUR: Mode de paiement non supporté: " + modePaiement);
                    return false;
            }

            // Simulation d'un taux de succès de 95% (pour tester les cas d'erreur)
            double random = Math.random();
            boolean succes = random < 0.95;

            System.out.println("DEBUG: Résultat simulation paiement: " + (succes ? "SUCCÈS" : "ÉCHEC"));
            return succes;

        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            System.err.println("ERREUR: Interruption lors du traitement du paiement");
            return false;
        } catch (Exception e) {
            System.err.println("ERREUR lors du traitement du paiement : " + e.getMessage());
            return false;
        }
    }

    /**
     * Traite la soumission d'une candidature de location.
     * VERSION CORRIGÉE avec gestion d'erreurs améliorée
     */
    private void soumettreCandidat(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("DEBUG: Début de soumettreCandidat");

        Utilisateur utilisateur = getUtilisateurConnecte(request);
        if (utilisateur == null) {
            System.err.println("ERREUR: Utilisateur non connecté");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        System.out.println("DEBUG: Utilisateur connecté ID = " + utilisateur.getId());

        Optional<Locataire> optLocataire = locataireService.obtenirParUtilisateur(utilisateur.getId());

        if (!optLocataire.isPresent()) {
            System.err.println("ERREUR: Profil locataire introuvable pour l'utilisateur " + utilisateur.getId());
            request.getSession().setAttribute("error", "Vous devez compléter votre profil locataire avant de postuler.");
            response.sendRedirect(request.getContextPath() + "/locataire/profile");
            return;
        }

        try {
            // Récupération et validation des paramètres
            String uniteIdStr = request.getParameter("uniteId");
            String dateDebutSouhaiteeStr = request.getParameter("dateDebutSouhaitee");
            String dureeBailStr = request.getParameter("dureeBail");
            String motivations = request.getParameter("motivations");
            String accepteConditions = request.getParameter("accepteConditions");

            System.out.println("DEBUG: Paramètres reçus:");
            System.out.println("  - uniteId: " + uniteIdStr);
            System.out.println("  - dateDebutSouhaitee: " + dateDebutSouhaiteeStr);
            System.out.println("  - dureeBail: " + dureeBailStr);
            System.out.println("  - accepteConditions: " + accepteConditions);

            // Validation des paramètres obligatoires
            if (uniteIdStr == null || uniteIdStr.trim().isEmpty()) {
                System.err.println("ERREUR: uniteId manquant");
                request.getSession().setAttribute("error", "Identifiant du logement manquant.");
                response.sendRedirect(request.getContextPath() + "/locataire/recherche");
                return;
            }

            if (dateDebutSouhaiteeStr == null || dateDebutSouhaiteeStr.trim().isEmpty()) {
                System.err.println("ERREUR: dateDebutSouhaitee manquante");
                request.getSession().setAttribute("error", "La date d'entrée souhaitée est obligatoire.");
                response.sendRedirect(request.getContextPath() + "/locataire/logement?id=" + uniteIdStr);
                return;
            }

            if (dureeBailStr == null || dureeBailStr.trim().isEmpty()) {
                System.err.println("ERREUR: dureeBail manquante");
                request.getSession().setAttribute("error", "La durée du bail est obligatoire.");
                response.sendRedirect(request.getContextPath() + "/locataire/logement?id=" + uniteIdStr);
                return;
            }

            if (accepteConditions == null || !accepteConditions.equals("on")) {
                System.err.println("ERREUR: conditions non acceptées");
                request.getSession().setAttribute("error", "Vous devez accepter les conditions pour continuer.");
                response.sendRedirect(request.getContextPath() + "/locataire/logement?id=" + uniteIdStr);
                return;
            }

            // Parsing des valeurs
            Long uniteId;
            Integer dureeBail;

            try {
                uniteId = Long.parseLong(uniteIdStr);
            } catch (NumberFormatException e) {
                System.err.println("ERREUR: Format uniteId invalide: " + uniteIdStr);
                request.getSession().setAttribute("error", "Identifiant du logement invalide.");
                response.sendRedirect(request.getContextPath() + "/locataire/recherche");
                return;
            }

            try {
                dureeBail = Integer.parseInt(dureeBailStr);
            } catch (NumberFormatException e) {
                System.err.println("ERREUR: Format dureeBail invalide: " + dureeBailStr);
                request.getSession().setAttribute("error", "Durée du bail invalide.");
                response.sendRedirect(request.getContextPath() + "/locataire/logement?id=" + uniteId);
                return;
            }

            System.out.println("DEBUG: Valeurs parsées - uniteId: " + uniteId + ", dureeBail: " + dureeBail);

            // Vérification de l'unité de location
            Optional<UniteLocation> optUnite = uniteLocationService.obtenirParId(uniteId);
            if (!optUnite.isPresent()) {
                System.err.println("ERREUR: Unité introuvable pour ID: " + uniteId);
                request.getSession().setAttribute("error", "Ce logement n'existe pas ou n'est plus disponible.");
                response.sendRedirect(request.getContextPath() + "/locataire/recherche");
                return;
            }

            UniteLocation unite = optUnite.get();

            if (unite.getStatut() != UniteLocation.Statut.DISPONIBLE) {
                System.err.println("ERREUR: Unité non disponible - Statut: " + unite.getStatut());
                request.getSession().setAttribute("error", "Ce logement n'est plus disponible.");
                response.sendRedirect(request.getContextPath() + "/locataire/recherche");
                return;
            }

            Locataire locataire = optLocataire.get();
            System.out.println("DEBUG: Locataire trouvé ID: " + locataire.getId());

            // Vérification de l'éligibilité
            boolean eligible = locataireService.estEligiblePourLocation(
                    locataire.getId(),
                    unite.getLoyer().doubleValue()
            );

            if (!eligible) {
                System.err.println("ERREUR: Locataire non éligible");
                request.getSession().setAttribute("error", "Votre profil ne correspond pas aux critères d'éligibilité pour ce logement.");
                response.sendRedirect(request.getContextPath() + "/locataire/logement?id=" + uniteId);
                return;
            }

            // Vérification qu'il n'y a pas déjà une candidature en cours pour cette unité
            if (candidatureLocationService.aCandidatureEnCours(locataire.getId(), uniteId)) {
                System.err.println("ERREUR: Candidature déjà en cours");
                request.getSession().setAttribute("error", "Vous avez déjà une candidature en cours pour ce logement.");
                response.sendRedirect(request.getContextPath() + "/locataire/logement?id=" + uniteId);
                return;
            }

            // Parsing de la date
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date dateDebutSouhaitee;
            try {
                dateDebutSouhaitee = sdf.parse(dateDebutSouhaiteeStr);
            } catch (ParseException e) {
                System.err.println("ERREUR: Format de date invalide: " + dateDebutSouhaiteeStr);
                request.getSession().setAttribute("error", "Format de date invalide.");
                response.sendRedirect(request.getContextPath() + "/locataire/logement?id=" + uniteId);
                return;
            }

            // Validation que la date n'est pas dans le passé
            if (dateDebutSouhaitee.before(new Date())) {
                System.err.println("ERREUR: Date dans le passé");
                request.getSession().setAttribute("error", "La date d'entrée souhaitée ne peut pas être dans le passé.");
                response.sendRedirect(request.getContextPath() + "/locataire/logement?id=" + uniteId);
                return;
            }

            // Validation de la durée du bail
            if (dureeBail < 1 || dureeBail > 60) {
                System.err.println("ERREUR: Durée bail invalide: " + dureeBail);
                request.getSession().setAttribute("error", "La durée du bail doit être comprise entre 1 et 60 mois.");
                response.sendRedirect(request.getContextPath() + "/locataire/logement?id=" + uniteId);
                return;
            }

            System.out.println("DEBUG: Création de la candidature...");

            // Création de la candidature
            CandidatureLocation candidature = new CandidatureLocation();
            candidature.setLocataire(locataire);
            candidature.setUnite(unite);
            candidature.setDateDebutSouhaitee(dateDebutSouhaitee);
            candidature.setDureeBail(dureeBail);
            candidature.setMotivations(motivations != null ? motivations.trim() : null);
            candidature.setStatut(CandidatureLocation.Statut.EN_ATTENTE);
            candidature.setDateCreation(new Date());

            // Sauvegarde de la candidature
            try {
                CandidatureLocation candidatureSauvegardee = candidatureLocationService.creer(candidature);
                System.out.println("DEBUG: Candidature sauvegardée avec ID: " + candidatureSauvegardee.getId());

                // Envoi des notifications par email
                try {
                    emailService.envoyerNotificationNouvelleCandidature(candidatureSauvegardee);
                    System.out.println("DEBUG: Notification email envoyée");
                } catch (Exception e) {
                    // Log l'erreur mais ne fait pas échouer la candidature
                    System.err.println("ERREUR lors de l'envoi des notifications email : " + e.getMessage());
                    e.printStackTrace();
                }

                // Message de succès
                request.getSession().setAttribute("success",
                        "Votre candidature a été envoyée avec succès ! Le propriétaire recevra une notification et vous répondra sous 48h maximum.");

                System.out.println("DEBUG: Redirection vers dashboard");
                response.sendRedirect(request.getContextPath() + "/locataire/dashboard");

            } catch (Exception e) {
                System.err.println("ERREUR lors de la sauvegarde de la candidature : " + e.getMessage());
                e.printStackTrace();
                request.getSession().setAttribute("error", "Une erreur s'est produite lors de l'enregistrement de votre candidature. Veuillez réessayer.");
                response.sendRedirect(request.getContextPath() + "/locataire/logement?id=" + uniteId);
            }

        } catch (Exception e) {
            System.err.println("ERREUR générale lors de la soumission de candidature : " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("error", "Une erreur inattendue s'est produite. Veuillez réessayer.");
            response.sendRedirect(request.getContextPath() + "/locataire/recherche");
        }
    }

    /**
     * Affiche le tableau de bord du locataire.
     */
    private void afficherDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Utilisateur utilisateur = getUtilisateurConnecte(request);
        Optional<Locataire> optLocataire = locataireService.obtenirParUtilisateur(utilisateur.getId());

        if (!optLocataire.isPresent()) {
            // Rediriger vers la création du profil
            request.setAttribute("needProfileCreation", true);
            request.getRequestDispatcher("/WEB-INF/views/locataire/profile/create.jsp")
                    .forward(request, response);
            return;
        }

        Locataire locataire = optLocataire.get();

        // Récupérer les statistiques
        List<ContratLocation> mesContrats = contratLocationService.obtenirParLocataire(locataire.getId());
        List<ContratLocation> contratsActifs = mesContrats.stream()
                .filter(c -> c.getStatut() == ContratLocation.Statut.EN_COURS)
                .toList();

        // Paiements à venir et en retard
        List<Paiement> tousPaiements = mesContrats.stream()
                .flatMap(c -> paiementService.obtenirParContrat(c.getId()).stream())
                .toList();

        List<Paiement> paiementsEnAttente = tousPaiements.stream()
                .filter(p -> p.getStatut() == Paiement.Statut.EN_ATTENTE)
                .toList();

        List<Paiement> paiementsEnRetard = tousPaiements.stream()
                .filter(p -> p.getStatut() == Paiement.Statut.EN_RETARD)
                .toList();

        List<Paiement> derniersPaiements = tousPaiements.stream()
                .filter(p -> p.getStatut() == Paiement.Statut.PAYE)
                .sorted((p1, p2) -> p2.getDatePaiement().compareTo(p1.getDatePaiement()))
                .limit(5)
                .toList();

        request.setAttribute("locataire", locataire);
        request.setAttribute("totalContrats", mesContrats.size());
        request.setAttribute("contratsActifs", contratsActifs);
        request.setAttribute("paiementsEnAttente", paiementsEnAttente);
        request.setAttribute("paiementsEnRetard", paiementsEnRetard);
        request.setAttribute("derniersPaiements", derniersPaiements);

        request.getRequestDispatcher("/WEB-INF/views/locataire/dashboard.jsp")
                .forward(request, response);
    }

    /**
     * Affiche le profil du locataire.
     */
    private void afficherProfil(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Utilisateur utilisateur = getUtilisateurConnecte(request);
        Optional<Locataire> optLocataire = locataireService.obtenirParUtilisateur(utilisateur.getId());

        if (!optLocataire.isPresent()) {
            request.getRequestDispatcher("/WEB-INF/views/locataire/profile/create.jsp")
                    .forward(request, response);
            return;
        }

        request.setAttribute("locataire", optLocataire.get());
        request.getRequestDispatcher("/WEB-INF/views/locataire/profile/view.jsp")
                .forward(request, response);
    }

    /**
     * Affiche le formulaire d'édition du profil.
     */
    private void afficherEditionProfil(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Utilisateur utilisateur = getUtilisateurConnecte(request);
        Optional<Locataire> optLocataire = locataireService.obtenirParUtilisateur(utilisateur.getId());

        if (!optLocataire.isPresent()) {
            response.sendRedirect(request.getContextPath() + "/locataire/profile");
            return;
        }

        request.setAttribute("locataire", optLocataire.get());
        request.getRequestDispatcher("/WEB-INF/views/locataire/profile/edit.jsp")
                .forward(request, response);
    }

    /**
     * Affiche la page de recherche de logements.
     */
    private void afficherRecherche(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Récupérer les paramètres de recherche
        String ville = request.getParameter("ville");
        String nombrePiecesStr = request.getParameter("nombrePieces");
        String loyerMinStr = request.getParameter("loyerMin");
        String loyerMaxStr = request.getParameter("loyerMax");

        List<UniteLocation> unites;
        boolean rechercheLancee = ville != null || nombrePiecesStr != null ||
                loyerMinStr != null || loyerMaxStr != null;

        if (rechercheLancee) {
            // Effectuer la recherche avec les critères
            Integer nombrePieces = parseInteger(nombrePiecesStr);
            BigDecimal loyerMin = parseBigDecimal(loyerMinStr);
            BigDecimal loyerMax = parseBigDecimal(loyerMaxStr);

            unites = uniteLocationService.rechercher(null, nombrePieces, loyerMin, loyerMax, true);

            // Filtrer par ville
            if (ville != null && !ville.trim().isEmpty()) {
                String villeRecherche = ville.toLowerCase().trim();
                unites = unites.stream()
                        .filter(u -> u.getImmeuble().getVille().toLowerCase().contains(villeRecherche))
                        .toList();
            }
        } else {
            // Afficher toutes les unités disponibles
            unites = uniteLocationService.obtenirDisponibles();
        }

        // Vérifier l'éligibilité pour chaque unité
        Utilisateur utilisateur = getUtilisateurConnecte(request);
        Optional<Locataire> optLocataire = locataireService.obtenirParUtilisateur(utilisateur.getId());

        request.setAttribute("unites", unites);
        request.setAttribute("ville", ville);
        request.setAttribute("nombrePieces", nombrePiecesStr);
        request.setAttribute("loyerMin", loyerMinStr);
        request.setAttribute("loyerMax", loyerMaxStr);
        request.setAttribute("rechercheLancee", rechercheLancee);
        request.setAttribute("hasProfile", optLocataire.isPresent());

        request.getRequestDispatcher("/WEB-INF/views/locataire/recherche.jsp")
                .forward(request, response);
    }

    /**
     * Affiche les détails d'un logement.
     * CORRECTION : Utilisation correcte de la session pour les messages d'erreur
     */
    private void afficherDetailsLogement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/locataire/recherche");
            return;
        }

        try {
            Long uniteId = Long.parseLong(idParam);
            Optional<UniteLocation> optUnite = uniteLocationService.obtenirParId(uniteId);

            if (!optUnite.isPresent() || optUnite.get().getStatut() != UniteLocation.Statut.DISPONIBLE) {
                // CORRECTION : Utiliser la session au lieu de request.setAttribute avec redirect
                request.getSession().setAttribute("error", "Logement non disponible.");
                response.sendRedirect(request.getContextPath() + "/locataire/recherche");
                return;
            }

            UniteLocation unite = optUnite.get();

            // Vérifier l'éligibilité
            Utilisateur utilisateur = getUtilisateurConnecte(request);
            Optional<Locataire> optLocataire = locataireService.obtenirParUtilisateur(utilisateur.getId());

            boolean eligible = false;
            boolean hasProfile = optLocataire.isPresent();

            if (hasProfile) {
                eligible = locataireService.estEligiblePourLocation(
                        optLocataire.get().getId(),
                        unite.getLoyer().doubleValue()
                );
            }

            request.setAttribute("unite", unite);
            request.setAttribute("eligible", eligible);
            request.setAttribute("hasProfile", hasProfile);

            request.getRequestDispatcher("/WEB-INF/views/locataire/logement/details.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/locataire/recherche");
        }
    }

    /**
     * Affiche la liste des contrats du locataire.
     */
    private void afficherMesContrats(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Utilisateur utilisateur = getUtilisateurConnecte(request);
        Optional<Locataire> optLocataire = locataireService.obtenirParUtilisateur(utilisateur.getId());

        if (!optLocataire.isPresent()) {
            response.sendRedirect(request.getContextPath() + "/locataire/profile");
            return;
        }

        List<ContratLocation> contrats = contratLocationService.obtenirParLocataire(optLocataire.get().getId());
        request.setAttribute("contrats", contrats);

        request.getRequestDispatcher("/WEB-INF/views/locataire/contrats/list.jsp")
                .forward(request, response);
    }

    /**
     * Correction dans la méthode afficherDetailsContrat()
     * Pour corriger les liens de paiement
     */
    private void afficherDetailsContrat(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/locataire/contrats");
            return;
        }

        try {
            Long contratId = Long.parseLong(idParam);
            Optional<ContratLocation> optContrat = contratLocationService.obtenirParId(contratId);

            if (!optContrat.isPresent()) {
                request.getSession().setAttribute("error", "Contrat non trouvé.");
                response.sendRedirect(request.getContextPath() + "/locataire/contrats");
                return;
            }

            ContratLocation contrat = optContrat.get();

            // Vérifier que le contrat appartient bien au locataire connecté
            Utilisateur utilisateur = getUtilisateurConnecte(request);
            Optional<Locataire> optLocataire = locataireService.obtenirParUtilisateur(utilisateur.getId());

            if (!optLocataire.isPresent() ||
                    !contrat.getLocataire().getId().equals(optLocataire.get().getId())) {
                request.getSession().setAttribute("error", "Accès non autorisé.");
                response.sendRedirect(request.getContextPath() + "/locataire/contrats");
                return;
            }

            // Récupérer les paiements du contrat
            List<Paiement> paiements = paiementService.obtenirParContrat(contratId);

            request.setAttribute("contrat", contrat);
            request.setAttribute("paiements", paiements);
            request.setAttribute("unite", contrat.getUnite());

            // Vérifier que la réponse n'a pas été envoyée avant le forward
            if (!response.isCommitted()) {
                request.getRequestDispatcher("/WEB-INF/views/locataire/contrats/details.jsp")
                        .forward(request, response);
            }

        } catch (NumberFormatException e) {
            System.err.println("ERREUR: ID de contrat invalide: " + idParam);
            if (!response.isCommitted()) {
                response.sendRedirect(request.getContextPath() + "/locataire/contrats");
            }
        } catch (Exception e) {
            System.err.println("ERREUR dans afficherDetailsContrat: " + e.getMessage());
            e.printStackTrace();

            if (!response.isCommitted()) {
                request.getSession().setAttribute("error", "Erreur lors de l'affichage du contrat.");
                response.sendRedirect(request.getContextPath() + "/locataire/contrats");
            }
        }
    }

    /**
     * Affiche la liste des paiements du locataire.
     */
    private void afficherMesPaiements(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Utilisateur utilisateur = getUtilisateurConnecte(request);
        Optional<Locataire> optLocataire = locataireService.obtenirParUtilisateur(utilisateur.getId());

        if (!optLocataire.isPresent()) {
            response.sendRedirect(request.getContextPath() + "/locataire/profile");
            return;
        }

        List<ContratLocation> contrats = contratLocationService.obtenirParLocataire(optLocataire.get().getId());

        // Récupérer tous les paiements
        List<Paiement> paiements = contrats.stream()
                .flatMap(c -> paiementService.obtenirParContrat(c.getId()).stream())
                .sorted((p1, p2) -> p2.getDateEcheance().compareTo(p1.getDateEcheance()))
                .toList();

        request.setAttribute("paiements", paiements);

        request.getRequestDispatcher("/WEB-INF/views/locataire/paiements/list.jsp")
                .forward(request, response);
    }

    /**
     * Met à jour le profil du locataire.
     */
    private void mettreAJourProfil(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Utilisateur utilisateur = getUtilisateurConnecte(request);
        Optional<Locataire> optLocataire = locataireService.obtenirParUtilisateur(utilisateur.getId());

        if (!optLocataire.isPresent()) {
            response.sendRedirect(request.getContextPath() + "/locataire/profile");
            return;
        }

        try {
            Locataire locataire = optLocataire.get();

            String profession = request.getParameter("profession");
            String employeur = request.getParameter("employeur");
            String revenuMensuelStr = request.getParameter("revenuMensuel");
            String numeroIdentification = request.getParameter("numeroIdentification");
            String telephoneEmployeur = request.getParameter("telephoneEmployeur");
            String adresseEmployeur = request.getParameter("adresseEmployeur");
            String contactUrgenceNom = request.getParameter("contactUrgenceNom");
            String contactUrgenceTelephone = request.getParameter("contactUrgenceTelephone");
            String contactUrgenceRelation = request.getParameter("contactUrgenceRelation");

            // Validation
            if (profession == null || profession.trim().isEmpty() ||
                    revenuMensuelStr == null || revenuMensuelStr.trim().isEmpty()) {

                request.setAttribute("error", "Veuillez remplir tous les champs obligatoires.");
                request.setAttribute("locataire", locataire);
                request.getRequestDispatcher("/WEB-INF/views/locataire/profile/edit.jsp")
                        .forward(request, response);
                return;
            }

            Double revenuMensuel = Double.parseDouble(revenuMensuelStr);
            if (revenuMensuel < 0) {
                throw new IllegalArgumentException("Le revenu ne peut pas être négatif");
            }

            // Mise à jour
            locataire.setProfession(profession.trim());
            locataire.setEmployeur(employeur != null ? employeur.trim() : null);
            locataire.setRevenuMensuel(revenuMensuel);
            locataire.setNumeroIdentification(numeroIdentification != null ? numeroIdentification.trim() : null);
            locataire.setTelephoneEmployeur(telephoneEmployeur != null ? telephoneEmployeur.trim() : null);
            locataire.setAdresseEmployeur(adresseEmployeur != null ? adresseEmployeur.trim() : null);
            locataire.setContactUrgenceNom(contactUrgenceNom != null ? contactUrgenceNom.trim() : null);
            locataire.setContactUrgenceTelephone(contactUrgenceTelephone != null ? contactUrgenceTelephone.trim() : null);
            locataire.setContactUrgenceRelation(contactUrgenceRelation != null ? contactUrgenceRelation.trim() : null);

            locataireService.mettreAJour(locataire);

            request.getSession().setAttribute("success", "Profil mis à jour avec succès.");
            response.sendRedirect(request.getContextPath() + "/locataire/profile");

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Veuillez saisir un revenu mensuel valide.");
            afficherEditionProfil(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors de la mise à jour: " + e.getMessage());
            afficherEditionProfil(request, response);
        }
    }

    /**
     * Crée le profil locataire.
     */
    private void creerProfilLocataire(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Utilisateur utilisateur = getUtilisateurConnecte(request);

        // Vérifier si le locataire a déjà un profil
        Optional<Locataire> optLocataire = locataireService.obtenirParUtilisateur(utilisateur.getId());
        if (optLocataire.isPresent()) {
            response.sendRedirect(request.getContextPath() + "/locataire/dashboard");
            return;
        }

        try {
            String profession = request.getParameter("profession");
            String employeur = request.getParameter("employeur");
            String revenuMensuelStr = request.getParameter("revenuMensuel");
            String numeroIdentification = request.getParameter("numeroIdentification");

            // Validation
            if (profession == null || profession.trim().isEmpty() ||
                    revenuMensuelStr == null || revenuMensuelStr.trim().isEmpty()) {

                request.setAttribute("error", "Veuillez remplir tous les champs obligatoires.");
                setProfilAttributes(request, profession, employeur, revenuMensuelStr, numeroIdentification);
                request.getRequestDispatcher("/WEB-INF/views/locataire/profile/create.jsp")
                        .forward(request, response);
                return;
            }

            Double revenuMensuel = Double.parseDouble(revenuMensuelStr);
            if (revenuMensuel < 0) {
                throw new IllegalArgumentException("Le revenu ne peut pas être négatif");
            }

            // Création du profil
            Locataire locataire = new Locataire();
            locataire.setProfession(profession.trim());
            locataire.setEmployeur(employeur != null ? employeur.trim() : null);
            locataire.setRevenuMensuel(revenuMensuel);
            locataire.setNumeroIdentification(numeroIdentification != null ? numeroIdentification.trim() : null);
            locataire.setActif(true);

            locataireService.creerAvecUtilisateurExistant(locataire, utilisateur.getId());

            request.getSession().setAttribute("success", "Profil locataire créé avec succès.");
            response.sendRedirect(request.getContextPath() + "/locataire/dashboard");

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Veuillez saisir un revenu mensuel valide.");
            setProfilAttributes(request, request.getParameter("profession"),
                    request.getParameter("employeur"), request.getParameter("revenuMensuel"),
                    request.getParameter("numeroIdentification"));
            request.getRequestDispatcher("/WEB-INF/views/locataire/profile/create.jsp")
                    .forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors de la création du profil: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/locataire/profile/create.jsp")
                    .forward(request, response);
        }
    }

    // Méthodes utilitaires

    private String getAction(HttpServletRequest request) {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            return "dashboard";
        }
        return pathInfo.substring(1); // Retirer le "/"
    }

    private boolean isLocataireConnecte(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;

        Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
        return user != null && user.getRole() == Utilisateur.Role.LOCATAIRE && user.isActif();
    }

    private Utilisateur getUtilisateurConnecte(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null ? (Utilisateur) session.getAttribute("utilisateur") : null;
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage)
            throws ServletException, IOException {

        // Vérifier si la réponse n'a pas déjà été envoyée
        if (response.isCommitted()) {
            // Si la réponse est déjà envoyée, on ne peut plus faire de forward
            // On log l'erreur et on sort
            System.err.println("ERREUR (réponse déjà envoyée): " + errorMessage);
            return;
        }

        try {
            // Mettre l'erreur en session pour qu'elle persiste lors des redirections
            request.getSession().setAttribute("error", errorMessage);

            // Rediriger vers le dashboard au lieu de faire un forward
            response.sendRedirect(request.getContextPath() + "/locataire/dashboard");

        } catch (IllegalStateException e) {
            // En cas d'erreur lors de la redirection, logger l'erreur
            System.err.println("ERREUR lors de la gestion d'erreur: " + errorMessage);
            System.err.println("Exception: " + e.getMessage());
        }
    }


    private Integer parseInteger(String value) {
        if (value == null || value.trim().isEmpty()) return null;
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private BigDecimal parseBigDecimal(String value) {
        if (value == null || value.trim().isEmpty()) return null;
        try {
            return new BigDecimal(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private void setProfilAttributes(HttpServletRequest request, String profession, String employeur,
                                     String revenuMensuel, String numeroIdentification) {
        request.setAttribute("profession", profession);
        request.setAttribute("employeur", employeur);
        request.setAttribute("revenuMensuel", revenuMensuel);
        request.setAttribute("numeroIdentification", numeroIdentification);
    }
}