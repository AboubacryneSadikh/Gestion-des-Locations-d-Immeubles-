package com.example.geslocation.servlet;

import com.example.geslocation.model.ContratLocation;
import com.example.geslocation.model.Utilisateur;
import com.example.geslocation.service.UtilisateurService;
import com.example.geslocation.service.ImmeubleService;
import com.example.geslocation.service.ContratLocationService;
import com.example.geslocation.service.impl.UtilisateurServiceImpl;
import com.example.geslocation.service.impl.ImmeubleServiceImpl;
import com.example.geslocation.service.impl.ContratLocationServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Servlet pour gérer les fonctionnalités d'administration.
 */
@WebServlet(name = "adminServlet", urlPatterns = {"/admin/*"})
public class AdminServlet extends HttpServlet {

    private final UtilisateurService utilisateurService;
    private final ImmeubleService immeubleService;
    private final ContratLocationService contratLocationService;

    public AdminServlet() {
        this.utilisateurService = new UtilisateurServiceImpl();
        this.immeubleService = new ImmeubleServiceImpl();
        this.contratLocationService = new ContratLocationServiceImpl() {
            @Override
            public ContratLocation creer(ContratLocation contrat) {

                return contrat;
            }
        };
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Vérifier si l'utilisateur est connecté et est un administrateur
        if (!isAdminUser(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            pathInfo = "/dashboard";
        }

        switch (pathInfo) {
            case "/dashboard":
                showDashboard(request, response);
                break;
            case "/users":
                showUsers(request, response);
                break;
            case "/users/create":
                showCreateUser(request, response);
                break;
            case "/users/edit":
                showEditUser(request, response);
                break;
            case "/reports":
                showReports(request, response);
                break;
            case "/settings":
                showSettings(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAdminUser(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        switch (pathInfo) {
            case "/users/create":
                handleCreateUser(request, response);
                break;
            case "/users/edit":
                handleEditUser(request, response);
                break;
            case "/users/delete":
                handleDeleteUser(request, response);
                break;
            case "/users/toggle-status":
                handleToggleUserStatus(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                break;
        }
    }

    /**
     * Affiche le tableau de bord administrateur.
     */
    private void showDashboard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Statistiques générales
            List<Utilisateur> allUsers = utilisateurService.obtenirTous();
            Long totalProprietaires = allUsers.stream()
                    .filter(u -> u.getRole() == Utilisateur.Role.PROPRIETAIRE && u.isActif())
                    .count();
            Long totalLocataires = allUsers.stream()
                    .filter(u -> u.getRole() == Utilisateur.Role.LOCATAIRE && u.isActif())
                    .count();
            Long totalImmeubles = (long) immeubleService.obtenirTous().size();
            Long totalContrats = (long) contratLocationService.obtenirActifs().size();

            request.setAttribute("totalUsers", allUsers.size());
            request.setAttribute("totalProprietaires", totalProprietaires);
            request.setAttribute("totalLocataires", totalLocataires);
            request.setAttribute("totalImmeubles", totalImmeubles);
            request.setAttribute("totalContrats", totalContrats);

            // Utilisateurs récents
            List<Utilisateur> recentUsers = allUsers.stream()
                    .sorted((u1, u2) -> u2.getDateCreation().compareTo(u1.getDateCreation()))
                    .limit(5)
                    .toList();
            request.setAttribute("recentUsers", recentUsers);

            request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors du chargement du tableau de bord: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
        }
    }

    /**
     * Affiche la liste des utilisateurs.
     */
    private void showUsers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String roleFilter = request.getParameter("role");
            String statusFilter = request.getParameter("status");
            String searchQuery = request.getParameter("search");

            List<Utilisateur> users = utilisateurService.obtenirTous();

            // Filtrage par rôle
            if (roleFilter != null && !roleFilter.isEmpty() && !roleFilter.equals("ALL")) {
                Utilisateur.Role role = Utilisateur.Role.valueOf(roleFilter);
                users = users.stream()
                        .filter(u -> u.getRole() == role)
                        .toList();
            }

            // Filtrage par statut
            if (statusFilter != null && !statusFilter.isEmpty()) {
                boolean isActive = "ACTIVE".equals(statusFilter);
                users = users.stream()
                        .filter(u -> u.isActif() == isActive)
                        .toList();
            }

            // Recherche par nom/email
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                String query = searchQuery.toLowerCase().trim();
                users = users.stream()
                        .filter(u -> u.getNom().toLowerCase().contains(query) ||
                                u.getPrenom().toLowerCase().contains(query) ||
                                u.getEmail().toLowerCase().contains(query))
                        .toList();
            }

            request.setAttribute("users", users);
            request.setAttribute("roleFilter", roleFilter);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("searchQuery", searchQuery);

            request.getRequestDispatcher("/WEB-INF/views/admin/users/list.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors du chargement des utilisateurs: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/users/list.jsp").forward(request, response);
        }
    }

