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
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Servlet pour gérer les fonctionnalités des propriétaires.
 */
@WebServlet(name = "proprietaireServlet", urlPatterns = {"/proprietaire/*"})
public class ProprietaireServlet extends HttpServlet {

    private final ImmeubleService immeubleService;
    private final UniteLocationService uniteLocationService;
    private final ContratLocationService contratLocationService;
    private final CandidatureLocationService candidatureService;
    private final EmailService emailService;

    public ProprietaireServlet() {
        this.immeubleService = new ImmeubleServiceImpl();
        this.uniteLocationService = new UniteLocationServiceImpl();
        this.contratLocationService = new ContratLocationServiceImpl();
        this.candidatureService = new CandidatureLocationServiceImpl();
        this.emailService = new EmailServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Vérifier si l'utilisateur est connecté et est un propriétaire
        if (!isProprietaireUser(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String pathInfo = request.getPathInfo();

        // Débugger l'URL reçue
        System.out.println("PathInfo reçu: " + pathInfo);
        System.out.println("Context Path: " + request.getContextPath());
        System.out.println("Request URI: " + request.getRequestURI());

        // Si pathInfo est null, rediriger vers dashboard
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/proprietaire/dashboard");
            return;
        }

        try {
            switch (pathInfo) {
                case "/dashboard":
                    showDashboard(request, response);
                    break;
                case "/immeubles":
                    showImmeubles(request, response);
                    break;
                case "/immeubles/create":
                    showCreateImmeuble(request, response);
                    break;
                case "/immeubles/edit":
                    showEditImmeuble(request, response);
                    break;
                case "/immeubles/view":
                    showViewImmeuble(request, response);
                    break;
                case "/unites":
                    showUnites(request, response);
                    break;
                case "/unites/create":
                    showCreateUnite(request, response);
                    break;
                case "/unites/edit":
                    showEditUnite(request, response);
                    break;
                case "/candidatures":
                    showCandidatures(request, response);
                    break;
                case "/candidatures/view":
                    showViewCandidature(request, response);
                    break;
                case "/candidatures/manage":
                    showManageCandidature(request, response);
                    break;
                case "/contrats":
                    showContrats(request, response);
                    break;
                case "/contrats/view":
                    showViewContrat(request, response);
                    break;
                case "/contrats/manage":
                    showManageContrat(request, response);
                    break;
                default:
                    System.out.println("PathInfo non reconnu: " + pathInfo);
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Page non trouvée: " + pathInfo);
                    break;
            }
        } catch (Exception e) {
            System.err.println("Erreur dans ProprietaireServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur interne: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isProprietaireUser(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            response.sendRedirect(request.getContextPath() + "/proprietaire/dashboard");
            return;
        }

        switch (pathInfo) {
            case "/immeubles/create":
                handleCreateImmeuble(request, response);
                break;
            case "/immeubles/edit":
                handleEditImmeuble(request, response);
                break;
            case "/immeubles/delete":
                handleDeleteImmeuble(request, response);
                break;
            case "/unites/create":
                handleCreateUnite(request, response);
                break;
            case "/unites/edit":
                handleEditUnite(request, response);
                break;
            case "/unites/delete":
                handleDeleteUnite(request, response);
                break;
            case "/unites/toggle-status":
                handleToggleUniteStatus(request, response);
                break;
            case "/candidatures/approve":
                handleApproveCandidature(request, response);
                break;
            case "/candidatures/reject":
                handleRejectCandidature(request, response);
                break;
            case "/candidatures/create-contract":
                handleCreateContract(request, response);
                break;
            case "/contrats/update-status":
                handleUpdateContratStatus(request, response);
                break;
            case "/contrats/renew":
                handleRenewContrat(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/proprietaire/dashboard");
                break;
        }
    }

    /**
     * Affiche la page de gestion d'une candidature (approuver/refuser) - VERSION CORRIGÉE
     */
    private void showManageCandidature(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("DEBUG: showManageCandidature - début");

        String idParam = request.getParameter("id");
        System.out.println("DEBUG: ID paramètre reçu: " + idParam);

        if (idParam == null || idParam.trim().isEmpty()) {
            System.err.println("ERREUR: ID candidature manquant");
            request.getSession().setAttribute("error", "Identifiant de candidature manquant.");
            response.sendRedirect(request.getContextPath() + "/proprietaire/candidatures");
            return;
        }

        try {
            Long candidatureId = Long.parseLong(idParam);
            System.out.println("DEBUG: ID candidature parsé: " + candidatureId);

            var optCandidature = candidatureService.obtenirParId(candidatureId);
            System.out.println("DEBUG: Candidature trouvée: " + optCandidature.isPresent());

            if (optCandidature.isPresent()) {
                CandidatureLocation candidature = optCandidature.get();

                System.out.println("DEBUG: Candidature ID: " + candidature.getId());
                System.out.println("DEBUG: Statut: " + candidature.getStatut());

                // Vérifications de sécurité
                if (candidature.getUnite() == null) {
                    System.err.println("ERREUR: Unité null pour la candidature " + candidatureId);
                    request.getSession().setAttribute("error", "Données de candidature incomplètes.");
                    response.sendRedirect(request.getContextPath() + "/proprietaire/candidatures");
                    return;
                }

                if (candidature.getUnite().getImmeuble() == null) {
                    System.err.println("ERREUR: Immeuble null pour l'unité " + candidature.getUnite().getId());
                    request.getSession().setAttribute("error", "Données de logement incomplètes.");
                    response.sendRedirect(request.getContextPath() + "/proprietaire/candidatures");
                    return;
                }

                if (!isOwnerOfImmeuble(request, candidature.getUnite().getImmeuble())) {
                    System.err.println("ERREUR: Propriétaire non autorisé");
                    request.getSession().setAttribute("error", "Candidature non accessible.");
                    response.sendRedirect(request.getContextPath() + "/proprietaire/candidatures");
                    return;
                }

                if (candidature.getStatut() != CandidatureLocation.Statut.EN_ATTENTE) {
                    System.err.println("ERREUR: Candidature déjà traitée - Statut: " + candidature.getStatut());
                    request.getSession().setAttribute("error", "Cette candidature a déjà été traitée.");
                    response.sendRedirect(request.getContextPath() + "/proprietaire/candidatures");
                    return;
                }

                System.out.println("DEBUG: Toutes les vérifications passées");

                request.setAttribute("candidature", candidature);

                // Vérifier si le fichier JSP existe
                String jspPath = "/WEB-INF/views/proprietaire/candidatures/manage.jsp";
                System.out.println("DEBUG: Forward vers: " + jspPath);

                request.getRequestDispatcher(jspPath).forward(request, response);

            } else {
                System.err.println("ERREUR: Candidature non trouvée pour ID: " + candidatureId);
                request.getSession().setAttribute("error", "Candidature non trouvée.");
                response.sendRedirect(request.getContextPath() + "/proprietaire/candidatures");
            }

        } catch (NumberFormatException e) {
            System.err.println("ERREUR: Format ID invalide: " + idParam + " - " + e.getMessage());
            request.getSession().setAttribute("error", "Identifiant de candidature invalide.");
            response.sendRedirect(request.getContextPath() + "/proprietaire/candidatures");
        } catch (Exception e) {
            System.err.println("ERREUR générale dans showManageCandidature: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("error", "Erreur lors du chargement de la page de gestion.");
            response.sendRedirect(request.getContextPath() + "/proprietaire/candidatures");
        }
    }

    /**
     * Génère un numéro de contrat unique.
     */
    private String generateContractNumber() {
        return "CONT-" + System.currentTimeMillis();
    }

    /**
     * Gère l'approbation d'une candidature.
     */
    private void handleApproveCandidature(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Long candidatureId = Long.parseLong(request.getParameter("id"));
            String commentaire = request.getParameter("commentaire");

            var optCandidature = candidatureService.obtenirParId(candidatureId);

            if (optCandidature.isPresent()) {
                CandidatureLocation candidature = optCandidature.get();

                if (isOwnerOfImmeuble(request, candidature.getUnite().getImmeuble()) &&
                        candidature.getStatut() == CandidatureLocation.Statut.EN_ATTENTE) {

                    // Approuver la candidature
                    candidature.setStatut(CandidatureLocation.Statut.APPROUVEE);
                    candidature.setCommentaireProprietaire(commentaire);
                    candidature.setDateReponse(new Date());

                    candidatureService.mettreAJour(candidature);

                    // Changer le statut de l'unité en "RÉSERVÉ"
                    UniteLocation unite = candidature.getUnite();
                    unite.setStatut(UniteLocation.Statut.RESERVE);
                    uniteLocationService.mettreAJour(unite);

                    // Refuser automatiquement les autres candidatures pour cette unité
                    candidatureService.refuserAutresCandidatures(
                            unite.getId(),
                            candidatureId,
                            "Unité attribuée à un autre candidat"
                    );

                    // Envoyer notification par email au locataire
                    emailService.envoyerNotificationApprobation(candidature);

                    request.getSession().setAttribute("success",
                            "Candidature approuvée. Le locataire a été notifié par email.");
                } else {
                    request.getSession().setAttribute("error",
                            "Candidature non accessible ou déjà traitée.");
                }
            } else {
                request.getSession().setAttribute("error", "Candidature non trouvée.");
            }

        } catch (Exception e) {
            request.getSession().setAttribute("error",
                    "Erreur lors de l'approbation: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/proprietaire/candidatures");
    }

    /**
     * Gère le refus d'une candidature.
     */
    private void handleRejectCandidature(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Long candidatureId = Long.parseLong(request.getParameter("id"));
            String commentaire = request.getParameter("commentaire");
            String motifRefus = request.getParameter("motifRefus");

            if (commentaire == null || commentaire.trim().isEmpty()) {
                request.getSession().setAttribute("error",
                        "Veuillez indiquer un motif de refus.");
                response.sendRedirect(request.getContextPath() +
                        "/proprietaire/candidatures/manage?id=" + candidatureId);
                return;
            }

            var optCandidature = candidatureService.obtenirParId(candidatureId);

            if (optCandidature.isPresent()) {
                CandidatureLocation candidature = optCandidature.get();

                if (isOwnerOfImmeuble(request, candidature.getUnite().getImmeuble()) &&
                        candidature.getStatut() == CandidatureLocation.Statut.EN_ATTENTE) {

                    // Refuser la candidature
                    candidature.setStatut(CandidatureLocation.Statut.REFUSEE);
                    candidature.setCommentaireProprietaire(commentaire);
                    candidature.setDateReponse(new Date());

                    candidatureService.mettreAJour(candidature);

                    // Envoyer notification par email au locataire
                    emailService.envoyerNotificationRefus(candidature, motifRefus);

                    request.getSession().setAttribute("success",
                            "Candidature refusée. Le locataire a été notifié.");
                } else {
                    request.getSession().setAttribute("error",
                            "Candidature non accessible ou déjà traitée.");
                }
            } else {
                request.getSession().setAttribute("error", "Candidature non trouvée.");
            }

        } catch (Exception e) {
            request.getSession().setAttribute("error",
                    "Erreur lors du refus: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/proprietaire/candidatures");
    }

    /**
     * Gère la création d'un contrat à partir d'une candidature approuvée.
     */
    private void handleCreateContract(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        try {
            Long candidatureId = Long.parseLong(request.getParameter("candidatureId"));
            var optCandidature = candidatureService.obtenirParId(candidatureId);

            if (optCandidature.isPresent()) {
                CandidatureLocation candidature = optCandidature.get();

                if (isOwnerOfImmeuble(request, candidature.getUnite().getImmeuble()) &&
                        candidature.getStatut() == CandidatureLocation.Statut.APPROUVEE) {

                    // Créer le contrat
                    ContratLocation contrat = new ContratLocation();
                    contrat.setNumeroContrat(generateContractNumber());
                    contrat.setLocataire(candidature.getLocataire());
                    contrat.setUnite(candidature.getUnite());
                    contrat.setDateDebut(candidature.getDateDebutSouhaitee());

                    // Calculer la date de fin basée sur la durée demandée
                    Calendar cal = Calendar.getInstance();
                    cal.setTime(candidature.getDateDebutSouhaitee());
                    cal.add(Calendar.MONTH, candidature.getDureeBail());
                    contrat.setDateFin(cal.getTime());

                    contrat.setLoyer(candidature.getUnite().getLoyer());
                    contrat.setChargesMensuelles(candidature.getUnite().getChargesMensuelles());
                    contrat.setDepotGarantie(candidature.getUnite().getDepotGarantie());
                    contrat.setJourPaiement(5); // Par défaut le 5 du mois
                    contrat.setStatut(ContratLocation.Statut.EN_ATTENTE);

                    contratLocationService.creer(contrat);

                    // Mettre à jour la candidature
                    candidature.setStatut(CandidatureLocation.Statut.CONTRAT_SIGNE);
                    candidatureService.mettreAJour(candidature);

                    // Mettre à jour l'unité
                    candidature.getUnite().setStatut(UniteLocation.Statut.LOUE);
                    uniteLocationService.mettreAJour(candidature.getUnite());

                    // Envoyer notification par email
                    emailService.envoyerNotificationContrat(contrat);

                    request.getSession().setAttribute("success",
                            "Contrat créé avec succès. Le locataire a été notifié.");
                    response.sendRedirect(request.getContextPath() +
                            "/proprietaire/contrats/view?id=" + contrat.getId());
                } else {
                    request.getSession().setAttribute("error",
                            "Candidature non accessible ou dans un état incorrect.");
                    response.sendRedirect(request.getContextPath() + "/proprietaire/candidatures");
                }
            } else {
                request.getSession().setAttribute("error", "Candidature non trouvée.");
                response.sendRedirect(request.getContextPath() + "/proprietaire/candidatures");
            }

        } catch (Exception e) {
            request.getSession().setAttribute("error",
                    "Erreur lors de la création du contrat: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/proprietaire/candidatures");
        }
    }

    /**
     * Vérifie l'éligibilité d'un locataire pour une unité.
     */
    private boolean checkLocataireEligibility(Locataire locataire, UniteLocation unite) {
        if (locataire.getRevenuMensuel() == null) {
            return false;
        }

        // Revenus minimum = 3 fois le loyer
        double revenuMinimum = unite.getLoyer().doubleValue() * 3;
        return locataire.getRevenuMensuel() >= revenuMinimum;
    }

    /**
     * Affiche les détails d'une candidature - VERSION CORRIGÉE
     */
    private void showViewCandidature(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("DEBUG: showViewCandidature - début");

        String idParam = request.getParameter("id");
        System.out.println("DEBUG: ID paramètre reçu: " + idParam);

        if (idParam == null || idParam.trim().isEmpty()) {
            System.err.println("ERREUR: ID candidature manquant");
            request.getSession().setAttribute("error", "Identifiant de candidature manquant.");
            response.sendRedirect(request.getContextPath() + "/proprietaire/candidatures");
            return;
        }

        try {
            Long candidatureId = Long.parseLong(idParam);
            System.out.println("DEBUG: ID candidature parsé: " + candidatureId);

            var optCandidature = candidatureService.obtenirParId(candidatureId);
            System.out.println("DEBUG: Candidature trouvée: " + optCandidature.isPresent());

            if (optCandidature.isPresent()) {
                CandidatureLocation candidature = optCandidature.get();

                System.out.println("DEBUG: Candidature ID: " + candidature.getId());
                System.out.println("DEBUG: Unité: " + (candidature.getUnite() != null ? candidature.getUnite().getId() : "null"));
                System.out.println("DEBUG: Immeuble: " + (candidature.getUnite() != null && candidature.getUnite().getImmeuble() != null ?
                        candidature.getUnite().getImmeuble().getId() : "null"));

                // Vérifier que la candidature concerne un bien du propriétaire
                if (candidature.getUnite() == null) {
                    System.err.println("ERREUR: Unité null pour la candidature " + candidatureId);
                    request.getSession().setAttribute("error", "Données de candidature incomplètes.");
                    response.sendRedirect(request.getContextPath() + "/proprietaire/candidatures");
                    return;
                }

                if (candidature.getUnite().getImmeuble() == null) {
                    System.err.println("ERREUR: Immeuble null pour l'unité " + candidature.getUnite().getId());
                    request.getSession().setAttribute("error", "Données de logement incomplètes.");
                    response.sendRedirect(request.getContextPath() + "/proprietaire/candidatures");
                    return;
                }

                if (!isOwnerOfImmeuble(request, candidature.getUnite().getImmeuble())) {
                    System.err.println("ERREUR: Propriétaire non autorisé pour l'immeuble " +
                            candidature.getUnite().getImmeuble().getId());
                    request.getSession().setAttribute("error", "Candidature non trouvée ou accès non autorisé.");
                    response.sendRedirect(request.getContextPath() + "/proprietaire/candidatures");
                    return;
                }

                System.out.println("DEBUG: Vérifications passées, préparation des attributs");

                // Vérifier l'éligibilité du locataire
                boolean eligible = false;
                if (candidature.getLocataire() != null && candidature.getUnite() != null) {
                    try {
                        eligible = checkLocataireEligibility(candidature.getLocataire(), candidature.getUnite());
                        System.out.println("DEBUG: Éligibilité calculée: " + eligible);
                    } catch (Exception e) {
                        System.err.println("ERREUR lors du calcul d'éligibilité: " + e.getMessage());
                        eligible = false;
                    }
                }

                request.setAttribute("candidature", candidature);
                request.setAttribute("eligible", eligible);

                System.out.println("DEBUG: Forward vers JSP");
                request.getRequestDispatcher("/WEB-INF/views/proprietaire/candidatures/view.jsp")
                        .forward(request, response);

            } else {
                System.err.println("ERREUR: Candidature non trouvée pour ID: " + candidatureId);
                request.getSession().setAttribute("error", "Candidature non trouvée.");
                response.sendRedirect(request.getContextPath() + "/proprietaire/candidatures");
            }

        } catch (NumberFormatException e) {
            System.err.println("ERREUR: Format ID invalide: " + idParam + " - " + e.getMessage());
            request.getSession().setAttribute("error", "Identifiant de candidature invalide.");
            response.sendRedirect(request.getContextPath() + "/proprietaire/candidatures");
        } catch (Exception e) {
            System.err.println("ERREUR générale dans showViewCandidature: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("error", "Erreur lors du chargement des détails de la candidature.");
            response.sendRedirect(request.getContextPath() + "/proprietaire/candidatures");
        }
    }

    /**
     * Affiche la liste des candidatures reçues par le propriétaire.
     */
    private void showCandidatures(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Utilisateur proprietaire = getCurrentUser(request);
            String statutFilter = request.getParameter("statut");

            // Récupérer les candidatures pour les unités du propriétaire
            List<CandidatureLocation> candidatures = candidatureService.obtenirParProprietaire(
                    proprietaire.getId(), statutFilter
            );

            // Compter les candidatures par statut pour les badges
            Map<String, Long> statsStatuts = candidatures.stream()
                    .collect(Collectors.groupingBy(
                            c -> c.getStatut().name(),
                            Collectors.counting()
                    ));

            request.setAttribute("candidatures", candidatures);
            request.setAttribute("statsStatuts", statsStatuts);
            request.setAttribute("statutFilter", statutFilter);

            request.getRequestDispatcher("/WEB-INF/views/proprietaire/candidatures/list.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors du chargement des candidatures: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/proprietaire/candidatures/list.jsp")
                    .forward(request, response);
        }
    }

    /**
     * Affiche le tableau de bord du propriétaire.
     */
    private void showDashboard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Utilisateur proprietaire = getCurrentUser(request);

            // Statistiques du propriétaire
            List<Immeuble> immeubles = immeubleService.obtenirParProprietaire(proprietaire.getId());
            Long totalImmeubles = (long) immeubles.size();

            Long totalUnites = immeubleService.compterUnitesParProprietaire(proprietaire.getId());

            // Compter les unités disponibles et louées
            long unitesDisponibles = 0;
            long unitesLouees = 0;

            for (Immeuble immeuble : immeubles) {
                List<UniteLocation> unites = uniteLocationService.obtenirParImmeuble(immeuble.getId());
                for (UniteLocation unite : unites) {
                    if (unite.getStatut() == UniteLocation.Statut.DISPONIBLE) {
                        unitesDisponibles++;
                    } else if (unite.getStatut() == UniteLocation.Statut.LOUE) {
                        unitesLouees++;
                    }
                }
            }

            // Contrats actifs
            List<ContratLocation> contratsActifs = contratLocationService.obtenirActifs().stream()
                    .filter(c -> immeubles.stream().anyMatch(i ->
                            i.getId().equals(c.getUnite().getImmeuble().getId())))
                    .toList();
            Long totalContrats = (long) contratsActifs.size();

            // Candidatures en attente
            Long candidaturesEnAttente = candidatureService.compterParProprietaireEtStatut(
                    proprietaire.getId(), CandidatureLocation.Statut.EN_ATTENTE);

            // Candidatures récentes (5 dernières)
            List<CandidatureLocation> candidaturesRecentes = candidatureService
                    .obtenirRecentesParProprietaire(proprietaire.getId(), 5);

            request.setAttribute("totalImmeubles", totalImmeubles);
            request.setAttribute("totalUnites", totalUnites);
            request.setAttribute("unitesDisponibles", unitesDisponibles);
            request.setAttribute("unitesLouees", unitesLouees);
            request.setAttribute("totalContrats", totalContrats);
            request.setAttribute("candidaturesEnAttente", candidaturesEnAttente);
            request.setAttribute("candidaturesRecentes", candidaturesRecentes);

            // Immeubles récents
            request.setAttribute("recentImmeubles", immeubles.stream()
                    .sorted((i1, i2) -> i2.getDateCreation().compareTo(i1.getDateCreation()))
                    .limit(5)
                    .toList());

            // Contrats expirant dans les 30 jours
            List<ContratLocation> contratsExpirant = contratLocationService.obtenirExpirantDansJours(30).stream()
                    .filter(c -> immeubles.stream().anyMatch(i ->
                            i.getId().equals(c.getUnite().getImmeuble().getId())))
                    .toList();
            request.setAttribute("contratsExpirant", contratsExpirant);

            request.getRequestDispatcher("/WEB-INF/views/proprietaire/dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors du chargement du tableau de bord: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/proprietaire/dashboard.jsp").forward(request, response);
        }
    }

    /**
     * Affiche la liste des immeubles du propriétaire.
     */
    private void showImmeubles(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Utilisateur proprietaire = getCurrentUser(request);
            List<Immeuble> immeubles = immeubleService.obtenirParProprietaire(proprietaire.getId());

            // Ajouter des informations supplémentaires pour chaque immeuble
            for (Immeuble immeuble : immeubles) {
                List<UniteLocation> unites = uniteLocationService.obtenirParImmeuble(immeuble.getId());
                immeuble.setNombreUnites(unites.size());
            }

            request.setAttribute("immeubles", immeubles);
            request.getRequestDispatcher("/WEB-INF/views/proprietaire/immeubles/list.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors du chargement des immeubles: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/proprietaire/immeubles/list.jsp").forward(request, response);
        }
    }

    /**
     * Affiche le formulaire de création d'immeuble.
     */
    private void showCreateImmeuble(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/proprietaire/immeubles/create.jsp").forward(request, response);
    }
    /**
     * Affiche la page de gestion d'un contrat (changement de statut)
     */
    private void showManageContrat(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Long contratId = Long.parseLong(request.getParameter("id"));
            var optContrat = contratLocationService.obtenirParId(contratId);

            if (optContrat.isPresent()) {
                ContratLocation contrat = optContrat.get();

                // Vérifier que le contrat appartient au propriétaire
                if (isOwnerOfImmeuble(request, contrat.getUnite().getImmeuble())) {
                    request.setAttribute("contrat", contrat);
                    request.getRequestDispatcher("/WEB-INF/views/proprietaire/contrats/manage.jsp")
                            .forward(request, response);
                } else {
                    request.getSession().setAttribute("error", "Accès non autorisé à ce contrat.");
                    response.sendRedirect(request.getContextPath() + "/proprietaire/contrats");
                }
            } else {
                request.getSession().setAttribute("error", "Contrat non trouvé.");
                response.sendRedirect(request.getContextPath() + "/proprietaire/contrats");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/proprietaire/contrats");
        }
    }

    /**
     * Gère la mise à jour du statut d'un contrat
     */
    private void handleUpdateContratStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Long contratId = Long.parseLong(request.getParameter("contratId"));
            String nouveauStatutStr = request.getParameter("nouveauStatut");

            if (nouveauStatutStr == null || nouveauStatutStr.trim().isEmpty()) {
                request.getSession().setAttribute("error", "Statut manquant.");
                response.sendRedirect(request.getContextPath() + "/proprietaire/contrats/manage?id=" + contratId);
                return;
            }

            ContratLocation.Statut nouveauStatut = ContratLocation.Statut.valueOf(nouveauStatutStr);

            var optContrat = contratLocationService.obtenirParId(contratId);
            if (!optContrat.isPresent()) {
                request.getSession().setAttribute("error", "Contrat non trouvé.");
                response.sendRedirect(request.getContextPath() + "/proprietaire/contrats");
                return;
            }

            ContratLocation contrat = optContrat.get();

            // Vérifier les droits
            if (!isOwnerOfImmeuble(request, contrat.getUnite().getImmeuble())) {
                request.getSession().setAttribute("error", "Accès non autorisé à ce contrat.");
                response.sendRedirect(request.getContextPath() + "/proprietaire/contrats");
                return;
            }

            // Traitement selon le nouveau statut
            if (nouveauStatut == ContratLocation.Statut.RESILIE) {
                handleResiliationContrat(request, response, contrat);
            } else {
                // Mise à jour simple du statut
                boolean success = contratLocationService.mettreAJourStatut(contratId, nouveauStatut);

                if (success) {
                    // Mise à jour des dates si fournies
                    updateContratDates(request, contrat);

                    request.getSession().setAttribute("success",
                            "Statut du contrat mis à jour avec succès.");
                } else {
                    request.getSession().setAttribute("error",
                            "Erreur lors de la mise à jour du statut.");
                }
            }

            response.sendRedirect(request.getContextPath() + "/proprietaire/contrats/view?id=" + contratId);

        } catch (Exception e) {
            request.getSession().setAttribute("error",
                    "Erreur lors de la mise à jour: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/proprietaire/contrats");
        }
    }

    /**
     * Gère la résiliation d'un contrat
     */
    private void handleResiliationContrat(HttpServletRequest request, HttpServletResponse response,
                                          ContratLocation contrat) throws IOException {
        try {
            String dateResiliationStr = request.getParameter("dateResiliation");
            String motifResiliation = request.getParameter("motifResiliation");
            String commentaire = request.getParameter("commentaire");

            // Validations
            if (dateResiliationStr == null || dateResiliationStr.trim().isEmpty()) {
                request.getSession().setAttribute("error", "Date de résiliation obligatoire.");
                response.sendRedirect(request.getContextPath() + "/proprietaire/contrats/manage?id=" + contrat.getId());
                return;
            }

            if (motifResiliation == null || motifResiliation.trim().isEmpty()) {
                request.getSession().setAttribute("error", "Motif de résiliation obligatoire.");
                response.sendRedirect(request.getContextPath() + "/proprietaire/contrats/manage?id=" + contrat.getId());
                return;
            }

            Date dateResiliation = java.sql.Date.valueOf(dateResiliationStr);

            // Vérifier que la date n'est pas dans le passé
            if (dateResiliation.before(new Date())) {
                request.getSession().setAttribute("error",
                        "La date de résiliation ne peut pas être antérieure à aujourd'hui.");
                response.sendRedirect(request.getContextPath() + "/proprietaire/contrats/manage?id=" + contrat.getId());
                return;
            }

            // Effectuer la résiliation avec les nouveaux paramètres
            boolean success = contratLocationService.resilier(contrat.getId(), dateResiliation, motifResiliation, commentaire);

            if (success) {
                request.getSession().setAttribute("success",
                        "Contrat résilié avec succès. L'unité est maintenant disponible.");
            } else {
                request.getSession().setAttribute("error",
                        "Erreur lors de la résiliation du contrat.");
            }

        } catch (Exception e) {
            request.getSession().setAttribute("error",
                    "Erreur lors de la résiliation: " + e.getMessage());
        }
    }

    /**
     * Met à jour les dates du contrat si fournies
     */
    private void updateContratDates(HttpServletRequest request, ContratLocation contrat) {
        try {
            String nouvelleDateDebutStr = request.getParameter("nouvelleDateDebut");
            String nouvelleDateFinStr = request.getParameter("nouvelleDateFin");

            boolean dateChanged = false;

            if (nouvelleDateDebutStr != null && !nouvelleDateDebutStr.trim().isEmpty()) {
                Date nouvelleDate = java.sql.Date.valueOf(nouvelleDateDebutStr);
                if (!nouvelleDate.equals(contrat.getDateDebut())) {
                    contrat.setDateDebut(nouvelleDate);
                    dateChanged = true;
                }
            }

            if (nouvelleDateFinStr != null && !nouvelleDateFinStr.trim().isEmpty()) {
                Date nouvelleDate = java.sql.Date.valueOf(nouvelleDateFinStr);
                if (!nouvelleDate.equals(contrat.getDateFin())) {
                    contrat.setDateFin(nouvelleDate);
                    dateChanged = true;
                }
            }

            // Validation des dates
            if (dateChanged && contrat.getDateDebut().after(contrat.getDateFin())) {
                throw new Exception("La date de début doit être antérieure à la date de fin.");
            }

            if (dateChanged) {
                contratLocationService.mettreAJour(contrat);
            }

        } catch (Exception e) {
            // Log l'erreur mais ne pas faire échouer la mise à jour du statut
            System.err.println("Erreur mise à jour dates contrat: " + e.getMessage());
        }
    }

    /**
     * Gère le renouvellement d'un contrat
     */
    private void handleRenewContrat(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Long contratId = Long.parseLong(request.getParameter("contratId"));
            String nouvelleDateFinStr = request.getParameter("nouvelleDateFin");
            String nouveauLoyerStr = request.getParameter("nouveauLoyer");

            // Validations
            if (nouvelleDateFinStr == null || nouvelleDateFinStr.trim().isEmpty()) {
                request.getSession().setAttribute("error", "Nouvelle date de fin obligatoire.");
                response.sendRedirect(request.getContextPath() + "/proprietaire/contrats/view?id=" + contratId);
                return;
            }

            Date nouvelleDateFin = java.sql.Date.valueOf(nouvelleDateFinStr);
            BigDecimal nouveauLoyer = null;

            if (nouveauLoyerStr != null && !nouveauLoyerStr.trim().isEmpty()) {
                try {
                    nouveauLoyer = new BigDecimal(nouveauLoyerStr);
                    if (nouveauLoyer.compareTo(BigDecimal.ZERO) <= 0) {
                        request.getSession().setAttribute("error", "Le nouveau loyer doit être supérieur à zéro.");
                        response.sendRedirect(request.getContextPath() + "/proprietaire/contrats/view?id=" + contratId);
                        return;
                    }
                } catch (NumberFormatException e) {
                    request.getSession().setAttribute("error", "Montant du loyer invalide.");
                    response.sendRedirect(request.getContextPath() + "/proprietaire/contrats/view?id=" + contratId);
                    return;
                }
            }

            // Vérifier les droits
            var optContrat = contratLocationService.obtenirParId(contratId);
            if (!optContrat.isPresent()) {
                request.getSession().setAttribute("error", "Contrat non trouvé.");
                response.sendRedirect(request.getContextPath() + "/proprietaire/contrats");
                return;
            }

            ContratLocation contrat = optContrat.get();
            if (!isOwnerOfImmeuble(request, contrat.getUnite().getImmeuble())) {
                request.getSession().setAttribute("error", "Accès non autorisé à ce contrat.");
                response.sendRedirect(request.getContextPath() + "/proprietaire/contrats");
                return;
            }

            // Effectuer le renouvellement
            ContratLocation contratRenouvele = contratLocationService.renouveler(contratId, nouvelleDateFin, nouveauLoyer);

            if (contratRenouvele != null) {
                request.getSession().setAttribute("success",
                        "Contrat renouvelé avec succès jusqu'au " +
                                new java.text.SimpleDateFormat("dd/MM/yyyy").format(nouvelleDateFin) + ".");

                // Envoyer notification au locataire
                try {
                    emailService.envoyerNotificationRenouvellement(contratRenouvele);
                } catch (Exception e) {
                    System.err.println("Erreur envoi email renouvellement: " + e.getMessage());
                }
            } else {
                request.getSession().setAttribute("error", "Erreur lors du renouvellement du contrat.");
            }

            response.sendRedirect(request.getContextPath() + "/proprietaire/contrats/view?id=" + contratId);

        } catch (Exception e) {
            request.getSession().setAttribute("error",
                    "Erreur lors du renouvellement: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/proprietaire/contrats");
        }
    }


    /**
     * Affiche le formulaire d'édition d'immeuble.
     */
    private void showEditImmeuble(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Long immeubleId = Long.parseLong(request.getParameter("id"));
            var optImmeuble = immeubleService.obtenirParId(immeubleId);

            if (optImmeuble.isPresent() &&
                    isOwnerOfImmeuble(request, optImmeuble.get())) {
                request.setAttribute("immeuble", optImmeuble.get());
                request.getRequestDispatcher("/WEB-INF/views/proprietaire/immeubles/edit.jsp").forward(request, response);
            } else {
                request.getSession().setAttribute("error", "Immeuble non trouvé ou accès non autorisé.");
                response.sendRedirect(request.getContextPath() + "/proprietaire/immeubles");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/proprietaire/immeubles");
        }
    }

    /**
     * Affiche les détails d'un immeuble.
     */
    private void showViewImmeuble(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Long immeubleId = Long.parseLong(request.getParameter("id"));
            var optImmeuble = immeubleService.obtenirParId(immeubleId);

            if (optImmeuble.isPresent() &&
                    isOwnerOfImmeuble(request, optImmeuble.get())) {

                Immeuble immeuble = optImmeuble.get();
                List<UniteLocation> unites = uniteLocationService.obtenirParImmeuble(immeubleId);

                request.setAttribute("immeuble", immeuble);
                request.setAttribute("unites", unites);

                request.getRequestDispatcher("/WEB-INF/views/proprietaire/immeubles/view.jsp").forward(request, response);
            } else {
                request.getSession().setAttribute("error", "Immeuble non trouvé ou accès non autorisé.");
                response.sendRedirect(request.getContextPath() + "/proprietaire/immeubles");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/proprietaire/immeubles");
        }
    }

    /**
     * Affiche la liste des unités du propriétaire.
     */
    private void showUnites(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Utilisateur proprietaire = getCurrentUser(request);
            String immeubleIdParam = request.getParameter("immeubleId");

            List<UniteLocation> unites;

            if (immeubleIdParam != null && !immeubleIdParam.isEmpty()) {
                Long immeubleId = Long.parseLong(immeubleIdParam);
                var optImmeuble = immeubleService.obtenirParId(immeubleId);

                if (optImmeuble.isPresent() && isOwnerOfImmeuble(request, optImmeuble.get())) {
                    unites = uniteLocationService.obtenirParImmeuble(immeubleId);
                    request.setAttribute("selectedImmeuble", optImmeuble.get());
                } else {
                    request.getSession().setAttribute("error", "Accès non autorisé à cet immeuble.");
                    response.sendRedirect(request.getContextPath() + "/proprietaire/immeubles");
                    return;
                }
            } else {
                // Obtenir toutes les unités des immeubles du propriétaire
                List<Immeuble> immeubles = immeubleService.obtenirParProprietaire(proprietaire.getId());
                unites = immeubles.stream()
                        .flatMap(i -> uniteLocationService.obtenirParImmeuble(i.getId()).stream())
                        .toList();
            }

            List<Immeuble> immeubles = immeubleService.obtenirParProprietaire(proprietaire.getId());

            request.setAttribute("unites", unites);
            request.setAttribute("immeubles", immeubles);
            request.getRequestDispatcher("/WEB-INF/views/proprietaire/unites/list.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors du chargement des unités: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/proprietaire/unites/list.jsp").forward(request, response);
        }
    }

    /**
     * Affiche le formulaire de création d'unité.
     */
    private void showCreateUnite(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Utilisateur proprietaire = getCurrentUser(request);
            List<Immeuble> immeubles = immeubleService.obtenirParProprietaire(proprietaire.getId());

            request.setAttribute("immeubles", immeubles);
            request.getRequestDispatcher("/WEB-INF/views/proprietaire/unites/create.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors du chargement du formulaire: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/proprietaire/unites");
        }
    }

    /**
     * Affiche le formulaire d'édition d'unité.
     */
    private void showEditUnite(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Long uniteId = Long.parseLong(request.getParameter("id"));
            var optUnite = uniteLocationService.obtenirParId(uniteId);

            if (optUnite.isPresent()) {
                UniteLocation unite = optUnite.get();

                if (isOwnerOfImmeuble(request, unite.getImmeuble())) {
                    Utilisateur proprietaire = getCurrentUser(request);
                    List<Immeuble> immeubles = immeubleService.obtenirParProprietaire(proprietaire.getId());

                    request.setAttribute("unite", unite);
                    request.setAttribute("immeubles", immeubles);
                    request.getRequestDispatcher("/WEB-INF/views/proprietaire/unites/edit.jsp").forward(request, response);
                } else {
                    request.getSession().setAttribute("error", "Accès non autorisé à cette unité.");
                    response.sendRedirect(request.getContextPath() + "/proprietaire/unites");
                }
            } else {
                request.getSession().setAttribute("error", "Unité non trouvée.");
                response.sendRedirect(request.getContextPath() + "/proprietaire/unites");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/proprietaire/unites");
        }
    }

    /**
     * Affiche la liste des contrats du propriétaire.
     */
    private void showContrats(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Utilisateur proprietaire = getCurrentUser(request);
            List<Immeuble> immeubles = immeubleService.obtenirParProprietaire(proprietaire.getId());

            // Filtrer les contrats qui concernent les immeubles du propriétaire
            List<ContratLocation> contrats = contratLocationService.obtenirTous().stream()
                    .filter(c -> immeubles.stream().anyMatch(i ->
                            i.getId().equals(c.getUnite().getImmeuble().getId())))
                    .toList();

            request.setAttribute("contrats", contrats);
            request.getRequestDispatcher("/WEB-INF/views/proprietaire/contrats/list.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors du chargement des contrats: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/proprietaire/contrats/list.jsp").forward(request, response);
        }
    }

    /**
     * Affiche les détails d'un contrat.
     */
    private void showViewContrat(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Long contratId = Long.parseLong(request.getParameter("id"));
            var optContrat = contratLocationService.obtenirParId(contratId);

            if (optContrat.isPresent()) {
                ContratLocation contrat = optContrat.get();

                if (isOwnerOfImmeuble(request, contrat.getUnite().getImmeuble())) {
                    request.setAttribute("contrat", contrat);
                    request.getRequestDispatcher("/WEB-INF/views/proprietaire/contrats/view.jsp").forward(request, response);
                } else {
                    request.getSession().setAttribute("error", "Accès non autorisé à ce contrat.");
                    response.sendRedirect(request.getContextPath() + "/proprietaire/contrats");
                }
            } else {
                request.getSession().setAttribute("error", "Contrat non trouvé.");
                response.sendRedirect(request.getContextPath() + "/proprietaire/contrats");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/proprietaire/contrats");
        }
    }

    /**
     * Gère la création d'un nouvel immeuble.
     */
    private void handleCreateImmeuble(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String nom = request.getParameter("nom");
            String adresse = request.getParameter("adresse");
            String ville = request.getParameter("ville");
            String codePostal = request.getParameter("codePostal");
            String description = request.getParameter("description");
            String equipementsStr = request.getParameter("equipements");

            // Validation
            if (nom == null || nom.trim().isEmpty() ||
                    adresse == null || adresse.trim().isEmpty() ||
                    ville == null || ville.trim().isEmpty()) {

                request.setAttribute("error", "Veuillez remplir tous les champs obligatoires.");
                setImmeubleAttributes(request, nom, adresse, ville, codePostal, description, equipementsStr);
                request.getRequestDispatcher("/WEB-INF/views/proprietaire/immeubles/create.jsp").forward(request, response);
                return;
            }

            // Créer l'immeuble
            Immeuble immeuble = new Immeuble();
            immeuble.setNom(nom.trim());
            immeuble.setAdresse(adresse.trim());
            immeuble.setVille(ville.trim());
            immeuble.setCodePostal(codePostal != null ? codePostal.trim() : null);
            immeuble.setDescription(description != null ? description.trim() : null);
            immeuble.setEquipements(equipementsStr != null ? equipementsStr.trim() : null);
            immeuble.setActif(true);

            Utilisateur proprietaire = getCurrentUser(request);
            immeubleService.creer(immeuble, proprietaire.getId());

            request.getSession().setAttribute("success", "Immeuble créé avec succès.");
            response.sendRedirect(request.getContextPath() + "/proprietaire/immeubles");

        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors de la création: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/proprietaire/immeubles/create.jsp").forward(request, response);
        }
    }

    /**
     * Gère la modification d'un immeuble.
     */
    private void handleEditImmeuble(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Long immeubleId = Long.parseLong(request.getParameter("id"));
            var optImmeuble = immeubleService.obtenirParId(immeubleId);

            if (!optImmeuble.isPresent() || !isOwnerOfImmeuble(request, optImmeuble.get())) {
                request.getSession().setAttribute("error", "Immeuble non trouvé ou accès non autorisé.");
                response.sendRedirect(request.getContextPath() + "/proprietaire/immeubles");
                return;
            }

            Immeuble immeuble = optImmeuble.get();

            String nom = request.getParameter("nom");
            String adresse = request.getParameter("adresse");
            String ville = request.getParameter("ville");
            String codePostal = request.getParameter("codePostal");
            String description = request.getParameter("description");
            String equipementsStr = request.getParameter("equipements");

            // Validation
            if (nom == null || nom.trim().isEmpty() ||
                    adresse == null || adresse.trim().isEmpty() ||
                    ville == null || ville.trim().isEmpty()) {

                request.setAttribute("error", "Veuillez remplir tous les champs obligatoires.");
                request.setAttribute("immeuble", immeuble);
                request.getRequestDispatcher("/WEB-INF/views/proprietaire/immeubles/edit.jsp").forward(request, response);
                return;
            }

            // Mettre à jour les informations
            immeuble.setNom(nom.trim());
            immeuble.setAdresse(adresse.trim());
            immeuble.setVille(ville.trim());
            immeuble.setCodePostal(codePostal != null ? codePostal.trim() : null);
            immeuble.setDescription(description != null ? description.trim() : null);
            immeuble.setEquipements(equipementsStr != null ? equipementsStr.trim() : null);

            immeubleService.mettreAJour(immeuble);

            request.getSession().setAttribute("success", "Immeuble modifié avec succès.");
            response.sendRedirect(request.getContextPath() + "/proprietaire/immeubles");

        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors de la modification: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/proprietaire/immeubles/edit.jsp").forward(request, response);
        }
    }

    /**
     * Gère la suppression d'un immeuble.
     */
    private void handleDeleteImmeuble(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            Long immeubleId = Long.parseLong(request.getParameter("id"));
            var optImmeuble = immeubleService.obtenirParId(immeubleId);

            if (optImmeuble.isPresent() && isOwnerOfImmeuble(request, optImmeuble.get())) {
                if (immeubleService.supprimer(immeubleId)) {
                    request.getSession().setAttribute("success", "Immeuble supprimé avec succès.");
                } else {
                    request.getSession().setAttribute("error", "Erreur lors de la suppression de l'immeuble.");
                }
            } else {
                request.getSession().setAttribute("error", "Immeuble non trouvé ou accès non autorisé.");
            }

        } catch (Exception e) {
            request.getSession().setAttribute("error", "Erreur lors de la suppression: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/proprietaire/immeubles");
    }

    /**
     * Gère la création d'une nouvelle unité.
     */
    private void handleCreateUnite(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Long immeubleId = Long.parseLong(request.getParameter("immeubleId"));
            String numeroUnite = request.getParameter("numero");
            String nombrePiecesStr = request.getParameter("nombrePieces");
            String superficieStr = request.getParameter("superficie");
            String loyerStr = request.getParameter("loyer");
            String chargesStr = request.getParameter("chargesMensuelles");
            String depotGarantieStr = request.getParameter("depotGarantie");
            String etageStr = request.getParameter("etage");
            String description = request.getParameter("description");
            String equipements = request.getParameter("equipements");

            // Vérifier que l'immeuble appartient au propriétaire
            var optImmeuble = immeubleService.obtenirParId(immeubleId);
            if (!optImmeuble.isPresent() || !isOwnerOfImmeuble(request, optImmeuble.get())) {
                request.getSession().setAttribute("error", "Immeuble non trouvé ou accès non autorisé.");
                response.sendRedirect(request.getContextPath() + "/proprietaire/unites");
                return;
            }

            // Validation
            if (numeroUnite == null || numeroUnite.trim().isEmpty() ||
                    nombrePiecesStr == null || nombrePiecesStr.trim().isEmpty() ||
                    loyerStr == null || loyerStr.trim().isEmpty() ||
                    etageStr == null || etageStr.trim().isEmpty() ||
                    superficieStr == null || superficieStr.trim().isEmpty()) {

                request.setAttribute("error", "Veuillez remplir tous les champs obligatoires.");
                setUniteAttributes(request, immeubleId, numeroUnite, nombrePiecesStr,
                        superficieStr, loyerStr, chargesStr, depotGarantieStr, etageStr, description, equipements);
                showCreateUnite(request, response);
                return;
            }

            // Créer l'unité
            UniteLocation unite = new UniteLocation();
            unite.setNumero(numeroUnite.trim());
            unite.setNombrePieces(Integer.parseInt(nombrePiecesStr));
            unite.setSuperficie(new BigDecimal(superficieStr));
            unite.setLoyer(new BigDecimal(loyerStr));
            unite.setEtage(Integer.parseInt(etageStr));

            if (chargesStr != null && !chargesStr.trim().isEmpty()) {
                unite.setChargesMensuelles(new BigDecimal(chargesStr));
            }

            if (depotGarantieStr != null && !depotGarantieStr.trim().isEmpty()) {
                unite.setDepotGarantie(new BigDecimal(depotGarantieStr));
            }

            unite.setDescription(description != null ? description.trim() : null);
            unite.setEquipements(equipements != null ? equipements.trim() : null);
            unite.setStatut(UniteLocation.Statut.DISPONIBLE);
            unite.setActif(true);

            uniteLocationService.creer(unite, immeubleId);

            request.getSession().setAttribute("success", "Unité créée avec succès.");
            response.sendRedirect(request.getContextPath() + "/proprietaire/unites?immeubleId=" + immeubleId);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Veuillez saisir des valeurs numériques valides.");
            showCreateUnite(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors de la création: " + e.getMessage());
            showCreateUnite(request, response);
        }
    }

    /**
     * Gère la modification d'une unité.
     */
    private void handleEditUnite(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Long uniteId = Long.parseLong(request.getParameter("id"));
            var optUnite = uniteLocationService.obtenirParId(uniteId);

            if (!optUnite.isPresent()) {
                request.getSession().setAttribute("error", "Unité non trouvée.");
                response.sendRedirect(request.getContextPath() + "/proprietaire/unites");
                return;
            }

            UniteLocation unite = optUnite.get();

            if (!isOwnerOfImmeuble(request, unite.getImmeuble())) {
                request.getSession().setAttribute("error", "Accès non autorisé à cette unité.");
                response.sendRedirect(request.getContextPath() + "/proprietaire/unites");
                return;
            }

            String numeroUnite = request.getParameter("numero");
            String nombrePiecesStr = request.getParameter("nombrePieces");
            String superficieStr = request.getParameter("superficie");
            String loyerStr = request.getParameter("loyer");
            String chargesStr = request.getParameter("chargesMensuelles");
            String depotGarantieStr = request.getParameter("depotGarantie");
            String etageStr = request.getParameter("etage");
            String description = request.getParameter("description");
            String equipements = request.getParameter("equipements");

            // Validation
            if (numeroUnite == null || numeroUnite.trim().isEmpty() ||
                    nombrePiecesStr == null || nombrePiecesStr.trim().isEmpty() ||
                    loyerStr == null || loyerStr.trim().isEmpty() ||
                    etageStr == null || etageStr.trim().isEmpty() ||
                    superficieStr == null || superficieStr.trim().isEmpty()) {

                request.setAttribute("error", "Veuillez remplir tous les champs obligatoires.");
                request.setAttribute("unite", unite);
                showEditUnite(request, response);
                return;
            }

            // Mettre à jour les informations
            unite.setNumero(numeroUnite.trim());
            unite.setNombrePieces(Integer.parseInt(nombrePiecesStr));
            unite.setSuperficie(new BigDecimal(superficieStr));
            unite.setLoyer(new BigDecimal(loyerStr));
            unite.setEtage(Integer.parseInt(etageStr));

            if (chargesStr != null && !chargesStr.trim().isEmpty()) {
                unite.setChargesMensuelles(new BigDecimal(chargesStr));
            } else {
                unite.setChargesMensuelles(null);
            }

            if (depotGarantieStr != null && !depotGarantieStr.trim().isEmpty()) {
                unite.setDepotGarantie(new BigDecimal(depotGarantieStr));
            } else {
                unite.setDepotGarantie(null);
            }

            unite.setDescription(description != null ? description.trim() : null);
            unite.setEquipements(equipements != null ? equipements.trim() : null);

            uniteLocationService.mettreAJour(unite);

            request.getSession().setAttribute("success", "Unité modifiée avec succès.");
            response.sendRedirect(request.getContextPath() + "/proprietaire/unites");

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Veuillez saisir des valeurs numériques valides.");
            showEditUnite(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors de la modification: " + e.getMessage());
            showEditUnite(request, response);
        }
    }

    /**
     * Gère la suppression d'une unité.
     */
    private void handleDeleteUnite(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            Long uniteId = Long.parseLong(request.getParameter("id"));
            var optUnite = uniteLocationService.obtenirParId(uniteId);

            if (optUnite.isPresent() && isOwnerOfImmeuble(request, optUnite.get().getImmeuble())) {
                if (uniteLocationService.supprimer(uniteId)) {
                    request.getSession().setAttribute("success", "Unité supprimée avec succès.");
                } else {
                    request.getSession().setAttribute("error", "Erreur lors de la suppression de l'unité.");
                }
            } else {
                request.getSession().setAttribute("error", "Unité non trouvée ou accès non autorisé.");
            }

        } catch (Exception e) {
            request.getSession().setAttribute("error", "Erreur lors de la suppression: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/proprietaire/unites");
    }

    /**
     * Gère le changement de statut d'une unité.
     */
    private void handleToggleUniteStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            Long uniteId = Long.parseLong(request.getParameter("id"));
            String statutStr = request.getParameter("statut");

            var optUnite = uniteLocationService.obtenirParId(uniteId);

            if (optUnite.isPresent() && isOwnerOfImmeuble(request, optUnite.get().getImmeuble())) {
                UniteLocation.Statut nouveauStatut = UniteLocation.Statut.valueOf(statutStr);

                if (uniteLocationService.mettreAJourStatut(uniteId, nouveauStatut)) {
                    request.getSession().setAttribute("success", "Statut de l'unité mis à jour avec succès.");
                } else {
                    request.getSession().setAttribute("error", "Erreur lors de la mise à jour du statut.");
                }
            } else {
                request.getSession().setAttribute("error", "Unité non trouvée ou accès non autorisé.");
            }

        } catch (Exception e) {
            request.getSession().setAttribute("error", "Erreur lors de la mise à jour: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/proprietaire/unites");
    }

    // Méthodes utilitaires

    /**
     * Définit les attributs pour le formulaire d'immeuble.
     */
    private void setImmeubleAttributes(HttpServletRequest request, String nom, String adresse,
                                       String ville, String codePostal, String description, String equipements) {
        request.setAttribute("nom", nom);
        request.setAttribute("adresse", adresse);
        request.setAttribute("ville", ville);
        request.setAttribute("codePostal", codePostal);
        request.setAttribute("description", description);
        request.setAttribute("equipements", equipements);
    }

    /**
     * Définit les attributs pour le formulaire d'unité.
     */
    private void setUniteAttributes(HttpServletRequest request, Long immeubleId, String numero,
                                    String nombrePieces, String superficie, String loyer,
                                    String charges, String depot, String etage, String description, String equipements) {
        request.setAttribute("selectedImmeubleId", immeubleId);
        request.setAttribute("numero", numero);
        request.setAttribute("nombrePieces", nombrePieces);
        request.setAttribute("superficie", superficie);
        request.setAttribute("loyer", loyer);
        request.setAttribute("chargesMensuelles", charges);
        request.setAttribute("depotGarantie", depot);
        request.setAttribute("etage", etage);
        request.setAttribute("description", description);
        request.setAttribute("equipements", equipements);
    }

    /**
     * Vérifie si l'utilisateur connecté est propriétaire de l'immeuble.
     */
    private boolean isOwnerOfImmeuble(HttpServletRequest request, Immeuble immeuble) {
        Utilisateur currentUser = getCurrentUser(request);
        return currentUser != null && currentUser.getId().equals(immeuble.getProprietaire().getId());
    }

    /**
     * Récupère l'utilisateur actuellement connecté.
     */
    private Utilisateur getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null ? (Utilisateur) session.getAttribute("utilisateur") : null;
    }

    /**
     * Vérifie si l'utilisateur connecté est un propriétaire.
     */
    private boolean isProprietaireUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;

        Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
        return user != null && user.getRole() == Utilisateur.Role.PROPRIETAIRE && user.isActif();
    }
}