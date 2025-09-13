package com.example.geslocation.servlet;

import com.example.geslocation.model.Utilisateur;
import com.example.geslocation.service.UtilisateurService;
import com.example.geslocation.service.impl.UtilisateurServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Date;
import java.util.Optional;

/**
 * Servlet pour gérer l'authentification des utilisateurs (connexion, inscription, déconnexion).
 */
@WebServlet(name = "authServlet", urlPatterns = {"/login", "/register", "/logout"})
public class AuthServlet extends HttpServlet {

    private final UtilisateurService utilisateurService;

    public AuthServlet() {
        this.utilisateurService = new UtilisateurServiceImpl();
    }

    /**
     * Gère les requêtes GET pour afficher les formulaires de connexion et d'inscription.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case "/login":
                // Vérifier si l'utilisateur est déjà connecté
                if (isUserLoggedIn(request)) {
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                    return;
                }
                request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
                break;

            case "/register":
                // Vérifier si l'utilisateur est déjà connecté
                if (isUserLoggedIn(request)) {
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                    return;
                }
                request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
                break;

            case "/logout":
                // Déconnecter l'utilisateur
                HttpSession session = request.getSession(false);
                if (session != null) {
                    session.invalidate();
                }
                response.sendRedirect(request.getContextPath() + "/login");
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/login");
                break;
        }
    }

    /**
     * Gère les requêtes POST pour traiter les formulaires de connexion et d'inscription.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case "/login":
                handleLogin(request, response);
                break;

            case "/register":
                handleRegister(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/login");
                break;
        }
    }

    /**
     * Gère la connexion d'un utilisateur.
     */
    private void handleLogin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        // CORRECTION: Utiliser "password" au lieu de "motDePasse" pour correspondre à la JSP
        String motDePasse = request.getParameter("password");

        // Debug: Afficher les paramètres reçus (à retirer en production)
        System.out.println("Debug - Email reçu: " + email);
        System.out.println("Debug - Mot de passe reçu: " + (motDePasse != null ? "***" : "null"));

        // Valider les entrées
        if (email == null || email.trim().isEmpty() || motDePasse == null || motDePasse.trim().isEmpty()) {
            request.setAttribute("error", "Veuillez remplir tous les champs.");
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            return;
        }

        // Nettoyer les données
        email = email.trim().toLowerCase();

        // Authentifier l'utilisateur
        try {
            Optional<Utilisateur> optUtilisateur = utilisateurService.authentifier(email, motDePasse);

            if (optUtilisateur.isPresent()) {
                Utilisateur utilisateur = optUtilisateur.get();

                // Vérifier si le compte est actif
                if (!utilisateur.isActif()) {
                    request.setAttribute("error", "Votre compte a été désactivé. Contactez l'administrateur.");
                    request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
                    return;
                }

                // Créer une session pour l'utilisateur
                HttpSession session = request.getSession();
                session.setAttribute("utilisateur", utilisateur);
                session.setAttribute("role", utilisateur.getRole().toString());
                session.setAttribute("userId", utilisateur.getId());
                session.setAttribute("userName", utilisateur.getPrenom() + " " + utilisateur.getNom());

                // Debug
                System.out.println("Debug - Utilisateur connecté: " + utilisateur.getEmail() + " - Rôle: " + utilisateur.getRole());

                // Rediriger vers le tableau de bord approprié selon le rôle
                String redirectUrl;
                switch (utilisateur.getRole()) {
                    case ADMIN:
                        redirectUrl = request.getContextPath() + "/admin/dashboard";
                        break;
                    case PROPRIETAIRE:
                        redirectUrl = request.getContextPath() + "/proprietaire/dashboard";
                        break;
                    case LOCATAIRE:
                        redirectUrl = request.getContextPath() + "/locataire/dashboard";
                        break;
                    default:
                        redirectUrl = request.getContextPath() + "/dashboard";
                        break;
                }

                response.sendRedirect(redirectUrl);

            } else {
                System.out.println("Debug - Authentification échouée pour: " + email);
                request.setAttribute("error", "Email ou mot de passe incorrect.");
                request.setAttribute("email", email); // Conserver l'email saisi
                request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            System.err.println("Erreur lors de la connexion: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Une erreur technique est survenue. Veuillez réessayer.");
            request.setAttribute("email", email); // Conserver l'email saisi
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
        }
    }