    /**
     * Affiche le formulaire de création d'utilisateur.
     */
    private void showCreateUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/admin/users/create.jsp").forward(request, response);
    }

    /**
     * Affiche le formulaire d'édition d'utilisateur.
     */
    private void showEditUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Long userId = Long.parseLong(request.getParameter("id"));
            var optUser = utilisateurService.obtenirParId(userId);

            if (optUser.isPresent()) {
                request.setAttribute("user", optUser.get());
                request.getRequestDispatcher("/WEB-INF/views/admin/users/edit.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Utilisateur non trouvé.");
                response.sendRedirect(request.getContextPath() + "/admin/users");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors du chargement de l'utilisateur: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }

    /**
     * Gère la création d'un nouvel utilisateur.
     */
    private void handleCreateUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String nom = request.getParameter("nom");
            String prenom = request.getParameter("prenom");
            String email = request.getParameter("email");
            String motDePasse = request.getParameter("motDePasse");
            String telephone = request.getParameter("telephone");
            String adresse = request.getParameter("adresse");
            String roleStr = request.getParameter("role");

            // Validation
            if (nom == null || nom.trim().isEmpty() ||
                    prenom == null || prenom.trim().isEmpty() ||
                    email == null || email.trim().isEmpty() ||
                    motDePasse == null || motDePasse.trim().isEmpty() ||
                    roleStr == null || roleStr.trim().isEmpty()) {

                request.setAttribute("error", "Veuillez remplir tous les champs obligatoires.");
                setCreateUserAttributes(request, nom, prenom, email, telephone, adresse, roleStr);
                request.getRequestDispatcher("/WEB-INF/views/admin/users/create.jsp").forward(request, response);
                return;
            }

            // Créer l'utilisateur
            Utilisateur utilisateur = new Utilisateur();
            utilisateur.setNom(nom.trim());
            utilisateur.setPrenom(prenom.trim());
            utilisateur.setEmail(email.trim().toLowerCase());
            utilisateur.setMotDePasse(motDePasse);
            utilisateur.setTelephone(telephone != null ? telephone.trim() : null);
            utilisateur.setAdresse(adresse != null ? adresse.trim() : null);
            utilisateur.setRole(Utilisateur.Role.valueOf(roleStr));
            utilisateur.setActif(true);

            utilisateurService.inscrire(utilisateur);

            request.setAttribute("success", "Utilisateur créé avec succès.");
            response.sendRedirect(request.getContextPath() + "/admin/users");

        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors de la création: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/users/create.jsp").forward(request, response);
        }
    }

    /**
     * Gère la modification d'un utilisateur.
     */
    private void handleEditUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Long userId = Long.parseLong(request.getParameter("id"));
            var optUser = utilisateurService.obtenirParId(userId);

            if (!optUser.isPresent()) {
                request.setAttribute("error", "Utilisateur non trouvé.");
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }

            Utilisateur utilisateur = optUser.get();

            String nom = request.getParameter("nom");
            String prenom = request.getParameter("prenom");
            String email = request.getParameter("email");
            String telephone = request.getParameter("telephone");
            String adresse = request.getParameter("adresse");
            String roleStr = request.getParameter("role");

            // Validation
            if (nom == null || nom.trim().isEmpty() ||
                    prenom == null || prenom.trim().isEmpty() ||
                    email == null || email.trim().isEmpty() ||
                    roleStr == null || roleStr.trim().isEmpty()) {

                request.setAttribute("error", "Veuillez remplir tous les champs obligatoires.");
                request.setAttribute("user", utilisateur);
                request.getRequestDispatcher("/WEB-INF/views/admin/users/edit.jsp").forward(request, response);
                return;
            }

            // Mettre à jour les informations
            utilisateur.setNom(nom.trim());
            utilisateur.setPrenom(prenom.trim());
            utilisateur.setEmail(email.trim().toLowerCase());
            utilisateur.setTelephone(telephone != null ? telephone.trim() : null);
            utilisateur.setAdresse(adresse != null ? adresse.trim() : null);
            utilisateur.setRole(Utilisateur.Role.valueOf(roleStr));

            utilisateurService.mettreAJour(utilisateur);

            request.setAttribute("success", "Utilisateur modifié avec succès.");
            response.sendRedirect(request.getContextPath() + "/admin/users");

        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors de la modification: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/users/edit.jsp").forward(request, response);
        }
    }

    /**
     * Gère la suppression d'un utilisateur.
     */
    private void handleDeleteUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            Long userId = Long.parseLong(request.getParameter("id"));

            // Empêcher la suppression de l'administrateur actuellement connecté
            HttpSession session = request.getSession();
            Utilisateur currentUser = (Utilisateur) session.getAttribute("utilisateur");

            if (currentUser.getId().equals(userId)) {
                request.getSession().setAttribute("error", "Vous ne pouvez pas supprimer votre propre compte.");
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }

            if (utilisateurService.desactiverCompte(userId)) {
                request.getSession().setAttribute("success", "Utilisateur supprimé avec succès.");
            } else {
                request.getSession().setAttribute("error", "Erreur lors de la suppression de l'utilisateur.");
            }

        } catch (Exception e) {
            request.getSession().setAttribute("error", "Erreur lors de la suppression: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    /**
     * Gère l'activation/désactivation d'un utilisateur.
     */
    private void handleToggleUserStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            Long userId = Long.parseLong(request.getParameter("id"));
            var optUser = utilisateurService.obtenirParId(userId);

            if (optUser.isPresent()) {
                Utilisateur utilisateur = optUser.get();

                // Empêcher la désactivation de l'administrateur actuellement connecté
                HttpSession session = request.getSession();
                Utilisateur currentUser = (Utilisateur) session.getAttribute("utilisateur");

                if (currentUser.getId().equals(userId) && utilisateur.isActif()) {
                    request.getSession().setAttribute("error", "Vous ne pouvez pas désactiver votre propre compte.");
                    response.sendRedirect(request.getContextPath() + "/admin/users");
                    return;
                }

                utilisateur.setActif(!utilisateur.isActif());
                utilisateurService.mettreAJour(utilisateur);

                String status = utilisateur.isActif() ? "activé" : "désactivé";
                request.getSession().setAttribute("success", "Utilisateur " + status + " avec succès.");
            } else {
                request.getSession().setAttribute("error", "Utilisateur non trouvé.");
            }

        } catch (Exception e) {
            request.getSession().setAttribute("error", "Erreur lors du changement de statut: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    /**
     * Affiche les rapports.
     */
    private void showReports(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // TODO: Implémenter les rapports
        request.getRequestDispatcher("/WEB-INF/views/admin/reports.jsp").forward(request, response);
    }

    /**
     * Affiche les paramètres.
     */
    private void showSettings(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // TODO: Implémenter les paramètres
        request.getRequestDispatcher("/WEB-INF/views/admin/settings.jsp").forward(request, response);
    }

    /**
     * Définit les attributs pour le formulaire de création d'utilisateur.
     */
    private void setCreateUserAttributes(HttpServletRequest request, String nom, String prenom,
                                         String email, String telephone, String adresse, String role) {
        request.setAttribute("nom", nom);
        request.setAttribute("prenom", prenom);
        request.setAttribute("email", email);
        request.setAttribute("telephone", telephone);
        request.setAttribute("adresse", adresse);
        request.setAttribute("role", role);
    }

    /**
     * Vérifie si l'utilisateur connecté est un administrateur.
     */
    private boolean isAdminUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;

        Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");
        return user != null && user.getRole() == Utilisateur.Role.ADMIN && user.isActif();
    }
}