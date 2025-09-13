package com.example.geslocation.service.impl;

import com.example.geslocation.dao.UtilisateurDAO;
import com.example.geslocation.dao.impl.UtilisateurDAOImpl;
import com.example.geslocation.model.Utilisateur;
import com.example.geslocation.service.UtilisateurService;

import java.util.Date;
import java.util.List;
import java.util.Optional;

/**
 * Implémentation du service pour les opérations liées aux utilisateurs.
 */
public class UtilisateurServiceImpl implements UtilisateurService {

    private final UtilisateurDAO utilisateurDAO;

    /**
     * Constructeur par défaut qui initialise le DAO.
     */
    public UtilisateurServiceImpl() {
        this.utilisateurDAO = new UtilisateurDAOImpl();
    }

    /**
     * Constructeur avec injection de dépendance pour les tests.
     * @param utilisateurDAO Le DAO à utiliser
     */
    public UtilisateurServiceImpl(UtilisateurDAO utilisateurDAO) {
        this.utilisateurDAO = utilisateurDAO;
    }

    @Override
    public Utilisateur inscrire(Utilisateur utilisateur) throws Exception {
        // Vérifier si l'email est déjà utilisé
        Optional<Utilisateur> existingUser = utilisateurDAO.findByEmail(utilisateur.getEmail());
        if (existingUser.isPresent()) {
            throw new Exception("Un utilisateur avec cet email existe déjà.");
        }

        // Définir la date de création
        utilisateur.setDateCreation(new Date());

        // Hasher le mot de passe (dans une application réelle)
        // utilisateur.setMotDePasse(hashPassword(utilisateur.getMotDePasse()));

        // Persister l'utilisateur
        return utilisateurDAO.create(utilisateur);
    }

    @Override
    public Optional<Utilisateur> authentifier(String email, String motDePasse) {
        // Dans une application réelle, on hasherait le mot de passe avant de le comparer
        Optional<Utilisateur> utilisateur = utilisateurDAO.authenticate(email, motDePasse);

        // Mettre à jour la dernière connexion si l'authentification réussit
        utilisateur.ifPresent(u -> utilisateurDAO.updateLastLogin(u.getId()));

        return utilisateur;
    }

    @Override
    public Optional<Utilisateur> obtenirParId(Long id) {
        return utilisateurDAO.findById(id);
    }

    @Override
    public Optional<Utilisateur> obtenirParEmail(String email) {
        return utilisateurDAO.findByEmail(email);
    }

    @Override
    public Utilisateur mettreAJour(Utilisateur utilisateur) throws Exception {
        // Vérifier si l'utilisateur existe
        Optional<Utilisateur> existingUser = utilisateurDAO.findById(utilisateur.getId());
        if (!existingUser.isPresent()) {
            throw new Exception("Utilisateur non trouvé.");
        }

        // Vérifier si l'email est déjà utilisé par un autre utilisateur
        Optional<Utilisateur> userWithEmail = utilisateurDAO.findByEmail(utilisateur.getEmail());
        if (userWithEmail.isPresent() && !userWithEmail.get().getId().equals(utilisateur.getId())) {
            throw new Exception("Un autre utilisateur utilise déjà cet email.");
        }

        // Conserver le mot de passe existant si non modifié
        if (utilisateur.getMotDePasse() == null || utilisateur.getMotDePasse().isEmpty()) {
            utilisateur.setMotDePasse(existingUser.get().getMotDePasse());
        } else {
            // Hasher le nouveau mot de passe (dans une application réelle)
            // utilisateur.setMotDePasse(hashPassword(utilisateur.getMotDePasse()));
        }

        // Mettre à jour l'utilisateur
        return utilisateurDAO.update(utilisateur);
    }

    @Override
    public boolean changerMotDePasse(Long id, String ancienMotDePasse, String nouveauMotDePasse) {
        // Récupérer l'utilisateur
        Optional<Utilisateur> optUtilisateur = utilisateurDAO.findById(id);
        if (!optUtilisateur.isPresent()) {
            return false;
        }

        Utilisateur utilisateur = optUtilisateur.get();

        // Vérifier l'ancien mot de passe
        // Dans une application réelle, on comparerait les hash
        if (!utilisateur.getMotDePasse().equals(ancienMotDePasse)) {
            return false;
        }

        // Mettre à jour le mot de passe
        // Dans une application réelle, on hasherait le nouveau mot de passe
        utilisateur.setMotDePasse(nouveauMotDePasse);

        try {
            utilisateurDAO.update(utilisateur);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    @Override
    public boolean desactiverCompte(Long id) {
        // Récupérer l'utilisateur
        Optional<Utilisateur> optUtilisateur = utilisateurDAO.findById(id);
        if (!optUtilisateur.isPresent()) {
            return false;
        }

        Utilisateur utilisateur = optUtilisateur.get();

        // Désactiver le compte
        utilisateur.setActif(false);

        try {
            utilisateurDAO.update(utilisateur);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    @Override
    public List<Utilisateur> obtenirTous() {
        return utilisateurDAO.findAll();
    }

    @Override
    public List<Utilisateur> obtenirParRole(Utilisateur.Role role) {
        return utilisateurDAO.findByRole(role);
    }

    // Méthode privée pour hasher un mot de passe (à implémenter dans une application réelle)
    /*
    private String hashPassword(String password) {
        // Utiliser un algorithme de hachage sécurisé comme BCrypt
        return BCrypt.hashpw(password, BCrypt.gensalt());
    }
    */
}