    /**
     * Gère l'inscription d'un nouvel utilisateur.
     */
    private void handleRegister(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String motDePasse = request.getParameter("password");
        String confirmMotDePasse = request.getParameter("confirmPassword");
        String telephone = request.getParameter("telephone");
        String roleStr = request.getParameter("role");

        // Debug
        System.out.println("Debug - Inscription - Email: " + email + ", Rôle: " + roleStr);

        // Valider les entrées
        if (nom == null || nom.trim().isEmpty() || prenom == null || prenom.trim().isEmpty() ||
                email == null || email.trim().isEmpty() || motDePasse == null || motDePasse.trim().isEmpty() ||
                confirmMotDePasse == null || confirmMotDePasse.trim().isEmpty() ||
                roleStr == null || roleStr.trim().isEmpty()) {

            request.setAttribute("error", "Veuillez remplir tous les champs obligatoires.");
            // Conserver les données saisies
            setRegisterAttributes(request, nom, prenom, email, telephone, roleStr);
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        // Nettoyer les données
        nom = nom.trim();
        prenom = prenom.trim();
        email = email.trim().toLowerCase();
        if (telephone != null) {
            telephone = telephone.trim();
        }

        // Vérifier que les mots de passe correspondent
        if (!motDePasse.equals(confirmMotDePasse)) {
            request.setAttribute("error", "Les mots de passe ne correspondent pas.");
            setRegisterAttributes(request, nom, prenom, email, telephone, roleStr);
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        // Valider la force du mot de passe
        if (motDePasse.length() < 6) {
            request.setAttribute("error", "Le mot de passe doit contenir au moins 6 caractères.");
            setRegisterAttributes(request, nom, prenom, email, telephone, roleStr);
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        // Déterminer le rôle
        Utilisateur.Role role;
        try {
            role = Utilisateur.Role.valueOf(roleStr);
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Rôle invalide sélectionné.");
            setRegisterAttributes(request, nom, prenom, email, telephone, roleStr);
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        // Créer l'utilisateur
        Utilisateur utilisateur = new Utilisateur();
        utilisateur.setNom(nom);
        utilisateur.setPrenom(prenom);
        utilisateur.setEmail(email);
        utilisateur.setMotDePasse(motDePasse);
        utilisateur.setTelephone(telephone);
        utilisateur.setRole(role);
        utilisateur.setDateCreation(new Date());
        utilisateur.setActif(true);

        try {
            utilisateur = utilisateurService.inscrire(utilisateur);

            System.out.println("Debug - Utilisateur créé avec succès: " + utilisateur.getEmail());

            // Rediriger vers la page de connexion avec un message de succès
            request.setAttribute("success", "Inscription réussie ! Vous pouvez maintenant vous connecter.");
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Erreur lors de l'inscription: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors de l'inscription: " + e.getMessage());
            setRegisterAttributes(request, nom, prenom, email, telephone, roleStr);
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
        }
    }

    /**
     * Méthode utilitaire pour conserver les données du formulaire d'inscription
     */
    private void setRegisterAttributes(HttpServletRequest request, String nom, String prenom,
                                       String email, String telephone, String role) {
        request.setAttribute("nom", nom);
        request.setAttribute("prenom", prenom);
        request.setAttribute("email", email);
        request.setAttribute("telephone", telephone);
        request.setAttribute("role", role);
    }

    /**
     * Vérifie si un utilisateur est connecté.
     * @param request La requête HTTP
     * @return true si l'utilisateur est connecté, false sinon
     */
    private boolean isUserLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute("utilisateur") != null;
    }
}