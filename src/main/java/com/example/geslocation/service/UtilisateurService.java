package com.example.geslocation.service;

import com.example.geslocation.model.Utilisateur;
import java.util.List;
import java.util.Optional;

/**
 * Interface de service pour les opérations liées aux utilisateurs.
 */
public interface UtilisateurService {
    
    /**
     * Inscrit un nouvel utilisateur.
     * @param utilisateur L'utilisateur à inscrire
     * @return L'utilisateur inscrit avec son ID généré
     * @throws Exception Si l'inscription échoue (ex: email déjà utilisé)
     */
    Utilisateur inscrire(Utilisateur utilisateur) throws Exception;
    
    /**
     * Authentifie un utilisateur avec son email et mot de passe.
     * @param email L'email de l'utilisateur
     * @param motDePasse Le mot de passe de l'utilisateur
     * @return Un Optional contenant l'utilisateur si l'authentification réussit, sinon un Optional vide
     */
    Optional<Utilisateur> authentifier(String email, String motDePasse);
    
    /**
     * Récupère un utilisateur par son ID.
     * @param id L'ID de l'utilisateur
     * @return Un Optional contenant l'utilisateur si trouvé, sinon un Optional vide
     */
    Optional<Utilisateur> obtenirParId(Long id);
    
    /**
     * Récupère un utilisateur par son email.
     * @param email L'email de l'utilisateur
     * @return Un Optional contenant l'utilisateur si trouvé, sinon un Optional vide
     */
    Optional<Utilisateur> obtenirParEmail(String email);
    
    /**
     * Met à jour les informations d'un utilisateur.
     * @param utilisateur L'utilisateur avec les informations mises à jour
     * @return L'utilisateur mis à jour
     * @throws Exception Si la mise à jour échoue
     */
    Utilisateur mettreAJour(Utilisateur utilisateur) throws Exception;
    
    /**
     * Change le mot de passe d'un utilisateur.
     * @param id L'ID de l'utilisateur
     * @param ancienMotDePasse L'ancien mot de passe
     * @param nouveauMotDePasse Le nouveau mot de passe
     * @return true si le changement a réussi, false sinon
     */
    boolean changerMotDePasse(Long id, String ancienMotDePasse, String nouveauMotDePasse);
    
    /**
     * Désactive un compte utilisateur.
     * @param id L'ID de l'utilisateur
     * @return true si la désactivation a réussi, false sinon
     */
    boolean desactiverCompte(Long id);
    
    /**
     * Récupère tous les utilisateurs.
     * @return Une liste de tous les utilisateurs
     */
    List<Utilisateur> obtenirTous();
    
    /**
     * Récupère tous les utilisateurs par rôle.
     * @param role Le rôle des utilisateurs à récupérer
     * @return Une liste des utilisateurs ayant le rôle spécifié
     */
    List<Utilisateur> obtenirParRole(Utilisateur.Role role);
}